-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    isInFishingArea = false,
    fishingAreaCenter = nil
}, {
    setInFishingArea = produceWrapper(function(p1, p2) -- line: 10
        p1.isInFishingArea = p2.isInFishingArea
    end),
    setFishingAreaCenter = produceWrapper(function(p3, p4) -- line: 13
        p3.fishingAreaCenter = p4.fishingAreaCenter
    end)
})

v1:getActions()

return {
    fishingAreaSlice = v1
}
