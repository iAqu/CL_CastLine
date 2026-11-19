local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")
local PolicyService = game:GetService("PolicyService")
local AnalyticsService = game:GetService("AnalyticsService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Signal = require(ReplicatedStorage.Packages.Signal)
local GameAnalyticsHelper = require(ReplicatedStorage.Modules.GameAnalyticsHelper)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local HGAnalyticsService = require(ServerScriptService.Services.HGAnalyticsService)
local FishingBaitPurchases = require(script.Parent.FishingBaitPurchases)

type Receipt = {PlayerId: number, PlaceIdWherePurchased: number, ProductId: number,
    PurchaseId: string, CurrencySpent: number, CurrencyType: Enum.CurrencyType}

local purchaseHistoryStore = DataStoreService:GetDataStore("PurchaseHistory")
local purchaseFailHistoryStore = DataStoreService:GetDataStore("PurchaseFailHistory")

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
        TokensPurchase = Knit.CreateSignal(),
        PromptPurchase = Knit.CreateSignal(),      -- robux purchase

        -- Server to Client
        PurchaseGiftSuccess = Knit.CreateSignal(),
        ReceiveGiftSuccess = Knit.CreateSignal(),
        TokensPurchaseFail = Knit.CreateSignal(),
        PromptPurchaseFail = Knit.CreateSignal(),
    },
    PurchaseSuccess = Signal.new(),
    _PlayerPolicyCache = {},

    _PlayerGifted = {},     -- {player userId: gifted player userId}
}

function PurchaseService.Client:SelectGiftedPlayer(player: Player, giftedPlayer: Player)
    return self.Server:SelectGiftedPlayer(player, giftedPlayer)
end

function PurchaseService:SelectGiftedPlayer(player: Player, giftedPlayer: Player)
    if not giftedPlayer then return false, "Player not found!" end
    -- if player == giftedPlayer then return false, "Cannot gift to yourself!" end
    if not Players:GetPlayerByUserId(giftedPlayer.UserId) then return false, "Player not found!" end

    self._PlayerGifted[player.UserId] = giftedPlayer.UserId
    return true, "Success!"
end

