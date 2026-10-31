-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local getFishMoneyPerSecondWithBuff = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getFishMoneyPerSecondWithBuff

local function showcaseFishToMpsInput(p1) -- line: 8
    return if p1 ~= nil then {
        fishId = p1.itemId,
        fishSpecies = p1.fishSpecies,
        level = p1.level,
        mutations = p1.mutations
    } else nil
end

local function getExclusiveFishEditionLabel(p2, p3) -- line: 19
    -- upvalues: getExclusiveFishConfigByFishName (copy)
    local v1 = getExclusiveFishConfigByFishName(p2)

    if not v1 then
        return nil
    end

    if v1.isUnlimitedIndexed then
        if p3 == nil then
            return "#?"
        end

        return (("#%*"):format(p3))
    end

    if v1.stock == nil then
        return nil
    end

    if p3 == nil then
        return (("#? / %*"):format(v1.stock))
    end

    return (("#%* / %*"):format(p3, v1.stock))
end

local getExclusiveFishMoneyPerSecondFromAquarium

local function getAquariumFishEffectiveMoneyPerSecond(p4, p5, p6, p7, p8, p9, p10) -- line: 33
    -- upvalues: getExclusiveFishConfigByFishName (copy), fishDataByName (copy), isFishData (copy), getFishMoneyPerSecondWithBuff (copy), getExclusiveFishMoneyPerSecondFromAquarium (ref)
    local v2 = if p8 == nil then 0 else p8
    local v3 = fishDataByName[p4.fishSpecies]

    if v3 and isFishData(v3) then
        if getExclusiveFishConfigByFishName(p4.fishSpecies) then
            return (getExclusiveFishMoneyPerSecondFromAquarium(p4.fishSpecies, p5, p6, p4.fishId, p7, v2, p9, p10))
        end

        return getFishMoneyPerSecondWithBuff(v3.moneyPerSecond, p4.level, p4.mutations, p6, p7, v2)
    end

    return 0
end

function getExclusiveFishMoneyPerSecondFromAquarium(p11, p12, p13, p14, p15, p16, p17, p18) -- line: 49
    -- upvalues: getExclusiveFishConfigByFishName (copy), fishDataByName (copy), isFishData (copy), getFishMoneyPerSecondWithBuff (copy)
    local v4 = if p16 == nil then 0 else p16
    local v5 = getExclusiveFishConfigByFishName(p11)

    if not v5 then
        return 0
    end

    local n1 = 0

    for _, v6 in p12 do
        if v6.fishId ~= p14 and not getExclusiveFishConfigByFishName(v6.fishSpecies) then
            local v7 = fishDataByName[v6.fishSpecies]

            if v7 and isFishData(v7) then
                n1 = math.max(n1, getFishMoneyPerSecondWithBuff(v7.moneyPerSecond, v6.level, v6.mutations, p13, p15, v4))
            end
        end
    end

    if p17 then
        for _, v9 in p17 do
            if v9.itemType == "fish" and not getExclusiveFishConfigByFishName(v9.itemName) then
                local v10 = fishDataByName[v9.itemName]

                if v10 and isFishData(v10) then
                    n1 = math.max(n1, getFishMoneyPerSecondWithBuff(v10.moneyPerSecond, v9.level, v9.mutations, p13, p15, v4))
                end
            end
        end
    end

    if p18 ~= nil and p18.fishId ~= p14 and getExclusiveFishConfigByFishName(p18.fishSpecies) == nil then
        local v11 = fishDataByName[p18.fishSpecies]

        if v11 ~= nil and isFishData(v11) then
            n1 = math.max(n1, getFishMoneyPerSecondWithBuff(v11.moneyPerSecond, p18.level, p18.mutations, p13, p15, v4))
        end
    end

    return (math.floor(n1 * v5.mpsMultiplier))
end

return {
    showcaseFishToMpsInput = showcaseFishToMpsInput,
    getExclusiveFishEditionLabel = getExclusiveFishEditionLabel,
    getAquariumFishEffectiveMoneyPerSecond = getAquariumFishEffectiveMoneyPerSecond,
    getExclusiveFishMoneyPerSecondFromAquarium = getExclusiveFishMoneyPerSecondFromAquarium
}
