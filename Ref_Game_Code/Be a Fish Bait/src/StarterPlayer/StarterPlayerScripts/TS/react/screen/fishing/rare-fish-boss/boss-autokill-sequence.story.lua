-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "boss-autokill-sequence").default

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(default2, {
    onComplete = function() -- onComplete | line: 10
        return print("autokill complete")
    end,
    onSuccessCutscene = function() -- onSuccessCutscene | line: 13
        return print("autokill success cutscene")
    end
})))