function PurchaseService:HandlePurchase(player: Player, productId: number, sentToGa: boolean?, allowDisabledPotionGrant: boolean?): boolean
    -- local profile = PlayerDataService:GetProfile(player)
    -- if not profile then warn "No Profile found!" return end
    local playerData = PlayerDataService:GetAllData(player)
    if not playerData then warn "HandlePurchase No playerData found!" return end

    -- local purchaseType = PurchaseDataHelper.GetType(productId)
    local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
    if PurchaseDataHelper.IsRetired(purchaseId) then return false end
    local purchaseType = PurchaseDataHelper.GetTypeByPurchaseId(purchaseId)
    
    sentToGa = sentToGa or true
    if sentToGa then
        GameAnalyticsHelper.AddBusinessEvent(player, productId)
    end

    local receivePlayer = nil
    if self._PlayerGifted[player.UserId] then
        receivePlayer = Players:GetPlayerByUserId(self._PlayerGifted[player.UserId])

    else
        receivePlayer = player
    end
    local receivePlayerData = PlayerDataService:GetAllData(receivePlayer)
    if not receivePlayerData then warn "No receivePlayerData found!" return end

    if purchaseType == "Wins" then
        -- local buyNum = GameDataUtil.CalculateWinTierCount(receivePlayerData, purchaseId)
        local buyNum = PurchaseDataHelper.GetBuyNum(purchaseId)
        -- if not receivePlayerData.LimitedPurchaseHistory[purchaseId] then
            -- buyNum = buyNum * 2
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true
            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
        -- end
        return PlayerDataService:AdjustWins(receivePlayer, buyNum)

    elseif purchaseType == "Diamond" then
        local count = PurchaseDataHelper.GetBuyNum(purchaseId)
        -- GameAnalyticsHelper.AddSourceWinsEvent(player, voidGearCount, "Purchase", purchaseId)
        -- if not receivePlayerData.LimitedPurchaseHistory[purchaseId] then
        --     count = count * 2
            -- receivePlayerData.LimitedPurchaseHistory[purchaseId] = true
        --     self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
        -- end
        -- return PlayerDataService:AdjustDiamonds(player, count)
        return PlayerDataService:AdjustDiamonds(receivePlayer, count)

    elseif purchaseType == "Token" then
        local count = PurchaseDataHelper.GetBuyNum(purchaseId)
        return PlayerDataService:AdjustTokens(receivePlayer, count)

    elseif purchaseType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        local count = PurchaseDataHelper.GetBuyNum(purchaseId)
        return PotionService:AdjustPotionCount(receivePlayer, purchaseId, count, allowDisabledPotionGrant)

    elseif purchaseType == "GamePass" then
        Knit.GetService("GamePassService"):GiveGamePass(receivePlayer, purchaseId)
        return true

    elseif purchaseType == "Spin" then
        local SpinningWheelService = Knit.GetService("SpinningWheelService")
        local num = PurchaseDataHelper.GetBuyNum(purchaseId)
        -- return SpinningWheelService:AdjustSpinNum(player, num)
        return SpinningWheelService:AdjustSpinNum(receivePlayer, num)

    elseif purchaseType == "SeasonPass" then
        local SeasonService = Knit.GetService("SeasonService")
        if purchaseId == Constants.PURCHASE_ID.SEASON_1 then
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true
            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
            return true
        elseif purchaseId == Constants.PURCHASE_ID.SEASON_SKIP_LEVEL then
            return SeasonService:SkipLevel(receivePlayer)
        elseif purchaseId == Constants.PURCHASE_ID.SEASON_UNLOCK_ALL then
            return SeasonService:UnlockAll(receivePlayer)
        elseif purchaseId == Constants.PURCHASE_ID.SEASON_RESTART then
            return SeasonService:Restart(receivePlayer)
        end

    elseif purchaseType == "Pack" then
        if purchaseId == Constants.PURCHASE_ID.LIMITED_STARTER_PACK then
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true

            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
            return true
        end

        if purchaseId == Constants.PURCHASE_ID.LIMITED_ADVANCED_PACK then
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true

			Knit.GetService("PotionService"):AdjustPotionCount(receivePlayer, Constants.POTION_ID.MUTATION, 5, allowDisabledPotionGrant)
            PlayerDataService:AdjustWins(receivePlayer, 10000)

            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
            return true
        end

        if purchaseId == Constants.PURCHASE_ID.LIMITED_SQUID_PACK then
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true

			Knit.GetService("PotionService"):AdjustPotionCount(receivePlayer, Constants.POTION_ID.MUTATION, 10, allowDisabledPotionGrant)
            PlayerDataService:AdjustWins(receivePlayer, 100000000)

            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
            return true
        end

        if purchaseId == Constants.PURCHASE_ID.POTION_BUNDLE then
            if receivePlayerData.LimitedPurchaseHistory[purchaseId] then return end
            local PotionService = Knit.GetService("PotionService")

			for _, potionId in ipairs({ Constants.POTION_ID.DOUBLE_WINS, Constants.POTION_ID.DOUBLE_WINS_SPEED, Constants.POTION_ID.DOUBLE_EXP, Constants.POTION_ID.MUTATION }) do
				PotionService:AdjustPotionCount(receivePlayer, potionId, 99, allowDisabledPotionGrant)
			end

            -- receivePlayerData.LimitedPurchaseHistory[purchaseId] = true
            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
            return true

        elseif purchaseId == Constants.PURCHASE_ID.LIMITED_DAILY_POTION_BUNDLE then
            local dayOfYear = DateTime.now():FormatUniversalTime("DDD", "en-us")
            -- if profile.Data.LimitedDailyPotionPurchaseHistory[dayOfYear] then return end
            if receivePlayerData.LimitedDailyPotionPurchaseHistory[dayOfYear] then return end

            local PotionService = Knit.GetService("PotionService")
			PotionService:AdjustPotionCount(receivePlayer, Constants.POTION_ID.MUTATION, 1, allowDisabledPotionGrant)
			PotionService:AdjustPotionCount(receivePlayer, Constants.POTION_ID.DOUBLE_WINS, 1, allowDisabledPotionGrant)
			PotionService:AdjustPotionCount(receivePlayer, Constants.POTION_ID.DOUBLE_EXP, 1, allowDisabledPotionGrant)
			PotionService:AdjustPotionCount(receivePlayer, Constants.POTION_ID.DOUBLE_WINS_SPEED, 1, allowDisabledPotionGrant)
			PotionService:AdjustPotionCount(receivePlayer, Constants.POTION_ID.MUTATION, 1, allowDisabledPotionGrant)

            receivePlayerData.LimitedDailyPotionPurchaseHistory[dayOfYear] = true
            return true

        elseif purchaseId == Constants.PURCHASE_ID.STARTER_PACK then
			Knit.GetService("OnlineRewardService"):GiveStartPack(receivePlayer, allowDisabledPotionGrant)
            return true

        elseif purchaseId:match("LimitedPack") then
			Knit.GetService("LimitedPackService"):GivePack(receivePlayer, purchaseId, allowDisabledPotionGrant)
            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true
            return true
        end
    --[[ EventButton 相关购买逻辑已禁用
    elseif purchaseType == "Event" then
        if purchaseId == Constants.PURCHASE_ID.EVENT_PACK_SMALL or purchaseId == Constants.PURCHASE_ID.EVENT_PACK_LARGE then
            local amount = PurchaseDataHelper.GetBuyNum(purchaseId)
            PlayerDataService:AdjustEventRewardAmount(receivePlayer, amount)
            return true
        end
    ]]

    elseif purchaseType == "Skip" then
        if purchaseId == Constants.PURCHASE_ID.SKIP_ONLINE_REWARDS then
            Knit.GetService("OnlineRewardService"):SkipOnlineRewards(receivePlayer)
            return true

        elseif purchaseId == Constants.PURCHASE_ID.SKIP_REBIRTH_FIRST_TIME then
            if receivePlayerData.LimitedPurchaseHistory[purchaseId] then return end
            receivePlayerData.LimitedPurchaseHistory[purchaseId] = true
            self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)

            return Knit.GetService("RebirthService"):SkipRebirth(receivePlayer, true)

        elseif purchaseId == Constants.PURCHASE_ID.SKIP_REBIRTH then
            return Knit.GetService("RebirthService"):SkipRebirth(receivePlayer, true)

        elseif purchaseId == Constants.PURCHASE_ID.ONLINE_QUEST then
            return "Online quest purchase is disabled"
        end

    elseif purchaseType == "GiftBox" then
        local GiftBoxService = Knit.GetService("GiftBoxService")
        return GiftBoxService:OpenGiftBox(receivePlayer, purchaseId, allowDisabledPotionGrant)

    elseif purchaseType == "StorePack" then
        return "Store pack purchase is disabled"
        --[[ 临时禁用
        local StorePackService = Knit.GetService("StorePackService")
        StorePackService:GivePack(receivePlayer, purchaseId)

        self.Client.PurchaseLimitSuccess:Fire(receivePlayer, purchaseId)
        receivePlayerData.LimitedPurchaseHistory[purchaseId] = true

        return true
        ]]
    end

    return false
