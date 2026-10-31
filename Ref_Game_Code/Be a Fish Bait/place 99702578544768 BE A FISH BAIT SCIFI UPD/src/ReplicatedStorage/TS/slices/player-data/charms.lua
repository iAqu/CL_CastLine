-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local original = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "immut", "src").original
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmResonanceGuaranteeAt, charmTierConfigs, getCharmTierKey = v1.charmResonanceGuaranteeAt, v1.charmTierConfigs, v1.getCharmTierKey
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v2.includesOriginal, v2.produceWrapper, v2.push
local v24 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 15
        p1[p2.userId] = {
            charmCoresByTier = p2.data.charms.charmCoresByTier,
            displayedCharmId = p2.data.charms.displayedCharmId,
            equippedCharmId = p2.data.charms.equippedCharmId,
            firstRollClaimedByTier = p2.data.charms.firstRollClaimedByTier or { false, false, false, false, false },
            ownedCharmIds = p2.data.charms.ownedCharmIds or {},
            pendingCharmCandidate = p2.data.charms.pendingCharmCandidate,
            resonanceByTier = p2.data.charms.resonanceByTier or { 0, 0, 0, 0, 0 },
            unlockedTierCharmVisuals = p2.data.charms.unlockedTierCharmVisuals or { false, false, false, false, false }
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 30
        p3[p4.userId] = nil
    end),
    charmPurchased = produceWrapper(function(p5, p6) -- line: 35
        -- upvalues: includesOriginal (copy), push (copy)
        local v3 = p5[p6.userId]

        if not v3 or includesOriginal(v3.ownedCharmIds, p6.charmId) then
            return nil
        end

        push(v3.ownedCharmIds, p6.charmId)
    end),
    charmSkinEquipped = produceWrapper(function(p7, p8) -- line: 47
        local v4 = p7[p8.userId]

        if not v4 then
            return nil
        end

        v4.displayedCharmId = p8.charmId
    end),
    charmSkinUnequipped = produceWrapper(function(p9, p10) -- line: 56
        local v5 = p9[p10.userId]

        if not v5 then
            return nil
        end

        v5.displayedCharmId = nil
    end),
    charmAttributesEquipped = produceWrapper(function(p11, p12) -- line: 65
        local v6 = p11[p12.userId]

        if not v6 then
            return nil
        end

        v6.equippedCharmId = p12.charmId
    end),
    charmAttributesUnequipped = produceWrapper(function(p13, p14) -- line: 74
        local v7 = p13[p14.userId]

        if not v7 then
            return nil
        end

        v7.equippedCharmId = nil
    end),
    charmRollStarted = produceWrapper(function(p15, p16) -- line: 83
        local v8 = p15[p16.userId]

        if not v8 then
            return nil
        end

        local v9 = p16.candidate.tierId - 1

        if v8.firstRollClaimedByTier == nil then
            v8.firstRollClaimedByTier = { false, false, false, false, false }
        end

        if v8.resonanceByTier == nil then
            v8.resonanceByTier = { 0, 0, 0, 0, 0 }
        end

        v8.pendingCharmCandidate = p16.candidate
        v8.firstRollClaimedByTier[v9 + 1] = true

        if p16.candidate.resonanceGuaranteeUsed then
            v8.resonanceByTier[v9 + 1] = 0
        end
    end),
    charmCandidateResolved = produceWrapper(function(p17, p18) -- line: 103
        -- upvalues: original (copy), charmResonanceGuaranteeAt (copy), charmTierConfigs (copy), getCharmTierKey (copy), includesOriginal (copy), push (copy)
        local v10 = p17[p18.userId]
        local v11 = if v10 == nil then v10 else v10.pendingCharmCandidate

        if not (v10 and v11) then
            return nil
        end

        local v12 = v11.tierId - 1

        if v10.resonanceByTier == nil then
            v10.resonanceByTier = { 0, 0, 0, 0, 0 }
        end

        if v10.unlockedTierCharmVisuals == nil then
            v10.unlockedTierCharmVisuals = { false, false, false, false, false }
        end

        local v13 = not v10.unlockedTierCharmVisuals[v12 + 1]

        v10.pendingCharmCandidate = nil

        if p18.decision ~= "replace" then
            v10.resonanceByTier[v12 + 1] = math.min(charmResonanceGuaranteeAt, v10.resonanceByTier[v12 + 1] + 1)

            return nil
        end

        local v16 = original(v11.affixes)
        local charmCoresByTier = v10.charmCoresByTier
        local v17 = getCharmTierKey(v11.tierId)
        local t4 = {}
        local v18 = table.create(#v16)

        local function v19(p19) -- line: 137
            local v20 = table.clone(p19)

            setmetatable(v20, nil)

            return v20
        end

        for v21, v22 in v16 do
            local _ = v21 - 1
            local v23 = table.clone(v22)

            setmetatable(v23, nil)
            v18[v21] = v23
        end

        t4.affixes = v18
        t4.overallPercentile = v11.overallPercentile
        t4.rolledAt = v11.rolledAt
        t4.tierId = v11.tierId
        t4.trainingPower = v11.trainingPower
        charmCoresByTier[v17] = t4
        v10.resonanceByTier[v12 + 1] = 0
        v10.unlockedTierCharmVisuals[v12 + 1] = true

        local defaultVisualId = charmTierConfigs[v11.tierId].defaultVisualId

        if not includesOriginal(v10.ownedCharmIds, defaultVisualId) then
            push(v10.ownedCharmIds, defaultVisualId)
        end

        if v13 then
            v10.displayedCharmId = defaultVisualId
            v10.equippedCharmId = defaultVisualId
        end
    end)
})

v24:getActions()

return {
    charmsSlice = v24
}
