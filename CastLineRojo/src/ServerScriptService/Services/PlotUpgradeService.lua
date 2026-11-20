local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlotUpgradeData = require(ReplicatedStorage.Modules.PlotUpgradeData)
local PlotAppearance = require(ReplicatedStorage.Modules.PlotAppearance)
local TransitionConfig = require(ReplicatedStorage.Modules.PlotUpgradeTransitionConfig)
local PlayerDataService = require(script.Parent.PlayerDataService)
local Analytics = require(script.Parent.OnboardingAnalyticsService)

local PlotUpgradeService = Knit.CreateService({
	Name = "PlotUpgradeService",
	Client = { UpgradeTransition = Knit.CreateSignal() },
})
local purchasing = {}

local function failure(message)
	return { ok = false, message = message }
end

function PlotUpgradeService:ApplyForPlayer(player: Player, plot: Instance)
	local profile = PlayerDataService:GetProfile(player)
	local config = PlotUpgradeData.Get(profile and profile.Data.PlotUpgradeLevel)
	PlotAppearance.Apply(plot, config)
	player:SetAttribute("PlotUpgradeLevel", config.Level)
	player:SetAttribute("PlotCapacity", config.Capacity)
end

function PlotUpgradeService:ResetPlot(plot: Instance)
	PlotAppearance.Apply(plot, PlotUpgradeData.Get(0))
end

local function validatePurchase(player: Player, expectedLevel: unknown, previous)
	if player.Parent ~= Players then
		return nil, "Your plot is unavailable."
	end
	local profile = PlayerDataService:GetProfile(player)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	if not profile or not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		return nil, "Your plot is unavailable."
	end
	if
		previous
		and (
			profile ~= previous.profile
			or profile.Data ~= previous.data
			or plot ~= previous.plot
			or player.Character ~= previous.character
		)
	then
		return nil, "Your plot changed. Please try again."
	end
	local data = profile.Data
	local oldConfig = PlotUpgradeData.Get(data.PlotUpgradeLevel)
	if typeof(expectedLevel) ~= "number" or expectedLevel ~= oldConfig.Level then
		return nil, "Your plot level changed. Please try again."
	end
	local config = PlotUpgradeData.GetNext(oldConfig.Level)
	if not config then
		return nil, "Your plot is already at maximum level."
	end
	local sign = plot:FindFirstChild("Sign")
	local board = sign and sign:FindFirstChild("UIPart")
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if
		not root
		or not board
		or not humanoid
		or humanoid.Health <= 0
		or (root.Position - board.Position).Magnitude > 22
	then
		return nil, "Walk up to your upgrade sign."
	end
	if typeof(data.Wins) ~= "number" or data.Wins ~= data.Wins or data.Wins < config.Price then
		return nil, "Not enough money."
	end
	local ready, message = PlotAppearance.Preflight(plot, config)
	if not ready then
		return nil, message
	end
	return { profile = profile, plot = plot, data = data, oldConfig = oldConfig, config = config, character = character }
end

function PlotUpgradeService:_broadcast(phase, context, id)
	local ok, err = pcall(function()
		self.Client.UpgradeTransition:FireAll(phase, context.plot, id, context.config.Level)
	end)
	if not ok then
		warn("PlotUpgradeService: could not broadcast transition", err)
	end
end

function PlotUpgradeService:_commitUpgrade(player, context)
	local plot, data = context.plot, context.data
	local config, oldConfig = context.config, context.oldConfig

	local oldBalance = data.Wins
	local applied, applyError = pcall(PlotAppearance.Apply, plot, config)
	if not applied then
		pcall(PlotAppearance.Apply, plot, oldConfig)
		warn("PlotUpgradeService: could not apply plot upgrade", applyError)
		return failure("Could not upgrade your plot.")
	end
	local charged, result = pcall(PlayerDataService.AdjustWins, PlayerDataService, player, -config.Price, false)
	if not charged or not result then
		-- Restore directly: a positive AdjustWins refund would count as new earned cash.
		data.Wins = oldBalance
		local stats = player:FindFirstChild("leaderstats")
		local cash = stats and stats:FindFirstChild("💵Cash")
		if cash then
			cash.Value = oldBalance
		end
		pcall(function()
			PlayerDataService.Client.WinsChanged:Fire(player, oldBalance)
		end)
		pcall(PlotAppearance.Apply, plot, oldConfig)
		return failure("Could not charge for the upgrade.")
	end
	data.PlotUpgradeLevel = config.Level
	Analytics:Growth(player, "CL_PlotUpgrade_v1", config.Price, config.Level, config.Capacity)
	player:SetAttribute("PlotUpgradeLevel", config.Level)
	player:SetAttribute("PlotCapacity", config.Capacity)
	local refreshed, refreshError = pcall(function()
		Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
	end)
	if not refreshed then
		warn("PlotUpgradeService: could not refresh upgraded roster", refreshError)
	end
	return { ok = true, level = config.Level, capacity = config.Capacity }
end

function PlotUpgradeService:RequestUpgrade(player: Player, expectedLevel: unknown)
	if purchasing[player] then
		return failure("An upgrade is already in progress.")
	end
	local context, message = validatePurchase(player, expectedLevel)
	if not context then
		return failure(message)
	end
	local id = HttpService:GenerateGUID(false)
	purchasing[player] = id
	self:_broadcast("Begin", context, id)
	local ok, response = pcall(function()
		task.wait(TransitionConfig.CoverDelay)
		local current, reason = validatePurchase(player, expectedLevel, context)
		if not current or purchasing[player] ~= id then
			return failure(reason or "Your plot changed. Please try again.")
		end
		return self:_commitUpgrade(player, current)
	end)
	if not ok then
		warn("PlotUpgradeService: upgrade transition failed", response)
		response = failure("Could not upgrade your plot.")
	end
	self:_broadcast(if response.ok then "Applied" else "Cancel", context, id)
	if purchasing[player] == id then
		purchasing[player] = nil
	end
	return response
end

function PlotUpgradeService.Client:RequestUpgrade(player: Player, expectedLevel: unknown)
	return self.Server:RequestUpgrade(player, expectedLevel)
end

function PlotUpgradeService:KnitStart()
	Players.PlayerRemoving:Connect(function(player)
		purchasing[player] = nil
	end)
end

return PlotUpgradeService
