-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingBoostFillAtom, trainingIsFrenzyAtom, trainingSkillcheckHitCounterAtom, frenzyEndTimeAtom = v1.trainingBoostFillAtom, v1.trainingIsFrenzyAtom, v1.trainingSkillcheckHitCounterAtom, v1.frenzyEndTimeAtom
local haptics = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics")
local cameraShakeEnabledAtom, hapticCircleClick = haptics.cameraShakeEnabledAtom, haptics.hapticCircleClick
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local v2 = RuntimeLib.import(script, script.Parent, "training-skillcheck.config")
local defaultTrainingTuning, getTrainingScale = v2.defaultTrainingTuning, v2.getTrainingScale
local default2 = RuntimeLib.import(script, script.Parent, "training-skillcheck-target").default
local events = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").events
local n1 = 0

local function MissedFeedback(p1) -- line: 31
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useMotion (copy), default (copy), useScreenSizeState (copy), getTrainingScale (copy)
    local pos, onRemove = p1.pos, p1.onRemove
    local v3 = getTrainingScale(useScreenSizeState())
    local v4, v5 = useMotion(0)
    local v6, v7 = useMotion(0)
    local v8 = useRef(true)
    local v9 = useRef(onRemove)

    v9.current = onRemove
    useEffect(function() -- line: 40
        -- upvalues: v3 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy)
        v7:tween(-28 * v3, {
            time = 0.75,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.Out
        })
        task.delay(0.25, function() -- line: 46
            -- upvalues: v5 (copy), v8 (copy)
            if not v8.current then
                return nil
            end

            v5:tween(1, {
                time = 0.5,
                style = Enum.EasingStyle.Linear
            })
        end)
        task.delay(0.8, function() -- line: 55
            -- upvalues: v8 (copy), v9 (copy)
            if not v8.current then
                return nil
            end

            v9.current()
        end)

        return function() -- line: 61
            -- upvalues: v8 (copy)
            v8.current = false
        end
    end, {})

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v6:map(function(p2) -- line: 68
            -- upvalues: pos (copy)
            return UDim2.fromOffset(pos.x, pos.y + p2)
        end),
        Size = UDim2.fromOffset(110 * v3, 36 * v3)
    }, react.createElement(default, {
        text = "Missed!",
        color = Color3.fromRGB(220, 40, 40),
        overrideProps = {
            TextScaled = true,
            ZIndex = 10,
            Size = UDim2.fromScale(1, 1)
        },
        strokeProps = {
            Color = Color3.fromRGB(0, 0, 0)
        },
        textTransparency = v4
    }))
end

local function randomPosInArea(p3, p4, p5, p6, p7) -- line: 87
    local v10 = p6 * 1.1
    local v11 = p3 * 0.5
    local v12 = p4 * 0.5
    local v13 = p3 * 0.12
    local v14 = p4 * 0.12

    for _ = 0, 19 do
        local v15 = (p3 - p5 * 2) * 0.5 - v13
        local v16 = (p4 - p5 * 2) * 0.5 - v14
        local v17 = if math.random() < 0.5 then v11 - v13 - math.random() * v15 else v11 + v13 + math.random() * v15
        local v18 = if math.random() < 0.5 then v12 - v14 - math.random() * v16 else v12 + v14 + math.random() * v16
        local v19 = p7 == nil
        local v20

        if not v19 then
            local v21 = v17 - p7.x
            local v22 = v18 - p7.y

            v20 = math.sqrt(v21 * v21 + v22 * v22) < v10
        end

        if v19 or not v20 then
            return {
                x = v17,
                y = v18
            }
        end
    end

    return {
        x = if math.random() < 0.5 then v11 - v13 * 2 else v11 + v13 * 2,
        y = if math.random() < 0.5 then v12 - v14 * 2 else v12 + v14 * 2
    }
end

