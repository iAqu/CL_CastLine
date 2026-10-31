-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmAttributeConfigs, isMajorCharmCandidate = v1.charmAttributeConfigs, v1.isMajorCharmCandidate
local v2 = Color3.fromRGB(255, 255, 255)
local getTierFlourishName, TierFlourish, RevealLine, getRevealDirection, pct, getAttributeIcon, getAttributeName

local function CharmRevealPanel(p1) -- line: 17
    -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), playClonedSound (copy), default (copy), default2 (copy), default3 (copy), isMajorCharmCandidate (copy), v2 (copy), getTierFlourishName (ref), TierFlourish (ref), RevealLine (ref), getRevealDirection (ref), pct (ref), getAttributeIcon (ref), getAttributeName (ref)
    local activeCore, canSkip, candidate, onSkip = p1.activeCore, p1.canSkip, p1.candidate, p1.onSkip
    local tier = p1.tier
    local wake, wake2 = useState("wake")
    local v3, v4 = useState(0)
    local v5, v6 = useMotion(0)
    local v7 = isMajorCharmCandidate(candidate)

    useEffect(function() -- line: 27
        -- upvalues: candidate (copy), wake2 (copy), v4 (copy), v6 (copy), v7 (copy), playClonedSound (copy)
        wake2("wake")
        v4(0)
        v6:immediate(0)

        local v8 = false
        local v9 = task.spawn(function() -- line: 32
            -- upvalues: v8 (ref), candidate (copy), wake2 (copy), v4 (copy), v6 (copy), v7 (copy), playClonedSound (copy)
            playClonedSound("AuraFarm", {
                playbackSpeed = 1.08,
                volume = 0.65
            })
            task.wait(0.3)
            wake2("core")
            playClonedSound("CrateTapSound", {
                playbackSpeed = 0.96,
                volume = 0.7
            })
            task.wait(0.8)
            wake2("affixes")

            local v11 = 0.85 / math.max(1, #candidate.affixes)

            for i = 0, #candidate.affixes - 1 do
                task.wait(v11)
                v4(i + 1)
                playClonedSound("CrateTapSound", {
                    volume = 0.74,
                    playbackSpeed = i * 0.12 + 1.04
                })
            end

            wake2("flourish")
            v6:tween(1, {
                time = 0.45,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad
            })
            playClonedSound(if v7 then "JackpotLandingImpact" else "LandingImpact", {
                playbackSpeed = v7 and 0.94 or 1,
                volume = v7 and 0.9 or 0.7
            })
            v8 = true
        end)

        return function() -- line: 66
            -- upvalues: v8 (ref), v9 (copy)
            if not v8 then
                task.cancel(v9)
            end
        end
    end, {
        candidate.affixes,
        candidate.rolledAt,
        v6,
        v7
    })

    local v13 = wake ~= "wake"
    local v14 = if wake == "wake" then "WAKING CHARM CORE..."
        elseif wake == "core" then "TRAINING CORE LOCKED"
        elseif wake == "affixes" then "LOCKING REAL ATTRIBUTES..."
        elseif v7 then "EXCEPTIONAL CONSTELLATION!"
        else ("%* COMPLETE"):format((getTierFlourishName(tier.tierId)))
    local v15 = react.createElement(TierFlourish, {
        isMajor = v7,
        progress = v5,
        tierId = tier.tierId,
        visible = wake == "flourish"
    })
    local v16 = react.createElement(default2, {
        shadowYScale = 0.045,
        color = v2,
        overrideProps = {
            TextScaled = true,
            ZIndex = 18,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.31, 0.565),
            Size = UDim2.fromScale(0.38, 0.045)
        },
        text = v14
    })
    local v17 = react.createElement("uilistlayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.004, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    if v13 then
        local trainingPower = candidate.trainingPower
        local v18 = if activeCore == nil then activeCore else activeCore.trainingPower
        local t2 = {
            direction = getRevealDirection(trainingPower, v18),
            icon = "⚔",
            key = "training-core",
            label = "Training Power",
            layoutOrder = 0,
            value = ("+%*"):format((pct(candidate.trainingPower))),
            text = ("TRAINING POWER  +%*  •  CORE"):format((pct(candidate.trainingPower)))
        }

        v13 = react.createElement(RevealLine, t2)
    end

    local affixes = candidate.affixes
    local v19 = table.create(#affixes)

    local function v20(p2, p3) -- line: 117
        -- upvalues: activeCore (copy), v3 (copy), react (copy), RevealLine (ref), getRevealDirection (ref), pct (ref), getAttributeIcon (ref), getAttributeName (ref)
        if not (p3 < v3) then
            return nil
        end

        local value = p2.value
        local v21 = activeCore

        if activeCore ~= nil then
            v21 = nil

            for v22, v23 in activeCore.affixes do
                local _ = v22 - 1

                if v23.attributeId == p2.attributeId == true then
                    v21 = v23
                    break
                end

                v21 = nil
            end

            if v21 ~= nil then
                v21 = v21.value
            end
        end

        local t3 = {
            direction = getRevealDirection(value, v21),
            icon = getAttributeIcon(p2.attributeId),
            key = ("%*-%*"):format(p2.attributeId, p3),
            label = getAttributeName(p2.attributeId),
            layoutOrder = p3 + 1,
            quality = p2.quality,
            value = ("+%*"):format((pct(p2.value))),
            text = ("%*  +%*  •  %*"):format(getAttributeName(p2.attributeId), pct(p2.value), (string.upper(p2.quality)))
        }

        return (react.createElement(RevealLine, t3))
    end

    for v24, v25 in affixes do
        v19[v24] = v20(v25, v24 - 1, affixes)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v15, v16, react.createElement(default, {
        cornerRadius = 0.045,
        isStudded = false,
        strokeThickness = 0.012,
        transparency = 0.18,
        zIndex = 16,
        backgroundColor = Color3.fromRGB(8, 13, 26),
        position = UDim2.fromScale(0.31, 0.62),
        size = UDim2.fromScale(0.38, 0.265),
        strokeColor = Color3.fromRGB(82, 91, 113)
    }, v17, v13, v19), canSkip and react.createElement(default3, {
        isStudded = true,
        label = "SKIP",
        zIndex = 20,
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 132, 191)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 69, 126))
        }),
        frameSize = UDim2.fromScale(0.18, 0.065),
        onClick = onSkip,
        position = UDim2.fromScale(0.5, 0.935)
    }))
