-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    targetPlayerUserId = nil
}, {
    giftTargetSelected = produceWrapper(function(p1, p2) -- line: 9
        p1.targetPlayerUserId = p2.targetPlayerUserId
    end),
    giftTargetCleared = produceWrapper(function(p3) -- line: 12
        p3.targetPlayerUserId = nil
    end)
})

v1:getActions()

return {
    giftUiSlice = v1
}
