-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "transition").default
local FeedbackDisplay = RuntimeLib.import(script, script.Parent, "feedback-manager").FeedbackDisplay

local function FeedbackManagerStory() -- line: 10
    -- upvalues: react (copy), useState (copy), default2 (copy), FeedbackDisplay (copy)
    local v1, v2 = useState(1)
    local v3, v4 = useState(3)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        ["in"] = true
    }, react.createElement(FeedbackDisplay, {
        message = "Fish caught!",
        type = "success",
        count = v1,
        position = UDim2.fromScale(0.5, 0.35)
    })), react.createElement(default2, {
        ["in"] = true
    }, react.createElement(FeedbackDisplay, {
        message = "Not enough coins!",
        type = "error",
        count = v3,
        position = UDim2.fromScale(0.5, 0.55)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 180, 80),
        Event = {
            Activated = function() -- Activated | line: 35
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 36
                    return p1 + 1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.38, 0.95),
        Size = UDim2.fromOffset(180, 48),
        Text = ("+ success (x%*)"):format(v1),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(190, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 54
                -- upvalues: v4 (copy)
                return v4(function(p2) -- line: 55
                    return p2 + 1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.62, 0.95),
        Size = UDim2.fromOffset(180, 48),
        Text = ("+ error (x%*)"):format(v3),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(FeedbackManagerStory)))
