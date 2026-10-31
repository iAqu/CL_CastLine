-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmCombinedCaps, getEquippedCharmCore = v1.charmCombinedCaps, v1.getEquippedCharmCore
local getBaitAuraBuffBonuses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils").getBaitAuraBuffBonuses
local resolveCombinedPlayerBuffBonuses

local function getPlayerBuffBonuses(p1, p2) -- line: 9
    -- upvalues: getEquippedCharmCore (copy), resolveCombinedPlayerBuffBonuses (ref)
    local v2 = p1.playerData.baitAuras[p2]

    if v2 ~= nil then
        v2 = v2.slots[v2.equippedSlotIndex + 1]
    end

    local v3 = p1.playerData.charms[p2]
    local resolveCombinedPlayerBuffBonuses2 = resolveCombinedPlayerBuffBonuses

    if v2 == nil or v2 == "" then
        v2 = nil
    end

    return resolveCombinedPlayerBuffBonuses2(v2, if v3 == nil then nil else getEquippedCharmCore(v3.charmCoresByTier, v3.equippedCharmId))
end

function resolveCombinedPlayerBuffBonuses(p3, p4) -- line: 23
    -- upvalues: charmCombinedCaps (copy), getBaitAuraBuffBonuses (copy)
    local v4 = table.clone(getBaitAuraBuffBonuses(p3))

    setmetatable(v4, nil)

    if p4 then
        v4.trainingPower += p4.trainingPower

        for _, v5 in p4.affixes do
            local attributeId = v5.attributeId

            if attributeId == "aquariumIncome" then
                v4.aquariumIncome += v5.value
            elseif attributeId == "bonusLuck" then
                v4.bonusLuck += v5.value
            elseif attributeId == "bossFishDamage" then
                v4.bossDamage += v5.value
            elseif attributeId == "bossFishQteSize" then
                v4.bossQteSize += v5.value
            elseif attributeId == "championMutationChance" then
                v4.championMutationChance += v5.value
            elseif attributeId == "baitHopDistance" then
                v4.hopDistance += v5.value
            elseif attributeId == "shopDiscount" then
                v4.moneyDiscount += v5.value
            elseif attributeId == "mutationLuck" then
                v4.mutationLuck += v5.value
            elseif attributeId == "weatherMutationLuck" then
                v4.weatherMutationLuck += v5.value
            end
        end

        v4.aquariumIncome = math.min(v4.aquariumIncome, charmCombinedCaps.aquariumIncome)
        v4.bonusLuck = math.min(v4.bonusLuck, charmCombinedCaps.bonusLuck)
        v4.bossDamage = math.min(v4.bossDamage, charmCombinedCaps.bossFishDamage)
        v4.championMutationChance = math.min(v4.championMutationChance, charmCombinedCaps.championMutationChance)
        v4.hopDistance = math.min(v4.hopDistance, charmCombinedCaps.baitHopDistance)
        v4.moneyDiscount = math.min(v4.moneyDiscount, charmCombinedCaps.shopDiscount)
        v4.mutationLuck = math.min(v4.mutationLuck, charmCombinedCaps.mutationLuck)
        v4.bossQteSize = math.min(v4.bossQteSize, charmCombinedCaps.bossFishQteSize)
        v4.trainingPower = math.min(v4.trainingPower, charmCombinedCaps.trainingPower)
        v4.weatherMutationLuck = math.min(v4.weatherMutationLuck, charmCombinedCaps.weatherMutationLuck)
    end

    return v4
end

return {
    getPlayerBuffBonuses = getPlayerBuffBonuses,
    resolveCombinedPlayerBuffBonuses = resolveCombinedPlayerBuffBonuses
}
