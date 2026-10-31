-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "notification-badge").default

local function NotificationBadgeStory() -- line: 7
    -- upvalues: react (copy), default2 (copy)
    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(220, 180, 60),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(80, 80)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    }), react.createElement(default2, {
        zIndex = 12,
        anchorPoint = Vector2.new(1, 0),
        position = UDim2.fromScale(1, 0),
        size = UDim2.fromOffset(36, 36)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(NotificationBadgeStory)))
