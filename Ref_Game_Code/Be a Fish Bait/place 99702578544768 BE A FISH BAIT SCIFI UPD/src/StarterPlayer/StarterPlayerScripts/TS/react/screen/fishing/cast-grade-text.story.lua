-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "cast-grade-text").default
local t1 = {
    "perfect",
    "excellent",
    "great",
    "good",
    "poor"
}

local function CastGradeTextStory() -- line: 10
    -- upvalues: react (copy), useState (copy), default2 (copy), t1 (copy)
    local v1, v2 = useState(0)
    local v3 = t1[v1 + 1]

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        grade = v3
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.62),
        Size = UDim2.fromOffset(220, 32),
        Text = ("Grade: %*"):format(v3),
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Next Grade",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 33
                -- upvalues: v2 (copy), t1 (copy)
                return v2(function(p1) -- line: 34
                    -- upvalues: t1 (copy)
                    return (p1 + 1) % #t1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.99),
        Size = UDim2.fromOffset(180, 48),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(CastGradeTextStory)))
