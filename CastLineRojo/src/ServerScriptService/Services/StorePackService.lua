local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local StorePacksDataHelper = require(ReplicatedFirst.DataHelpers.StorePacksDataHelper)
local PotionService = require(ServerScriptService.Services.PotionService)

local StorePackService = Knit.CreateService {
    Name = "StorePackService",
    Client = {
    },
}

function StorePackService:GivePack(player: Player, packId: string)
    return -- 临时禁用 StorePack 发奖
    --[[
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then return end

    local totalItemData = StorePacksDataHelper.GetAllItemData(packId)
    for _, itemData in pairs(totalItemData) do
        local itemType = itemData.Type
        local itemId = itemData.Id
        local itemCount = itemData.Count

        if itemType == "Wins" then
            PlayerDataService:AdjustWins(player, itemCount)

        elseif itemType == "Trophy" then
            PlayerDataService:AdjustTrophy(player, itemCount)

        elseif itemType == "Diamond" then
            PlayerDataService:AdjustDiamonds(player, itemCount)

        elseif itemType == "Potion" then
            PotionService:AdjustPotionCount(player, itemId, itemCount)

        else
            warn("Unknown item type: ", itemType)
        end
    end
    ]]
end

function StorePackService:KnitInit()
end

function StorePackService:KnitStart()
end

return StorePackService
