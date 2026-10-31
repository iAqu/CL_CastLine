-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useState = react.useCallback, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "viewport-frame-with-prefab").default
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmAttributeConfigs, charmTierConfigs = v1.charmAttributeConfigs, v1.charmTierConfigs
local charmData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charms").charmData
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local default8 = RuntimeLib.import(script, script.Parent, "charm-constellation-lock-panel").default
local default9 = RuntimeLib.import(script, script.Parent, "charm-reveal-panel").default
local default10 = RuntimeLib.import(script, script.Parent, "charm-scene-close-button").default
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(220, 211, 239)
local v4 = Color3.fromRGB(255, 224, 133)
local v5 = Color3.fromRGB(147, 67, 235)
local v6 = Color3.fromRGB(255, 139, 35)
local v7 = Color3.fromRGB(72, 223, 113)
local v8 = Color3.fromRGB(93, 103, 126)
local v9 = Color3.fromRGB(55, 65, 90)
local v10 = Color3.fromRGB(80, 95, 130)
local v11 = Color3.fromRGB(30, 35, 55)
local v12 = Color3.fromRGB(70, 80, 110)
local v13 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.06),
    NumberSequenceKeypoint.new(0.72, 0.58),
    NumberSequenceKeypoint.new(1, 1)
})
local CharmResolutionSuccessPanel, SceneVignette, PreRollPanel, SceneCloseButton, gradient, HeaderCash, ResultPanel

local function CharmAttributesWindow(p1) -- line: 38
    -- upvalues: react (copy), default3 (copy), useScreenSizeState (copy), default8 (copy), default9 (copy), v5 (copy), v6 (copy), CharmResolutionSuccessPanel (ref), SceneVignette (ref), PreRollPanel (ref), SceneCloseButton (ref), gradient (ref), HeaderCash (ref), ResultPanel (ref)
    local v14 = useScreenSizeState() == "sm"
    local v15 = not p1.isBusy and p1.rebirthCount >= p1.tier.rebirthRequirement and (p1.firstRollFree or p1.money >= p1.tier.cost)

    if p1.resolutionSuccess ~= nil then
        return react.createElement(CharmResolutionSuccessPanel, {
            onContinue = p1.onResolutionSuccessDismiss,
            resolution = p1.resolutionSuccess
        })
    end

    if p1.isLocking then
        return react.createElement(default8, {
            candidate = p1.candidate,
            onClose = p1.onClose,
            onComplete = p1.onLockComplete
        })
    end

    if p1.candidate == nil then
        local v16 = react.createElement(SceneVignette)
        local t1 = {
            canRoll = v15,
            isMobile = v14
        }

        for v17, v18 in p1 do
            t1[v17] = v18
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 900,
            Size = UDim2.fromScale(1, 1)
        }, v16, react.createElement(PreRollPanel, t1))
    end

    if p1.isRevealing then
        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 900,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(SceneVignette), react.createElement(SceneCloseButton, {
            onClose = p1.onClose
        }), react.createElement(default9, {
            activeCore = p1.activeCore,
            canSkip = p1.canSkip,
            candidate = p1.candidate,
            onSkip = p1.onSkip,
            tier = p1.tier
        }))
    end

    return react.createElement(react.Fragment, nil, react.createElement("frame", {
        Active = true,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 900,
        BackgroundColor3 = Color3.fromRGB(8, 5, 20),
        Size = UDim2.fromScale(1, 1)
    }), react.createElement(default3, {
        bodyGradientRotation = 35,
        headerGradientRotation = 0,
        title = "COMPARE OLD VS NEW",
        zIndexOffset = 1000,
        bodyBg = gradient(Color3.fromRGB(31, 14, 64), Color3.fromRGB(14, 37, 77)),
        headerBg = gradient(v5, v6),
        onClose = p1.onClose,
        size = if v14 then UDim2.fromScale(0.98, 0.9) else UDim2.fromScale(0.672, 0.82),
        titleNode = react.createElement(HeaderCash, {
            money = p1.money
        })
    }, react.createElement(ResultPanel, {
        activeCore = p1.activeCore,
        candidate = p1.candidate,
        candidateResonance = p1.resonance,
        isBusy = p1.isBusy,
        isMobile = v14,
        onKeepOld = p1.onKeepOld,
        onReplace = p1.onReplace,
        resonanceFeedback = p1.resonanceFeedback
    })))
end

function CharmResolutionSuccessPanel(p2) -- line: 119
    -- upvalues: react (copy), default4 (copy), SceneVignette (ref)
    local onContinue = p2.onContinue
    local v20 = p2.resolution.decision == "replace"
    local v21 = if v20 then Color3.fromRGB(192, 97, 255) else Color3.fromRGB(111, 232, 105)

    return react.createElement("textbutton", {
        Active = true,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 900,
        Event = {
            Activated = onContinue
        },
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(SceneVignette), react.createElement(default4, {
        shadowYScale = 0.06,
        color = v21,
        overrideProps = {
            TextScaled = true,
            ZIndex = 905,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.28, 0.075),
            Size = UDim2.fromScale(0.44, 0.08)
        },
        text = v20 and "UPDATED!" or "CURRENT CORE KEPT!"
    }), react.createElement(default4, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(235, 236, 244),
        overrideProps = {
            TextScaled = true,
            ZIndex = 905,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.22, 0.155),
            Size = UDim2.fromScale(0.56, 0.05)
        },
        text = v20 and "Your charm has been empowered." or "Your current Core is safe. Resonance increased."
    }), react.createElement(default4, {
        shadowYScale = 0.045,
        text = "TAP ANYWHERE TO CONTINUE",
        color = Color3.fromRGB(236, 235, 243),
        overrideProps = {
            TextScaled = true,
            ZIndex = 905,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.25, 0.89),
            Size = UDim2.fromScale(0.5, 0.055)
        }
    }))
end

local formatHudMoney

function HeaderCash(p3) -- line: 171
    -- upvalues: react (copy), default4 (copy), v2 (copy), formatHudMoney (ref)
    local money = p3.money

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1.16, 0.5),
        Size = UDim2.fromScale(0.825, 0.72)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(default4, {
        shadowYScale = 0.055,
        color = v2,
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0, 0.96)
        },
        text = formatHudMoney(money)
    }))
end

local SceneCash, CorePanel, AttributePool, ResonanceProgressCard, RerollPanel

function PreRollPanel(p4) -- line: 197
    -- upvalues: react (copy), default4 (copy), charmData (copy), v2 (copy), SceneCloseButton (ref), SceneCash (ref), CorePanel (ref), AttributePool (ref), ResonanceProgressCard (ref), RerollPanel (ref)
    local v24 = charmData[p4.tier.defaultVisualId]
    local v25 = if p4.isMobile then 0.3 else 0.265
    local v26 = if p4.isMobile then UDim2.fromScale(0.27, 0.025) else UDim2.fromScale(0.315, 0.025)
    local v27 = if p4.isMobile then UDim2.fromScale(0.46, 0.085) else UDim2.fromScale(0.37, 0.09)
    local t6 = {
        shadowYScale = 0.055,
        color = v2,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            Font = Enum.Font.FredokaOne,
            Position = v26,
            Size = v27
        },
        strokeProps = {
            Thickness = 0.075
        }
    }

    if v24 ~= nil then
        v24 = v24.displayName
    end

    if v24 == nil then
        v24 = p4.tier.displayName
    end

    t6.text = ("%* CHARM  •  TIER %*"):format(string.upper(v24), p4.tier.tierId)

    local v28 = react.createElement(default4, t6)
    local v29 = react.createElement(SceneCash, {
        isMobile = p4.isMobile,
        money = p4.money
    })
    local v30 = react.createElement(SceneCloseButton, {
        onClose = p4.onClose
    })
    local v31 = react.createElement(CorePanel, {
        title = "CURRENT CORE",
        visualStyle = "aura",
        core = p4.activeCore,
        position = UDim2.fromScale(0.03, 0.15),
        size = UDim2.fromScale(v25, 0.56)
    })
    local v32 = react.createElement(AttributePool, {
        position = UDim2.fromScale(0.97 - v25, 0.15),
        size = UDim2.fromScale(v25, 0.56),
        tier = p4.tier
    })
    local v33 = react.createElement(ResonanceProgressCard, {
        isMobile = p4.isMobile,
        resonance = p4.resonance
    })
    local v34 = table.clone(p4)

    setmetatable(v34, nil)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v28, v29, v30, v31, v32, v33, react.createElement(RerollPanel, v34))
