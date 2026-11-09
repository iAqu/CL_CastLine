local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local DEFAULT_CONDITION_ID = "Codition_1"
local ItemInventoryService = Knit.CreateService({ Name = "ItemInventoryService", Client = {} })

local function findExistingItemTool(player: Player, instanceId: string): Tool?
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and ItemToolUtil.GetInstanceId(child) == instanceId then
					return child
				end
			end
		end
	end
	return nil
end

local function isPlacedOnPlot(profileData, instanceId: string): boolean
	if typeof(profileData.PlotPlacements) ~= "table" then
		return false
	end
	for _, placedUid in pairs(profileData.PlotPlacements) do
		if placedUid == instanceId then
			return true
		end
	end
	return false
end

local function normalizeStoredItem(record, item)
	local weight = tonumber(record.Weight)
	if not weight or weight ~= weight or weight <= 0 or weight == math.huge then
		return nil
	end
	local conditionId = if typeof(record.ConditionId) == "string" and ConditionsData[record.ConditionId]
		then record.ConditionId
		else DEFAULT_CONDITION_ID
	local condition = ConditionsData[conditionId]
	if not condition then
		return nil
	end
	local mutationId = MutationDataUtil.NormalizeMutationId(record.MutationId)
	local price = tonumber(record.Price)
		or ItemStatUtil.CalculatePrice(item, weight, condition.ValueMult, MutationDataUtil.GetPriceRate(mutationId))
	record.Weight = weight
	record.ConditionId = conditionId
	record.Price = price
	record.MutationId = mutationId
	return { Weight = weight, ConditionId = conditionId, Price = price, MutationId = mutationId }
end

function ItemInventoryService:RestoreItemTools(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return
	end
	if typeof(profile.Data.Items) ~= "table" then
		profile.Data.Items = {}
	end
	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack or not backpack:IsA("Backpack") then
		return
	end
	for instanceId, record in pairs(profile.Data.Items) do
		if
			typeof(instanceId) ~= "string"
			or typeof(record) ~= "table"
			or isPlacedOnPlot(profile.Data, instanceId)
			or findExistingItemTool(player, instanceId)
		then
			continue
		end
		local itemId = record.ItemId
		local item = typeof(itemId) == "string" and FishInventoryData[itemId] or nil
		local instanceData = item and normalizeStoredItem(record, item) or nil
		if not item or not instanceData then
			warn("ItemInventoryService: invalid stored item", tostring(instanceId))
			continue
		end
		local tool = ItemToolUtil.Create(instanceId, item, instanceData)
		if tool then
			tool.Parent = backpack
		end
	end
end

function ItemInventoryService:KnitStart()
	local boundPlayers = {}
	local function bindPlayer(player: Player)
		if boundPlayers[player] then
			return
		end
		boundPlayers[player] = true
		player.CharacterAdded:Connect(function()
			task.defer(function()
				self:RestoreItemTools(player)
			end)
		end)
		task.defer(function()
			self:RestoreItemTools(player)
		end)
	end
	PlayerDataService.ProfileLoaded:Connect(bindPlayer)
	Players.PlayerRemoving:Connect(function(player)
		boundPlayers[player] = nil
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		if PlayerDataService:GetProfile(player) then
			bindPlayer(player)
		end
	end
end

return ItemInventoryService