end

function PurchaseService:processReceipt(receiptInfo: Receipt)
    local paidEggs = Knit.GetService("PaidEggService")
    if paidEggs:IsProduct(receiptInfo.ProductId) then
        return if paidEggs:ProcessReceipt(receiptInfo)
            then Enum.ProductPurchaseDecision.PurchaseGranted
            else Enum.ProductPurchaseDecision.NotProcessedYet
    end
    if FishingBaitPurchases.GetRod(receiptInfo.ProductId) then
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
    -- Determine if the product was already granted by checking the data store
    local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
    local purchased = false
    local success, result, errorMessage
    success, errorMessage = pcall(function()
        purchased = purchaseHistoryStore:GetAsync(playerProductKey)
    end)

    -- If purchase was recorded, the product was already granted
    if success and purchased then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    elseif not success then
        error("Data store error:" .. errorMessage)
    end
    if PurchaseDataHelper.IsRetired(PurchaseDataHelper.GetPurchaseId(receiptInfo.ProductId)) then
        -- A retired product must not grant an entitlement or create a new order record.
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    -- Determine if the product was already granted by checking the data store 
    local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
    local success, isPurchaseRecorded = pcall(function()
        return purchaseHistoryStore:UpdateAsync(playerProductKey, function(alreadyPurchased)
            if alreadyPurchased then
                return true
            end

            -- Find the player who made the purchase in the server
            local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
            if not player then
                -- The player probably left the game
                -- If they come back, the callback will be called again
                return nil
            end

            local success, result = pcall(function()
                return self:HandlePurchase(player, receiptInfo.ProductId, nil, true)
            end)
            -- If granting the product failed, do NOT record the purchase in datastores.
            -- if not success or not result then
            if not success or result ~= true then
                -- error("Failed to process a product purchase for ProductId: " .. tostring(receiptInfo.ProductId) .. " Player: " .. tostring(player) .. " Error: " .. tostring(result))
                local geFailHistorysuccess, haveSendFailMessage = pcall(function()
                    return purchaseFailHistoryStore:GetAsync(playerProductKey)
                end)
                if geFailHistorysuccess then
                    if not haveSendFailMessage then
                        self.Client.PurchaseFail:Fire(player, result)
                        pcall(function()
                            purchaseFailHistoryStore:SetAsync(playerProductKey, true)
                        end)
                    end
                end
                
                return nil
            end

            -- Record the transcation in purchaseHistoryStore.
            return true
        end)
    end)
    
    if not success then
        error("Failed to process receipt due to data store error.")
        return Enum.ProductPurchaseDecision.NotProcessedYet
    elseif isPurchaseRecorded == nil then
        -- Didn't update the value in data store.
        return Enum.ProductPurchaseDecision.NotProcessedYet
    else
        local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
        -- self.Client.PurchaseSuccess:Fire(player, receiptInfo.ProductId)
        -- self.PurchaseSuccess:Fire(player, receiptInfo.ProductId)
        local purchaseId = PurchaseDataHelper.GetPurchaseId(receiptInfo.ProductId)
        local isHatch = PurchaseDataHelper.GetTypeByPurchaseId(purchaseId) == "Hatch"
        if not self._PlayerGifted[receiptInfo.PlayerId] then
            self.Client.PurchaseSuccess:Fire(player, receiptInfo.ProductId, not isHatch)
            self.PurchaseSuccess:Fire(player, receiptInfo.ProductId)
        else
            local giftedPlayer = Players:GetPlayerByUserId(self._PlayerGifted[receiptInfo.PlayerId])
            self.Client.PurchaseGiftSuccess:Fire(player, receiptInfo.ProductId)
            self.Client.ReceiveGiftSuccess:Fire(giftedPlayer, receiptInfo.ProductId, player.DisplayName)
        end

        local playerData = PlayerDataService:GetAllData(player)
        if playerData then
            playerData.RobuxSpent = playerData.RobuxSpent + PurchaseDataHelper.GetPrice(PurchaseDataHelper.GetPurchaseId(receiptInfo.ProductId))
            LogHelper.Print("RobuxSpent: " .. playerData.RobuxSpent)
        end

        HGAnalyticsService:LogPurchase(player, purchaseId)
         
        -- IMPORTANT: Tell Roblox that the game successfully handled the purchase
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end
end

