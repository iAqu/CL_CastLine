-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "hoola-score-popup").default

return storyForScreenGui(react.createElement(default, nil, react.createElement(default2, {
    rotation = -22,
    score = 18,
    x = 0.35,
    y = 0.76,
    onComplete = function() -- onComplete | line: 8
        return nil
    end
}), react.createElement(default2, {
    rotation = 24,
    score = 26,
    x = 0.65,
    y = 0.78,
    onComplete = function() -- onComplete | line: 16
        return nil
    end
})))