end

function SceneCash(p5) -- line: 257
    -- upvalues: react (copy), default4 (copy), formatHudMoney (ref)
    local isMobile, money = p5.isMobile, p5.money
    local createElement = react.createElement
    local t7 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0)
    }

    if isMobile then
        t7.Position = UDim2.fromScale(0.945, 0.035)
        t7.Size = UDim2.fromScale(0.22, 0.06)
    else
        t7.Position = UDim2.fromScale(0.91, 0.035)
        t7.Size = UDim2.fromScale(0.19, 0.055)
    end

    return createElement("frame", t7, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(default4, {
        shadowYScale = 0.055,
        color = Color3.fromRGB(255, 231, 126),
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0, 0.9)
        },
        text = formatHudMoney(money)
    }))
end

function SceneCloseButton(p6) -- line: 283
    -- upvalues: react (copy), default10 (copy)
    local onClose = p6.onClose

    return react.createElement(default10, {
        onClose = onClose
    })
end

function SceneVignette() -- line: 289
    -- upvalues: react (copy), v13 (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(4, 6, 18),
        Size = UDim2.fromScale(0.36, 1)
    }, react.createElement("uigradient", {
        Rotation = 0,
        Transparency = v13
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(4, 6, 18),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromScale(0.36, 1)
    }, react.createElement("uigradient", {
        Rotation = 180,
        Transparency = v13
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(4, 6, 18),
        Size = UDim2.fromScale(1, 0.22)
    }, react.createElement("uigradient", {
        Rotation = 90,
        Transparency = v13
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(4, 6, 18),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0.3)
    }, react.createElement("uigradient", {
        Rotation = 270,
        Transparency = v13
    })))
end

local RerollButtonLabel, RerollInfoTooltip

function RerollPanel(p7) -- line: 328
    -- upvalues: react (copy), useState (copy), default2 (copy), default4 (copy), default5 (copy), v8 (copy), gradient (ref), RerollButtonLabel (ref), RerollInfoTooltip (ref)
    local v35, v36 = useState(false)
    local v37 = if p7.isMobile then UDim2.fromScale(0.9, 0.36) else UDim2.fromScale(0.88, 0.22)
    local v38 = if p7.isMobile then UDim2.fromScale(0.64, 0.985) else UDim2.fromScale(0.55, 0.965)
    local v39 = if p7.isMobile then UDim2.fromScale(0.52, 0.44) else UDim2.fromScale(0.3, 0.355)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = v38,
        Size = v39
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 18,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, p7.isMobile and 0.78 or 0.8),
        Size = v37
    }, react.createElement(default2, {
        cornerRadius = 0.5,
        isStudded = true,
        strokeThickness = 0.05,
        textureTransparency = 0.68,
        zIndex = 20,
        anchorPoint = Vector2.new(0, 0.5),
        backgroundColor = Color3.fromRGB(18, 20, 32),
        minimumSize = Vector2.new(44, 44),
        onClick = function() -- onClick | line: 351
            -- upvalues: v36 (copy)
            return v36(function(p8) -- line: 352
                return not p8
            end)
        end,
        position = UDim2.fromScale(p7.isMobile and 0.82 or 0.83, 0.5),
        size = UDim2.fromScale(p7.isMobile and 0.17 or 0.13, p7.isMobile and 0.96 or 0.9),
        strokeColor = Color3.fromRGB(255, 225, 127)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement(default4, {
        shadowYScale = 0.08,
        text = "!",
        color = Color3.fromRGB(255, 238, 152),
        overrideProps = {
            TextScaled = true,
            ZIndex = 23,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.28, 0.05),
            Size = UDim2.fromScale(0.44, 0.8)
        }
    })), react.createElement(default5, {
        isStudded = true,
        label = "",
        zIndex = 20,
        color = if p7.canRoll then gradient(Color3.fromRGB(255, 199, 48), Color3.fromRGB(225, 126, 18)) else gradient(v8, Color3.fromRGB(58, 63, 78)),
        disabled = not p7.canRoll,
        frameSize = UDim2.fromScale(p7.isMobile and 0.76 or 0.72, p7.isMobile and 0.86 or 0.82),
        isShiny = p7.canRoll,
        minimumSize = Vector2.new(0, 44),
        onClick = p7.onRoll,
        position = UDim2.fromScale(p7.isMobile and 0.39 or 0.42, 0.5),
        strokeColor = if p7.canRoll then Color3.fromRGB(255, 236, 145) else Color3.fromRGB(170, 175, 190)
    }, react.createElement(RerollButtonLabel, {
        firstRollFree = p7.firstRollFree,
        isBusy = p7.isBusy,
        moneyCost = p7.tier.cost
    }))), v35 and react.createElement(RerollInfoTooltip))
end

function RerollInfoTooltip() -- line: 394
    -- upvalues: react (copy), default (copy), default4 (copy), v2 (copy), gradient (ref)
    return react.createElement(default, {
        cornerRadius = 0.08,
        isStudded = true,
        strokeThickness = 0.022,
        textureTransparency = 0.72,
        zIndex = 40,
        anchorPoint = Vector2.new(0.5, 1),
        backgroundColor = gradient(Color3.fromRGB(18, 20, 42), Color3.fromRGB(8, 10, 25)),
        position = UDim2.fromScale(0.55, 0.68),
        size = UDim2.fromScale(1.014, 0.78),
        strokeColor = Color3.fromRGB(255, 225, 127)
    }, react.createElement(default4, {
        shadowYScale = 0.045,
        text = "REROLL ATTRIBUTES",
        color = Color3.fromRGB(255, 229, 133),
        overrideProps = {
            TextScaled = true,
            ZIndex = 43,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.06, 0.05),
            Size = UDim2.fromScale(0.88, 0.1),
            TextXAlignment = Enum.TextXAlignment.Left
        }
    }), react.createElement(default4, {
        shadowYScale = 0.04,
        text = "Roll generates a candidate Core. Your current Core stays equipped until you choose.",
        color = v2,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 43,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.06, 0.2),
            Size = UDim2.fromScale(0.88, 0.24),
            TextXAlignment = Enum.TextXAlignment.Left
        }
    }), react.createElement(default4, {
        shadowYScale = 0.04,
        text = "KEEP OLD grants +1 RESONANCE. At 8/8, your next Roll guarantees 1 Great+ line.",
        color = Color3.fromRGB(255, 229, 133),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 43,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.06, 0.51),
            Size = UDim2.fromScale(0.88, 0.26),
            TextXAlignment = Enum.TextXAlignment.Left
        }
    }))
end

