-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local t1 = {}

local function addDiscoveredFish(p1, p2, p3) -- line: 7
    if not p1 then
        return nil
    end

    local v1 = p1.discoveredFish[p2]

    if v1 == nil then
        v1 = {}
    end

    local t2 = {}

    for _, v2 in v1 do
        t2[v2] = true
    end

    t2.Normal = true

    for _, v3 in p3 do
        t2[v3] = true
    end

    local discoveredFish = p1.discoveredFish
    local t3 = {}
    local v4 = #t3

    for v5 in t2 do
        v4 += 1
        t3[v4] = v5
    end

    discoveredFish[p2] = t3
end

local v11 = createProducer(t1, {
    playerJoined = produceWrapper(function(p4, p5) -- line: 38
        p4[p5.userId] = p5.data.collectionIndex
    end),
    playerLeft = produceWrapper(function(p6, p7) -- line: 44
        p6[p7.userId] = nil
    end),
    fishObtained = produceWrapper(function(p8, p9) -- line: 49
        -- upvalues: addDiscoveredFish (copy)
        addDiscoveredFish(p8[p9.userId], p9.fishName, p9.mutations)
    end),
    fishMutationSet = produceWrapper(function(p10, p11) -- line: 54
        -- upvalues: addDiscoveredFish (copy)
        local v6 = p10[p11.userId]
        local fishName = p11.fishName

        if fishName == nil then
            return nil
        end

        addDiscoveredFish(v6, fishName, p11.mutations)
    end),
    fishDiscovered = produceWrapper(function(p12, p13) -- line: 64
        -- upvalues: addDiscoveredFish (copy)
        addDiscoveredFish(p12[p13.userId], p13.fishName, p13.mutations)
    end),
    aquariumFishAdded = produceWrapper(function(p14, p15) -- line: 69
        -- upvalues: addDiscoveredFish (copy)
        addDiscoveredFish(p14[p15.userId], p15.fishSpecies, p15.mutations)
    end),
    aquariumFishUnequipped = produceWrapper(function(p16, p17) -- line: 74
        -- upvalues: addDiscoveredFish (copy)
        addDiscoveredFish(p16[p17.userId], p17.fishSpecies, p17.mutations)
    end),
    equipBestFishApplied = produceWrapper(function(p18, p19) -- line: 79
        -- upvalues: addDiscoveredFish (copy)
        local v7 = p18[p19.userId]

        for _, v8 in p19.toAdd do
            addDiscoveredFish(v7, v8.fishSpecies, v8.mutations)
        end

        for _, v9 in p19.toRemove do
            addDiscoveredFish(v7, v9.fishSpecies, v9.mutations)
        end
    end),
    itemGifted = produceWrapper(function(p20, p21) -- line: 90
        -- upvalues: addDiscoveredFish (copy)
        if p21.item.itemType ~= "fish" then
            return nil
        end

        addDiscoveredFish(p20[p21.receiverUserId], p21.item.itemName, p21.item.mutations)
    end),
    fishCollectionSeen = produceWrapper(function(p22, p23) -- line: 98
        local v10 = p22[p23.userId]

        if not v10 then
            return nil
        end

        v10.seenFishes = p23.seenFishes
    end)
})

v11:getActions()

return {
    collectionIndexSlice = v11
}
