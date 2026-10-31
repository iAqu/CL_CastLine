-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "quests-tab-content").default

local function QuestsTabContentShowcase() -- line: 7
    -- upvalues: react (copy), default2 (copy)
    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.68, 0.66)
    }, react.createElement(default2)))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(QuestsTabContentShowcase)))
