-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    1, 2, 3, 4, 5
}
local t2 = {
    "1",
    "2",
    "3",
    "4",
    "5"
}

local function getCharmTierKey(p1) -- line: 16
    -- upvalues: t2 (copy)
    return t2[p1]
end

local function isMajorCharmCandidate(p2) -- line: 20
    if #p2.affixes + 1 >= 5 then
        return true
    end

    return p2.overallPercentile >= 0.95
end

local function shouldBroadcastCharmCandidate(p3) -- line: 23
    if p3.tierId == 5 then
        return p3.overallPercentile >= 0.99
    end

    return false
end

local t3 = {
    {
        charmDisplayAttachmentName = "Attachment",
        cost = 2.5E+07,
        defaultVisualId = "pearlfinPup",
        displayName = "Pearlfin Pup",
        randomLineCount = 1,
        rebirthRequirement = 2,
        tierId = 1,
        trainingPower = 0.05,
        previewCharmScale = 1.5,
        charmModelPath = { "Charms", "Charm_PearlfinPup_02" },
        podiumModelPath = { "Charms", "Podium", "Charm_PearlfinExhibition" }
    },
    {
        charmDisplayAttachmentName = "Attachment",
        cost = 2.5E+08,
        defaultVisualId = "diamondShark",
        displayName = "Diamond Shark",
        randomLineCount = 2,
        rebirthRequirement = 4,
        tierId = 2,
        trainingPower = 0.08,
        previewCharmScale = 1,
        charmModelPath = { "Charms", "Charm_Shark_02" },
        podiumModelPath = { "Charms", "Podium", "Charm_SharkExhibition" }
    },
    {
        charmDisplayAttachmentName = "Attachment",
        cost = 2.5E+09,
        defaultVisualId = "prismaticMegalodon",
        displayName = "Prismatic Megalodon",
        randomLineCount = 3,
        rebirthRequirement = 6,
        tierId = 3,
        trainingPower = 0.12,
        previewCharmScale = 1,
        charmModelPath = { "Charms", "Charm_PrismaticMegalodon" },
        podiumModelPath = { "Charms", "Podium", "Charm_PrismaticMegalodonExhibition" }
    },
    {
        charmDisplayAttachmentName = "Attachment",
        cost = 2.5E+10,
        defaultVisualId = "astralLeviathan",
        displayName = "Astral Leviathan",
        randomLineCount = 3,
        rebirthRequirement = 8,
        tierId = 4,
        trainingPower = 0.18,
        previewCharmScale = 1,
        extraLineChance = 0.25,
        charmModelPath = { "Charms", "Charm_AstralLeviathan" },
        podiumModelPath = { "Charms", "Podium", "Charm_AstralLeviathanExhibition" }
    },
    {
        charmDisplayAttachmentName = "Attachment",
        cost = 2.5E+11,
        defaultVisualId = "eclipseWorldeater",
        displayName = "Eclipse Worldeater",
        randomLineCount = 4,
        rebirthRequirement = 10,
        tierId = 5,
        trainingPower = 0.25,
        previewCharmScale = 1,
        charmModelPath = { "Charms", "Charm_EclipseWorldeater" },
        podiumModelPath = { "Charms", "Podium", "Charm_EclipseWorldeaterExhibition" }
    }
}

local function ranges(p4, p5, p6, p7, p8, p9) -- line: 94
    local v1 = if p9 == nil then 0.01 else p9

    return {
        {
            minimum = p4[1],
            maximum = p4[2],
            step = v1
        },
        {
            minimum = p5[1],
            maximum = p5[2],
            step = v1
        },
        {
            minimum = p6[1],
            maximum = p6[2],
            step = v1
        },
        {
            minimum = p7[1],
            maximum = p7[2],
            step = v1
        },
        {
            minimum = p8[1],
            maximum = p8[2],
            step = v1
        }
    }
end

