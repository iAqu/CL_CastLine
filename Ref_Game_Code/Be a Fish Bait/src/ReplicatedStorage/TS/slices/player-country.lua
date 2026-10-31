-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({}, {
    playerLeft = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.userId] = nil
    end),
    playerCountryDetected = produceWrapper(function(p3, p4) -- line: 15
        p3[p4.userId] = p4.countryCode
    end)
})

v1:getActions()

return {
    playerCountrySlice = v1
}
