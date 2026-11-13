local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)
local PlotFishMotion = require(ReplicatedStorage.Modules.PlotFishMotion)
local PlotPlacementUtil = require(ReplicatedStorage.Modules.PlotPlacementUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local PlotFishService = Knit.CreateService({
	Name = "PlotFishService",
	Client = { EquippedFishChanged = Knit.CreateSignal() },
})

local production = {}
local rosterRevisions = {}
local activeFish = {}
local random = Random.new()

local function reject(message: string)
	return { ok = false, message = message }
end

local function getHeldItemTool(player: Player, instanceId: string): Tool?
	local character = player.Character
	if not character then
		return nil
	end
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and ItemToolUtil.GetInstanceId(child) == instanceId then
			return child
		end
	end
	return nil
end

local DEFAULT_CONDITION_ID = "Codition_1"

local function readItemRecord(record, repair: boolean?): (any?, any?)
	if typeof(record) ~= "table" or typeof(record.ItemId) ~= "string" then
		return nil, nil
	end
	local item = FishInventoryData[record.ItemId]
	if not item then
		return nil, nil
	end
	local weight = tonumber(record.Weight)
	local conditionId = record.ConditionId
	local condition = typeof(conditionId) == "string" and ConditionsData[conditionId] or nil
	if not condition then
		conditionId = DEFAULT_CONDITION_ID
		condition = ConditionsData[conditionId]
	end
	if not weight or weight ~= weight or weight == math.huge or weight <= 0 or not condition then
		return nil, nil
	end
	local mutationId = MutationDataUtil.NormalizeMutationId(record.MutationId)
	local price = ItemStatUtil.CalculatePrice(item, weight, condition.ValueMult, MutationDataUtil.GetPriceRate(mutationId))
	if repair then
		record.Weight = weight
		record.ConditionId = conditionId
		record.Price = price
		record.MutationId = mutationId
	end
	return item, { Weight = weight, ConditionId = conditionId, Price = price, MutationId = mutationId }
end

local function getRoot(player: Player): BasePart?
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	return if humanoid and humanoid.Health > 0 and root and root:IsA("BasePart") then root else nil
end

local function getOwnedPlot(player: Player): Instance?
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	return if plot and plot:GetAttribute("OwnerUserId") == player.UserId then plot else nil
end

local function getFishFolder(plot: Instance, player: Player): Folder
	local existing = plot:FindFirstChild(PlotFishMotion.FOLDER_NAME)
	if existing then
		if existing:IsA("Folder") and existing:GetAttribute("OwnerUserId") == player.UserId then
			return existing
		end
		existing:Destroy()
	end
	local folder = Instance.new("Folder")
	folder.Name = PlotFishMotion.FOLDER_NAME
	folder:SetAttribute("OwnerUserId", player.UserId)
	folder.Parent = plot
	return folder
end

local function createFish(uid, item, data, slot, boundary, entry, now, footprint)
	local fish = Instance.new("Configuration")
	fish.Name = uid
	fish:SetAttribute("ItemId", item.ItemID)
	fish:SetAttribute("Weight", data.Weight)
	fish:SetAttribute("ConditionId", data.ConditionId)
	fish:SetAttribute("MutationId", data.MutationId)
	fish:SetAttribute("Slot", slot)
	fish:SetAttribute("StartedAt", now)
	local move = PlotFishMotion.Start(boundary, entry, now, random, nil, footprint)
	fish:SetAttribute(PlotFishMotion.MOVE_ATTRIBUTE, PlotFishMotion.Encode(move))
	activeFish[fish] = { boundary = boundary, move = move, footprint = footprint }
	return fish
end

function PlotFishService:_stepMotion(now: number)
	for fish, state in pairs(activeFish) do
		if not fish.Parent or not state.boundary.Parent then
			activeFish[fish] = nil
			continue
		end
		local nextMove = PlotFishMotion.Advance(state.boundary, state.move, now, random, state.footprint)
		if nextMove then
			state.move = nextMove
			fish:SetAttribute(PlotFishMotion.MOVE_ATTRIBUTE, PlotFishMotion.Encode(nextMove))
		end
	end
end

local function defaultEntry(slot: number): Vector3
	local angle = slot * 2.399963
	return Vector3.new(math.cos(angle) * 9, 0, math.sin(angle) * 9)
end

local function getIncome(item, data, bestBaseCps: number): number
	return PlotFishIncome.GetCpsPrice(item, MutationDataUtil.GetEarnCashRate(data.MutationId), bestBaseCps, data.Weight)
end

local function getEquippedFish(player: Player, data)
	local fish = {}
	local bestBaseCps = PlotFishIncome.GetBestOwnedBaseCps(data)
	local seen = {}
	for slot = 1, PlotPlacementUtil.CAPACITY do
		local uid = PlotPlacementUtil.GetItemUid(data.PlotPlacements, slot)
		if uid and not seen[uid] then
			local item, record = readItemRecord(data.Items[uid])
			if item and record then
				seen[uid] = true
				table.insert(fish, {
					uid = uid,
					itemId = item.ItemID,
					weight = record.Weight,
					mutationId = record.MutationId,
					income = getIncome(item, record, bestBaseCps),
				})
			end
		end
	end
	table.sort(fish, function(a, b)
		return if a.income == b.income then a.uid < b.uid else a.income > b.income
	end)
	return { revision = rosterRevisions[player] or 0, fish = fish }
end

local function settle(player: Player, data, now: number)
	local state = production[player]
	if not state then
		state = { at = now, rate = PlotFishIncome.GetRate(data), credit = 0 }
		production[player] = state
	end
	local elapsed = now - state.at
	if elapsed > 0 or state.credit >= 1 then
		local credit = state.credit + state.rate * elapsed
		local payout = math.floor(credit)
		if payout > 0 and not PlayerDataService:AdjustWins(player, payout, false) then
			-- Preserve unpaid credit before switching an inventory-dependent rate.
			state.at = now
			state.credit = credit
			return nil
		end
		state.at = now
		state.credit = credit - payout
		data.LastOnlineTime = os.time()
	end
	return state
end

local function rosterChanged(player: Player, data, state)
	state.rate = PlotFishIncome.GetRate(data)
	player:SetAttribute(PlotFishIncome.BEST_CPS_ATTRIBUTE, PlotFishIncome.GetBestOwnedBaseCps(data))
	Knit.GetService("PlayerLuckService"):RefreshPlayerLuck(player)
	rosterRevisions[player] = (rosterRevisions[player] or 0) + 1
	PlotFishService.Client.EquippedFishChanged:Fire(player, getEquippedFish(player, data))
end

-- Call once after an inventory transaction commits (or finishes rolling back).
function PlotFishService:RefreshInventoryIncome(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return
	end
	local state = settle(player, profile.Data, Workspace:GetServerTimeNow()) or production[player]
	rosterChanged(player, profile.Data, state)
end

function PlotFishService:_restore(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	local plot = getOwnedPlot(player)
	local boundary = plot and PlotFishMotion.GetBoundary(plot)
	if not profile or not plot or not boundary then
		return
	end
	local folder = getFishFolder(plot, player)
	local placements = profile.Data.PlotPlacements
	local now = Workspace:GetServerTimeNow()
	for slot = 1, PlotFishMotion.CAPACITY do
		local uid = PlotPlacementUtil.GetItemUid(placements, slot)
		if uid and not folder:FindFirstChild(uid) then
			local item, data = readItemRecord(profile.Data.Items[uid], true)
			local geometry = item and data and PlotFishMotion.GetGeometry(item, data.Weight, boundary)
			if geometry then
				createFish(uid, item, data, slot, boundary, defaultEntry(slot), now, geometry.footprint).Parent = folder
			end
		end
	end
end

function PlotFishService:RequestPlace(player: Player, uid: unknown)
	if typeof(uid) ~= "string" or uid == "" then
		return reject("Invalid fish.")
	end
	local plot = getOwnedPlot(player)
	local boundary = plot and PlotFishMotion.GetBoundary(plot)
	local root = getRoot(player)
	local entry = boundary and root and PlotFishMotion.GetEntry(boundary, root)
	if not plot or not boundary or not entry then
		return reject("Stand inside your own plot to place a fish.")
	end
	local heldTool = getHeldItemTool(player, uid)
	if not heldTool then
		return reject("Hold a fish to place it.")
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return reject("Fish data is unavailable.")
	end
	local placements = profile.Data.PlotPlacements
	if PlotPlacementUtil.IsPlaced(placements, uid) then
		return reject("This fish is already in your plot.")
	end
	local emptySlot
	for slot = 1, PlotFishMotion.CAPACITY do
		if not PlotPlacementUtil.GetItemUid(placements, slot) then
			emptySlot = slot
			break
		end
	end
	if not emptySlot then
		return reject(string.format("Your plot is full (%d/%d).", PlotFishMotion.CAPACITY, PlotFishMotion.CAPACITY))
	end
	local item, data = readItemRecord(profile.Data.Items[uid])
	local geometry = item and data and PlotFishMotion.GetGeometry(item, data.Weight, boundary)
	if not geometry then
		return reject("Fish data is unavailable.")
	end

	local now = Workspace:GetServerTimeNow()
	local state = settle(player, profile.Data, now)
	if not state then
		return reject("Cash data is unavailable.")
	end
	local position = PlotFishMotion.GetSurfacePoint(boundary, entry, geometry.footprint)
	local previousRate = state.rate
	PlotPlacementUtil.SetItemUid(placements, emptySlot, uid)
	createFish(uid, item, data, emptySlot, boundary, entry, now, geometry.footprint).Parent = getFishFolder(plot, player)
	heldTool:Destroy()
	rosterChanged(player, profile.Data, state)
	return { ok = true, position = position, rate = state.rate - previousRate }
end

local function getCarriedTools(character: Model, backpack: Backpack)
	local tools = {}
	for _, container in { backpack, character } do
		for _, child in container:GetChildren() do
			local uid = ItemToolUtil.GetInstanceId(child)
			if uid then
				tools[uid] = child
			end
		end
	end
	return tools
end

local function getMenuContext(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	local plot = getOwnedPlot(player)
	local boundary = plot and PlotFishMotion.GetBoundary(plot)
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not profile or not plot or not boundary or not backpack or not getRoot(player) then
		return nil
	end
	return {
		data = profile.Data,
		plot = plot,
		boundary = boundary,
		backpack = backpack,
		tools = getCarriedTools(player.Character, backpack),
	}
end

local function destroyPrepared(tools)
	for _, tool in pairs(tools) do
		tool:Destroy()
	end
end

-- Prepare all return tools before touching placements or consuming carried tools.
-- ItemToolUtil.Create, the settlement and the commit run without yielding.
local function commitMenuRoster(player: Player, context, desired)
	local data = context.data
	local placements = data.PlotPlacements
	local outgoing, incoming = {}, {}
	for slot = 1, PlotPlacementUtil.CAPACITY do
		local uid = PlotPlacementUtil.GetItemUid(placements, slot)
		local nextUid = desired[slot]
		if uid == nextUid then
			continue
		end
		if uid then
			local item, record = readItemRecord(data.Items[uid])
			if not item or not record or context.tools[uid] then
				return reject("Could not return a fish to your backpack.")
			end
			outgoing[slot] = { uid = uid, item = item, record = record }
		end
		if nextUid then
			local item, record = readItemRecord(data.Items[nextUid])
			local tool = context.tools[nextUid]
			local geometry = item and record and PlotFishMotion.GetGeometry(item, record.Weight, context.boundary)
			if not tool or not geometry then
				return reject("A fish is unavailable.")
			end
			incoming[slot] = { uid = nextUid, item = item, record = record, tool = tool, footprint = geometry.footprint }
		end
	end
	if next(outgoing) == nil and next(incoming) == nil then
		return { ok = true }
	end

	local returnTools = {}
	for slot, fish in pairs(outgoing) do
		local ok, tool = pcall(ItemToolUtil.Create, fish.uid, fish.item, fish.record, player)
		if not ok or not tool then
			destroyPrepared(returnTools)
			if not ok then
				warn("PlotFishService: could not create return tool", tool)
			end
			return reject("Could not return a fish to your backpack.")
		end
		returnTools[slot] = tool
	end

	local now = Workspace:GetServerTimeNow()
	local state = settle(player, data, now)
	if not state then
		destroyPrepared(returnTools)
		return reject("Cash data is unavailable.")
	end

	local folder = getFishFolder(context.plot, player)
	for slot, fish in pairs(outgoing) do
		PlotPlacementUtil.ClearSlot(placements, slot)
		local display = folder:FindFirstChild(fish.uid)
		if display then
			activeFish[display] = nil
			display:Destroy()
		end
	end
	for slot, fish in pairs(incoming) do
		PlotPlacementUtil.SetItemUid(placements, slot, fish.uid)
		createFish(fish.uid, fish.item, fish.record, slot, context.boundary, defaultEntry(slot), now, fish.footprint).Parent = folder
		fish.tool:Destroy()
	end
	for _, tool in pairs(returnTools) do
		tool.Parent = context.backpack
	end
	rosterChanged(player, data, state)
	return { ok = true }
end

function PlotFishService:RequestUnequip(player: Player, uid: unknown)
	if typeof(uid) ~= "string" or uid == "" then
		return reject("Invalid fish.")
	end
	local context = getMenuContext(player)
	if not context then
		return reject("Your fish pond or backpack is unavailable.")
	end
	local desired = {}
	local found = false
	for slot = 1, PlotPlacementUtil.CAPACITY do
		local placedUid = PlotPlacementUtil.GetItemUid(context.data.PlotPlacements, slot)
		if placedUid == uid then
			found = true
		else
			desired[slot] = placedUid
		end
	end
	if not found then
		return reject("This fish is not equipped.")
	end
	return commitMenuRoster(player, context, desired)
end

function PlotFishService:RequestEquipBest(player: Player)
	local context = getMenuContext(player)
	if not context then
		return reject("Your fish pond or backpack is unavailable.")
	end
	local placements = context.data.PlotPlacements
	local candidates, seen = {}, {}
	local bestBaseCps = PlotFishIncome.GetBestOwnedBaseCps(context.data)
	local function addCandidate(uid: string, slot: number?)
		local item, record = readItemRecord(context.data.Items[uid])
		if item and record then
			seen[uid] = true
			table.insert(candidates, { uid = uid, slot = slot, income = getIncome(item, record, bestBaseCps) })
		end
	end
	for slot = 1, PlotPlacementUtil.CAPACITY do
		local uid = PlotPlacementUtil.GetItemUid(placements, slot)
		if uid and not seen[uid] then
			addCandidate(uid, slot)
		end
	end
	for uid in pairs(context.tools) do
		if not seen[uid] then
			addCandidate(uid, nil)
		end
	end
	table.sort(candidates, function(a, b)
		if a.income ~= b.income then
			return a.income > b.income
		end
		if (a.slot ~= nil) ~= (b.slot ~= nil) then
			return a.slot ~= nil
		end
		return a.uid < b.uid
	end)

	local desired, additions = {}, {}
	for index = 1, math.min(#candidates, PlotPlacementUtil.CAPACITY) do
		local fish = candidates[index]
		if fish.slot then
			desired[fish.slot] = fish.uid
		else
			table.insert(additions, fish.uid)
		end
	end
	local nextAddition = 1
	for slot = 1, PlotPlacementUtil.CAPACITY do
		if not desired[slot] and additions[nextAddition] then
			desired[slot] = additions[nextAddition]
			nextAddition += 1
		end
	end
	return commitMenuRoster(player, context, desired)
end

function PlotFishService.Client:GetEquippedFish(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	return if profile then getEquippedFish(player, profile.Data) else nil
end

function PlotFishService.Client:RequestUnequip(player: Player, uid: string)
	return self.Server:RequestUnequip(player, uid)
end

function PlotFishService.Client:RequestEquipBest(player: Player)
	return self.Server:RequestEquipBest(player)
end

function PlotFishService.Client:RequestPlace(player: Player, uid: string)
	return self.Server:RequestPlace(player, uid)
end

function PlotFishService.Client:GetOfflineReward(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if profile then
		return {
			amount = profile.Data.PendingPlotOfflineCash,
			away = player:GetAttribute("PlotOfflineAwaySeconds"),
			counted = player:GetAttribute("PlotOfflineCountedSeconds"),
		}
	end
	return nil
end

function PlotFishService.Client:ClaimOfflineReward(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	local amount = profile and PlotFishIncome.NormalizeBalance(profile.Data.PendingPlotOfflineCash) or 0
	if not profile or amount == 0 then
		return reject("There is no offline reward to claim.")
	end
	profile.Data.PendingPlotOfflineCash = 0
	if not PlayerDataService:AdjustWins(player, amount, false) then
		profile.Data.PendingPlotOfflineCash = amount
		return reject("Could not claim offline earnings.")
	end
	return { ok = true }
end

function PlotFishService:KnitStart()
	local slotService = Knit.GetService("PlotSlotService")
	slotService.SlotAssigned:Connect(function(player)
		self:_restore(player)
	end)
	slotService.SlotReleased:Connect(function(plot)
		local folder = plot:FindFirstChild(PlotFishMotion.FOLDER_NAME)
		if folder and plot:GetAttribute("OwnerUserId") == 0 then
			for _, fish in folder:GetChildren() do
				activeFish[fish] = nil
			end
			folder:Destroy()
		end
	end)

	local function initialize(player)
		slotService:EnsurePlayerSlot(player)
		self:_restore(player)
		self:RefreshInventoryIncome(player)
	end
	PlayerDataService.ProfileLoaded:Connect(initialize)
	for _, player in Players:GetPlayers() do
		local profile = PlayerDataService:GetProfile(player)
		if profile then
			initialize(player)
		end
	end
	Players.PlayerRemoving:Connect(function(player)
		production[player] = nil
		rosterRevisions[player] = nil
	end)
	task.spawn(function()
		while true do
			task.wait(0.1)
			self:_stepMotion(Workspace:GetServerTimeNow())
		end
	end)
	task.spawn(function()
		while true do
			task.wait(1)
			local now = Workspace:GetServerTimeNow()
			for player in pairs(production) do
				local profile = PlayerDataService:GetProfile(player)
				if profile then
					settle(player, profile.Data, now)
				end
			end
		end
	end)
end

return PlotFishService
