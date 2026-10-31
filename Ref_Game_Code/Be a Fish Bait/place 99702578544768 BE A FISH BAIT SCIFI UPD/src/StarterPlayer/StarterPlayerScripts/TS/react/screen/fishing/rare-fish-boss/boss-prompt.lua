-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local events = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "network").events
local default = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "circular-progress").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local useQteConsoleKey = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-qte-console-key").useQteConsoleKey
local v1 = Color3.fromRGB(124, 128, 134)
local v2 = Color3.fromRGB(170, 176, 184)
local v3 = Color3.fromRGB(35, 230, 95)
local v4 = Color3.fromRGB(0, 90, 42)
local v5 = Color3.fromRGB(255, 190, 35)
local v6 = Color3.fromRGB(255, 245, 115)
local v7 = Color3.fromRGB(0, 0, 0)
local v8 = Color3.fromRGB(0, 0, 0)
local t1 = {
    {
        phase = 0,
        radius = 0.58,
        size = 0.16,
        color = Color3.fromRGB(255, 235, 95)
    },
    {
        phase = 0.23,
        radius = 0.72,
        size = 0.11,
        color = Color3.fromRGB(95, 255, 180)
    },
    {
        phase = 0.48,
        radius = 0.62,
        size = 0.13,
        color = Color3.fromRGB(105, 190, 255)
    },
    {
        phase = 0.71,
        radius = 0.78,
        size = 0.1,
        color = Color3.fromRGB(255, 120, 220)
    }
}

local function PromptVerbHint(p1) -- line: 42
    -- upvalues: react (copy)
    local offset = p1.offset

    if offset == nil then
        offset = 14
    end

    local size, verb = p1.size, p1.verb
    local v10 = math.max(1.5, size * 0.025)

    return react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 1),
        Font = Enum.Font.GothamBlack,
        Position = UDim2.new(0.5, 0, 0.5, -(size * 0.5 + offset)),
        Size = UDim2.fromOffset(size * 1.1, size * 0.28),
        Text = verb,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uistroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = v10
    }))
end

local function PromptCircleGradient(p2) -- line: 65
    -- upvalues: react (copy)
    local transparency = p2.transparency

    if transparency == nil then
        transparency = 0
    end

    local zIndex = p2.zIndex

    return react.createElement("frame", {
        Active = false,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = transparency,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        ZIndex = zIndex
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.5, 0)
    }), react.createElement("uigradient", {
        Rotation = 135,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(208, 214, 222)),
            ColorSequenceKeypoint.new(0.42, Color3.fromRGB(142, 148, 158)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 76, 84))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(0.48, 0.28),
            NumberSequenceKeypoint.new(1, 0.02)
        })
    }))
end

local function toBinding(p3) -- line: 89
    -- upvalues: react (copy)
    if typeof(p3) == "table" and p3.map ~= nil then
        return p3
    end

    return (react.createBinding(p3))
end

