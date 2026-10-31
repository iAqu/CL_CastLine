-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({}, {
    otherPlayerCastReceived = produceWrapper(function(p1, p2) -- line: 7
        p1[p2.casterUserId] = {
            castParams = p2.castParams,
            castTimestamp = p2.castTimestamp
        }
    end),
    otherPlayerCastRemoved = produceWrapper(function(p3, p4) -- line: 16
        p3[p4.casterUserId] = nil
    end)
})

v1:getActions()

return {
    otherPlayerCastsSlice = v1
}
