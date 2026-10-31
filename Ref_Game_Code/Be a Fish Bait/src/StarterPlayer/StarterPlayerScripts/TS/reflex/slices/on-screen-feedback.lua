-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    feedbacks = {}
}, {
    onScreenFeedbackAdded = produceWrapper(function(p1, p2) -- line: 10
        -- upvalues: Workspace (copy)
        p1.feedbacks[p2.id] = {
            duration = p2.duration,
            id = p2.id,
            message = p2.message,
            type = p2.type,
            timestamp = Workspace:GetServerTimeNow()
        }
    end),
    onScreenFeedbackRemoved = produceWrapper(function(p3, p4) -- line: 22
        p3.feedbacks[p4.id] = nil
    end)
})

v1:getActions()

return {
    onScreenFeedbackSlice = v1
}
