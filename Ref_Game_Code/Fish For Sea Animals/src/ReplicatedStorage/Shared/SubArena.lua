-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    FLOOR_Y = -1100,
    CENTER = Vector3.new(9160, -1100, -5840),
    RADIUS = 260,
    MAX_X = 9435,
    MONSTER_RADIUS = 200
}

t1.LOW = t1.FLOOR_Y + 10
t1.HIGH = t1.FLOOR_Y + 120
t1.CRUISE = t1.FLOOR_Y + 40
t1.CRACK = Vector3.new(9465, -1080, -5840)
t1.MONSTER_SCALE = 2.4
t1.MONSTER_TOP = t1.FLOOR_Y + 66
t1.MIDDLE_UP = 31
t1.MONSTER_BODY = 42
t1.MONSTER_START = Vector3.new(9300, t1.FLOOR_Y, -5840)

function t1.yawOf(p1) -- line: 28
    return (math.atan2(p1.X, p1.Z))
end

function t1.dirOf(p2) -- line: 32
    return (Vector3.new(math.sin(p2), 0, (math.cos(p2))))
end

function t1.monsterPivot(p3, p4) -- line: 37
    -- upvalues: t1 (copy)
    return CFrame.new(p3.X, t1.FLOOR_Y, p3.Z) * CFrame.Angles(0, p4, 0)
end

function t1.start(p5, p6) -- line: 42
    -- upvalues: t1 (copy)
    local v3 = t1.CRACK.Z + (p5 - (p6 + 1) / 2) * 32
    local v5 = Vector3.new(t1.MAX_X - 25, t1.CRUISE, v3)

    return CFrame.lookAt(v5, v5 - Vector3.new(1, 0, 0))
end

function t1.clamp(p7, p8) -- line: 49
    -- upvalues: t1 (copy)
    local CENTER = t1.CENTER
    local v8 = Vector3.new(p7.X - CENTER.X, 0, p7.Z - CENTER.Z)

    if v8.Magnitude > t1.RADIUS then
        v8 = v8.Unit * t1.RADIUS
    end

    local v13 = Vector3.new(math.min(CENTER.X + v8.X, t1.MAX_X), math.clamp(p7.Y, t1.LOW, t1.HIGH), CENTER.Z + v8.Z)
    local v14, v15

    if not p8 or not (v13.Y < t1.MONSTER_TOP) then
        v15 = v13

        return v15
    end

    local v18 = Vector3.new(v13.X - p8.X, 0, v13.Z - p8.Z)

    if not (v18.Magnitude < t1.MONSTER_BODY) then
        v15 = v13

        return v15
    end

    v14 = if v18.Magnitude > 0.01 then v18.Unit else Vector3.new(1, 0, 0)

    return Vector3.new(p8.X, v13.Y, p8.Z) + v14 * t1.MONSTER_BODY
end

function t1.flat(p9, p10) -- line: 68
    return Vector3.new(p9.X - p10.X, 0, p9.Z - p10.Z).Magnitude
end

return t1
