-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local v7 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.userId] = p2.data.zoneGacha or {
            tokenA = 0,
            tokenB = 0,
            tokenC = 0,
            ownedItemIds = {}
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 21
        p3[p4.userId] = nil
    end),
    zoneGachaItemUnlocked = produceWrapper(function(p5, p6) -- line: 26
        -- upvalues: includesOriginal (copy), push (copy)
        local v2 = p5[p6.userId]

        if not v2 or includesOriginal(v2.ownedItemIds, p6.itemId) then
            return nil
        end

        push(v2.ownedItemIds, p6.itemId)
    end),
    zoneGachaSkinEquipped = produceWrapper(function(p7, p8) -- line: 38
        local v3 = p7[p8.userId]

        if not v3 then
            return nil
        end

        local category = p8.category

        if category == "head" then
            v3.headEquippedSkinId = p8.itemId
        elseif category == "eyes" then
            v3.eyesEquippedSkinId = p8.itemId
        elseif category == "legendary" then
            v3.legendaryEquippedSkinId = p8.itemId
        end
    end),
    zoneGachaBuffEquipped = produceWrapper(function(p9, p10) -- line: 61
        local v4 = p9[p10.userId]

        if not v4 then
            return nil
        end

        local category = p10.category

        if category == "head" then
            v4.headEquippedBuffId = p10.itemId
        elseif category == "eyes" then
            v4.eyesEquippedBuffId = p10.itemId
        elseif category == "legendary" then
            v4.legendaryEquippedBuffId = p10.itemId
        end
    end),
    zoneTokensEarned = produceWrapper(function(p11, p12) -- line: 84
        local v5 = p11[p12.userId]

        if not v5 then
            return nil
        end

        v5[p12.tokenType] += p12.amount
    end),
    zoneTokensSpent = produceWrapper(function(p13, p14) -- line: 93
        local v6 = p13[p14.userId]

        if not v6 then
            return nil
        end

        v6[p14.tokenType] -= p14.amount
    end)
})

v7:getActions()

return {
    zoneGachaSlice = v7
}