function ResonanceProgressCard(p9) -- line: 446
    -- upvalues: react (copy), default (copy), default4 (copy), v2 (copy), v3 (copy), gradient (ref)
    local isMobile, resonance = p9.isMobile, p9.resonance
    local v41 = resonance >= 8
    local createElement = react.createElement
    local t12 = {
        cornerRadius = 0.08,
        isStudded = true,
        strokeThickness = 0.035,
        textureTransparency = 0.62,
        backgroundColor = if v41 then gradient(Color3.fromRGB(241, 142, 37), Color3.fromRGB(138, 60, 22)) else gradient(Color3.fromRGB(112, 61, 188), Color3.fromRGB(37, 32, 80))
    }

    if isMobile then
        t12.position = UDim2.fromScale(0.025, 0.735)
        t12.size = UDim2.fromScale(0.345, 0.18)
    else
        t12.position = UDim2.fromScale(0.03, 0.75)
        t12.size = UDim2.fromScale(0.33, 0.17)
    end

    t12.strokeColor = if v41 then Color3.fromRGB(255, 223, 112) else Color3.fromRGB(211, 172, 255)

    return createElement(default, t12, react.createElement(default, {
        cornerRadius = 0.5,
        isStudded = true,
        strokeThickness = 0.04,
        textureTransparency = 0.55,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = if v41 then gradient(Color3.fromRGB(255, 174, 45), Color3.fromRGB(172, 75, 24)) else gradient(Color3.fromRGB(137, 74, 220), Color3.fromRGB(51, 39, 109)),
        position = UDim2.fromScale(0.2, 0.5),
        size = UDim2.fromScale(0.3, 0.74),
        strokeColor = if v41 then Color3.fromRGB(255, 232, 135) else Color3.fromRGB(224, 193, 255)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement(default4, {
        shadowYScale = 0.055,
        color = v2,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.12, 0.18),
            Size = UDim2.fromScale(0.76, 0.31)
        },
        text = ("%* / 8"):format(resonance)
    }), react.createElement(default4, {
        shadowYScale = 0.04,
        text = "RESONANCE",
        color = v3,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.12, 0.55),
            Size = UDim2.fromScale(0.76, 0.17)
        }
    })), react.createElement(default4, {
        shadowYScale = 0.045,
        color = if v41 then Color3.fromRGB(255, 235, 142) else v2,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.39, 0.1),
            Size = UDim2.fromScale(0.55, 0.2),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = v41 and "RESONANCE READY" or "RESONANCE PROGRESS"
    }), react.createElement(default4, {
        shadowYScale = 0.04,
        text = "KEEP OLD: +1 RESONANCE",
        color = Color3.fromRGB(255, 229, 133),
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.39, 0.35),
            Size = UDim2.fromScale(0.55, 0.17),
            TextXAlignment = Enum.TextXAlignment.Left
        }
    }), react.createElement(default4, {
        shadowYScale = 0.035,
        color = v3,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.39, 0.57),
            Size = UDim2.fromScale(0.55, 0.29),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = v41 and "READY: next Roll guarantees 1 Great+ line." or "At 8/8, next Roll guarantees 1 Great+ line."
    }))
end

local formatCash

function RerollButtonLabel(p10) -- line: 529
    -- upvalues: react (copy), default4 (copy), images (copy), v2 (copy), formatCash (ref)
    local firstRollFree, isBusy, moneyCost = p10.firstRollFree, p10.isBusy, p10.moneyCost

    if not (isBusy or firstRollFree) then
        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 24,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.015, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default4, {
            shadowYScale = 0.065,
            text = "ROLL",
            color = v2,
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                ZIndex = 25,
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0, 0.72)
            }
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 25,
            Image = images.moneyIcon,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.11, 0.52)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        })), react.createElement(default4, {
            shadowYScale = 0.065,
            color = v2,
            overrideProps = {
                LayoutOrder = 3,
                TextScaled = true,
                ZIndex = 25,
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0, 0.76)
            },
            text = formatCash(moneyCost)
        }))
    end

    return react.createElement(default4, {
        shadowYScale = 0.055,
        color = v2,
        overrideProps = {
            TextScaled = true,
            ZIndex = 24,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(1, 1)
        },
        text = isBusy and "ROLLING..." or "ROLL  FREE"
    })
end

local AttributeLine, pct

function AttributePool(p11) -- line: 593
    -- upvalues: react (copy), default (copy), default4 (copy), default7 (copy), charmAttributeConfigs (copy), v2 (copy), v9 (copy), v10 (copy), AttributeLine (ref), pct (ref)
    local position, size, tier = p11.position, p11.size, p11.tier
    local v45 = react.createElement(default4, {
        shadowYScale = 0.055,
        text = "POSSIBLE RANDOM LINES",
        color = v2,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.08, 0.03),
            Size = UDim2.fromScale(0.84, 0.09),
            TextXAlignment = Enum.TextXAlignment.Left
        }
    })
    local v46 = table.create(#charmAttributeConfigs)

    local function v47(p12, p13) -- line: 611
        -- upvalues: tier (copy), react (copy), charmAttributeConfigs (copy), AttributeLine (ref), pct (ref)
        local v48 = p12.tierRanges[tier.tierId]

        return react.createElement(AttributeLine, {
            attribute = p12.displayName,
            key = p12.id,
            layoutOrder = p13,
            probability = ("(%*%%)"):format(p12.selectionWeight),
            value = ("%*–%*"):format(pct(v48.minimum), (pct(v48.maximum))),
            variant = if p13 == #charmAttributeConfigs - 1 then "gold" elseif p13 % 2 == 0 then "violet" else "blue"
        })
    end

    for v49, v50 in charmAttributeConfigs do
        v46[v49] = v47(v50, v49 - 1, charmAttributeConfigs)
    end

    return react.createElement(default, {
        cornerRadius = 0.025,
        isStudded = true,
        strokeThickness = 0.005,
        textureTransparency = 0.9,
        transparency = 0.3,
        backgroundColor = v9,
        position = position,
        size = size,
        strokeColor = v10
    }, v45, react.createElement(default7, {
        automaticCanvasSize = true,
        canvasHeightScale = 1,
        itemPaddingScale = 0.012,
        scrollBarThickness = 4,
        position = UDim2.fromScale(0.08, 0.21),
        scrollBarColor = v10,
        size = UDim2.fromScale(0.86, 0.745)
    }, v46), react.createElement("frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.08, 0.145),
        Size = UDim2.fromScale(0.86, 0.055)
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "AFFIX",
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0, 0.12),
        Size = UDim2.fromScale(0.48, 0.76),
        TextColor3 = Color3.fromRGB(190, 202, 225),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "ROLL RANGE",
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.48, 0.12),
        Size = UDim2.fromScale(0.27, 0.76),
        TextColor3 = Color3.fromRGB(190, 202, 225),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "ODDS",
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.75, 0.12),
        Size = UDim2.fromScale(0.25, 0.76),
        TextColor3 = Color3.fromRGB(190, 202, 225),
        TextXAlignment = Enum.TextXAlignment.Right
    })))
end

function AttributeLine(p14) -- line: 677
    -- upvalues: react (copy), default4 (copy), v2 (copy)
    local attribute, layoutOrder, probability, value = p14.attribute, p14.layoutOrder, p14.probability, p14.value
    local variant = p14.variant
    local v51 = if variant == "gold" then Color3.fromRGB(255, 220, 95) elseif variant == "violet" then Color3.fromRGB(205, 152, 255) else Color3.fromRGB(147, 208, 255)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 0.085)
    }, react.createElement(default4, {
        shadowYScale = 0.05,
        color = v51,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(0.48, 0.88),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = attribute
    }), react.createElement(default4, {
        shadowYScale = 0.05,
        color = v51,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.48, 0),
            Size = UDim2.fromScale(0.27, 0.88),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = value
    }), react.createElement(default4, {
        shadowYScale = 0.05,
        color = v51,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.75, 0),
            Size = UDim2.fromScale(0.25, 0.88),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = probability
    }), react.createElement("frame", {
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = v2,
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.fromScale(1, 0.035)
    }))
