-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push = v1.produceWrapper, v1.push
local v4 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 9
        p1[p2.userId] = {
            equippedVfxId = p2.data.fishReelbackVfx.equippedVfxId,
            ownedVfxIds = p2.data.fishReelbackVfx.ownedVfxIds
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 18
        p3[p4.userId] = nil
    end),
    fishReelbackVfxPurchased = produceWrapper(function(p5, p6) -- line: 23
        -- upvalues: push (copy)
        local v2 = p5[p6.userId]

        if not v2 then
            return nil
        end

        local ownedVfxIds = v2.ownedVfxIds
        local vfxId = p6.vfxId

        if table.find(ownedVfxIds, vfxId) == nil then
            push(v2.ownedVfxIds, p6.vfxId)
        end

        v2.equippedVfxId = p6.vfxId
    end),
    fishReelbackVfxEquipped = produceWrapper(function(p7, p8) -- line: 38
        local v3 = p7[p8.userId]

        if not v3 then
            return nil
        end

        v3.equippedVfxId = p8.vfxId
    end)
})

v4:getActions()

return {
    fishReelbackVfxSlice = v4
}
