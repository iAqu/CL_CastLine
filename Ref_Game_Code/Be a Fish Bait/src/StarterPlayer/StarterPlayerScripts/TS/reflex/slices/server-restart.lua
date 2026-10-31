-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    serverRestartSlice = createProducer({
        endTimestamp = nil,
        closeReason = nil,
        message = nil
    }, {
        serverRestartScheduled = produceWrapper(function(p1, p2) -- line: 11
            p1.endTimestamp = p2.endTimestamp
            p1.closeReason = p2.closeReason
            p1.message = p2.message
        end)
    })
}