end

local ComparisonCoreCard, ComparisonResonanceBar, CharmDecisionConfirmPanel

function ResultPanel(p15) -- line: 740
    -- upvalues: react (copy), useState (copy), default4 (copy), default5 (copy), gradient (ref), ComparisonCoreCard (ref), ComparisonResonanceBar (ref), CharmDecisionConfirmPanel (ref)
    local activeCore, candidate, candidateResonance, isBusy = p15.activeCore, p15.candidate, p15.candidateResonance, p15.isBusy
    local onKeepOld, onReplace, resonanceFeedback = p15.onKeepOld, p15.onReplace, p15.resonanceFeedback
    local v52, v53 = useState(false)
    local v54, v55 = useState(false)
    local v56 = react.createElement(ComparisonCoreCard, {
        mode = "old",
        theme = "current",
        comparison = candidate,
        core = activeCore,
        position = UDim2.fromScale(0, 0),
        size = UDim2.fromScale(0.455, 0.69)
    })
    local v57 = react.createElement(ComparisonCoreCard, {
        mode = "new",
        theme = "candidate",
        comparison = activeCore,
        core = candidate,
        position = UDim2.fromScale(0.545, 0),
        size = UDim2.fromScale(0.455, 0.69)
    })
    local v58 = react.createElement(default4, {
        shadowYScale = 0.06,
        text = "VS",
        color = Color3.fromRGB(112, 185, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 1040,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.465, 0.25),
            Size = UDim2.fromScale(0.07, 0.12)
        }
    })
    local v59 = react.createElement(ComparisonResonanceBar, {
        position = UDim2.fromScale(0.015, 0.715),
        resonance = candidateResonance
    })
    local t18 = {
        shadowYScale = 0.04,
        color = Color3.fromRGB(226, 224, 235),
        overrideProps = {
            TextScaled = true,
            ZIndex = 1030,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.25, 0.81),
            Size = UDim2.fromScale(0.5, 0.04)
        },
        text = if resonanceFeedback == nil then "ALL ATTRIBUTES WILL BE REPLACED IF YOU CHOOSE THE NEW ROLL" else resonanceFeedback
    }
    local createElement = react.createElement
    local t19 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.025, 0.14),
        Size = UDim2.fromScale(0.95, 0.815)
    }
    local v60 = react.createElement(default4, t18)
    local v61 = react.createElement(default5, {
        isStudded = true,
        zIndex = 1035,
        color = gradient(Color3.fromRGB(72, 82, 104), Color3.fromRGB(31, 37, 52)),
        disabled = isBusy,
        frameSize = UDim2.fromScale(0.455, 0.105),
        label = isBusy and "WAIT..." or "KEEP CURRENT",
        onClick = function() -- onClick | line: 808
            -- upvalues: v53 (copy)
            return v53(true)
        end,
        position = UDim2.fromScale(0.2275, 0.925)
    })
    local v62 = react.createElement(default5, {
        isShiny = true,
        isStudded = true,
        zIndex = 1035,
        color = gradient(Color3.fromRGB(255, 205, 47), Color3.fromRGB(218, 129, 12)),
        disabled = isBusy,
        frameSize = UDim2.fromScale(0.455, 0.105),
        label = isBusy and "WAIT..." or "REPLACE",
        onClick = function() -- onClick | line: 820
            -- upvalues: v55 (copy)
            return v55(true)
        end,
        position = UDim2.fromScale(0.7725, 0.925)
    })

    v52 = v52 and react.createElement(CharmDecisionConfirmPanel, {
        decision = "keep",
        activeCore = activeCore,
        candidate = candidate,
        onCancel = function() -- onCancel | line: 829
            -- upvalues: v53 (copy)
            return v53(false)
        end,
        onConfirm = function() -- onConfirm | line: 832
            -- upvalues: onKeepOld (copy), v53 (copy)
            v53(false)
            onKeepOld()
        end
    })
    v54 = v54 and react.createElement(CharmDecisionConfirmPanel, {
        decision = "replace",
        activeCore = activeCore,
        candidate = candidate,
        onCancel = function() -- onCancel | line: 840
            -- upvalues: v55 (copy)
            return v55(false)
        end,
        onConfirm = function() -- onConfirm | line: 843
            -- upvalues: onReplace (copy), v55 (copy)
            v55(false)
            onReplace()
        end
    })

    return createElement("frame", t19, v56, v57, v58, v59, v60, v61, v62, v52, v54)
end

local initializeCharmViewportModel

function CharmDecisionConfirmPanel(p16) -- line: 850
    -- upvalues: react (copy), useCallback (copy), default (copy), default3 (copy), default4 (copy), default5 (copy), default6 (copy), charmTierConfigs (copy), charmData (copy), images (copy), gradient (ref), initializeCharmViewportModel (ref)
    local activeCore, candidate, decision, onCancel = p16.activeCore, p16.candidate, p16.decision, p16.onCancel
    local onConfirm = p16.onConfirm
    local v63 = decision == "replace"

    if not v63 then
        candidate = activeCore or candidate
    end

    local v64 = charmData[charmTierConfigs[candidate.tierId].defaultVisualId]
    local v65 = if v63 then Color3.fromRGB(198, 103, 255) else Color3.fromRGB(119, 244, 108)
    local v66 = if v63 then gradient(Color3.fromRGB(203, 102, 255), Color3.fromRGB(92, 47, 181)) else gradient(Color3.fromRGB(84, 211, 74), Color3.fromRGB(20, 115, 45))
    local v67 = if v63 then gradient(Color3.fromRGB(31, 13, 64), Color3.fromRGB(5, 12, 30)) else gradient(Color3.fromRGB(7, 28, 29), Color3.fromRGB(5, 12, 25))
    local v71 = useCallback(function() -- line: 863
        -- upvalues: v64 (copy)
        local v69 = v64

        if v64 ~= nil then
            v69 = v64.model
        end

        if v69 == nil then
            v69 = Instance.new("Model")
        end

        return v69
    end, { if v64 == nil then v64 else v64.model })
    local v72 = react.createElement("frame", {
        Active = true,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 1090,
        BackgroundColor3 = Color3.fromRGB(2, 5, 12),
        Position = UDim2.fromScale(-0.03, -0.17),
        Size = UDim2.fromScale(1.06, 1.2)
    })
    local v73 = react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    })
    local v74 = react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    })
    local v75 = react.createElement("uistroke", {
        Thickness = 0.025,
        Color = v65
    })
    local v76 = if v64 == nil then v64 else v64.model
    local v77

    if v76 ~= nil then
        v77 = react.createElement(default6, {
            cameraFov = 34,
            cameraCFrame = CFrame.new(Vector3.new(0, 0.2, -7), (Vector3.new(0, 0.2, 0))),
            getPrefabInstance = v71,
            onPrefabInstantiated = initializeCharmViewportModel,
            viewportFrameProps = {
                BackgroundTransparency = 1,
                LightDirection = Vector3.new(-1, -0.7, -0.4),
                ZIndex = 1104,
                Ambient = if v63 then Color3.fromRGB(222, 188, 255) else Color3.fromRGB(185, 232, 190),
                LightColor = if v63 then Color3.fromRGB(241, 221, 255) else Color3.fromRGB(225, 255, 228),
                Size = UDim2.fromScale(1, 1)
            }
        })
    else
        local t24 = {
            BackgroundTransparency = 1
        }
        local v78 = if v64 == nil then v64 else v64.imageId

        t24.Image = if v78 == nil then images.charmIcon else v78
        t24.Position = UDim2.fromScale(0.12, 0.12)
        t24.ScaleType = Enum.ScaleType.Fit
        t24.Size = UDim2.fromScale(0.76, 0.76)
        t24.ZIndex = 1104
        v77 = react.createElement("imagelabel", t24)
    end

    return react.createElement(react.Fragment, nil, v72, react.createElement(default3, {
        bodyGradientRotation = 35,
        headerGradientRotation = 0,
        zIndexOffset = 1100,
        bodyBg = v67,
        headerBg = v66,
        onClose = onCancel,
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(0.68, 0.93),
        title = v63 and "REPLACE WITH NEW ROLL?" or "KEEP CURRENT ATTRIBUTES?"
    }, react.createElement("frame", {
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 1102,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(3, 18, 22),
        Position = UDim2.fromScale(0.5, 0.17),
        Size = UDim2.fromScale(0.39, 0.39)
    }, v73, v74, v75, v77), react.createElement(default, {
        cornerRadius = 0.045,
        isStudded = true,
        strokeThickness = 0.012,
        textureTransparency = 0.86,
        zIndex = 1102,
        anchorPoint = Vector2.new(0.5, 0),
        backgroundColor = Color3.fromRGB(8, 16, 28),
        position = UDim2.fromScale(0.5, 0.59),
        size = UDim2.fromScale(0.82, 0.16),
        strokeColor = Color3.fromRGB(57, 93, 99)
    }, react.createElement(default4, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(237, 239, 246),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 1105,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.18),
            Size = UDim2.fromScale(0.84, 0.64)
        },
        text = v63 and "You will replace all current attributes with the new roll." or "You will keep your current attributes and discard the new roll."
    })), react.createElement(default5, {
        isStudded = true,
        label = "CANCEL",
        zIndex = 1110,
        color = gradient(Color3.fromRGB(75, 82, 101), Color3.fromRGB(30, 37, 51)),
        frameSize = UDim2.fromScale(0.38, 0.12),
        onClick = onCancel,
        position = UDim2.fromScale(0.28, 0.86)
    }), react.createElement(default5, {
        isShiny = true,
        isStudded = true,
        zIndex = 1110,
        color = if v63 then gradient(Color3.fromRGB(255, 205, 47), Color3.fromRGB(218, 129, 12)) else gradient(Color3.fromRGB(95, 210, 76), Color3.fromRGB(22, 122, 39)),
        frameSize = UDim2.fromScale(0.42, 0.12),
        label = v63 and "REPLACE" or "KEEP CURRENT",
        onClick = onConfirm,
        position = UDim2.fromScale(0.72, 0.86),
        strokeColor = if v63 then Color3.fromRGB(255, 235, 140) else Color3.fromRGB(151, 255, 137)
    })))
