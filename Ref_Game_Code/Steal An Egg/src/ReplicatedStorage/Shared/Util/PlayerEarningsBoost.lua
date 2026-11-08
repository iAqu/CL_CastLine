-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local t1 = {}
local v1 = t1

t1.DURATION_SECONDS = 900
t1.EXPIRES_AT_ATTRIBUTE = "EarningsBoostExpiresAt"
t1.BONUS_MULTIPLIER_ATTRIBUTE = "EarningsBonusMultiplier"
t1.BONUS_EXPIRES_AT_ATTRIBUTE = "EarningsBonusExpiresAt"

function t1.GetConfiguredMultiplier() -- line: 24
    -- upvalues: BossMasteryFlags (copy)
    return BossMasteryFlags.CashBoosterMultiplier:Get()
end

function t1.GetRemainingSecondsFromExpiry(p1, p2) -- line: 28
    -- upvalues: Workspace (copy)
    if typeof(p1) ~= "number" then
        return 0
    end

    return (math.max(0, p1 - (p2 or Workspace:GetServerTimeNow())))
end

local function GetRemainingSeconds(p3, p4) -- line: 36
    -- upvalues: v1 (ref)
    if p3 == nil then
        return 0
    end

    return v1.GetRemainingSecondsFromExpiry(p3:GetAttribute("EarningsBoostExpiresAt"), p4)
end

local v3 = v1

v3.GetRemainingSeconds = GetRemainingSeconds

function v3.GetBonus(p5, p6) -- line: 48
    -- upvalues: v1 (ref)
    if p5 == nil then
        return 1, 0
    end

    local EarningsBonusMultiplier = p5:GetAttribute("EarningsBonusMultiplier")
    local v4 = v1.GetRemainingSecondsFromExpiry(p5:GetAttribute("EarningsBonusExpiresAt"), p6)

    if type(EarningsBonusMultiplier) ~= "number" or v4 <= 0 then
        return 1, 0
    end

    return EarningsBonusMultiplier, v4
end

function v3.GetActive(p7, p8) -- line: 61
    -- upvalues: v1 (ref)
    local v5 = v1.GetRemainingSeconds(p7, p8)
    local v6 = if v5 > 0 then v1.GetConfiguredMultiplier() else 1
    local v7, v8 = v1.GetBonus(p7, p8)

    if v6 < v7 then
        return v7, v8
    end

    return v6, v5
end

function v3.GetMultiplier(p9) -- line: 71
    -- upvalues: v1 (ref)
    return (v1.GetActive(p9))
end

function v3.GetChangedSignal(p10) -- line: 75
    return p10:GetAttributeChangedSignal("EarningsBoostExpiresAt")
end

v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.PlayerEarningsBoost", v1, {
    MULTIPLIER = true,
    DURATION_SECONDS = true
}, false)

return v1
