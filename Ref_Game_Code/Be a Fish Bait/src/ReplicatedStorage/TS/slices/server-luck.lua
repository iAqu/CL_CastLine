-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    serverLuckSlice = createProducer({
        expiresAt = 0,
        multiplier = 1
    }, {
        serverLuckUpdated = produceWrapper(function(p1, p2) -- line: 10
            p1.expiresAt = p2.expiresAt
            p1.multiplier = p2.multiplier
        end)
    })
}
