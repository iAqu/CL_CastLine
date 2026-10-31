local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local GiftBoxesDataHelper = require(ReplicatedFirst.DataHelpers.GiftBoxesDataHelper)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

local GiftBoxService = Knit.CreateService {
    Name = "GiftBoxService",
    Client = {
        OpenGiftBox = Knit.CreateSignal(),
        DropGifts = Knit.CreateSignal(),
        -- DropGifts = Knit.CreateSignal(),
        PickGift = Knit.CreateSignal(),
    },

    _DroppedGiftsPerPlayer = {},  -- {[player : Player] : {{[UUID : string] : [GiftInstance : GiftInstance]}}}
}

function GiftBoxService:OpenGiftBox(player: Player, giftBoxId: string, allowDisabledPotionGrant: boolean?)
	if not allowDisabledPotionGrant and not PotionFeatureHelper.IsAcquisitionEnabled() then
		return false
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    if profile.Data.GiftBoxClaimLog[giftBoxId] == true then warn("Already claimed!") return end

	local dropGifts = self:CreateGifts(giftBoxId, allowDisabledPotionGrant)
    self.Client.DropGifts:Fire(player, giftBoxId, dropGifts)

    if not self._DroppedGiftsPerPlayer[player] then
        self._DroppedGiftsPerPlayer[player] = {}
    end
    for _, giftInstance in pairs(dropGifts) do
        self._DroppedGiftsPerPlayer[player][giftInstance.UUID] = giftInstance
    end

    profile.Data.GiftBoxClaimLog[giftBoxId] = true

    return true
end

function GiftBoxService:CreateGifts(giftBoxId: string, allowDisabledPotionGrant: boolean?): {}
    local giftInstances = {}
    for index = 1, GiftBoxesDataHelper.GetGiftTypeNum() do
        local itemType = GiftBoxesDataHelper.GetItemType(giftBoxId, index)
        local itemId = GiftBoxesDataHelper.GetItemId(giftBoxId, index)
        local itemCount = GiftBoxesDataHelper.GetItemCount(giftBoxId, index)

        if itemType == "Wins" then
            local winGiftNum = math.random(8, 12)
            if itemCount < winGiftNum then winGiftNum = itemCount end
            for i = 1, winGiftNum do
                local giftInstance: GiftBoxesDataHelper.GiftInstance = {
                    UUID = HttpService:GenerateGUID(false),
                    ItemType = itemType,
                    ItemId = itemId,
                    Value = math.ceil(itemCount / winGiftNum),
					AllowDisabledPotionGrant = allowDisabledPotionGrant,
                }
                table.insert(giftInstances, giftInstance)
            end

        elseif itemType == "Strength" then
            local strengthNum = math.random(8, 12)
            if itemCount < strengthNum then strengthNum = itemCount end
            for i = 1, strengthNum do
                local giftInstance: GiftBoxesDataHelper.GiftInstance = {
                    UUID = HttpService:GenerateGUID(false),
                    ItemType = itemType,
                    ItemId = itemId,
                    Value = math.ceil(itemCount / strengthNum),
					AllowDisabledPotionGrant = allowDisabledPotionGrant,
                }
                table.insert(giftInstances, giftInstance)
            end

        elseif itemType == "Potion" then
            for i = 1, itemCount do
                local giftInstance: GiftBoxesDataHelper.GiftInstance = {
                    UUID = HttpService:GenerateGUID(false),
                    ItemType = itemType,
                    ItemId = itemId,
                    Value = 1,
					AllowDisabledPotionGrant = allowDisabledPotionGrant,
                }
                table.insert(giftInstances, giftInstance)
            end

        elseif itemType == "Diamond" then
            local diamondNum = math.random(7, 11)
            if itemCount < diamondNum then diamondNum = itemCount end
            for i = 1, diamondNum do
                local giftInstance: GiftBoxesDataHelper.GiftInstance = {
                    UUID = HttpService:GenerateGUID(false),
                    ItemType = itemType,
                    ItemId = itemId,
                    Value = math.ceil(itemCount / diamondNum),
					AllowDisabledPotionGrant = allowDisabledPotionGrant,
                }
                table.insert(giftInstances, giftInstance)
            end
        end
    end
    return giftInstances
end

function GiftBoxService:PickGift(player: Player, giftUuid: string)
	local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    if not self._DroppedGiftsPerPlayer[player] then warn "No gift found! 1" return end

    local giftInstance = self._DroppedGiftsPerPlayer[player][giftUuid]
    if not giftInstance then warn "No gift found! 2" return end
	if not PotionFeatureHelper.IsAcquisitionEnabled() and not giftInstance.AllowDisabledPotionGrant then
		return
	end

    if giftInstance.ItemType == "Wins" then
        PlayerDataService:AdjustWins(player, giftInstance.Value)

    elseif giftInstance.ItemType == "Strength" then
        PlayerDataService:AdjustStrength(player, giftInstance.Value)

    elseif giftInstance.ItemType == "Diamond" then
        PlayerDataService:AdjustDiamonds(player, giftInstance.Value)

    elseif giftInstance.ItemType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, giftInstance.ItemId, giftInstance.Value, giftInstance.AllowDisabledPotionGrant)
    end

    self.Client.PickGift:Fire(player, giftInstance)

    if self._DroppedGiftsPerPlayer[player] then
        self._DroppedGiftsPerPlayer[player][giftUuid] = nil
    end
end

function GiftBoxService:KnitInit()

    Players.PlayerRemoving:Connect(function(player)
        self._DroppedGiftsPerPlayer[player] = nil
    end)
end

function GiftBoxService:KnitStart()
    self.Client.OpenGiftBox:Connect(function(player: Player, giftBoxId: string)
		if not PotionFeatureHelper.IsAcquisitionEnabled() then
			return
		end
        -- self:OpenGiftBox(player, giftBoxId)
        Knit.GetService("PurchaseService"):PromptPurchase(player, giftBoxId)
    end)

    self.Client.PickGift:Connect(function(player: Player, giftUuid: string)
        self:PickGift(player, giftUuid)
    end)
end

return GiftBoxService
