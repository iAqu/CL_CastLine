local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local LimitedPacksDataHelper = require(ReplicatedFirst.DataHelpers.LimitedPacksDataHelper)
local PotionService = require(ServerScriptService.Services.PotionService)
local SpinningWheelService = require(ServerScriptService.Services.SpinningWheelService)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

local LimitedPackService = Knit.CreateService {
    Name = "LimitedPackService",
    Client = {
    },
}

function LimitedPackService:GivePack(player: Player, packId: string, allowDisabledPotionGrant: boolean?)
	if not allowDisabledPotionGrant and not PotionFeatureHelper.IsAcquisitionEnabled() then
		return false
	end
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    for i = 1, 4 do
        local itemType = LimitedPacksDataHelper.GetItemType(packId, i)
        local itemId = LimitedPacksDataHelper.GetItemId(packId, i)
        local itemCount = LimitedPacksDataHelper.GetItemCount(packId, i)

        if itemType == "Potion" then
			PotionService:AdjustPotionCount(player, itemId, itemCount, allowDisabledPotionGrant)

        elseif itemType == "Spin" then
            SpinningWheelService:AdjustSpinNum(player, itemCount)

        elseif itemType == "Wins" then
            PlayerDataService:AdjustWins(player, itemCount)

        elseif itemType == "Diamond" then
            PlayerDataService:AdjustDiamonds(player, itemCount)

        else
            warn("Unknown item type: ", itemType)
	end
	return true
end
end

function LimitedPackService:KnitInit()
end

function LimitedPackService:KnitStart()
end

return LimitedPackService