end

local buildComparisonCoreLines, CharmModelPreview, ComparisonCoreLine

function ComparisonCoreCard(p17) -- line: 1000
    -- upvalues: react (copy), default (copy), default4 (copy), default7 (copy), charmTierConfigs (copy), charmData (copy), gradient (ref), buildComparisonCoreLines (ref), CharmModelPreview (ref), ComparisonCoreLine (ref)
    local comparison, core, mode, position = p17.comparison, p17.core, p17.mode, p17.position
    local size, theme = p17.size, p17.theme
    local v82 = if theme == "current" then Color3.fromRGB(83, 218, 94) else Color3.fromRGB(199, 105, 255)
    local v83 = buildComparisonCoreLines(core, comparison, mode)
    local t31 = {}

    local function v84(p18) -- line: 1011
        return p18.status ~= "missing"
    end

    local n1 = 0

    for v85, v86 in v83 do
        local _ = v85 - 1

        if v86.status ~= "missing" == true then
            n1 += 1
            t31[n1] = v86
        end
    end

    local v87 = if core ~= nil then charmData[charmTierConfigs[core.tierId].defaultVisualId] else nil
    local v88 = react.createElement(default4, {
        shadowYScale = 0.045,
        color = v82,
        overrideProps = {
            TextScaled = true,
            ZIndex = 1025,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.025),
            Size = UDim2.fromScale(0.84, 0.075)
        },
        text = theme == "current" and "CURRENT (ACTIVE)" or "NEW ROLL (CANDIDATE)"
    })
    local t33 = {
        charmImage = if v87 == nil then v87 else v87.imageId,
        charmModel = if v87 ~= nil then v87.model else v87,
        color = v82
    }
    local v89 = react.createElement(CharmModelPreview, t33)
    local v90 = react.createElement(default4, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(235, 234, 240),
        overrideProps = {
            TextScaled = true,
            ZIndex = 1025,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.2, 0.37),
            Size = UDim2.fromScale(0.6, 0.06)
        },
        text = if core == nil then "NO ACTIVE CHARM" else ("TIER %* CHARM"):format(core.tierId)
    })
    local v91 = table.create(#t31)

    for v92, v93 in t31 do
        local v94 = v92 - 1

        v91[v92] = react.createElement(ComparisonCoreLine, {
            key = ("%*-%*-%*"):format(mode, v94, v93.label),
            layoutOrder = v94,
            line = v93,
            showArrow = mode == "new"
        })
    end

    return react.createElement(default, {
        cornerRadius = 0.045,
        isStudded = false,
        strokeThickness = 0.012,
        transparency = 0.12,
        zIndex = 1020,
        backgroundColor = if theme == "current" then gradient(Color3.fromRGB(10, 45, 39), Color3.fromRGB(7, 21, 31)) else gradient(Color3.fromRGB(35, 19, 63), Color3.fromRGB(10, 17, 35)),
        position = position,
        size = size,
        strokeColor = v82:Lerp(Color3.fromRGB(45, 50, 64), 0.45)
    }, v88, v89, v90, react.createElement(default7, {
        automaticCanvasSize = true,
        canvasHeightScale = 1,
        itemPaddingScale = 0.006,
        scrollBarThickness = 3,
        zIndex = 1025,
        position = UDim2.fromScale(0.05, 0.45),
        scrollBarColor = v82,
        size = UDim2.fromScale(0.9, 0.51)
    }, v91))
end

function CharmModelPreview(p19) -- line: 1103
    -- upvalues: react (copy), useCallback (copy), default6 (copy), images (copy), initializeCharmViewportModel (ref)
    local charmImage, charmModel, color = p19.charmImage, p19.charmModel, p19.color
    local v95 = useCallback(function() -- line: 1107
        -- upvalues: charmModel (copy)
        return charmModel or Instance.new("Model")
    end, { charmModel })
    local v96 = react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    })
    local v97 = react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    })
    local v98 = react.createElement("uistroke", {
        Thickness = 0.045,
        Transparency = 0.08,
        Color = color
    })
    local v99

    if charmModel ~= nil then
        v99 = react.createElement(default6, {
            cameraFov = 34,
            cameraCFrame = CFrame.new(Vector3.new(0, 0.2, -7), (Vector3.new(0, 0.2, 0))),
            getPrefabInstance = v95,
            onPrefabInstantiated = initializeCharmViewportModel,
            viewportFrameProps = {
                BackgroundTransparency = 1,
                LightDirection = Vector3.new(-1, -0.7, -0.4),
                ZIndex = 1024,
                Ambient = Color3.fromRGB(185, 202, 235),
                LightColor = Color3.fromRGB(225, 238, 255),
                Size = UDim2.fromScale(1, 1)
            }
        })

        return react.createElement("frame", {
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            ZIndex = 1023,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(5, 10, 23),
            Position = UDim2.fromScale(0.5, 0.115),
            Size = UDim2.fromScale(0.34, 0.24)
        }, v96, v97, v98, v99)
    end

    local t36 = {
        BackgroundTransparency = 1
    }

    t36.Image = if charmImage == nil then images.charmIcon else charmImage
    t36.Position = UDim2.fromScale(0.12, 0.12)
    t36.ScaleType = Enum.ScaleType.Fit
    t36.Size = UDim2.fromScale(0.76, 0.76)
    t36.ZIndex = 1024
    v99 = react.createElement("imagelabel", t36)

    return react.createElement("frame", {
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 1023,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(5, 10, 23),
        Position = UDim2.fromScale(0.5, 0.115),
        Size = UDim2.fromScale(0.34, 0.24)
    }, v96, v97, v98, v99)
