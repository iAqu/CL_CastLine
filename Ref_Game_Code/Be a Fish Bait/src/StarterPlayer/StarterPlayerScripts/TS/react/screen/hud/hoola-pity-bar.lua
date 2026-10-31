-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local flightTriggerGateComboAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-combo-atom").flightTriggerGateComboAtom
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-score-atoms")
local flightTriggerGatePityBaselineReadyAtom, flightTriggerGatePityImpactVersionAtom, flightTriggerGatePityResetVersionAtom, flightTriggerGatePityScoreAtom = v1.flightTriggerGatePityBaselineReadyAtom, v1.flightTriggerGatePityImpactVersionAtom, v1.flightTriggerGatePityResetVersionAtom, v1.flightTriggerGatePityScoreAtom
local flightTriggerGatePityThresholdAtom, flightTriggerGatePityTierAtom, flightTriggerGateSurfScoreAtom = v1.flightTriggerGatePityThresholdAtom, v1.flightTriggerGatePityTierAtom, v1.flightTriggerGateSurfScoreAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useLoopingGradientRotation = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "use-exclusive-gradient-rotation").useLoopingGradientRotation
local useLoopMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-loop-motion").useLoopMotion
local flightGateFXConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig
local hoolaMutationDisplayNames = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").hoolaMutationDisplayNames
local hoolaSystemConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hoola-system-config").hoolaSystemConfig
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-combo-utils")
local getFlightGateComboTier, sampleFlightGateGradient = v2.getFlightGateComboTier, v2.sampleFlightGateGradient
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerFishingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors").selectPlayerFishingState
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v3 = tostring(Players.LocalPlayer.UserId)
local v4 = Color3.fromRGB(0, 0, 0)

local function brighten(p1, p2) -- line: 40
    return Color3.new(math.min(p1.R * (1 + p2), 1), math.min(p1.G * (1 + p2), 1), (math.min(p1.B * (1 + p2), 1)))
end

local v10 = Color3.fromRGB(255, 255, 255)
local _ = {
    hoola1 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 157, 35)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 225)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 226, 64)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 157, 35))
    }),
    hoola2 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 157, 35)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 244, 130)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(225, 250, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(105, 255, 230)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(133, 227, 255))
    }),
    hoola3 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
        ColorSequenceKeypoint.new(0.22, Color3.fromRGB(255, 250, 190)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 245)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(115, 255, 232)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 179, 222))
    })
}