local t4 = {
    {
        id = "mutationLuck",
        displayName = "Mutation Luck",
        selectionWeight = 8,
        tierRanges = ranges({ 0.03, 0.05 }, { 0.05, 0.08 }, { 0.08, 0.12 }, { 0.12, 0.18 }, { 0.18, 0.25 })
    },
    {
        id = "aquariumIncome",
        displayName = "Aquarium Income",
        selectionWeight = 8,
        tierRanges = ranges({ 0.04, 0.06 }, { 0.06, 0.1 }, { 0.1, 0.15 }, { 0.15, 0.2 }, { 0.2, 0.25 })
    },
    {
        id = "shopDiscount",
        displayName = "Shop Discount",
        selectionWeight = 6,
        tierRanges = ranges({ 0.01, 0.02 }, { 0.02, 0.03 }, { 0.03, 0.04 }, { 0.04, 0.06 }, { 0.06, 0.08 })
    },
    {
        id = "bonusLuck",
        displayName = "Bonus Luck",
        selectionWeight = 11,
        tierRanges = ranges({ 0.02, 0.03 }, { 0.03, 0.05 }, { 0.05, 0.08 }, { 0.08, 0.12 }, { 0.12, 0.15 })
    },
    {
        id = "weatherMutationLuck",
        displayName = "Weather Mutation Luck",
        selectionWeight = 11,
        tierRanges = ranges({ 0.02, 0.03 }, { 0.03, 0.05 }, { 0.05, 0.07 }, { 0.07, 0.09 }, { 0.1, 0.1 })
    },
    {
        id = "championMutationChance",
        displayName = "Champion Mutation Chance",
        selectionWeight = 11,
        tierRanges = ranges({ 0.03, 0.05 }, { 0.05, 0.08 }, { 0.08, 0.12 }, { 0.12, 0.18 }, { 0.18, 0.2 })
    },
    {
        id = "baitHopDistance",
        displayName = "Bait Hop Distance",
        selectionWeight = 11,
        tierRanges = ranges({ 0.01, 0.015 }, { 0.015, 0.02 }, { 0.02, 0.025 }, { 0.03, 0.035 }, { 0.04, 0.04 }, 0.005)
    },
    {
        id = "bossFishDamage",
        displayName = "Boss Fish Damage",
        selectionWeight = 17,
        tierRanges = ranges({ 0.05, 0.08 }, { 0.08, 0.12 }, { 0.12, 0.18 }, { 0.18, 0.22 }, { 0.25, 0.25 })
    },
    {
        id = "bossFishQteSize",
        displayName = "Boss Fish QTE Size",
        selectionWeight = 17,
        tierRanges = ranges({ 0.03, 0.05 }, { 0.05, 0.07 }, { 0.07, 0.1 }, { 0.1, 0.12 }, { 0.15, 0.15 })
    }
}
local t5 = {
    aquariumIncome = 0.4,
    baitHopDistance = 0.1,
    bonusLuck = 0.3,
    bossFishDamage = 0.4,
    bossFishQteSize = 0.3,
    championMutationChance = 0.4,
    mutationLuck = 0.4,
    shopDiscount = 0.15,
    trainingPower = 0.4,
    weatherMutationLuck = 0.2
}

local function isCharmTierId(p10) -- line: 184
    if p10 >= 1 and p10 <= 5 then
        return p10 % 1 == 0
    end

    return false
end

local function isCharmCandidateDecision(p11) -- line: 188
    if p11 == "keep" then
        return true
    end

    return p11 == "replace"
end

local function getCharmTierFlag(p12, p13) -- line: 191
    return p12[p13]
end

local function getCharmTierResonance(p14, p15) -- line: 194
    return p14[p15]
end

local function getCharmAttributeConfig(p16) -- line: 197
    -- upvalues: t4 (copy)
    for v2, v3 in t4 do
        local _ = v2 - 1

        if v3.id == p16 == true then
            return v3
        end
    end

    return nil
end

local function getCharmTierIdForVisualId(p17) -- line: 212
    -- upvalues: t1 (copy), t3 (copy)
    if p17 == nil then
        return nil
    end

    for v4, v5 in t1 do
        local _ = v4 - 1

        if t3[v5].defaultVisualId == p17 == true then
            return v5
        end
    end

    return nil
end

local function getEquippedCharmCore(p18, p19) -- line: 230
    -- upvalues: t2 (copy), getCharmTierIdForVisualId (copy)
    local v6 = getCharmTierIdForVisualId(p19)

    return if v6 ~= nil then p18[t2[v6]] else nil
end

local rollQuality, rollAttributeValue, qualityPercentile

