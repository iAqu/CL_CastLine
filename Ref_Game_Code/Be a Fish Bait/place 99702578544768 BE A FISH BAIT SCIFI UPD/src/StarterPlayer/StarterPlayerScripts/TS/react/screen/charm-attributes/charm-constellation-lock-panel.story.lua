-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "charm-constellation-lock-panel").default

local function CharmConstellationLockPanelStory() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, if v1 then react.createElement(default3, {
        onClose = function() -- onClose | line: 16
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onComplete = function() -- onComplete | line: 19
            -- upvalues: v2 (copy)
            return v2(false)
        end
    }) else react.createElement(default, {
        isShiny = true,
        isStudded = true,
        label = "REPLAY ROLL",
        color = Color3.fromRGB(125, 75, 221),
        frameSize = UDim2.fromScale(0.2, 0.08),
        onClick = function() -- onClick | line: 28
            -- upvalues: v2 (copy)
            return v2(true)
        end,
        position = UDim2.fromScale(0.5, 0.5),
        strokeColor = Color3.fromRGB(237, 199, 255)
    }))
end

return storyForScreenGui(react.createElement(default2, nil, react.createElement(CharmConstellationLockPanelStory)))
