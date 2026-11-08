-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    [0] = -12336,
    [1] = -12592,
    [2] = -12848,
    [3] = -13104,
    [4] = -13360,
    [5] = -13616,
    [6] = -13872,
    [7] = -14128,
    [8] = 25180,
    [9] = 29788,
    [10] = 28252,
    [11] = -25136,
    [12] = 26204,
    [13] = 29276,
    [14] = -25904,
    [15] = -26160,
    [16] = -12337,
    [17] = -12593,
    [18] = -12849,
    [19] = -13105,
    [20] = -13361,
    [21] = -13617,
    [22] = -13873,
    [23] = -14129,
    [24] = -14385,
    [25] = -14641,
    [26] = -24881,
    [27] = -25137,
    [28] = -25393,
    [29] = -25649,
    [30] = -25905,
    [31] = -26161
}
local t2 = {
    [36] = true,
    [95] = true
}
local t3 = {
    [36] = true,
    [95] = true
}

for i = 65, 90 do
    t2[i] = true
    t3[i] = true
end

for i = 97, 122 do
    t2[i] = true
    t3[i] = true
end

t3[48] = true
t3[49] = true
t3[50] = true
t3[51] = true
t3[52] = true
t3[53] = true
t3[54] = true
t3[55] = true
t3[56] = true
t3[57] = true

local function Stream(p1) -- line: 91
    return {
        Pos = 0,
        Indent = 0,
        Pretty = false,
        Null = nil,
        QuoteChar = 34,
        UnquoteIdent = false,
        Buf = p1,
        Cap = buffer.len(p1),
        Encoders = {}
    }
end

local function ToString(p2) -- line: 105
    return buffer.readstring(p2.Buf, 0, p2.Pos)
end

local function AllocSize(p3) -- line: 109
    return (math.max(p3, 2 ^ math.ceil((math.log(p3, 2)))))
end

local function Reserve(p4, p5) -- line: 113
    local Pos = p4.Pos
    local v3 = Pos + p5

    if p4.Cap < v3 then
        local v6 = math.max(v3, 2 ^ math.ceil((math.log(v3, 2))))
        local v7 = buffer.create(v6)

        buffer.copy(v7, 0, p4.Buf, 0, Pos)
        p4.Buf = v7
        p4.Cap = v6
    end

    p4.Pos = v3

    return Pos
end

local function WriteString(p6, p7) -- line: 126
    -- upvalues: Reserve (copy)
    local v8 = string.len(p7)
    local v9 = Reserve(p6, v8)

    buffer.writestring(p6.Buf, v9, p7, v8)
end

local function WriteIndent(p8) -- line: 132
    -- upvalues: Reserve (copy)
    local v10 = p8.Indent * 2
    local v11 = Reserve(p8, v10)
    local Buf = p8.Buf

    for i = 0, v10 - 1 do
        buffer.writeu16(Buf, v11 + i * 2, 8224)
    end
end

local function IncrementIndent(p9, p10) -- line: 141
    p9.Indent += p10
end

local function WriteU8(p11, p12) -- line: 145
    -- upvalues: Reserve (copy)
    local v13 = Reserve(p11, 1)

    buffer.writeu8(p11.Buf, v13, p12)
end

local function WriteU16(p13, p14) -- line: 150
    -- upvalues: Reserve (copy)
    local v14 = Reserve(p13, 2)

    buffer.writeu16(p13.Buf, v14, p14)
end

local function WriteU32(p15, p16) -- line: 155
    -- upvalues: Reserve (copy)
    local v15 = Reserve(p15, 4)

    buffer.writeu32(p15.Buf, v15, p16)
end

local function EncodeNull(p17, _) -- line: 160
    -- upvalues: Reserve (copy)
    local v16 = Reserve(p17, 4)

    buffer.writeu32(p17.Buf, v16, 1819047278)
end

