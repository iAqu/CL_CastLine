-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent, "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent, "timeskip-reward").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "screen", "fishing", "fish-roll-item").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rarityColorGradients = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColorGradients
local t1 = {
    {
        delay = 0,
        endX = 0.26,
        endY = 0.2,
        size = 16,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.02,
        endX = 0.18,
        endY = 0.31,
        size = 10,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.04,
        endX = 0.36,
        endY = 0.34,
        size = 12,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.06,
        endX = 0.46,
        endY = 0.23,
        size = 9,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.08,
        endX = 0.31,
        endY = 0.55,
        size = 18,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.1,
        endX = 0.22,
        endY = 0.66,
        size = 13,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.12,
        endX = 0.42,
        endY = 0.68,
        size = 14,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.14,
        endX = 0.52,
        endY = 0.48,
        size = 11,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.16,
        endX = 0.2,
        endY = 0.45,
        size = 11,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.18,
        endX = 0.34,
        endY = 0.78,
        size = 15,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.2,
        endX = 0.38,
        endY = 0.16,
        size = 15,
        color = Color3.fromRGB(255, 120, 40)
    },
    {
        delay = 0.22,
        endX = 0.48,
        endY = 0.6,
        size = 8,
        color = Color3.fromRGB(255, 255, 255)
    },
    {
        delay = 0.24,
        endX = 0.14,
        endY = 0.18,
        size = 12,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.26,
        endX = 0.28,
        endY = 0.82,
        size = 9,
        color = Color3.fromRGB(120, 230, 255)
    },
    {
        delay = 0.28,
        endX = 0.55,
        endY = 0.32,
        size = 13,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.3,
        endX = 0.44,
        endY = 0.84,
        size = 10,
        color = Color3.fromRGB(255, 225, 80)
    },
    {
        delay = 0.03,
        endX = 0.4,
        endY = 0.5,
        size = 15,
        color = Color3.fromRGB(255, 70, 110)
    },
    {
        delay = 0.07,
        endX = 0.16,
        endY = 0.4,
        size = 11,
        color = Color3.fromRGB(90, 255, 135)
    },
    {
        delay = 0.11,
        endX = 0.5,
        endY = 0.74,
        size = 13,
        color = Color3.fromRGB(80, 205, 255)
    },
    {
        delay = 0.15,
        endX = 0.24,
        endY = 0.28,
        size = 12,
        color = Color3.fromRGB(255, 220, 65)
    },
    {
        delay = 0.19,
        endX = 0.46,
        endY = 0.42,
        size = 14,
        color = Color3.fromRGB(220, 110, 255)
    },
    {
        delay = 0.23,
        endX = 0.3,
        endY = 0.66,
        size = 10,
        color = Color3.fromRGB(255, 105, 220)
    },
    {
        delay = 0.27,
        endX = 0.52,
        endY = 0.22,
        size = 12,
        color = Color3.fromRGB(165, 255, 85)
    },
    {
        delay = 0.31,
        endX = 0.2,
        endY = 0.6,
        size = 11,
        color = Color3.fromRGB(255, 165, 55)
    },
    {
        delay = 0.05,
        endX = 0.42,
        endY = 0.26,
        size = 13,
        color = Color3.fromRGB(120, 255, 225)
    },
    {
        delay = 0.09,
        endX = 0.34,
        endY = 0.88,
        size = 12,
        color = Color3.fromRGB(85, 135, 255)
    },
    {
        delay = 0.13,
        endX = 0.12,
        endY = 0.52,
        size = 9,
        color = Color3.fromRGB(255, 250, 135)
    },
    {
        delay = 0.17,
        endX = 0.48,
        endY = 0.36,
        size = 15,
        color = Color3.fromRGB(245, 100, 145)
    }
}
local t2 = {
    {
        color = Color3.fromRGB(255, 72, 96),
        delay = 0,
        ["end"] = Vector2.new(0.18, 0.18),
        size = 0.13
    },
    {
        color = Color3.fromRGB(255, 151, 48),
        delay = 0.02,
        ["end"] = Vector2.new(0.38, 0.08),
        size = 0.1
    },
    {
        color = Color3.fromRGB(255, 236, 72),
        delay = 0.04,
        ["end"] = Vector2.new(0.62, 0.1),
        size = 0.14
    },
    {
        color = Color3.fromRGB(110, 255, 104),
        delay = 0.06,
        ["end"] = Vector2.new(0.82, 0.2),
        size = 0.11
    },
    {
        color = Color3.fromRGB(64, 242, 218),
        delay = 0.08,
        ["end"] = Vector2.new(0.9, 0.4),
        size = 0.15
    },
    {
        color = Color3.fromRGB(65, 176, 255),
        delay = 0.1,
        ["end"] = Vector2.new(0.84, 0.62),
        size = 0.1
    },
    {
        color = Color3.fromRGB(112, 104, 255),
        delay = 0.12,
        ["end"] = Vector2.new(0.68, 0.76),
        size = 0.13
    },
    {
        color = Color3.fromRGB(212, 91, 255),
        delay = 0.14,
        ["end"] = Vector2.new(0.46, 0.8),
        size = 0.11
    },
    {
        color = Color3.fromRGB(255, 86, 205),
        delay = 0.16,
        ["end"] = Vector2.new(0.24, 0.7),
        size = 0.15
    },
    {
        color = Color3.fromRGB(255, 117, 143),
        delay = 0.18,
        ["end"] = Vector2.new(0.1, 0.52),
        size = 0.09
    },
    {
        color = Color3.fromRGB(255, 221, 72),
        delay = 0.05,
        ["end"] = Vector2.new(0.08, 0.31),
        size = 0.12
    },
    {
        color = Color3.fromRGB(77, 255, 164),
        delay = 0.09,
        ["end"] = Vector2.new(0.31, 0.29),
        size = 0.08
    },
    {
        color = Color3.fromRGB(74, 209, 255),
        delay = 0.13,
        ["end"] = Vector2.new(0.69, 0.32),
        size = 0.09
    },
    {
        color = Color3.fromRGB(255, 105, 232),
        delay = 0.17,
        ["end"] = Vector2.new(0.55, 0.61),
        size = 0.1
    }
}

