-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    materialsSlice = createProducer({}, {
        playerJoined = produceWrapper(function(p1, p2) -- line: 7
            p1[p2.userId] = p2.data.materials
        end),
        playerLeft = produceWrapper(function(p3, p4) -- line: 13
            p3[p4.userId] = nil
        end),
        forgeMaterialObtained = produceWrapper(function(p5, p6) -- line: 18
            local v1 = p5[p6.userId]

            if v1 == nil then
                return nil
            end

            local quantity = p6.quantity

            if quantity == nil then
                quantity = 1
            end

            if quantity <= 0 then
                return nil
            end

            local materialId = p6.materialId
            local v2 = v1[p6.materialId]

            if v2 == nil then
                v2 = 0
            end

            v1[materialId] = v2 + quantity
        end)
    })
}
