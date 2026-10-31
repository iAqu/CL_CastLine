-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v2 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 7
        p1[p2.userId] = p2.data.tutorialTracking
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 13
        p3[p4.userId] = nil
    end),
    tutorialTrackingStepUpdated = produceWrapper(function(p5, p6) -- line: 18
        local v1 = p5[p6.userId]

        if v1 then
            v1.currentStep = p6.step
        end
    end)
})

v2:getActions()

return {
    tutorialTrackingSlice = v2
}
