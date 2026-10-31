-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "celebration-event-countdown").default

return storyForScreenGui(react.createElement(default, nil, react.createElement("frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(45, 35, 20),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.45, 0.1)
}, react.createElement(default2))))
