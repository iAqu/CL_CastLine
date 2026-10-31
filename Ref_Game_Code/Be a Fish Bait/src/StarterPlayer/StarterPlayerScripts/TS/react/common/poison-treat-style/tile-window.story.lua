-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent, "tile-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(default, {
    title = "Results",
    bodyColorSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }),
    headerColorSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 250, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(209, 171, 21))
    }),
    onClose = function() -- onClose | line: 12
    end,
    size = UDim2.fromScale(0.4, 0.6)
}, react.createElement("textlabel", {
    BackgroundTransparency = 1,
    Font = "GothamBold",
    Text = "Body Content Here",
    TextScaled = true,
    TextStrokeTransparency = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.9, 0.3),
    TextColor3 = Color3.new(1, 1, 1),
    TextStrokeColor3 = Color3.new(0, 0, 0)
}, react.createElement("uitextsizeconstraint", {
    MaxTextSize = 36
}), react.createElement("uistroke", {
    Thickness = 3
})))))
