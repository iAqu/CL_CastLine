-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local vipGamepassName = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils").vipGamepassName
local calculateBonusBonus

local function calculateBonusMultiplier(p1, p2) -- line: 15
    -- upvalues: calculateBonusBonus (ref)
    return 1 + calculateBonusBonus(p1, p2)
end

function calculateBonusBonus(p3, p4) -- line: 18
    return (if p3 then 0.15 else 0) + p4 * 5 / 100
end

local calculateVipCoinMultiplier

local function calculateMoneyGain(p5, p6) -- line: 35
    -- upvalues: calculateVipCoinMultiplier (ref)
    return (math.floor(math.max(1, p5) * calculateVipCoinMultiplier(p6)))
end

function calculateVipCoinMultiplier(p7) -- line: 47
    -- upvalues: vipGamepassName (copy)
    if not p7 or #p7 == 0 then
        return 1
    end

    local function v2(p8) -- line: 53
        -- upvalues: vipGamepassName (copy)
        return p8.gamepassName == vipGamepassName
    end

    local v3 = false

    for v4, v5 in p7 do
        local _ = v4 - 1

        if v5.gamepassName == vipGamepassName then
            v3 = true
            break
        end
    end

    if v3 then
        return 1.5
    end

    return 1
end

return {
    premiumMoneyBonusPercent = 15,
    friendMoneyBonusPerFriend = 5,
    vipCoinMultiplier = 1.5,
    calculateBonusMultiplier = calculateBonusMultiplier,
    calculateBonusBonus = calculateBonusBonus,
    calculateMoneyGain = calculateMoneyGain,
    calculateVipCoinMultiplier = calculateVipCoinMultiplier
}
