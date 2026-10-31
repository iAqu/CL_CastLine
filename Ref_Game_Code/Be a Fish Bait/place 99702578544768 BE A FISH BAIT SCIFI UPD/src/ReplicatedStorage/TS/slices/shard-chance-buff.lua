-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    shardChanceBuffSlice = createProducer({
        expiresAt = 0
    }, {
        shardChanceBuffUpdated = produceWrapper(function(p1, p2) -- line: 9
            p1.expiresAt = p2.expiresAt
        end)
    })
}
