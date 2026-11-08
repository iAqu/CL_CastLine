-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Encode = require(ReplicatedStorage.UserGenerated.DataModel.Encode)
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local ValueType, MaxStringBytes = Observability.ValueType, Observability.MaxStringBytes
local t1 = {
    newWriter = Encode.newWriter,
    varuint = function(p1, p2) -- varuint | line: 26
        local v2 = math.max(0, (math.floor(p2)))

        while v2 >= 128 do
            p1:u8((bit32.bor(v2 % 128, 128)))
            v2 //= 128
        end

        p1:u8(v2)
    end,
    i16 = function(p3, p4) -- i16 | line: 35
        p3:_ensure(2)

        local buf, len = p3.buf, p3.len
        local v5 = math.clamp(math.round(p4), -32768, 32767)

        buffer.writei16(buf, len, v5)
        p3.len += 2
    end,
    i32 = function(p5, p6) -- i32 | line: 41
        p5:_ensure(4)

        local v6 = if p6 == p6 then p6 else 0
        local buf, len = p5.buf, p5.len
        local v8 = math.clamp(math.round(v6), -2147483648, 2147483647)

        buffer.writei32(buf, len, v8)
        p5.len += 4
    end
}

function t1.str(p7, p8) -- line: 50
    -- upvalues: MaxStringBytes (copy), t1 (copy)
    local v9 = #p8
    local v10

    if MaxStringBytes < v9 then
        v9 = MaxStringBytes

        while v9 > 0 and bit32.band(string.byte(p8, v9 + 1), 192) == 128 do
            v9 -= 1
        end

        v10 = string.sub(p8, 1, v9)
    else
        v10 = p8
    end

    t1.varuint(p7, v9)

    if not (v9 > 0) then
        return
    end

    p7:_ensure(v9)
    buffer.writestring(p7.buf, p7.len, v10)
    p7.len += v9
end

local function color(p9, p10) -- line: 68
    p9:u8((math.clamp(math.floor(p10.R * 255 + 0.5), 0, 255)))
    p9:u8((math.clamp(math.floor(p10.G * 255 + 0.5), 0, 255)))
    p9:u8((math.clamp(math.floor(p10.B * 255 + 0.5), 0, 255)))
end

local function udim(p11, p12) -- line: 74
    -- upvalues: t1 (copy)
    p11:f32(p12.Scale)
    t1.i32(p11, p12.Offset)
end

function t1.udim2Mask(p13, p14) -- line: 81
    local X, Y = p13.X, p13.Y
    local X2, Y2 = p14.X, p14.Y

    return (if X.Scale == X2.Scale then 0 else 1) + (if X.Offset == X2.Offset then 0 else 2) + (if Y.Scale == Y2.Scale then 0 else 4) + (if Y.Offset == Y2.Offset then 0 else 8)
end

function t1.udim2Part(p15, p16, p17) -- line: 90
    -- upvalues: t1 (copy)
    p15:u8(p16)

    if bit32.btest(p16, 1) then
        p15:f32(p17.X.Scale)
    end

    if bit32.btest(p16, 2) then
        t1.i32(p15, p17.X.Offset)
    end

    if bit32.btest(p16, 4) then
        p15:f32(p17.Y.Scale)
    end

    if bit32.btest(p16, 8) then
        t1.i32(p15, p17.Y.Offset)
    end
end

local function finite(p18) -- line: 106
    if p18 == p18 and p18 > (-1e999) and p18 < 1e999 then
        return p18
    end

    return 0
end

local function quantize(p19) -- line: 112
    return (math.clamp(math.round(p19), -32768, 32767))
end

