local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionService = require(ServerScriptService.Services.PotionService)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)

local RandomPotionService = Knit.CreateService {
    Name = "RandomPotionService",
    Client = {
        -- client -> server
        BuyPotionEvent = Knit.CreateSignal(),

        -- server -> client
        BuyPotionResultEvent = Knit.CreateSignal(),
        UpdateRandomPotionBuyLogEvent = Knit.CreateSignal(),
    },
}

local function isValidPurchaseCount(buyNum: unknown): boolean
	return typeof(buyNum) == "number"
		and buyNum == buyNum
		and buyNum ~= math.huge
		and buyNum ~= -math.huge
		and buyNum > 0
		and buyNum % 1 == 0
end

local function buyPotion(player: Player, buyNum: number)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		RandomPotionService.Client.BuyPotionResultEvent:Fire(player, false, PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE)
		return
	end
	if not isValidPurchaseCount(buyNum) then
		RandomPotionService.Client.BuyPotionResultEvent:Fire(player, false, "Invalid purchase quantity")
		return
	end
	local playerData = PlayerDataService:GetAllData(player)
    if not playerData then warn("No player data found!") return end

    -- local potionBoughtNum = 0
    -- if playerData.RandomPotionBuyLog then
    --     potionBoughtNum = #TableUtil.Values(playerData.RandomPotionBuyLog)
    -- end
    local potionBoughtNum = #playerData.RandomPotionBuyLog

    local remainingPurchaseCount = Constants.MAX_RANDOM_POTION_BUY_NUM - potionBoughtNum
    if buyNum > remainingPurchaseCount then
        RandomPotionService.Client.BuyPotionResultEvent:Fire(player, false, "Purchase limit reached")
        return
    end

    local totalPrice = buyNum * Constants.RANDOM_POTION_PRICE
    -- if playerData.Wins < totalPrice then
    if playerData.Diamonds < totalPrice then
        RandomPotionService.Client.BuyPotionResultEvent:Fire(player, false, "Not enough diamonds")
        return
    end

    -- local costSuccess = PlayerDataService:AdjustWins(player, -totalPrice)
    local costSuccess = PlayerDataService:AdjustDiamonds(player, -totalPrice)
    if not costSuccess then
        warn("RandomPotionService:buyPotion: can't cost diamonds")
        return
    end

    for i = 1, buyNum do
        local randomPotionId = Constants.POTION_IDS[math.random(1, #Constants.POTION_IDS)]
        PotionService:AdjustPotionCount(player, randomPotionId, 1)
        -- playerData.RandomPotionBuyLog[randomPotionId] = os.time()
        table.insert(playerData.RandomPotionBuyLog, randomPotionId)
        local potionName = PurchaseDataHelper.GetName(randomPotionId)
        local notificationText = Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", potionName)
        RandomPotionService.Client.BuyPotionResultEvent:Fire(player, true, notificationText)
    end

    RandomPotionService.Client.UpdateRandomPotionBuyLogEvent:Fire(player, playerData.RandomPotionBuyLog)
end

local function resetRandomPotionBuyLog()
    for _, player in Players:GetPlayers() do
        local playerData = PlayerDataService:GetAllData(player)
        if not playerData then warn("No player data found!") continue end

        playerData.RandomPotionBuyLog = {}
        RandomPotionService.Client.UpdateRandomPotionBuyLogEvent:Fire(player, playerData.RandomPotionBuyLog)
    end
end

function RandomPotionService:KnitInit()
end

function RandomPotionService:KnitStart()
    self.Client.BuyPotionEvent:Connect(function(player: Player, buyNum: number)
       buyPotion(player, buyNum)
    end)

    Timer.Simple(Constants.RANDOM_POTION_BUY_COOLDOWN, function()
        resetRandomPotionBuyLog()
        LogHelper.Print("Reset random potion buy log")
    end)
end


return RandomPotionService
