-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local GameConfig = require(Parent.GameConfig)
local Fish = require(Parent.Data.Fish)
local Zones = require(Parent.Data.Zones)
local Variants = require(Parent.Data.Variants)
local Sizes = require(Parent.Data.Sizes)
local Baits = require(Parent.Data.Baits)
local Events = require(Parent.Data.Events)
local t1 = {}

function t1.zoneAt(p1) -- line: 13
    -- upvalues: GameConfig (copy), Zones (copy)
    local v4 = math.clamp(math.floor(p1 / GameConfig.ZONE_LENGTH) + 1, 1, #Zones.List)

    return Zones.List[v4]
end

t1.EVERYDAY_SLOTS = 5

function t1.everydayWeights(p2) -- line: 27
    -- upvalues: t1 (copy)
    local v5 = math.clamp(p2, 0, 1) * 3.8 + 1.2
    local t2 = {}
    local EVERYDAY_SLOTS = t1.EVERYDAY_SLOTS
    local n1 = 0

    for i = 1, EVERYDAY_SLOTS do
        t2[i] = math.exp(-(i - v5) ^ 2 / 1.4449999999999998)
        n1 += t2[i]
    end

    for i = 1, t1.EVERYDAY_SLOTS do
        t2[i] /= n1
    end

    return t2
end

function t1.species(p3, p4, p5, p6) -- line: 40
    -- upvalues: Fish (copy), t1 (copy)
    local v7 = Fish.ByZone[p3]
    local v8

    for _, v9 in ipairs(v7) do
        if not v9.slot or not (v9.slot <= t1.EVERYDAY_SLOTS) or v9.exclusive then
            if v9.odds <= 1 or p5:NextNumber() < math.min(1, p4 / v9.odds) then
                return v9
            end
        else
            v8 = v8 or {}
            v8[v9.slot] = v9
        end
    end

    if not v8 then
        return v7[#v7]
    end

    local v14 = t1.everydayWeights(p6 or 0.5)
    local v15 = p5:NextNumber()
    local EVERYDAY_SLOTS = t1.EVERYDAY_SLOTS
    local n2 = 0

    for i = 1, EVERYDAY_SLOTS do
        if v8[i] then
            n2 += v14[i]

            if v15 < n2 then
                return v8[i]
            end
        end
    end

    return v8[t1.EVERYDAY_SLOTS] or v7[#v7]
end

function t1.variant(p7) -- line: 68
    -- upvalues: Variants (copy)
    local t3 = {}

    for i = 2, #Variants.List do
        table.insert(t3, i)
    end

    table.sort(t3, function(p8, p9) -- line: 74
        -- upvalues: Variants (copy)
        return Variants.List[p8].odds > Variants.List[p9].odds
    end)

    for _, v16 in ipairs(t3) do
        if p7:NextNumber() < 1 / Variants.List[v16].odds then
            return v16
        end
    end

    return 1
end

function t1.size(p10, p11, p12) -- line: 89
    -- upvalues: Sizes (copy)
    local v17 = if type(p12) ~= "number" or not (p12 > 1) then 1 else p12

    if v17 > 1 then
        for i = #Sizes.List, 1, -1 do
            local v18 = Sizes.List[i]

            if i ~= Sizes.NORMAL_INDEX and p10:NextNumber() < (if p11 then v18.lucky else v18.chance) * v17 then
                return i
            end
        end
    else
        local v19 = p10:NextNumber()
        local n3 = 0

        for v20, v21 in ipairs(Sizes.List) do
            n3 += if p11 then v21.lucky else v21.chance

            if v19 < n3 then
                return v20
            end
        end

        if p11 then
            return 4
        end
    end

    return Sizes.NORMAL_INDEX
end

function t1.income(p13, p14, p15, p16, p17) -- line: 114
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy), Events (copy)
    local v22 = Fish.ById[p13]
    local v23 = Variants.List[p14] or Variants.List[1]
    local v24 = Sizes.List[p15] or Sizes.List[Sizes.NORMAL_INDEX]

    if not v22 then
        return 0
    end

    local v25 = p16 and Events.ById[p16]

    return (p17 or v22.income) * v23.mult * v24.mult * (if v25 then v25.mult else 1)
end

function t1.sellValue(p18, p19, p20, p21, p22) -- line: 125
    -- upvalues: GameConfig (copy), t1 (copy)
    return t1.income(p18, p19, p20, p21, p22) * GameConfig.SELL_MULTIPLIER
end

function t1.incomeOf(p23) -- line: 130
    -- upvalues: t1 (copy)
    return t1.income(p23.id, p23.v, p23.s, p23.e, p23.b)
end

function t1.sellOf(p24) -- line: 133
    -- upvalues: t1 (copy)
    return t1.sellValue(p24.id, p24.v, p24.s, p24.e, p24.b)
end

function t1.bestIncome(p25, p26) -- line: 138
    -- upvalues: t1 (copy)
    local v26 = p26 or 0

    for _, v27 in ipairs(p25) do
        for _, v29 in ipairs(v27) do
            v26 = math.max(v26, t1.incomeOf(v29))
        end
    end

    return v26
end

function t1.combinedOdds(p27, p28, p29) -- line: 149
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy)
    local v30 = Fish.ById[p27]
    local v31 = Variants.List[p28]
    local v32 = Sizes.List[p29]
    local v33 = if p29 == Sizes.NORMAL_INDEX then 1 else 1 / v32.chance

    return (math.max(1, (math.floor(v30.odds * v31.odds * v33 + 0.5))))
end

local t4 = {
    Gold = 1,
    Ruby = 1,
    Emerald = 1,
    Diamond = 2,
    Rainbow = 3,
    Void = 4
}
local t5 = {
    0, 0, 0, 1, 1, 2, 2, 3,
    3, 4, 4, 4
}

function t1.thrill(p30, p31, p32) -- line: 166
    -- upvalues: Fish (copy), Variants (copy), t4 (copy), t5 (copy)
    local v36 = Fish.ById[p30]
    local v37 = 0

    if v36 then
        local v38 = Fish.ByZone[v36.zone] or {}
        local v39 = table.find(v38, v36) or #v38
        local n4 = 0

        for _, v40 in ipairs(v38) do
            if v40.endgame then
                n4 += 1
            end
        end

        if n4 > 0 and not v36.endgame then
            v39 = v39 - n4 + 1
        end

        v37 = if v36.endgame then 4
            elseif v36.exclusive then math.clamp((v36.slot or 1) - 2, 0, 4)
            elseif v39 == 1 then 4
            elseif v39 <= 3 then 3
            elseif v36.slot then if v36.slot >= 6 then 2 elseif v36.slot >= 4 then 1 else 0
            elseif v39 == 4 then 2
            elseif v39 == 5 then 1
            else 0
    end

    local v42 = Variants.List[p31]
    local v43

    if v42 then
        v43 = t4[v42.id]
        v43 = v43 or 0
    else
        v43 = 0
    end

    local v44 = t5[p32] or 0
    local v45 = math.max(v37, v43, v44)

    if (if v37 >= 2 then 1 else 0) + (if v43 >= 2 then 1 else 0) + (if v44 >= 2 then 1 else 0) >= 2 then
        v45 += 1
    end

    return (math.clamp(v45, 0, 4))
end

function t1.legend(p33) -- line: 209
    -- upvalues: Fish (copy)
    local v46 = Fish.ById[p33]

    return v46 and v46.endgame or 0
end

function t1.catch(p34, p35) -- line: 216
    -- upvalues: GameConfig (copy), Fish (copy), Variants (copy), Sizes (copy), Baits (copy), t1 (copy)
    local v49 = math.clamp(math.floor(p34.meterBonus or 1), GameConfig.METER_MIN, GameConfig.METER_MAX)
    local v51 = math.max(0, p34.castPower or GameConfig.START_CAST_POWER) + v49
    local v52 = GameConfig.distanceForPower(v51)
    local v53 = t1.zoneAt(v52)
    local v54 = Baits.ById[p34.baitId] or Baits.List[1]
    local v55 = GameConfig.luckForDistance(v52)
    local v57 = math.clamp(p34.pity or 0, 0, GameConfig.PITY_MAX_STACKS)
    local v58 = v55 * (tonumber(p34.baitLuck) or v54.luck) * (1 + v57 * GameConfig.PITY_STEP) * (p34.luckBoost or 1) * (if p34.luckyCast == true then GameConfig.LUCKY_CAST_LUCK else 1)
    local v59 = if p34.luckyCast == true then 1 else math.clamp(v52 / GameConfig.ZONE_LENGTH - (v53.index - 1), 0, 1)
    local v61 = p34.forceFish and Fish.ById[p34.forceFish] or t1.species(v53.id, v58, p35, v59)
    local v62 = t1.variant(p35)

    if p34.forceVariant and Variants.List[p34.forceVariant] then
        v62 = p34.forceVariant
    end

    local v63 = t1.size(p35, p34.luckyCast == true, p34.sizeLuck)

    if p34.forceSize and Sizes.List[p34.forceSize] then
        v63 = p34.forceSize
    end

    local v64 = Sizes.List[v63]
    local v66 = math.floor((v61.kg[1] + (v61.kg[2] - v61.kg[1]) * p35:NextNumber()) * v64.mult ^ 2 * 100 + 0.5) / 100

    return {
        power = v51,
        meterBonus = v49,
        distance = v52,
        zoneIndex = v53.index,
        zoneId = v53.id,
        zoneProgress = v59,
        distanceLuck = v55,
        luck = v58,
        fishId = v61.id,
        rarity = v61.rarity,
        variant = v62,
        size = v63,
        kg = v66,
        income = t1.income(v61.id, v62, v63),
        odds = t1.combinedOdds(v61.id, v62, v63),
        isFallback = v61.odds <= 1,
        lucky = p34.luckyCast == true
    }
end

return t1
