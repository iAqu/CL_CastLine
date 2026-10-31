-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local haptics = RuntimeLib.import(script, script.Parent.Parent.Parent, "haptics")
local cameraShakeEnabledAtom, hapticWaterSkip = haptics.cameraShakeEnabledAtom, haptics.hapticWaterSkip
local useCamera = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useCamera
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, RunService, UserInputService = services.CollectionService, services.Players, services.RunService, services.UserInputService
local Workspace = services.Workspace
local events = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").events
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom")
local apexAfterRareFishCutsceneAtom, apexDropAtom, apexSkillCheckAtom, hookCastDistanceAtom = v1.apexAfterRareFishCutsceneAtom, v1.apexDropAtom, v1.apexSkillCheckAtom, v1.hookCastDistanceAtom
local hookLandedPositionAtom, currentFishingZoneAtom, hookHrpAtom = v1.hookLandedPositionAtom, v1.currentFishingZoneAtom, v1.hookHrpAtom
local deluluRiftBaitPauseAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-bait-pause-atom").deluluRiftBaitPauseAtom
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hook-flight-steering-atom")
local hookFlightSteeringActiveAtom, hookFlightSteeringInputAtom = v2.hookFlightSteeringActiveAtom, v2.hookFlightSteeringInputAtom
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local castDistanceFromPower, castDuration, castEndYFromPower, castLaunchSpeedFromPower = v3.castDistanceFromPower, v3.castDuration, v3.castEndYFromPower, v3.castLaunchSpeedFromPower
local bounceCount, bounceInitialDistanceFromSpeed, computeArcOffset, computeBounceDistances = v3.bounceCount, v3.bounceInitialDistanceFromSpeed, v3.computeArcOffset, v3.computeBounceDistances
local defaultBounceDiminishFactor, defaultBounceInitialHeight, defaultBounceGravity, drag = v3.defaultBounceDiminishFactor, v3.defaultBounceInitialHeight, v3.defaultBounceGravity, v3.drag
local effectiveCastDistance, findVisualTWater, miniPlayerRig, perfectCastBounceMultiplier = v3.effectiveCastDistance, v3.findVisualTWater, v3.miniPlayerRig, v3.perfectCastBounceMultiplier
local waterSurfaceY, attachFlyingWaveToHead, attachFlyingVFXToRig = v3.waterSurfaceY, v3.attachFlyingWaveToHead, v3.attachFlyingVFXToRig
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-steering-utils")
local flightLateralOffsetLimit, flightSteeringCameraConfig, getCastRightDirection, maxFlightLateralOffsetFromDistance = v4.flightLateralOffsetLimit, v4.flightSteeringCameraConfig, v4.getCastRightDirection, v4.maxFlightLateralOffsetFromDistance
local flightLateralSpeedFromInput = v4.flightLateralSpeedFromInput
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-boundary-utils")
local clampFishingBoundaryOffset, getFishingBoundaryLimits = v5.clampFishingBoundaryOffset, v5.getFishingBoundaryLimits
local rarityColorGradients = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColorGradients
local getFishingZoneIndex = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils").getFishingZoneIndex
local default = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "prefab").default
local PerfectVFX = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "PerfectVFX")
local Splash = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "Splash")
local ZoneChange = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "ZoneChange")
local playVisulie = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "visulie-utils").playVisulie
local CameraFov = RuntimeLib.import(script, script.Parent, "camera-fov").CameraFov
local CameraSpeedlines = RuntimeLib.import(script, script.Parent, "camera-speedlines").CameraSpeedlines
local useRefState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-ref-state").useRefState
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig
local selectCastCutsceneMiniRigEndCFrame = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "cast-cutscene.selectors").selectCastCutsceneMiniRigEndCFrame
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerBaitAuras, selectPlayerBuffBonuses, selectPlayerStat = selectors.selectPlayerBaitAuras, selectors.selectPlayerBuffBonuses, selectors.selectPlayerStat
local selectHighScoreShown = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectHighScoreShown
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-vfx-utils")
local applyBaitAuraVfx, clearBaitAuraVfx = v6.applyBaitAuraVfx, v6.clearBaitAuraVfx

local function zoneToTrailColor(p1) -- line: 88
    -- upvalues: rarityColorGradients (copy)
    if p1 == nil then
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255))
        })
    end

    local Keypoints = rarityColorGradients[p1].color.Keypoints

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, Keypoints[2].Value),
        ColorSequenceKeypoint.new(1, Keypoints[1].Value)
    })
end