local function HoolaPityBarDisplay(p3) -- line: 65
    -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useMotion (copy), RunService (copy), default (copy), default2 (copy), useLoopingGradientRotation (copy), useLoopMotion (copy), flightGateFXConfig (copy), hoolaMutationDisplayNames (copy), hoolaSystemConfig (copy), getFlightGateComboTier (copy), sampleFlightGateGradient (copy), images (copy), v4 (copy), v10 (copy)
    local combo, impactVersion, initialProgress, progress = p3.combo, p3.impactVersion, p3.initialProgress, p3.progress
    local resetVersion, pityTier = p3.resetVersion, p3.pityTier
    local barVFX = flightGateFXConfig.barVFX
    local strokeFlash = barVFX.strokeFlash
    local v11 = useLoopingGradientRotation(pityTier == "hoola3")
    local v12 = useLoopingGradientRotation(true)
    local v13, v14 = useMotion(initialProgress)
    local v15, v16 = useMotion(initialProgress)
    local v17, v18 = useMotion(1)
    local v19, v20 = useBinding(0)
    local _, v21 = useMotion(0)
    local v23 = useLoopMotion({
        min = 0,
        max = 1,
        motionType = "linear",
        linearOptions = {
            speed = 1 / (1 / flightGateFXConfig.comboTextVFX.shine.speed)
        }
    })[1]
    local v24 = useRef(combo)
    local v25 = useRef(0)
    local v26 = useRef(impactVersion)
    local v27 = useRef(resetVersion)

    v24.current = combo

    local v28 = ("tier%*"):format((getFlightGateComboTier(combo)))
    local v29 = if combo <= 0 then v4 else sampleFlightGateGradient(flightGateFXConfig.combo.ringGradients[v28], 0.5)
    local brightenFactor = strokeFlash.brightenFactor
    local v35 = Color3.new(math.min(v29.R * (1 + brightenFactor), 1), math.min(v29.G * (1 + brightenFactor), 1), (math.min(v29.B * (1 + brightenFactor), 1)))
    local v36 = v23:map(function(p4) -- line: 105
        -- upvalues: v29 (copy), v35 (copy)
        return v29:Lerp(v35, p4)
    end)

    useEffect(function() -- line: 108
        -- upvalues: v21 (copy)
        local t1 = {}
        local v37

        v37 = function(p5) -- line: 112
            -- upvalues: v37 (ref), t1 (copy), v21 (copy)
            v21:tween(p5 and 5 or -5, {
                time = 0.3,
                style = Enum.EasingStyle.Sine
            })
            table.insert(t1, (task.delay(0.3, function() -- line: 117
                -- upvalues: p5 (copy), v37 (ref)
                return v37(not p5)
            end)))
        end

        v37(true)

        return function() -- line: 123
            -- upvalues: t1 (copy), v21 (copy)
            local function v40(p6) -- line: 125
                return task.cancel(p6)
            end

            for v41, v42 in t1 do
                local _ = v41 - 1

                task.cancel(v42)
            end

            v21:immediate(0)
        end
    end, { v21 })
    useEffect(function() -- line: 135
        -- upvalues: impactVersion (copy), progress (copy), resetVersion (copy), barVFX (copy), v14 (copy), v16 (copy), v18 (copy), v20 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), RunService (copy)
        if resetVersion == v27.current then
            if impactVersion == v26.current then
                v14:set(progress)
                v16:set(progress)

                return nil
            end

            v26.current = impactVersion
            v25.current += 1

            local current = v25.current
            local impact = barVFX.impact
            local v43 = impact.comboMultiplier.maxCombo - impact.comboMultiplier.startCombo
            local v46 = 1 + (if v43 > 0 then math.clamp((v24.current - impact.comboMultiplier.startCombo) / v43, 0, 1) else 1) * (impact.comboMultiplier.maxMultiplier - 1)
            local v47 = 1 - (1 - impact.punch.undershootScale) * v46
            local v48 = 1 + (impact.punch.overshootScale - 1) * v46
            local totalDurationSeconds = impact.totalDurationSeconds
            local v49 = totalDurationSeconds * impact.fillLerp.startFraction
            local v50 = totalDurationSeconds * (impact.fillLerp.endFraction - impact.fillLerp.startFraction)
            local v51 = totalDurationSeconds * impact.punch.startFraction
            local v52 = totalDurationSeconds * (impact.punch.endFraction - impact.punch.startFraction)
            local v53 = v52 * impact.punch.undershootFraction
            local v54 = v52 * impact.punch.overshootFraction
            local v55 = v52 * impact.punch.settleFraction
            local t2 = {}

            v16:set(progress)
            table.insert(t2, (task.delay(v49, function() -- line: 170
                -- upvalues: current (copy), v50 (copy), progress (copy), v14 (copy), v25 (copy)
                if current ~= v25.current then
                    return nil
                end

                v14:tween(progress, {
                    time = v50,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
            end)))
            table.insert(t2, (task.delay(v51, function() -- line: 181
                -- upvalues: current (copy), v47 (copy), v48 (copy), v53 (copy), v54 (copy), v55 (copy), t2 (copy), v18 (copy), v25 (copy)
                if current ~= v25.current then
                    return nil
                end

                v18:tween(v47, {
                    time = v53,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.In
                })
                table.insert(t2, (task.delay(v53, function() -- line: 190
                    -- upvalues: current (copy), v48 (copy), v54 (copy), v18 (copy), v25 (copy)
                    if current ~= v25.current then
                        return nil
                    end

                    v18:tween(v48, {
                        time = v54,
                        style = Enum.EasingStyle.Linear
                    })
                end)))
                table.insert(t2, (task.delay(v53 + v54, function() -- line: 200
                    -- upvalues: current (copy), v55 (copy), v18 (copy), v25 (copy)
                    if current ~= v25.current then
                        return nil
                    end

                    v18:tween(1, {
                        time = v55,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                end)))
            end)))

            local v60 = totalDurationSeconds * impact.tremble.startFraction
            local v61 = totalDurationSeconds * (impact.tremble.endFraction - impact.tremble.startFraction)
            local elapsed = os.clock()
            local connection = RunService.Heartbeat:Connect(function() -- line: 216
                -- upvalues: current (copy), impact (copy), v46 (copy), v60 (copy), v61 (copy), elapsed (copy), v20 (copy), v25 (copy)
                if current ~= v25.current then
                    return nil
                end

                local v62 = os.clock() - elapsed

                if v62 < v60 or v60 + v61 <= v62 then
                    v20(0)

                    return nil
                end

                local v63 = v62 - v60
                local v65 = math.max(0, 1 - v63 / v61)

                v20(math.sin(v63 * impact.tremble.frequency) * v65 * impact.tremble.rotationAmplitudeDegrees * v46)
            end)
            local v68 = task.delay(v60 + v61, function() -- line: 230
                -- upvalues: current (copy), connection (copy), v20 (copy), v25 (copy)
                if current == v25.current then
                    v20(0)
                end

                connection:Disconnect()
            end)

            return function() -- line: 236
                -- upvalues: t2 (copy), connection (copy), v68 (copy)
                local function v69(p7) -- line: 238
                    return task.cancel(p7)
                end

                for v70, v71 in t2 do
                    local _ = v70 - 1

                    task.cancel(v71)
                end

                task.cancel(v68)
                connection:Disconnect()
            end
        end

        v25.current += 1
        v27.current = resetVersion
        v26.current = impactVersion
        v14:set(progress)
        v16:set(progress)
        v18:set(1)
        v20(0)

        return nil
    end, { barVFX, v16, impactVersion, progress, v14, v18, resetVersion, v20 })

    return react.createElement(react.Fragment, nil, react.createElement(default2, {
        text = "Pass through hoops to fill the bar!",
        anchorPoint = Vector2.new(0.5, 0),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 36,
            Size = UDim2.fromScale(0.35, 0.04),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        position = UDim2.fromScale(barVFX.instructionPosition.X, barVFX.instructionPosition.Y),
        strokeProps = {
            Thickness = 0.06,
            Color = Color3.fromRGB(45, 20, 0)
        }
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 35,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5 + barVFX.offsetFromCenter.X, 0.5 + barVFX.offsetFromCenter.Y),
        Rotation = v19,
        Size = v17:map(function(p8) -- line: 269
            -- upvalues: barVFX (copy)
            return UDim2.fromScale(barVFX.length / 0.55 * p8, barVFX.width / 0.5 * p8)
        end)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.1, 0.4),
        Size = UDim2.fromScale(0.55, 0.5)
    }, react.createElement(default, {
        isStudded = true,
        isStuddedTransparency = 0.8,
        textureTransparency = 0,
        tileSize = 90,
        transparency = 0,
        zIndex = 1,
        backgroundColor = barVFX.trackColor,
        cornerRadius = barVFX.cornerRadius,
        size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = v15:map(function(p9) -- line: 297
            return UDim2.fromScale(p9, 1)
        end)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(barVFX.cornerRadius, 0)
    }), react.createElement("uigradient", {
        Rotation = 0,
        Color = hoolaSystemConfig.displayGradients[pityTier]
    })), react.createElement(default, {
        clipsDescendants = true,
        gradientRotation = 0,
        isStudded = true,
        isStuddedTransparency = 0.8,
        textureTransparency = 0,
        tileSize = 90,
        transparency = 0.2,
        zIndex = 3,
        backgroundColor = hoolaSystemConfig.displayGradients[pityTier],
        cornerRadius = barVFX.cornerRadius,
        size = v13:map(function(p10) -- line: 313
            return UDim2.fromScale(p10, 1)
        end)
    }), react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            Size = UDim2.fromScale(0.7, 0.7)
        },
        position = UDim2.fromScale(0.5, 0.5),
        strokeProps = {
            Thickness = 0.06,
            Color = Color3.fromRGB(45, 20, 0)
        },
        text = ("%*%%"):format((math.floor(progress * 100 + 0.5)))
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 6,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(barVFX.cornerRadius, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.075,
        Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = v36,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }))))), react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(barVFX.mutationLabelPosition.X, barVFX.mutationLabelPosition.Y),
        Size = UDim2.fromScale(0.168, 0.42)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.29),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.38,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.shineBackground,
        ImageColor3 = v10,
        Position = UDim2.fromScale(0.5, 0.7),
        Rotation = v12,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(3.5, 3.5)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = hoolaSystemConfig.displayGradients[pityTier],
        gradientRotation = v11,
        overrideProps = {
            TextScaled = true,
            ZIndex = 3,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.06,
            Color = Color3.fromRGB(45, 20, 0)
        },
        text = hoolaMutationDisplayNames[pityTier]
    })), react.createElement(default2, {
        text = "mutation",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 3,
            Position = UDim2.fromScale(0.5, 1.1),
            Size = UDim2.fromScale(1, 0.5),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.06,
            Color = Color3.fromRGB(45, 20, 0)
        }
    }))))
