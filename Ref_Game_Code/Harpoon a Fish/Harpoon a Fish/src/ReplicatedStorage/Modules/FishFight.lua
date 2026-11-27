-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    MAX_VERTICAL_COMPONENT = 0.45,
    CATCH_DISTANCE = 2.5,
    TUG_TIME = 0.3,
    TUG_TIME_HOME = 0.35,
    FOLLOW_RESPONSIVENESS = 18,
    TUG_RESPONSIVENESS = 60,
    ROT_RESPONSIVENESS = 7,
    LINE_DRIFT = 6,
    PANIC_SPEED_GAIN = 0.5,
    PANIC_RATE_GAIN = 0.3,
    DART_TIME = { 0.55, 1.1 },
    DART_SPEED = { 22, 30 },
    FIGHT_TURN = 5,
    PANIC_DRIFT_GAIN = 1,
    ClampVerticalTo = function(p1, p2) -- ClampVerticalTo | line: 33
        local v2 = math.clamp(p1.Y, -p2, p2)
        local v3 = Vector3.new(p1.X, 0, p1.Z)

        if v3.Magnitude < 0.001 then
            v3 = Vector3.new(1, 0, 0)
        end

        local v6 = v3.Unit * math.sqrt((math.max(0, 1 - v2 * v2)))

        return Vector3.new(v6.X, v2, v6.Z).Unit
    end
}

function t1.ClampVertical(p3) -- line: 41
    -- upvalues: t1 (copy)
    return t1.ClampVerticalTo(p3, t1.MAX_VERTICAL_COMPONENT)
end

function t1.Orient(p4, p5, p6, p7) -- line: 46
    local Unit = (Vector3.new(0, 1, 0) - p5 * (Vector3.new(0, 1, 0)):Dot(p5)).Unit
    local v7 = CFrame.fromMatrix(Vector3.new(0, 0, 0), p5, Unit)

    if p7 and p7 ~= 0 then
        v7 *= CFrame.Angles(p7, 0, 0)
    end

    return CFrame.new(p4) * (v7 * p6)
end

function t1.Face(p8, p9) -- line: 58
    if not p9 then
        return p8
    end

    local v8 = Vector3.new(p8.X, 0, p8.Z)

    if v8.Magnitude <= 0.001 then
        return p8
    end

    local v10 = math.asin((math.clamp(p8.Y, -1, 1))) + p9

    return (v8.Unit * math.cos(v10) + Vector3.new(0, 1, 0) * math.sin(v10)).Unit
end

function t1.ClampPos(p10, p11, p12) -- line: 68
    local box = p10.box

    if box then
        local v11 = box.cf:PointToObjectSpace(p11)
        local v18 = Vector3.new(math.clamp(v11.X, -box.half.X, box.half.X), math.clamp(v11.Y, -box.half.Y, box.half.Y), (math.clamp(v11.Z, -box.half.Z, box.half.Z)))

        return box.cf:PointToWorldSpace(v18)
    end

    local v19 = p10.zoneBand or p12

    return (Vector3.new(p11.X, math.clamp(p11.Y, v19.yMin, v19.yMax), p11.Z))
end

function t1.RollDart(p13, p14, p15, p16) -- line: 85
    -- upvalues: t1 (copy)
    local v21 = p14:Cross((Vector3.new(0, 1, 0)))

    p13.dartDir = ((v21.Magnitude > 1E-04 and v21.Unit or Vector3.new(0, 0, 1)) * (p16:NextNumber() < 0.5 and 1 or -1) + Vector3.new(0, 1, 0) * p16:NextNumber(-0.7, 0.7) - p14 * p16:NextNumber(-0.2, 0.6)).Unit
    p13.dartT = p16:NextNumber(t1.DART_TIME[1], t1.DART_TIME[2]) * (1 - t1.PANIC_RATE_GAIN * p15)
    p13.speed = p16:NextNumber(t1.DART_SPEED[1], t1.DART_SPEED[2]) * (1 + t1.PANIC_SPEED_GAIN * p15) * (p13.scale or 1)
end

local v22

