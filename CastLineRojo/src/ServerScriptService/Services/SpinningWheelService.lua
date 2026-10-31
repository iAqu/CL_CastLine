local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionService = require(ServerScriptService.Services.PotionService)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

local SpinningWheelService = Knit.CreateService {
    Name = "SpinningWheelService",
    Client = {
        UpdateSpinningWheelCount = Knit.CreateSignal(),
    },
}

function SpinningWheelService.Client:StartSpin(player: Player): {resultIndex: number, resultText: string}
    return SpinningWheelService:StartSpin(player)
end

local function hasFreeSpin(profile): boolean
    return os.time() - profile.Data.SpinningWheelLastCheckTime >= Constants.SPINNING_WHEEL_TIME
end

function SpinningWheelService:AdjustSpinNum(player: Player, num: number): boolean
    local profile = PlayerDataService:GetProfile(player)
    if not profile then warn "No profile found!" return end

    profile.Data.SpinningWheelBonusSpins += num
    self.Client.UpdateSpinningWheelCount:Fire(player, profile.Data.SpinningWheelLastCheckTime, profile.Data.SpinningWheelBonusSpins)
    return true
end

function SpinningWheelService:StartSpin(player: Player) : {resultIndex: number, resultText: string}
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return {resultIndex = 0, resultText = PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE}
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile then warn "No profile found!" return end

    local hasBonusSpin = profile.Data.SpinningWheelBonusSpins > 0
    if not hasBonusSpin and not hasFreeSpin(profile) then
        return {resultIndex = 0, resultText = "No more spinning wheel!"}
    end

    local itemList = {}
    local totalWeight = 0
    for index, weight in pairs(Constants.SPINNING_WHEEL_CHANCE) do
        totalWeight += weight
        table.insert(itemList, {
            INDEX = index,
            WEIGHT = weight,
        })
    end

    table.sort(itemList, function(a, b) return a.WEIGHT < b.WEIGHT end)

    local randomNum = math.random(1, totalWeight)
    local count = 0
    local finalItemIndex = nil
    for _, itemInfo in ipairs(itemList) do
        count += itemInfo.WEIGHT
        if randomNum <= count then
            finalItemIndex = itemInfo.INDEX
            break
        end
    end

    if not finalItemIndex then warn("No final item index!") return end

    local resultText = nil
    if finalItemIndex == 1 then
		PotionService:AdjustPotionCount(player, Constants.POTION_ID.DOUBLE_WINS, 2)
		resultText = Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", 2):gsub("#POTION", "Double Wins")

    elseif finalItemIndex == 2 then
        -- PlayerDataService:AdjustDiamonds(player, 5)
        -- resultText = Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", 5)
        PlayerDataService:AdjustWins(player, 500)
        resultText = Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", 500)

    elseif finalItemIndex == 3 then
		PotionService:AdjustPotionCount(player, Constants.POTION_ID.DOUBLE_EXP, 1)
		resultText = Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", 1):gsub("#POTION", "Double Exp")

    elseif finalItemIndex == 4 then
        -- PlayerDataService:AdjustDiamonds(player, 25)
        -- resultText = Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", 25)
        PlayerDataService:AdjustWins(player, 25000)
        resultText = Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", 25000)

    elseif finalItemIndex == 5 then
        PlayerDataService:AdjustWins(player, 100000)
        resultText = Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", 100000)

    else
        warn("Invalid final item index!")
        return
    end

    if hasBonusSpin then
        profile.Data.SpinningWheelBonusSpins -= 1
    else
        profile.Data.SpinningWheelLastCheckTime = os.time()
    end
    self.Client.UpdateSpinningWheelCount:Fire(player, profile.Data.SpinningWheelLastCheckTime, profile.Data.SpinningWheelBonusSpins)
    return {resultIndex = finalItemIndex, resultText = resultText}
end

function SpinningWheelService:KnitInit()
end

function SpinningWheelService:KnitStart()
    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        if playerData.SpinningWheelLastCheckTime == nil then
            -- playerData.SpinningWheelNum = 1
            playerData.SpinningWheelLastCheckTime = os.time() - Constants.SPINNING_WHEEL_TIME
        end
    end)
end

return SpinningWheelService
