local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")
local UserService = game:GetService("UserService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Config = require(ReplicatedStorage.Modules.GlobalLeaderboardConfig)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

type BoardType = Config.BoardType
type RankRow = Config.RankRow

local GlobalLeaderboardService = Knit.CreateService {
	Name = "GlobalLeaderboardService",
	Client = {
		RankingsChanged = Knit.CreateSignal(),
		UpdateMyBestData = Knit.CreateSignal(),
		UpdatePlayersInLeaderboard = Knit.CreateSignal(),
	},
	_Stores = {},
	_PublishedScores = {},
	_Rankings = { Revision = 0, Boards = {} },
	_DanceAnimTracks = {},
	_Dancers = setmetatable({}, {__mode = "k"}),
}

local function createMemoryStore()
	local scores = {}
	return {
		UpdateAsync = function(_, key, transform)
			local value = transform(scores[key])
			if value ~= nil then
				scores[key] = value
			end
			return value
		end,
		GetSortedAsync = function(_, _ascending, size, minimum)
			local entries = {}
			for key, value in pairs(scores) do
				if value >= minimum then
					table.insert(entries, { key = key, value = value })
				end
			end
			table.sort(entries, function(left, right)
				if left.value ~= right.value then
					return left.value > right.value
				end
				return left.key < right.key
			end)
			return {
				GetCurrentPage = function()
					return table.move(entries, 1, math.min(size, #entries), 1, {})
				end,
			}
		end,
		RemoveAsync = function(_, key)
			scores[key] = nil
		end,
	}
end

local function getScores(data): { [BoardType]: number }
	local scores = {}
	for _, boardType in Config.Types do
		scores[boardType] = Config.NormalizeScore(data and data[Config.Boards[boardType].Field])
	end
	return scores
end

local function publishAssets()
	local source = Workspace:FindFirstChild("Leaderboards")
	local serverGui = ServerStorage:FindFirstChild("Gui")
	local gui = serverGui and serverGui:FindFirstChild("LeaderboardGui")
	if not source or not gui or not gui:IsA("SurfaceGui") then
		warn("GlobalLeaderboard: leaderboard models or GUI template are missing")
		return
	end

	local models = {}
	for _, boardType in Config.Types do
		local model = source:FindFirstChild(boardType .. "Leaderboard")
		local base = model and model:FindFirstChild("Box002")
		if not model or not model:IsA("Model") or not model.PrimaryPart or not base or not base:IsA("BasePart") then
			warn("GlobalLeaderboard: invalid model template for " .. boardType)
			return
		end
		table.insert(models, model)
	end

	local assets = Instance.new("Folder")
	assets.Name = Config.AssetsName
	local guiTemplate = gui:Clone()
	guiTemplate.Adornee = nil
	guiTemplate.Enabled = false
	guiTemplate.Parent = assets
	for _, model in models do
		model.Parent = assets
	end
	assets.Parent = ReplicatedStorage
end

function GlobalLeaderboardService:GetMyBestData(player: Player, boardType: BoardType): number
	local definition = Config.Boards[boardType]
	if not definition then
		return 0
	end
	local profile = PlayerDataService:GetProfile(player)
	local published = self._PublishedScores[player]
	return math.max(
		Config.NormalizeScore(profile and profile.Data[definition.Field]),
		published and published[boardType] or 0
	)
end

function GlobalLeaderboardService.Client:GetMyBestData(player: Player, boardType: BoardType): number
	return GlobalLeaderboardService:GetMyBestData(player, boardType)
end

function GlobalLeaderboardService.Client:GetSnapshot(player: Player)
	local best = {}
	for _, boardType in Config.Types do
		best[boardType] = GlobalLeaderboardService:GetMyBestData(player, boardType)
	end
	return {
		Rankings = GlobalLeaderboardService._Rankings,
		PersonalBest = best,
	}
end

function GlobalLeaderboardService:PublishScores(player: Player, scores, published)
	if PlayerDataService:IsStudioOnboardingTest() then
		return
	end
	local key = tostring(player.UserId)
	if not PlayerDataService:IsUsingMockProfiles() then
		local blacklist = Knit.GetService("GameOperationService"):GetBlackList()
		if blacklist and blacklist[key] then
			return
		end
	end

	for _, boardType in Config.Types do
		local score = scores[boardType]
		if score <= (published[boardType] or 0) then
			continue
		end
		local confirmed = score
		local ok, result = pcall(function()
			return self._Stores[boardType]:UpdateAsync(key, function(previous)
				local previousScore = Config.NormalizeScore(previous)
				confirmed = math.max(previousScore, score)
				if previousScore >= score then
					return nil
				end
				return score
			end)
		end)
		if ok then
			published[boardType] = math.max(published[boardType] or 0, confirmed)
		else
			warn("GlobalLeaderboard: could not publish " .. boardType, result)
		end
	end
end

function GlobalLeaderboardService:SyncPlayerLeaderboardData(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return
	end

	local published = self._PublishedScores[player] or {}
	self._PublishedScores[player] = published
	local scores = getScores(profile.Data)
	for _, boardType in Config.Types do
		self.Client.UpdateMyBestData:Fire(player, boardType, math.max(scores[boardType], published[boardType] or 0))
	end
	self:PublishScores(player, scores, published)
	if Players:GetPlayerByUserId(player.UserId) == player then
		for _, boardType in Config.Types do
			if (published[boardType] or 0) > scores[boardType] then
				self.Client.UpdateMyBestData:Fire(player, boardType, published[boardType])
			end
		end
	end
end

local function buildRows(entries): { RankRow }
	local names, userIds, seen = {}, {}, {}
	for _, entry in ipairs(entries) do
		local userId = tonumber(entry.key)
		if userId and not seen[userId] then
			seen[userId] = true
			local player = Players:GetPlayerByUserId(userId)
			if player then
				names[userId] = player.DisplayName
			elseif userId > 0 then
				table.insert(userIds, userId)
			end
		end
	end
	if #userIds > 0 then
		local ok, result = pcall(UserService.GetUserInfosByUserIdsAsync, UserService, userIds)
		if ok then
			for _, user in ipairs(result) do
				names[user.Id] = user.DisplayName
			end
		else
			warn("GlobalLeaderboard: could not resolve display names", result)
		end
	end

	local rows = {}
	for rank, entry in ipairs(entries) do
		local userId = tonumber(entry.key)
		if userId then
			table.insert(rows, {
				Rank = rank,
				UserId = userId,
				DisplayName = names[userId] or tostring(userId),
				Value = entry.value
			})
		end
	end
	return rows
end

local function sameRows(previous, rows)
	if not previous or #previous ~= #rows then
		return false
	end
	for index, row in rows do
		local old = previous[index]
		if old.UserId ~= row.UserId or old.Value ~= row.Value
			or old.DisplayName ~= row.DisplayName or old.Rank ~= row.Rank then
			return false
		end
	end
	return true
end

function GlobalLeaderboardService:UpdateLeaderboards()
	local boards = table.clone(self._Rankings.Boards)
	local changed = false
	for _, boardType in Config.Types do
		local ok, entries = pcall(function()
			return self._Stores[boardType]:GetSortedAsync(false, Config.MaxRows, 1):GetCurrentPage()
		end)
		if ok then
			local rows = buildRows(entries)
			if not sameRows(boards[boardType], rows) then
				boards[boardType] = rows
				changed = true
			end
			self:UpdateDancingPlayers(boardType, boards[boardType])
		else
			warn("GlobalLeaderboard: could not refresh " .. boardType, entries)
		end
	end
	if changed then
		self._Rankings = { Revision = self._Rankings.Revision + 1, Boards = boards }
		self.Client.RankingsChanged:FireAll(self._Rankings)
		self:UpdatePlayersInLeaderboard()
	end
end

function GlobalLeaderboardService:UpdatePlayersInLeaderboard()
	local playersInLeaderboard = {}
	for _, boardType in Config.Types do
		for _, row in ipairs(self._Rankings.Boards[boardType] or {}) do
			local key = tostring(row.UserId)
			local ranks = playersInLeaderboard[key]
			if not ranks then
				ranks = {}
				playersInLeaderboard[key] = ranks
			end
			ranks[boardType] = row.Rank
		end
	end
	local onlineRanks = {}
	for _, player in Players:GetPlayers() do
		local key = tostring(player.UserId)
		onlineRanks[key] = playersInLeaderboard[key] or {}
	end
	self.Client.UpdatePlayersInLeaderboard:FireAll(onlineRanks)
end

function GlobalLeaderboardService:UpdateDancingPlayers(boardType: BoardType, rows: { RankRow })
	local leaderboards = Workspace:FindFirstChild("Leaderboards")
	local dancers = leaderboards and leaderboards:FindFirstChild("DancingPlayers")
	local holders = dancers and dancers:FindFirstChild(boardType)
	if not holders then return end

	for _, row in ipairs(rows) do
		local holder = holders:FindFirstChild(tostring(row.Rank))
		if holder and holder:IsA("Model") then
			local state = self._Dancers[holder]
			if not state then
				state = {}
				self._Dancers[holder] = state
			end
			if state.row ~= row then
				state.row = row
				local frame = holder.Part.BillboardGui.Frame
				frame.PlayerName.Text = "#" .. row.Rank .. " " .. row.DisplayName
				frame.WinsAmount.Text = Config.Boards[boardType].Label .. ": " .. Config.FormatValue(boardType, row.Value)
			end
			if state.appliedUserId ~= row.UserId and not state.running then
				state.running = true
				task.spawn(function()
					while holder.Parent and state.appliedUserId ~= state.row.UserId do
						local userId = state.row.UserId
						local ok, applied = pcall(self.PlayerDance, self, holder, userId, state)
						if ok and applied then
							state.appliedUserId = userId
						elseif state.row.UserId == userId then
							if not ok then
								warn("GlobalLeaderboard: could not apply dancer", applied)
							end
							break
						end
					end
					state.running = false
				end)
			end
		end
	end
end

function GlobalLeaderboardService:PlayerDance(holder: Model, userId: number, state): boolean
	local success, description = pcall(Players.GetHumanoidDescriptionFromUserId, Players, userId)
	if not success or not holder.Parent or state.row.UserId ~= userId then
		return false
	end

	local avatar = holder:FindFirstChild("Avatar")
	if not avatar then
		warn("GlobalLeaderboard: dancer has no avatar")
		return false
	end

	local scale = avatar:GetScale()
	description.HeadScale *= scale
	description.DepthScale *= scale
	description.HeightScale *= scale
	description.WidthScale *= scale
	local humanoid = avatar.Humanoid
	humanoid:ApplyDescription(description)
	for _, child in avatar:GetDescendants() do
		if child:IsA("BasePart") then
			child.CastShadow = false
			if child.Parent == avatar then
				child.Anchored = child.Name == "HumanoidRootPart"
			end
		end
	end

	if #humanoid:GetPlayingAnimationTracks() == 0 then
		local track = self._DanceAnimTracks[holder]
		if not track then
			local animator = humanoid:WaitForChild("Animator")
			track = animator:LoadAnimation(avatar.Animation)
			self._DanceAnimTracks[holder] = track
		end
		track:Play()
	end

	return true
end

function GlobalLeaderboardService:RemoveLeaderboard(playerId: number)
	local key = tostring(playerId)
	for _, store in pairs(self._Stores) do
		store:RemoveAsync(key)
	end
end

function GlobalLeaderboardService:KnitStart()
	local useMemory = PlayerDataService:IsUsingMockProfiles()
	for _, boardType in Config.Types do
		self._Stores[boardType] = if useMemory
			then createMemoryStore()
			else DataStoreService:GetOrderedDataStore(Config.Boards[boardType].Store)
	end

	publishAssets()
	PlayerDataService.ProfileLoaded:Connect(function(player: Player)
		task.spawn(function()
			self:SyncPlayerLeaderboardData(player)
		end)
		self:UpdatePlayersInLeaderboard()
	end)
	PlayerDataService:RegisterBeforeProfileRelease(function(player, data)
		local published = self._PublishedScores[player]
		self._PublishedScores[player] = nil
		if published then
			local scores = getScores(data)
			task.defer(function()
				self:PublishScores(player, scores, published)
			end)
		end
	end)

	task.spawn(function()
		while true do
			for _, player in Players:GetPlayers() do
				self:SyncPlayerLeaderboardData(player)
			end
			self:UpdateLeaderboards()
			task.wait(Constants.LEADERBOARD_UPDATE_INTERVAL)
		end
	end)
end

return GlobalLeaderboardService