return {
    default = function(p8) -- TrainingSkillcheck | line: 118
        -- upvalues: Flamework (copy), react (copy), useBinding (copy), useEffect (copy), useRef (copy), useState (copy), RunService (copy), Workspace (copy), shake (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), trainingSkillcheckHitCounterAtom (copy), frenzyEndTimeAtom (copy), cameraShakeEnabledAtom (copy), hapticCircleClick (copy), useScreenSizeState (copy), defaultTrainingTuning (copy), getTrainingScale (copy), default2 (copy), events (copy), n1 (ref), MissedFeedback (copy), randomPosInArea (copy)
        local isActive, baseSpawnDelayMs = p8.isActive, p8.baseSpawnDelayMs

        if baseSpawnDelayMs == nil then
            baseSpawnDelayMs = defaultTrainingTuning.baseSpawnDelayMs
        end

        local boostGainPerHit = p8.boostGainPerHit

        if boostGainPerHit == nil then
            boostGainPerHit = defaultTrainingTuning.boostGainPerHit
        end

        local circleDurationMs = p8.circleDurationMs

        if circleDurationMs == nil then
            circleDurationMs = defaultTrainingTuning.circleDurationMs
        end

        local frenzyDurationSeconds = p8.frenzyDurationSeconds

        if frenzyDurationSeconds == nil then
            frenzyDurationSeconds = defaultTrainingTuning.frenzyDurationSeconds
        end

        local minSpawnDelayMs = p8.minSpawnDelayMs

        if minSpawnDelayMs == nil then
            minSpawnDelayMs = defaultTrainingTuning.minSpawnDelayMs
        end

        local playAreaHeight = p8.playAreaHeight

        if playAreaHeight == nil then
            playAreaHeight = defaultTrainingTuning.playAreaHeight
        end

        local playAreaPadding = p8.playAreaPadding

        if playAreaPadding == nil then
            playAreaPadding = defaultTrainingTuning.playAreaPadding
        end

        local playAreaWidth = p8.playAreaWidth

        if playAreaWidth == nil then
            playAreaWidth = defaultTrainingTuning.playAreaWidth
        end

        local size = p8.size

        if size == nil then
            size = defaultTrainingTuning.size
        end

        local spawnAccelerationFactor = p8.spawnAccelerationFactor

        if spawnAccelerationFactor == nil then
            spawnAccelerationFactor = defaultTrainingTuning.spawnAccelerationFactor
        end

        local v24 = getTrainingScale(useScreenSizeState())
        local v25, v26 = useState(false)
        local v27, v28 = useState({})
        local v29, v30 = useState({
            x = playAreaWidth * 0.5,
            y = playAreaHeight * 0.5
        })
        local v31, v32 = useBinding(0)
        local v33 = useRef(true)
        local v34 = useRef(false)
        local v35 = useRef(isActive)
        local idle = useRef("idle")
        local v36 = useRef({
            x = playAreaWidth * 0.5,
            y = playAreaHeight * 0.5
        })
        local v37 = useRef(os.clock())
        local v38 = useRef(0)
        local v39 = useRef(0)
        local v40 = useRef(baseSpawnDelayMs)
        local v41 = useRef(v32)

        v41.current = v32

        local v42 = useRef({
            baseSpawnDelayMs = baseSpawnDelayMs,
            boostGainPerHit = boostGainPerHit,
            circleDurationMs = circleDurationMs,
            frenzyDurationSeconds = frenzyDurationSeconds,
            lateGraceMs = defaultTrainingTuning.lateGraceMs,
            minSpawnDelayMs = minSpawnDelayMs,
            playAreaHeight = playAreaHeight,
            playAreaPadding = playAreaPadding,
            playAreaWidth = playAreaWidth,
            size = size,
            spawnAccelerationFactor = spawnAccelerationFactor
        })

        v42.current = {
            baseSpawnDelayMs = baseSpawnDelayMs,
            boostGainPerHit = boostGainPerHit,
            circleDurationMs = circleDurationMs,
            frenzyDurationSeconds = frenzyDurationSeconds,
            lateGraceMs = defaultTrainingTuning.lateGraceMs,
            minSpawnDelayMs = minSpawnDelayMs,
            playAreaHeight = playAreaHeight * v24,
            playAreaPadding = playAreaPadding * v24,
            playAreaWidth = playAreaWidth * v24,
            size = size * v24,
            spawnAccelerationFactor = spawnAccelerationFactor
        }

        local v43 = useRef(function() -- line: 209
        end)
        local v44 = useRef(function() -- line: 210
        end)
        local v45 = useRef(0)
        local v46 = useRef(defaultTrainingTuning.popSoundBasePitch)

        useEffect(function() -- line: 213
            -- upvalues: isActive (copy), v35 (copy)
            v35.current = isActive
        end, { isActive })
        useEffect(function() -- line: 216
            -- upvalues: v33 (copy)
            return function() -- line: 217
                -- upvalues: v33 (copy)
                v33.current = false
            end
        end, {})

        function v43.current() -- line: 222
            -- upvalues: v26 (copy), v30 (copy), v32 (copy), v33 (copy), v34 (copy), idle (copy), v36 (copy), v37 (copy), v42 (copy), randomPosInArea (copy)
            if not v33.current or idle.current ~= "active" then
                return nil
            end

            local current = v42.current
            local v47 = randomPosInArea(current.playAreaWidth, current.playAreaHeight, current.playAreaPadding, current.size, v36.current)

            v36.current = v47
            v37.current = os.clock()
            v32(0)
            v30(v47)
            v34.current = true
            v26(true)
        end

        local function queueNextCircle(p9) -- line: 239
            -- upvalues: v43 (copy)
            task.delay(p9 / 1000, function() -- line: 240
                -- upvalues: v43 (copy)
                return v43.current()
            end)
        end

        local function startFrenzy() -- line: 244
            -- upvalues: v26 (copy), v32 (copy), v34 (copy), idle (copy), v39 (copy), v40 (copy), v42 (copy), trainingIsFrenzyAtom (copy), frenzyEndTimeAtom (copy), events (copy)
            idle.current = "frenzy"
            trainingIsFrenzyAtom(true)
            events.trainingFrenzyStarted:fire()
            v34.current = false
            v26(false)
            v32(0)
            v39.current = os.clock() + v42.current.frenzyDurationSeconds
            frenzyEndTimeAtom(v39.current)
            v40.current = v42.current.baseSpawnDelayMs
            print((("[FRENZY DEBUG] startFrenzy: endTime=%*, duration=%*s, now=%*"):format(v39.current, v42.current.frenzyDurationSeconds, (os.clock()))))
        end

        local function endFrenzy() -- line: 257
            -- upvalues: v35 (copy), idle (copy), v38 (copy), v39 (copy), v43 (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy)
            local elapsed = os.clock()
            local current = v39.current
            local v48 = current - elapsed

            print((("[FRENZY DEBUG] endFrenzy: now=%*, expectedEnd=%*, earlyBy=%*s, isActive=%*"):format(elapsed, current, v48, v35.current)))
            trainingIsFrenzyAtom(false)
            v38.current = 0
            trainingBoostFillAtom(0)

            if v35.current then
                idle.current = "active"
                v43.current()
            else
                idle.current = "idle"
            end
        end

        function v44.current() -- line: 272
            -- upvalues: v26 (copy), v32 (copy), v34 (copy), idle (copy), v38 (copy), v40 (copy), v42 (copy), v43 (copy), v45 (copy), v46 (copy), startFrenzy (copy), Flamework (copy), Workspace (copy), shake (copy), trainingBoostFillAtom (copy), trainingSkillcheckHitCounterAtom (copy), cameraShakeEnabledAtom (copy), hapticCircleClick (copy), defaultTrainingTuning (copy)
            if idle.current ~= "active" or not v34.current then
                return nil
            end

            local current = v42.current

            v34.current = false
            v26(false)
            v32(0)

            local elapsed = os.clock()

            if elapsed - v45.current <= defaultTrainingTuning.popSoundPitchWindowSeconds then
                v46.current = math.min(v46.current + defaultTrainingTuning.popSoundPitchStep, defaultTrainingTuning.popSoundPitchCap)
            else
                v46.current = defaultTrainingTuning.popSoundBasePitch
            end

            v45.current = elapsed
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):playSoundPolyphonic("PopSound", v46.current, defaultTrainingTuning.popSoundVolume)
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):playSoundPolyphonic("ThockyKeyboard", v46.current, defaultTrainingTuning.thockyKeyboardVolume, defaultTrainingTuning.thockyKeyboardStartTime)
            hapticCircleClick()

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera and cameraShakeEnabledAtom() then
                local _CFrame = CurrentCamera.CFrame
                local v50 = shake.new()

                v50.Amplitude = 0.8
                v50.Frequency = 0.07142857142857142
                v50.FadeInTime = 0
                v50.FadeOutTime = 0.25
                v50.SustainTime = 0
                v50.PositionInfluence = Vector3.new(0.1, 0.1, 0.1)
                v50.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
                v50:Start()
                v50:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p10, p11, p12) -- line: 306
                    -- upvalues: CurrentCamera (copy), _CFrame (copy)
                    if p12 then
                        CurrentCamera.CFrame = _CFrame

                        return nil
                    end

                    local _CFrame2 = CurrentCamera.CFrame
                    local v51 = CFrame.new(p10)
                    local v52 = CFrame.fromEulerAnglesXYZ(p11.X, p11.Y, p11.Z)

                    CurrentCamera.CFrame = _CFrame2 * v51 * v52
                end)
            end

            trainingSkillcheckHitCounterAtom(function(p13) -- line: 318
                return p13 + 1
            end)
            v38.current = math.min(v38.current + current.boostGainPerHit, 1)
            trainingBoostFillAtom(v38.current)

            if v38.current >= 1 then
                startFrenzy()

                return nil
            end

            v40.current = math.max(v40.current * current.spawnAccelerationFactor, current.minSpawnDelayMs)

            local current2 = v40.current

            task.delay(current2 / 1000, function() -- line: 240
                -- upvalues: v43 (copy)
                return v43.current()
            end)
        end

        useEffect(function() -- line: 334
            -- upvalues: isActive (copy), v26 (copy), v28 (copy), v32 (copy), v34 (copy), idle (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy), v40 (copy), v41 (copy), v42 (copy), v43 (copy), endFrenzy (copy), RunService (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), n1 (ref)
            if isActive then
                idle.current = "active"
                v38.current = 0
                trainingBoostFillAtom(0)
                v40.current = v42.current.baseSpawnDelayMs
                v43.current()

                local connection = RunService.Heartbeat:Connect(function(_) -- line: 357
                    -- upvalues: v26 (copy), v28 (copy), v34 (copy), idle (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy), v40 (copy), v41 (copy), v42 (copy), v43 (copy), endFrenzy (copy), trainingBoostFillAtom (copy), n1 (ref)
                    local current = v42.current

                    if idle.current == "frenzy" then
                        local v55 = v39.current - os.clock()
                        local v57 = math.max(v55 / current.frenzyDurationSeconds, 0)

                        v38.current = v57
                        trainingBoostFillAtom(v57)

                        if v55 <= 0 then
                            print((("[FRENZY DEBUG] Heartbeat triggered endFrenzy: remaining=%*, fill=%*"):format(v55, v57)))
                            endFrenzy()
                        end

                        return nil
                    end

                    if idle.current ~= "active" or not v34.current then
                        return nil
                    end

                    local v58 = os.clock() - v37.current
                    local v59 = v58 / (current.circleDurationMs / 1000)

                    v41.current(v59)

                    if not ((current.circleDurationMs + current.lateGraceMs) / 1000 <= v58) then
                        return
                    end

                    local v60 = table.clone(v36.current)

                    setmetatable(v60, nil)
                    v34.current = false
                    v26(false)
                    v41.current(0)

                    local v61 = n1

                    n1 += 1
                    v28(function(p15) -- line: 394
                        -- upvalues: v60 (copy), v61 (copy)
                        local t2 = {}
                        local v62 = #t2
                        local v63 = #p15

                        table.move(p15, 1, v63, v62 + 1, t2)
                        t2[v62 + v63 + 1] = {
                            id = v61,
                            pos = v60
                        }

                        return t2
                    end)
                    v40.current = current.baseSpawnDelayMs

                    local baseSpawnDelayMs = current.baseSpawnDelayMs

                    task.delay(baseSpawnDelayMs / 1000, function() -- line: 240
                        -- upvalues: v43 (copy)
                        return v43.current()
                    end)
                end)

                return function() -- line: 410
                    -- upvalues: connection (copy), v26 (copy), v32 (copy), v34 (copy), idle (copy), v38 (copy), v39 (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy)
                    connection:Disconnect()
                    v34.current = false
                    v26(false)
                    v32(0)

                    if idle.current == "frenzy" then
                        local elapsed = os.clock()
                        local current = v39.current

                        print((("[FRENZY DEBUG] useEffect cleanup forcibly ended frenzy: now=%*, expectedEnd=%*, earlyBy=%*s"):format(elapsed, current, current - elapsed)))
                    end

                    trainingIsFrenzyAtom(false)
                    trainingBoostFillAtom(0)
                    v38.current = 0
                    idle.current = "idle"
                end
            end

            if idle.current == "frenzy" then
                local elapsed = os.clock()
                local current = v39.current

                print((("[FRENZY DEBUG] isActive=false branch killed frenzy: now=%*, expectedEnd=%*, earlyBy=%*s"):format(elapsed, current, current - elapsed)))
            end

            idle.current = "idle"
            v34.current = false
            v26(false)
            v32(0)
            trainingIsFrenzyAtom(false)
            trainingBoostFillAtom(0)
            v38.current = 0

            return nil
        end, { isActive })

        if not isActive then
            return react.createElement(react.Fragment)
        end

        v25 = v25 and react.createElement(default2, {
            approachRingProgress = v31,
            onTap = function() -- onTap | line: 432
                -- upvalues: v44 (copy)
                return v44.current()
            end,
            size = size * v24,
            targetPos = v29
        })

        local v64 = table.create(#v27)

        local function v65(p16) -- line: 440
            -- upvalues: v28 (copy), react (copy), MissedFeedback (copy)
            return react.createElement(MissedFeedback, {
                key = tostring(p16.id),
                onRemove = function() -- onRemove | line: 443
                    -- upvalues: p16 (copy), v28 (copy)
                    return v28(function(p17) -- line: 444
                        -- upvalues: p16 (copy)
                        local t5 = {}
                        local n2 = 0

                        for v66, v67 in p17 do
                            local _ = v66 - 1

                            if v67.id ~= p16.id == true then
                                n2 += 1
                                t5[n2] = v67
                            end
                        end

                        return t5
                    end)
                end,
                pos = p16.pos
            })
        end

        for v68, v69 in v27 do
            v64[v68] = v65(v69, v68 - 1, v27)
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 15,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.44),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = false,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(playAreaWidth * v24, playAreaHeight * v24)
        }, v25, v64))
    end
}