end

local getRevealLineStyle

function RevealLine(p4) -- line: 184
    -- upvalues: react (copy), v2 (copy), getRevealLineStyle (ref)
    local direction, icon, label, layoutOrder = p4.direction, p4.icon, p4.label, p4.layoutOrder
    local quality, value = p4.quality, p4.value
    local v26 = getRevealLineStyle(quality)
    local v27 = if direction == "up" then Color3.fromRGB(82, 230, 111) elseif direction == "down" then Color3.fromRGB(255, 91, 72) else Color3.fromRGB(177, 185, 204)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 17,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(0.94, 0.18)
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 18,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.02, 0.08),
        Size = UDim2.fromScale(0.1, 0.78),
        Text = icon,
        TextColor3 = v26.text
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 18,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.14, 0.08),
        Size = UDim2.fromScale(0.2, 0.78),
        Text = value,
        TextColor3 = v2,
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 18,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.35, 0.08),
        Size = UDim2.fromScale(0.47, 0.78),
        Text = label,
        TextColor3 = Color3.fromRGB(232, 235, 244),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 18,
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.86, 0.03),
        Size = UDim2.fromScale(0.1, 0.86),
        Text = if direction == "up" then "▲" elseif direction == "down" then "▼" else "—",
        TextColor3 = v27
    }), react.createElement("frame", {
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        ZIndex = 17,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(72, 81, 101),
        Position = UDim2.fromScale(0.02, 1),
        Size = UDim2.fromScale(0.94, 0.018)
    }))
end

local getTierFlourishColor