end

local getCoreLineStyle

function ComparisonCoreLine(p20) -- line: 1164
    -- upvalues: react (copy), v2 (copy), getCoreLineStyle (ref)
    local layoutOrder, line, showArrow = p20.layoutOrder, p20.line, p20.showArrow
    local v100 = getCoreLineStyle(line.quality)
    local v101 = line.status == "lost"
    local v102 = if line.delta == nil and line.status == "new" or line.delta ~= nil and line.delta > 0 then "up" elseif line.delta == nil or not (line.delta < 0) then "same" else "down"
    local v103 = if v102 == "up" then Color3.fromRGB(82, 230, 111) elseif v102 == "down" then Color3.fromRGB(255, 91, 72) else Color3.fromRGB(177, 185, 204)
    local createElement = react.createElement
    local t37 = {
        BackgroundTransparency = 1,
        ZIndex = 1026,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(0.97, 0.18)
    }
    local v104 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1027,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.02, 0.08),
        Size = UDim2.fromScale(0.1, 0.78),
        Text = line.icon,
        TextColor3 = v100.textColor,
        TextTransparency = v101 and 0.45 or 0
    })
    local v105 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1027,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.14, 0.08),
        Size = UDim2.fromScale(0.2, 0.78),
        Text = line.valueText,
        TextColor3 = v2,
        TextTransparency = v101 and 0.45 or 0,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v106 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1027,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.35, 0.08),
        Size = UDim2.fromScale(showArrow and 0.46 or 0.59, 0.78),
        Text = line.label,
        TextColor3 = Color3.fromRGB(232, 235, 244),
        TextTransparency = v101 and 0.45 or 0,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    showArrow = showArrow and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1027,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.85, 0.03),
        Size = UDim2.fromScale(0.1, 0.86),
        Text = if v102 == "up" then "▲" elseif v102 == "down" then "▼" else "—",
        TextColor3 = v103
    })

    return createElement("frame", t37, v104, v105, v106, showArrow, react.createElement("frame", {
        BackgroundTransparency = 0.52,
        BorderSizePixel = 0,
        ZIndex = 1026,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(72, 81, 101),
        Position = UDim2.fromScale(0.02, 1),
        Size = UDim2.fromScale(0.94, 0.016)
    }))
end

function ComparisonResonanceBar(p21) -- line: 1228
    -- upvalues: react (copy), v2 (copy)
    local position, resonance = p21.position, p21.resonance
    local v108 = math.clamp(resonance / 8, 0, 1)
    local v109 = resonance >= 8
    local v110 = if v109 then Color3.fromRGB(244, 151, 34) else Color3.fromRGB(182, 91, 255)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Position = position,
        Size = UDim2.fromScale(0.97, 0.08)
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1030,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromScale(0.36, 0.36),
        Text = v109 and "RESONANCE READY" or "RESONANCE PROGRESS",
        TextColor3 = if v109 then Color3.fromRGB(255, 220, 116) else Color3.fromRGB(225, 226, 236),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1030,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.88, 0),
        Size = UDim2.fromScale(0.12, 0.36),
        Text = ("%* / 8"):format(resonance),
        TextColor3 = v2,
        TextXAlignment = Enum.TextXAlignment.Right
    }), react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 1030,
        BackgroundColor3 = Color3.fromRGB(22, 28, 41),
        Position = UDim2.fromScale(0, 0.53),
        Size = UDim2.fromScale(1, 0.28)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.08,
        Color = Color3.fromRGB(78, 84, 101)
    }), react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 1031,
        BackgroundColor3 = v110,
        Size = UDim2.fromScale(v108, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    }))))
end

function initializeCharmViewportModel(p22) -- line: 1277
    for _, descendant in p22:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    local BoundingBox, BoundingBox2 = p22:GetBoundingBox()
    local v111 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

    if v111 > 0.01 then
        p22:ScaleTo(p22:GetScale() * (4 / v111))
        BoundingBox = p22:GetBoundingBox()
    end

    local v112 = BoundingBox:ToObjectSpace(p22:GetPivot())

    p22:PivotTo(CFrame.Angles(0, 0.3141592653589793, 0) * v112)
end

local function ResonanceDecisionHint(p23) -- line: 1297
    -- upvalues: react (copy), default4 (copy)
    local feedback, isMobile = p23.feedback, p23.isMobile
    local t44 = {
        shadowYScale = 0.05,
        color = Color3.fromRGB(255, 230, 126)
    }
    local t45 = {
        TextScaled = true,
        Font = Enum.Font.FredokaOne
    }

    if isMobile then
        t45.Position = UDim2.fromScale(0.12, 0.675)
        t45.Size = UDim2.fromScale(0.76, 0.06)
    else
        t45.Position = UDim2.fromScale(0.29, 0.73)
        t45.Size = UDim2.fromScale(0.42, 0.055)
    end

    t45.TextXAlignment = Enum.TextXAlignment.Center
    t44.overrideProps = t45
    t44.text = if feedback == nil then "KEEP OLD → RESONANCE +1" else feedback

    return react.createElement(default4, t44)
end

local buildCandidateResultLines, CandidateResultLine

local function CandidateResultCard(p24) -- line: 1319
    -- upvalues: react (copy), default7 (copy), buildCandidateResultLines (ref), CandidateResultLine (ref)
    local activeCore, candidate, position, size = p24.activeCore, p24.candidate, p24.position, p24.size
    local v113 = buildCandidateResultLines(candidate, activeCore)
    local v114 = table.create(#v113)

    for v115, v116 in v113 do
        local v117 = v115 - 1

        v114[v115] = react.createElement(CandidateResultLine, {
            key = ("%*-%*"):format(v117, v116.label),
            layoutOrder = v117,
            line = v116
        })
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Position = position,
        Size = size
    }, react.createElement(default7, {
        automaticCanvasSize = true,
        canvasHeightScale = 1,
        itemPaddingScale = 0.022,
        scrollBarThickness = 4,
        zIndex = 1010,
        position = UDim2.fromScale(0, 0),
        scrollBarColor = Color3.fromRGB(184, 120, 255),
        size = UDim2.fromScale(1, 1)
    }, v114))
end

function CandidateResultLine(p25) -- line: 1353
    -- upvalues: react (copy), default (copy), v2 (copy), getCoreLineStyle (ref)
    local layoutOrder, line = p25.layoutOrder, p25.line
    local v118 = getCoreLineStyle(line.quality)
    local v119 = if line.delta == nil or line.delta > 0 then "up" elseif line.delta < 0 then "down" else "same"
    local v120 = if v119 == "up" then Color3.fromRGB(82, 230, 111) elseif v119 == "down" then Color3.fromRGB(255, 94, 86) else Color3.fromRGB(193, 199, 217)

    return react.createElement(default, {
        cornerRadius = 0.11,
        isStudded = true,
        strokeThickness = 0.026,
        textureTransparency = 0.72,
        zIndex = 1011,
        backgroundColor = v118.backgroundColor,
        layoutOrder = layoutOrder,
        size = UDim2.fromScale(0.98, 0.17),
        strokeColor = v118.strokeColor
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1012,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.05, 0.09),
        Size = UDim2.fromScale(0.24, 0.82),
        Text = line.valueText,
        TextColor3 = v2,
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1012,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.28, 0.09),
        Size = UDim2.fromScale(0.55, 0.82),
        Text = line.label,
        TextColor3 = v118.textColor,
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1012,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.84, 0.03),
        Size = UDim2.fromScale(0.11, 0.94),
        Text = if v119 == "up" then "▲" elseif v119 == "down" then "▼" else "—",
        TextColor3 = v120
    }))