local function quantizeRotation(p20) -- line: 118
    local _, _, _, Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9 = p20:GetComponents()

    if Components == 1 and Components5 == 1 and Components9 == 1 then
        return 4, 0, 0, 0
    end

    local v20 = Components + Components5 + Components9
    local v21, v22, v23, v24

    if v20 > 0 then
        local v26 = math.sqrt(1 + v20) * 2

        v22 = v26 * 0.25
        v21 = (Components8 - Components6) / v26
        v23 = (Components3 - Components7) / v26
        v24 = (Components4 - Components2) / v26
    elseif Components5 < Components and Components9 < Components then
        local v28 = math.sqrt(1 + Components - Components5 - Components9) * 2

        v22 = (Components8 - Components6) / v28
        v21 = v28 * 0.25
        v23 = (Components2 + Components4) / v28
        v24 = (Components3 + Components7) / v28
    elseif Components9 < Components5 then
        local v30 = math.sqrt(1 + Components5 - Components - Components9) * 2

        v22 = (Components3 - Components7) / v30
        v21 = (Components2 + Components4) / v30
        v23 = v30 * 0.25
        v24 = (Components6 + Components8) / v30
    else
        local v32 = math.sqrt(1 + Components9 - Components - Components5) * 2

        v22 = (Components4 - Components2) / v32
        v21 = (Components3 + Components7) / v32
        v23 = (Components6 + Components8) / v32
        v24 = v32 * 0.25
    end

    if v21 ~= v21 or not (v21 > (-1e999)) or not (v21 < 1e999) then
        v21 = 0
    end

    if v23 ~= v23 or not (v23 > (-1e999)) or not (v23 < 1e999) then
        v23 = 0
    end

    if v24 ~= v24 or not (v24 > (-1e999)) or not (v24 < 1e999) then
        v24 = 0
    end

    if v22 ~= v22 or not (v22 > (-1e999)) or not (v22 < 1e999) then
        v22 = 0
    end

    local t2 = {
        v21,
        v23,
        v24,
        v22
    }
    local v34 = math.sqrt(t2[1] * t2[1] + t2[2] * t2[2] + t2[3] * t2[3] + t2[4] * t2[4])

    if v34 < 1E-06 then
        return 4, 0, 0, 0
    end

    local v35 = if math.abs(t2[2]) > math.abs(t2[1]) then 2 else 1

    if math.abs(t2[3]) > math.abs(t2[v35]) then
        v35 = 3
    end

    if math.abs(t2[4]) > math.abs(t2[v35]) then
        v35 = 4
    end

    local v40 = (if t2[v35] < 0 then -46339.53579827921 else 46339.53579827921) / v34
    local n1 = 0
    local n2 = 0
    local n3 = 0
    local n4 = 0

    for i = 1, 4 do
        if i ~= v35 then
            n4 += 1

            local v43 = math.clamp(math.round(t2[i] * v40), -32768, 32767)

            if n4 == 1 then
                n1 = v43
            elseif n4 == 2 then
                n2 = v43
            else
                n3 = v43
            end
        end
    end

    return v35 - 1, n1, n2, n3
end

t1.quantizeRotation = quantizeRotation

function t1.position(p21, p22) -- line: 169
    local Position = p22.Position
    local X = Position.X

    if X ~= X or not (X > (-1e999)) or not (X < 1e999) then
        X = 0
    end

    p21:f32(X)

    local Y = Position.Y

    if Y ~= Y or not (Y > (-1e999)) or not (Y < 1e999) then
        Y = 0
    end

    p21:f32(Y)

    local Z = Position.Z

    if Z ~= Z or not (Z > (-1e999)) or not (Z < 1e999) then
        Z = 0
    end

    p21:f32(Z)
end

function t1.rotation(p23, p24, p25, p26, p27) -- line: 178
    -- upvalues: t1 (copy)
    p23:u8(p24)

    if p24 == 4 then
        return
    end

    t1.i16(p23, p25)
    t1.i16(p23, p26)
    t1.i16(p23, p27)
end

function t1.cframe(p28, p29) -- line: 188
    -- upvalues: t1 (copy), quantizeRotation (copy)
    local Position = p29.Position
    local X = Position.X

    if X ~= X or not (X > (-1e999)) or not (X < 1e999) then
        X = 0
    end

    p28:f32(X)

    local Y = Position.Y

    if Y ~= Y or not (Y > (-1e999)) or not (Y < 1e999) then
        Y = 0
    end

    p28:f32(Y)

    local Z = Position.Z

    if Z ~= Z or not (Z > (-1e999)) or not (Z < 1e999) then
        Z = 0
    end

    p28:f32(Z)

    local v44, v45, v46, v47 = quantizeRotation(p29)

    p28:u8(v44)

    if v44 == 4 then
        return
    end

    t1.i16(p28, v45)
    t1.i16(p28, v46)
    t1.i16(p28, v47)
end

function t1.zigzag(p30, p31) -- line: 194
    -- upvalues: t1 (copy)
    t1.varuint(p30, if p31 >= 0 then p31 * 2 else -p31 * 2 - 1)
end

t1.MaxPositionSteps = 2147483648

local v48 = buffer.create(4)

