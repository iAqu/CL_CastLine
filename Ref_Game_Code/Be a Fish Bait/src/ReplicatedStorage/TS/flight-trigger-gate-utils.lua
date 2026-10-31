-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local bounceCount, castDuration, castEndYFromPower, castLaunchSpeedFromPower = v1.bounceCount, v1.castDuration, v1.castEndYFromPower, v1.castLaunchSpeedFromPower
local castDistanceFromPower, bounceInitialDistanceFromSpeed, computeArcOffset, computeBounceDistances = v1.castDistanceFromPower, v1.bounceInitialDistanceFromSpeed, v1.computeArcOffset, v1.computeBounceDistances
local defaultBounceDiminishFactor, defaultBounceGravity, defaultBounceInitialHeight, drag = v1.defaultBounceDiminishFactor, v1.defaultBounceGravity, v1.defaultBounceInitialHeight, v1.drag
local findVisualTWater, waterSurfaceY = v1.findVisualTWater, v1.waterSurfaceY
local getFishingZoneIndex = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils").getFishingZoneIndex
local getFishingBoundaryLimits = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-boundary-utils").getFishingBoundaryLimits
local flightTriggerGateConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-trigger-gate-config").flightTriggerGateConfig
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-steering-utils")
local getCastRightDirection, flightSteeringMaxSpeed, remapFlightSteeringInput = v2.getCastRightDirection, v2.flightSteeringMaxSpeed, v2.remapFlightSteeringInput
local t1 = {}

t1.flightTriggerGateConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-trigger-gate-config").flightTriggerGateConfig

local function formatGateDebugNumber(p1, p2) -- line: 27
    local v3 = 10 ^ p2

    return (tostring(math.floor(p1 * v3 + 0.5) / v3))
end

