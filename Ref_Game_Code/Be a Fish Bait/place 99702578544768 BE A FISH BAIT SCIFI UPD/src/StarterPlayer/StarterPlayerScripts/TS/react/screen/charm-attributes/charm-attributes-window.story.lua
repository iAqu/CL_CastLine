-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, subscribe = charm.atom, charm.subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "charm-podium", "charm-podium-camera-focus")
local setCharmPodiumRollPresentationActive, setCharmPodiumSuccessPresentationActive = v1.setCharmPodiumRollPresentationActive, v1.setCharmPodiumSuccessPresentationActive
local CharmPodiumPreviewScene = RuntimeLib.import(script, script.Parent.Parent.Parent, "charm-podium", "charm-podium-preview-scene").CharmPodiumPreviewScene
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local charmTierConfigs = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").charmTierConfigs
local storyForWorkspaceWithScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForWorkspaceWithScreenGui
local default4 = RuntimeLib.import(script, script.Parent, "charm-attributes-window").default
local t1 = {
    overallPercentile = 0.82,
    rolledAt = 0,
    tierId = 2,
    trainingPower = 0.08,
    affixes = {
        {
            attributeId = "mutationLuck",
            quality = "great",
            value = 0.07
        },
        {
            attributeId = "bossFishDamage",
            quality = "perfect",
            value = 0.12
        }
    }
}
local t2 = {
    {
        label = "NORMAL T1",
        candidate = {
            overallPercentile = 0.5,
            resonanceGuaranteeUsed = false,
            rolledAt = 1,
            tierId = 1,
            trainingPower = 0.05,
            affixes = {
                {
                    attributeId = "mutationLuck",
                    quality = "good",
                    value = 0.05
                }
            }
        }
    },
    {
        label = "FIVE LINE T4",
        candidate = {
            overallPercentile = 0.82,
            resonanceGuaranteeUsed = false,
            rolledAt = 2,
            tierId = 4,
            trainingPower = 0.18,
            affixes = {
                {
                    attributeId = "mutationLuck",
                    quality = "great",
                    value = 0.11
                },
                {
                    attributeId = "aquariumIncome",
                    quality = "good",
                    value = 0.13
                },
                {
                    attributeId = "bossFishDamage",
                    quality = "perfect",
                    value = 0.18
                },
                {
                    attributeId = "bonusLuck",
                    quality = "great",
                    value = 0.1
                }
            }
        }
    },
    {
        label = "TOP 5% T3",
        candidate = {
            overallPercentile = 0.96,
            resonanceGuaranteeUsed = true,
            rolledAt = 3,
            tierId = 3,
            trainingPower = 0.12,
            affixes = {
                {
                    attributeId = "mutationLuck",
                    quality = "perfect",
                    value = 0.15
                },
                {
                    attributeId = "weatherMutationLuck",
                    quality = "great",
                    value = 0.13
                },
                {
                    attributeId = "bossFishDamage",
                    quality = "great",
                    value = 0.18
                }
            }
        }
    },
    {
        label = "TOP 1% T5",
        candidate = {
            overallPercentile = 1,
            resonanceGuaranteeUsed = false,
            rolledAt = 4,
            tierId = 5,
            trainingPower = 0.25,
            affixes = {
                {
                    attributeId = "mutationLuck",
                    quality = "perfect",
                    value = 0.2
                },
                {
                    attributeId = "aquariumIncome",
                    quality = "perfect",
                    value = 0.25
                },
                {
                    attributeId = "bossFishDamage",
                    quality = "perfect",
                    value = 0.25
                },
                {
                    attributeId = "bonusLuck",
                    quality = "perfect",
                    value = 0.2
                }
            }
        }
    }
}
local v2 = atom(true)
local v3 = atom(2)

local function nextCharmTierId(p1) -- line: 126
    if p1 == 1 then
        return 2
    end

    if p1 == 2 then
        return 3
    end

    if p1 == 3 then
        return 4
    end

    if p1 == 4 then
        return 5
    end

    return 1
end

local function useCharmAttributesStoryOpen() -- line: 141
    -- upvalues: subscribe (copy), useEffect (copy), useState (copy), v2 (copy)
    local v4, v5 = useState(v2)

    useEffect(function() -- line: 143
        -- upvalues: v5 (copy), subscribe (copy), v2 (copy)
        return subscribe(v2, v5)
    end, {})

    return v4
end