return {
    FishingHookCast = function(p2) -- FishingHookCast | line: 95
        -- upvalues: shake (copy), cameraShakeEnabledAtom (copy), hapticWaterSkip (copy), useCamera (copy), subscribe (copy), react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), createPortal (copy), CollectionService (copy), Players (copy), RunService (copy), UserInputService (copy), Workspace (copy), events (copy), apexAfterRareFishCutsceneAtom (copy), apexDropAtom (copy), apexSkillCheckAtom (copy), hookCastDistanceAtom (copy), hookLandedPositionAtom (copy), currentFishingZoneAtom (copy), hookHrpAtom (copy), deluluRiftBaitPauseAtom (copy), hookFlightSteeringActiveAtom (copy), hookFlightSteeringInputAtom (copy), castDistanceFromPower (copy), castDuration (copy), castEndYFromPower (copy), castLaunchSpeedFromPower (copy), bounceCount (copy), bounceInitialDistanceFromSpeed (copy), computeArcOffset (copy), computeBounceDistances (copy), defaultBounceDiminishFactor (copy), defaultBounceInitialHeight (copy), defaultBounceGravity (copy), drag (copy), effectiveCastDistance (copy), findVisualTWater (copy), miniPlayerRig (copy), perfectCastBounceMultiplier (copy), waterSurfaceY (copy), attachFlyingWaveToHead (copy), attachFlyingVFXToRig (copy), flightLateralOffsetLimit (copy), flightSteeringCameraConfig (copy), getCastRightDirection (copy), maxFlightLateralOffsetFromDistance (copy), flightLateralSpeedFromInput (copy), clampFishingBoundaryOffset (copy), getFishingBoundaryLimits (copy), getFishingZoneIndex (copy), default (copy), PerfectVFX (copy), Splash (copy), ZoneChange (copy), playVisulie (copy), CameraFov (copy), CameraSpeedlines (copy), useRefState (copy), useRootProducer (copy), useRootSelector (copy), useConfig (copy), selectCastCutsceneMiniRigEndCFrame (copy), selectPlayerBaitAuras (copy), selectPlayerBuffBonuses (copy), selectPlayerStat (copy), selectHighScoreShown (copy), animations (copy), applyBaitAuraVfx (copy), clearBaitAuraVfx (copy), zoneToTrailColor (copy)
        local direction, drag2 = p2.direction, p2.drag
        local drag3 = drag2

        if drag2 == nil then
            drag3 = drag
        end

        local power, cameraBackDistance, cameraUpDistance, startPosition = p2.power, p2.cameraBackDistance, p2.cameraUpDistance, p2.startPosition
        local peakBias, peakHeight, showHook, isPerfect = p2.peakBias, p2.peakHeight, p2.showHook, p2.isPerfect
        local v7 = isPerfect

        if isPerfect == nil then
            v7 = false
            isPerfect = false
        end

        local bounceDiminishFactor = p2.bounceDiminishFactor
        local v8 = bounceDiminishFactor

        if bounceDiminishFactor == nil then
            v8 = defaultBounceDiminishFactor
        end

        local bounceInitialHeight = p2.bounceInitialHeight
        local v9 = bounceInitialHeight

        if bounceInitialHeight == nil then
            v9 = defaultBounceInitialHeight
        end

        local bounceInitialDistance, bounceGravity = p2.bounceInitialDistance, p2.bounceGravity
        local v10 = bounceGravity

        if bounceGravity == nil then
            v10 = defaultBounceGravity
        end

        local v11 = useCamera()
        local getSound = useConfig().getSound
        local v12 = useCallback(function(p3) -- line: 129
            -- upvalues: getSound (copy), getFishingZoneIndex (copy)
            local ZoneChange = getSound("ZoneChange")

            ZoneChange.PlaybackSpeed = 1 + (getFishingZoneIndex(p3) - 1) * 0.1
            ZoneChange:Play()
        end, { getSound })
        local v13, v14 = useState(function() -- line: 134
            -- upvalues: apexDropAtom (copy)
            return apexDropAtom() ~= nil
        end)
        local v15, v16 = useState(function() -- line: 137
            -- upvalues: apexSkillCheckAtom (copy)
            return apexSkillCheckAtom() ~= nil
        end)
        local v17, v18 = useState(function() -- line: 140
            -- upvalues: apexAfterRareFishCutsceneAtom (copy)
            return apexAfterRareFishCutsceneAtom()
        end)
        local v19, v20 = useState(false)
        local v21, v22 = useState(function() -- line: 144
            -- upvalues: currentFishingZoneAtom (copy), zoneToTrailColor (copy)
            return zoneToTrailColor(currentFishingZoneAtom())
        end)
        local v23 = useRootSelector(selectPlayerBaitAuras((tostring(Players.LocalPlayer.UserId))))

        if v23 ~= nil then
            v23 = v23.slots[v23.equippedSlotIndex + 1]
        end

        local hopDistance = useRootSelector(selectPlayerBuffBonuses((tostring(Players.LocalPlayer.UserId)))).hopDistance

        useEffect(function() -- line: 154
            -- upvalues: v14 (copy), subscribe (copy), apexDropAtom (copy)
            return subscribe(apexDropAtom, function(p4) -- line: 155
                -- upvalues: v14 (copy)
                return v14(p4 ~= nil)
            end)
        end, {})
        useEffect(function() -- line: 159
            -- upvalues: v16 (copy), subscribe (copy), apexSkillCheckAtom (copy)
            return subscribe(apexSkillCheckAtom, function(p5) -- line: 160
                -- upvalues: v16 (copy)
                return v16(p5 ~= nil)
            end)
        end, {})
        useEffect(function() -- line: 164
            -- upvalues: v18 (copy), subscribe (copy), apexAfterRareFishCutsceneAtom (copy)
            return subscribe(apexAfterRareFishCutsceneAtom, function(p6) -- line: 165
                -- upvalues: v18 (copy)
                return v18(p6)
            end)
        end, {})
        useEffect(function() -- line: 169
            -- upvalues: v22 (copy), subscribe (copy), currentFishingZoneAtom (copy), zoneToTrailColor (copy)
            return subscribe(currentFishingZoneAtom, function(p7) -- line: 170
                -- upvalues: v22 (copy), zoneToTrailColor (copy)
                return v22(zoneToTrailColor(p7))
            end)
        end, {})

        local v24 = useRefState()
        local v25 = v24[1]
        local v26 = v24[2]
        local v27 = useRefState()
        local v28 = v27[1]
        local v29 = v27[2]
        local v30 = useRefState()
        local v31 = v30[1]
        local v32 = v30[2]
        local v33 = useRefState()
        local v34 = v33[1]
        local v35 = v33[2]
        local v36 = useRef()
        local v37 = useRef()
        local v38 = useRef(v11.CFrame)
        local v39 = useRootProducer()
        local v40 = castEndYFromPower(power)
        local v41 = castDistanceFromPower(power)
        local v42 = castDuration(power)
        local v43 = castLaunchSpeedFromPower(power)

        if bounceInitialDistance == nil then
            bounceInitialDistance = bounceInitialDistanceFromSpeed(v43)
        end

        local v45 = bounceInitialDistance * (if isPerfect then perfectCastBounceMultiplier else 1) * (1 + hopDistance)

        print((("[HookCast] isPerfect=%* baseBounceDistValue=%* resolvedBounceDist=%*"):format(isPerfect, bounceInitialDistance, v45)))
        useEffect(function() -- line: 202
            -- upvalues: getSound (copy)
            local WindSFX = getSound("WindSFX")

            WindSFX.Looped = true
            WindSFX:Play()

            return function() -- line: 206
                -- upvalues: WindSFX (copy)
                WindSFX:Stop()
                WindSFX.Looped = false
            end
        end, { getSound })
        useEffect(function() -- line: 211
            -- upvalues: getSound (copy), v19 (copy)
            if not v19 then
                return nil
            end

            local WindSFX = getSound("WindSFX")

            WindSFX:Stop()
            WindSFX.Looped = false
        end, { v19, getSound })
        useEffect(function() -- line: 220
            -- upvalues: v11 (copy), v28 (copy)
            if not v28 then
                return nil
            end

            v11.CameraSubject = v28
        end, { v28, v11 })
        useEffect(function() -- line: 227
            -- upvalues: v28 (copy), hookHrpAtom (copy)
            hookHrpAtom(v28 or nil)

            return function() -- line: 229
                -- upvalues: hookHrpAtom (copy)
                hookHrpAtom(nil)
            end
        end, { v28 })
        useEffect(function() -- line: 234
            -- upvalues: v12 (copy), v25 (copy), subscribe (copy), RunService (copy), Workspace (copy), currentFishingZoneAtom (copy), ZoneChange (copy), playVisulie (copy)
            if not v25 then
                return nil
            end

            local v46 = subscribe(currentFishingZoneAtom, function(p8) -- line: 238
                -- upvalues: v12 (copy), v25 (copy), RunService (copy), Workspace (copy), ZoneChange (copy), playVisulie (copy)
                if p8 == nil or p8 == "common" then
                    return nil
                end

                v12(p8)

                local Model = Instance.new("Model")

                Model.Name = "ZoneChangeVisulie"
                Model.Parent = Workspace
                playVisulie(ZoneChange, v25:GetPivot(), Model)

                local connection

                connection = RunService.RenderStepped:Connect(function() -- line: 248
                    -- upvalues: Model (copy), connection (ref), v25 (copy)
                    if not v25.Parent then
                        connection:Disconnect()
                        Model:Destroy()

                        return nil
                    end

                    Model:PivotTo(v25:GetPivot())
                end)
                task.delay(0.75, function() -- line: 257
                    -- upvalues: Model (copy), connection (ref)
                    connection:Disconnect()
                    Model:Destroy()
                end)
            end)

            return function() -- line: 262
                -- upvalues: v46 (copy)
                return v46()
            end
        end, { v25, v12 })

        local v47

        useEffect(function() -- line: 268
            -- upvalues: direction (copy), drag3 (ref), power (copy), cameraBackDistance (copy), cameraUpDistance (copy), startPosition (copy), peakBias (copy), peakHeight (copy), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (copy), getSound (copy), v20 (copy), hopDistance (copy), v25 (copy), v28 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy), v40 (copy), v41 (copy), v42 (copy), v45 (copy), v47 (ref), shake (copy), cameraShakeEnabledAtom (copy), hapticWaterSkip (copy), subscribe (copy), CollectionService (copy), Players (copy), RunService (copy), UserInputService (copy), Workspace (copy), events (copy), hookCastDistanceAtom (copy), hookLandedPositionAtom (copy), deluluRiftBaitPauseAtom (copy), hookFlightSteeringActiveAtom (copy), hookFlightSteeringInputAtom (copy), bounceCount (copy), computeArcOffset (copy), computeBounceDistances (copy), effectiveCastDistance (copy), findVisualTWater (copy), waterSurfaceY (copy), flightLateralOffsetLimit (copy), flightSteeringCameraConfig (copy), getCastRightDirection (copy), maxFlightLateralOffsetFromDistance (copy), flightLateralSpeedFromInput (copy), clampFishingBoundaryOffset (copy), getFishingBoundaryLimits (copy), PerfectVFX (copy), Splash (copy), ZoneChange (copy), playVisulie (copy), selectCastCutsceneMiniRigEndCFrame (copy), selectPlayerStat (copy), selectHighScoreShown (copy)
            if not v25 then
                return nil
            end

            local v48 = selectCastCutsceneMiniRigEndCFrame(v39:getState())

            if v48 ~= nil then
                v25:PivotTo(v48)
            else
                warn("[src/client/react/fishing/fishing-hook-cast.tsx:289]", "[FishingHookCast] cutscene mini rig end CFrame not set")
            end

            if v48 ~= nil then
                v48 = v48.Position
            end

            if v48 == nil then
                v48 = startPosition
            end

            local Unit = (direction * Vector3.new(1, 0, 1)).Unit
            local v49 = getCastRightDirection(direction)
            local v50 = findVisualTWater(startPosition.Y, v40, waterSurfaceY, drag3, peakHeight, peakBias)
            local v52 = v50 + (1 - v50) / math.max(drag3, 0.001)
            local v53 = v41 / v52
            local v54 = (v40 - startPosition.Y) / v52
            local v56 = maxFlightLateralOffsetFromDistance((effectiveCastDistance(power, startPosition.Y, v7, hopDistance)))
            local t1 = {}

            for _, v57 in CollectionService:GetTagged("FishingBoundary") do
                if v57:IsA("BasePart") then
                    table.insert(t1, v57)
                end
            end

            local v58 = getFishingBoundaryLimits(t1, startPosition, v49)
            local TouchEnabled = UserInputService.TouchEnabled

            if TouchEnabled then
                v11.CameraType = Enum.CameraType.Scriptable

                local Position = v25:GetPivot().Position
                local v59 = Unit * -cameraBackDistance
                local v60 = Vector3.new(0, cameraUpDistance, 0)
                local v61 = Position + v59 + v60

                v11.CFrame = CFrame.lookAt(v61, v61 + Unit) * CFrame.Angles(0, 0, (math.rad(flightSteeringCameraConfig.zAngleDegrees)))
            else
                v11.CameraType = Enum.CameraType.Scriptable
                v11.CFrame = v38.current
            end

            local v63 = tick()
            local v64 = false

            local function v65(p9, p10) -- line: 325
                -- upvalues: v11 (copy)
                local _CFrame = v11.CFrame
                local v66 = CFrame.new(p9)
                local v67 = CFrame.Angles(p10.X, p10.Y, p10.Z)

                v11.CFrame = _CFrame * v66 * v67
            end

            local function v68(p11) -- line: 331
                -- upvalues: v65 (copy), shake (copy), cameraShakeEnabledAtom (copy)
                if not cameraShakeEnabledAtom() then
                    return nil
                end

                p11:Start()
                p11:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p12, p13) -- line: 336
                    -- upvalues: v65 (copy)
                    return v65(p12, p13)
                end)
            end

            local v69 = shake.new()

            v69.Amplitude = 12
            v69.Frequency = 0.1
            v69.FadeInTime = 0
            v69.FadeOutTime = 0.5
            v69.SustainTime = 0.05
            v69.PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
            v69.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
            v68(v69)

            local t2 = {}

            for i = 0, 2 do
                local v70 = shake.new()

                v70.Amplitude = 0.8 ^ i * 0.8
                v70.Frequency = 0.07142857142857142
                v70.FadeInTime = 0
                v70.FadeOutTime = 0.25
                v70.SustainTime = 0
                v70.PositionInfluence = Vector3.new(0.1, 0.1, 0.1)
                v70.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
                table.insert(t2, v70)
            end

            local v71 = shake.new()

            v71.Amplitude = 2
            v71.Frequency = 0.2
            v71.FadeInTime = 0
            v71.FadeOutTime = 0.45
            v71.SustainTime = 0.08
            v71.PositionInfluence = Vector3.new(0.1, 0.1, 0.1)
            v71.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)

            local v72 = startPosition * Vector3.new(1, 0, 1)
            local v73 = tick()
            local v74 = true
            local n1 = 0

            hookFlightSteeringActiveAtom(true)

            local v75 = false
            local n2 = 0
            local v76
            local v77 = subscribe(deluluRiftBaitPauseAtom, function(p14) -- line: 391
                -- upvalues: v68 (copy), v69 (copy), v73 (ref), v75 (ref), n2 (ref), v76 (ref)
                if p14 then
                    v75 = true
                    n2 = tick()
                elseif v75 then
                    v75 = false

                    local v78 = tick() - n2

                    v73 += v78
                    v76 += v78
                    v68(v69)
                end
            end)
            local v79 = selectPlayerStat(tostring(Players.LocalPlayer.UserId), "highScoreDistance")(v39:getState())

            if v79 == nil then
                v79 = 0
            end

            local v80 = false

            local function v81() -- line: 411
                -- upvalues: v79 (ref), v80 (ref), v25 (copy), v39 (copy), Players (copy), RunService (copy), Workspace (copy), ZoneChange (copy), playVisulie (copy), selectHighScoreShown (copy)
                if v80 or v79 <= 0 or selectHighScoreShown((tostring(Players.LocalPlayer.UserId)))(v39:getState()) == false then
                    return nil
                end

                v80 = true

                local Model = Instance.new("Model")

                Model.Name = "ZoneChangeVisulie"
                Model.Parent = Workspace
                playVisulie(ZoneChange, v25:GetPivot(), Model)

                local connection

                connection = RunService.RenderStepped:Connect(function() -- line: 424
                    -- upvalues: Model (copy), connection (ref), v25 (copy)
                    if not v25.Parent then
                        connection:Disconnect()
                        Model:Destroy()

                        return nil
                    end

                    Model:PivotTo(v25:GetPivot())
                end)
                task.delay(0.75, function() -- line: 432
                    -- upvalues: Model (copy), connection (ref)
                    connection:Disconnect()
                    Model:Destroy()
                end)
            end

            local v82 = "flight"
            local v83 = startPosition.Y
            local v84 = Vector3.new(0, 0, 0)
            local n3 = 0

            v76 = 0

            local n4 = 0
            local t3 = {
                0, 0, 0
            }
            local t4 = {
                0, 0, 0
            }
            local v85 = v8
            local v86 = startPosition
            local n5 = 1

            local function v87(p15, p16, p17, p18) -- line: 450
                -- upvalues: v82 (ref), n3 (ref), v86 (ref), n5 (ref), v25 (copy), v36 (copy)
                local v88 = p15 - v86

                v86 = p15

                if v88.Magnitude > 0.001 then
                    local v89 = not (v82 == "bounce" and n3 == 2) and v82 ~= "sink"
                    local v90 = if p18 then Vector3.new(p18.X, v88.Y, p18.Z) else v88

                    if v89 then
                        local Magnitude = Vector3.new(v90.X, 0, v90.Z).Magnitude
                        local v91 = if Magnitude > 0.001 then -Magnitude * 0.5773502691896257 else v90.Y

                        v90 = Vector3.new(v90.X, math.max(v90.Y, v91), v90.Z)
                    end

                    if v25 ~= nil then
                        local Unit = v90.Unit

                        v25:PivotTo(CFrame.lookAt(p16, p16 + Unit) * CFrame.Angles(-1.5707963267948966, 0, 0))
                    end
                end

                if v36.current then
                    local v95 = 1 - math.clamp(math.max((if p17 > 0 then v88.Magnitude / p17 else 0) - 40, 0) / 80, 0, 1) ^ 3 * 0.2
                    local v96 = n5

                    n5 = v96 + (v95 - n5) * math.min(p17 * 8, 1)
                    v36.current.Transparency = n5
                end
            end

            local v99 = waterSurfaceY + 1

            local function v100(p19) -- line: 487
                -- upvalues: v25 (copy), RunService (copy), Workspace (copy), PerfectVFX (copy), playVisulie (copy)
                local Model = Instance.new("Model")

                Model.Name = "PerfectVFXContainer"
                Model.Parent = Workspace
                playVisulie(PerfectVFX, p19, Model)

                local connection

                connection = RunService.RenderStepped:Connect(function() -- line: 493
                    -- upvalues: Model (copy), connection (ref), v25 (copy)
                    if not v25.Parent then
                        connection:Disconnect()
                        Model:Destroy()

                        return nil
                    end

                    Model:PivotTo(v25:GetPivot())
                end)
                task.delay(2.2, function() -- line: 501
                    -- upvalues: Model (copy), connection (ref)
                    connection:Disconnect()
                    Model:Destroy()
                end)
            end

            local connection = RunService.RenderStepped:Connect(function() -- line: 506
                -- upvalues: v25 (copy), v37 (copy)
                if v37.current then
                    v37.current:PivotTo(v25:GetPivot())
                end
            end)
            local connection2 = RunService.RenderStepped:Connect(function() -- line: 511
                -- upvalues: Unit (copy), TouchEnabled (copy), v63 (copy), v64 (ref), cameraBackDistance (copy), cameraUpDistance (copy), v11 (copy), v25 (copy), v28 (copy), hookFlightSteeringActiveAtom (copy), flightSteeringCameraConfig (copy)
                if TouchEnabled then
                    if hookFlightSteeringActiveAtom() then
                        v11.CameraType = Enum.CameraType.Scriptable

                        local Position = v25:GetPivot().Position
                        local v102 = Unit * -cameraBackDistance
                        local v103 = Vector3.new(0, cameraUpDistance, 0)
                        local v104 = Position + v102 + v103

                        v11.CFrame = CFrame.lookAt(v104, v104 + Unit) * CFrame.Angles(0, 0, (math.rad(flightSteeringCameraConfig.zAngleDegrees)))
                    elseif not v64 then
                        v64 = true
                        v11.CameraType = Enum.CameraType.Track
                        v11.CameraSubject = v28
                    end

                    return nil
                end

                if v64 then
                    return nil
                end

                local v107 = math.clamp((tick() - v63) / 0.3, 0, 1)
                local Position = v25:GetPivot().Position
                local v109 = Position + Unit * -cameraBackDistance
                local v110 = Vector3.new(0, cameraUpDistance, 0)
                local v111 = CFrame.lookAt(v109 + v110, Position)

                v11.CFrame = v11.CFrame:Lerp(v111, 0.8)

                if v107 >= 1 then
                    v64 = true
                    v11.CameraType = Enum.CameraType.Track
                end
            end)
            local connection3 = RunService.Heartbeat:Connect(function(p20) -- line: 544
                -- upvalues: v48 (ref), Unit (copy), v49 (copy), v50 (copy), v52 (copy), v53 (copy), v54 (copy), v56 (copy), v58 (copy), v68 (copy), t2 (copy), v71 (copy), v72 (copy), v73 (ref), v74 (ref), n1 (ref), v75 (ref), v76 (ref), v79 (ref), v81 (copy), v82 (ref), v83 (ref), v84 (ref), n3 (ref), n4 (ref), t3 (copy), t4 (copy), v85 (copy), v87 (copy), v99 (copy), v100 (copy), drag3 (ref), startPosition (copy), peakBias (copy), peakHeight (copy), v7 (ref), v9 (ref), v10 (ref), getSound (copy), v20 (copy), v37 (copy), v40 (copy), v42 (copy), v45 (copy), v47 (ref), hapticWaterSkip (copy), events (copy), hookCastDistanceAtom (copy), hookLandedPositionAtom (copy), hookFlightSteeringActiveAtom (copy), hookFlightSteeringInputAtom (copy), bounceCount (copy), computeArcOffset (copy), computeBounceDistances (copy), waterSurfaceY (copy), flightLateralOffsetLimit (copy), flightLateralSpeedFromInput (copy), clampFishingBoundaryOffset (copy), Splash (copy), playVisulie (copy)
                if not v74 or v75 then
                    return nil
                end

                if v82 == "flight" then
                    local v114 = math.max(0, (tick() - v73) / v42)
                    local v116 = math.max(0, v114 - v50)
                    local v117 = if v114 <= v50 then v114 else v50 + (1 - v50) * (1 - math.exp(-drag3 * v116)) / drag3
                    local v121 = Unit * (v53 * v117)
                    local v122 = startPosition.Y + v54 * v117 + computeArcOffset(v117 / v52, peakHeight, peakBias)
                    local v123 = if v50 > 0 then math.clamp(v114 / v50, 0, 1) else 1
                    local v125 = flightLateralSpeedFromInput(hookFlightSteeringInputAtom())
                    local v126 = n1 + v125 * math.clamp(p20, 0, 0.06666666666666667)
                    local v128 = flightLateralOffsetLimit(v123, v56)

                    n1 = if v58 then clampFishingBoundaryOffset(v126, v58) else math.clamp(v126, -v128, v128)

                    local v131 = startPosition * Vector3.new(1, 0, 1) + v121
                    local v133 = v49 * n1
                    local v134 = Vector3.new(0, v122, 0)
                    local v135 = v131 + v133 + v134
                    local v137 = math.clamp((tick() - v73) / 0.2, 0, 1)
                    local v138 = v137 * v137 * (3 - v137 * 2)

                    v87(v135, v48:Lerp(v135, v138), p20, Unit)

                    local v140 = (v135 * Vector3.new(1, 0, 1) - v72):Dot(Unit)

                    hookCastDistanceAtom(v140)

                    if v79 < v140 then
                        v81()
                    end

                    if v83 > waterSurfaceY and v122 <= waterSurfaceY then
                        v84 = Vector3.new(v135.X, 0, v135.Z) - v49 * n1

                        local v143 = computeBounceDistances(v45, bounceCount, v85)

                        for i = 0, bounceCount - 1 do
                            t3[i + 1] = v143[i + 1]

                            local v144 = 2 * v9 * v85 ^ i / v10

                            t4[i + 1] = math.sqrt(v144) * 2
                        end

                        n3 = 0
                        v76 = tick()
                        n4 = 0
                        v82 = "bounce"
                        print((("[HookCast] initial water hit isPerfect=%*"):format(v7)))
                        playVisulie(Splash, CFrame.new(v135.X, v99, v135.Z))

                        if v7 then
                            v100(CFrame.new(v135.X, v99, v135.Z))
                        end

                        getSound("WaterSkip"):Play()
                        hapticWaterSkip()
                        v68(t2[1])

                        local roll = v47.current.roll

                        if roll ~= nil then
                            roll:Play()
                        end
                    end

                    v83 = v122

                    if (if v50 >= 1 then v114 >= 1 else math.exp(-drag3 * v116) < 0.01) and v82 == "flight" then
                        hookLandedPositionAtom(v135)
                        events.hookLanded:fire(v135)
                        v74 = false
                    end
                elseif v82 == "bounce" then
                    local v147 = tick() - v76
                    local v148 = t4[n3 + 1]
                    local v149 = if v148 > 0 then math.clamp(v147 / v148, 0, 1) else 1

                    if n3 < 3 then
                        local v151 = flightLateralSpeedFromInput(hookFlightSteeringInputAtom())
                        local v152 = n1 + v151 * math.clamp(p20, 0, 0.06666666666666667)
                        local v154 = flightLateralOffsetLimit(1, v56)

                        n1 = if v58 then clampFishingBoundaryOffset(v152, v58) else math.clamp(v152, -v154, v154)
                    end

                    local v157 = v9 * v85 ^ n3
                    local v158 = n4 + t3[n3 + 1] * v149
                    local v160 = waterSurfaceY + v157 * 4 * v149 * (1 - v149)
                    local v161 = v84
                    local v162 = Unit * v158
                    local v164 = v49 * n1
                    local v165 = Vector3.new(0, v160, 0)
                    local v166 = v161 + v162 + v164 + v165

                    v87(v166, v166, p20, Unit)

                    local v167 = (v166 * Vector3.new(1, 0, 1) - v72):Dot(Unit)

                    hookCastDistanceAtom(v167)

                    if v79 < v167 then
                        v81()
                    end

                    if v149 >= 1 then
                        print((("[HookCast] bounce %* splash isPerfect=%*"):format(n3, v7)))
                        playVisulie(Splash, CFrame.new(v166.X, v99, v166.Z))

                        if v7 then
                            v100(CFrame.new(v166.X, v99, v166.Z))
                        end

                        n4 += t3[n3 + 1]
                        n3 += 1
                        events.analyticsHookBounce:fire(n3)

                        if n3 >= 3 then
                            hookFlightSteeringActiveAtom(false)

                            local current = v37.current

                            if current ~= nil then
                                current:Destroy()
                            end

                            v37.current = nil
                            getSound("DivingIntoWater"):Play()
                            hapticWaterSkip()
                            v82 = "sink"
                            v20(true)
                            v76 = tick()
                            v68(v71)

                            local roll = v47.current.roll

                            if roll ~= nil then
                                roll:Stop()
                            end

                            local idle = v47.current.idle

                            if idle ~= nil then
                                idle:Play()
                            end
                        else
                            getSound("WaterSkip"):Play()
                            hapticWaterSkip()
                            v76 = tick()
                            v68(t2[n3 + 1])

                            local roll = v47.current.roll

                            if roll ~= nil then
                                roll:Play()
                            end
                        end
                    end
                elseif v82 == "sink" then
                    local v170 = tick() - v76
                    local v172 = 1 - math.exp(-drag3 * v170)
                    local v173 = n4 + t3[3] * v172
                    local v175 = waterSurfaceY + (v40 - waterSurfaceY) * v172
                    local v176 = v84
                    local v177 = Unit * v173
                    local v179 = v49 * n1
                    local v180 = Vector3.new(0, v175, 0)
                    local v181 = v176 + v177 + v179 + v180

                    v87(v181, v181, p20, Unit)

                    local v182 = (v181 * Vector3.new(1, 0, 1) - v72):Dot(Unit)

                    hookCastDistanceAtom(v182)

                    if v79 < v182 then
                        v81()
                    end

                    if math.exp(-drag3 * v170) < 0.01 then
                        hookLandedPositionAtom(v181)
                        events.hookLanded:fire(v181)
                        v74 = false
                    end
                end
            end)

            return function() -- line: 708
                -- upvalues: v69 (copy), t2 (copy), v71 (copy), v77 (copy), connection (copy), connection2 (copy), connection3 (copy), v11 (copy), v20 (copy), v37 (copy), Players (copy), RunService (copy), hookCastDistanceAtom (copy), hookLandedPositionAtom (copy), hookFlightSteeringActiveAtom (copy)
                hookFlightSteeringActiveAtom(false)
                connection:Disconnect()
                connection2:Disconnect()
                connection3:Disconnect()
                v77()
                v69:Destroy()

                local function v184(p21) -- line: 716
                    return p21:Destroy()
                end

                for v185, v186 in t2 do
                    local _ = v185 - 1

                    v186:Destroy()
                end

                v71:Destroy()

                local current = v37.current

                if current ~= nil then
                    current:Destroy()
                end

                v37.current = nil
                hookLandedPositionAtom(nil)
                hookCastDistanceAtom(0)
                v20(false)
                v11.CameraType = if not RunService:IsStudio() or RunService:IsRunning() then Enum.CameraType.Custom else Enum.CameraType.Orbital

                local Character = Players.LocalPlayer.Character

                v11.CameraSubject = if Character ~= nil then Character:FindFirstChildOfClass("Humanoid") else Character
            end
        end, {
            startPosition,
            direction,
            drag3,
            v40,
            v41,
            v42,
            v43,
            power,
            peakBias,
            peakHeight,
            cameraBackDistance,
            cameraUpDistance,
            v7,
            v8,
            v9,
            v10,
            v45,
            v11,
            v25,
            v39,
            getSound,
            v20
        })

        local v44 = useCallback(function() -- line: 740
            -- upvalues: miniPlayerRig (copy)
            return miniPlayerRig
        end, {})
        local v188 = useCallback(function(p22) -- line: 743
            -- upvalues: CollectionService (copy)
            CollectionService:AddTag(p22, "ApplyLocalCharacterAppearance")
        end, {})
        local v189 = useCallback(function(p23) -- line: 746
            -- upvalues: v26 (copy), v29 (copy)
            v26(p23)

            if p23 then
                v29(p23.HumanoidRootPart)
            end
        end, { v26, v29 })

        useEffect(function() -- line: 752
            -- upvalues: v25 (copy), v36 (copy), v37 (copy), attachFlyingWaveToHead (copy), attachFlyingVFXToRig (copy)
            if not v25 then
                return nil
            end

            v36.current = attachFlyingWaveToHead(v25)
            v37.current = attachFlyingVFXToRig(v25)
        end, { v25 })
        useEffect(function() -- line: 768
            -- upvalues: v15 (copy), v17 (copy), v23 (ref), v25 (copy), applyBaitAuraVfx (copy), clearBaitAuraVfx (copy)
            if not v25 then
                return nil
            end

            local Humanoid = v25:FindFirstChildOfClass("Humanoid")

            local function v190() -- line: 773
                -- upvalues: v15 (copy), v17 (copy), v23 (ref), v25 (copy), applyBaitAuraVfx (copy), clearBaitAuraVfx (copy)
                if not v15 or v17 then
                    applyBaitAuraVfx(v25, v23)
                else
                    clearBaitAuraVfx(v25)
                end
            end

            if not v15 or v17 then
                applyBaitAuraVfx(v25, v23)
            else
                clearBaitAuraVfx(v25)
            end

            if Humanoid ~= nil then
                Humanoid = Humanoid.ApplyDescriptionFinished:Connect(function() -- line: 783
                    -- upvalues: v190 (copy)
                    return v190()
                end)
            end

            return function() -- line: 788
                -- upvalues: Humanoid (ref), v25 (copy), clearBaitAuraVfx (copy)
                if Humanoid ~= nil then
                    Humanoid:Disconnect()
                end

                clearBaitAuraVfx(v25)
            end
        end, { v25, v23, v15, v17 })
        v47 = useRef({})
        useEffect(function() -- line: 798
            -- upvalues: v25 (copy), v47 (ref), animations (copy)
            if not v25 then
                return nil
            end

            local Humanoid = v25:FindFirstChildOfClass("Humanoid")

            if Humanoid ~= nil then
                Humanoid = Humanoid:FindFirstChildOfClass("Animator")
            end

            if not Humanoid then
                return nil
            end

            local flyingAnim = animations.flyingAnim
            local Animation = Instance.new("Animation")

            Animation.AnimationId = flyingAnim

            local track = Humanoid:LoadAnimation(Animation)
            local waterImpactRoll = animations.waterImpactRoll
            local Animation2 = Instance.new("Animation")

            Animation2.AnimationId = waterImpactRoll

            local track2 = Humanoid:LoadAnimation(Animation2)
            local idleFloat = animations.idleFloat
            local Animation3 = Instance.new("Animation")

            Animation3.AnimationId = idleFloat

            local track3 = Humanoid:LoadAnimation(Animation3)

            track.Looped = true
            track3.Looped = true
            track2.Looped = false

            local v191 = v47

            v191.current = {
                fly = track,
                roll = track2,
                idle = track3
            }
            track:Play()

            return function() -- line: 827
                -- upvalues: track (copy), track2 (copy), track3 (copy), v47 (ref)
                track:Stop()
                track2:Stop()
                track3:Stop()

                local v192 = v47

                v192.current = {}
            end
        end, { v25 })

        local createElement, Fragment = react.createElement, react.Fragment
        local v193 = not v13 and not v19 and react.createElement(CameraFov, {
            rigRef = v25
        })
        local v194 = not v13 and not v19 and react.createElement(CameraSpeedlines, {
            speed = v43
        })
        local v195 = showHook and react.createElement(default, {
            getPrefabInstance = v44,
            onPrefabInstantiated = v188,
            prefabRef = v189
        })

        if not v28 then
            return createElement(Fragment, nil, v193, v194, v195, v28)
        end

        return createElement(Fragment, nil, v193, v194, v195, (createPortal(react.createElement(react.Fragment, nil, react.createElement("attachment", {
            Position = Vector3.new(0.4, 0, 0),
            key = "att0",
            ref = v32
        }), react.createElement("attachment", {
            Position = Vector3.new(-0.4, 0, 0),
            key = "att1",
            ref = v35
        }), v31 and v34 and react.createElement("trail", {
            Lifetime = 0.5,
            MinLength = 0,
            key = "trail",
            Attachment0 = v31,
            Attachment1 = v34,
            Color = v21,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.6, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            }),
            WidthScale = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0.1)
            })
        })), v28)))
    end
}