local function EncodeBoolean(p19, p20) -- line: 164
    -- upvalues: Reserve (copy)
    if p20 then
        local v17 = Reserve(p19, 4)

        buffer.writeu32(p19.Buf, v17, 1702195828)
    else
        local v18 = Reserve(p19, 5)
        local Buf = p19.Buf

        buffer.writeu32(Buf, v18, 1936482662)
        buffer.writeu8(Buf, v18 + 4, 101)
    end
end

local function EncodeNumber(p21, p22) -- line: 175
    -- upvalues: Reserve (copy)
    if p22 == p22 then
        if p22 == 1e999 then
            local v20 = Reserve(p21, 8)
            local Buf = p21.Buf

            buffer.writeu32(Buf, v20, 1768320585)
            buffer.writeu32(Buf, v20 + 4, 2037672302)
        elseif p22 == (-1e999) then
            local v22 = Reserve(p21, 9)
            local Buf = p21.Buf

            buffer.writeu8(Buf, v22, 45)
            buffer.writeu32(Buf, v22 + 1, 1768320585)
            buffer.writeu32(Buf, v22 + 5, 2037672302)
        else
            local v25 = tostring(p22)
            local v26 = string.find(v25, "e%+")

            if v26 then
                v25 = string.sub(v25, 1, v26) .. string.sub(v25, v26 + 2)
            end

            local v29 = string.len(v25)
            local v30 = Reserve(p21, v29)

            buffer.writestring(p21.Buf, v30, v25, v29)
        end
    else
        local v31 = Reserve(p21, 3)
        local Buf = p21.Buf

        buffer.writeu16(Buf, v31, 24910)
        buffer.writeu8(Buf, v31 + 2, 78)
    end
end

local function IsIdentifierName(_, p24) -- line: 202
    -- upvalues: t2 (copy), t3 (copy)
    local v33 = string.len(p24)

    if v33 == 0 or not t2[string.byte(p24, 1)] then
        return false
    end

    for i = 2, v33 do
        if not t3[string.byte(p24, i)] then
            return false
        end
    end

    return true
end

local function EncodeString(p25, p26, p27) -- line: 220
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), Reserve (copy)
    local v35

    if p27 then
        local v36 = string.len(p26)
        local v37

        if v36 == 0 then
            v37 = false
        elseif t2[string.byte(p26, 1)] then
            local v39 = false

            for i = 2, v36 do
                if not t3[string.byte(p26, i)] then
                    v37 = false
                    v39 = true
                    break
                end
            end

            if not v39 then
                v37 = true
            end
        else
            v37 = false
        end

        v35 = if v37 then p27 else false
    else
        v35 = p27
    end

    local v40 = string.len(p26)
    local v41 = Reserve(p25, v40 * 6 + 2)
    local Buf, QuoteChar = p25.Buf, p25.QuoteChar

    if not v35 then
        buffer.writeu8(Buf, v41, QuoteChar)
        v41 += 1
    end

    for i = 1, v40 do
        local v42 = string.byte(p26, i)

        if v42 > 31 then
            if v42 == QuoteChar or v42 == 92 then
                buffer.writeu16(Buf, v41, bit32.lshift(v42, 8) + 92)
                v41 += 2
            else
                buffer.writeu8(Buf, v41, v42)
                v41 += 1
            end
        else
            local v44 = t1[v42]

            if v44 < 0 then
                v44 = -v44
                buffer.writeu32(Buf, v41, 808482140)
                v41 += 4
            end

            buffer.writeu16(Buf, v41, v44)
            v41 += 2
        end
    end

    if not v35 then
        buffer.writeu8(Buf, v41, QuoteChar)
        v41 += 1
    end

    p25.Pos = v41
end

