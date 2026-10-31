local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeShopConfig = require(ReplicatedStorage.Modules.UpgradeShopConfig)
local GamePassEffectUtil = require(ReplicatedStorage.Modules.GamePassEffectUtil)

local CarryCapacityUtil = {}

CarryCapacityUtil.WEIGHT_ATTRIBUTE = "CarriedWeightKg"
CarryCapacityUtil.CAPACITY_ATTRIBUTE = "CarryCapacityKg"
CarryCapacityUtil.VALUE_ATTRIBUTE = "CarriedValue"

local function getPlacedItemIds(playerData): { [string]: boolean }
	local placed = {}
	if typeof(playerData.PlotPlacements) ~= "table" then
		return placed
	end
	for _, instanceId in pairs(playerData.PlotPlacements) do
		if typeof(instanceId) == "string" then
			placed[instanceId] = true
		end
	end
	return placed
end

function CarryCapacityUtil.GetCarriedTotals(playerData): (number, number)
	local totalWeight = 0
	local totalValue = 0
	if not playerData or typeof(playerData.Items) ~= "table" then
		return totalWeight, totalValue
	end

	local placed = getPlacedItemIds(playerData)
	for instanceId, record in pairs(playerData.Items) do
		if not placed[instanceId] and typeof(record) == "table" then
			totalWeight += math.max(0, tonumber(record.Weight) or 0)
			totalValue += math.max(0, tonumber(record.Price) or 0)
		end
	end
	return totalWeight, totalValue
end

function CarryCapacityUtil.GetCapacity(playerData): number
	return UpgradeShopConfig.GetCarryWeight(playerData) * GamePassEffectUtil.GetCarryCapacityMultiplier(playerData)
end

function CarryCapacityUtil.CanCarry(playerData, addedWeight: unknown): boolean
	local weight = tonumber(addedWeight)
	if not weight or weight < 0 then
		return false
	end
	local currentWeight = CarryCapacityUtil.GetCarriedTotals(playerData)
	return currentWeight + weight <= CarryCapacityUtil.GetCapacity(playerData)
end

return CarryCapacityUtil