function t1.FightStep(p17, p18, p19, p20) -- line: 107
    -- upvalues: v22 (ref)
    if not v22 then
        local t2 = {}

        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name:match("^Zone%dWall$") or child.Name == "Seabed" or child.Name == "Zone5BottomRocks" then
                t2[#t2 + 1] = child
            end
        end

        v22 = RaycastParams.new()
        v22.FilterType = Enum.RaycastFilterType.Include
        v22.FilterDescendantsInstances = t2
        v22.IgnoreWater = true
    end

    local v24 = p20 - p19
    local Magnitude = v24.Magnitude

    if Magnitude < 1E-04 then
        return p20
    end

    local v25 = v24 / Magnitude
    local v27 = math.min(p17.reach or 3, 12)
    local v28 = workspace:Raycast(p19, v25 * (Magnitude + v27), v22)

    if not v28 then
        return p20
    end

    local Normal = v28.Normal
    local v29 = p18.dartDir or v25

    p18.dartDir = (v29 - 2 * v29:Dot(Normal) * Normal).Unit
    p18.heading = p18.dartDir

    return p19 + v25 * math.max(0, v28.Distance - v27)
end

function t1.SteerFight(p21, p22) -- line: 134
    -- upvalues: t1 (copy)
    local v31 = p21.heading or p21.dartDir
    local v34 = math.acos((math.clamp(v31:Dot(p21.dartDir), -1, 1)))

    if v34 > 0.001 then
        local v35 = v31:Cross(p21.dartDir)
        local v36 = v35.Magnitude > 1E-04 and v35.Unit or Vector3.new(0, 1, 0)

        v31 = (CFrame.fromAxisAngle(v36, (math.min(v34, t1.FIGHT_TURN * p22))) * v31).Unit
    end

    p21.heading = v31

    return v31
end

function t1.OrbitPath(p23, p24) -- line: 154
    local orbit = p23.orbit
    local v40 = Vector3.new(p23.pos.X - orbit.c.X, 0, p23.pos.Z - orbit.c.Z)
    local v41 = math.max(v40.Magnitude, 0.001)
    local v42 = v40 / v41
    local v44 = Vector3.new(-v42.Z, 0, v42.X)

    if not orbit.sgn then
        orbit.sgn = p23.dir and p23.dir:Dot(v44) < 0 and -1 or 1
    end

    local v45 = math.atan2(v40.Z, v40.X) + orbit.sgn * (orbit.speed or 30) * p24 / v41
    local v48 = Vector3.new(orbit.c.X + math.cos(v45) * v41, p23.pos.Y, orbit.c.Z + math.sin(v45) * v41)
    local v49 = v48 - p23.pos
    local Unit = v49.Magnitude > 1E-04 and v49.Unit or v44 * orbit.sgn

    p23.pos = v48
    p23.dir = Unit

    return Unit
end

function t1.Struggle(p25, p26, p27, p28, p29) -- line: 173
    -- upvalues: t1 (copy)
    if p25.orbit then
        return t1.OrbitPath(p25, p26)
    end

    local v50 = p27 - p25.pos
    local Magnitude = v50.Magnitude
    local v51 = v50 / Magnitude
    local fight = p25.fight
    local v52

    if fight then
        v52 = fight
    else
        local v53 = v51:Cross((Vector3.new(0, 1, 0)))
        local v54 = v53.Magnitude > 1E-04 and v53.Unit or Vector3.new(0, 0, 1)

        v52 = {
            dartT = 0.3,
            lineLen = Magnitude
        }
        v52.dartDir = (Vector3.new(0, 1.2, 0) - v51 * 0.4 + v54 * (p28:NextNumber() < 0.5 and 0.6 or -0.6)).Unit
        v52.scale = p25.fightScale
        v52.speed = 44 * (p25.fightScale or 1)
        p25.fight = v52
    end

    local reelSched = p25.reelSched
    local v55 = reelSched and math.clamp(reelSched.done / reelSched.total, 0, 1) or 0

    if p25.driftCap then
        v52.lineLen = math.min(v52.lineLen + t1.LINE_DRIFT * (1 + t1.PANIC_DRIFT_GAIN * v55) * p26, p25.driftCap)
    end

    v52.dartT -= p26

    if v52.dartT <= 0 then
        t1.RollDart(v52, v51, v55, p28)
    end

    local v58 = t1.SteerFight(v52, p26)
    local v59 = p25.pos + v58 * v52.speed * p26
    local v60 = v59 - p27
    local Magnitude2 = v60.Magnitude

    if Magnitude2 > 0.1 then
        v59 -= v60.Unit * (Magnitude2 - v52.lineLen) * math.min(1, p26 * 5)
    end

    p25.pos = t1.FightStep(p25, v52, p25.pos, p29(p25, v59))
    p25.dir = v58

    return v58
end

function t1.Tug(p30, p31, p32) -- line: 227
    -- upvalues: t1 (copy)
    local reelSched = p30.reelSched

    if not reelSched then
        reelSched = {
            base = p32,
            total = p31 + 1
        }
        p30.reelSched = reelSched
    end

    reelSched.done = reelSched.total - p31

    local v63 = p31 > 0 and math.min(p32, (math.max(t1.CATCH_DISTANCE + 2, reelSched.base * p31 / reelSched.total))) or 0

    p30.tug = {
        t = 0,
        time = p31 > 0 and t1.TUG_TIME or t1.TUG_TIME_HOME,
        startDist = p32,
        endDist = v63
    }
    p30.hookMode = "tug"
    p30.fight = nil
end

function t1.TugStep(p33, p34, p35) -- line: 250
    -- upvalues: t1 (copy)
    local tug = p33.tug

    if not (p33.orbit and tug.endDist > 0) then
        local v67 = p35 - p33.pos
        local Magnitude = v67.Magnitude

        tug.t += p34

        local v69 = math.min(1, tug.t / tug.time)
        local v70 = tug.endDist > 0 and 1 - (1 - v69) ^ 3 or v69 * v69
        local v71 = tug.startDist + (tug.endDist - tug.startDist) * v70
        local v72 = Magnitude > 0.001 and v67 / Magnitude or p33.dir

        p33.pos = p35 - v72 * v71

        if not (v69 >= 1 and tug.endDist > 0) then
            return -v72, false
        end

        p33.hookMode = "struggle"
        p33.driftCap = tug.startDist
        p33.fight = nil
        p33.tug = nil

        return -v72, true
    end

    tug.t += p34

    local v73 = t1.OrbitPath(p33, p34)

    if not (tug.t >= tug.time) then
        return v73, false
    end

    p33.hookMode = "struggle"
    p33.driftCap = tug.startDist
    p33.fight = nil
    p33.tug = nil

    return v73, true
end

return t1
