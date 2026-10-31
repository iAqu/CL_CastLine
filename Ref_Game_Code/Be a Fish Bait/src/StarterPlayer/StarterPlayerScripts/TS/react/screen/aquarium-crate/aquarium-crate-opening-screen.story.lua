-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local activeAquariumCrateSeries = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").activeAquariumCrateSeries
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "aquarium-crate-opening-screen").default

local function AquariumCrateOpeningStory() -- line: 11
    -- upvalues: react (copy), useState (copy), default (copy), activeAquariumCrateSeries (copy), default3 (copy)
    local v1, v2 = useState(0)
    local v3, v4 = useState(false)

    if v3 then
        return react.createElement("frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 24, 48),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            isShiny = true,
            isStudded = true,
            label = "REPLAY OPENING",
            zIndex = 10,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(181, 42, 224))
            }),
            frameSize = UDim2.fromScale(0.3, 0.12),
            onClick = function() -- onClick | line: 35
                -- upvalues: v2 (copy), v4 (copy)
                v2(function(p1) -- line: 36
                    return p1 + 1
                end)
                v4(false)
            end,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.8)
        }))
    end

    return react.createElement(default3, {
        targetTier = "mythic",
        key = v1,
        onFinished = function() -- onFinished | line: 17
            -- upvalues: v4 (copy)
            return v4(true)
        end,
        seriesId = activeAquariumCrateSeries.id
    })
end

return storyForScreenGui(react.createElement(default2, nil, react.createElement(AquariumCrateOpeningStory)))
