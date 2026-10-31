-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local v4 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.userId] = p2.data.rodSkins or {
            ownedSkinIds = {}
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 18
        p3[p4.userId] = nil
    end),
    fishingRodSkinUnlocked = produceWrapper(function(p5, p6) -- line: 23
        -- upvalues: includesOriginal (copy), push (copy)
        local v2 = p5[p6.userId]

        if not v2 or includesOriginal(v2.ownedSkinIds, p6.skinId) then
            return nil
        end

        push(v2.ownedSkinIds, p6.skinId)
    end),
    fishingRodSkinEquipped = produceWrapper(function(p7, p8) -- line: 32
        local v3 = p7[p8.userId]

        if not v3 then
            return nil
        end

        v3.equippedSkinId = p8.skinId
    end)
})

v4:getActions()

return {
    fishingRodSkinsSlice = v4
}
