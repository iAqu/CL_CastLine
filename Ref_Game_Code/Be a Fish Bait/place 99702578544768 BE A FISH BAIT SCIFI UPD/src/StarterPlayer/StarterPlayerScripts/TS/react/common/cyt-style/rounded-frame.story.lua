-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent, "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(default, {
    size = UDim2.fromScale(0.1, 0.1)
}, react.createElement("textlabel", {
    BackgroundTransparency = 1,
    Text = "Rounded Frame",
    TextScaled = true,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Font = Enum.Font.Gotham,
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.9, 0.9),
    TextColor3 = Color3.new(1, 1, 1)
}, react.createElement("uitextsizeconstraint", {
    MaxTextSize = 48
})))))