function PurchaseService.Client:GetPolicyCache(player: Player) : {[string]: any}
    return self.Server:GetPolicyCache(player)
end

function PurchaseService:GetPolicyCache(player: Player) : {[string]: any}
    if not self._PlayerPolicyCache[player.UserId] then
        self._PlayerPolicyCache[player.UserId] = PolicyService:GetPolicyInfoForPlayerAsync(player)
    end
    return self._PlayerPolicyCache[player.UserId]
end

function PurchaseService:PromptPurchase(player: Player, purchaseId: string)
    if require(ReplicatedStorage.Modules.PaidEggConfig).Purchases[purchaseId] then
        local success, message = Knit.GetService("PaidEggService"):Prompt(player, purchaseId)
        if not success then
            self.Client.PromptPurchaseFail:Fire(player, message or "Purchase unavailable.")
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
	local productId = nil
    if self._PlayerGifted[player.UserId] then
        productId = PurchaseDataHelper.GetGiftProductId(purchaseId)
    else
        productId = PurchaseDataHelper.GetProductId(purchaseId)
    end
    if not productId then warn "productId not found!" return end

    if PurchaseDataHelper.GetType(productId) == "StorePack" then
        self.Client.PromptPurchaseFail:Fire(player, "Store pack purchase is disabled")
        return
    end

    if PurchaseDataHelper.GetType(productId) == "GamePass" then
        if self._PlayerGifted[player.UserId] then
            local giftedPlayer = Players:GetPlayerByUserId(self._PlayerGifted[player.UserId])
            local giftedPlayerData = PlayerDataService:GetAllData(giftedPlayer)
            if not giftedPlayerData then self.Client.PromptPurchaseFail:Fire(player, "Player not found!") return end
            if giftedPlayerData.GamePasses[purchaseId] then self.Client.PromptPurchaseFail:Fire(player, "Already owned!") return end
            MarketplaceService:PromptProductPurchase(player, productId)
        else
            local playerData = PlayerDataService:GetAllData(player)
            if playerData and playerData.GamePasses[purchaseId] then
                self.Client.PromptPurchaseFail:Fire(player, "Already owned!")
                return
            end
            MarketplaceService:PromptGamePassPurchase(player, productId)
        end
    else
        MarketplaceService:PromptProductPurchase(player, productId)
    end