local function useCharmAttributesStoryTier() -- line: 148
    -- upvalues: subscribe (copy), useEffect (copy), useState (copy), v3 (copy)
    local v6, v7 = useState(v3)

    useEffect(function() -- line: 150
        -- upvalues: v7 (copy), subscribe (copy), v3 (copy)
        return subscribe(v3, v7)
    end, {})

    return v6
end

local function CharmAttributesWindowStory() -- line: 155
    -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), setCharmPodiumRollPresentationActive (copy), setCharmPodiumSuccessPresentationActive (copy), default (copy), default2 (copy), charmTierConfigs (copy), default4 (copy), t1 (copy), t2 (copy), v2 (copy), v3 (copy), nextCharmTierId (copy)
    local v8, v9 = useState(false)
    local v10, v11 = useState(3)
    local v12, v13 = useState()
    local v14, v15 = useState(0)
    local v16, v17 = useState(2)
    local v18, v19 = useState("pre-roll")
    local v20 = t2[v14 + 1]
    local v21 = if v18 == "pre-roll" then nil else v20.candidate
    local v22, v23 = useState(v2)

    useEffect(function() -- line: 143
        -- upvalues: v23 (copy), subscribe (copy), v2 (copy)
        return subscribe(v2, v23)
    end, {})

    local v24 = v18 == "locking"

    useEffect(function() -- line: 166
        -- upvalues: v2 (copy)
        v2(true)
    end, {})
    useEffect(function() -- line: 169
        -- upvalues: v16 (copy), v3 (copy)
        v3(v16)
    end, { v16 })
    useEffect(function() -- line: 172
        -- upvalues: v24 (copy), setCharmPodiumRollPresentationActive (copy)
        setCharmPodiumRollPresentationActive(v24)

        return function() -- line: 174
            -- upvalues: v24 (copy), setCharmPodiumRollPresentationActive (copy)
            if v24 then
                setCharmPodiumRollPresentationActive(false)
            end
        end
    end, { v24 })
    useEffect(function() -- line: 180
        -- upvalues: v12 (copy), setCharmPodiumSuccessPresentationActive (copy)
        local v25 = v12 ~= nil

        setCharmPodiumSuccessPresentationActive(v25)

        return function() -- line: 183
            -- upvalues: v25 (copy), setCharmPodiumSuccessPresentationActive (copy)
            if v25 then
                setCharmPodiumSuccessPresentationActive(false)
            end
        end
    end, { v12 })

    local t3 = {
        isBusy = false,
        money = 5E+08,
        rebirthCount = 10,
        activeCore = t1,
        canSkip = v18 == "reveal",
        candidate = v21,
        firstRollFree = v8,
        isLocking = v24,
        isRevealing = v18 == "reveal",
        onClose = function() -- onClose | line: 198
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onKeepOld = function() -- onKeepOld | line: 201
            -- upvalues: v13 (copy), t1 (copy)
            return v13({
                decision = "keep",
                core = t1
            })
        end,
        onLockComplete = function() -- onLockComplete | line: 207
            -- upvalues: v19 (copy)
            return v19("reveal")
        end,
        onReplace = function() -- onReplace | line: 210
            -- upvalues: v13 (copy), v20 (copy)
            return v13({
                decision = "replace",
                core = v20.candidate
            })
        end,
        onResolutionSuccessDismiss = function() -- onResolutionSuccessDismiss | line: 216
            -- upvalues: v13 (copy)
            return v13(nil)
        end,
        onRoll = function() -- onRoll | line: 219
            -- upvalues: v19 (copy)
            return v19("locking")
        end,
        onSkip = function() -- onSkip | line: 222
            -- upvalues: v19 (copy)
            return v19("result")
        end,
        resolutionSuccess = v12,
        resonance = v10
    }

    if v21 ~= nil then
        v21 = v21.tierId
    end

    if v21 == nil then
        v21 = 2
    end

    t3.tier = charmTierConfigs[v21]

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v22
    }, react.createElement(default4, t3)), react.createElement(default, {
        isStudded = true,
        zIndex = 3000,
        color = if v10 == 8 then Color3.fromRGB(230, 163, 36) else Color3.fromRGB(109, 73, 213),
        frameSize = UDim2.fromScale(0.18, 0.065),
        isShiny = v10 == 8,
        label = ("RESONANCE: %*/8"):format(v10),
        onClick = function() -- onClick | line: 251
            -- upvalues: v11 (copy)
            return v11(function(p2) -- line: 252
                if p2 == 8 then
                    return 3
                end

                return 8
            end)
        end,
        position = UDim2.fromScale(0.11, 0.045),
        strokeColor = Color3.fromRGB(255, 235, 172)
    }), react.createElement(default, {
        isShiny = true,
        isStudded = true,
        zIndex = 3000,
        color = if v8 then Color3.fromRGB(76, 173, 255) else Color3.fromRGB(255, 142, 42),
        frameSize = UDim2.fromScale(0.18, 0.065),
        label = ("MODE: %*"):format(v8 and "FREE ROLL" or "CASH ROLL"),
        onClick = function() -- onClick | line: 265
            -- upvalues: v9 (copy)
            return v9(function(p3) -- line: 266
                return not p3
            end)
        end,
        position = UDim2.fromScale(0.31, 0.045),
        strokeColor = Color3.fromRGB(255, 235, 172)
    }), react.createElement(default, {
        isShiny = true,
        isStudded = true,
        zIndex = 3000,
        color = Color3.fromRGB(112, 61, 188),
        frameSize = UDim2.fromScale(0.28, 0.065),
        label = ("CASE: %*"):format(v20.label),
        onClick = function() -- onClick | line: 279
            -- upvalues: v15 (copy), v19 (copy), t2 (copy)
            v15(function(p4) -- line: 280
                -- upvalues: t2 (copy)
                return (p4 + 1) % #t2
            end)
            v19("locking")
        end,
        position = UDim2.fromScale(0.56, 0.045),
        strokeColor = Color3.fromRGB(255, 221, 132)
    }), react.createElement(default, {
        isShiny = true,
        isStudded = true,
        zIndex = 3000,
        color = Color3.fromRGB(105, 62, 206),
        frameSize = UDim2.fromScale(0.25, 0.055),
        label = ("PODIUM: TIER %*"):format(v16),
        onClick = function() -- onClick | line: 294
            -- upvalues: v17 (copy), nextCharmTierId (copy)
            return v17(nextCharmTierId)
        end,
        position = UDim2.fromScale(0.5, 0.12),
        strokeColor = Color3.fromRGB(255, 223, 134)
    }), react.createElement(default, {
        isShiny = true,
        isStudded = true,
        zIndex = 3000,
        color = Color3.fromRGB(42, 122, 190),
        frameSize = UDim2.fromScale(0.18, 0.065),
        label = ("VIEW: %*"):format((string.upper(v18))),
        onClick = function() -- onClick | line: 306
            -- upvalues: v19 (copy)
            return v19(function(p5) -- line: 307
                if p5 == "pre-roll" then
                    return "locking"
                end

                if p5 == "locking" then
                    return "reveal"
                end

                if p5 == "reveal" then
                    return "result"
                end

                return "pre-roll"
            end)
        end,
        position = UDim2.fromScale(0.82, 0.045),
        strokeColor = Color3.fromRGB(178, 229, 255)
    }), not v22 and react.createElement(default, {
        isShiny = true,
        isStudded = true,
        label = "REOPEN CHARM WINDOW",
        zIndex = 3000,
        color = Color3.fromRGB(139, 76, 229),
        frameSize = UDim2.fromScale(0.22, 0.075),
        onClick = function() -- onClick | line: 320
            -- upvalues: v2 (copy)
            return v2(true)
        end,
        position = UDim2.fromScale(0.5, 0.5),
        strokeColor = Color3.fromRGB(255, 190, 99)
    }))
end

local function CharmAttributesWindowStoryWorkspace() -- line: 328
    -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), CharmPodiumPreviewScene (copy), v2 (copy), v3 (copy)
    local v31, v32 = useState(v2)

    useEffect(function() -- line: 143
        -- upvalues: v32 (copy), subscribe (copy), v2 (copy)
        return subscribe(v2, v32)
    end, {})

    local v33, v34 = useState(v3)

    useEffect(function() -- line: 150
        -- upvalues: v34 (copy), subscribe (copy), v3 (copy)
        return subscribe(v3, v34)
    end, {})

    return if v31 then react.createElement(CharmPodiumPreviewScene, {
        tierId = v33
    }) else nil
end

return storyForWorkspaceWithScreenGui({
    screenGui = react.createElement(default3, nil, react.createElement(CharmAttributesWindowStory)),
    workspace = react.createElement(default3, nil, react.createElement(CharmAttributesWindowStoryWorkspace))
})