return {
    default = function(p1) -- RewardScreen | line: 257
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), abbreviate (copy), images (copy), rarityColorGradients (copy), t1 (copy), t2 (copy)
        local v1 = useRef(false)
        local v2 = useRef(false)
        local v3 = useRef(p1.onFinished)

        v3.current = p1.onFinished

        local v4, v5 = useState(false)
        local v6, v7 = useState(false)
        local v8, v9 = useState(false)
        local v10, v11 = useMotion(0)
        local v12, v13 = useMotion(0)
        local v14, v15 = useMotion(0)
        local v16, v17 = useMotion(0)
        local v18, v19 = useMotion(0)
        local v20, v21 = useMotion(0)
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 50
        end

        local revealDelaySec = p1.revealDelaySec

        if revealDelaySec == nil then
            revealDelaySec = 0
        end

        local showIcon = p1.showIcon

        if showIcon == nil then
            showIcon = true
        end

        local v22 = p1.rewardRayColor or Color3.fromRGB(255, 232, 82)
        local onReveal, secondaryReward, backdropTransparency = p1.onReveal, p1.secondaryReward, p1.backdropTransparency

        if backdropTransparency == nil then
            backdropTransparency = 0.28
        end

        local v23 = if secondaryReward == nil then secondaryReward else secondaryReward.transitionDelaySec

        if v23 == nil then
            v23 = 1.2
        end

        local v24 = if secondaryReward == nil then 2.35 else 3.45
        local iconImage = if not v6 or secondaryReward == nil then p1.iconImage else secondaryReward.iconImage
        local v25 = if not v6 or secondaryReward == nil then p1.rewardText else secondaryReward.rewardText
        local rewardRarity = if not v6 or secondaryReward == nil then p1.rewardRarity else secondaryReward.rewardRarity
        local v26, v27

        if v6 then
            v27 = if secondaryReward ~= nil then secondaryReward.rewardRayColor else secondaryReward
            v26 = v27 ~= nil
        else
            v26 = v6
        end

        v27 = if v26 then secondaryReward.rewardRayColor else v22

        local showWhiteRewardRay = if not v6 or secondaryReward == nil then p1.showWhiteRewardRay else secondaryReward.showWhiteRewardRay

        if showWhiteRewardRay == nil then
            showWhiteRewardRay = false
        end

        if v6 then
            v6 = if secondaryReward ~= nil then secondaryReward.title else secondaryReward
            v6 = v6 ~= nil
        end

        local title = if v6 then secondaryReward.title else p1.title
        local v28 = useCallback(function() -- line: 340
            -- upvalues: v1 (copy), v3 (copy)
            if v1.current then
                return nil
            end

            v1.current = true

            local current = v3.current

            if current ~= nil then
                current()
            end
        end, {})

        useEffect(function() -- line: 350
            -- upvalues: p1 (copy), v2 (copy), v5 (copy), v7 (copy), v9 (copy), v11 (copy), v13 (copy), v15 (copy), v17 (copy), v19 (copy), v21 (copy), revealDelaySec (ref), onReveal (copy), secondaryReward (copy), v23 (ref), v28 (copy), v24 (copy)
            v21:linear(360, {
                speed = 100
            })

            local v29 = v21:onComplete(function() -- line: 357
                -- upvalues: v21 (copy)
                v21:immediate(0)
                v21:linear(360, {
                    speed = 100
                })
            end)

            v17:linear(360, {
                speed = 60
            })

            local v30 = v17:onComplete(function() -- line: 367
                -- upvalues: v17 (copy)
                v17:immediate(0)
                v17:linear(360, {
                    speed = 60
                })
            end)
            local v31 = task.delay(revealDelaySec, function() -- line: 371
                -- upvalues: p1 (copy), v2 (copy), v5 (copy), v11 (copy), v13 (copy), v19 (copy), onReveal (copy), v24 (copy)
                v5(true)

                if not v2.current then
                    v2.current = true

                    if onReveal ~= nil then
                        onReveal()
                    end
                end

                v11:linear(1, {
                    speed = 1 / v24
                })
                v13:spring(1, {
                    damping = 0.45,
                    frequency = 0.55
                })

                if p1.exclusiveRewardEffects == true then
                    v19:immediate(0)
                    v19:linear(1, {
                        speed = 1.1111111111111112
                    })
                end
            end)
            local v32

            if secondaryReward ~= nil then
                local delay = task.delay
                local v33 = v23 - 0.42

                v32 = delay(revealDelaySec + math.max(v33, 0), function() -- line: 394
                    -- upvalues: v9 (copy), v13 (copy), v15 (copy)
                    v9(true)
                    v13:tween(0, {
                        time = 0.42,
                        direction = Enum.EasingDirection.In,
                        style = Enum.EasingStyle.Back
                    })
                    v15:tween(180, {
                        time = 0.42,
                        direction = Enum.EasingDirection.In,
                        style = Enum.EasingStyle.Quad
                    })
                end)
            end

            local v34 = if secondaryReward == nil then nil else task.delay(revealDelaySec + v23, function() -- line: 407
                -- upvalues: v7 (copy), v9 (copy), v13 (copy), v15 (copy)
                v13:immediate(0)
                v15:immediate(-180)
                v7(true)
                v9(false)
                v13:spring(1, {
                    damping = 0.45,
                    frequency = 0.55
                })
                v15:spring(0, {
                    damping = 0.55,
                    frequency = 0.7
                })
            end)
            local v35 = task.delay(revealDelaySec + v24 + 0.1, function() -- line: 421
                -- upvalues: v28 (copy)
                v28()
            end)

            return function() -- line: 424
                -- upvalues: v29 (copy), v30 (copy), v31 (copy), v35 (copy), v34 (copy), v32 (ref)
                v29()
                v30()
                task.cancel(v31)

                if v32 ~= nil then
                    task.cancel(v32)
                end

                if v34 ~= nil then
                    task.cancel(v34)
                end

                task.cancel(v35)
            end
        end, {
            v28,
            v19,
            v13,
            v15,
            onReveal,
            v24,
            v11,
            p1.exclusiveRewardEffects,
            revealDelaySec,
            v17,
            secondaryReward,
            v23,
            v21
        })

        local v36 = v10:map(function(p2) -- line: 437
            -- upvalues: v4 (copy)
            if not v4 then
                return 1
            end

            if p2 < 0.12 then
                return 1 - p2 / 0.12
            end

            if p2 > 0.86 then
                return (p2 - 0.86) / 0.14
            end

            return 0
        end)
        local v37 = v10:map(function(p3) -- line: 449
            if p3 > 0.82 then
                return (p3 - 0.82) / 0.18
            end

            return 0
        end)
        local v38 = v10:map(function(p4) -- line: 452
            if p4 > 0.9 then
                return (p4 - 0.9) / 0.1
            end

            return 0
        end)

        local function v39(p5) -- line: 455
            -- upvalues: v10 (copy), zIndex (ref), react (copy), t1 (copy)
            local v40 = table.create(#t1)

            local function v41(p6, p7) -- line: 458
                -- upvalues: p5 (copy), v10 (copy), zIndex (ref), react (copy)
                local v42 = if p5 == "left" then 1 else -1
                local v43 = if p5 == "left" then -0.08 else 1.08
                local v44 = if p5 == "left" then p6.endX else 1 - p6.endX
                local v45 = v10:map(function(p8) -- line: 462
                    -- upvalues: p6 (copy), v44 (copy), v43 (copy)
                    local v47 = math.clamp((p8 - p6.delay) / 0.58, 0, 1)
                    local v49 = 1 - math.pow(1 - v47, 3)
                    local v51 = math.sin(v47 * 3.141592653589793) * 0.18

                    return UDim2.fromScale(v43 + (v44 - v43) * v49, 0.62 + (p6.endY - 0.62) * v49 - v51)
                end)

                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = p6.color,
                    BackgroundTransparency = v10:map(function(p9) -- line: 471
                        -- upvalues: p6 (copy)
                        if math.clamp((p9 - p6.delay) / 0.58, 0, 1) >= 0.98 then
                            return 1
                        end

                        return 0
                    end),
                    Position = v45,
                    Rotation = v10:map(function(p10) -- line: 477
                        -- upvalues: p7 (copy), v42 (copy)
                        return v42 * (p10 * 720 + p7 * 28)
                    end),
                    Size = UDim2.fromOffset(p6.size, (math.max(6, p6.size * 0.55))),
                    ZIndex = zIndex + 5,
                    key = ("%*-%*"):format(p5, p7)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0, 3)
                }))
            end

            for v54, v55 in t1 do
                v40[v54] = v41(v55, v54 - 1, t1)
            end

            return v40
        end

        local left, v56, v57, v58

        if v4 then
            left = v39("left")

            local right = v39("right")

            v56 = react.createElement(default, {
                anchorPoint = Vector2.new(0.5, 0.5),
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
                    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(255, 230, 70)),
                    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(90, 255, 120)),
                    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(80, 190, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 100, 255))
                }),
                overrideProps = {
                    TextScaled = true,
                    Size = UDim2.fromOffset(720 * p1.uiScale, 110 * p1.uiScale),
                    TextTransparency = v37,
                    ZIndex = zIndex + 10
                },
                position = UDim2.fromScale(0.5, 0.2),
                strokeProps = {
                    Thickness = 0.08
                },
                text = title
            })

            local v59

            if v8 then
                v57 = if secondaryReward ~= nil then secondaryReward.transitionText else secondaryReward

                if v57 ~= nil then
                    local createElement = react.createElement
                    local t4 = {}

                    t4.anchorPoint = Vector2.new(0.5, 0.5)
                    t4.color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 80)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 255, 230))
                    })
                    t4.overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(0.5, 0.08),
                        ZIndex = zIndex + 14
                    }
                    t4.position = UDim2.fromScale(0.5, 0.54)

                    local t5 = {
                        Thickness = 0.08
                    }

                    t5.Color = Color3.fromRGB(20, 12, 35)
                    t4.strokeProps = t5
                    t4.text = secondaryReward.transitionText
                    v59 = createElement(default, t4)
                else
                    v59 = false
                end
            else
                v59 = v8
            end

            local createElement2, v60

            if p1.fish ~= nil then
                createElement2 = react.createElement(react.Fragment, nil, react.createElement(default3, {
                    showRarity = false,
                    anchorPoint = Vector2.new(0.5, 0.5),
                    finalFishData = p1.fish,
                    finalMutations = p1.mutations,
                    position = UDim2.fromScale(0.5, 0.5),
                    size = UDim2.fromScale(0.62, 0.86),
                    transparency = v38,
                    zIndex = zIndex + 8
                }), p1.rewardBadgeText ~= nil and react.createElement(default, {
                    anchorPoint = Vector2.new(0.5, 0.5),
                    color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 120)),
                        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(60, 255, 240)),
                        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 90, 220)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 245, 120))
                    }),
                    overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(1.2, 0.17),
                        TextTransparency = v38,
                        ZIndex = zIndex + 12
                    },
                    position = UDim2.fromScale(0.5, 0.02),
                    strokeProps = {
                        Thickness = 0.08,
                        Color = Color3.fromRGB(0, 0, 0)
                    },
                    text = p1.rewardBadgeText
                }), react.createElement(default, {
                    anchorPoint = Vector2.new(0.5, 0.5),
                    color = rarityColorGradients[p1.fish.rarity].color,
                    overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(1.1, 0.16),
                        TextTransparency = v38,
                        ZIndex = zIndex + 11
                    },
                    position = UDim2.fromScale(0.5, 1.08),
                    strokeProps = {
                        Thickness = 0.08,
                        Color = rarityColorGradients[p1.fish.rarity].borderColor
                    },
                    text = string.upper(p1.fish.rarity)
                }))
            elseif p1.titleReward ~= nil then
                createElement2 = react.createElement

                local Fragment, v78 = react.Fragment, react.createElement

                v78 = v78("imagelabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.shineBackground,
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    ImageTransparency = v38:map(function(p22) -- line: 587
                        return (math.min(0.18 + p22, 1))
                    end),
                    Position = UDim2.fromScale(0.5, 0.6),
                    Rotation = v16,
                    Size = UDim2.fromScale(1.24, 1.72),
                    ZIndex = zIndex + 7
                }, react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1
                }))

                local v80 = not p1.titleRewardTextOnly and react.createElement(react.Fragment, nil, react.createElement(default, {
                    text = "PLAYER TITLE",
                    anchorPoint = Vector2.new(0.5, 0.5),
                    color = Color3.fromRGB(255, 255, 255),
                    overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(1.2, 0.2),
                        TextTransparency = v38,
                        ZIndex = zIndex + 10
                    },
                    position = UDim2.fromScale(0.5, 0.34),
                    strokeProps = {
                        Thickness = 0.08
                    }
                }))
                local v81 = react.createElement(default, {
                    anchorPoint = Vector2.new(0.5, 0.5),
                    color = p1.titleReward.color,
                    gradientRotation = v20,
                    overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(1.15, 0.22),
                        TextTransparency = v38,
                        ZIndex = zIndex + 10
                    },
                    position = UDim2.fromScale(0.5, p1.titleRewardTextOnly and 0.5 or 0.56),
                    strokeProps = {
                        Thickness = 0.08
                    },
                    text = p1.titleReward.displayName
                })
                local v82 = false

                if p1.titleReward.perkDescription ~= nil then
                    local createElement = react.createElement

                    v60 = {
                        anchorPoint = Vector2.new(0.5, 0.5),
                        color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(215, 250, 255)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 230, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 255, 255))
                        }),
                        overrideProps = {
                            TextScaled = true,
                            TextWrapped = true,
                            Size = UDim2.fromScale(1.28, 0.18),
                            TextTransparency = v38,
                            ZIndex = zIndex + 10
                        }
                    }
                    v60.position = UDim2.fromScale(0.5, p1.titleRewardTextOnly and 0.69 or 0.74)
                    v60.strokeProps = {
                        Thickness = 0.065,
                        Color = Color3.fromRGB(0, 36, 54)
                    }
                    v60.text = p1.titleReward.perkDescription
                    v82 = createElement(default, v60)
                end

                createElement2 = createElement2(Fragment, nil, v78, v80, v81, v82)
            elseif p1.timeSkipReward ~= nil then
                local Fragment, Fragment2, createElement = react.createElement, react.Fragment, react.createElement

                v25 = {
                    BackgroundTransparency = 1,
                    Rotation = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.shineBackground,
                    ImageColor3 = v22
                }
                v25.ImageTransparency = v38:map(function(p21) -- line: 650
                    return (math.min(0.18 + p21, 1))
                end)
                v25.Position = UDim2.fromScale(0.5, 0.48)
                v25.Size = UDim2.fromScale(1.34, 1.34)
                v25.ZIndex = zIndex + 7
                createElement2 = Fragment(Fragment2, nil, createElement("imagelabel", v25), react.createElement(default2, {
                    cashText = ("+$%*"):format((abbreviate(p1.timeSkipReward.cashAmount))),
                    minutes = p1.timeSkipReward.minutes,
                    position = UDim2.fromScale(0.5, 0.52),
                    size = UDim2.fromScale(1, 1),
                    transparency = v38,
                    zIndex = zIndex + 9
                }))
            else
                local Fragment = react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.shineBackground,
                    ImageColor3 = if p1.exclusiveRewardEffects == true then Color3.fromRGB(255, 225, 64) else v27,
                    ImageTransparency = v38:map(function(p11) -- line: 671
                        return (math.min(0.18 + p11, 1))
                    end),
                    Position = UDim2.fromScale(0.5, 0.44),
                    Rotation = if p1.exclusiveRewardEffects == true then 0 else v16:map(function(p12) -- line: 675
                        return p12 * 0.35
                    end),
                    Size = if p1.circularRewardRay or p1.exclusiveRewardEffects == true then UDim2.fromScale(1.5, 1.5) else UDim2.fromScale(1.28, 1.28),
                    ZIndex = zIndex + 7
                }, if p1.circularRewardRay or p1.exclusiveRewardEffects == true then react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1,
                    DominantAxis = Enum.DominantAxis.Height
                }) else false)
                local v62 = if showWhiteRewardRay or p1.exclusiveRewardEffects == true then react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.shineBackground,
                    ImageColor3 = if p1.exclusiveRewardEffects == true then Color3.fromRGB(255, 252, 196) else Color3.fromRGB(255, 255, 255),
                    ImageTransparency = v38:map(function(p13) -- line: 689
                        return (math.min(0.58 + p13, 1))
                    end),
                    Position = UDim2.fromScale(0.5, 0.44),
                    Rotation = v16:map(function(p14) -- line: 693
                        -- upvalues: p1 (copy)
                        if p1.exclusiveRewardEffects == true then
                            return p14
                        end

                        return -p14
                    end),
                    Size = if p1.circularRewardRay or p1.exclusiveRewardEffects == true then UDim2.fromScale(1.62, 1.62) else UDim2.fromScale(1.38, 1.38),
                    ZIndex = zIndex + 8
                }, if p1.circularRewardRay or p1.exclusiveRewardEffects == true then react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1,
                    DominantAxis = Enum.DominantAxis.Height
                }) else false) else false
                local v64, v65

                if showIcon then
                    v64 = {
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5)
                    }

                    if iconImage ~= nil then
                        v64.Image = iconImage
                    else
                        v64.Image = images.coinBundle
                    end

                    v64.ImageTransparency = v38
                    v64.Position = UDim2.fromScale(0.5, 0.42)
                    v64.ScaleType = Enum.ScaleType.Fit
                    v64.Size = UDim2.fromScale(0.54, 0.54)
                    v64.ZIndex = zIndex + 9
                    v65 = react.createElement("imagelabel", v64)
                else
                    v65 = showIcon
                end

                v64 = p1.exclusiveRewardEffects == true

                local createElement3

                if v64 then
                    v64 = table.create(#t2)

                    local zIndex2 = zIndex

                    createElement3 = function(p15, p16) -- line: 724
                        -- upvalues: v18 (copy), zIndex2 (copy), react (copy), images (copy)
                        return react.createElement("imagelabel", {
                            BackgroundTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = images.sparkleIcon,
                            ImageColor3 = p15.color,
                            ImageTransparency = v18:map(function(p17) -- line: 730
                                -- upvalues: p15 (copy)
                                local v67 = math.clamp((p17 - p15.delay) / (1 - p15.delay), 0, 1)

                                if v67 < 0.08 then
                                    return 1 - v67 / 0.08
                                end

                                return (math.clamp((v67 - 0.3) / 0.7, 0, 1))
                            end),
                            Position = v18:map(function(p18) -- line: 737
                                -- upvalues: p15 (copy)
                                local v71 = 1 - math.pow(1 - math.clamp((p18 - p15.delay) / (1 - p15.delay), 0, 1), 3)

                                return UDim2.fromScale(0.5 + (p15["end"].X - 0.5) * v71, 0.42 + (p15["end"].Y - 0.42) * v71)
                            end),
                            Rotation = v18:map(function(p19) -- line: 742
                                -- upvalues: p16 (copy)
                                return p19 * 320 * (if p16 % 2 == 0 then 1 else -1)
                            end),
                            Size = v18:map(function(p20) -- line: 745
                                -- upvalues: p15 (copy)
                                local v73 = math.clamp((p20 - p15.delay) / (1 - p15.delay), 0, 1)
                                local v74 = 0.015 + (p15.size - 0.015) * v73

                                return UDim2.fromScale(v74, v74)
                            end),
                            ZIndex = zIndex2 + 10,
                            key = ("exclusive-sparkle-%*"):format(p16)
                        }, react.createElement("uiaspectratioconstraint", {
                            AspectRatio = 1
                        }))
                    end

                    for v75, v76 in t2 do
                        v64[v75] = createElement3(v76, v75 - 1, t2)
                    end
                end

                local t9 = {
                    anchorPoint = Vector2.new(0.5, 0.5),
                    color = Color3.fromRGB(255, 255, 255),
                    overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(1.1, 0.22),
                        TextTransparency = v38,
                        ZIndex = zIndex + 10
                    }
                }

                createElement3 = UDim2.fromScale
                v60 = if not showIcon or rewardRarity == nil then 0.8 else 0.76
                t9.position = createElement3(0.5, v60)
                t9.strokeProps = {
                    Thickness = 0.08
                }

                if v25 == nil then
                    v25 = ""
                end

                t9.text = v25
                createElement2 = react.createElement(react.Fragment, nil, Fragment, v62, v65, v64, react.createElement(default, t9), rewardRarity ~= nil and react.createElement(default, {
                    anchorPoint = Vector2.new(0.5, 0.5),
                    color = rarityColorGradients[rewardRarity].color,
                    overrideProps = {
                        TextScaled = true,
                        Size = UDim2.fromScale(0.9, 0.14),
                        TextTransparency = v38,
                        ZIndex = zIndex + 11
                    },
                    position = UDim2.fromScale(0.5, 0.95),
                    strokeProps = {
                        Thickness = 0.08,
                        Color = rarityColorGradients[rewardRarity].borderColor
                    },
                    text = string.upper(rewardRarity)
                }))
            end

            local createElement = react.createElement
            local Fragment = react.Fragment

            v25 = react.createElement
            v60 = {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.54),
                Rotation = v14
            }
            v60.Size = v12:map(function(p23) -- line: 807
                -- upvalues: p1 (copy)
                return UDim2.fromScale(0.34 * p1.uiScale * p23, 0.46 * p1.uiScale * p23)
            end)
            v60.ZIndex = zIndex + 8
            v58 = createElement(Fragment, nil, left, right, v56, v59, v25("frame", v60, createElement2))
        else
            v58 = v4
        end

        left = react.createElement
        v56 = {
            Active = false,
            BorderSizePixel = 0,
            Rotation = 0,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        }
        v56.BackgroundTransparency = v36:map(function(p24) -- line: 817
            -- upvalues: backdropTransparency (ref)
            return backdropTransparency + p24 * (1 - backdropTransparency)
        end)
        v56.Position = UDim2.fromScale(0, 0)
        v56.Size = UDim2.fromScale(1, 1)
        v56.ZIndex = zIndex
        v57 = p1.allowTapToAdvance == true and v4 and react.createElement("textbutton", {
            Active = true,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Event = {
                Activated = v28
            },
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 100
        })

        return left("frame", v56, v58, v57)
    end
}
