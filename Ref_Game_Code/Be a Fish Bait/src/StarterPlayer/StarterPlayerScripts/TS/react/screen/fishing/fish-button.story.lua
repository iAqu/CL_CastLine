-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default
local default3 = RuntimeLib.import(script, script.Parent, "fish-button").default
local t1 = {
    0,
    tutorialSteps.catchAFish
}

local function FishButtonStory() -- line: 12
    -- upvalues: react (copy), useState (copy), tutorialSteps (copy), default2 (copy), default3 (copy), t1 (copy)
    local v1, v2 = useState(0)
    local v3, v4 = useState(0)
    local v5 = t1[v3 + 1] == tutorialSteps.catchAFish

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default3, {
        key = tostring(v1)
    }), v5 and react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 202,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.475, 0.663),
        Size = UDim2.fromScale(0.07, 0.1)
    }, react.createElement(default2, {
        direction = "down",
        size = UDim2.fromScale(1.5, 1.5)
    })), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        TextScaled = true,
        ZIndex = 300,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 120),
        Event = {
            Activated = function() -- Activated | line: 39
                -- upvalues: v4 (copy), t1 (copy)
                return v4(function(p1) -- line: 40
                    -- upvalues: t1 (copy)
                    return (p1 + 1) % #t1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.fromOffset(200, 36),
        Text = ("Tutorial: %*"):format(v5 and "catchAFish" or "none"),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Reset",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 60
                -- upvalues: v2 (copy)
                return v2(function(p2) -- line: 61
                    return p2 + 1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.99),
        Size = UDim2.fromOffset(160, 48),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(FishButtonStory)))
