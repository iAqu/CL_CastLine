-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    UtcOffsetHours = -7,
    StrengthHour = 20,
    StrengthLength = 3600,
    StrengthMult = 2
}

local function localSecond(p1) -- line: 18
    -- upvalues: t1 (copy)
    return (p1 + t1.UtcOffsetHours * 3600) % 86400
end

function t1.strengthLeft(p2) -- line: 23
    -- upvalues: t1 (copy)
    local v1 = ((p2 + t1.UtcOffsetHours * 3600) % 86400 - t1.StrengthHour * 3600) % 86400

    if v1 < t1.StrengthLength then
        return t1.StrengthLength - v1
    end

    return 0
end

function t1.strengthMult(p3) -- line: 28
    -- upvalues: t1 (copy)
    if t1.strengthLeft(p3) > 0 then
        return t1.StrengthMult
    end

    return 1
end

function t1.strengthIn(p4) -- line: 33
    -- upvalues: t1 (copy)
    return (t1.StrengthHour * 3600 - (p4 + t1.UtcOffsetHours * 3600) % 86400) % 86400
end

function t1.nextSlot(p5, p6, p7) -- line: 38
    local v3 = math.floor((p5 - p7) / p6) * p6 + p7

    if p5 < v3 then
        return v3
    end

    return v3 + p6
end

t1.World2OpensAt = 1795320000

function t1.world2OpensIn(p8) -- line: 49
    -- upvalues: t1 (copy)
    return (math.max(0, t1.World2OpensAt - p8))
end

function t1.clock(p9) -- line: 54
    local v5 = math.ceil(p9)
    local v6 = v5 // 3600
    local v7 = v5 // 60 % 60
    local v8 = v5 % 60

    if v6 > 0 then
        return (("%*h %*m"):format(v6, (string.format("%02d", v7))))
    end

    if v7 > 0 then
        return (("%*m %*s"):format(v7, (string.format("%02d", v8))))
    end

    return (("%*s"):format(v8))
end

return t1
