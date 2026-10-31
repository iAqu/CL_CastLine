-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local v8 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        local userId = p2.userId
        local v2 = table.clone(p2.data.plot)

        setmetatable(v2, nil)
        v2.showcaseFish = p2.data.plot.showcaseFish or nil
        v2.equippedHologramSkin = p2.data.plot.equippedHologramSkin
        p1[userId] = v2
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 24
        p3[p4.userId] = nil
    end),
    plotLiked = produceWrapper(function(p5, p6) -- line: 29
        local v3 = p5[p6.plotOwnerUserId]

        if not v3 then
            return nil
        end

        v3.plotLikes += 1
    end),
    showcaseFishSet = produceWrapper(function(p7, p8) -- line: 38
        local v4 = p7[p8.userId]

        if not v4 then
            return nil
        end

        v4.showcaseFish = {
            exclusiveIndex = p8.exclusiveIndex,
            fishObtainedTimestamp = p8.fishObtainedTimestamp,
            fishSpecies = p8.fishSpecies,
            itemId = p8.itemId,
            level = p8.level,
            mutations = p8.mutations
        }
    end),
    showcaseFishRetrieved = produceWrapper(function(p9, p10) -- line: 54
        local v5 = p9[p10.userId]

        if not v5 then
            return nil
        end

        local showcaseFish = v5.showcaseFish

        if showcaseFish ~= nil then
            showcaseFish = showcaseFish.itemId
        end

        if showcaseFish ~= p10.itemId then
            return nil
        end

        v5.showcaseFish = nil
    end),
    hologramSkinObtained = produceWrapper(function(p11, p12) -- line: 70
        -- upvalues: includesOriginal (copy), push (copy)
        local v6 = p11[p12.userId]

        if not v6 or includesOriginal(v6.ownedHologramSkins, p12.hologramSkinName) then
            return nil
        end

        push(v6.ownedHologramSkins, p12.hologramSkinName)
    end),
    hologramSkinEquipped = produceWrapper(function(p13, p14) -- line: 82
        -- upvalues: includesOriginal (copy)
        local v7 = p13[p14.userId]

        if not v7 or not includesOriginal(v7.ownedHologramSkins, p14.hologramSkinName) then
            return nil
        end

        v7.equippedHologramSkin = p14.hologramSkinName
    end)
})

v8:getActions()

return {
    plotSlice = v8
}