function TierFlourish(p5) -- line: 247
    -- upvalues: react (copy), v2 (copy), getTierFlourishColor (ref)
    local isMajor, progress, tierId = p5.isMajor, p5.progress, p5.tierId

    if not p5.visible then
        return nil
    end

    local v31 = if isMajor then 1.25 else 1
    local v32 = getTierFlourishColor(tierId)
    local v33 = progress:map(function(p6) -- line: 257
        return (math.clamp(p6 * 1.15, 0.08, 1))
    end)
    local v35 = react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 8,
        BackgroundColor3 = v32,
        BackgroundTransparency = v33,
        Size = UDim2.fromScale(1, 1)
    })
    local v36 = tierId == 1

    if v36 then
        local t6 = {
            0, 1, 2, 3, 4, 5
        }

        v36 = table.create(#t6)

        local function v37(p7) -- line: 272
            -- upvalues: progress (copy), react (copy), v2 (copy)
            return react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 8,
                BackgroundColor3 = Color3.fromRGB(123, 226, 255),
                BackgroundTransparency = progress:map(function(p8) -- line: 275
                    return 0.12 + p8 * 0.78
                end),
                Position = progress:map(function(p9) -- line: 279
                    -- upvalues: p7 (copy)
                    return UDim2.fromScale(0.15 + p7 * 0.14, 0.76 - p9 * (0.42 + p7 * 0.025))
                end),
                Size = UDim2.fromScale(0.035 + p7 % 3 * 0.012, 0.06 + p7 % 2 * 0.025),
                key = ("bubble-%*"):format(p7)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.5, 0)
            }), react.createElement("uistroke", {
                Thickness = 0.08,
                Transparency = 0.2,
                Color = v2
            }))
        end

        for v38, v39 in t6 do
            v36[v38] = v37(v39, v38 - 1, t6)
        end
    end

    local v40 = tierId == 2

    if v40 then
        local t8 = {
            0, 1, 2
        }

        v40 = table.create(#t8)

        local function v41(p10) -- line: 304
            -- upvalues: progress (copy), v31 (copy), react (copy), v2 (copy)
            return react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = if p10 == 1 then v2 else Color3.fromRGB(114, 226, 255),
                BackgroundTransparency = progress:map(function(p11) -- line: 308
                    return 0.12 + p11 * 0.76
                end),
                Position = UDim2.fromScale(0.5, 0.5),
                Rotation = progress:map(function(p12) -- line: 313
                    -- upvalues: p10 (copy)
                    return 45 + p10 * 60 + p12 * 70
                end),
                Size = progress:map(function(p13) -- line: 316
                    -- upvalues: p10 (copy), v31 (copy)
                    return UDim2.fromScale(0.025 + p13 * (v31 * 0.68), 0.42 - p10 * 0.08)
                end),
                key = ("refraction-%*"):format(p10)
            })
        end

        for v42, v43 in t8 do
            v40[v42] = v41(v43, v42 - 1, t8)
        end
    end

    local v44 = tierId == 3

    if v44 then
        local t10 = {
            0, 1, 2, 3, 4, 5, 6, 7
        }

        v44 = table.create(#t10)

        local function v45(p14) -- line: 334
            -- upvalues: progress (copy), v32 (copy), v31 (copy), react (copy), v2 (copy)
            local v46 = p14 / 8 * 3.141592653589793 * 2

            return react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = if p14 % 2 == 0 then v32 else v2,
                BackgroundTransparency = progress:map(function(p15) -- line: 339
                    return 0.08 + p15 * 0.72
                end),
                Position = progress:map(function(p16) -- line: 343
                    -- upvalues: v46 (copy), v31 (copy)
                    local v47 = v46 + p16 * 3.141592653589793 * 0.8
                    local v48 = p16 * 0.38 * v31

                    return UDim2.fromScale(0.5 + math.cos(v47) * v48, 0.5 + math.sin(v47) * v48)
                end),
                Rotation = progress:map(function(p17) -- line: 348
                    -- upvalues: v46 (copy)
                    return math.deg(v46) + p17 * 160
                end),
                Size = UDim2.fromScale(0.025, 0.12),
                key = ("shard-%*"):format(p14)
            })
        end

        for v49, v50 in t10 do
            v44[v49] = v45(v50, v49 - 1, t10)
        end
    end

    local v51 = tierId == 4

    if v51 then
        local t12 = {
            0, 1, 2
        }

        v51 = table.create(#t12)

        local function v52(p18) -- line: 367
            -- upvalues: progress (copy), v32 (copy), v31 (copy), react (copy), v2 (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = progress:map(function(p19) -- line: 372
                    -- upvalues: p18 (copy), v31 (copy)
                    local v53 = 0.12 + p19 * (0.7 + p18 * 0.16) * v31

                    return UDim2.fromScale(v53, v53 * 1.6)
                end),
                key = ("halo-%*"):format(p18)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.5, 0)
            }), react.createElement("uistroke", {
                Color = if p18 == 1 then v2 else v32,
                Thickness = 0.055 - p18 * 0.01,
                Transparency = progress:map(function(p20) -- line: 383
                    return 0.05 + p20 * 0.82
                end)
            }))
        end

        for v55, v56 in t12 do
            v51[v55] = v52(v56, v55 - 1, t12)
        end
    end

    local createElement = react.createElement
    local t15 = {
        BackgroundTransparency = 1,
        ZIndex = 8,
        Size = UDim2.fromScale(1, 1)
    }

    if tierId ~= 5 then
        local v57 = false

        return createElement("frame", t15, v35, v36, v40, v44, v51, v57)
    end

    return createElement("frame", t15, v35, v36, v40, v44, v51, (react.createElement(react.Fragment, nil, react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(8, 4, 17),
        BackgroundTransparency = progress:map(function(p21) -- line: 401
            return (math.clamp(p21 * 0.8, 0, 0.8))
        end),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = progress:map(function(p22) -- line: 406
            -- upvalues: v31 (copy)
            local v59 = 0.18 + p22 * 0.32 * v31

            return UDim2.fromScale(v59, v59 * 1.75)
        end)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.1,
        Color = Color3.fromRGB(255, 91, 86),
        Transparency = progress:map(function(p23) -- line: 416
            return p23 * 0.72
        end)
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = v2,
        BackgroundTransparency = progress:map(function(p24) -- line: 422
            return (math.clamp(p24 * 1.4, 0, 1))
        end),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, v31 * 0.045)
    }))))
