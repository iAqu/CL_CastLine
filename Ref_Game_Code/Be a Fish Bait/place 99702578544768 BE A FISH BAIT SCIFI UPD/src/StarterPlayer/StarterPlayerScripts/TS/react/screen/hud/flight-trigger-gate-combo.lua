-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local flightTriggerGateComboAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-combo-atom").flightTriggerGateComboAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local flightGateFXConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-combo-utils")
local getFlightGateComboTier, sampleFlightGateGradient = v1.getFlightGateComboTier, v1.sampleFlightGateGradient

local function buildComboShineGradient(p1) -- line: 23
    -- upvalues: sampleFlightGateGradient (copy)
    local v2 = sampleFlightGateGradient(p1, 0.5)
    local v3 = v2:Lerp(Color3.new(1, 1, 1), 0.82)

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v2),
        ColorSequenceKeypoint.new(0.42, v2),
        ColorSequenceKeypoint.new(0.5, v3),
        ColorSequenceKeypoint.new(0.58, v2),
        ColorSequenceKeypoint.new(1, v2)
    })
end

return {
    default = function() -- FlightTriggerGateCombo | line: 29
        -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), useMotion (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), default (copy), flightGateFXConfig (copy), getFlightGateComboTier (copy), buildComboShineGradient (copy)
        local v4, v5 = useState(flightTriggerGateComboAtom())
        local v6, v7 = useState(hookFlightSteeringActiveAtom())
        local v8, v9 = useMotion(1)
        local v10, v11 = useMotion(1)
        local v12, v13 = useMotion(-1)
        local v14 = v12:map(function(p2) -- line: 35
            return Vector2.new(p2, 0)
        end)
        local comboTextVFX = flightGateFXConfig.comboTextVFX

        useEffect(function() -- line: 39
            -- upvalues: v5 (copy), v7 (copy), subscribe (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy)
            local v15 = subscribe(flightTriggerGateComboAtom, v5)
            local v16 = subscribe(hookFlightSteeringActiveAtom, v7)

            return function() -- line: 42
                -- upvalues: v15 (copy), v16 (copy)
                v15()
                v16()
            end
        end, {})
        useEffect(function() -- line: 47
            -- upvalues: v4 (copy), v6 (copy), v13 (copy), comboTextVFX (copy)
            if not v6 or v4 <= 0 then
                v13:immediate(-1)

                return nil
            end

            v13:linear(1, {
                speed = comboTextVFX.shine.speed
            })

            local v17 = v13:onComplete(function() -- line: 58
                -- upvalues: v13 (copy), comboTextVFX (copy)
                v13:immediate(-1)
                v13:linear(1, {
                    speed = comboTextVFX.shine.speed
                })
            end)

            return function() -- line: 62
                -- upvalues: v17 (copy)
                return v17()
            end
        end, {
            v4,
            v6,
            comboTextVFX.shine.speed,
            v13
        })
        useEffect(function() -- line: 66
            -- upvalues: v4 (copy), v6 (copy), v9 (copy), comboTextVFX (copy)
            local impact, punch, v18

            if v6 and not (v4 <= 0) then
                impact = comboTextVFX.impact
                punch = impact.punch

                local v19 = impact.comboMultiplier.maxCombo - impact.comboMultiplier.startCombo

                v18 = if v19 > 0 then math.clamp((v4 - impact.comboMultiplier.startCombo) / v19, 0, 1) else 1

                local v21 = 1 + v18 * (impact.comboMultiplier.maxMultiplier - 1)
                local v22 = 1 - (1 - punch.undershootScale) * v21
                local v23 = 1 + (punch.overshootScale - 1) * v21
                local totalDurationSeconds = impact.totalDurationSeconds
                local v24 = totalDurationSeconds * punch.startFraction
                local v25 = totalDurationSeconds * (punch.endFraction - punch.startFraction)
                local v26 = v25 * punch.undershootFraction
                local v27 = v25 * punch.overshootFraction
                local v28 = v25 * punch.settleFraction
                local t1 = {}

                table.insert(t1, (task.delay(v24, function() -- line: 85
                    -- upvalues: v22 (copy), v23 (copy), v26 (copy), v27 (copy), v28 (copy), t1 (copy), v9 (copy)
                    v9:tween(v22, {
                        time = v26,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.In
                    })
                    table.insert(t1, (task.delay(v26, function() -- line: 91
                        -- upvalues: v23 (copy), v27 (copy), v9 (copy)
                        v9:tween(v23, {
                            time = v27,
                            style = Enum.EasingStyle.Linear
                        })
                    end)))
                    table.insert(t1, (task.delay(v26 + v27, function() -- line: 98
                        -- upvalues: v28 (copy), v9 (copy)
                        v9:tween(1, {
                            time = v28,
                            style = Enum.EasingStyle.Quad,
                            direction = Enum.EasingDirection.Out
                        })
                    end)))
                end)))

                local v32 = task.delay(totalDurationSeconds, function() -- line: 108
                    -- upvalues: v9 (copy)
                    return v9:set(1)
                end)

                return function() -- line: 111
                    -- upvalues: t1 (copy), v32 (copy)
                    local function v33(p3) -- line: 113
                        return task.cancel(p3)
                    end

                    for v34, v35 in t1 do
                        local _ = v34 - 1

                        task.cancel(v35)
                    end

                    task.cancel(v32)
                end
            end

            v9:set(1)

            return nil
        end, { v4, comboTextVFX, v6, v9 })
        useEffect(function() -- line: 123
            -- upvalues: v4 (copy), v6 (copy), v11 (copy), comboTextVFX (copy)
            if not v6 or v4 <= 0 then
                v11:set(1)

                return nil
            end

            local pulse = comboTextVFX.pulse
            local v37 = math.max(pulse.maxCombo - 1, 1)
            local v39 = math.clamp((v4 - 1) / v37, 0, 1)
            local v41 = math.max(pulse.baseIntervalSeconds - v39 * (pulse.baseIntervalSeconds - pulse.minIntervalSeconds), pulse.intervalSecondsCap) / 2
            local t2 = {}
            local v42

            v42 = function(p4) -- line: 138
                -- upvalues: v42 (ref), pulse (copy), v41 (copy), t2 (copy), v11 (copy)
                v11:tween(if p4 then pulse.peakScale else 1, {
                    time = v41,
                    style = Enum.EasingStyle.Sine
                })
                table.insert(t2, (task.delay(v41, function() -- line: 143
                    -- upvalues: p4 (copy), v42 (ref)
                    return v42(not p4)
                end)))
            end

            v42(true)

            return function() -- line: 149
                -- upvalues: t2 (copy), v11 (copy)
                local function v45(p5) -- line: 151
                    return task.cancel(p5)
                end

                for v46, v47 in t2 do
                    local _ = v46 - 1

                    task.cancel(v47)
                end

                v11:set(1)
            end
        end, { v4, comboTextVFX, v6, v11 })

        local v48

        if not v6 or v4 <= 0 then
            return nil
        else
            local v50 = getFlightGateComboTier(v4)

            v48 = if v50 == 1 then comboTextVFX.gradient else flightGateFXConfig.combo.ringGradients[("tier%*"):format(v50)]
        end

        local v51 = buildComboShineGradient(v48)
        local v55 = math.min(math.pow(1 + comboTextVFX.sizeGrowthPerCombo, v4 - 1), comboTextVFX.sizeGrowthScaleCap)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 40,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5 + comboTextVFX.offsetFromCenter.X, 0.5 + comboTextVFX.offsetFromCenter.Y),
            Size = v8:map(function(p6) -- line: 175
                -- upvalues: comboTextVFX (copy), v55 (copy)
                local v56 = comboTextVFX.sizeMultiplier * v55 * p6

                return UDim2.fromScale(0.2 * v56, 0.09 * v56)
            end)
        }, react.createElement(default, {
            gradientRotation = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v51,
            gradientOffset = v14,
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = Enum.Font.GothamBlack,
                Size = v10:map(function(p7) -- line: 187
                    return UDim2.fromScale(p7, p7)
                end),
                TextYAlignment = Enum.TextYAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.075,
                Color = comboTextVFX.strokeColor
            },
            text = ("COMBO x%*"):format(v4)
        }))
    end
}
