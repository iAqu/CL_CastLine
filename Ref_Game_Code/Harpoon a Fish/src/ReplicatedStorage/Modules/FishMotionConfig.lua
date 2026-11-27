-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    TICK = 0.05,
    TIERS = {
        {
            dist = 90,
            every = 1
        },
        {
            dist = 200,
            every = 2
        },
        {
            dist = 340,
            every = 3
        }
    },
    PEN_EVERY = 8,
    SHOW = 340,
    KEEP = 420,
    DELAY = 0.18,
    JITTER_K = 2.5,
    BASE_MAX_DELAY = 0.5,
    MAX_DELAY = 10,
    GAP_MIN = 0.6,
    GAP_MEMORY = 120,
    CATCHUP = 0.1,
    SLOW_SEND_DELAY = 1,
    HOOK_REWIND_MIN = 1,
    MAX_EXTRAP = 0.3,
    FIGHT_DELAY = 0.06,
    FIGHT_MAX_DELAY = 0.5,
    STALE = 1.5,
    FADE = 1.2,
    LINGER = 0.6,
    MAX_REWIND = 0.8,
    HIST_EVERY = 0.05,
    RECORD_BYTES = 15,
    PER_PACKET = 58,
    POS_SCALE = 16,
    ORIGIN = Vector3.new(50, 0, 0),
    Y_OFFSET = 1000,
    ROT_SCALE = 10430.060040584269
}

local function q(p1) -- line: 69
    local v2 = math.floor(p1 + 0.5)

    if v2 > 32767 then
        return 32767
    end

    if v2 < -32767 then
        return -32767
    end

    return v2
end

function t1.newPacket(p2, p3) -- line: 75
    -- upvalues: t1 (copy)
    local v3 = buffer.create(8 + p2 * t1.RECORD_BYTES)

    buffer.writef64(v3, 0, p3)

    return v3
end

function t1.write(p4, p5, p6, p7, p8) -- line: 82
    -- upvalues: t1 (copy)
    local v4 = 8 + (p5 - 1) * t1.RECORD_BYTES
    local v5 = p7.Position - t1.ORIGIN
    local v6, v7, v8 = p7:ToEulerAnglesYXZ()

    buffer.writeu16(p4, v4, p6)

    local v9 = v4 + 2
    local v11 = math.floor(v5.X * t1.POS_SCALE + 0.5)

    if v11 > 32767 then
        v11 = 32767
    elseif v11 < -32767 then
        v11 = -32767
    end

    buffer.writei16(p4, v9, v11)

    local v12 = v4 + 4
    local v14 = math.floor((p7.Position.Y + t1.Y_OFFSET) * t1.POS_SCALE + 0.5)

    if v14 > 32767 then
        v14 = 32767
    elseif v14 < -32767 then
        v14 = -32767
    end

    buffer.writei16(p4, v12, v14)

    local v15 = v4 + 6
    local v17 = math.floor(v5.Z * t1.POS_SCALE + 0.5)

    if v17 > 32767 then
        v17 = 32767
    elseif v17 < -32767 then
        v17 = -32767
    end

    buffer.writei16(p4, v15, v17)

    local v18 = v4 + 8
    local v20 = math.floor(v6 * t1.ROT_SCALE + 0.5)

    if v20 > 32767 then
        v20 = 32767
    elseif v20 < -32767 then
        v20 = -32767
    end

    buffer.writei16(p4, v18, v20)

    local v21 = v4 + 10
    local v23 = math.floor(v7 * t1.ROT_SCALE + 0.5)

    if v23 > 32767 then
        v23 = 32767
    elseif v23 < -32767 then
        v23 = -32767
    end

    buffer.writei16(p4, v21, v23)

    local v24 = v4 + 12
    local v26 = math.floor(v8 * t1.ROT_SCALE + 0.5)

    if v26 > 32767 then
        v26 = 32767
    elseif v26 < -32767 then
        v26 = -32767
    end

    buffer.writei16(p4, v24, v26)
    buffer.writeu8(p4, v4 + 14, p8 % 256)
end

function t1.count(p9) -- line: 96
    -- upvalues: t1 (copy)
    return (buffer.len(p9) - 8) // t1.RECORD_BYTES
end

function t1.time(p10) -- line: 100
    return (buffer.readf64(p10, 0))
end

function t1.read(p11, p12) -- line: 104
    -- upvalues: t1 (copy)
    local v29 = 8 + (p12 - 1) * t1.RECORD_BYTES
    local v30 = buffer.readu16(p11, v29)
    local v32 = buffer.readi16(p11, v29 + 2) / t1.POS_SCALE + t1.ORIGIN.X
    local v34 = buffer.readi16(p11, v29 + 4) / t1.POS_SCALE - t1.Y_OFFSET
    local v36 = buffer.readi16(p11, v29 + 6) / t1.POS_SCALE + t1.ORIGIN.Z
    local v38 = buffer.readi16(p11, v29 + 8) / t1.ROT_SCALE
    local v40 = buffer.readi16(p11, v29 + 10) / t1.ROT_SCALE
    local v42 = buffer.readi16(p11, v29 + 12) / t1.ROT_SCALE

    return v30, CFrame.new(v32, v34, v36) * CFrame.fromEulerAnglesYXZ(v38, v40, v42), (buffer.readu8(p11, v29 + 14))
end

t1.clientDelay = nil

function t1.renderLag() -- line: 120
    -- upvalues: t1 (copy)
    return t1.clientDelay or t1.DELAY
end

t1.clientAge = nil

function t1.bodyLag() -- line: 126
    -- upvalues: t1 (copy)
    return t1.renderLag() - (t1.clientAge or 0)
end

t1.holdSince = nil
t1.recvBytes = 0
t1.override = {}
t1.nudge = {}
t1.blink = {}

return t1
