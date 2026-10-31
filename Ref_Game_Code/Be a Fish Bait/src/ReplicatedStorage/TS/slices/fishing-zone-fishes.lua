-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local v4 = createProducer({}, {
    fishSpawned = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.fishId] = {
            despawnTimestamp = p2.despawnTimestamp,
            fishId = p2.fishId,
            fishName = p2.fishName,
            isNaturalApexFish = p2.isNaturalApexFish,
            level = p2.level,
            mutations = p2.mutations,
            nibbleHookPosition = p2.nibbleHookPosition,
            rarity = p2.rarity,
            spawnCFrame = p2.spawnCFrame,
            zone = p2.zone
        }
    end),
    fishDespawnExtended = produceWrapper(function(p3, p4) -- line: 27
        local v2 = p3[p4.fishId]

        if v2 ~= nil then
            v2.despawnTimestamp = p4.newDespawnTimestamp
        end
    end),
    fishDespawned = produceWrapper(function(p5, p6) -- line: 35
        p5[p6.fishId] = nil
    end),
    fishMutationAdded = produceWrapper(function(p7, p8) -- line: 40
        -- upvalues: includesOriginal (copy), push (copy)
        local v3 = p7[p8.fishId]

        if v3 ~= nil and not includesOriginal(v3.mutations, p8.mutation) then
            push(v3.mutations, p8.mutation)
        end
    end),
    allFishCleared = produceWrapper(function(p9) -- line: 48
        table.clear(p9)
    end)
})

v4:getActions()

return {
    fishingZoneFishesSlice = v4
}
