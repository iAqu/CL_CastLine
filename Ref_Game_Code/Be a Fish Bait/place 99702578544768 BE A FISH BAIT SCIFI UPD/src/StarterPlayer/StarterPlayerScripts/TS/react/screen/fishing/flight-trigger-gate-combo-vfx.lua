-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useCamera, useMotion = out.useCamera, out.useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage = services.Players, services.ReplicatedStorage
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local cameraShakeEnabledAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").cameraShakeEnabledAtom
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local flightTriggerGateComboAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-combo-atom").flightTriggerGateComboAtom
local flightTriggerGateStreakFailVersionAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-streak-fail-atom").flightTriggerGateStreakFailVersionAtom
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-score-atoms")
local flightTriggerGatePityBaselineReadyAtom, flightTriggerGatePityScoreAtom, flightTriggerGatePityThresholdAtom, flightTriggerGateSurfScoreAtom = v1.flightTriggerGatePityBaselineReadyAtom, v1.flightTriggerGatePityScoreAtom, v1.flightTriggerGatePityThresholdAtom, v1.flightTriggerGateSurfScoreAtom
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local flightGateFXConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig
local getFlightGateComboTier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-combo-utils").getFlightGateComboTier
local selectPlayerFishingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors").selectPlayerFishingState
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local useLoopingGradientRotation = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "use-exclusive-gradient-rotation").useLoopingGradientRotation
local v2 = tostring(Players.LocalPlayer.UserId)