return {
    BossTapPrompt = function(p4) -- BossTapPrompt | line: 107
        -- upvalues: react (copy), useEffect (copy), events (copy), default (copy), default2 (copy), useIsUsingGamepad (copy), useQteConsoleKey (copy), v7 (copy), v8 (copy), PromptVerbHint (copy), PromptCircleGradient (copy)
        useEffect(function() -- line: 108
            -- upvalues: events (copy)
            events.analyticsRareSkillCheckButtonShown:fire()
        end, {})

        local v11 = useQteConsoleKey(p4.onActivated)
        local v12 = useIsUsingGamepad()
        local v13 = p4.size * 2.3
        local v14 = p4.variant == "multiTap"
        local v17 = p4.innerBorderWidth + math.max(if v14 then 5 else 2, p4.size * (if v14 then 0.07 else 0.035))
        local v18 = p4.timerProgress ~= nil
        local v21 = p4.size + math.max(if v14 then 54 else 42, p4.size * 0.34)
        local timerProgress = p4.timerProgress

        if timerProgress == nil then
            timerProgress = 100
        end

        if typeof(timerProgress) ~= "table" or timerProgress.map == nil then
            timerProgress = react.createBinding(timerProgress)
        end

        local v22 = timerProgress:map(function(p5) -- line: 122
            return (math.clamp(p5, 0, 100))
        end)
        local v23 = v22:map(function(p6) -- line: 125
            -- upvalues: v14 (copy)
            if v14 then
                if p6 <= 20 then
                    return (Color3.fromRGB(255, 55, 55))
                end

                if p6 <= 50 then
                    return (Color3.fromRGB(255, 220, 45))
                end

                return (Color3.fromRGB(145, 60, 230))
            end

            if p6 <= 20 then
                return (Color3.fromRGB(255, 70, 70))
            end

            if p6 <= 50 then
                return (Color3.fromRGB(255, 205, 70))
            end

            return (Color3.fromRGB(120, 50, 200))
        end)
        local v24 = if v14 then Color3.fromRGB(240, 255, 235) else p4.innerFillColor
        local v25 = if v14 then 0.04 else 0
        local v26 = if v14 then 0.32 else 0
        local v27 = if v14 then 28 else 14

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 12,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = p4.position,
            Size = UDim2.fromOffset(v13, v13)
        }, if v18 then react.createElement(react.Fragment, nil, react.createElement(default, {
            direction = "Left",
            missingPartType = "TransAndColor",
            starterPoint = "Up",
            transOfPercentPart = 0,
            zIndex = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            colorOfMissingPart = Color3.fromRGB(0, 0, 0),
            colorOfPercentPart = v23,
            position = UDim2.fromScale(0.5, 0.5),
            progress = v22,
            size = UDim2.fromOffset(v21, v21),
            transOfMissingPart = v14 and 0.36 or 0.62
        }), v14 and react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 9,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(v21, v21)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Transparency = 0.02,
            Color = Color3.fromRGB(25, 0, 55),
            Thickness = math.max(3, p4.size * 0.05)
        }))) else react.createElement(react.Fragment, nil, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p4.ringSize
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = v8,
            Thickness = p4.approachRingWidth + 2
        })), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p4.ringSize
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = p4.approachRingColor,
            Thickness = p4.approachRingWidth
        }))), react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = p4.glowColor,
            BackgroundTransparency = if v14 then 0.58 else p4.glowTransparency,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p4.size + (v14 and 34 or 18), p4.size + (v14 and 34 or 18))
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v24,
            BackgroundTransparency = v25,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p4.size, p4.size)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Transparency = 0.06,
            Color = v7,
            Thickness = v17
        }), react.createElement(PromptCircleGradient, {
            zIndex = 3,
            transparency = v26
        }), p4.label ~= nil and react.createElement("textlabel", {
            Active = false,
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.64, 0.64),
            Text = p4.label,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Transparency = 0.02,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = math.max(2, p4.size * 0.045)
        }))), react.createElement(PromptVerbHint, {
            verb = "TAP",
            offset = v27,
            size = p4.size
        }), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = p4.onActivated
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p4.hitboxSize, p4.hitboxSize)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), v12 and react.createElement(default2, {
            keyCode = v11,
            radius = p4.size / 2,
            size = p4.size * 0.4
        }))
    end,
    BossSlidePrompt = function(p7) -- BossSlidePrompt | line: 265
        -- upvalues: react (copy), useEffect (copy), events (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), t1 (copy), PromptVerbHint (copy), PromptCircleGradient (copy)
        useEffect(function() -- line: 266
            -- upvalues: events (copy)
            events.analyticsHoldAndDragShown:fire()
        end, {})

        local v40 = math.max(2.5, p7.startSize * 0.04)
        local v42 = math.max(2, p7.pathWidth * 0.08)
        local v44 = math.max(28, p7.pathWidth * 0.58)
        local v45 = react.joinBindings({
            ["end"] = p7.endPosition,
            start = p7.startPosition
        }):map(function(p8) -- line: 277
            -- upvalues: p7 (copy)
            local Offset = p8.start.X.Offset
            local Offset2 = p8.start.Y.Offset
            local Offset3 = p8["end"].X.Offset
            local Offset4 = p8["end"].Y.Offset
            local v46 = Offset3 - Offset
            local v47 = Offset4 - Offset2
            local v49 = math.sqrt(v46 * v46 + v47 * v47)
            local v51 = math.deg((math.atan2(v47, v46)))

            return {
                position = UDim2.fromOffset((Offset + Offset3) / 2, (Offset2 + Offset4) / 2),
                rotation = v51,
                size = UDim2.fromOffset(v49, p7.pathWidth)
            }
        end)
        local v52 = react.joinBindings({
            ["end"] = p7.endPosition,
            progress = p7.dragProgress,
            start = p7.startPosition
        }):map(function(p9) -- line: 297
            local Offset = p9.start.X.Offset
            local Offset2 = p9.start.Y.Offset
            local Offset3 = p9["end"].X.Offset
            local Offset4 = p9["end"].Y.Offset

            return UDim2.fromOffset(Offset + (Offset3 - Offset) * p9.progress, Offset2 + (Offset4 - Offset2) * p9.progress)
        end)
        local v53 = p7.dragProgress:map(function(p10) -- line: 305
            if p10 >= 0.92 then
                return 0.22
            end

            return 0.68
        end)
        local v54 = p7.grabbed:map(function(p11) -- line: 308
            if p11 then
                return 0.55
            end

            return 1
        end)
        local v55 = p7.startApproach:map(function(p12) -- line: 311
            -- upvalues: p7 (copy)
            local v57 = math.sin(p12 * 3.141592653589793 * 8) * 0.06 + 1.1

            return UDim2.fromOffset(p7.startSize * v57, p7.startSize * v57)
        end)
        local v58 = react.joinBindings({
            grabbed = p7.grabbed,
            phase = p7.arrowPhase
        }):map(function(p13) -- line: 318
            -- upvalues: p7 (copy)
            local v59 = if p13.grabbed then math.sin(p13.phase * 3.141592653589793 * 2) * 0.1 + 1.05 else 0.75
            local v61 = p7.endSize * 0.92 * v59

            return UDim2.fromOffset(v61, v61)
        end)
        local v62 = p7.grabbed:map(function(p14) -- line: 323
            if p14 then
                return 0.16
            end

            return 1
        end)
        local v63 = p7.dragProgress:map(function(p15) -- line: 326
            -- upvalues: p7 (copy)
            local v65 = math.sin(p15 * 3.141592653589793 * 6) * 0.08 + 1
            local v66 = p7.endSize * 1.1 * v65

            return UDim2.fromOffset(v66, v66)
        end)
        local v67 = p7.grabbed:map(function(p16) -- line: 331
            if p16 then
                return 0.62
            end

            return 1
        end)
        local v68 = react.joinBindings({
            grabbed = p7.grabbed,
            phase = p7.arrowPhase
        }):map(function(p17) -- line: 337
            if p17.grabbed then
                return math.sin(p17.phase * 3.141592653589793 * 2) * 0.08 + 0.08
            end

            return 1
        end)
        local v70 = p7.startApproach:map(function(p18) -- line: 343
            -- upvalues: p7 (copy)
            local v72 = math.max(2.3 - math.clamp(p18, 0, 1) * 1.3, 1)

            return UDim2.fromOffset(p7.startSize * v72, p7.startSize * v72)
        end)
        local v73 = p7.grabbed:map(function(p19) -- line: 347
            if p19 then
                return 1
            end

            return 0
        end)
        local v74 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })
        local v76 = react.createElement("uistroke", {
            Transparency = 0.04,
            Color = v4,
            Thickness = v42 + math.max(4, p7.pathWidth * 0.08)
        })
        local v78 = react.createElement("uistroke", {
            Transparency = 0,
            Color = Color3.fromRGB(240, 255, 245),
            Thickness = math.max(2, v42 * 0.55)
        })
        local t12 = {
            0, 1, 2
        }
        local v79 = table.create(#t12)

        local function v80(p20) -- line: 366
            -- upvalues: p7 (copy), v44 (copy), v45 (copy), react (copy), v4 (copy)
            local v81 = react.joinBindings({
                bar = v45,
                phase = p7.arrowPhase
            }):map(function(p21) -- line: 370
                -- upvalues: p20 (copy), p7 (copy)
                local v82 = p7.pathWidth * 0.68
                local v84 = math.max(1, p21.bar.size.X.Offset - v82 * 2)
                local v85 = (p21.phase + p20 / 3) % 1

                return UDim2.fromOffset(v82 + v84 * v85, p7.pathWidth * 0.5)
            end)
            local v86 = p7.arrowPhase:map(function(p22) -- line: 376
                -- upvalues: p20 (copy)
                local v87 = (p22 + p20 / 3) % 1

                return (1 - math.clamp(math.min(v87 / 0.18, (1 - v87) / 0.18, 1), 0, 1)) * 0.38 + 0.02
            end)

            return react.createElement("textlabel", {
                BackgroundTransparency = 1,
                Rotation = 0,
                Text = "▶",
                TextScaled = true,
                ZIndex = 2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = v81,
                Size = UDim2.fromOffset(v44, v44),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextTransparency = v86,
                key = ("lane-arrow-%*"):format(p20)
            }, react.createElement("uistroke", {
                Color = v4,
                Thickness = math.max(1.5, v44 * 0.08),
                Transparency = v86
            }))
        end

        for v92, v93 in t12 do
            v79[v92] = v80(v93, v92 - 1, t12)
        end

        local v94 = react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v3,
            Position = v45:map(function(p23) -- line: 410
                return p23.position
            end),
            Rotation = v45:map(function(p24) -- line: 413
                return p24.rotation
            end),
            Size = v45:map(function(p25) -- line: 416
                return p25.size
            end)
        }, v74, v76, v78, v79)
        local v99 = react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v1,
            BackgroundTransparency = v53,
            Position = p7.endPosition,
            Size = UDim2.fromOffset(p7.endSize, p7.endSize)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Transparency = 0.08,
            Color = v7,
            Thickness = v40 + math.max(2, p7.endSize * 0.035)
        }), react.createElement(PromptCircleGradient, {
            zIndex = 3,
            transparency = v53:map(function(p26) -- line: 437
                return (math.min(0.82, p26 + 0.04))
            end)
        }))
        local v100 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })
        local v103 = react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v63
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = v3,
            Thickness = math.max(2, v42 * 0.75),
            Transparency = v67
        }))
        local v104 = react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v5,
            BackgroundTransparency = v62,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v58
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }))
        local v105 = table.create(#t1)

        local function v106(p27, p28) -- line: 475
            -- upvalues: p7 (copy), v42 (copy), v68 (copy), react (copy)
            local v107 = p7.arrowPhase:map(function(p29) -- line: 476
                -- upvalues: p27 (copy), p7 (copy)
                local v108 = (p29 + p27.phase) * 3.141592653589793 * 2
                local v109 = p7.endSize * p27.radius

                return UDim2.fromOffset(p7.endSize * 0.275 + math.cos(v108) * v109, p7.endSize * 0.275 + math.sin(v108) * v109)
            end)
            local v110 = p7.arrowPhase:map(function(p30) -- line: 481
                -- upvalues: p27 (copy), p7 (copy)
                local v112 = math.sin((p30 + p27.phase) * 3.141592653589793 * 4) * 0.18 + 0.82
                local v113 = p7.endSize * p27.size * v112

                return UDim2.fromOffset(v113, v113)
            end)

            return react.createElement("frame", {
                Active = false,
                BorderSizePixel = 0,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = p27.color,
                BackgroundTransparency = v68,
                Position = v107,
                Rotation = p7.arrowPhase:map(function(p31) -- line: 493
                    -- upvalues: p27 (copy)
                    return (p31 + p27.phase) * 180
                end),
                Size = v110,
                key = ("held-sparkle-%*"):format(p28)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 2)
            }), react.createElement("uistroke", {
                Color = p27.color:Lerp(Color3.fromRGB(255, 255, 255), 0.35),
                Thickness = math.max(1, v42 * 0.25),
                Transparency = v68
            }))
        end

        for v116, v117 in t1 do
            v105[v116] = v106(v117, v116 - 1, t1)
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 12,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v94, v99, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v5,
            Position = v52,
            Size = UDim2.fromOffset(p7.endSize * 0.5, p7.endSize * 0.5)
        }, v100, v103, v104, v105, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v6,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.44, 0.44)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("uistroke", {
            Transparency = 0,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = v42 + math.max(3, p7.pathWidth * 0.06)
        }), react.createElement("uistroke", {
            Transparency = 0,
            Color = Color3.fromRGB(255, 255, 210),
            Thickness = math.max(2, v42 * 0.45)
        })), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v1,
            Position = p7.startPosition,
            Size = UDim2.fromOffset(p7.startSize, p7.startSize)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Transparency = 0.05,
            Color = v7,
            Thickness = v40 + math.max(2, p7.startSize * 0.035)
        }), react.createElement(PromptCircleGradient, {
            zIndex = 6
        }), react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v2,
            BackgroundTransparency = v54,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v55
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v70
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = v8,
            Thickness = v40 + 2,
            Transparency = v73
        })), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 8,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v70
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = v40,
            Transparency = v73
        })), react.createElement(PromptVerbHint, {
            verb = "DRAG",
            size = p7.startSize
        }), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 11,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = p7.onGrab
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.6, 1.6)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }))))
    end
}