function t1.stepPosition(p32, p33) -- line: 207
    -- upvalues: v48 (copy)
    buffer.writef32(v48, 0, p32 + p33 / 1024)

    return (buffer.readf32(v48, 0))
end

function t1.positionSteps(p34, p35) -- line: 213
    return (math.round((p35 - p34) * 1024))
end

function t1.cframeDelta(p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47) -- line: 220
    -- upvalues: t1 (copy)
    local v51 = if p37 == 0 and p38 == 0 and p39 == 0 then 0 else 1

    if p40 ~= p44 or p41 ~= p45 or p42 ~= p46 or p43 ~= p47 then
        if p40 == p44 and p44 ~= 4 and math.abs(p45 - p41) <= 8191 and math.abs(p46 - p42) <= 8191 and math.abs(p47 - p43) <= 8191 then
            v51 += 4
        else
            v51 += 2
        end
    end

    p36:u8(v51)

    if v51 % 2 == 1 then
        t1.zigzag(p36, p37)
        t1.zigzag(p36, p38)
        t1.zigzag(p36, p39)
    end

    if bit32.btest(v51, 4) then
        t1.zigzag(p36, p45 - p41)
        t1.zigzag(p36, p46 - p42)
        t1.zigzag(p36, p47 - p43)
    elseif bit32.btest(v51, 2) then
        p36:u8(p44)

        if p44 ~= 4 then
            t1.i16(p36, p45)
            t1.i16(p36, p46)
            t1.i16(p36, p47)
        end
    end
end

local function v56() -- line: 269
    return nil
end

function t1.setRefLookup(p48) -- line: 273
    -- upvalues: v56 (ref)
    v56 = p48
end

