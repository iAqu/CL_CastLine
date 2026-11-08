-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local ValueType, Op = Observability.ValueType, Observability.Op
local t1 = {
    Types = table.freeze({
        [ValueType.ColorSequence] = true,
        [ValueType.NumberSequence] = true
    })
}
local v1 = buffer.create(4)

local function f32(p1) -- line: 40
    -- upvalues: v1 (copy)
    buffer.writef32(v1, 0, p1)

    return (buffer.readf32(v1, 0))
end

local function u8(p2) -- line: 45
    return (math.clamp(math.floor(p2 * 255 + 0.5), 0, 255))
end

function t1.keypoints(p3, p4) -- line: 50
    -- upvalues: ValueType (copy), v1 (copy)
    local t2 = {}

    if p3 == ValueType.ColorSequence then
        if typeof(p4) == "ColorSequence" then
            for v4, v5 in p4.Keypoints do
                local Value = v5.Value

                buffer.writef32(v1, 0, v5.Time)
                t2[v4] = {
                    buffer.readf32(v1, 0),
                    math.clamp(math.floor(Value.R * 255 + 0.5), 0, 255),
                    math.clamp(math.floor(Value.G * 255 + 0.5), 0, 255),
                    (math.clamp(math.floor(Value.B * 255 + 0.5), 0, 255))
                }
            end

            return t2
        end
    elseif typeof(p4) == "NumberSequence" then
        for v15, v16 in p4.Keypoints do
            buffer.writef32(v1, 0, v16.Time)

            local v17 = buffer.readf32(v1, 0)

            buffer.writef32(v1, 0, v16.Value)

            local v18 = buffer.readf32(v1, 0)

            buffer.writef32(v1, 0, v16.Envelope)
            t2[v15] = {
                v17,
                v18,
                (buffer.readf32(v1, 0))
            }
        end
    end

    return t2
end

function t1.key(p5) -- line: 68
    local v19 = if p5[1] then #p5[1] else 0
    local v20 = buffer.create(#p5 * v19 * 4)
    local n1 = 0

    for _, v21 in p5 do
        for _, v23 in v21 do
            buffer.writef32(v20, n1, v23)
            n1 += 4
        end
    end

    return buffer.tostring(v20)
end

function t1.shift(p6, p7, p8, p9) -- line: 83
    local v24 = #p6
    local v25 = p7 / 65536
    local t3 = {}
    local t4 = {}

    for i = 2, v24 - 1 do
        local v26 = p6[i]
        local v27 = table.clone(v26)
        local v28 = v26[1] + v25

        if v28 >= 1 then
            v27[1] = v28 - 1
            table.insert(t3, v27)
        else
            v27[1] = v28
            table.insert(t4, v27)
        end
    end

    local v29 = table.clone(p8)

    v29[1] = p6[1][1]

    local v30 = table.clone(p9)

    v30[1] = p6[v24][1]

    local t5 = {
        v29
    }

    table.move(t3, 1, #t3, 2, t5)
    table.move(t4, 1, #t4, #t5 + 1, t5)
    table.insert(t5, v30)

    return t5
end

local function near(p10, p11, p12) -- line: 110
    -- upvalues: ValueType (copy)
    if #p10 ~= #p11 then
        return false
    end

    local v31 = p12 == ValueType.ColorSequence

    for v32, v33 in p10 do
        local v34 = p11[v32]

        if math.abs(v33[1] - v34[1]) > 5E-04 then
            return false
        end

        for i = 2, #v33 do
            if if v31 then v33[i] ~= v34[i] else math.abs(v33[i] - v34[i]) > 1E-04 then
                return false
            end
        end
    end

    return true
end

function t1.findShift(p13, p14, p15) -- line: 131
    -- upvalues: t1 (copy), near (copy)
    local v38 = #p14

    if not (v38 < 3) and #p13 == v38 then
        local v39 = p14[2][1]

        for i = 2, v38 - 1 do
            local v41 = math.round((v39 - p13[i][1]) % 1 * 65536) % 65536
            local v42 = t1.shift(p13, v41, p14[1], p14[v38])

            if near(v42, p14, p15) then
                return v41, v42
            end
        end
    end

    return nil, nil
end

local function writeHeader(p16, p17, p18, p19, p20) -- line: 147
    -- upvalues: Codec (copy)
    p16:u8(p17)
    Codec.varuint(p16, p18)
    Codec.varuint(p16, p19)
    p16:u8(p20)
end

local function writeEnd(p21, p22, p23) -- line: 154
    -- upvalues: ValueType (copy)
    if p22 ~= ValueType.ColorSequence then
        p21:f32(p23[2])
        p21:f32(p23[3])

        return
    end

    p21:u8(p23[2])
    p21:u8(p23[3])
    p21:u8(p23[4])
end

function t1.writeCopy(p24, p25, p26, p27, p28) -- line: 165
    -- upvalues: Codec (copy), Op (copy)
    p24:u8(Op.SeqCopy)
    Codec.varuint(p24, p25)
    Codec.varuint(p24, p26)
    p24:u8(p27)
    Codec.varuint(p24, p28)
end

function t1.writeShift(p29, p30, p31, p32, p33, p34, p35) -- line: 170
    -- upvalues: Codec (copy), Op (copy), writeEnd (copy)
    p29:u8(Op.SeqShift)
    Codec.varuint(p29, p30)
    Codec.varuint(p29, p31)
    p29:u8(p32)
    p29:u16(p34)
    writeEnd(p29, p33, p35[1])
    writeEnd(p29, p33, p35[#p35])
end

return table.freeze(t1)
