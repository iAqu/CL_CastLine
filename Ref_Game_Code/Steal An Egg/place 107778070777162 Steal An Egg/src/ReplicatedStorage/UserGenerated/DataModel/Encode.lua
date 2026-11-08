-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {}

t2.__index = t2

function t1.newWriter(p1) -- line: 34
    -- upvalues: t2 (copy)
    p1 = p1 or 65536

    return (setmetatable({
        len = 0,
        buf = buffer.create(p1),
        cap = p1
    }, t2))
end

function t2._ensure(p2, p3) -- line: 43
    local v2 = p2.len + p3

    if not (p2.cap < v2) then
        return
    end

    local v3 = p2.cap * 2

    while v3 < v2 do
        v3 *= 2
    end

    local v4 = buffer.create(v3)

    buffer.copy(v4, 0, p2.buf, 0, p2.len)
    p2.buf = v4
    p2.cap = v3
end

function t2.u8(p4, p5) -- line: 57
    p4:_ensure(1)
    buffer.writeu8(p4.buf, p4.len, p5)
    p4.len += 1
end

function t2.u16(p6, p7) -- line: 63
    p6:_ensure(2)
    buffer.writeu16(p6.buf, p6.len, p7)
    p6.len += 2
end

function t2.u32(p8, p9) -- line: 69
    p8:_ensure(4)
    buffer.writeu32(p8.buf, p8.len, p9)
    p8.len += 4
end

function t2.f32(p10, p11) -- line: 75
    p10:_ensure(4)
    buffer.writef32(p10.buf, p10.len, p11)
    p10.len += 4
end

function t2.f64(p12, p13) -- line: 81
    p12:_ensure(8)
    buffer.writef64(p12.buf, p12.len, p13)
    p12.len += 8
end

function t2.strU8(p14, p15) -- line: 88
    local v5 = #p15

    p14:_ensure(v5 + 1)
    buffer.writeu8(p14.buf, p14.len, v5)
    p14.len += 1

    if v5 > 0 then
        buffer.writestring(p14.buf, p14.len, p15)
        p14.len += v5
    end
end

function t2.strU16(p16, p17) -- line: 100
    local v6 = #p17
    local v7 = p17

    if v6 > 65535 then
        v7 = string.sub(p17, 1, 65535)
        v6 = 65535
    end

    p16:_ensure(v6 + 2)
    buffer.writeu16(p16.buf, p16.len, v6)
    p16.len += 2

    if v6 > 0 then
        buffer.writestring(p16.buf, p16.len, v7)
        p16.len += v6
    end
end

function t2.str32(p18, p19) -- line: 116
    local v8 = #p19

    p18:_ensure(v8 + 4)
    buffer.writeu32(p18.buf, p18.len, v8)
    p18.len += 4

    if v8 > 0 then
        buffer.writestring(p18.buf, p18.len, p19)
        p18.len += v8
    end
end

function t2.patchU16(p20, p21, p22) -- line: 127
    buffer.writeu16(p20.buf, p21, p22)
end

function t2.finish(p23) -- line: 131
    local v9 = buffer.create(p23.len)

    buffer.copy(v9, 0, p23.buf, 0, p23.len)

    return v9
end

function t1.writeValue(p24, p25) -- line: 140
    if p25 ~= nil then
        local v10 = typeof(p25)

        if v10 == "boolean" then
            p24:u8(p25 and 2 or 1)
        elseif v10 == "number" then
            p24:u8(3)
            p24:f64(p25)
        elseif v10 == "string" then
            p24:u8(4)
            p24:str32(p25)
        elseif v10 == "EnumItem" then
            p24:u8(5)
            p24:str32((tostring(p25)))
        elseif v10 == "Vector2" then
            p24:u8(6)
            p24:f32(p25.X)
            p24:f32(p25.Y)
        elseif v10 == "Vector3" then
            p24:u8(7)
            p24:f32(p25.X)
            p24:f32(p25.Y)
            p24:f32(p25.Z)
        elseif v10 == "Color3" then
            p24:u8(8)
            p24:u8((math.clamp(math.floor(p25.R * 255 + 0.5), 0, 255)))
            p24:u8((math.clamp(math.floor(p25.G * 255 + 0.5), 0, 255)))
            p24:u8((math.clamp(math.floor(p25.B * 255 + 0.5), 0, 255)))
        elseif v10 == "CFrame" then
            p24:u8(9)

            local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p25:GetComponents()

            p24:f32(Components)
            p24:f32(Components2)
            p24:f32(Components3)
            p24:f32(Components4)
            p24:f32(Components5)
            p24:f32(Components6)
            p24:f32(Components7)
            p24:f32(Components8)
            p24:f32(Components9)
            p24:f32(Components10)
            p24:f32(Components11)
            p24:f32(Components12)
        else
            p24:u8(10)
            p24:str32((tostring(p25)))
        end
    else
        p24:u8(0)
    end
end

return t1
