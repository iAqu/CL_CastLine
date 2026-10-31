-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local hoolaSystemConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "hoola-system-config").hoolaSystemConfig

local function isHoolaMutationName(p1) -- line: 4
    if p1 == "hoola1" or p1 == "hoola2" then
        return true
    end

    return p1 == "hoola3"
end

local function getMaximumSurfScore(p2) -- line: 7
    local v2 = math.max(0, (math.floor(p2)))

    return v2 * (v2 + 9)
end

local function getSurfScoreForRing(p3) -- line: 12
    return math.max(0, math.floor(p3) - 1) * 2 + 10
end

local function getHoolaTierThreeChance(p4) -- line: 16
    -- upvalues: hoolaSystemConfig (copy)
    local v5 = math.max(0, p4 * hoolaSystemConfig.tierThreeWeightPerCombo)
    local v6 = hoolaSystemConfig.tierOneWeight + hoolaSystemConfig.tierTwoWeight + v5

    if v6 > 0 then
        return v5 / v6
    end

    return 0
end

local function getHoolaAcquisitionChance(p5, p6) -- line: 22
    -- upvalues: hoolaSystemConfig (copy)
    local v8 = math.max(0, (math.floor(p6)))
    local v9 = v8 * (v8 + 9)

    if v9 <= 0 then
        return 0
    end

    return (math.clamp(math.max(0, p5) / v9 * hoolaSystemConfig.acquisitionChanceCap, 0, hoolaSystemConfig.acquisitionChanceCap))
end

local rollHoolaTierWithDetails

local function rollHoolaTier(p7, p8, p9, p10) -- line: 30
    -- upvalues: rollHoolaTierWithDetails (ref)
    local v11 = if p10 == nil then math.random else p10

    return rollHoolaTierWithDetails(p7, p8, p9, v11).hoolaMutation
end

function rollHoolaTierWithDetails(p11, p12, p13, p14, p15) -- line: 36
    -- upvalues: hoolaSystemConfig (copy)
    local v12 = if p14 == nil then math.random else p14
    local v13 = p15 ~= nil and p15
    local v15 = math.max(0, (math.floor(p13)))
    local v16 = v15 * (v15 + 9)
    local v17 = if v16 <= 0 then 0 else math.clamp(math.max(0, p11) / v16 * hoolaSystemConfig.acquisitionChanceCap, 0, hoolaSystemConfig.acquisitionChanceCap)
    local v19 = if v13 then nil else v12()
    local v21 = math.max(0, p12 * hoolaSystemConfig.tierThreeWeightPerCombo)
    local v22 = hoolaSystemConfig.tierOneWeight + hoolaSystemConfig.tierTwoWeight
    local v23 = v22 + v21
    local v24 = if v23 > 0 then hoolaSystemConfig.tierOneWeight / v23 else 0
    local v25 = if v23 > 0 then v21 / v23 else 0
    local t1 = {
        hoolaMutation = nil,
        lowerTierRoll = nil,
        tierThreeRoll = nil,
        acquisitionChance = v17,
        acquisitionRoll = v19,
        acquisitionWasForced = v13,
        lowerTierOneChance = v24,
        tierThreeChance = v25
    }

    if hoolaSystemConfig.enabled then
        if not v13 and (v19 == nil or v17 <= v19) then
            return t1
        end

        t1.tierThreeRoll = v12()

        if t1.tierThreeRoll < v25 then
            t1.hoolaMutation = "hoola3"
        elseif not (v22 <= 0) then
            t1.lowerTierRoll = v12()
            t1.hoolaMutation = t1.lowerTierRoll < v24 and "hoola1" or "hoola2"
        end
    end

    return t1
end

return {
    isHoolaMutationName = isHoolaMutationName,
    getMaximumSurfScore = getMaximumSurfScore,
    getSurfScoreForRing = getSurfScoreForRing,
    getHoolaTierThreeChance = getHoolaTierThreeChance,
    getHoolaAcquisitionChance = getHoolaAcquisitionChance,
    rollHoolaTier = rollHoolaTier,
    rollHoolaTierWithDetails = rollHoolaTierWithDetails
}