local t3 = {
    [ValueType.Bool] = function(p49, p50) -- line: 278
        p49:u8(p50 == true and 1 or 0)
    end,
    [ValueType.Int32] = function(p51, p52) -- line: 281
        -- upvalues: t1 (copy)
        t1.i32(p51, if type(p52) == "number" then p52 else 0)
    end,
    [ValueType.Float32] = function(p53, p54) -- line: 284
        p53:f32(if type(p54) == "number" then p54 else 0)
    end,
    [ValueType.Float64] = function(p55, p56) -- line: 287
        p55:f64(if type(p56) == "number" then p56 else 0)
    end,
    [ValueType.Int64] = function(p57, p58) -- line: 290
        p57:f64(if type(p58) == "number" then p58 else 0)
    end,
    [ValueType.String] = function(p59, p60) -- line: 293
        -- upvalues: t1 (copy)
        t1.str(p59, if type(p60) == "string" then p60 else "")
    end,
    [ValueType.Enum] = function(p61, p62) -- line: 296
        -- upvalues: t1 (copy)
        t1.varuint(p61, if typeof(p62) == "EnumItem" then p62.Value else 0)
    end,
    [ValueType.UDim] = function(p63, p64) -- line: 299
        -- upvalues: t1 (copy)
        local v57 = if typeof(p64) == "UDim" then p64 else UDim.new()

        p63:f32(v57.Scale)
        t1.i32(p63, v57.Offset)
    end,
    [ValueType.UDim2] = function(p65, p66) -- line: 302
        -- upvalues: t1 (copy)
        local v58 = if typeof(p66) == "UDim2" then p66 else UDim2.new()
        local X = v58.X

        p65:f32(X.Scale)
        t1.i32(p65, X.Offset)

        local Y = v58.Y

        p65:f32(Y.Scale)
        t1.i32(p65, Y.Offset)
    end,
    [ValueType.Vector2] = function(p67, p68) -- line: 307
        local v59 = if typeof(p68) == "Vector2" then p68 else Vector2.zero

        p67:f32(v59.X)
        p67:f32(v59.Y)
    end,
    [ValueType.Vector3] = function(p69, p70) -- line: 312
        local v60 = if typeof(p70) == "Vector3" then p70 else Vector3.new(0, 0, 0)

        p69:f32(v60.X)
        p69:f32(v60.Y)
        p69:f32(v60.Z)
    end,
    [ValueType.Color3] = function(p71, p72) -- line: 318
        -- upvalues: color (copy)
        color(p71, if typeof(p72) == "Color3" then p72 else Color3.new())
    end,
    [ValueType.Rect] = function(p73, p74) -- line: 321
        local v62 = if typeof(p74) == "Rect" then p74 else Rect.new()

        p73:f32(v62.Min.X)
        p73:f32(v62.Min.Y)
        p73:f32(v62.Max.X)
        p73:f32(v62.Max.Y)
    end,
    [ValueType.Font] = function(p75, p76) -- line: 328
        -- upvalues: t1 (copy)
        if typeof(p76) == "Font" then
            t1.str(p75, p76.Family)
            t1.varuint(p75, p76.Weight.Value)
            p75:u8(p76.Style.Value)
        else
            t1.str(p75, "")
            t1.varuint(p75, 400)
            p75:u8(0)
        end
    end,
    [ValueType.ColorSequence] = function(p77, p78) -- line: 339
        -- upvalues: t1 (copy), color (copy)
        local v63 = if typeof(p78) == "ColorSequence" then p78.Keypoints else {}

        t1.varuint(p77, #v63)

        for _, v64 in v63 do
            p77:f32(v64.Time)
            color(p77, v64.Value)
        end
    end,
    [ValueType.NumberSequence] = function(p79, p80) -- line: 347
        -- upvalues: t1 (copy)
        local v65 = if typeof(p80) == "NumberSequence" then p80.Keypoints else {}

        t1.varuint(p79, #v65)

        for _, v66 in v65 do
            p79:f32(v66.Time)
            p79:f32(v66.Value)
            p79:f32(v66.Envelope)
        end
    end,
    [ValueType.NumberRange] = function(p81, p82) -- line: 356
        local v67 = if typeof(p82) == "NumberRange" then p82 else NumberRange.new(0)

        p81:f32(v67.Min)
        p81:f32(v67.Max)
    end,
    [ValueType.Content] = function(p83, p84) -- line: 361
        -- upvalues: t1 (copy)
        local v68 = if typeof(p84) == "Content" then p84.Uri else nil
        local str = t1.str

        if type(v68) ~= "string" then
            v68 = ""
        end

        str(p83, v68)
    end,
    [ValueType.CFrame] = function(p85, p86) -- line: 365
        -- upvalues: t1 (copy), quantizeRotation (copy)
        local v69 = if typeof(p86) == "CFrame" then p86 else CFrame.identity
        local Position = v69.Position
        local X = Position.X

        if X ~= X or not (X > (-1e999)) or not (X < 1e999) then
            X = 0
        end

        p85:f32(X)

        local Y = Position.Y

        if Y ~= Y or not (Y > (-1e999)) or not (Y < 1e999) then
            Y = 0
        end

        p85:f32(Y)

        local Z = Position.Z

        if Z ~= Z or not (Z > (-1e999)) or not (Z < 1e999) then
            Z = 0
        end

        p85:f32(Z)

        local v70, v71, v72, v73 = quantizeRotation(v69)

        p85:u8(v70)

        if v70 == 4 then
            return
        end

        t1.i16(p85, v71)
        t1.i16(p85, v72)
        t1.i16(p85, v73)
    end,
    [ValueType.Ref] = function(p87, p88) -- line: 368
        -- upvalues: t1 (copy), v56 (ref)
        local v74 = if typeof(p88) == "Instance" then v56(p88) else nil

        t1.varuint(p87, if v74 then v74 + 1 else 0)
    end,
    [ValueType.Vector2int16] = function(p89, p90) -- line: 372
        -- upvalues: t1 (copy)
        local v75 = if typeof(p90) == "Vector2int16" then p90 else Vector2int16.new()

        t1.i16(p89, v75.X)
        t1.i16(p89, v75.Y)
    end
}

t1.Writers = t3

function t1.writeValue(p91, p92, p93) -- line: 380
    -- upvalues: t3 (copy)
    t3[p92](p91, p93)
end

t1.EngineTypes = table.freeze({
    bool = ValueType.Bool,
    int = ValueType.Int32,
    int64 = ValueType.Int64,
    float = ValueType.Float32,
    double = ValueType.Float64,
    string = ValueType.String,
    ContentId = ValueType.String,
    Enum = ValueType.Enum,
    UDim = ValueType.UDim,
    UDim2 = ValueType.UDim2,
    Vector2 = ValueType.Vector2,
    Vector3 = ValueType.Vector3,
    Color3 = ValueType.Color3,
    Rect = ValueType.Rect,
    Font = ValueType.Font,
    ColorSequence = ValueType.ColorSequence,
    NumberSequence = ValueType.NumberSequence,
    NumberRange = ValueType.NumberRange,
    Content = ValueType.Content,
    CFrame = ValueType.CFrame,
    Vector2int16 = ValueType.Vector2int16
})

return table.freeze(t1)
