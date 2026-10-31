-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, ReplicatedStorage, RunService, Workspace = services.CollectionService, services.ReplicatedStorage, services.RunService, services.Workspace
local hookHrpAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom").hookHrpAtom
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local flightTriggerGateComboAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "flight-trigger-gate-combo-atom").flightTriggerGateComboAtom
local flightGateFXConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig
local getFishingBoundaryLimits = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-boundary-utils").getFishingBoundaryLimits
local playClonedVfxWithSound, playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").playClonedVfxWithSound, RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").playClonedSound
local flightTriggerGateConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-trigger-gate-config").flightTriggerGateConfig
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "flight-trigger-gate-events")
local flightTriggerGateRingMissed, flightTriggerGateRingPassed, flightTriggerGateRunEnded, flightTriggerGateRunStarted = v1.flightTriggerGateRingMissed, v1.flightTriggerGateRingPassed, v1.flightTriggerGateRunEnded, v1.flightTriggerGateRunStarted
local flightTriggerGateStreakFailVersionAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "flight-trigger-gate-streak-fail-atom").flightTriggerGateStreakFailVersionAtom
local resolveZoneContaining = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zone-detection-utils").resolveZoneContaining
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-trigger-gate-utils")
local createFlightGatePath, planFlightGates, projectedHalfExtent = v2.createFlightGatePath, v2.planFlightGates, v2.projectedHalfExtent
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-combo-utils")
local getFlightGateComboTier, lerpFlightGateGradient, sampleFlightGateGradient = v3.getFlightGateComboTier, v3.lerpFlightGateGradient, v3.sampleFlightGateGradient

local function getDetectableCrossing(p1, p2, p3) -- line: 40
    -- upvalues: flightTriggerGateConfig (copy)
    local v4 = p3.CFrame:PointToObjectSpace(p1)
    local v5 = p3.CFrame:PointToObjectSpace(p2)
    local v7 = p3.Size * 0.5 + Vector3.new(flightTriggerGateConfig.detectorPadding, flightTriggerGateConfig.detectorPadding, flightTriggerGateConfig.detectorPadding)
    local v8 = v5 - v4
    local n1 = 1
    local n2 = 0

    for _, v9 in { "X", "Y", "Z" } do
        if math.abs(v8[v9]) < 1E-04 then
            if math.abs(v4[v9]) > v7[v9] then
                return nil
            end
        else
            local v12 = (-v7[v9] - v4[v9]) / v8[v9]
            local v13 = (v7[v9] - v4[v9]) / v8[v9]

            n2 = math.max(n2, (math.min(v12, v13)))
            n1 = math.min(n1, (math.max(v12, v13)))

            if n1 < n2 then
                return nil
            end
        end
    end

    if n1 < 0 or n2 > 1 then
        return nil
    end

    return p1:Lerp(p2, (math.clamp(n2, 0, 1)))
end

local function isGateColorable(p4) -- line: 70
    return p4:IsA("BasePart")
        or p4:IsA("SpecialMesh")
        or p4:IsA("Beam")
        or p4:IsA("Trail")
        or p4:IsA("ParticleEmitter")
        or p4:IsA("PointLight")
        or p4:IsA("SpotLight")
        or p4:IsA("SurfaceLight")
end

local function getGateColorables(p5) -- line: 73
    -- upvalues: isGateColorable (copy)
    local Descendants = p5:GetDescendants()
    local t1 = {}
    local n3 = 0

    for v16, v17 in Descendants do
        if isGateColorable(v17, v16 - 1, Descendants) == true then
            n3 += 1
            t1[n3] = v17
        end
    end

    return t1
end