return {
    default = function() -- FlightTriggerGateComboVFX | line: 32
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useCamera (copy), useMotion (copy), ReplicatedStorage (copy), subscribe (copy), shake (copy), cameraShakeEnabledAtom (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightTriggerGateStreakFailVersionAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGateSurfScoreAtom (copy), playClonedSound (copy), flightGateFXConfig (copy), getFlightGateComboTier (copy), selectPlayerFishingState (copy), useRootSelectorCreator (copy), useLoopingGradientRotation (copy), v2 (copy)
        local v3 = useCamera()
        local v4, v5 = useState(flightTriggerGateComboAtom())
        local v6, v7 = useState(flightTriggerGateStreakFailVersionAtom())
        local v8, v9 = useState(hookFlightSteeringActiveAtom())
        local v10, v11 = useState(flightTriggerGatePityBaselineReadyAtom())
        local v12, v13 = useState(flightTriggerGatePityScoreAtom())
        local v14, v15 = useState(flightTriggerGateSurfScoreAtom())
        local v16, v17 = useState(flightTriggerGatePityThresholdAtom())
        local v18 = useRootSelectorCreator(selectPlayerFishingState, v2)
        local v19, v20 = useState(nil)
        local v21, v22 = useMotion(1)
        local v23, v24 = useMotion(Color3.fromRGB(255, 255, 255))

        if v10 then
            v10 = v16 > 0 and v16 <= v12 + v14
        end

        local v25 = v8 and v10
        local v26 = useLoopingGradientRotation(v25, flightGateFXConfig.vignetteVFX.pityGradientRotationSpeed)
        local v27 = useRef()

        useEffect(function() -- line: 49
            -- upvalues: v20 (copy), ReplicatedStorage (copy), flightGateFXConfig (copy)
            local v28 = ReplicatedStorage:FindFirstChild(flightGateFXConfig.vignetteVFX.assetFolderName)
            local v29 = if v28 == nil then v28 else v28:FindFirstChild(flightGateFXConfig.vignetteVFX.decalName, true)

            if not (if v29 == nil then v29 else v29:IsA("Decal")) then
                if v28 ~= nil then
                    local Descendants = v28:GetDescendants()

                    local function v30(p1) -- line: 68
                        return p1:IsA("Decal")
                    end

                    v29 = nil

                    for v31, v32 in Descendants do
                        local _ = v31 - 1

                        if v32:IsA("Decal") == true then
                            v29 = v32
                            break
                        end

                        v29 = nil
                    end
                else
                    v29 = v28
                end
            end

            if if v29 == nil then v29 else v29:IsA("Decal") then
                v20(v29.Texture)
            else
                warn(("[FlightTriggerGate] %* Decal is missing from "):format(flightGateFXConfig.vignetteVFX.decalName) .. ("ReplicatedStorage.%*"):format(flightGateFXConfig.vignetteVFX.assetFolderName))
            end
        end, {})
        useEffect(function() -- line: 94
            -- upvalues: v5 (copy), v7 (copy), v9 (copy), v11 (copy), v13 (copy), v15 (copy), v17 (copy), subscribe (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightTriggerGateStreakFailVersionAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGateSurfScoreAtom (copy)
            local v33 = subscribe(flightTriggerGateComboAtom, v5)
            local v34 = subscribe(flightTriggerGateStreakFailVersionAtom, v7)
            local v35 = subscribe(hookFlightSteeringActiveAtom, v9)
            local v36 = subscribe(flightTriggerGatePityBaselineReadyAtom, v11)
            local v37 = subscribe(flightTriggerGatePityScoreAtom, v13)
            local v38 = subscribe(flightTriggerGateSurfScoreAtom, v15)
            local v39 = subscribe(flightTriggerGatePityThresholdAtom, v17)

            return function() -- line: 102
                -- upvalues: v33 (copy), v34 (copy), v35 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy), flightTriggerGateComboAtom (copy), flightTriggerGateStreakFailVersionAtom (copy)
                v33()
                v34()
                v35()
                v36()
                v37()
                v38()
                v39()
                flightTriggerGateComboAtom(0)
                flightTriggerGateStreakFailVersionAtom(0)
            end
        end, {})
        useEffect(function() -- line: 114
            -- upvalues: v4 (copy), v8 (copy), v10 (ref), v18 (copy), v22 (copy), v24 (copy), flightGateFXConfig (copy), getFlightGateComboTier (copy)
            local v41 = getFlightGateComboTier(v4)
            local vignetteVFX = flightGateFXConfig.vignetteVFX
            local v42 = not v8

            if not v42 then
                local v43 = v18

                if v18 ~= nil then
                    v43 = v18.fishingState
                end

                v42 = v43 == "nibbling"
            end

            if v42 then
                v22:tween(1, {
                    time = vignetteVFX.fadeOutSeconds
                })

                return nil
            end

            if v10 then
                v24:tween(Color3.fromRGB(255, 255, 255), {
                    time = vignetteVFX.colorLerpSeconds
                })
                v22:tween(vignetteVFX.activeTransparency, {
                    time = vignetteVFX.appearSeconds
                })
            elseif v41 == 3 then
                v24:tween(vignetteVFX.tier3Color, {
                    time = vignetteVFX.colorLerpSeconds
                })
                v22:tween(vignetteVFX.activeTransparency, {
                    time = vignetteVFX.appearSeconds
                })
            elseif v41 == 2 then
                v24:tween(vignetteVFX.tier2Color, {
                    time = vignetteVFX.colorLerpSeconds
                })
                v22:tween(vignetteVFX.activeTransparency, {
                    time = vignetteVFX.appearSeconds
                })
            else
                v22:tween(1, {
                    time = vignetteVFX.fadeOutSeconds
                })
            end
        end, {
            v4,
            v8,
            if v18 == nil then v18 else v18.fishingState,
            v10,
            v24,
            v22
        })
        useEffect(function() -- line: 163
            -- upvalues: v3 (copy), v6 (copy), v10 (ref), v22 (copy), v24 (copy), v27 (copy), shake (copy), cameraShakeEnabledAtom (copy), playClonedSound (copy), flightGateFXConfig (copy)
            if v6 == 0 then
                return nil
            end

            local vignetteVFX = flightGateFXConfig.vignetteVFX

            if not v10 then
                v24:immediate(vignetteVFX.comboBreakColor)
                v22:tween(1, {
                    time = vignetteVFX.fadeOutSeconds
                })
            end

            playClonedSound(flightGateFXConfig.combo.streakFailVFX.comboFailSFX)

            if not cameraShakeEnabledAtom() then
                return nil
            end

            local v45 = shake.new()

            v27.current = v45

            local shake2 = flightGateFXConfig.combo.streakFailVFX.shake

            v45.Amplitude = shake2.amplitude
            v45.Frequency = shake2.frequency
            v45.FadeInTime = 0
            v45.SustainTime = 0
            v45.FadeOutTime = shake2.durationSeconds
            v45.PositionInfluence = shake2.positionInfluence
            v45.RotationInfluence = shake2.rotationInfluence
            v45:Start()
            v45:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p2, p3) -- line: 189
                -- upvalues: v3 (copy)
                local _CFrame = v3.CFrame
                local v46 = CFrame.new(p2)
                local v47 = CFrame.Angles(p3.X, p3.Y, p3.Z)

                v3.CFrame = _CFrame * v46 * v47
            end)

            local v48 = task.delay(shake2.durationSeconds, function() -- line: 195
                -- upvalues: v45 (copy), v27 (copy)
                v45:Destroy()
                v27.current = nil
            end)

            return function() -- line: 199
                -- upvalues: v45 (copy), v48 (copy), v27 (copy)
                task.cancel(v48)
                v45:Destroy()
                v27.current = nil
            end
        end, { v6, v3, v8, v10, v24, v22 })

        if v19 == nil then
            return react.createElement(react.Fragment)
        end

        return react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v19,
            ImageColor3 = v23,
            ImageTransparency = v21,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = flightGateFXConfig.vignetteVFX.zIndex
        }, v25 and react.createElement("uigradient", {
            Color = flightGateFXConfig.vignetteVFX.pityGradient,
            Rotation = v26
        }))
    end
}