local function createFlightGatePath(p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) -- line: 31
    -- upvalues: bounceCount (copy), castDuration (copy), castEndYFromPower (copy), castLaunchSpeedFromPower (copy), castDistanceFromPower (copy), bounceInitialDistanceFromSpeed (copy), computeBounceDistances (copy), defaultBounceDiminishFactor (copy), defaultBounceGravity (copy), defaultBounceInitialHeight (copy), drag (copy), findVisualTWater (copy), waterSurfaceY (copy), getCastRightDirection (copy)
    local v6 = p10
    local v7 = p12
    local v8 = p13
    local v9 = if p8 == nil then drag else p8
    local v10 = p9 ~= nil and p9

    if p10 == nil then
        v6 = defaultBounceInitialHeight
    end

    local v11 = p12

    if p12 == nil then
        v11 = defaultBounceDiminishFactor
        v7 = defaultBounceDiminishFactor
    end

    if p13 == nil then
        v8 = defaultBounceGravity
    end

    local Unit = Vector3.new(p4.X, 0, p4.Z).Unit
    local v12 = getCastRightDirection(p4)
    local v13 = castLaunchSpeedFromPower(p5)
    local v14 = castDuration(p5)
    local v15 = castEndYFromPower(p5)
    local v16 = findVisualTWater(p3.Y, v15, waterSurfaceY, v9, p7, p6)
    local v17 = v16 + (1 - v16) / math.max(v9, 0.001)
    local v18 = castDistanceFromPower(p5)
    local v20 = computeBounceDistances((if p11 == nil then bounceInitialDistanceFromSpeed(v13) else p11) * (if v10 then 1.3 else 1), bounceCount, v11)
    local v21 = table.create(#v20)

    for v22, _ in v20 do
        local v23 = v22 - 1

        v21[v22] = math.sqrt(2 * v6 * v7 ^ v23 / v8) * 2
    end

    return {
        start = p3,
        forward = Unit,
        right = v12,
        power = p5,
        drag = v9,
        isPerfect = v10,
        bounceInitialDistance = p11,
        bounceDiminishFactor = v7,
        bounceGravity = v8,
        initialDistance = v18 * v16 / v17,
        initialDuration = v14,
        tWater = v16,
        scaledDistance = v18 / v17,
        maxProgress = v17,
        scaledDY = (v15 - p3.Y) / v17,
        peakHeight = p7,
        peakBias = p6,
        bounceDistances = v20,
        bounceDurations = v21,
        bounceHeight = v6
    }
end

local function maxAirDistanceForPower(p14, p15) -- line: 94
    -- upvalues: bounceCount (copy), castEndYFromPower (copy), castLaunchSpeedFromPower (copy), castDistanceFromPower (copy), bounceInitialDistanceFromSpeed (copy), computeBounceDistances (copy), findVisualTWater (copy), waterSurfaceY (copy)
    local v25 = castLaunchSpeedFromPower(p15)
    local v26 = castEndYFromPower(p15)
    local v27 = findVisualTWater(p14.start.Y, v26, waterSurfaceY, p14.drag, p14.peakHeight, p14.peakBias)
    local v29 = v27 + (1 - v27) / math.max(p14.drag, 0.001)
    local v30 = castDistanceFromPower(p15) * v27 / v29
    local bounceInitialDistance = p14.bounceInitialDistance

    if bounceInitialDistance == nil then
        bounceInitialDistance = bounceInitialDistanceFromSpeed(v25)
    end

    local v32 = computeBounceDistances(bounceInitialDistance * (if p14.isPerfect then 1.3 else 1), bounceCount, p14.bounceDiminishFactor)

    local function v33(p16, p17) -- line: 109
        return p16 + p17
    end

    local n1 = 0

    for i = 1, #v32 do
        local v35 = v32[i]
        local _ = i - 1

        n1 += v35
    end

    return v30 + n1
end

local zoneForwardInterval

local function canFlightTriggerGatePathReachMinimumZone(p18, p19) -- line: 119
    -- upvalues: flightTriggerGateConfig (copy), maxAirDistanceForPower (copy), zoneForwardInterval (ref)
    local n2 = 1e999
    local v36

    for _, v37 in p19 do
        if v37.zone == flightTriggerGateConfig.minPowerZoneGate then
            local v39 = math.max(0, zoneForwardInterval(v37.part, p18.start, p18.forward)[1])

            if v39 < n2 then
                n2 = v39
                v36 = v37
            end
        end
    end

    if v36 then
        return n2 <= maxAirDistanceForPower(p18, p18.power)
    end

    return false
end

local function sampleFlightGatePath(p20, p21) -- line: 140
    -- upvalues: computeArcOffset (copy), waterSurfaceY (copy), sampleFlightGatePath (copy)
    local bounceDistances = p20.bounceDistances

    local function v40(p22, p23) -- line: 144
        return p22 + p23
    end

    local n3 = 0

    for i = 1, #bounceDistances do
        local v42 = bounceDistances[i]
        local _ = i - 1

        n3 += v42
    end

    local v43 = p20.initialDistance + n3
    local v44 = math.max(p21, 0)

    if v43 < v44 then
        local v45 = sampleFlightGatePath(p20, v43)
        local v46 = v44 - v43
        local v48 = math.max(p20.scaledDistance / math.max(p20.initialDuration, 0.001), 1)
        local t2 = {
            distance = v44,
            time = v45.time + v46 / v48
        }

        t2.position = v45.position + p20.forward * v46

        return t2
    end

    if v44 <= p20.initialDistance or n3 <= 0 then
        local v49 = if p20.scaledDistance > 0 then v44 / p20.scaledDistance else 0
        local v50 = p20.start.Y + p20.scaledDY * v49 + computeArcOffset(v49 / p20.maxProgress, p20.peakHeight, p20.peakBias)
        local t3 = {
            distance = v44,
            time = p20.initialDuration * (if p20.tWater > 0 then v49 / p20.tWater else 0)
        }
        local start = p20.start
        local v51 = p20.forward * v44
        local v53 = Vector3.new(0, v50 - p20.start.Y, 0)

        t3.position = start + v51 + v53

        return t3
    end

    local v54 = v44 - p20.initialDistance
    local v55 = p20.initialDistance
    local v56 = p20.initialDuration * p20.tWater

    for i = 0, #p20.bounceDistances - 1 do
        local v57 = p20.bounceDistances[i + 1]
        local v58 = if v57 > 0 then math.clamp(v54 / v57, 0, 1) else 1
        local v60 = p20.bounceHeight * 0.5 ^ i * 4 * v58 * (1 - v58)

        if v54 <= v57 then
            local t4 = {
                distance = v44,
                time = v56 + p20.bounceDurations[i + 1] * v58
            }
            local start, forward = p20.start, p20.forward
            local v61 = v55 + v57 * v58
            local v63 = Vector3.new(0, waterSurfaceY + v60 - p20.start.Y, 0)

            t4.position = start + forward * v61 + v63

            return t4
        end

        v54 -= v57
        v55 += v57
        v56 += p20.bounceDurations[i + 1]
    end

    local t5 = {
        distance = v44,
        time = v56
    }
    local start = p20.start
    local v64 = p20.forward * v44
    local v66 = Vector3.new(0, waterSurfaceY - p20.start.Y, 0)

    t5.position = start + v64 + v66

    return t5
end

local function lateralReach(p24, p25) -- line: 220
    -- upvalues: flightSteeringMaxSpeed (copy), remapFlightSteeringInput (copy)
    return math.max(p24, 0) * remapFlightSteeringInput(p25) * flightSteeringMaxSpeed
end

local function reachableGateDelta(p26, p27, _) -- line: 223
    -- upvalues: flightTriggerGateConfig (copy), flightSteeringMaxSpeed (copy), remapFlightSteeringInput (copy)
    local v67 = if p27 < 0 then -1 else 1

    return (math.max(0, math.abs(math.max(p26, 0) * remapFlightSteeringInput(v67) * flightSteeringMaxSpeed) - flightTriggerGateConfig.lateralLeeway))
end

function zoneForwardInterval(p29, p30, p31) -- line: 229
    local v70 = p29.Size * 0.5
    local t6 = {
        Vector3.new(-v70.X, 0, -v70.Z),
        Vector3.new(-v70.X, 0, v70.Z),
        Vector3.new(v70.X, 0, -v70.Z),
        (Vector3.new(v70.X, 0, v70.Z))
    }
    local v78 = table.create(#t6)

    for v79, v80 in t6 do
        local _ = v79 - 1

        v78[v79] = (p29.CFrame:PointToWorldSpace(v80) - p30):Dot(p31)
    end

    return {
        math.min(unpack(v78)),
        (math.max(unpack(v78)))
    }
end

local function projectedHalfExtent(p32, p33) -- line: 247
    local v82 = if p33.Magnitude > 0 then p33.Unit else Vector3.new(1, 0, 0)

    return math.abs((v82:Dot(p32.CFrame.RightVector))) * p32.Size.X * 0.5 + math.abs((v82:Dot(p32.CFrame.UpVector))) * p32.Size.Y * 0.5 + math.abs((v82:Dot(p32.CFrame.LookVector))) * p32.Size.Z * 0.5
end

local function planFlightGates(p34, p35, p36, p37, p38) -- line: 251
    -- upvalues: getFishingZoneIndex (copy), getFishingBoundaryLimits (copy), flightTriggerGateConfig (copy), flightSteeringMaxSpeed (copy), remapFlightSteeringInput (copy), zoneForwardInterval (ref), sampleFlightGatePath (copy), projectedHalfExtent (copy)
    local v88 = getFishingBoundaryLimits(p36, p34.start, p34.right)
    local v89 = getFishingZoneIndex(flightTriggerGateConfig.firstZone)
    local t7 = {}
    local n4 = 0
    local v90

    for v91, v92 in p35 do
        v90 = v91 - 1

        if v89 <= getFishingZoneIndex(v92.zone) == true then
            n4 += 1
            t7[n4] = v92
        end
    end

    n4 = table.create(#t7)

    local v93

    for v94, v95 in t7 do
        v90 = v94 - 1
        v90 = zoneForwardInterval(v95.part, p34.start, p34.forward)

        local v96 = table.clone(v95)

        setmetatable(v96, nil)
        v93 = v90[1] + (v90[2] - v90[1]) * flightTriggerGateConfig.zonePositionAlpha
        v96.forwardDistance = math.max(0, v93)
        n4[v94] = v96
    end

    table.sort(n4, function(p39, p40) -- line: 282
        return p39.forwardDistance < p40.forwardDistance
    end)

    local v97 = Random.new(p37)
    local t8 = {}
    local v98, bounceDistances = p34.initialDistance, p34.bounceDistances

    local function v99(p41, p42) -- line: 292
        return p41 + p42
    end

    local v100 = #bounceDistances
    local n5 = 0

    for i = 1, v100 do
        local v101 = bounceDistances[i]

        v93 = i - 1
        n5 += v101
    end

    v99 = v98 + n5

    local v103 = math.clamp(flightTriggerGateConfig.smallestRingSizeScale, 0, 1)

    v100 = projectedHalfExtent(p38, p34.right)
    v98 = v100 * v103

    local v102 = 1e999

    if v88 then
        n5 = (v88.minOffset + v88.maxOffset) * 0.5
        v103 = n5 - v88.minOffset - flightTriggerGateConfig.boundaryPadding
        v102 = v88.maxOffset - n5 - flightTriggerGateConfig.boundaryPadding
    else
        n5 = 0
        v103 = 1e999
    end

    local n6 = 0
    local forwardDistance, v104, time

    for _, v105 in n4 do
        forwardDistance = v105.forwardDistance
        v104 = sampleFlightGatePath(p34, forwardDistance)
        time = v104.time

        local v107 = time - (if #t8 > 0 then t8[#t8].sample.time else 0)
        local v106 = if v97:NextInteger(0, 1) == 0 then -1 else 1

        if #t8 == 0 then
        end

        local v108 = if v106 < 0 then -1 else 1
        local v111 = math.max(0, math.abs(math.max(v107, 0) * remapFlightSteeringInput(v108) * flightSteeringMaxSpeed) - flightTriggerGateConfig.lateralLeeway)
        local v112

        if #t8 == 0 then
            v108 = n5
            v112 = 0
        else
            v108 = n6
            v112 = n6
        end

        local v114 = math.min(math.abs(v111), (math.max(0, flightTriggerGateConfig.gateOffsetMax)))
        local v115 = math.min(v114, (math.max(0, flightTriggerGateConfig.gateOffsetMin)))
        local v113 = v108 - n5
        local v110 = {
            v112 - v111 - v98,
            v112 + v111 + v98
        }

        if v88 then
            v112 = {
                v88.minOffset + flightTriggerGateConfig.boundaryPadding + v100,
                v88.maxOffset - flightTriggerGateConfig.boundaryPadding - v100
            }
        else
            v112 = { (-1e999), 1e999 }
        end

        local v116 = v110[1]
        local v109 = math.max(v116, v112[1], v108 - v114)
        local v117 = v110[2]
        local v118 = v112[2]
        local v119 = v108 + v114
        local t9 = {
            v109,
            (math.min(v117, v118, v119))
        }

        if not (t9[1] > t9[2]) then
            v117 = v113 + v103

            local v120 = math.max(0, v117)

            v117 = v102 - v113

            local v121 = math.max(0, v117)
            local v122, _print

            if v88 and math.abs(v113) > flightTriggerGateConfig.sideWeightingDeadzone then
                v116 = math.min(v120, v121)
                v117 = math.max(v120, v121)
                v118 = if v117 > 0 then (v117 - v116) / v117 else 1
                n6 = flightTriggerGateConfig.sideWeightingMaxBiasWallDistance - v116
                _print = flightTriggerGateConfig.sideWeightingMaxBiasWallDistance
                v122 = n6 / math.max(_print, 0.001)
                v119 = math.clamp(v122, 0, 1)
                v119 = math.max(v118, v119)
                v118 = 0.5 - (0.5 - flightTriggerGateConfig.sideWeightingMinimumChance) * v119

                if v120 < v121 then
                    v109 = 1 - v118
                elseif v121 < v120 then
                    v118, v109 = 1 - v118, v118
                else
                    v118 = 0.5
                    v109 = 0.5
                end
            else
                v118 = 0.5
                v109 = 0.5
            end

            v117 = t9[1] - n5
            v119 = t9[2] - n5
            v116 = {
                v117,
                (math.min(v119, v113 - v115))
            }
            v119 = t9[1] - n5
            v117 = {
                math.max(v119, v113 + v115),
                t9[2] - n5
            }

            local v123 = v116[1] <= v116[2]

            v119 = v117[1] <= v117[2]
            n6 = if v97:NextNumber() <= v118 then -1 else 1

            local v124

            if n6 < 0 then
                if v123 then
                    v124 = v116[1] + v97:NextNumber() * (v116[2] - v116[1])
                elseif (n6 > 0 or v119) and v119 then
                    v124 = v117[1] + v97:NextNumber() * (v117[2] - v117[1])
                else
                    _print = {
                        t9[1] - n5,
                        t9[2] - n5
                    }
                    v124 = _print[1] + v97:NextNumber() * (_print[2] - _print[1])
                end
            elseif n6 > 0 then
                if v119 then
                    v124 = v117[1] + v97:NextNumber() * (v117[2] - v117[1])
                elseif v123 then
                    v124 = v116[1] + v97:NextNumber() * (v116[2] - v116[1])
                else
                    _print = {
                        t9[1] - n5,
                        t9[2] - n5
                    }
                    v124 = _print[1] + v97:NextNumber() * (_print[2] - _print[1])
                end
            elseif v123 then
                v124 = v116[1] + v97:NextNumber() * (v116[2] - v116[1])
            elseif v119 then
                v124 = v117[1] + v97:NextNumber() * (v117[2] - v117[1])
            else
                _print = {
                    t9[1] - n5,
                    t9[2] - n5
                }
                v124 = _print[1] + v97:NextNumber() * (_print[2] - _print[1])
            end

            n6 = n5 + v124

            if flightTriggerGateConfig.debugLogging then
                _print = print
                _print(("[HoopDebug] zone=%* reference=%* "):format(v105.zone, (tostring(math.floor(v113 * 100 + 0.5) / 100))) .. ("elapsed=%*s reach=%* "):format(tostring(math.floor(v107 * 1000 + 0.5) / 1000), (tostring(math.floor(v111 * 100 + 0.5) / 100))) .. ("leeway=%* "):format((tostring(math.floor(flightTriggerGateConfig.lateralLeeway * 100 + 0.5) / 100))) .. ("effectiveOffset=[%*,%*] "):format(tostring(math.floor(v115 * 100 + 0.5) / 100), (tostring(math.floor(v114 * 100 + 0.5) / 100))) .. ("allowance=[L:%* R:%*] "):format(tostring(math.floor(v120 * 100 + 0.5) / 100), (tostring(math.floor(v121 * 100 + 0.5) / 100))) .. ("spawn=%* centerRelative=%* "):format(tostring(math.floor(n6 * 100 + 0.5) / 100), (tostring(math.floor(v124 * 100 + 0.5) / 100))) .. ("forcedBeyondAir=%* "):format(v99 < forwardDistance) .. ("smallestRingHalfExtent=%* "):format((tostring(math.floor(v98 * 100 + 0.5) / 100))) .. ("[L: %*%% - R: %*%%]"):format(tostring(math.floor(v118 * 100 * 10 + 0.5) / 10), (tostring(math.floor(v109 * 100 * 10 + 0.5) / 10))))
            end

            v124 = {
                zone = v105.zone,
                offset = n6
            }
            _print = table.clone(v104)
            setmetatable(_print, nil)
            _print.position = v104.position + p34.right * n6
            v124.sample = _print
            table.insert(t8, v124)
        end
    end

    v90 = t8[1]

    if v90 ~= nil then
        v90 = v90.sample.position.Y
    end

    if v90 ~= nil then
        for _, v142 in t8 do
            if not (v142.sample.distance <= v99) then
                local position = v142.sample.position

                forwardDistance = table.clone(v142.sample)
                setmetatable(forwardDistance, nil)
                v104 = position.X
                time = position.Z
                forwardDistance.position = Vector3.new(v104, v90, time)
                v142.sample = forwardDistance
            end
        end
    end

    return t8
end

t1.createFlightGatePath = createFlightGatePath
t1.canFlightTriggerGatePathReachMinimumZone = canFlightTriggerGatePathReachMinimumZone
t1.sampleFlightGatePath = sampleFlightGatePath
t1.reachableGateDelta = reachableGateDelta
t1.projectedHalfExtent = projectedHalfExtent
t1.planFlightGates = planFlightGates

return t1
