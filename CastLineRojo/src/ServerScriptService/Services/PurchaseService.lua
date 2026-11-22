local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Signal = require(ReplicatedStorage.Packages.Signal)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local FishingBaitPurchases = require(script.Parent.FishingBaitPurchases)
local ProductPurchases = require(script.Parent.ProductPurchases)
local Checkout = require(script.Parent.PurchaseCheckout)
local PaidItemPolicy = require(script.Parent.PaidItemPolicy)
local PaidEggConfig = require(ReplicatedStorage.Modules.PaidEggConfig)
local CashPack = require(ReplicatedStorage.Modules.CashPack)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)
local ULTRA_LUCK_ID = "MegaLuck"

type Receipt = {PlayerId: number, PlaceIdWherePurchased: number, ProductId: number,
    PurchaseId: string, CurrencySpent: number, CurrencyType: Enum.CurrencyType}

local PurchaseService = Knit.CreateService {
    Name = "PurchaseService",
    Client = {
        PurchaseSuccess = Knit.CreateSignal(),
        PurchaseFail = Knit.CreateSignal(),
        PurchaseLimitSuccess = Knit.CreateSignal(),
        UpdateUGCRemaining = Knit.CreateSignal(),

        -- Client <-> Server

        -- Client to Server
        CancelGift = Knit.CreateSignal(),
        PromptPurchase = Knit.CreateSignal(),      -- robux purchase

        -- Server to Client
        PurchaseGiftSuccess = Knit.CreateSignal(),
        ReceiveGiftSuccess = Knit.CreateSignal(),
        PromptPurchaseFail = Knit.CreateSignal(),
    },
    PurchaseSuccess = Signal.new(),

    _PlayerGifted = {},     -- {player userId: gifted player userId}
}

function PurchaseService.Client:SelectGiftedPlayer(player: Player, giftedPlayer: Player)
    return self.Server:SelectGiftedPlayer(player, giftedPlayer)
end

function PurchaseService:SelectGiftedPlayer(player: Player, giftedPlayer: Player)
    if typeof(giftedPlayer) ~= "Instance" or not giftedPlayer:IsA("Player")
        or giftedPlayer.Parent ~= Players then
        return false, "Player not found!"
    end

    self._PlayerGifted[player.UserId] = giftedPlayer.UserId
    task.defer(PaidItemPolicy.Get, giftedPlayer)
    return true, "Success!"
end

function PurchaseService:HandlePurchase(player: Player, productId: number): boolean
    local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
    if not purchaseId or PurchaseDataHelper.IsRetired(purchaseId) then
        return false
    end
    local row = PurchaseDataHelper.GetData(purchaseId)
    if row.Type ~= "GamePass" or row.ProductId ~= productId or not PlayerDataService:GetProfile(player) then
        return false
    end
    Knit.GetService("GamePassService"):GiveGamePass(player, purchaseId)
    return true
end

function PurchaseService:processReceipt(receiptInfo: Receipt)
    local paidEggs = Knit.GetService("PaidEggService")
    if paidEggs:IsProduct(receiptInfo.ProductId) then
        return if paidEggs:ProcessReceipt(receiptInfo)
            then Enum.ProductPurchaseDecision.PurchaseGranted
            else Enum.ProductPurchaseDecision.NotProcessedYet
    end
    if FishingBaitPurchases.IsProduct(receiptInfo.ProductId) then
        local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
        local ok, granted, added = pcall(FishingBaitPurchases.Process, player, receiptInfo)
        if not ok then
            warn("PurchaseService: fishing bait receipt failed: " .. tostring(granted))
        end
        if ok and granted then
            if added then
                self.Client.PurchaseSuccess:Fire(player, receiptInfo.ProductId, false)
            end
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
    local granted, record, player = ProductPurchases.Process(receiptInfo)
    if not granted then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
    if record and player.Parent == Players then
        if record.RecipientUserId == player.UserId then
            self.Client.PurchaseLimitSuccess:Fire(player, record.PurchaseId)
            self.Client.PurchaseSuccess:Fire(player, receiptInfo.ProductId, true)
            self.PurchaseSuccess:Fire(player, receiptInfo.ProductId)
        else
            self.Client.PurchaseGiftSuccess:Fire(player, receiptInfo.ProductId)
        end
    end
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

function PurchaseService.Client:GetPolicyCache(player: Player) : {[string]: any}
    return self.Server:GetPolicyCache(player)
end

function PurchaseService:GetPolicyCache(player: Player) : {[string]: any}
    return PaidItemPolicy.Get(player) or {}
end

local function getRecipient(service, player, forSelf)
    local recipientId = if forSelf == true then nil else service._PlayerGifted[player.UserId]
    if recipientId and recipientId ~= player.UserId then
        return Players:GetPlayerByUserId(recipientId)
    end
    return player
end