end

function getRevealLineStyle(p25) -- line: 431
    if p25 == "standard" then
        return {
            background = Color3.fromRGB(63, 74, 101),
            stroke = Color3.fromRGB(146, 163, 197),
            text = Color3.fromRGB(242, 245, 255)
        }
    end

    if p25 == "good" then
        return {
            background = Color3.fromRGB(44, 140, 81),
            stroke = Color3.fromRGB(144, 239, 171),
            text = Color3.fromRGB(239, 255, 243)
        }
    end

    if p25 == "great" then
        return {
            background = Color3.fromRGB(112, 61, 188),
            stroke = Color3.fromRGB(213, 166, 255),
            text = Color3.fromRGB(250, 241, 255)
        }
    end

    if p25 == "perfect" then
        return {
            background = Color3.fromRGB(202, 142, 29),
            stroke = Color3.fromRGB(255, 234, 133),
            text = Color3.fromRGB(255, 253, 224)
        }
    end

    return {
        background = Color3.fromRGB(42, 122, 190),
        stroke = Color3.fromRGB(166, 230, 255),
        text = Color3.fromRGB(232, 250, 255)
    }
end

function getTierFlourishColor(p26) -- line: 466
    if p26 == 1 then
        return Color3.fromRGB(109, 225, 255)
    end

    if p26 == 2 then
        return Color3.fromRGB(123, 232, 255)
    end

    if p26 == 3 then
        return Color3.fromRGB(190, 103, 255)
    end

    if p26 == 4 then
        return Color3.fromRGB(255, 214, 83)
    end

    return Color3.fromRGB(255, 79, 114)
end

function getTierFlourishName(p27) -- line: 481
    if p27 == 1 then
        return "BUBBLE ASCENT"
    end

    if p27 == 2 then
        return "CRYSTAL REFRACTION"
    end

    if p27 == 3 then
        return "SHARD ORBIT"
    end

    if p27 == 4 then
        return "HALO PULSE"
    end

    return "ECLIPSE SNAP"
end

function getRevealDirection(p28, p29) -- line: 496
    if p29 == nil or p29 < p28 then
        return "up"
    end

    if p28 < p29 then
        return "down"
    end

    return "same"
end

function getAttributeIcon(p30) -- line: 505
    if p30 == "mutationLuck" then
        return "♣"
    end

    if p30 == "aquariumIncome" then
        return "●"
    end

    if p30 == "shopDiscount" then
        return "%"
    end

    if p30 == "bonusLuck" then
        return "★"
    end

    if p30 == "weatherMutationLuck" then
        return "☁"
    end

    if p30 == "championMutationChance" then
        return "◆"
    end

    if p30 == "baitHopDistance" then
        return "↗"
    end

    if p30 == "bossFishDamage" then
        return "◎"
    end

    return "◉"
end

function getAttributeName(p31) -- line: 532
    -- upvalues: charmAttributeConfigs (copy)
    local v63

    for v64, v65 in charmAttributeConfigs do
        local _ = v64 - 1

        if v65.id == p31 == true then
            v63 = v65
            break
        end

        v63 = nil
    end

    if v63 ~= nil then
        v63 = v63.displayName
    end

    if v63 == nil then
        v63 = p31
    end

    return v63
end

function pct(p32) -- line: 555
    return (`{ math.round(p32 * 1000) / 10 }%`)
end

return {
    default = CharmRevealPanel
}