local function applyGateGradient(p6, p7) -- line: 87
    -- upvalues: sampleFlightGateGradient (copy)
    local v19 = math.max(#p6 - 1, 1)

    for i = 0, #p6 - 1 do
        local v20 = sampleFlightGateGradient(p7, i / v19)
        local v21 = p6[i + 1]

        if v21:IsA("BasePart") then
            v21.Color = v20
        elseif v21:IsA("SpecialMesh") then
            v21.VertexColor = Vector3.new(v20.R, v20.G, v20.B)
        elseif v21:IsA("Beam") or v21:IsA("Trail") or v21:IsA("ParticleEmitter") then
            v21.Color = p7
        elseif v21:IsA("PointLight") or v21:IsA("SpotLight") or v21:IsA("SurfaceLight") then
            v21.Color = v20
        end
    end
end

return {
    FlightTriggerGateCourse = function(p8) -- FlightTriggerGateCourse | line: 105
        -- upvalues: react (copy), useEffect (copy), CollectionService (copy), ReplicatedStorage (copy), RunService (copy), Workspace (copy), hookHrpAtom (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightGateFXConfig (copy), getFishingBoundaryLimits (copy), playClonedVfxWithSound (copy), playClonedSound (copy), flightTriggerGateConfig (copy), flightTriggerGateRingMissed (copy), flightTriggerGateRingPassed (copy), flightTriggerGateRunEnded (copy), flightTriggerGateRunStarted (copy), flightTriggerGateStreakFailVersionAtom (copy), resolveZoneContaining (copy), createFlightGatePath (copy), planFlightGates (copy), projectedHalfExtent (copy), getFlightGateComboTier (copy), lerpFlightGateGradient (copy), getDetectableCrossing (copy), getGateColorables (copy), applyGateGradient (copy)
        useEffect(function() -- line: 106
            -- upvalues: p8 (copy), CollectionService (copy), ReplicatedStorage (copy), RunService (copy), Workspace (copy), hookHrpAtom (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightGateFXConfig (copy), getFishingBoundaryLimits (copy), playClonedVfxWithSound (copy), playClonedSound (copy), flightTriggerGateConfig (copy), flightTriggerGateRingMissed (copy), flightTriggerGateRingPassed (copy), flightTriggerGateRunEnded (copy), flightTriggerGateRunStarted (copy), flightTriggerGateStreakFailVersionAtom (copy), resolveZoneContaining (copy), createFlightGatePath (copy), planFlightGates (copy), projectedHalfExtent (copy), getFlightGateComboTier (copy), lerpFlightGateGradient (copy), getDetectableCrossing (copy), getGateColorables (copy), applyGateGradient (copy)
            print("[HoopDebug] FlightTriggerGateCourse effect started")

            local v22 = ReplicatedStorage:FindFirstChild(flightTriggerGateConfig.assetFolderName)

            if v22 ~= nil then
                v22 = v22:FindFirstChild(flightTriggerGateConfig.assetModelName)
            end

            if v22 and v22:IsA("Model") then
                local v23 = v22:FindFirstChild(flightTriggerGateConfig.detectableAreaName)

                if not (v23 and v23:IsA("BasePart")) then
                    warn("[HoopDebug] ABORT: FlightTriggerGate.DetectableArea BasePart is missing")

                    return nil
                end

                local t2 = {}

                for _, v24 in CollectionService:GetTagged("FishingZone") do
                    if v24:IsA("Model") then
                        local v25 = v24:FindFirstChild(flightTriggerGateConfig.detectableAreaName)
                        local zoneId = v24:GetAttribute("zoneId")

                        if (if v25 == nil then v25 else v25:IsA("BasePart")) and typeof(zoneId) == "string" then
                            table.insert(t2, {
                                zone = zoneId,
                                part = v25
                            })
                        end
                    end
                end

                local t4 = {}

                for _, v26 in CollectionService:GetTagged("FishingBoundary") do
                    if v26:IsA("BasePart") then
                        table.insert(t4, v26)
                    end
                end

                print(("[HoopDebug] source=%* detectable=ok "):format((v22:GetFullName())) .. ("taggedZones=%* "):format(#CollectionService:GetTagged("FishingZone")) .. ("resolvedZones=%* boundaries=%* "):format(#t2, #t4) .. ("startPosition=%* power=%*"):format(p8.startPosition, p8.power))

                if #t2 == 0 then
                    warn("[HoopDebug] WARNING: no FishingZone instances resolved — gates will have nothing to be placed relative to zone-wise (check Tag.FishingZone and zoneId attribute + DetectableArea child on each zone model)")
                end

                local v27 = createFlightGatePath(p8.startPosition, p8.direction, p8.power, p8.peakBias, p8.peakHeight, p8.drag, p8.isPerfect, p8.bounceInitialHeight, p8.bounceInitialDistance, p8.bounceDiminishFactor, p8.bounceGravity)

                flightTriggerGateComboAtom(0)

                local v29 = planFlightGates(v27, t2, t4, math.floor(os.clock() * 1000), v23)

                flightTriggerGateRunStarted:Fire(#v29)
                print(("[HoopDebug] planFlightGates returned %* placement(s) "):format(#v29) .. ("firstZone=%*"):format(flightTriggerGateConfig.firstZone))

                if #v29 == 0 then
                    warn("[HoopDebug] WARNING: 0 placements — no hoop models will be spawned this run (check zones resolved above, firstZone config, and boundary limits)")
                end

                if flightTriggerGateConfig.debugLogging then
                    local v30 = getFishingBoundaryLimits(t4, p8.startPosition, v27.right)
                    local v31 = if v30 then (v30.minOffset + v30.maxOffset) * 0.5 else 0
                    local v32 = ("[HoopDebug] start=%* right=%* "):format(p8.startPosition, v27.right) .. ("boundaries=%* limits=%* "):format(#t4, if v30 then ("%*,%*"):format(v30.minOffset, v30.maxOffset) else "undefined") .. ("dockCenterOffset=%* "):format(v31)
                    local v33 = v29[1]

                    if v33 ~= nil then
                        v33 = v33.offset
                    end

                    if v33 == nil then
                        v33 = "none"
                    end

                    print(v32 .. ("firstGate=%*"):format(v33))

                    for _, v34 in t4 do
                        print(("[HoopDebug] boundary=%* "):format((v34:GetFullName())) .. ("position=%* projectedAxis=%*"):format(v34.Position, (v34.Position:Dot(v27.right))))
                    end

                    for _, v35 in CollectionService:GetTagged("FishingArea") do
                        if v35:IsA("Model") then
                            local DetectableArea = v35:FindFirstChild("DetectableArea")

                            if if DetectableArea == nil then DetectableArea else DetectableArea:IsA("BasePart") then
                                local v36 = ("[HoopDebug] fishingAreaCenter=%* "):format(DetectableArea.Position)
                                local DetectableAreaPosition = DetectableArea.Position
                                local startPosition = p8.startPosition

                                print(v36 .. ("centerLateralOffset=%*"):format(((DetectableAreaPosition - startPosition):Dot(v27.right))))
                            end
                        end
                    end

                    local v37 = table.create(#t2)

                    local function v38(p9) -- line: 199
                        return {
                            zone = p9.zone,
                            part = p9.part
                        }
                    end

                    for v39, v40 in t2 do
                        local _ = v39 - 1

                        v37[v39] = {
                            zone = v40.zone,
                            part = v40.part
                        }
                    end

                    for _, v41 in v29 do
                        local v42 = resolveZoneContaining(v37, v41.sample.position)
                        local v43 = ("[HoopDebug] placement zone=%* "):format(v41.zone) .. ("distance=%* position=%* "):format(v41.sample.distance, v41.sample.position)

                        if v42 ~= nil then
                            v42 = v42.zone
                        end

                        if v42 == nil then
                            v42 = "none"
                        end

                        print(v43 .. ("contains=%*"):format(v42))
                    end
                end

                local Folder = Instance.new("Folder")

                Folder.Name = "LocalFlightTriggerGates"
                Folder.Parent = Workspace

                local t5 = {}
                local Pivot = v22:GetPivot()
                local Position = v23.Position
                local Scale = v22:GetScale()
                local n4 = 0
                local n5 = 1
                local n6 = 1
                local n7 = 1
                local v44 = flightGateFXConfig.combo.ringGradients.tier1
                local v45 = v44
                local v46 = false
                local n8 = 1
                local v47 = flightGateFXConfig.combo.ringLerpSpeed

                local function v48(p10) -- line: 240
                    -- upvalues: flightTriggerGateConfig (copy)
                    return 1 - math.clamp(p10 / math.max(flightTriggerGateConfig.comboToSmallestRingSize, 1), 0, 1) * (1 - math.clamp(flightTriggerGateConfig.smallestRingSizeScale, 0, 1))
                end

                local function v51(p11) -- line: 257
                    -- upvalues: t5 (copy), Scale (copy), n7 (ref)
                    if math.abs(p11 - n7) < 0.001 then
                        return nil
                    end

                    for _, v53 in t5 do
                        if not v53.passed and v53.model.Parent then
                            local areaPosition = v53.area.Position

                            v53.model:ScaleTo(Scale * p11)
                            v53.model:PivotTo(v53.model:GetPivot() + (areaPosition - v53.area.Position))
                        end
                    end

                    n7 = p11
                end

                local function v54(p12) -- line: 276
                    -- upvalues: t5 (copy), v44 (ref), v45 (ref), v46 (ref), n8 (ref), v47 (ref), lerpFlightGateGradient (copy), applyGateGradient (copy)
                    if not v46 then
                        return nil
                    end

                    local v56 = math.clamp(p12 * v47, 0, 1)
                    local v57 = n8

                    n8 = v57 + (1 - n8) * v56
                    v44 = lerpFlightGateGradient(v44, v45, v56)

                    for _, v58 in t5 do
                        if not v58.passed then
                            applyGateGradient(v58.colorables, v44)
                        end
                    end

                    if n8 >= 0.999 then
                        v44 = v45
                        v46 = false
                    end
                end

                local function v59(p13, p14) -- line: 293
                    -- upvalues: v45 (ref), v46 (ref), n8 (ref), v47 (ref), flightGateFXConfig (copy), playClonedSound (copy)
                    local v60 = flightGateFXConfig.combo.ringGradients[("tier%*"):format(p13)]

                    if v60 == v45 then
                        return nil
                    end

                    v45 = v60
                    v46 = true
                    n8 = 0
                    v47 = if p13 == 1 then 1 / flightGateFXConfig.combo.streakFailVFX.ringResetSeconds else flightGateFXConfig.combo.ringLerpSpeed

                    if p14 and p13 > 1 then
                        playClonedSound(if p13 == 2 then flightGateFXConfig.combo.tierSFX.tier2 else flightGateFXConfig.combo.tierSFX.tier3)
                    end
                end

                for _, v62 in v29 do
                    local clone = v22:Clone()
                    local v63 = clone:FindFirstChild(flightTriggerGateConfig.detectableAreaName)

                    if if v63 == nil then v63 else v63:IsA("BasePart") then
                        v63.CanCollide = false
                        v63.CanTouch = false
                        clone.Name = ("FlightTriggerGate_%*"):format(v62.zone)
                        clone:SetAttribute("Zone", v62.zone)
                        clone.Parent = Folder

                        local v64 = getGateColorables(clone)

                        clone:PivotTo(Pivot + (v62.sample.position - Position))
                        applyGateGradient(v64, v44)

                        local v65 = ("[HoopDebug] SPAWNED gate zone=%* name=%* "):format(v62.zone, clone.Name)
                        local Parent = clone.Parent

                        if Parent ~= nil then
                            Parent = Parent:GetFullName()
                        end

                        print(v65 .. ("parent=%* pivot=%* "):format(Parent, clone:GetPivot().Position) .. ("descendantCount=%*"):format(#clone:GetDescendants()))
                        table.insert(t5, {
                            passed = false,
                            model = clone,
                            area = v63,
                            colorables = v64,
                            distance = v62.sample.distance
                        })
                    else
                        warn(("[HoopDebug] SKIPPED gate zone=%* — cloned model has no "):format(v62.zone) .. "DetectableArea BasePart child")
                        clone:Destroy()
                    end
                end

                local v66 = ("[HoopDebug] spawn pass complete: %*/%* gates live "):format(#t5, #v29) .. ("under %* "):format((Folder:GetFullName()))
                local FolderParent = Folder.Parent

                if FolderParent ~= nil then
                    FolderParent = FolderParent:GetFullName()
                end

                if FolderParent == nil then
                    FolderParent = "nil"
                end

                print(v66 .. ("(container.Parent=%*)"):format(FolderParent))

                local v67 = hookHrpAtom()

                if v67 ~= nil then
                    v67 = v67.Position
                end

                local v68 = v67
                local v69 = hookFlightSteeringActiveAtom()
                local v70 = v69
                local v71 = false
                local n9 = 0

                print(("[HoopDebug] initial hook=%* "):format(hookHrpAtom() and "present" or "nil") .. ("flightActive=%*"):format(v69))

                local connection

                connection = RunService.Heartbeat:Connect(function(p15) -- line: 376
                    -- upvalues: v27 (copy), Folder (copy), t5 (copy), n4 (ref), n5 (ref), n6 (ref), v45 (ref), v46 (ref), n8 (ref), v47 (ref), v51 (copy), v54 (copy), v59 (copy), v68 (ref), v70 (ref), v71 (ref), n9 (ref), connection (ref), p8 (copy), hookHrpAtom (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGateComboAtom (copy), flightGateFXConfig (copy), playClonedVfxWithSound (copy), flightTriggerGateConfig (copy), flightTriggerGateRingMissed (copy), flightTriggerGateRingPassed (copy), flightTriggerGateRunEnded (copy), flightTriggerGateStreakFailVersionAtom (copy), projectedHalfExtent (copy), getFlightGateComboTier (copy), getDetectableCrossing (copy)
                    n9 += 1

                    local v72 = hookHrpAtom()

                    if not (v72 and v72.Parent) then
                        if n9 <= 3 or n9 % 60 == 0 then
                            warn((("[HoopDebug] tick=%* hookHrpAtom is %* — gate pass/miss detection cannot run"):format(n9, v72 and "present but unparented" or "nil")))
                        end

                        return nil
                    end

                    if hookFlightSteeringActiveAtom() then
                        v70 = true
                    elseif v70 then
                        print(("[HoopDebug] tick=%* DESTROYING course — flightActive went "):format(n9) .. ("false after being observed true (gates=%*)"):format(#t5))

                        if not v71 then
                            v71 = true
                            flightTriggerGateRunEnded:Fire()
                        end

                        for _, v74 in t5 do
                            v74.model:Destroy()
                        end

                        Folder:Destroy()
                        connection:Disconnect()

                        return nil
                    end

                    local v76 = math.clamp(p15 * flightGateFXConfig.ringScaleLerpSpeed, 0, 1)

                    n5 += (n6 - n5) * v76

                    local v80 = n6

                    if math.abs(v80 - n5) < 1E-04 then
                        n5 = n6
                    end

                    v51(n5)
                    v54(p15)

                    local Position = v72.Position

                    if v68 then
                        local v81 = (Position - p8.startPosition):Dot(v27.forward)

                        for _, v82 in t5 do
                            if v82.model.Parent and not v82.passed then
                                if getDetectableCrossing(v68, Position, v82.area) ~= nil then
                                    v82.passed = true
                                    v82.model:SetAttribute("Passed", true)
                                    n4 += 1
                                    flightTriggerGateComboAtom(n4)
                                    v59(getFlightGateComboTier(n4), true)
                                    flightTriggerGateRingPassed:Fire()

                                    local v88 = n4

                                    n6 = 1 - math.clamp(v88 / math.max(flightTriggerGateConfig.comboToSmallestRingSize, 1), 0, 1) * (1 - math.clamp(flightTriggerGateConfig.smallestRingSizeScale, 0, 1))
                                    playClonedVfxWithSound(flightTriggerGateConfig.passVfxName, flightTriggerGateConfig.passSfxName, {
                                        lifetimeSeconds = flightTriggerGateConfig.passVfxDuration,
                                        soundPlaybackSpeed = math.min(flightGateFXConfig.combo.passSfxMaxPitch, 1 + math.max(n4 - 1, 0) * flightGateFXConfig.combo.passSfxPitchUpStep),
                                        targetPart = v72
                                    })
                                    v82.model:Destroy()
                                elseif v82.distance + projectedHalfExtent(v82.area, v27.forward) + flightTriggerGateConfig.detectorPadding <= v81 then
                                    v82.passed = true

                                    local v83 = n4 > 0

                                    n4 = 0
                                    flightTriggerGateComboAtom(0)
                                    flightTriggerGateRingMissed:Fire()

                                    local v84 = flightGateFXConfig.combo.ringGradients[("tier%*"):format(1)]

                                    if v84 ~= v45 then
                                        v45 = v84
                                        v46 = true
                                        n8 = 0
                                        v47 = 1 / flightGateFXConfig.combo.streakFailVFX.ringResetSeconds
                                    end

                                    if v83 then
                                        flightTriggerGateStreakFailVersionAtom(function(p16) -- line: 438
                                            return p16 + 1
                                        end)
                                    end

                                    local v85 = n4

                                    n6 = 1 - math.clamp(v85 / math.max(flightTriggerGateConfig.comboToSmallestRingSize, 1), 0, 1) * (1 - math.clamp(flightTriggerGateConfig.smallestRingSizeScale, 0, 1))

                                    if flightTriggerGateConfig.debugLogging then
                                        print(("[HoopDebug] missed gate distance=%* "):format(v82.distance) .. "combo reset to 0")
                                    end

                                    v82.model:Destroy()
                                end
                            end
                        end
                    end

                    v68 = Position
                end)

                return function() -- line: 452
                    -- upvalues: Folder (copy), v71 (ref), connection (ref), flightTriggerGateComboAtom (copy), flightTriggerGateRunEnded (copy)
                    if not v71 then
                        v71 = true
                        flightTriggerGateRunEnded:Fire()
                    end

                    connection:Disconnect()
                    Folder:Destroy()
                    flightTriggerGateComboAtom(0)
                end
            end

            warn("[HoopDebug] ABORT: ReplicatedStorage.SubwaySurf.FlightTriggerGate Model is missing")

            return nil
        end, {
            p8.direction,
            p8.power,
            p8.startPosition,
            p8.peakBias,
            p8.peakHeight
        })

        return react.createElement(react.Fragment)
    end
}
