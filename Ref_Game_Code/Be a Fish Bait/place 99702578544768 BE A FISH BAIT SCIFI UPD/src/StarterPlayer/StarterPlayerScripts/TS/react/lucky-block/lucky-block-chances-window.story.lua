-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "transition", "window-transition").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default4 = RuntimeLib.import(script, script.Parent, "lucky-block-chances-window").default

local function LuckyBlockChancesWindowShowcase() -- line: 11
    -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), default4 (copy)
    local v1, v2 = useState(true)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v3 = not v1

    v3 = v3 and react.createElement(default, {
        isShiny = true,
        isStudded = true,
        label = "OPEN LUCKY BLOCK CHANCES",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 224, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 40))
        }),
        frameSize = UDim2.fromScale(0.28, 0.09),
        onClick = function() -- onClick | line: 23
            -- upvalues: v2 (copy)
            return v2(true)
        end,
        position = UDim2.fromScale(0.5, 0.5)
    })

    return createElement("frame", t1, v3, react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default4)))
end

return storyForScreenGui(react.createElement(default3, nil, react.createElement(LuckyBlockChancesWindowShowcase)))
