-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer({
    isInGroup = false
}, {
    isInGroupUpdated = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper(function(p1, p2) -- line: 9
        p1.isInGroup = p2.isInGroup
    end)
})

v1:getActions()

return {
    freeRewardsUiSlice = v1
}
