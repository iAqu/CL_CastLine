-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "bonus-text").default

local function BonusTextStory() -- line: 9
    -- upvalues: react (copy), useState (copy), default2 (copy)
    local v1, v2 = useState(1)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        level = v1
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.62),
        Size = UDim2.fromOffset(220, 32),
        Text = ("Level: %*"):format(v1),
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Next Bonus",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 31
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 32
                    return p1 % 4 + 1
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

return storyForScreenGui(react.createElement(default, nil, react.createElement(BonusTextStory)))
