-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "celebration-reward-popup-screen").default

local function Story() -- line: 9
    -- upvalues: react (copy), useState (copy), default2 (copy)
    local v1, v2 = useState(0)

    return react.createElement("frame", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(0.12, 0.12, 0.14),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        uiScale = 1,
        zIndex = 50,
        key = v1
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Replay",
        TextScaled = true,
        ZIndex = 300,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 110, 200),
        Event = {
            MouseButton1Down = function() -- MouseButton1Down | line: 26
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 27
                    return p1 + 1
                end)
            end
        },
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(0.2, 0.05),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(Story)))
