local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Constants)

local PotionFeatureHelper = {}

PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE = "Potion rewards are temporarily disabled."

function PotionFeatureHelper.IsAcquisitionEnabled(): boolean
	return Constants.POTION_ACQUISITION_ENABLED == true
end

function PotionFeatureHelper.IsPotionReward(itemType: unknown, itemId: unknown): boolean
	return itemType == "Potion" or itemType == "PotionPack" or itemType == "PotionBundle"
		or (typeof(itemId) == "string" and itemId:match("^Potion_") ~= nil)
end

function PotionFeatureHelper.IsPotionRelatedPurchaseId(purchaseId: unknown): boolean
	if typeof(purchaseId) ~= "string" then
		return false
	end
	return purchaseId:find("Potion", 1, true) ~= nil
		or purchaseId == "StarterPack"
		or purchaseId == "LimitedStarterPack"
		or purchaseId == "LimitedAdvancedPack"
		or purchaseId == "LimitedSquidPack"
		or purchaseId:find("LimitedPack", 1, true) ~= nil
end

function PotionFeatureHelper.HasPotionReward(rewardData: unknown): boolean
	if typeof(rewardData) ~= "table" then
		return false
	end

	for key, value in pairs(rewardData) do
		if typeof(key) == "string" and key:match("^Type_") and PotionFeatureHelper.IsPotionReward(value, nil) then
			return true
		end
		if typeof(key) == "string" and (key:match("^Id_") or key:match("^ItemI[Dd]_") or key:match("RewardItemId"))
			and PotionFeatureHelper.IsPotionReward(nil, value)
		then
			return true
		end
	end

	return false
end

return PotionFeatureHelper
