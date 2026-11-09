local HttpService = game:GetService("HttpService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local GamePassEffectUtil = require(ReplicatedStorage.Modules.GamePassEffectUtil)
local ItemRollUtil = require(ReplicatedStorage.Modules.ItemRollUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local ItemGrantUtil = {}

local DEFAULT_CONDITION_ID = "Codition_1"

export type GrantOptions = {
	Random: Random?,
	Weight: number?,
	CountTowardTotalWeight: boolean?,
	MutationId: string?,
}

local function getBackpack(player: Player): Backpack?
	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	return if backpack and backpack:IsA("Backpack") then backpack else nil
end

local function getInstanceId(items: { [string]: unknown }): string
	local instanceId = HttpService:GenerateGUID(false)
	while items[instanceId] ~= nil do
		instanceId = HttpService:GenerateGUID(false)
	end
	return instanceId
end

function ItemGrantUtil.GetOrderedItemIds(): { string }
	local itemIds = {}
	for itemId in pairs(FishInventoryData) do
		table.insert(itemIds, itemId)
	end
	table.sort(itemIds, function(left, right)
		local leftItem = FishInventoryData[left]
		local rightItem = FishInventoryData[right]
		if leftItem.LayoutOrder ~= rightItem.LayoutOrder then
			return leftItem.LayoutOrder < rightItem.LayoutOrder
		end
		return left < right
	end)
	return itemIds
end

function ItemGrantUtil.Grant(player: Player, itemId: string, options: GrantOptions?): ({ [string]: unknown }?, string?)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil, "No Profile found for player"
	end

	local item = FishInventoryData[itemId]
	if not item then
		return nil, "Unknown item: " .. tostring(itemId)
	end

	local backpack = getBackpack(player)
	if not backpack then
		return nil, "Backpack is unavailable for player"
	end

	local random = options and options.Random or nil
	local weight = options and tonumber(options.Weight) or nil
	weight = weight or ItemStatUtil.RollWeight(item, random)
	-- Roll from the item's intrinsic Luck so a Condition never improves its own chance.
	local conditionLuck = ItemStatUtil.CalculateLuck(item, weight, 1)
	conditionLuck += Knit.GetService("IndexService"):GetDiscoveryLuck(player)
	conditionLuck *= GamePassEffectUtil.GetItemLuckMultiplier(profile.Data)
	local conditionId, condition = ItemRollUtil.RollCondition(ConditionsData, conditionLuck, random)
	conditionId = conditionId or DEFAULT_CONDITION_ID
	condition = condition or ConditionsData[conditionId]
	if not condition then
		return nil, "No valid item condition is configured"
	end

	local mutationId = MutationDataUtil.NormalizeMutationId(options and options.MutationId)
	local mutationPriceRate = MutationDataUtil.GetPriceRate(mutationId)
	local basePrice = ItemStatUtil.CalculatePrice(item, weight, 1, mutationPriceRate)
	local price = ItemStatUtil.CalculatePrice(item, weight, condition.ValueMult, mutationPriceRate)
	local instanceData = {
		Weight = weight,
		ConditionId = conditionId,
		Price = price,
		MutationId = mutationId,
	}
	local tool = ItemToolUtil.Create("pending", item, instanceData)
	if not tool then
		return nil, "Item model is unavailable: " .. tostring(item.Model)
	end
	if backpack.Parent ~= player then
		tool:Destroy()
		return nil, "Backpack is unavailable for player"
	end

	if typeof(profile.Data.Items) ~= "table" then
		profile.Data.Items = {}
	end
	local instanceId = getInstanceId(profile.Data.Items)
	tool.Name = "Item_" .. instanceId
	tool:SetAttribute(ItemToolUtil.INSTANCE_ID_ATTRIBUTE, instanceId)
	profile.Data.Items[instanceId] = {
		ItemId = itemId,
		Weight = weight,
		ConditionId = conditionId,
		Price = price,
		MutationId = mutationId,
	}
	tool.Parent = backpack
	if typeof(profile.Data.NewItemTagSeenLog) ~= "table" then
		profile.Data.NewItemTagSeenLog = {}
	end
	local isFirstItemAcquisition = profile.Data.NewItemTagSeenLog[itemId] ~= true
	profile.Data.NewItemTagSeenLog[itemId] = true
	Knit.GetService("IndexService"):DiscoverItem(player, itemId)
	if options and options.CountTowardTotalWeight then
		PlayerDataService:AdjustTotalItemWeightTenths(player, math.round(weight * 10))
	end

	Knit.GetService("CarryCapacityService"):RefreshPlayer(player)

	return {
		Item = item,
		ItemId = itemId,
		InstanceId = instanceId,
		Weight = weight,
		ConditionId = conditionId,
		Condition = condition,
		BasePrice = basePrice,
		Price = price,
		IsFirstItemAcquisition = isFirstItemAcquisition,
		MutationId = mutationId,
	}
end

return ItemGrantUtil
