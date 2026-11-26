local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local RebirthDataHelper = require(ReplicatedFirst.DataHelpers.RebirthDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GameDataUtil = require(ReplicatedStorage.Modules.GameDataUtil)
local RebirthUpgradesDataHelper = require(ReplicatedFirst.DataHelpers.RebirthUpgradesDataHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)

local RebirthService = Knit.CreateService {
    Name = "RebirthService",
    Client = {
        -- server <-> client
        -- SuperRebirthUpgrade = Knit.CreateSignal(),
    },
}

function RebirthService.Client:Rebirth(player: Player): string
    return self.Server:Rebirth(player)
end

function RebirthService:Rebirth(player: Player): string
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return "No Profile!" end

    local currentRebirth = profile.Data.Rebirths
    local nextRebirth = currentRebirth + 1
    local cost = RebirthDataHelper.GetRebirthCost(nextRebirth)
    if not cost then warn("Rebirth.Rebirth: 超过最大重生次数") return end

    -- local canAfford = profile.Data.Wins >= cost
    local canAfford = profile.Data.Strength >= cost
    if not canAfford then return "Not enough strength!" end

    PlayerDataService:AdjustRebirths(player, 1)
    PlayerDataService:AdjustStrength(player, -profile.Data.Strength)
    PlayerDataService:AdjustStrength(player, 0)   -- add 100 strength (min strength)
    -- PlayerDataService:AdjustWins(player, -cost)
    return Constants.NOTIFICATION.REBIRTH_SUCCESS:gsub("{amount}", nextRebirth)
end

function RebirthService:SkipRebirth(player: Player): boolean
    local profile = PlayerDataService:GetProfile(player)
    if not profile then warn("No Profile!") return end

    local currentRebirth = profile.Data.Rebirths
    if not RebirthDataHelper.GetRebirthData(currentRebirth + 1) then warn("More than max rebirths!") return end

    return PlayerDataService:AdjustRebirths(player, 1)
end

function RebirthService.Client:SuperRebirth(player: Player): (boolean, string)
    return self.Server:SuperRebirth(player, 1)
end

function RebirthService:SuperRebirth(player: Player, amount: number?): (boolean, string)
    amount = if amount then amount else 1

    local profile = PlayerDataService:GetProfile(player)
    if not profile then return false, "No Profile!" end

    -- local rebirthRequired = 31 + profile.Data.SuperRebirths   -- super rebirth require +1 after each super rebirth
    local rebirthRequired = GameDataUtil.CalculateSuperRebirtRequired(profile.Data.SuperRebirths + 1)
    if profile.Data.Rebirths < rebirthRequired then return false, "Not enough rebirths!" end


    PlayerDataService:AdjustSuperRebirths(player, 1)
    PlayerDataService:AdjustRebirths(player, -profile.Data.Rebirths)
    PlayerDataService:AdjustStrength(player, -profile.Data.Strength)
    PlayerDataService:AdjustWins(player, -profile.Data.Wins)
    PlayerDataService:AdjustSuperRebirthTokens(player, 1)

    Knit.GetService("AreaService"):ResetAreas(player)

    return true, Constants.NOTIFICATION.SUPER_REBIRTH_SUCCESS
end

function RebirthService.Client:SuperRebirthUpgrade(player: Player, upgradeId: string): (boolean, string)
    return self.Server:SuperRebirthUpgrade(player, upgradeId)
end

function RebirthService:SuperRebirthUpgrade(player: Player, upgradeId: string)
    local profile = PlayerDataService:GetProfile(player)
    if not profile then warn("No profile found!") return end

    local currentUpgradeLevel = profile.Data.RebirthUpgrades[upgradeId] or 0
    if RebirthUpgradesDataHelper.GetMaxLevel(upgradeId) ~= 0
    and currentUpgradeLevel >= RebirthUpgradesDataHelper.GetMaxLevel(upgradeId) then 
        -- self.Client.SuperRebirthUpgrade:Fire(player, upgradeId, false, "Max level reached")
        return false, "Max level reached"
    end

    local price = RebirthUpgradesDataHelper.GetPrice(upgradeId, currentUpgradeLevel + 1)
    if profile.Data.SuperRebirthTokens < price then
        -- self.Client.SuperRebirthUpgrade:Fire(player, upgradeId, false, "Not enough stars")
        return false, "Not enough stars"
    end

    -- profile.Data.SuperRebirthUpgrade[upgradeId] += 1
    PlayerDataService:AdjustSuperRebirthTokens(player, -price)
    PlayerDataService:AdjustSuperRebirthUpgrade(player, upgradeId, 1)
    if upgradeId == Constants.SUPER_REBIRTH_UPGRADE_ID.DIAMONDS then
        PlayerDataService:AdjustDiamonds(player, RebirthUpgradesDataHelper.GetBoostValue(upgradeId))
    end

    -- self.Client.Upgrade:Fire(player, upgradeId, true, "Upgraded to level " .. newUpgradeLevel)
    return true, "Upgrade success!"
end

function RebirthService:KnitInit()
    LogHelper.Print("RebirthService initialized")
end

function RebirthService:KnitStart()
    LogHelper.Print("RebirthService started")
end

return RebirthService
