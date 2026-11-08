-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function getIsValueValid(p1) -- line: 47
    if p1 == p1 then
        return p1 ~= nil
    end

    return false
end

function t1.new(p2, p3) -- line: 54
    -- upvalues: t1 (copy)
    local v1 = if p2 == p2 and p2 ~= nil then p2 elseif typeof(p2) == "Vector3" then Vector3.new(0, 0, 0) else 0

    p3 = p3 or tick

    return (setmetatable({
        _damper = 1,
        _speed = 1,
        _clock = p3,
        _time0 = p3(),
        _position0 = v1,
        _velocity0 = 0 * v1,
        _target = v1
    }, t1))
end

function t1.Impulse(p4, p5) -- line: 78
    if p5 == p5 and p5 ~= nil then
        p4.Velocity += p5
    end
end

function t1.TimeSkip(p6, p7) -- line: 88
    local v3 = p6._clock()
    local v4, v5 = p6:_positionVelocity(v3 + p7)

    p6._position0 = v4
    p6._velocity0 = v5
    p6._time0 = v3
end

function t1.getPosition(p8) -- line: 96
    return p8:_positionVelocity(p8._clock())
end

function t1.__index(p9, p10) -- line: 100
    -- upvalues: t1 (copy)
    if t1[p10] then
        return t1[p10]
    end

    if p10 == "Value" or p10 == "Position" or p10 == "p" then
        return (p9:_positionVelocity(p9._clock()))
    end

    if p10 == "Velocity" or p10 == "v" then
        local _, v6 = p9:_positionVelocity(p9._clock())

        return v6
    end

    if p10 == "Target" or p10 == "t" then
        return p9._target
    end

    if p10 == "Damper" or p10 == "d" then
        return p9._damper
    end

    if p10 == "Speed" or p10 == "s" then
        return p9._speed
    end

    if p10 == "Clock" then
        return p9._clock
    end

    error(("%q is not a valid member of Spring"):format((tostring(p10))), 2)
end

function t1.__newindex(p11, p12, p13) -- line: 122
    local v7 = p11._clock()

    if p13 ~= p13 or p13 == nil then
        return
    end

    if p12 ~= "Value" and p12 ~= "Position" and p12 ~= "p" then
        if p12 == "Velocity" or p12 == "v" then
            p11._position0 = p11:_positionVelocity(v7)
            p11._velocity0 = p13
            p11._time0 = v7
        elseif p12 == "Target" or p12 == "t" then
            local v8, v9 = p11:_positionVelocity(v7)

            p11._position0 = v8
            p11._velocity0 = v9
            p11._target = p13
            p11._time0 = v7
        elseif p12 == "Damper" or p12 == "d" then
            local v10, v11 = p11:_positionVelocity(v7)

            p11._position0 = v10
            p11._velocity0 = v11
            p11._damper = math.clamp(p13, 0, 1)
            p11._time0 = v7
        elseif p12 == "Speed" or p12 == "s" then
            local v12, v13 = p11:_positionVelocity(v7)

            p11._position0 = v12
            p11._velocity0 = v13

            if p13 < 0 then
                p11._speed = 0
            else
                p11._speed = p13
            end

            p11._time0 = v7
        elseif p12 == "Clock" then
            local v14, v15 = p11:_positionVelocity(v7)

            p11._position0 = v14
            p11._velocity0 = v15
            p11._clock = p13
            p11._time0 = p13()
        else
            error(("%q is not a valid member of Spring"):format((tostring(p12))), 2)
        end
    else
        local _, v16 = p11:_positionVelocity(v7)

        p11._position0 = p13
        p11._velocity0 = v16
        p11._time0 = v7
    end
end

function t1._positionVelocity(p14, p15) -- line: 168
    local _position0, _velocity0, _target, _damper = p14._position0, p14._velocity0, p14._target, p14._damper
    local _speed = p14._speed
    local v17 = _speed * (p15 - p14._time0)
    local v18 = _damper * _damper
    local v19, v20, v21

    if v18 < 1 then
        v19 = math.sqrt(1 - v18)

        local v24 = math.exp(-_damper * v17) / v19

        v20 = v24 * math.cos(v19 * v17)
        v21 = v24 * math.sin(v19 * v17)
    elseif v18 == 1 then
        v20 = math.exp(-_damper * v17) / 1
        v19 = 1
        v21 = v20 * v17
    else
        v19 = math.sqrt(v18 - 1)

        local v30 = math.exp((-_damper + v19) * v17) / (2 * v19)
        local v32 = math.exp((-_damper - v19) * v17) / (2 * v19)

        v20 = v30 + v32
        v21 = v30 - v32
    end

    local v33 = v19 * v20 + _damper * v21
    local v34 = 1 - (v19 * v20 + _damper * v21)
    local v35 = v21 / _speed
    local v36 = -_speed * v21
    local v37 = _speed * v21
    local v38 = v19 * v20 - _damper * v21

    return v33 * _position0 + v34 * _target + v35 * _velocity0, v36 * _position0 + v37 * _target + v38 * _velocity0
end

return t1
