-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local fishMutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").fishMutations
local calculateVipCoinMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "money-gain-utils").calculateVipCoinMultiplier
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local cashGamepassName, extraAquariumFishCapacityBonus, extraAquariumFishGamepassName = v1.cashGamepassName, v1.extraAquariumFishCapacityBonus, v1.extraAquariumFishGamepassName
local getActivePreLogoutMoneyMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pre-logout-buff-utils").getActivePreLogoutMoneyMultiplier

local function calculateAquariumFishCapacity(p1, p2) -- line: 14
    -- upvalues: extraAquariumFishCapacityBonus (copy), extraAquariumFishGamepassName (copy)
    local v2

    if p2 ~= nil then
        local function v3(p3) -- line: 19
            -- upvalues: extraAquariumFishGamepassName (copy)
            return p3.gamepassName == extraAquariumFishGamepassName
        end

        v2 = false

        for v4, v5 in p2 do
            local _ = v4 - 1

            if v5.gamepassName == extraAquariumFishGamepassName then
                v2 = true
                break
            end

            v2 = false
        end
    else
        v2 = p2
    end

    if v2 then
        return p1 + extraAquariumFishCapacityBonus
    end

    return p1
end

local function calculateTotalCashMultiplier(p4) -- line: 37
    -- upvalues: calculateVipCoinMultiplier (copy), cashGamepassName (copy)
    local v6 = calculateVipCoinMultiplier(p4)
    local v7

    if p4 then
        local function v8(p5) -- line: 43
            -- upvalues: cashGamepassName (copy)
            return p5.gamepassName == cashGamepassName
        end

        v7 = false

        for v9, v10 in p4 do
            local _ = v9 - 1

            if v10.gamepassName == cashGamepassName then
                v7 = true
                break
            end

            v7 = false
        end
    else
        v7 = p4
    end

    if v7 then
        v6 *= 2
    end

    return v6
end

local function calculateTotalCashMultiplierWithBuff(p6, p7, p8) -- line: 60
    -- upvalues: getActivePreLogoutMoneyMultiplier (copy), calculateTotalCashMultiplier (copy)
    return calculateTotalCashMultiplier(p6) * getActivePreLogoutMoneyMultiplier(p7, p8)
end

local function getLevelUpCost(p9, p10) -- line: 68
    return (math.floor(p9 * math.pow(1.5, p10 - 1)))
end

local function getScaledMoneyPerSecond(p11, p12) -- line: 72
    return (math.floor(p11 * math.pow(1.05, p12 - 1)))
end

local function getMutationMultiplier(p13) -- line: 76
    -- upvalues: fishMutations (copy)
    local n1 = 1

    for v15, v16 in fishMutations do
        if table.find(p13, v15) ~= nil then
            n1 += v16.mutationCashMultiplier - 1
        end
    end

    return n1
end

local function getMutatedMoneyPerSecond(p14, p15, p16) -- line: 87
    -- upvalues: getMutationMultiplier (copy)
    return (math.floor(math.floor(p14 * math.pow(1.05, p15 - 1)) * getMutationMultiplier(p16)))
end

local function getFishMoneyPerSecond(p17, p18, p19, p20) -- line: 96
    -- upvalues: calculateTotalCashMultiplier (copy), getMutationMultiplier (copy)
    return (math.floor(math.floor(math.floor(p17 * math.pow(1.05, p18 - 1)) * getMutationMultiplier(p19)) * calculateTotalCashMultiplier(p20)))
end

return {
    maxAquariumFishLevel = 50,
    cashGamepassMultiplier = 2,
    calculateAquariumFishCapacity = calculateAquariumFishCapacity,
    calculateTotalCashMultiplier = calculateTotalCashMultiplier,
    calculateTotalCashMultiplierWithBuff = calculateTotalCashMultiplierWithBuff,
    getLevelUpCost = getLevelUpCost,
    getScaledMoneyPerSecond = getScaledMoneyPerSecond,
    getMutationMultiplier = getMutationMultiplier,
    getMutatedMoneyPerSecond = getMutatedMoneyPerSecond,
    getFishMoneyPerSecond = getFishMoneyPerSecond,
    getFishMoneyPerSecondWithBuff = function(p21, p22, p23, p24, p25, p26) -- getFishMoneyPerSecondWithBuff | line: 99
        -- upvalues: getActivePreLogoutMoneyMultiplier (copy), calculateTotalCashMultiplier (copy), getMutationMultiplier (copy)
        return (math.floor(math.floor(math.floor(p21 * math.pow(1.05, p22 - 1)) * getMutationMultiplier(p23)) * (calculateTotalCashMultiplier(p24) * getActivePreLogoutMoneyMultiplier(p25, p26))))
    end
}