end

local function StatusRibbon(p26) -- line: 1400
    -- upvalues: react (copy), default (copy), default4 (copy), v2 (copy), gradient (ref)
    local color, hidden, text = p26.color, p26.hidden, p26.text

    if hidden then
        return nil
    end

    return react.createElement(default, {
        cornerRadius = 0.16,
        isStudded = true,
        strokeThickness = 0.035,
        textureTransparency = 0.68,
        backgroundColor = gradient(color:Lerp(v2, 0.12), color:Lerp(Color3.fromRGB(28, 20, 68), 0.4)),
        size = UDim2.fromScale(1, 0.09),
        strokeColor = v2
    }, react.createElement(default4, {
        shadowYScale = 0.05,
        color = v2,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.03, 0.08),
            Size = UDim2.fromScale(0.94, 0.82)
        },
        text = text
    }))
end

local AuraCoreLine

function CorePanel(p27) -- line: 1429
    -- upvalues: react (copy), default (copy), default4 (copy), v2 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), gradient (ref), pct (ref), buildComparisonCoreLines (ref), getCoreLineStyle (ref), AuraCoreLine (ref)
    local comparison, core, hidden, mode = p27.comparison, p27.core, p27.hidden, p27.mode
    local position, size, title, titleColor = p27.position, p27.size, p27.title, p27.titleColor

    if titleColor == nil then
        titleColor = v2
    end

    local visualStyle = p27.visualStyle

    if hidden then
        return nil
    end

    local v123 = buildComparisonCoreLines(core, comparison, mode)
    local v124 = if visualStyle == "aura" then react.createElement(default4, {
        shadowYScale = 0.055,
        color = v2,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.06, 0.03),
            Size = UDim2.fromScale(0.85, 0.09),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = title
    }) else react.createElement(default, {
        cornerRadius = 0.08,
        isStudded = true,
        strokeThickness = 0.035,
        textureTransparency = 0.65,
        backgroundColor = gradient(titleColor:Lerp(v5, 0.48), titleColor:Lerp(v6, 0.38)),
        position = UDim2.fromScale(0.04, 0.04),
        size = UDim2.fromScale(0.92, 0.14),
        strokeColor = v2
    }, react.createElement(default4, {
        shadowYScale = 0.055,
        color = v2,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(1, 1)
        },
        text = title
    }))
    local v125 = visualStyle == "aura" and react.createElement(default, {
        cornerRadius = 0.08,
        strokeThickness = 0.01,
        transparency = 0.15,
        backgroundColor = v11,
        position = UDim2.fromScale(0.06, 0.16),
        size = UDim2.fromScale(0.88, 0.76),
        strokeColor = v12
    })
    local v126 = react.createElement("uilistlayout", {
        Padding = UDim.new(0.025, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v127 = table.create(#v123)

    local function v128(p28, p29) -- line: 1491
        -- upvalues: mode (copy), visualStyle (copy), react (copy), default (copy), v7 (copy), pct (ref), getCoreLineStyle (ref), AuraCoreLine (ref)
        local v129 = getCoreLineStyle(p28.quality)
        local v130 = p28.status == "lost" or p28.status == "missing"
        local v131 = if p28.delta == nil or p28.delta == 0 then v129.textColor elseif p28.delta > 0 then v7 else Color3.fromRGB(255, 105, 116)

        if visualStyle == "aura" then
            return (react.createElement(AuraCoreLine, {
                isDimmed = v130,
                key = ("%*-%*"):format(p29, p28.label),
                layoutOrder = p29,
                line = p28,
                mode = mode,
                style = v129
            }))
        end

        local createElement = react.createElement
        local t48 = {
            cornerRadius = 0.12,
            isStudded = true,
            strokeThickness = 0.028,
            backgroundColor = if v130 then Color3.fromRGB(55, 55, 74) else v129.backgroundColor,
            key = ("%*-%*"):format(p29, p28.label),
            layoutOrder = p29,
            size = UDim2.new(1, -5, 0, 28),
            strokeColor = v129.strokeColor,
            textureTransparency = v130 and 0.9 or 0.72
        }
        local v132 = react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.045, 0.04),
            Size = UDim2.fromScale(0.53, 0.9),
            Text = p28.label,
            TextColor3 = v129.textColor,
            TextTransparency = v130 and 0.45 or 0,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local v133 = react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.57, 0.04),
            Size = UDim2.fromScale(0.2, 0.9),
            Text = p28.valueText,
            TextColor3 = v129.textColor,
            TextTransparency = v130 and 0.45 or 0,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        local createElement4, t51, v134, v135

        if mode ~= "new" or p28.delta == nil or p28.delta == 0 then
            v135 = false
        else
            createElement4 = react.createElement
            t51 = {
                BackgroundTransparency = 1,
                TextScaled = true,
                Font = Enum.Font.FredokaOne,
                Position = UDim2.fromScale(0.78, 0.04),
                Size = UDim2.fromScale(0.17, 0.9)
            }
            v134 = if p28.delta > 0 then "+" else ""
            t51.Text = ("%*%*"):format(v134, (pct(p28.delta)))
            t51.TextColor3 = v131
            t51.TextXAlignment = Enum.TextXAlignment.Right
            v135 = createElement4("textlabel", t51)
        end

        return (createElement(default, t48, v132, v133, v135, p28.status ~= nil and p28.status ~= "missing" and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.77, 0.04),
            Size = UDim2.fromScale(0.18, 0.9),
            Text = p28.status == "new" and "NEW" or "LOST",
            TextColor3 = if p28.status == "new" then Color3.fromRGB(255, 222, 88) else Color3.fromRGB(170, 170, 186),
            TextXAlignment = Enum.TextXAlignment.Right
        })))
    end

    for v137, v138 in v123 do
        v127[v137] = v128(v138, v137 - 1, v123)
    end

    return react.createElement(default, {
        isStudded = true,
        backgroundColor = if visualStyle == "aura" then v9 else gradient(Color3.fromRGB(42, 34, 105), Color3.fromRGB(25, 49, 103)),
        cornerRadius = visualStyle == "aura" and 0.025 or 0.055,
        position = position,
        size = size,
        strokeColor = if visualStyle == "aura" then v10 else v4,
        strokeThickness = visualStyle == "aura" and 0.005 or 0.008,
        textureTransparency = visualStyle == "aura" and 0.9 or 0.8,
        transparency = if visualStyle == "aura" then 0.3 else nil
    }, v124, v125, react.createElement("scrollingframe", {
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Position = if visualStyle == "aura" then UDim2.fromScale(0.11, 0.22) else UDim2.fromScale(0.06, 0.23),
        ScrollBarImageColor3 = if visualStyle == "aura" then v10 else Color3.fromRGB(255, 201, 100),
        Size = if visualStyle == "aura" then UDim2.fromScale(0.78, 0.62) else UDim2.fromScale(0.88, 0.7)
    }, v126, v127))
end

