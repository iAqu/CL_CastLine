-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, subscribe = charm.atom, charm.subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local charmTierOrder = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").charmTierOrder
local storyForWorkspaceWithScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForWorkspaceWithScreenGui
local CharmPodiumPreviewScene = RuntimeLib.import(script, script.Parent, "charm-podium-preview-scene").CharmPodiumPreviewScene
local v1 = atom(1)

local function usePreviewTierId() -- line: 17
    -- upvalues: subscribe (copy), useEffect (copy), useState (copy), v1 (copy)
    local v2, v3 = useState(v1)

    useEffect(function() -- line: 19
        -- upvalues: v3 (copy), subscribe (copy), v1 (copy)
        return subscribe(v1, v3)
    end, {})

    return v2
end

local function CharmPodiumPreviewSceneStory() -- line: 24
    -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), CharmPodiumPreviewScene (copy), v1 (copy)
    local v4, v5 = useState(v1)

    useEffect(function() -- line: 19
        -- upvalues: v5 (copy), subscribe (copy), v1 (copy)
        return subscribe(v1, v5)
    end, {})

    return react.createElement(CharmPodiumPreviewScene, {
        tierId = v4
    })
end

local function CharmPodiumPreviewDebugPanel() -- line: 30
    -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), default (copy), default2 (copy), charmTierOrder (copy), v1 (copy)
    local v6, v7 = useState(v1)

    useEffect(function() -- line: 19
        -- upvalues: v7 (copy), subscribe (copy), v1 (copy)
        return subscribe(v1, v7)
    end, {})
    useEffect(function() -- line: 32
        -- upvalues: v1 (copy)
        v1(1)
    end, {})

    local v8 = table.create(#charmTierOrder)

    local function v9(p1, p2) -- line: 37
        -- upvalues: v6 (copy), react (copy), default2 (copy), v1 (copy)
        local v10 = p1 == v6

        return react.createElement(default2, {
            isStudded = true,
            zIndex = 101,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = if v10 then ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 175, 49)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 65, 224))
            }) else Color3.fromRGB(35, 71, 126),
            frameSize = UDim2.fromScale(0.17, 0.66),
            isShiny = v10,
            key = tostring(p1),
            label = ("TIER %*"):format(p1),
            onClick = function() -- onClick | line: 47
                -- upvalues: p1 (copy), v1 (copy)
                return v1(p1)
            end,
            position = UDim2.fromScale(0.1 + p2 * 0.2, 0.5),
            strokeColor = if v10 then Color3.fromRGB(255, 235, 160) else Color3.fromRGB(101, 173, 255)
        })
    end

    for v11, v12 in charmTierOrder do
        v8[v11] = v9(v12, v11 - 1, charmTierOrder)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default, {
        cornerRadius = 0.12,
        isStudded = true,
        strokeThickness = 0.035,
        transparency = 0.12,
        zIndex = 100,
        anchorPoint = Vector2.new(0.5, 1),
        backgroundColor = Color3.fromRGB(11, 20, 46),
        position = UDim2.fromScale(0.5, 0.97),
        size = UDim2.fromScale(0.64, 0.09),
        strokeColor = Color3.fromRGB(151, 102, 255)
    }, v8))
end

return storyForWorkspaceWithScreenGui({
    screenGui = react.createElement(default3, nil, react.createElement(CharmPodiumPreviewDebugPanel)),
    workspace = react.createElement(default3, nil, react.createElement(CharmPodiumPreviewSceneStory))
})