local function EncodeBuffer(p28, p29) -- line: 266
    -- upvalues: t1 (copy), Reserve (copy)
    local v45 = buffer.len(p29)
    local v46 = Reserve(p28, 2 + v45 * 6)
    local Buf, QuoteChar = p28.Buf, p28.QuoteChar

    buffer.writeu8(Buf, v46, QuoteChar)

    local v47 = v46 + 1

    for i = 0, v45 - 1 do
        local v48 = buffer.readu8(p29, i)

        if v48 > 31 then
            if v48 == QuoteChar or v48 == 92 then
                buffer.writeu16(Buf, v47, bit32.lshift(v48, 8) + 92)
                v47 += 2
            else
                buffer.writeu8(Buf, v47, v48)
                v47 += 1
            end
        else
            local v50 = t1[v48]

            if v50 < 0 then
                v50 = -v50
                buffer.writeu32(Buf, v47, 808482140)
                v47 += 4
            end

            buffer.writeu16(Buf, v47, v50)
            v47 += 2
        end
    end

    buffer.writeu8(Buf, v47, QuoteChar)
    p28.Pos = v47 + 1
end

local function EncodeAny(p30, p31) -- line: 304
    local v51 = if p31 == p30.Null then nil else p31

    p30.Encoders[typeof(v51)](p30, v51)
end

local function EncodeArray(p32, p33) -- line: 311
    -- upvalues: Reserve (copy)
    local Pretty = p32.Pretty
    local v52 = Reserve(p32, 1)

    buffer.writeu8(p32.Buf, v52, 91)

    if Pretty then
        p32.Indent += 1
    end

    for v53, v54 in ipairs(p33) do
        if v53 > 1 then
            local v55 = Reserve(p32, 1)

            buffer.writeu8(p32.Buf, v55, 44)
        end

        if Pretty then
            local v56 = Reserve(p32, 1)

            buffer.writeu8(p32.Buf, v56, 10)

            local v57 = p32.Indent * 2
            local v58 = Reserve(p32, v57)
            local Buf2 = p32.Buf

            for i = 0, v57 - 1 do
                buffer.writeu16(Buf2, v58 + i * 2, 8224)
            end
        end

        local v60 = if v54 == p32.Null then nil else v54

        p32.Encoders[typeof(v60)](p32, v60)
    end

    if Pretty then
        p32.Indent += -1

        if #p33 > 0 then
            local v61 = Reserve(p32, 1)

            buffer.writeu8(p32.Buf, v61, 10)

            local v62 = p32.Indent * 2
            local v63 = Reserve(p32, v62)
            local Buf2 = p32.Buf

            for i = 0, v62 - 1 do
                buffer.writeu16(Buf2, v63 + i * 2, 8224)
            end
        end
    end

    local v65 = Reserve(p32, 1)

    buffer.writeu8(p32.Buf, v65, 93)
end

local function EncodeMap(p34, p35) -- line: 338
    -- upvalues: Reserve (copy), EncodeString (copy)
    local t4 = {}

    for v66, _ in pairs(p35) do
        assert(type(v66) == "string")
        table.insert(t4, v66)
    end

    table.sort(t4)

    local Pretty, UnquoteIdent = p34.Pretty, p34.UnquoteIdent
    local v68 = Reserve(p34, 1)

    buffer.writeu8(p34.Buf, v68, 123)

    if Pretty then
        p34.Indent += 1
    end

    for v69, v70 in ipairs(t4) do
        if v69 > 1 then
            local v71 = Reserve(p34, 1)

            buffer.writeu8(p34.Buf, v71, 44)
        end

        if Pretty then
            local v72 = Reserve(p34, 1)

            buffer.writeu8(p34.Buf, v72, 10)

            local v73 = p34.Indent * 2
            local v74 = Reserve(p34, v73)
            local Buf2 = p34.Buf

            for i = 0, v73 - 1 do
                buffer.writeu16(Buf2, v74 + i * 2, 8224)
            end
        end

        EncodeString(p34, v70, UnquoteIdent)

        if Pretty then
            local v76 = Reserve(p34, 2)

            buffer.writeu16(p34.Buf, v76, 8250)
        else
            local v77 = Reserve(p34, 1)

            buffer.writeu8(p34.Buf, v77, 58)
        end

        local v78 = p35[v70]

        if v78 == p34.Null then
            v78 = nil
        end

        p34.Encoders[typeof(v78)](p34, v78)
    end

    if Pretty then
        p34.Indent += -1

        if #t4 > 0 then
            local v79 = Reserve(p34, 1)

            buffer.writeu8(p34.Buf, v79, 10)

            local v80 = p34.Indent * 2
            local v81 = Reserve(p34, v80)
            local Buf2 = p34.Buf

            for i = 0, v80 - 1 do
                buffer.writeu16(Buf2, v81 + i * 2, 8224)
            end
        end
    end

    local v83 = Reserve(p34, 1)

    buffer.writeu8(p34.Buf, v83, 125)