end

function PurchaseService:KnitInit()
    LogHelper.Print("PurchaseService initialized")

    Players.PlayerAdded:Connect(function(player)
        self._PlayerPolicyCache[player.UserId] = PolicyService:GetPolicyInfoForPlayerAsync(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self._PlayerPolicyCache[player.UserId] = nil
        self._PlayerGifted[player.UserId] = nil
    end)

    self.Client.PromptPurchase:Connect(function(player: Player, purchaseId: string)
        self:PromptPurchase(player, purchaseId)
    end)
end

function PurchaseService:KnitStart()
    LogHelper.Print("PurchaseService started")

    -- handle developer product purchase
    MarketplaceService.ProcessReceipt = function(...)
        -- GameAnalytics:ProcessReceiptCallback(...)
        return self:processReceipt(...)
    end

    -- handle game pass purchase
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
        if not wasPurchased or PurchaseDataHelper.IsRetired(PurchaseDataHelper.GetPurchaseId(gamePassId)) then
            return
        end
        self:HandlePurchase(player, gamePassId)
        -- LogHelper.Print("PromptGamePassPurchaseFinished")
        self.Client.PurchaseSuccess:Fire(player, gamePassId)
        self.PurchaseSuccess:Fire(player, gamePassId)       -- for void service
    end)

    self.Client.TokensPurchase:Connect(function(player: Player, purchaseId: string)
        if PurchaseDataHelper.IsRetired(purchaseId) then
            self.Client.TokensPurchaseFail:Fire(player, "This item is no longer for sale.")
            return
        end
        local playerData = PlayerDataService:GetAllData(player)
        if not playerData then return end

        if playerData.Tokens < PurchaseDataHelper.GetPrice(purchaseId) then
            self.Client.TokensPurchaseFail:Fire(player, "Not enough tokens!")
            return
        end

        local purchaseResult = self:HandlePurchase(player, PurchaseDataHelper.GetProductId(purchaseId), false)
        if purchaseResult == true then
            PlayerDataService:AdjustTokens(player, -PurchaseDataHelper.GetPrice(purchaseId))
            self.Client.PurchaseSuccess:Fire(player, PurchaseDataHelper.GetProductId(purchaseId), true)
        else
            if type(purchaseResult) == "string" then
                self.Client.PurchaseFail:Fire(player, purchaseResult)
            else
                self.Client.PurchaseFail:Fire(player, "Purchase failed!")
            end
        end
        -- self.Client.PurchaseFail:Fire(player, "Currently unavailable, we are fixing it now.")
    end)

    self.Client.CancelGift:Connect(function(player: Player)
        self._PlayerGifted[player.UserId] = nil
    end)

    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
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