function AuraCoreLine(p30) -- line: 1576
    -- upvalues: react (copy), v2 (copy), v7 (copy), pct (ref)
    local isDimmed, layoutOrder, line, mode = p30.isDimmed, p30.layoutOrder, p30.line, p30.mode
    local style = p30.style
    local v139 = if line.delta == nil or line.delta == 0 then style.textColor elseif line.delta > 0 then v7 else Color3.fromRGB(255, 105, 116)
    local createElement = react.createElement
    local t55 = {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 0.15)
    }
    local v140 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0, 0.04),
        Size = UDim2.fromScale(0.57, 0.78),
        Text = line.label,
        TextColor3 = if isDimmed then Color3.fromRGB(160, 165, 178) else style.textColor,
        TextTransparency = isDimmed and 0.45 or 0,
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uistroke", {
        Thickness = 1,
        Color = Color3.fromRGB(0, 0, 0)
    }))
    local v141 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.6, 0.04),
        Size = UDim2.fromScale(0.22, 0.78),
        Text = line.valueText,
        TextColor3 = style.textColor,
        TextTransparency = isDimmed and 0.45 or 0,
        TextXAlignment = Enum.TextXAlignment.Right
    }, react.createElement("uistroke", {
        Thickness = 1,
        Color = Color3.fromRGB(0, 0, 0)
    }))
    local createElement4, t58, v142, v143

    if mode ~= "new" then
        v143 = false

        return createElement("frame", t55, v140, v141, v143, react.createElement("frame", {
            BackgroundTransparency = 0.88,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = v2,
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(1, 0.025)
        }))
    end

    if line.delta == nil or line.delta == 0 then
        v143 = false
    else
        createElement4 = react.createElement
        t58 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.84, 0.04),
            Size = UDim2.fromScale(0.16, 0.78)
        }
        v142 = if line.delta > 0 then "+" else ""
        t58.Text = ("%*%*"):format(v142, (pct(line.delta)))
        t58.TextColor3 = v139
        t58.TextXAlignment = Enum.TextXAlignment.Right
        v143 = createElement4("textlabel", t58, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.fromRGB(0, 0, 0)
        }))
    end

    return createElement("frame", t55, v140, v141, v143, react.createElement("frame", {
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = v2,
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.fromScale(1, 0.025)
    }))
end

function buildCandidateResultLines(p31, p32) -- line: 1634
    -- upvalues: buildComparisonCoreLines (ref)
    local new = buildComparisonCoreLines(p31, p32, "new")
    local t59 = {}

    local function v144(p33) -- line: 1638
        return p33.status ~= "missing"
    end

    local n2 = 0

    for v145, v146 in new do
        local _ = v145 - 1

        if v146.status ~= "missing" == true then
            n2 += 1
            t59[n2] = v146
        end
    end

    return t59
end

function getCoreLineStyle(p34) -- line: 1651
    -- upvalues: rarityColors (copy)
    if p34 == nil then
        return {
            backgroundColor = Color3.fromRGB(42, 122, 190),
            strokeColor = Color3.fromRGB(166, 230, 255),
            textColor = rarityColors.rare
        }
    end

    if p34 == "standard" then
        return {
            backgroundColor = Color3.fromRGB(63, 74, 101),
            strokeColor = Color3.fromRGB(146, 163, 197),
            textColor = rarityColors.common
        }
    end

    if p34 == "good" then
        return {
            backgroundColor = Color3.fromRGB(44, 140, 81),
            strokeColor = Color3.fromRGB(144, 239, 171),
            textColor = rarityColors.uncommon
        }
    end

    if p34 == "great" then
        return {
            backgroundColor = Color3.fromRGB(112, 61, 188),
            strokeColor = Color3.fromRGB(213, 166, 255),
            textColor = rarityColors.epic
        }
    end

    return {
        backgroundColor = Color3.fromRGB(202, 142, 29),
        strokeColor = Color3.fromRGB(255, 234, 133),
        textColor = rarityColors.legendary
    }
end

local addComparisonCoreLine, getCharmAttributeIcon

function buildComparisonCoreLines(p35, p36, p37) -- line: 1687
    -- upvalues: charmAttributeConfigs (copy), addComparisonCoreLine (ref), getCharmAttributeIcon (ref)
    if p35 == nil and p36 == nil then
        return {
            {
                icon = "?",
                label = "NO ACTIVE CHARM CORE",
                valueText = "—"
            }
        }
    end

    local t60 = {}
    local v147 = if p35 == nil then p35 else p35.trainingPower
    local v148 = if p36 == nil then p36 else p36.trainingPower

    addComparisonCoreLine(t60, "⚔", "TRAINING POWER", v147, v148, p37)

    for _, v149 in charmAttributeConfigs do
        local v150

        if p35 ~= nil then
            for v151, v152 in p35.affixes do
                local _ = v151 - 1

                if v152.attributeId == v149.id == true then
                    v150 = v152
                    break
                end

                v150 = nil
            end
        else
            v150 = p35
        end

        local v153

        if p36 ~= nil then
            for v154, v155 in p36.affixes do
                local _ = v154 - 1

                if v155.attributeId == v149.id == true then
                    v153 = v155
                    break
                end

                v153 = nil
            end
        else
            v153 = p36
        end

        if v150 ~= nil or v153 ~= nil then
            local v157 = getCharmAttributeIcon(v149.id)
            local displayName = v149.displayName
            local value = if v150 == nil then v150 else v150.value

            if v153 ~= nil then
                v153 = v153.value
            end

            if v150 ~= nil then
                v150 = v150.quality
            end

            addComparisonCoreLine(t60, v157, displayName, value, v153, p37, v150)
        end
    end

    return t60
end

function addComparisonCoreLine(p38, p39, p40, p41, p42, p43, p44) -- line: 1764
    -- upvalues: pct (ref)
    local v158 = if p43 == "new" and p41 ~= nil and p42 == nil then "new"
        elseif p43 == "old" and p41 ~= nil and p42 == nil then "lost"
        elseif p41 == nil then "missing"
        else nil

    table.insert(p38, {
        delta = if p41 == nil or p42 == nil then nil else p41 - p42,
        icon = p39,
        label = p40,
        quality = p44,
        status = v158,
        valueText = if p41 == nil then "—" else ("+%*"):format((pct(p41)))
    })
end

local function getComparisonTitle(p45, p46) -- line: 1777
    -- upvalues: charmTierConfigs (copy), charmData (copy)
    if p46 == nil then
        return (("%* • NO ACTIVE CORE"):format(p45))
    end

    local v159 = charmData[charmTierConfigs[p46.tierId].defaultVisualId]

    if v159 ~= nil then
        v159 = v159.displayName
    end

    local tierId = p46.tierId

    if v159 == nil then
        v159 = "CHARM CORE"
    end

    return (("%* • TIER %* • %*"):format(p45, tierId, v159))
end

function getCharmAttributeIcon(p47) -- line: 1795
    if p47 == "mutationLuck" then
        return "♣"
    end

    if p47 == "aquariumIncome" then
        return "●"
    end

    if p47 == "shopDiscount" then
        return "%"
    end

    if p47 == "bonusLuck" then
        return "★"
    end

    if p47 == "weatherMutationLuck" then
        return "☁"
    end

    if p47 == "championMutationChance" then
        return "◆"
    end

    if p47 == "baitHopDistance" then
        return "↗"
    end

    if p47 == "bossFishDamage" then
        return "◎"
    end

    return "◉"
end

function gradient(p48, p49) -- line: 1822
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p48),
        ColorSequenceKeypoint.new(1, p49)
    })
end

function pct(p50) -- line: 1825
    return (`{ math.round(p50 * 1000) / 10 }%`)
end

function formatCash(p51) -- line: 1828
    if p51 >= 1E+09 then
        return (`{ p51 / 1E+09 }B`)
    end

    return (`{ p51 / 1E+06 }M`)
end

function formatHudMoney(p52) -- line: 1834
    -- upvalues: abbreviate (copy)
    return (("%*$"):format((abbreviate(p52))))
end

return {
    default = CharmAttributesWindow
}