end

local function EncodeTable(p36, p37) -- line: 377
    -- upvalues: EncodeArray (copy), EncodeMap (copy)
    if #p37 > 0 or next(p37) == nil then
        EncodeArray(p36, p37)
    else
        EncodeMap(p36, p37)
    end
end

local function EncodeVector2(p38, p39) -- line: 386
    -- upvalues: EncodeArray (copy)
    EncodeArray(p38, {
        p39.X,
        p39.Y
    })
end

local function EncodeVector3(p40, p41) -- line: 390
    -- upvalues: EncodeArray (copy)
    EncodeArray(p40, {
        p41.X,
        p41.Y,
        p41.Z
    })
end

local function EncodeVector2int16(p42, p43) -- line: 394
    -- upvalues: EncodeArray (copy)
    EncodeArray(p42, {
        p43.X,
        p43.Y
    })
end

local function EncodeVector3int16(p44, p45) -- line: 398
    -- upvalues: EncodeArray (copy)
    EncodeArray(p44, {
        p45.X,
        p45.Y,
        p45.Z
    })
end

local function EncodeRegion3(p46, p47) -- line: 402
    -- upvalues: EncodeArray (copy)
    local v84 = p47.CFrame * (p47.Size * -0.5)
    local v85 = p47.CFrame * (p47.Size * 0.5)

    EncodeArray(p46, {
        v84.X,
        v84.Y,
        v84.Z,
        v85.X,
        v85.Y,
        v85.Z
    })
end

local function EncodeRegion3int16(p48, p49) -- line: 408
    -- upvalues: EncodeArray (copy)
    EncodeArray(p48, {
        p49.Min.X,
        p49.Min.Y,
        p49.Min.Z,
        p49.Max.X,
        p49.Max.Y,
        p49.Max.Z
    })
end

local function EncodeUDim(p50, p51) -- line: 412
    -- upvalues: EncodeArray (copy)
    EncodeArray(p50, {
        p51.Scale,
        p51.Offset
    })
end

local function EncodeUDim2(p52, p53) -- line: 416
    -- upvalues: EncodeArray (copy)
    EncodeArray(p52, {
        p53.X.Scale,
        p53.X.Offset,
        p53.Y.Scale,
        p53.Y.Offset
    })
end

local function EncodeCFrame(p54, p55) -- line: 420
    -- upvalues: EncodeArray (copy)
    EncodeArray(p54, { p55:GetComponents() })
end

local function EncodeColor3(p56, p57) -- line: 424
    -- upvalues: EncodeArray (copy)
    EncodeArray(p56, {
        math.round(p57.R * 255),
        math.round(p57.G * 255),
        (math.round(p57.B * 255))
    })
end

local function EncodeNumberRange(p58, p59) -- line: 432
    -- upvalues: EncodeArray (copy)
    EncodeArray(p58, {
        p59.Min,
        p59.Max
    })
end

local function EncodeRect(p60, p61) -- line: 436
    -- upvalues: EncodeArray (copy)
    EncodeArray(p60, {
        p61.Min.X,
        p61.Min.Y,
        p61.Max.X,
        p61.Max.Y
    })
