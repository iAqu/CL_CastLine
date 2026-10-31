-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "item-rarity-overlay").default

return storyForScreenGui(react.createElement(default, nil, react.createElement("frame", {
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.2, 0.2)
}, react.createElement(default2, {
    cornerRadius = 8,
    rarity = "scifi"
}))))