function PurchaseService:PromptPurchase(
    player: Player,
    purchaseId: string,
    forSelf: boolean?,
    disclosedRecipientId: number?,
    displayedAmount: number?
)
    if type(purchaseId) ~= "string" then return end
    if FishingBaitPurchases.IsPurchaseId(purchaseId) then
        self.Client.PromptPurchaseFail:Fire(player, "Select the bait while fishing to buy it.")
        return
    end
    if PaidEggConfig.Purchases[purchaseId] then
        local success, message = Knit.GetService("PaidEggService"):Prompt(player, purchaseId, forSelf == true)
        if not success then
            self.Client.PromptPurchaseFail:Fire(player, message or "Purchase unavailable.", purchaseId)
        end
        return
    end
    if PurchaseDataHelper.IsRetired(purchaseId) then
        self.Client.PromptPurchaseFail:Fire(player, "This item is no longer for sale.")
        return
    end
	if not PotionFeatureHelper.IsAcquisitionEnabled() and PotionFeatureHelper.IsPotionRelatedPurchaseId(purchaseId) then
		self.Client.PromptPurchaseFail:Fire(player, PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE)
		return
	end
    local row = PurchaseDataHelper.GetData(purchaseId)
    if not row or (row.Type ~= "Wins" and row.Type ~= "GamePass") then
        self.Client.PromptPurchaseFail:Fire(player, "This item is no longer for sale.")
        return
    end

    local recipient = getRecipient(self, player, forSelf)
    if purchaseId == ULTRA_LUCK_ID then
        local recipientChanged = "Gift recipient changed. Select the recipient again."
        if forSelf ~= true and (not recipient or recipient == player or disclosedRecipientId ~= recipient.UserId) then
            self.Client.PromptPurchaseFail:Fire(player, recipientChanged)
            return
        end
        local allowed, message = PaidItemPolicy.CanPurchase(player, recipient, "Ultra Luck is unavailable for this player.")
        if not allowed or getRecipient(self, player, forSelf) ~= recipient then
            self.Client.PromptPurchaseFail:Fire(player, message or recipientChanged)
            return
        end
    end
    local data = recipient and PlayerDataService:GetAllData(recipient)
    if not data then
        self.Client.PromptPurchaseFail:Fire(player, "Player not found!")
        return
    end
    if row.Type == "GamePass" and data.GamePasses[purchaseId] then
        self.Client.PromptPurchaseFail:Fire(player, "Already owned!")
        return
    end

    local productId = if recipient == player then row.ProductId else row.GiftProductId
    if type(productId) ~= "number" or productId <= 0 then
        self.Client.PromptPurchaseFail:Fire(player, "Purchase unavailable.")
        return
    end
    if row.Type == "GamePass" and recipient == player then
        MarketplaceService:PromptGamePassPurchase(player, productId)
        return
    end
    local amount
    if CashPack.Offers[purchaseId] then
        amount = CashPack.GetAmount(purchaseId, PlotFishIncome.GetBaseRate(data))
        if not amount or disclosedRecipientId ~= recipient.UserId or displayedAmount ~= amount then
            self.Client.PromptPurchaseFail:Fire(player, "Cash pack amount or recipient changed. Check the store and try again.")
            return
        end
    end

    local ok, message = ProductPurchases.Prompt(player, purchaseId, row, productId, recipient, amount)
    if not ok then
        self.Client.PromptPurchaseFail:Fire(player, message)
    end
end

function PurchaseService:KnitInit()
    LogHelper.Print("PurchaseService initialized")

    Players.PlayerRemoving:Connect(function(player)
        self._PlayerGifted[player.UserId] = nil
        ProductPurchases.Remove(player)
    end)

    self.Client.PromptPurchase:Connect(function(player, purchaseId, forSelf, disclosedRecipientId, displayedAmount)
        self:PromptPurchase(player, purchaseId, forSelf, disclosedRecipientId, displayedAmount)
    end)
end

function PurchaseService:KnitStart()
    LogHelper.Print("PurchaseService started")

    PlayerDataService:RegisterBeforeProfileRelease(function(player)
        local profile = PlayerDataService:GetProfile(player)
        if profile then
            ProductPurchases.ClearCanceledPrompt(player, profile)
            FishingBaitPurchases.ClearCanceledPrompt(player, profile)
        end
    end)

    Checkout.Start()

    -- handle developer product purchase
    MarketplaceService.ProcessReceipt = function(...)
        return self:processReceipt(...)
    end

    MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, purchased)
        local player = Players:GetPlayerByUserId(userId)
        FishingBaitPurchases.OnPromptFinished(player, productId, purchased)
        ProductPurchases.OnPromptFinished(player, productId, purchased)
    end)

    -- handle game pass purchase
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
        if not wasPurchased or not self:HandlePurchase(player, gamePassId) then
            return
        end
        -- LogHelper.Print("PromptGamePassPurchaseFinished")
        self.Client.PurchaseSuccess:Fire(player, gamePassId)
        self.PurchaseSuccess:Fire(player, gamePassId)       -- for void service
    end)

    self.Client.CancelGift:Connect(function(player: Player)
        self._PlayerGifted[player.UserId] = nil
    end)

    PlayerDataService.ProfileLoaded:Connect(function(player: Player)
        ProductPurchases.Watch(player, function(recipient, order)
            if order.Type == "Wins" then
                self.Client.PurchaseLimitSuccess:Fire(recipient, order.PurchaseId)
            end
            self.Client.ReceiveGiftSuccess:Fire(recipient, order.ProductId, order.SenderName)
        end)
        -- update gamepass data
        task.spawn(function()
            for purchaseId, _ in pairs(PurchaseDataHelper.GetGamePassesData()) do
                local gamePassId = PurchaseDataHelper.GetProductId(purchaseId)
                local success, wasPurchased = pcall(function()
                    return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
                end)
                if success and wasPurchased then
					Knit.GetService("GamePassService"):GiveGamePass(player, purchaseId)
                    self.Client.PurchaseSuccess:Fire(player, gamePassId, false)
                end
            end
        end)
    end)
end

return PurchaseService