end

return {
    default = function() -- HoolaPityBar | line: 404
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityImpactVersionAtom (copy), flightTriggerGatePityResetVersionAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGatePityTierAtom (copy), flightTriggerGateSurfScoreAtom (copy), useRootSelectorCreator (copy), selectPlayerFishingState (copy), v3 (copy), HoolaPityBarDisplay (copy)
        local v76 = useRootSelectorCreator(selectPlayerFishingState, v3)
        local v77, v78 = useState(hookFlightSteeringActiveAtom())
        local v79, v80 = useState(flightTriggerGatePityBaselineReadyAtom())
        local v81, v82 = useState(flightTriggerGatePityScoreAtom())
        local v83, v84 = useState(flightTriggerGateSurfScoreAtom())
        local v85, v86 = useState(flightTriggerGatePityThresholdAtom())
        local v87, v88 = useState(flightTriggerGatePityTierAtom())
        local v89, v90 = useState(flightTriggerGateComboAtom())
        local v91, v92 = useState(flightTriggerGatePityImpactVersionAtom())
        local v93, v94 = useState(flightTriggerGatePityResetVersionAtom())

        useEffect(function() -- line: 415
            -- upvalues: v78 (copy), v80 (copy), v82 (copy), v84 (copy), v86 (copy), v88 (copy), v90 (copy), v92 (copy), v94 (copy), subscribe (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityImpactVersionAtom (copy), flightTriggerGatePityResetVersionAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGatePityTierAtom (copy), flightTriggerGateSurfScoreAtom (copy)
            local t10 = {
                subscribe(hookFlightSteeringActiveAtom, v78),
                subscribe(flightTriggerGatePityBaselineReadyAtom, v80),
                subscribe(flightTriggerGatePityScoreAtom, v82),
                subscribe(flightTriggerGateSurfScoreAtom, v84),
                subscribe(flightTriggerGatePityThresholdAtom, v86),
                subscribe(flightTriggerGatePityTierAtom, v88),
                subscribe(flightTriggerGateComboAtom, v90),
                subscribe(flightTriggerGatePityImpactVersionAtom, v92),
                subscribe(flightTriggerGatePityResetVersionAtom, v94)
            }

            return function() -- line: 417
                -- upvalues: t10 (copy)
                local function v95(p11) -- line: 419
                    return p11()
                end

                for v96, v97 in t10 do
                    local _ = v96 - 1

                    v97()
                end

                return nil
            end
        end, {})

        local v98 = not v77

        if not v98 then
            local castParams

            if v76 ~= nil then
                castParams = v76.castParams

                if castParams ~= nil then
                    castParams = castParams.flightTriggerGateEligible
                end
            else
                castParams = v76
            end

            v98 = not castParams or not v79 or v85 <= 0
        end

        if v98 then
            return nil
        end

        local v100 = math.clamp((v81 + v83) / v85, 0, 1)

        return react.createElement(HoolaPityBarDisplay, {
            combo = v89,
            impactVersion = v91,
            initialProgress = v100,
            pityTier = v87,
            progress = v100,
            resetVersion = v93
        })
    end
}