local function generateCharmCandidate(p20, p21, p22, p23) -- line: 243
    -- upvalues: t3 (copy), t4 (copy), rollQuality (ref), rollAttributeValue (ref), qualityPercentile (ref)
    local v7 = p23
    local v8 = p23

    if p23 == nil then
        v8 = function() -- line: 245
            return math.random()
        end

        v7 = v8
    end

    local v9 = t3[p20]
    local v10 = if v9.extraLineChance == nil or not (v8() < v9.extraLineChance) then 0 else 1
    local v11 = v9.randomLineCount + v10
    local t6 = {}
    local v12 = #t6

    table.move(t4, 1, #t4, v12 + 1, t6)

    local t7 = {}
    local n1 = 0
    local v13 = false

    while true do
        if v13 then
            n1 += 1
        else
            v13 = true
        end

        if n1 < v11 then
            local function v14(p24, p25) -- line: 271
                return p24 + p25.selectionWeight
            end

            local n2 = 0

            for i = 1, #t6 do
                local v16 = t6[i]
                local _ = i - 1

                n2 += v16.selectionWeight
            end

            local v17 = v8() * n2
            local v18 = #t6 - 1

            for i = 0, #t6 - 1 do
                v17 -= t6[i + 1].selectionWeight

                if v17 < 0 then
                    v18 = i
                    break
                end
            end

            table.insert(t7, t6[v18 + 1])
            table.remove(t6, v18 + 1)
            continue
        end

        break
    end

    local v20 = p21 >= 8
    local v21 = table.create(#t7)

    local function v22(p26, p27) -- line: 297
        -- upvalues: v7 (ref), p20 (copy), v20 (copy), rollQuality (ref), rollAttributeValue (ref)
        local v23 = rollQuality(v7(), v20 and p27 == 0)

        return {
            attributeId = p26.id,
            quality = v23,
            value = rollAttributeValue(p26.tierRanges[p20], v23, v7())
        }
    end

    for v24, v25 in t7 do
        v21[v24] = v22(v25, v24 - 1, t7)
    end

    local n3 = 0

    for i = 1, #v21 do
        local v27 = v21[i]
        local _ = i - 1

        n3 += qualityPercentile(v27.quality)
    end

    return {
        affixes = v21,
        overallPercentile = math.clamp(n3 / #v21, 0, 1),
        resonanceGuaranteeUsed = v20,
        rolledAt = p22,
        tierId = p20,
        trainingPower = v9.trainingPower
    }
end

function rollQuality(p28, p29) -- line: 329
    if p29 then
        if p28 < 0.15 then
            return "perfect"
        end

        return "great"
    end

    if p28 < 0.45 then
        return "standard"
    end

    if p28 < 0.8 then
        return "good"
    end

    if p28 < 0.97 then
        return "great"
    end

    return "perfect"
end

function qualityPercentile(p30) -- line: 344
    if p30 == "standard" then
        return 0.125
    end

    if p30 == "good" then
        return 0.5
    end

    if p30 == "great" then
        return 0.875
    end

    return 1
end

function rollAttributeValue(p31, p32, p33) -- line: 356
    if p31.minimum == p31.maximum or p32 == "perfect" then
        return p31.maximum
    end

    local t8 = if p32 == "standard" then { 0, 0.25 } elseif p32 == "good" then { 0.25, 0.75 } else { 0.75, 1 }
    local v29 = t8[1]
    local v30 = t8[2]
    local v32 = math.floor((p31.minimum + (p31.maximum - p31.minimum) * (v29 + (v30 - v29) * p33) - p31.minimum) / p31.step + 0.5)

    return (math.clamp(p31.minimum + v32 * p31.step, p31.minimum, p31.maximum))
end

return {
    charmResonanceGuaranteeAt = 8,
    charmRevealDurationSeconds = 4.4,
    charmCandidateTimeoutSeconds = 60,
    getCharmTierKey = getCharmTierKey,
    isMajorCharmCandidate = isMajorCharmCandidate,
    shouldBroadcastCharmCandidate = shouldBroadcastCharmCandidate,
    isCharmTierId = isCharmTierId,
    isCharmCandidateDecision = isCharmCandidateDecision,
    getCharmTierFlag = getCharmTierFlag,
    getCharmTierResonance = getCharmTierResonance,
    getCharmAttributeConfig = getCharmAttributeConfig,
    getCharmTierIdForVisualId = getCharmTierIdForVisualId,
    getEquippedCharmCore = getEquippedCharmCore,
    generateCharmCandidate = generateCharmCandidate,
    charmTierOrder = t1,
    charmTierConfigs = t3,
    charmAttributeConfigs = t4,
    charmCombinedCaps = t5
}