end

local function EncodeEnumItem(p62, p63) -- line: 440
    -- upvalues: EncodeNumber (copy)
    EncodeNumber(p62, p63.Value)
end

local t5 = {}

t5["nil"] = EncodeNull
t5.boolean = EncodeBoolean
t5.number = EncodeNumber
t5.string = EncodeString
t5.buffer = EncodeBuffer
t5.table = EncodeTable

local v91 = table.clone(t5)

v91.Vector2 = EncodeVector2
v91.Vector3 = EncodeVector3
v91.Vector2int16 = EncodeVector2int16
v91.Vector3int16 = EncodeVector3int16
v91.Region3 = EncodeRegion3
v91.Region3int16 = EncodeRegion3int16
v91.UDim = EncodeUDim
v91.UDim2 = EncodeUDim2
v91.CFrame = EncodeCFrame
v91.Color3 = EncodeColor3
v91.NumberRange = EncodeNumberRange
v91.Rect = EncodeRect
v91.EnumItem = EncodeEnumItem

local v92 = buffer.create(4096)
local v93 = Stream(v92)

v93.Encoders = t5

local function Compact(p64, p65) -- line: 473
    -- upvalues: ToString (copy), v93 (copy)
    v93.Pos = 0
    v93.Null = p65

    local v94 = if p64 == v93.Null then nil else p64

    v93.Encoders[typeof(v94)](v93, v94)

    return ToString(v93)
end

local v95 = Stream(v92)

v95.Encoders = t5
v95.Pretty = true

local function Pretty(p66, p67) -- line: 484
    -- upvalues: ToString (copy), v95 (copy)
    v95.Pos = 0
    v95.Indent = 0
    v95.Null = p67

    local v96 = if p66 == v95.Null then nil else p66

    v95.Encoders[typeof(v96)](v95, v96)

    return ToString(v95)
end

local v97 = Stream(v92)

v97.Encoders = v91

local function CompactExt(p68, p69) -- line: 495
    -- upvalues: ToString (copy), v97 (copy)
    v97.Pos = 0
    v97.Null = p69

    local v98 = if p68 == v97.Null then nil else p68

    v97.Encoders[typeof(v98)](v97, v98)

    return ToString(v97)
end

local v99 = Stream(v92)

v99.Encoders = v91
v99.Pretty = true

local function PrettyExt(p70, p71) -- line: 506
    -- upvalues: ToString (copy), v99 (copy)
    v99.Pos = 0
    v99.Indent = 0
    v99.Null = p71

    local v100 = if p70 == v99.Null then nil else p70

    v99.Encoders[typeof(v100)](v99, v100)

    return ToString(v99)
end

local v101 = Stream(v92)

v101.Encoders = t5
v101.UnquoteIdent = true
v101.QuoteChar = 39

local function Compact5(p72, p73) -- line: 520
    -- upvalues: ToString (copy), v101 (copy)
    v101.Pos = 0
    v101.Null = p73

    local v102 = if p72 == v101.Null then nil else p72

    v101.Encoders[typeof(v102)](v101, v102)

    return ToString(v101)
end

local v103 = Stream(v92)

v103.Encoders = t5
v103.Pretty = true
v103.UnquoteIdent = true
v103.QuoteChar = 39

local t6 = {
    Compact = Compact,
    Pretty = Pretty,
    CompactExt = CompactExt,
    PrettyExt = PrettyExt,
    Compact5 = Compact5,
    Pretty5 = function(p74, p75) -- Pretty5 | line: 533
        -- upvalues: ToString (copy), v103 (copy)
        v103.Pos = 0
        v103.Indent = 0
        v103.Null = p75

        local v104 = if p74 == v103.Null then nil else p74

        v103.Encoders[typeof(v104)](v103, v104)

        return ToString(v103)
    end
}

return table.freeze(t6)
