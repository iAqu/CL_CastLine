-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {
    Axes = 64,
    BrickColor = 65,
    CFrame = 66,
    Color3 = 67,
    ColorSequenceKeypoint = 68,
    ColorSequence = 69,
    DateTime = 70,
    Faces = 71,
    Font = 72,
    NumberRange = 73,
    NumberSequenceKeypoint = 74,
    NumberSequence = 75,
    PhysicalProperties = 76,
    Ray = 77,
    Rect = 78,
    Region3 = 79,
    Region3int16 = 80,
    TweenInfo = 81,
    UDim = 82,
    UDim2 = 83,
    Vector2 = 84,
    Vector2int16 = 85,
    Vector3 = 86,
    Vector3int16 = 87,
    PathWaypoint = 88,
    FloatCurveKey = 89,
    RotationCurveKey = 90,
    Path2DControlPoint = 91,
    Enum = 14,
    EnumItem = 15
}
local v1 = buffer.create(256)
local n1 = 0
local n2 = 256
local t3, v2
local v3 = buffer.create(0)
local n3 = 0

local function ru8() -- line: 248
    -- upvalues: v3 (ref), n3 (ref)
    local v6 = buffer.readu8(v3, n3)

    n3 += 1

    return v6
end

local function ru16() -- line: 254
    -- upvalues: v3 (ref), n3 (ref)
    local v9 = buffer.readu16(v3, n3)

    n3 += 2

    return v9
end

local function ru32() -- line: 260
    -- upvalues: v3 (ref), n3 (ref)
    local v12 = buffer.readu32(v3, n3)

    n3 += 4

    return v12
end

local function ri8() -- line: 266
    -- upvalues: v3 (ref), n3 (ref)
    local v15 = buffer.readi8(v3, n3)

    n3 += 1

    return v15
end

local function ri16() -- line: 272
    -- upvalues: v3 (ref), n3 (ref)
    local v18 = buffer.readi16(v3, n3)

    n3 += 2

    return v18
end

local function ri32() -- line: 278
    -- upvalues: v3 (ref), n3 (ref)
    local v21 = buffer.readi32(v3, n3)

    n3 += 4

    return v21
end

local function rf32() -- line: 284
    -- upvalues: v3 (ref), n3 (ref)
    local v24 = buffer.readf32(v3, n3)

    n3 += 4

    return v24
end

local function rf64() -- line: 290
    -- upvalues: v3 (ref), n3 (ref)
    local v27 = buffer.readf64(v3, n3)

    n3 += 8

    return v27
end

local function rstr(p1) -- line: 296
    -- upvalues: v3 (ref), n3 (ref)
    local v28 = buffer.readstring(v3, n3, p1)

    n3 += p1

    return v28
end

local function rlstr() -- line: 302
    -- upvalues: v3 (ref), n3 (ref)
    local v31 = buffer.readu32(v3, n3)

    n3 += 4

    if v31 == 0 then
        return ""
    end

    local v32 = buffer.readstring(v3, n3, v31)

    n3 += v31

    return v32
end

local v33, v34
local t5 = {}
local t4 = {}

t4[0] = function() -- line: 319
end

t4[1] = function() -- line: 320
end

t4[2] = function() -- line: 321
end

t4[3] = function(p2) -- line: 322
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 1 > n2 then
        local v35 = n1 + 1
        local v36 = n2

        repeat
            v36 *= 2
        until v35 <= v36

        local v37 = buffer.create(v36)

        buffer.copy(v37, 0, v1, 0, n1)
        v1 = v37
        n2 = v36
    end

    buffer.writeu8(v1, n1, p2)
    n1 += 1
end

t4[4] = function(p3) -- line: 325
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 2 > n2 then
        local v40 = n1 + 2
        local v41 = n2

        repeat
            v41 *= 2
        until v40 <= v41

        local v42 = buffer.create(v41)

        buffer.copy(v42, 0, v1, 0, n1)
        v1 = v42
        n2 = v41
    end

    buffer.writeu16(v1, n1, p3)
    n1 += 2
end

t4[5] = function(p4) -- line: 328
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 4 > n2 then
        local v45 = n1 + 4
        local v46 = n2

        repeat
            v46 *= 2
        until v45 <= v46

        local v47 = buffer.create(v46)

        buffer.copy(v47, 0, v1, 0, n1)
        v1 = v47
        n2 = v46
    end

    buffer.writeu32(v1, n1, p4)
    n1 += 4
end

t4[6] = function(p5) -- line: 331
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 1 > n2 then
        local v50 = n1 + 1
        local v51 = n2

        repeat
            v51 *= 2
        until v50 <= v51

        local v52 = buffer.create(v51)

        buffer.copy(v52, 0, v1, 0, n1)
        v1 = v52
        n2 = v51
    end

    local v53 = v1
    local v54 = n1

    buffer.writei8(v53, v54, p5)
    n1 += 1
end

t4[7] = function(p6) -- line: 334
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 2 > n2 then
        local v55 = n1 + 2
        local v56 = n2

        repeat
            v56 *= 2
        until v55 <= v56

        local v57 = buffer.create(v56)

        buffer.copy(v57, 0, v1, 0, n1)
        v1 = v57
        n2 = v56
    end

    local v58 = v1
    local v59 = n1

    buffer.writei16(v58, v59, p6)
    n1 += 2
end

t4[8] = function(p7) -- line: 337
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 4 > n2 then
        local v60 = n1 + 4
        local v61 = n2

        repeat
            v61 *= 2
        until v60 <= v61

        local v62 = buffer.create(v61)

        buffer.copy(v62, 0, v1, 0, n1)
        v1 = v62
        n2 = v61
    end

    local v63 = v1
    local v64 = n1

    buffer.writei32(v63, v64, p7)
    n1 += 4
end

t4[9] = function(p8) -- line: 340
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 8 > n2 then
        local v65 = n1 + 8
        local v66 = n2

        repeat
            v66 *= 2
        until v65 <= v66

        local v67 = buffer.create(v66)

        buffer.copy(v67, 0, v1, 0, n1)
        v1 = v67
        n2 = v66
    end

    buffer.writef64(v1, n1, p8)
    n1 += 8
end

t4[10] = function(p9) -- line: 344
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v70 = #p9

    if n1 + 1 > n2 then
        local v71 = n1 + 1
        local v72 = n2

        repeat
            v72 *= 2
        until v71 <= v72

        local v73 = buffer.create(v72)

        buffer.copy(v73, 0, v1, 0, n1)
        v1 = v73
        n2 = v72
    end

    buffer.writeu8(v1, n1, v70)
    n1 += 1

    local v76 = #p9

    if n1 + v76 > n2 then
        local v77 = n1 + v76
        local v78 = n2

        repeat
            v78 *= 2
        until v77 <= v78

        local v79 = buffer.create(v78)

        buffer.copy(v79, 0, v1, 0, n1)
        v1 = v79
        n2 = v78
    end

    buffer.writestring(v1, n1, p9)
    n1 += v76
end

t4[11] = function(p10) -- line: 350
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v80 = #p10

    if n1 + 2 > n2 then
        local v81 = n1 + 2
        local v82 = n2

        repeat
            v82 *= 2
        until v81 <= v82

        local v83 = buffer.create(v82)

        buffer.copy(v83, 0, v1, 0, n1)
        v1 = v83
        n2 = v82
    end

    buffer.writeu16(v1, n1, v80)
    n1 += 2

    local v86 = #p10

    if n1 + v86 > n2 then
        local v87 = n1 + v86
        local v88 = n2

        repeat
            v88 *= 2
        until v87 <= v88

        local v89 = buffer.create(v88)

        buffer.copy(v89, 0, v1, 0, n1)
        v1 = v89
        n2 = v88
    end

    buffer.writestring(v1, n1, p10)
    n1 += v86
end

t4[12] = function(p11) -- line: 356
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v90 = #p11

    if n1 + 4 > n2 then
        local v91 = n1 + 4
        local v92 = n2

        repeat
            v92 *= 2
        until v91 <= v92

        local v93 = buffer.create(v92)

        buffer.copy(v93, 0, v1, 0, n1)
        v1 = v93
        n2 = v92
    end

    buffer.writeu32(v1, n1, v90)
    n1 += 4

    local v96 = #p11

    if n1 + v96 > n2 then
        local v97 = n1 + v96
        local v98 = n2

        repeat
            v98 *= 2
        until v97 <= v98

        local v99 = buffer.create(v98)

        buffer.copy(v99, 0, v1, 0, n1)
        v1 = v99
        n2 = v98
    end

    buffer.writestring(v1, n1, p11)
    n1 += v96
end

t4[13] = function(p12) -- line: 362
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v100 = buffer.len(p12)

    if n1 + 4 > n2 then
        local v101 = n1 + 4
        local v102 = n2

        repeat
            v102 *= 2
        until v101 <= v102

        local v103 = buffer.create(v102)

        buffer.copy(v103, 0, v1, 0, n1)
        v1 = v103
        n2 = v102
    end

    buffer.writeu32(v1, n1, v100)
    n1 += 4

    if n1 + v100 > n2 then
        local v106 = n1 + v100
        local v107 = n2

        repeat
            v107 *= 2
        until v106 <= v107

        local v108 = buffer.create(v107)

        buffer.copy(v108, 0, v1, 0, n1)
        v1 = v108
        n2 = v107
    end

    buffer.copy(v1, n1, p12, 0, v100)
    n1 += v100
end

t5[0] = function() -- line: 371
    return nil
end

t5[1] = function() -- line: 374
    return false
end

t5[2] = function() -- line: 377
    return true
end

t5[3] = ru8
t5[4] = ru16
t5[5] = ru32
t5[6] = ri8
t5[7] = ri16
t5[8] = ri32
t5[9] = rf64

t5[10] = function() -- line: 388
    -- upvalues: v3 (ref), n3 (ref)
    local v111 = buffer.readu8(v3, n3)

    n3 += 1

    if v111 == 0 then
        return ""
    end

    local v112 = buffer.readstring(v3, n3, v111)

    n3 += v111

    return v112
end

t5[11] = function() -- line: 396
    -- upvalues: v3 (ref), n3 (ref)
    local v115 = buffer.readu16(v3, n3)

    n3 += 2

    if v115 == 0 then
        return ""
    end

    local v116 = buffer.readstring(v3, n3, v115)

    n3 += v115

    return v116
end

t5[12] = function() -- line: 404
    -- upvalues: v3 (ref), n3 (ref)
    local v119 = buffer.readu32(v3, n3)

    n3 += 4

    if v119 == 0 then
        return ""
    end

    local v120 = buffer.readstring(v3, n3, v119)

    n3 += v119

    return v120
end

t5[13] = function() -- line: 412
    -- upvalues: v3 (ref), n3 (ref)
    local v123 = buffer.readu32(v3, n3)

    n3 += 4

    local v124 = buffer.create(v123)

    buffer.copy(v124, 0, v3, n3, v123)
    n3 += v123

    return v124
end

t4[14] = function(p13) -- line: 421
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v125 = tostring(p13)
    local v126 = #v125

    if n1 + 4 > n2 then
        local v127 = n1 + 4
        local v128 = n2

        repeat
            v128 *= 2
        until v127 <= v128

        local v129 = buffer.create(v128)

        buffer.copy(v129, 0, v1, 0, n1)
        v1 = v129
        n2 = v128
    end

    buffer.writeu32(v1, n1, v126)
    n1 += 4

    if not (v126 > 0) then
        return
    end

    local v132 = #v125

    if n1 + v132 > n2 then
        local v133 = n1 + v132
        local v134 = n2

        repeat
            v134 *= 2
        until v133 <= v134

        local v135 = buffer.create(v134)

        buffer.copy(v135, 0, v1, 0, n1)
        v1 = v135
        n2 = v134
    end

    buffer.writestring(v1, n1, v125)
    n1 += v132
end

t4[15] = function(p14) -- line: 425
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v136 = tostring(p14.EnumType)
    local v137 = #v136

    if n1 + 4 > n2 then
        local v138 = n1 + 4
        local v139 = n2

        repeat
            v139 *= 2
        until v138 <= v139

        local v140 = buffer.create(v139)

        buffer.copy(v140, 0, v1, 0, n1)
        v1 = v140
        n2 = v139
    end

    buffer.writeu32(v1, n1, v137)
    n1 += 4

    if v137 > 0 then
        local v143 = #v136

        if n1 + v143 > n2 then
            local v144 = n1 + v143
            local v145 = n2

            repeat
                v145 *= 2
            until v144 <= v145

            local v146 = buffer.create(v145)

            buffer.copy(v146, 0, v1, 0, n1)
            v1 = v146
            n2 = v145
        end

        buffer.writestring(v1, n1, v136)
        n1 += v143
    end

    local Value = p14.Value

    if n1 + 4 > n2 then
        local v147 = n1 + 4
        local v148 = n2

        repeat
            v148 *= 2
        until v147 <= v148

        local v149 = buffer.create(v148)

        buffer.copy(v149, 0, v1, 0, n1)
        v1 = v149
        n2 = v148
    end

    local v150 = v1
    local v151 = n1

    buffer.writei32(v150, v151, Value)
    n1 += 4
end

t5[14] = function() -- line: 430
    -- upvalues: v3 (ref), n3 (ref)
    local _Enum = Enum
    local v154 = buffer.readu32(v3, n3)

    n3 += 4

    local v155

    if v154 == 0 then
        v155 = ""
    else
        v155 = buffer.readstring(v3, n3, v154)
        n3 += v154
    end

    return _Enum[v155]
end

t5[15] = function() -- line: 434
    -- upvalues: v3 (ref), n3 (ref)
    local _Enum = Enum
    local v158 = buffer.readu32(v3, n3)

    n3 += 4

    local v159

    if v158 == 0 then
        v159 = ""
    else
        v159 = buffer.readstring(v3, n3, v158)
        n3 += v158
    end

    local v160 = _Enum[v159]
    local v163 = buffer.readi32(v3, n3)

    n3 += 4

    return v160:FromValue(v163)
end

t4[92] = function(p15) -- line: 440
    -- upvalues: v1 (ref), n1 (ref), n2 (ref), t3 (ref)
    if not t3 then
        error("Buff: Instance serialization requires enableInstances=true in encode()")
    end

    table.insert(t3, p15)

    local v164 = #t3

    if n1 + 4 > n2 then
        local v165 = n1 + 4
        local v166 = n2

        repeat
            v166 *= 2
        until v165 <= v166

        local v167 = buffer.create(v166)

        buffer.copy(v167, 0, v1, 0, n1)
        v1 = v167
        n2 = v166
    end

    buffer.writeu32(v1, n1, v164)
    n1 += 4
end

t5[92] = function() -- line: 448
    -- upvalues: v2 (ref), v3 (ref), n3 (ref)
    local v172 = buffer.readu32(v3, n3)

    n3 += 4

    if not v2 then
        error("Buff: buffer contains Instance refs but no instances array was provided to decode()")
    end

    return v2[v172]
end

t4[64] = function(p16) -- line: 458
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v173 = if p16.X then 0 + 1 else 0

    if p16.Y then
        v173 += 2
    end

    if p16.Z then
        v173 += 4
    end

    if n1 + 1 > n2 then
        local v174 = n1 + 1
        local v175 = n2

        repeat
            v175 *= 2
        until v174 <= v175

        local v176 = buffer.create(v175)

        buffer.copy(v176, 0, v1, 0, n1)
        v1 = v176
        n2 = v175
    end

    buffer.writeu8(v1, n1, v173)
    n1 += 1
end

t5[64] = function() -- line: 472
    -- upvalues: v3 (ref), n3 (ref)
    local v181 = buffer.readu8(v3, n3)

    n3 += 1

    local t7 = {}

    if bit32.band(v181, 1) ~= 0 then
        table.insert(t7, Enum.Axis.X)
    end

    if bit32.band(v181, 2) ~= 0 then
        table.insert(t7, Enum.Axis.Y)
    end

    if bit32.band(v181, 4) ~= 0 then
        table.insert(t7, Enum.Axis.Z)
    end

    return Axes.new(table.unpack(t7))
end

t4[65] = function(p17) -- line: 488
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local Number = p17.Number

    if n1 + 2 > n2 then
        local v182 = n1 + 2
        local v183 = n2

        repeat
            v183 *= 2
        until v182 <= v183

        local v184 = buffer.create(v183)

        buffer.copy(v184, 0, v1, 0, n1)
        v1 = v184
        n2 = v183
    end

    buffer.writeu16(v1, n1, Number)
    n1 += 2
end

t5[65] = function() -- line: 491
    -- upvalues: v3 (ref), n3 (ref)
    local new = BrickColor.new
    local v189 = buffer.readu16(v3, n3)

    n3 += 2

    return new(v189)
end

t4[66] = function(p18) -- line: 496
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 48 > n2 then
        local v190 = n1 + 48
        local v191 = n2

        repeat
            v191 *= 2
        until v190 <= v191

        local v192 = buffer.create(v191)

        buffer.copy(v192, 0, v1, 0, n1)
        v1 = v192
        n2 = v191
    end

    local v193 = n1
    local v194 = v1
    local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p18:GetComponents()

    buffer.writef32(v194, v193, Components)
    buffer.writef32(v194, v193 + 4, Components2)
    buffer.writef32(v194, v193 + 8, Components3)
    buffer.writef32(v194, v193 + 12, Components4)
    buffer.writef32(v194, v193 + 16, Components5)
    buffer.writef32(v194, v193 + 20, Components6)
    buffer.writef32(v194, v193 + 24, Components7)
    buffer.writef32(v194, v193 + 28, Components8)
    buffer.writef32(v194, v193 + 32, Components9)
    buffer.writef32(v194, v193 + 36, Components10)
    buffer.writef32(v194, v193 + 40, Components11)
    buffer.writef32(v194, v193 + 44, Components12)
    n1 = v193 + 48
end

t5[66] = function() -- line: 516
    -- upvalues: v3 (ref), n3 (ref)
    local v206 = n3
    local v207 = v3
    local v230 = CFrame.new(buffer.readf32(v207, v206), buffer.readf32(v207, v206 + 4), buffer.readf32(v207, v206 + 8), buffer.readf32(v207, v206 + 12), buffer.readf32(v207, v206 + 16), buffer.readf32(v207, v206 + 20), buffer.readf32(v207, v206 + 24), buffer.readf32(v207, v206 + 28), buffer.readf32(v207, v206 + 32), buffer.readf32(v207, v206 + 36), buffer.readf32(v207, v206 + 40), (buffer.readf32(v207, v206 + 44)))

    n3 = v206 + 48

    return v230
end

t4[67] = function(p19) -- line: 538
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 12 > n2 then
        local v231 = n1 + 12
        local v232 = n2

        repeat
            v232 *= 2
        until v231 <= v232

        local v233 = buffer.create(v232)

        buffer.copy(v233, 0, v1, 0, n1)
        v1 = v233
        n2 = v232
    end

    local v234 = n1
    local v235 = v1

    buffer.writef32(v235, v234, p19.R)

    local v236 = v1

    buffer.writef32(v236, v234 + 4, p19.G)

    local v238 = v1

    buffer.writef32(v238, v234 + 8, p19.B)
    n1 = v234 + 12
end

t5[67] = function() -- line: 547
    -- upvalues: v3 (ref), n3 (ref)
    local v240 = n3
    local new = Color3.new
    local v242 = buffer.readf32(v3, v240)
    local v243 = v3
    local v245 = buffer.readf32(v243, v240 + 4)
    local v246 = v3
    local v248 = new(v242, v245, (buffer.readf32(v246, v240 + 8)))

    n3 = v240 + 12

    return v248
end

t4[68] = function(p20) -- line: 555
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 16 > n2 then
        local v249 = n1 + 16
        local v250 = n2

        repeat
            v250 *= 2
        until v249 <= v250

        local v251 = buffer.create(v250)

        buffer.copy(v251, 0, v1, 0, n1)
        v1 = v251
        n2 = v250
    end

    local v252 = n1
    local v253 = v1

    buffer.writef32(v253, v252, p20.Time)

    local v254 = v1

    buffer.writef32(v254, v252 + 4, p20.Value.R)

    local v256 = v1

    buffer.writef32(v256, v252 + 8, p20.Value.G)

    local v258 = v1

    buffer.writef32(v258, v252 + 12, p20.Value.B)
    n1 = v252 + 16
end

t5[68] = function() -- line: 565
    -- upvalues: v3 (ref), n3 (ref)
    local v260 = n3
    local v261 = v3
    local v268 = ColorSequenceKeypoint.new(buffer.readf32(v261, v260), Color3.new(buffer.readf32(v261, v260 + 4), buffer.readf32(v261, v260 + 8), (buffer.readf32(v261, v260 + 12))))

    n3 = v260 + 16

    return v268
end

t4[69] = function(p21) -- line: 577
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local Keypoints = p21.Keypoints
    local v269 = #Keypoints

    if n1 + 4 > n2 then
        local v270 = n1 + 4
        local v271 = n2

        repeat
            v271 *= 2
        until v270 <= v271

        local v272 = buffer.create(v271)

        buffer.copy(v272, 0, v1, 0, n1)
        v1 = v272
        n2 = v271
    end

    buffer.writeu32(v1, n1, v269)
    n1 += 4

    local v275 = v269 * 16

    if n1 + v275 > n2 then
        local v276 = n1 + v275
        local v277 = n2

        repeat
            v277 *= 2
        until v276 <= v277

        local v278 = buffer.create(v277)

        buffer.copy(v278, 0, v1, 0, n1)
        v1 = v278
        n2 = v277
    end

    for i = 1, v269 do
        local v279 = Keypoints[i]
        local v280 = n1
        local v281 = v1

        buffer.writef32(v281, v280, v279.Time)

        local v282 = v1

        buffer.writef32(v282, v280 + 4, v279.Value.R)

        local v284 = v1

        buffer.writef32(v284, v280 + 8, v279.Value.G)

        local v286 = v1

        buffer.writef32(v286, v280 + 12, v279.Value.B)
        n1 = v280 + 16
    end
end

t5[69] = function() -- line: 593
    -- upvalues: v3 (ref), n3 (ref)
    local v290 = buffer.readu32(v3, n3)

    n3 += 4

    local v291 = table.create(v290)

    for i = 1, v290 do
        local v292 = n3
        local v293 = v3

        v291[i] = ColorSequenceKeypoint.new(buffer.readf32(v293, v292), Color3.new(buffer.readf32(v293, v292 + 4), buffer.readf32(v293, v292 + 8), (buffer.readf32(v293, v292 + 12))))
        n3 = v292 + 16
    end

    return ColorSequence.new(v291)
end

t4[70] = function(p22) -- line: 609
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local UnixTimestampMillis = p22.UnixTimestampMillis

    if n1 + 8 > n2 then
        local v300 = n1 + 8
        local v301 = n2

        repeat
            v301 *= 2
        until v300 <= v301

        local v302 = buffer.create(v301)

        buffer.copy(v302, 0, v1, 0, n1)
        v1 = v302
        n2 = v301
    end

    buffer.writef64(v1, n1, UnixTimestampMillis)
    n1 += 8
end

t5[70] = function() -- line: 612
    -- upvalues: v3 (ref), n3 (ref)
    local fromUnixTimestampMillis = DateTime.fromUnixTimestampMillis
    local v307 = buffer.readf64(v3, n3)

    n3 += 8

    return fromUnixTimestampMillis(v307)
end

t4[71] = function(p23) -- line: 617
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local v308 = if p23.Top then 0 + 1 else 0

    if p23.Bottom then
        v308 += 2
    end

    if p23.Left then
        v308 += 4
    end

    if p23.Right then
        v308 += 8
    end

    if p23.Front then
        v308 += 16
    end

    if p23.Back then
        v308 += 32
    end

    if n1 + 1 > n2 then
        local v309 = n1 + 1
        local v310 = n2

        repeat
            v310 *= 2
        until v309 <= v310

        local v311 = buffer.create(v310)

        buffer.copy(v311, 0, v1, 0, n1)
        v1 = v311
        n2 = v310
    end

    buffer.writeu8(v1, n1, v308)
    n1 += 1
end

t5[71] = function() -- line: 640
    -- upvalues: v3 (ref), n3 (ref)
    local v316 = buffer.readu8(v3, n3)

    n3 += 1

    local t8 = {}

    if bit32.band(v316, 1) ~= 0 then
        table.insert(t8, Enum.NormalId.Top)
    end

    if bit32.band(v316, 2) ~= 0 then
        table.insert(t8, Enum.NormalId.Bottom)
    end

    if bit32.band(v316, 4) ~= 0 then
        table.insert(t8, Enum.NormalId.Left)
    end

    if bit32.band(v316, 8) ~= 0 then
        table.insert(t8, Enum.NormalId.Right)
    end

    if bit32.band(v316, 16) ~= 0 then
        table.insert(t8, Enum.NormalId.Front)
    end

    if bit32.band(v316, 32) ~= 0 then
        table.insert(t8, Enum.NormalId.Back)
    end

    return Faces.new(table.unpack(t8))
end

t4[72] = function(p24) -- line: 665
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local Family = p24.Family
    local v317 = #Family

    if n1 + 4 > n2 then
        local v318 = n1 + 4
        local v319 = n2

        repeat
            v319 *= 2
        until v318 <= v319

        local v320 = buffer.create(v319)

        buffer.copy(v320, 0, v1, 0, n1)
        v1 = v320
        n2 = v319
    end

    buffer.writeu32(v1, n1, v317)
    n1 += 4

    if v317 > 0 then
        local v323 = #Family

        if n1 + v323 > n2 then
            local v324 = n1 + v323
            local v325 = n2

            repeat
                v325 *= 2
            until v324 <= v325

            local v326 = buffer.create(v325)

            buffer.copy(v326, 0, v1, 0, n1)
            v1 = v326
            n2 = v325
        end

        buffer.writestring(v1, n1, Family)
        n1 += v323
    end

    local Value = p24.Weight.Value

    if n1 + 4 > n2 then
        local v327 = n1 + 4
        local v328 = n2

        repeat
            v328 *= 2
        until v327 <= v328

        local v329 = buffer.create(v328)

        buffer.copy(v329, 0, v1, 0, n1)
        v1 = v329
        n2 = v328
    end

    buffer.writeu32(v1, n1, Value)
    n1 += 4

    local Value2 = p24.Style.Value

    if n1 + 4 > n2 then
        local v332 = n1 + 4
        local v333 = n2

        repeat
            v333 *= 2
        until v332 <= v333

        local v334 = buffer.create(v333)

        buffer.copy(v334, 0, v1, 0, n1)
        v1 = v334
        n2 = v333
    end

    buffer.writeu32(v1, n1, Value2)
    n1 += 4
end

t5[72] = function() -- line: 671
    -- upvalues: v3 (ref), n3 (ref)
    local v339 = buffer.readu32(v3, n3)

    n3 += 4

    local v340

    if v339 == 0 then
        v340 = ""
    else
        v340 = buffer.readstring(v3, n3, v339)
        n3 += v339
    end

    local FontWeight = Enum.FontWeight
    local v343 = buffer.readu32(v3, n3)

    n3 += 4

    local v344 = FontWeight:FromValue(v343)
    local FontStyle = Enum.FontStyle
    local v347 = buffer.readu32(v3, n3)

    n3 += 4

    local v348 = FontStyle:FromValue(v347)

    return Font.new(v340, v344, v348)
end

t4[73] = function(p25) -- line: 679
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 8 > n2 then
        local v349 = n1 + 8
        local v350 = n2

        repeat
            v350 *= 2
        until v349 <= v350

        local v351 = buffer.create(v350)

        buffer.copy(v351, 0, v1, 0, n1)
        v1 = v351
        n2 = v350
    end

    local v352 = v1
    local v353 = n1

    buffer.writef32(v352, v353, p25.Min)

    local v354 = v1

    buffer.writef32(v354, n1 + 4, p25.Max)
    n1 += 8
end

t5[73] = function() -- line: 686
    -- upvalues: v3 (ref), n3 (ref)
    local v358 = buffer.readf32(v3, n3)
    local v359 = v3
    local v361 = buffer.readf32(v359, n3 + 4)

    n3 += 8

    return NumberRange.new(v358, v361)
end

t4[74] = function(p26) -- line: 694
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 12 > n2 then
        local v362 = n1 + 12
        local v363 = n2

        repeat
            v363 *= 2
        until v362 <= v363

        local v364 = buffer.create(v363)

        buffer.copy(v364, 0, v1, 0, n1)
        v1 = v364
        n2 = v363
    end

    local v365 = n1
    local v366 = v1

    buffer.writef32(v366, v365, p26.Time)

    local v367 = v1

    buffer.writef32(v367, v365 + 4, p26.Value)

    local v369 = v1

    buffer.writef32(v369, v365 + 8, p26.Envelope)
    n1 = v365 + 12
end

t5[74] = function() -- line: 703
    -- upvalues: v3 (ref), n3 (ref)
    local v371 = n3
    local v372 = v3
    local v377 = NumberSequenceKeypoint.new(buffer.readf32(v372, v371), buffer.readf32(v372, v371 + 4), (buffer.readf32(v372, v371 + 8)))

    n3 = v371 + 12

    return v377
end

t4[75] = function(p27) -- line: 712
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    local Keypoints = p27.Keypoints
    local v378 = #Keypoints

    if n1 + 4 > n2 then
        local v379 = n1 + 4
        local v380 = n2

        repeat
            v380 *= 2
        until v379 <= v380

        local v381 = buffer.create(v380)

        buffer.copy(v381, 0, v1, 0, n1)
        v1 = v381
        n2 = v380
    end

    buffer.writeu32(v1, n1, v378)
    n1 += 4

    local v384 = v378 * 12

    if n1 + v384 > n2 then
        local v385 = n1 + v384
        local v386 = n2

        repeat
            v386 *= 2
        until v385 <= v386

        local v387 = buffer.create(v386)

        buffer.copy(v387, 0, v1, 0, n1)
        v1 = v387
        n2 = v386
    end

    for i = 1, v378 do
        local v388 = Keypoints[i]
        local v389 = n1
        local v390 = v1

        buffer.writef32(v390, v389, v388.Time)

        local v391 = v1

        buffer.writef32(v391, v389 + 4, v388.Value)

        local v393 = v1

        buffer.writef32(v393, v389 + 8, v388.Envelope)
        n1 = v389 + 12
    end
end

t5[75] = function() -- line: 727
    -- upvalues: v3 (ref), n3 (ref)
    local v397 = buffer.readu32(v3, n3)

    n3 += 4

    local v398 = table.create(v397)

    for i = 1, v397 do
        local v399 = n3
        local v400 = v3

        v398[i] = NumberSequenceKeypoint.new(buffer.readf32(v400, v399), buffer.readf32(v400, v399 + 4), (buffer.readf32(v400, v399 + 8)))
        n3 = v399 + 12
    end

    return NumberSequence.new(v398)
end

t4[76] = function(p28) -- line: 740
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 20 > n2 then
        local v405 = n1 + 20
        local v406 = n2

        repeat
            v406 *= 2
        until v405 <= v406

        local v407 = buffer.create(v406)

        buffer.copy(v407, 0, v1, 0, n1)
        v1 = v407
        n2 = v406
    end

    local v408 = n1
    local v409 = v1

    buffer.writef32(v409, v408, p28.Density)

    local v410 = v1

    buffer.writef32(v410, v408 + 4, p28.Friction)

    local v412 = v1

    buffer.writef32(v412, v408 + 8, p28.Elasticity)

    local v414 = v1

    buffer.writef32(v414, v408 + 12, p28.FrictionWeight)

    local v416 = v1

    buffer.writef32(v416, v408 + 16, p28.ElasticityWeight)
    n1 = v408 + 20
end

t5[76] = function() -- line: 751
    -- upvalues: v3 (ref), n3 (ref)
    local v418 = n3
    local v419 = v3
    local v428 = PhysicalProperties.new(buffer.readf32(v419, v418), buffer.readf32(v419, v418 + 4), buffer.readf32(v419, v418 + 8), buffer.readf32(v419, v418 + 12), (buffer.readf32(v419, v418 + 16)))

    n3 = v418 + 20

    return v428
end

t4[77] = function(p29) -- line: 766
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 24 > n2 then
        local v429 = n1 + 24
        local v430 = n2

        repeat
            v430 *= 2
        until v429 <= v430

        local v431 = buffer.create(v430)

        buffer.copy(v431, 0, v1, 0, n1)
        v1 = v431
        n2 = v430
    end

    local v432 = n1
    local Origin, Direction = p29.Origin, p29.Direction
    local v433 = v1

    buffer.writef32(v433, v432, Origin.X)

    local v434 = v1

    buffer.writef32(v434, v432 + 4, Origin.Y)

    local v436 = v1

    buffer.writef32(v436, v432 + 8, Origin.Z)

    local v438 = v1

    buffer.writef32(v438, v432 + 12, Direction.X)

    local v440 = v1

    buffer.writef32(v440, v432 + 16, Direction.Y)

    local v442 = v1

    buffer.writef32(v442, v432 + 20, Direction.Z)
    n1 = v432 + 24
end

t5[77] = function() -- line: 779
    -- upvalues: v3 (ref), n3 (ref)
    local v444 = n3
    local v445 = v3
    local v458 = Ray.new(Vector3.new(buffer.readf32(v445, v444), buffer.readf32(v445, v444 + 4), (buffer.readf32(v445, v444 + 8))), (Vector3.new(buffer.readf32(v445, v444 + 12), buffer.readf32(v445, v444 + 16), (buffer.readf32(v445, v444 + 20)))))

    n3 = v444 + 24

    return v458
end

t4[78] = function(p30) -- line: 791
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 16 > n2 then
        local v459 = n1 + 16
        local v460 = n2

        repeat
            v460 *= 2
        until v459 <= v460

        local v461 = buffer.create(v460)

        buffer.copy(v461, 0, v1, 0, n1)
        v1 = v461
        n2 = v460
    end

    local v462 = n1
    local v463 = v1

    buffer.writef32(v463, v462, p30.Min.X)

    local v464 = v1

    buffer.writef32(v464, v462 + 4, p30.Min.Y)

    local v466 = v1

    buffer.writef32(v466, v462 + 8, p30.Max.X)

    local v468 = v1

    buffer.writef32(v468, v462 + 12, p30.Max.Y)
    n1 = v462 + 16
end

t5[78] = function() -- line: 801
    -- upvalues: v3 (ref), n3 (ref)
    local v470 = n3
    local v471 = v3
    local v478 = Rect.new(buffer.readf32(v471, v470), buffer.readf32(v471, v470 + 4), buffer.readf32(v471, v470 + 8), (buffer.readf32(v471, v470 + 12)))

    n3 = v470 + 16

    return v478
end

t4[79] = function(p31) -- line: 811
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 24 > n2 then
        local v479 = n1 + 24
        local v480 = n2

        repeat
            v480 *= 2
        until v479 <= v480

        local v481 = buffer.create(v480)

        buffer.copy(v481, 0, v1, 0, n1)
        v1 = v481
        n2 = v480
    end

    local v482 = n1
    local CFramePosition = p31.CFrame.Position
    local v483 = p31.Size / 2
    local v484 = CFramePosition - v483
    local v485 = CFramePosition + v483
    local v486 = v1

    buffer.writef32(v486, v482, v484.X)

    local v487 = v1

    buffer.writef32(v487, v482 + 4, v484.Y)

    local v489 = v1

    buffer.writef32(v489, v482 + 8, v484.Z)

    local v491 = v1

    buffer.writef32(v491, v482 + 12, v485.X)

    local v493 = v1

    buffer.writef32(v493, v482 + 16, v485.Y)

    local v495 = v1

    buffer.writef32(v495, v482 + 20, v485.Z)
    n1 = v482 + 24
end

t5[79] = function() -- line: 826
    -- upvalues: v3 (ref), n3 (ref)
    local v497 = n3
    local v498 = v3
    local v511 = Region3.new(Vector3.new(buffer.readf32(v498, v497), buffer.readf32(v498, v497 + 4), (buffer.readf32(v498, v497 + 8))), (Vector3.new(buffer.readf32(v498, v497 + 12), buffer.readf32(v498, v497 + 16), (buffer.readf32(v498, v497 + 20)))))

    n3 = v497 + 24

    return v511
end

t4[80] = function(p32) -- line: 838
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 12 > n2 then
        local v512 = n1 + 12
        local v513 = n2

        repeat
            v513 *= 2
        until v512 <= v513

        local v514 = buffer.create(v513)

        buffer.copy(v514, 0, v1, 0, n1)
        v1 = v514
        n2 = v513
    end

    local v515 = n1
    local Min, Max = p32.Min, p32.Max
    local v516 = v1
    local X = Min.X

    buffer.writei16(v516, v515, X)

    local v517 = v1
    local v518 = v515 + 2
    local Y = Min.Y

    buffer.writei16(v517, v518, Y)

    local v519 = v1
    local v520 = v515 + 4
    local Z = Min.Z

    buffer.writei16(v519, v520, Z)

    local v521 = v1
    local v522 = v515 + 6
    local X2 = Max.X

    buffer.writei16(v521, v522, X2)

    local v523 = v1
    local v524 = v515 + 8
    local Y2 = Max.Y

    buffer.writei16(v523, v524, Y2)

    local v525 = v1
    local v526 = v515 + 10
    local Z2 = Max.Z

    buffer.writei16(v525, v526, Z2)
    n1 = v515 + 12
end

t5[80] = function() -- line: 851
    -- upvalues: v3 (ref), n3 (ref)
    local v527 = n3
    local v528 = v3
    local v539 = Region3int16.new(Vector3int16.new(buffer.readi16(v528, v527), buffer.readi16(v528, v527 + 2), (buffer.readi16(v528, v527 + 4))), Vector3int16.new(buffer.readi16(v528, v527 + 6), buffer.readi16(v528, v527 + 8), (buffer.readi16(v528, v527 + 10))))

    n3 = v527 + 12

    return v539
end

t4[81] = function(p33) -- line: 863
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 21 > n2 then
        local v540 = n1 + 21
        local v541 = n2

        repeat
            v541 *= 2
        until v540 <= v541

        local v542 = buffer.create(v541)

        buffer.copy(v542, 0, v1, 0, n1)
        v1 = v542
        n2 = v541
    end

    local v543 = n1
    local v544 = v1

    buffer.writef32(v544, v543, p33.Time)

    local v545 = v1

    buffer.writeu32(v545, v543 + 4, p33.EasingStyle.Value)

    local v547 = v1

    buffer.writeu32(v547, v543 + 8, p33.EasingDirection.Value)

    local v549 = v1
    local v550 = v543 + 12
    local RepeatCount = p33.RepeatCount

    buffer.writei32(v549, v550, RepeatCount)

    local v551 = v1

    buffer.writeu8(v551, v543 + 16, p33.Reverses and 1 or 0)

    local v554 = v1

    buffer.writef32(v554, v543 + 17, p33.DelayTime)
    n1 = v543 + 21
end

t5[81] = function() -- line: 875
    -- upvalues: v3 (ref), n3 (ref)
    local v556 = n3
    local v557 = v3
    local v568 = TweenInfo.new(buffer.readf32(v557, v556), Enum.EasingStyle:FromValue((buffer.readu32(v557, v556 + 4))), Enum.EasingDirection:FromValue((buffer.readu32(v557, v556 + 8))), buffer.readi32(v557, v556 + 12), buffer.readu8(v557, v556 + 16) == 1, (buffer.readf32(v557, v556 + 17)))

    n3 = v556 + 21

    return v568
end

t4[82] = function(p34) -- line: 891
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 8 > n2 then
        local v569 = n1 + 8
        local v570 = n2

        repeat
            v570 *= 2
        until v569 <= v570

        local v571 = buffer.create(v570)

        buffer.copy(v571, 0, v1, 0, n1)
        v1 = v571
        n2 = v570
    end

    local v572 = v1
    local v573 = n1

    buffer.writef32(v572, v573, p34.Scale)

    local v574 = v1
    local v575 = n1 + 4
    local Offset = p34.Offset

    buffer.writei32(v574, v575, Offset)
    n1 += 8
end

t5[82] = function() -- line: 898
    -- upvalues: v3 (ref), n3 (ref)
    local v578 = buffer.readf32(v3, n3)
    local v579 = v3
    local v581 = buffer.readi32(v579, n3 + 4)

    n3 += 8

    return UDim.new(v578, v581)
end

t4[83] = function(p35) -- line: 906
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 16 > n2 then
        local v582 = n1 + 16
        local v583 = n2

        repeat
            v583 *= 2
        until v582 <= v583

        local v584 = buffer.create(v583)

        buffer.copy(v584, 0, v1, 0, n1)
        v1 = v584
        n2 = v583
    end

    local v585 = n1
    local v586 = v1

    buffer.writef32(v586, v585, p35.X.Scale)

    local v587 = v1
    local v588 = v585 + 4
    local Offset = p35.X.Offset

    buffer.writei32(v587, v588, Offset)

    local v589 = v1

    buffer.writef32(v589, v585 + 8, p35.Y.Scale)

    local v591 = v1
    local v592 = v585 + 12
    local Offset2 = p35.Y.Offset

    buffer.writei32(v591, v592, Offset2)
    n1 = v585 + 16
end

t5[83] = function() -- line: 916
    -- upvalues: v3 (ref), n3 (ref)
    local v593 = n3
    local v594 = v3
    local v601 = UDim2.new(UDim.new(buffer.readf32(v594, v593), (buffer.readi32(v594, v593 + 4))), UDim.new(buffer.readf32(v594, v593 + 8), (buffer.readi32(v594, v593 + 12))))

    n3 = v593 + 16

    return v601
end

t4[84] = function(p36) -- line: 928
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 8 > n2 then
        local v602 = n1 + 8
        local v603 = n2

        repeat
            v603 *= 2
        until v602 <= v603

        local v604 = buffer.create(v603)

        buffer.copy(v604, 0, v1, 0, n1)
        v1 = v604
        n2 = v603
    end

    local v605 = v1
    local v606 = n1

    buffer.writef32(v605, v606, p36.X)

    local v607 = v1

    buffer.writef32(v607, n1 + 4, p36.Y)
    n1 += 8
end

t5[84] = function() -- line: 935
    -- upvalues: v3 (ref), n3 (ref)
    local v611 = buffer.readf32(v3, n3)
    local v612 = v3
    local v614 = buffer.readf32(v612, n3 + 4)

    n3 += 8

    return Vector2.new(v611, v614)
end

t4[85] = function(p37) -- line: 943
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 4 > n2 then
        local v615 = n1 + 4
        local v616 = n2

        repeat
            v616 *= 2
        until v615 <= v616

        local v617 = buffer.create(v616)

        buffer.copy(v617, 0, v1, 0, n1)
        v1 = v617
        n2 = v616
    end

    local v618 = v1
    local v619 = n1
    local X = p37.X

    buffer.writei16(v618, v619, X)

    local v620 = v1
    local v621 = n1 + 2
    local Y = p37.Y

    buffer.writei16(v620, v621, Y)
    n1 += 4
end

t5[85] = function() -- line: 950
    -- upvalues: v3 (ref), n3 (ref)
    local v624 = buffer.readi16(v3, n3)
    local v625 = v3
    local v627 = buffer.readi16(v625, n3 + 2)

    n3 += 4

    return Vector2int16.new(v624, v627)
end

t4[86] = function(p38) -- line: 958
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 12 > n2 then
        local v628 = n1 + 12
        local v629 = n2

        repeat
            v629 *= 2
        until v628 <= v629

        local v630 = buffer.create(v629)

        buffer.copy(v630, 0, v1, 0, n1)
        v1 = v630
        n2 = v629
    end

    local v631 = n1
    local v632 = v1

    buffer.writef32(v632, v631, p38.X)

    local v633 = v1

    buffer.writef32(v633, v631 + 4, p38.Y)

    local v635 = v1

    buffer.writef32(v635, v631 + 8, p38.Z)
    n1 = v631 + 12
end

t5[86] = function() -- line: 967
    -- upvalues: v3 (ref), n3 (ref)
    local v637 = n3
    local v638 = v3
    local v644 = Vector3.new(buffer.readf32(v638, v637), buffer.readf32(v638, v637 + 4), (buffer.readf32(v638, v637 + 8)))

    n3 = v637 + 12

    return v644
end

t4[87] = function(p39) -- line: 976
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 6 > n2 then
        local v645 = n1 + 6
        local v646 = n2

        repeat
            v646 *= 2
        until v645 <= v646

        local v647 = buffer.create(v646)

        buffer.copy(v647, 0, v1, 0, n1)
        v1 = v647
        n2 = v646
    end

    local v648 = n1
    local v649 = v1
    local X = p39.X

    buffer.writei16(v649, v648, X)

    local v650 = v1
    local v651 = v648 + 2
    local Y = p39.Y

    buffer.writei16(v650, v651, Y)

    local v652 = v1
    local v653 = v648 + 4
    local Z = p39.Z

    buffer.writei16(v652, v653, Z)
    n1 = v648 + 6
end

t5[87] = function() -- line: 985
    -- upvalues: v3 (ref), n3 (ref)
    local v654 = n3
    local v655 = v3
    local v660 = Vector3int16.new(buffer.readi16(v655, v654), buffer.readi16(v655, v654 + 2), (buffer.readi16(v655, v654 + 4)))

    n3 = v654 + 6

    return v660
end

t4[88] = function(p40) -- line: 994
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 13 > n2 then
        local v661 = n1 + 13
        local v662 = n2

        repeat
            v662 *= 2
        until v661 <= v662

        local v663 = buffer.create(v662)

        buffer.copy(v663, 0, v1, 0, n1)
        v1 = v663
        n2 = v662
    end

    local v664 = n1
    local Position = p40.Position
    local v665 = v1

    buffer.writef32(v665, v664, Position.X)

    local v666 = v1

    buffer.writef32(v666, v664 + 4, Position.Y)

    local v668 = v1

    buffer.writef32(v668, v664 + 8, Position.Z)

    local v670 = v1

    buffer.writeu8(v670, v664 + 12, p40.Action.Value)
    n1 = v664 + 13
end

t5[88] = function() -- line: 1005
    -- upvalues: v3 (ref), n3 (ref)
    local v672 = n3
    local v673 = v3
    local v681 = PathWaypoint.new(Vector3.new(buffer.readf32(v673, v672), buffer.readf32(v673, v672 + 4), (buffer.readf32(v673, v672 + 8))), (Enum.PathWaypointAction:FromValue((buffer.readu8(v673, v672 + 12)))))

    n3 = v672 + 13

    return v681
end

t4[89] = function(p41) -- line: 1017
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 9 > n2 then
        local v682 = n1 + 9
        local v683 = n2

        repeat
            v683 *= 2
        until v682 <= v683

        local v684 = buffer.create(v683)

        buffer.copy(v684, 0, v1, 0, n1)
        v1 = v684
        n2 = v683
    end

    local v685 = n1
    local v686 = v1

    buffer.writef32(v686, v685, p41.Time)

    local v687 = v1

    buffer.writef32(v687, v685 + 4, p41.Value)

    local v689 = v1

    buffer.writeu8(v689, v685 + 8, p41.Interpolation.Value)
    n1 = v685 + 9
end

t5[89] = function() -- line: 1026
    -- upvalues: v3 (ref), n3 (ref)
    local v691 = n3
    local v692 = v3
    local v697 = FloatCurveKey.new(buffer.readf32(v692, v691), buffer.readf32(v692, v691 + 4), (Enum.KeyInterpolationMode:FromValue((buffer.readu8(v692, v691 + 8)))))

    n3 = v691 + 9

    return v697
end

t4[90] = function(p42) -- line: 1039
    -- upvalues: v1 (ref), n1 (ref), n2 (ref), t4 (copy)
    local Time = p42.Time

    if n1 + 4 > n2 then
        local v698 = n1 + 4
        local v699 = n2

        repeat
            v699 *= 2
        until v698 <= v699

        local v700 = buffer.create(v699)

        buffer.copy(v700, 0, v1, 0, n1)
        v1 = v700
        n2 = v699
    end

    buffer.writef32(v1, n1, Time)
    n1 += 4
    t4[66](p42.Value)

    local Value = p42.Interpolation.Value

    if n1 + 1 > n2 then
        local v703 = n1 + 1
        local v704 = n2

        repeat
            v704 *= 2
        until v703 <= v704

        local v705 = buffer.create(v704)

        buffer.copy(v705, 0, v1, 0, n1)
        v1 = v705
        n2 = v704
    end

    buffer.writeu8(v1, n1, Value)
    n1 += 1
end

t5[90] = function() -- line: 1045
    -- upvalues: v3 (ref), n3 (ref), t5 (copy)
    local v710 = buffer.readf32(v3, n3)

    n3 += 4

    local v711 = t5[66]()
    local KeyInterpolationMode = Enum.KeyInterpolationMode
    local v714 = buffer.readu8(v3, n3)

    n3 += 1

    local v715 = KeyInterpolationMode:FromValue(v714)

    return RotationCurveKey.new(v710, v711, v715)
end

t4[91] = function(p43) -- line: 1053
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    if n1 + 48 > n2 then
        local v716 = n1 + 48
        local v717 = n2

        repeat
            v717 *= 2
        until v716 <= v717

        local v718 = buffer.create(v717)

        buffer.copy(v718, 0, v1, 0, n1)
        v1 = v718
        n2 = v717
    end

    local v719 = n1
    local v720 = v1
    local Position, LeftTangent, RightTangent = p43.Position, p43.LeftTangent, p43.RightTangent

    buffer.writef32(v720, v719, Position.X.Scale)

    local v721 = v719 + 4
    local Offset = Position.X.Offset

    buffer.writei32(v720, v721, Offset)
    buffer.writef32(v720, v719 + 8, Position.Y.Scale)

    local v723 = v719 + 12
    local Offset2 = Position.Y.Offset

    buffer.writei32(v720, v723, Offset2)
    buffer.writef32(v720, v719 + 16, LeftTangent.X.Scale)

    local v725 = v719 + 20
    local Offset3 = LeftTangent.X.Offset

    buffer.writei32(v720, v725, Offset3)
    buffer.writef32(v720, v719 + 24, LeftTangent.Y.Scale)

    local v727 = v719 + 28
    local Offset4 = LeftTangent.Y.Offset

    buffer.writei32(v720, v727, Offset4)
    buffer.writef32(v720, v719 + 32, RightTangent.X.Scale)

    local v729 = v719 + 36
    local Offset5 = RightTangent.X.Offset

    buffer.writei32(v720, v729, Offset5)
    buffer.writef32(v720, v719 + 40, RightTangent.Y.Scale)

    local v731 = v719 + 44
    local Offset6 = RightTangent.Y.Offset

    buffer.writei32(v720, v731, Offset6)
    n1 = v719 + 48
end

t5[91] = function() -- line: 1075
    -- upvalues: v3 (ref), n3 (ref)
    local v732 = n3
    local v733 = v3
    local v756 = Path2DControlPoint.new(UDim2.new(UDim.new(buffer.readf32(v733, v732), (buffer.readi32(v733, v732 + 4))), UDim.new(buffer.readf32(v733, v732 + 8), (buffer.readi32(v733, v732 + 12)))), UDim2.new(UDim.new(buffer.readf32(v733, v732 + 16), (buffer.readi32(v733, v732 + 20))), UDim.new(buffer.readf32(v733, v732 + 24), (buffer.readi32(v733, v732 + 28)))), UDim2.new(UDim.new(buffer.readf32(v733, v732 + 32), (buffer.readi32(v733, v732 + 36))), UDim.new(buffer.readf32(v733, v732 + 40), (buffer.readi32(v733, v732 + 44)))))

    n3 = v732 + 48

    return v756
end

t5[16] = function() -- line: 1096
    return {}
end

t5[17] = function() -- line: 1100
    -- upvalues: v3 (ref), n3 (ref), v34 (ref)
    local v759 = buffer.readu32(v3, n3)

    n3 += 4

    local v760 = table.create(v759)

    for i = 1, v759 do
        v760[i] = v34()
    end

    return v760
end

t5[21] = function() -- line: 1109
    -- upvalues: v3 (ref), n3 (ref), v34 (ref)
    local t9 = {}

    while true and buffer.readu8(v3, n3) ~= 255 do
        t9[v34()] = v34()
    end

    n3 += 1

    return t9
end

local function v763(p44) -- line: 1122
    -- upvalues: t2 (copy), v1 (ref), n1 (ref), n2 (ref), t3 (ref), v33 (ref), t4 (copy)
    local v764 = typeof(p44)

    if v764 == "number" then
        if n1 + 9 > n2 then
            local v765 = n1 + 9
            local v766 = n2

            repeat
                v766 *= 2
            until v765 <= v766

            local v767 = buffer.create(v766)

            buffer.copy(v767, 0, v1, 0, n1)
            v1 = v767
            n2 = v766
        end

        buffer.writeu8(v1, n1, 9)

        local v770 = v1

        buffer.writef64(v770, n1 + 1, p44)
        n1 += 9
    elseif v764 == "string" then
        local v772 = #p44

        if n1 + 5 + v772 > n2 then
            local v773 = v772 + 5
            local v774 = n1 + v773
            local v775 = n2

            repeat
                v775 *= 2
            until v774 <= v775

            local v776 = buffer.create(v775)

            buffer.copy(v776, 0, v1, 0, n1)
            v1 = v776
            n2 = v775
        end

        buffer.writeu8(v1, n1, 12)

        local v779 = v1

        buffer.writeu32(v779, n1 + 1, v772)
        buffer.writestring(v1, n1 + 5, p44)

        local v781 = n1

        n1 = v781 + (v772 + 5)
    elseif v764 == "boolean" then
        if n1 + 1 > n2 then
            local v782 = n1 + 1
            local v783 = n2

            repeat
                v783 *= 2
            until v782 <= v783

            local v784 = buffer.create(v783)

            buffer.copy(v784, 0, v1, 0, n1)
            v1 = v784
            n2 = v783
        end

        local v785 = v1
        local v786 = n1

        buffer.writeu8(v785, v786, p44 and 2 or 1)
        n1 += 1
    elseif v764 == "table" then
        local v788 = #p44

        if not (v788 > 0) or next(p44, v788) ~= nil then
            if v788 ~= 0 or next(p44) ~= nil then
                if n1 + 1 > n2 then
                    local v789 = n1 + 1
                    local v790 = n2

                    repeat
                        v790 *= 2
                    until v789 <= v790

                    local v791 = buffer.create(v790)

                    buffer.copy(v791, 0, v1, 0, n1)
                    v1 = v791
                    n2 = v790
                end

                buffer.writeu8(v1, n1, 21)
                n1 += 1

                for v794, v795 in p44 do
                    local v796 = type(v794)

                    if v796 == "number" then
                        if n1 + 9 > n2 then
                            local v797 = n1 + 9
                            local v798 = n2

                            repeat
                                v798 *= 2
                            until v797 <= v798

                            local v799 = buffer.create(v798)

                            buffer.copy(v799, 0, v1, 0, n1)
                            v1 = v799
                            n2 = v798
                        end

                        buffer.writeu8(v1, n1, 9)

                        local v802 = v1

                        buffer.writef64(v802, n1 + 1, v794)
                        n1 += 9
                    elseif v796 == "string" then
                        local v804 = #v794

                        if n1 + 5 + v804 > n2 then
                            local v805 = v804 + 5
                            local v806 = n1 + v805
                            local v807 = n2

                            repeat
                                v807 *= 2
                            until v806 <= v807

                            local v808 = buffer.create(v807)

                            buffer.copy(v808, 0, v1, 0, n1)
                            v1 = v808
                            n2 = v807
                        end

                        buffer.writeu8(v1, n1, 12)

                        local v811 = v1

                        buffer.writeu32(v811, n1 + 1, v804)
                        buffer.writestring(v1, n1 + 5, v794)

                        local v813 = n1

                        n1 = v813 + (v804 + 5)
                    else
                        v33(v794)
                    end

                    local v814 = type(v795)

                    if v814 == "number" then
                        if n1 + 9 > n2 then
                            local v815 = n1 + 9
                            local v816 = n2

                            repeat
                                v816 *= 2
                            until v815 <= v816

                            local v817 = buffer.create(v816)

                            buffer.copy(v817, 0, v1, 0, n1)
                            v1 = v817
                            n2 = v816
                        end

                        buffer.writeu8(v1, n1, 9)

                        local v820 = v1

                        buffer.writef64(v820, n1 + 1, v795)
                        n1 += 9
                    elseif v814 == "string" then
                        local v822 = #v795

                        if n1 + 5 + v822 > n2 then
                            local v823 = v822 + 5
                            local v824 = n1 + v823
                            local v825 = n2

                            repeat
                                v825 *= 2
                            until v824 <= v825

                            local v826 = buffer.create(v825)

                            buffer.copy(v826, 0, v1, 0, n1)
                            v1 = v826
                            n2 = v825
                        end

                        buffer.writeu8(v1, n1, 12)

                        local v829 = v1

                        buffer.writeu32(v829, n1 + 1, v822)
                        buffer.writestring(v1, n1 + 5, v795)

                        local v831 = n1

                        n1 = v831 + (v822 + 5)
                    elseif v814 == "boolean" then
                        if n1 + 1 > n2 then
                            local v832 = n1 + 1
                            local v833 = n2

                            repeat
                                v833 *= 2
                            until v832 <= v833

                            local v834 = buffer.create(v833)

                            buffer.copy(v834, 0, v1, 0, n1)
                            v1 = v834
                            n2 = v833
                        end

                        local v835 = v1
                        local v836 = n1

                        buffer.writeu8(v835, v836, v795 and 2 or 1)
                        n1 += 1
                    else
                        v33(v795)
                    end
                end

                if n1 + 1 > n2 then
                    local v838 = n1 + 1
                    local v839 = n2

                    repeat
                        v839 *= 2
                    until v838 <= v839

                    local v840 = buffer.create(v839)

                    buffer.copy(v840, 0, v1, 0, n1)
                    v1 = v840
                    n2 = v839
                end

                buffer.writeu8(v1, n1, 255)
            else
                if n1 + 1 > n2 then
                    local v843 = n1 + 1
                    local v844 = n2

                    repeat
                        v844 *= 2
                    until v843 <= v844

                    local v845 = buffer.create(v844)

                    buffer.copy(v845, 0, v1, 0, n1)
                    v1 = v845
                    n2 = v844
                end

                buffer.writeu8(v1, n1, 16)
            end

            n1 += 1
        else
            if n1 + 5 > n2 then
                local v848 = n1 + 5
                local v849 = n2

                repeat
                    v849 *= 2
                until v848 <= v849

                local v850 = buffer.create(v849)

                buffer.copy(v850, 0, v1, 0, n1)
                v1 = v850
                n2 = v849
            end

            buffer.writeu8(v1, n1, 17)

            local v853 = v1

            buffer.writeu32(v853, n1 + 1, v788)
            n1 += 5

            for i = 1, v788 do
                local v855 = p44[i]
                local v856 = type(v855)

                if v856 == "number" then
                    if n1 + 9 > n2 then
                        local v857 = n1 + 9
                        local v858 = n2

                        repeat
                            v858 *= 2
                        until v857 <= v858

                        local v859 = buffer.create(v858)

                        buffer.copy(v859, 0, v1, 0, n1)
                        v1 = v859
                        n2 = v858
                    end

                    buffer.writeu8(v1, n1, 9)

                    local v862 = v1

                    buffer.writef64(v862, n1 + 1, v855)
                    n1 += 9
                elseif v856 == "string" then
                    local v864 = #v855

                    if n1 + 5 + v864 > n2 then
                        local v865 = v864 + 5
                        local v866 = n1 + v865
                        local v867 = n2

                        repeat
                            v867 *= 2
                        until v866 <= v867

                        local v868 = buffer.create(v867)

                        buffer.copy(v868, 0, v1, 0, n1)
                        v1 = v868
                        n2 = v867
                    end

                    buffer.writeu8(v1, n1, 12)

                    local v871 = v1

                    buffer.writeu32(v871, n1 + 1, v864)
                    buffer.writestring(v1, n1 + 5, v855)

                    local v873 = n1

                    n1 = v873 + (v864 + 5)
                elseif v856 == "boolean" then
                    if n1 + 1 > n2 then
                        local v874 = n1 + 1
                        local v875 = n2

                        repeat
                            v875 *= 2
                        until v874 <= v875

                        local v876 = buffer.create(v875)

                        buffer.copy(v876, 0, v1, 0, n1)
                        v1 = v876
                        n2 = v875
                    end

                    local v877 = v1
                    local v878 = n1

                    buffer.writeu8(v877, v878, v855 and 2 or 1)
                    n1 += 1
                else
                    v33(v855)
                end
            end
        end
    elseif v764 == "buffer" then
        local v880 = buffer.len(p44)

        if n1 + 5 + v880 > n2 then
            local v881 = 5 + v880
            local v882 = n1 + v881
            local v883 = n2

            repeat
                v883 *= 2
            until v882 <= v883

            local v884 = buffer.create(v883)

            buffer.copy(v884, 0, v1, 0, n1)
            v1 = v884
            n2 = v883
        end

        buffer.writeu8(v1, n1, 13)

        local v887 = v1

        buffer.writeu32(v887, n1 + 1, v880)
        buffer.copy(v1, n1 + 5, p44, 0, v880)

        local v889 = n1

        n1 = v889 + (5 + v880)
    elseif p44 ~= nil then
        if v764 == "Instance" then
            if not t3 then
                error("Buff: Instance serialization requires enableInstances=true in encode()")
            end

            table.insert(t3, p44)

            if n1 + 5 > n2 then
                local v895 = n1 + 5
                local v896 = n2

                repeat
                    v896 *= 2
                until v895 <= v896

                local v897 = buffer.create(v896)

                buffer.copy(v897, 0, v1, 0, n1)
                v1 = v897
                n2 = v896
            end

            buffer.writeu8(v1, n1, 92)

            local v900 = v1

            buffer.writeu32(v900, n1 + 1, #t3)
            n1 += 5
        else
            local v903 = t2[v764]

            if not v903 then
                error((("Buff: unsupported type \"%*\""):format(v764)))
            end

            if n1 + 1 > n2 then
                local v904 = n1 + 1
                local v905 = n2

                repeat
                    v905 *= 2
                until v904 <= v905

                local v906 = buffer.create(v905)

                buffer.copy(v906, 0, v1, 0, n1)
                v1 = v906
                n2 = v905
            end

            buffer.writeu8(v1, n1, v903)
            n1 += 1
            t4[v903](p44)
        end
    else
        if n1 + 1 > n2 then
            local v890 = n1 + 1
            local v891 = n2

            repeat
                v891 *= 2
            until v890 <= v891

            local v892 = buffer.create(v891)

            buffer.copy(v892, 0, v1, 0, n1)
            v1 = v892
            n2 = v891
        end

        buffer.writeu8(v1, n1, 0)
        n1 += 1
    end
end

local function v909(p45) -- line: 1290
    -- upvalues: t2 (copy), v1 (ref), n1 (ref), n2 (ref), t3 (ref), v33 (ref), t4 (copy)
    local v910 = typeof(p45)

    if v910 == "number" then
        if p45 ~= p45 or p45 % 1 ~= 0 then
            if n1 + 9 > n2 then
                local v911 = n1 + 9
                local v912 = n2

                repeat
                    v912 *= 2
                until v911 <= v912

                local v913 = buffer.create(v912)

                buffer.copy(v913, 0, v1, 0, n1)
                v1 = v913
                n2 = v912
            end

            buffer.writeu8(v1, n1, 9)

            local v916 = v1

            buffer.writef64(v916, n1 + 1, p45)
            n1 += 9
        elseif p45 >= 0 then
            if p45 <= 255 then
                if n1 + 2 > n2 then
                    local v918 = n1 + 2
                    local v919 = n2

                    repeat
                        v919 *= 2
                    until v918 <= v919

                    local v920 = buffer.create(v919)

                    buffer.copy(v920, 0, v1, 0, n1)
                    v1 = v920
                    n2 = v919
                end

                buffer.writeu8(v1, n1, 3)

                local v923 = v1

                buffer.writeu8(v923, n1 + 1, p45)
                n1 += 2
            elseif p45 <= 65535 then
                if n1 + 3 > n2 then
                    local v925 = n1 + 3
                    local v926 = n2

                    repeat
                        v926 *= 2
                    until v925 <= v926

                    local v927 = buffer.create(v926)

                    buffer.copy(v927, 0, v1, 0, n1)
                    v1 = v927
                    n2 = v926
                end

                buffer.writeu8(v1, n1, 4)

                local v930 = v1

                buffer.writeu16(v930, n1 + 1, p45)
                n1 += 3
            elseif p45 <= 4294967295 then
                if n1 + 5 > n2 then
                    local v932 = n1 + 5
                    local v933 = n2

                    repeat
                        v933 *= 2
                    until v932 <= v933

                    local v934 = buffer.create(v933)

                    buffer.copy(v934, 0, v1, 0, n1)
                    v1 = v934
                    n2 = v933
                end

                buffer.writeu8(v1, n1, 5)

                local v937 = v1

                buffer.writeu32(v937, n1 + 1, p45)
                n1 += 5
            else
                if n1 + 9 > n2 then
                    local v939 = n1 + 9
                    local v940 = n2

                    repeat
                        v940 *= 2
                    until v939 <= v940

                    local v941 = buffer.create(v940)

                    buffer.copy(v941, 0, v1, 0, n1)
                    v1 = v941
                    n2 = v940
                end

                buffer.writeu8(v1, n1, 9)

                local v944 = v1

                buffer.writef64(v944, n1 + 1, p45)
                n1 += 9
            end
        elseif p45 >= -128 then
            if n1 + 2 > n2 then
                local v946 = n1 + 2
                local v947 = n2

                repeat
                    v947 *= 2
                until v946 <= v947

                local v948 = buffer.create(v947)

                buffer.copy(v948, 0, v1, 0, n1)
                v1 = v948
                n2 = v947
            end

            buffer.writeu8(v1, n1, 6)

            local v951 = v1
            local v952 = n1 + 1

            buffer.writei8(v951, v952, p45)
            n1 += 2
        elseif p45 >= -32768 then
            if n1 + 3 > n2 then
                local v953 = n1 + 3
                local v954 = n2

                repeat
                    v954 *= 2
                until v953 <= v954

                local v955 = buffer.create(v954)

                buffer.copy(v955, 0, v1, 0, n1)
                v1 = v955
                n2 = v954
            end

            buffer.writeu8(v1, n1, 7)

            local v958 = v1
            local v959 = n1 + 1

            buffer.writei16(v958, v959, p45)
            n1 += 3
        elseif p45 >= -2147483648 then
            if n1 + 5 > n2 then
                local v960 = n1 + 5
                local v961 = n2

                repeat
                    v961 *= 2
                until v960 <= v961

                local v962 = buffer.create(v961)

                buffer.copy(v962, 0, v1, 0, n1)
                v1 = v962
                n2 = v961
            end

            buffer.writeu8(v1, n1, 8)

            local v965 = v1
            local v966 = n1 + 1

            buffer.writei32(v965, v966, p45)
            n1 += 5
        else
            if n1 + 9 > n2 then
                local v967 = n1 + 9
                local v968 = n2

                repeat
                    v968 *= 2
                until v967 <= v968

                local v969 = buffer.create(v968)

                buffer.copy(v969, 0, v1, 0, n1)
                v1 = v969
                n2 = v968
            end

            buffer.writeu8(v1, n1, 9)

            local v972 = v1

            buffer.writef64(v972, n1 + 1, p45)
            n1 += 9
        end
    elseif v910 == "string" then
        local v974 = #p45

        if v974 <= 255 then
            if n1 + 2 + v974 > n2 then
                local v975 = v974 + 2
                local v976 = n1 + v975
                local v977 = n2

                repeat
                    v977 *= 2
                until v976 <= v977

                local v978 = buffer.create(v977)

                buffer.copy(v978, 0, v1, 0, n1)
                v1 = v978
                n2 = v977
            end

            buffer.writeu8(v1, n1, 10)

            local v981 = v1

            buffer.writeu8(v981, n1 + 1, v974)
            buffer.writestring(v1, n1 + 2, p45)

            local v983 = n1

            n1 = v983 + (v974 + 2)
        elseif v974 <= 65535 then
            if n1 + 3 + v974 > n2 then
                local v984 = v974 + 3
                local v985 = n1 + v984
                local v986 = n2

                repeat
                    v986 *= 2
                until v985 <= v986

                local v987 = buffer.create(v986)

                buffer.copy(v987, 0, v1, 0, n1)
                v1 = v987
                n2 = v986
            end

            buffer.writeu8(v1, n1, 11)

            local v990 = v1

            buffer.writeu16(v990, n1 + 1, v974)
            buffer.writestring(v1, n1 + 3, p45)

            local v992 = n1

            n1 = v992 + (v974 + 3)
        else
            if n1 + 5 + v974 > n2 then
                local v993 = v974 + 5
                local v994 = n1 + v993
                local v995 = n2

                repeat
                    v995 *= 2
                until v994 <= v995

                local v996 = buffer.create(v995)

                buffer.copy(v996, 0, v1, 0, n1)
                v1 = v996
                n2 = v995
            end

            buffer.writeu8(v1, n1, 12)

            local v999 = v1

            buffer.writeu32(v999, n1 + 1, v974)
            buffer.writestring(v1, n1 + 5, p45)

            local v1001 = n1

            n1 = v1001 + (v974 + 5)
        end
    elseif v910 == "boolean" then
        if n1 + 1 > n2 then
            local v1002 = n1 + 1
            local v1003 = n2

            repeat
                v1003 *= 2
            until v1002 <= v1003

            local v1004 = buffer.create(v1003)

            buffer.copy(v1004, 0, v1, 0, n1)
            v1 = v1004
            n2 = v1003
        end

        local v1005 = v1
        local v1006 = n1

        buffer.writeu8(v1005, v1006, p45 and 2 or 1)
        n1 += 1
    elseif v910 == "table" then
        local v1008 = #p45

        if not (v1008 > 0) or next(p45, v1008) ~= nil then
            if v1008 ~= 0 or next(p45) ~= nil then
                if n1 + 1 > n2 then
                    local v1009 = n1 + 1
                    local v1010 = n2

                    repeat
                        v1010 *= 2
                    until v1009 <= v1010

                    local v1011 = buffer.create(v1010)

                    buffer.copy(v1011, 0, v1, 0, n1)
                    v1 = v1011
                    n2 = v1010
                end

                buffer.writeu8(v1, n1, 21)
                n1 += 1

                for v1014, v1015 in p45 do
                    v33(v1014)
                    v33(v1015)
                end

                if n1 + 1 > n2 then
                    local v1016 = n1 + 1
                    local v1017 = n2

                    repeat
                        v1017 *= 2
                    until v1016 <= v1017

                    local v1018 = buffer.create(v1017)

                    buffer.copy(v1018, 0, v1, 0, n1)
                    v1 = v1018
                    n2 = v1017
                end

                buffer.writeu8(v1, n1, 255)
            else
                if n1 + 1 > n2 then
                    local v1021 = n1 + 1
                    local v1022 = n2

                    repeat
                        v1022 *= 2
                    until v1021 <= v1022

                    local v1023 = buffer.create(v1022)

                    buffer.copy(v1023, 0, v1, 0, n1)
                    v1 = v1023
                    n2 = v1022
                end

                buffer.writeu8(v1, n1, 16)
            end

            n1 += 1
        else
            if n1 + 5 > n2 then
                local v1026 = n1 + 5
                local v1027 = n2

                repeat
                    v1027 *= 2
                until v1026 <= v1027

                local v1028 = buffer.create(v1027)

                buffer.copy(v1028, 0, v1, 0, n1)
                v1 = v1028
                n2 = v1027
            end

            buffer.writeu8(v1, n1, 17)

            local v1031 = v1

            buffer.writeu32(v1031, n1 + 1, v1008)
            n1 += 5

            for i = 1, v1008 do
                v33(p45[i])
            end
        end
    elseif v910 == "buffer" then
        local v1033 = buffer.len(p45)

        if n1 + 5 + v1033 > n2 then
            local v1034 = 5 + v1033
            local v1035 = n1 + v1034
            local v1036 = n2

            repeat
                v1036 *= 2
            until v1035 <= v1036

            local v1037 = buffer.create(v1036)

            buffer.copy(v1037, 0, v1, 0, n1)
            v1 = v1037
            n2 = v1036
        end

        buffer.writeu8(v1, n1, 13)

        local v1040 = v1

        buffer.writeu32(v1040, n1 + 1, v1033)
        buffer.copy(v1, n1 + 5, p45, 0, v1033)

        local v1042 = n1

        n1 = v1042 + (5 + v1033)
    elseif p45 ~= nil then
        if v910 == "Instance" then
            if not t3 then
                error("Buff: Instance serialization requires enableInstances=true in encode()")
            end

            table.insert(t3, p45)

            if n1 + 5 > n2 then
                local v1048 = n1 + 5
                local v1049 = n2

                repeat
                    v1049 *= 2
                until v1048 <= v1049

                local v1050 = buffer.create(v1049)

                buffer.copy(v1050, 0, v1, 0, n1)
                v1 = v1050
                n2 = v1049
            end

            buffer.writeu8(v1, n1, 92)

            local v1053 = v1

            buffer.writeu32(v1053, n1 + 1, #t3)
            n1 += 5
        else
            local v1056 = t2[v910]

            if not v1056 then
                error((("Buff: unsupported type \"%*\""):format(v910)))
            end

            if n1 + 1 > n2 then
                local v1057 = n1 + 1
                local v1058 = n2

                repeat
                    v1058 *= 2
                until v1057 <= v1058

                local v1059 = buffer.create(v1058)

                buffer.copy(v1059, 0, v1, 0, n1)
                v1 = v1059
                n2 = v1058
            end

            buffer.writeu8(v1, n1, v1056)
            n1 += 1
            t4[v1056](p45)
        end
    else
        if n1 + 1 > n2 then
            local v1043 = n1 + 1
            local v1044 = n2

            repeat
                v1044 *= 2
            until v1043 <= v1044

            local v1045 = buffer.create(v1044)

            buffer.copy(v1045, 0, v1, 0, n1)
            v1 = v1045
            n2 = v1044
        end

        buffer.writeu8(v1, n1, 0)
        n1 += 1
    end
end

v33 = v763

v34 = function() -- line: 1466
    -- upvalues: v3 (ref), n3 (ref), t5 (copy)
    local v1064 = buffer.readu8(v3, n3)

    n3 += 1

    local v1065 = t5[v1064]

    if not v1065 then
        error((("Buff: unknown type tag %* at offset %*"):format(v1064, n3 - 1)))
    end

    return v1065()
end

function t1.encode(p46, p47, p48) -- line: 1476
    -- upvalues: v1 (ref), n1 (ref), t3 (ref), v33 (ref), v763 (copy), v909 (copy)
    n1 = 0

    if p48 then
        t3 = {}
    else
        t3 = nil
    end

    v33 = if p47 == "size" then v909 else v763
    v33(p46)

    local v1066 = buffer.create(n1)

    buffer.copy(v1066, 0, v1, 0, n1)

    local t12 = t3

    t3 = nil

    if not (t12 and #t12 > 0) then
        return v1066, nil
    end

    return v1066, t12
end

function t1.decode(p49, p50) -- line: 1488
    -- upvalues: v2 (ref), v3 (ref), n3 (ref), v34 (ref)
    v3 = p49
    n3 = 0
    v2 = p50

    local v1067 = v34()

    v2 = nil

    return v1067
end

function t1.analyze(p51) -- line: 1497
    local n4 = 0
    local v1068 = buffer.len(p51)
    local t13 = {}
    local t14 = {}

    local function record(p52, p53) -- line: 1503
        -- upvalues: t13 (copy), t14 (copy)
        t13[p52] = (t13[p52] or 0) + 1
        t14[p52] = (t14[p52] or 0) + p53
    end

    local function walk() -- line: 1508
        -- upvalues: p51 (copy), n4 (ref), t13 (copy), t14 (copy), walk (copy)
        local v1070 = buffer.readu8(p51, n4)

        n4 += 1

        if v1070 == 0 then
            t13["nil"] = (t13["nil"] or 0) + 1
            t14["nil"] = (t14["nil"] or 0) + 1
        elseif v1070 == 1 or v1070 == 2 then
            t13.boolean = (t13.boolean or 0) + 1
            t14.boolean = (t14.boolean or 0) + 1
        elseif v1070 == 3 then
            t13["number (u8)"] = (t13["number (u8)"] or 0) + 1
            t14["number (u8)"] = (t14["number (u8)"] or 0) + 2
            n4 += 1
        elseif v1070 == 4 then
            t13["number (u16)"] = (t13["number (u16)"] or 0) + 1
            t14["number (u16)"] = (t14["number (u16)"] or 0) + 3
            n4 += 2
        elseif v1070 == 5 then
            t13["number (u32)"] = (t13["number (u32)"] or 0) + 1
            t14["number (u32)"] = (t14["number (u32)"] or 0) + 5
            n4 += 4
        elseif v1070 == 6 then
            t13["number (i8)"] = (t13["number (i8)"] or 0) + 1
            t14["number (i8)"] = (t14["number (i8)"] or 0) + 2
            n4 += 1
        elseif v1070 == 7 then
            t13["number (i16)"] = (t13["number (i16)"] or 0) + 1
            t14["number (i16)"] = (t14["number (i16)"] or 0) + 3
            n4 += 2
        elseif v1070 == 8 then
            t13["number (i32)"] = (t13["number (i32)"] or 0) + 1
            t14["number (i32)"] = (t14["number (i32)"] or 0) + 5
            n4 += 4
        elseif v1070 == 9 then
            t13["number (f64)"] = (t13["number (f64)"] or 0) + 1
            t14["number (f64)"] = (t14["number (f64)"] or 0) + 9
            n4 += 8
        elseif v1070 == 10 then
            local v1072 = buffer.readu8(p51, n4)
            local v1073 = n4

            n4 = v1073 + (v1072 + 1)

            local v1074 = v1072 + 2

            t13["string (u8 hdr)"] = (t13["string (u8 hdr)"] or 0) + 1
            t14["string (u8 hdr)"] = (t14["string (u8 hdr)"] or 0) + v1074
        elseif v1070 == 11 then
            local v1076 = buffer.readu16(p51, n4)
            local v1077 = n4

            n4 = v1077 + (v1076 + 2)

            local v1078 = v1076 + 3

            t13["string (u16 hdr)"] = (t13["string (u16 hdr)"] or 0) + 1
            t14["string (u16 hdr)"] = (t14["string (u16 hdr)"] or 0) + v1078
        elseif v1070 == 12 then
            local v1080 = buffer.readu32(p51, n4)
            local v1081 = n4

            n4 = v1081 + (v1080 + 4)

            local v1082 = v1080 + 5

            t13["string (u32 hdr)"] = (t13["string (u32 hdr)"] or 0) + 1
            t14["string (u32 hdr)"] = (t14["string (u32 hdr)"] or 0) + v1082
        elseif v1070 == 13 then
            local v1084 = buffer.readu32(p51, n4)
            local v1085 = n4

            n4 = v1085 + (v1084 + 4)

            local v1086 = v1084 + 5

            t13.buffer = (t13.buffer or 0) + 1
            t14.buffer = (t14.buffer or 0) + v1086
        elseif v1070 == 14 then
            local v1088 = buffer.readu32(p51, n4)
            local v1089 = n4

            n4 = v1089 + (v1088 + 4)

            local v1090 = v1088 + 5

            t13.Enum = (t13.Enum or 0) + 1
            t14.Enum = (t14.Enum or 0) + v1090
        elseif v1070 == 15 then
            local v1092 = buffer.readu32(p51, n4)
            local v1093 = n4

            n4 = v1093 + (v1092 + 4 + 4)

            local v1094 = v1092 + 9

            t13.EnumItem = (t13.EnumItem or 0) + 1
            t14.EnumItem = (t14.EnumItem or 0) + v1094
        elseif v1070 == 16 then
            t13["table (empty)"] = (t13["table (empty)"] or 0) + 1
            t14["table (empty)"] = (t14["table (empty)"] or 0) + 1
        elseif v1070 == 17 then
            local v1096 = buffer.readu32(p51, n4)

            n4 += 4
            t13["table (array hdr)"] = (t13["table (array hdr)"] or 0) + 1
            t14["table (array hdr)"] = (t14["table (array hdr)"] or 0) + 5

            for _ = 1, v1096 do
                walk()
            end
        else
            if v1070 == 21 then
                t13["table (dict hdr)"] = (t13["table (dict hdr)"] or 0) + 1
                t14["table (dict hdr)"] = (t14["table (dict hdr)"] or 0) + 1

                while true and buffer.readu8(p51, n4) ~= 255 do
                    walk()
                    walk()
                end

                n4 += 1
                t13["table (sentinel)"] = (t13["table (sentinel)"] or 0) + 1
                t14["table (sentinel)"] = (t14["table (sentinel)"] or 0) + 1

                return
            end

            if v1070 == 64 then
                t13.Axes = (t13.Axes or 0) + 1
                t14.Axes = (t14.Axes or 0) + 2
                n4 += 1

                return
            end

            if v1070 == 65 then
                t13.BrickColor = (t13.BrickColor or 0) + 1
                t14.BrickColor = (t14.BrickColor or 0) + 3
                n4 += 2

                return
            end

            if v1070 == 66 then
                t13.CFrame = (t13.CFrame or 0) + 1
                t14.CFrame = (t14.CFrame or 0) + 49
                n4 += 48

                return
            end

            if v1070 == 67 then
                t13.Color3 = (t13.Color3 or 0) + 1
                t14.Color3 = (t14.Color3 or 0) + 13
                n4 += 12

                return
            end

            if v1070 == 68 then
                t13.ColorSeqKeypoint = (t13.ColorSeqKeypoint or 0) + 1
                t14.ColorSeqKeypoint = (t14.ColorSeqKeypoint or 0) + 17
                n4 += 16

                return
            end

            if v1070 == 69 then
                local v1099 = buffer.readu32(p51, n4)
                local v1100 = n4

                n4 = v1100 + (v1099 * 16 + 4)

                local v1101 = v1099 * 16 + 5

                t13.ColorSequence = (t13.ColorSequence or 0) + 1
                t14.ColorSequence = (t14.ColorSequence or 0) + v1101

                return
            end

            if v1070 == 70 then
                t13.DateTime = (t13.DateTime or 0) + 1
                t14.DateTime = (t14.DateTime or 0) + 9
                n4 += 8

                return
            end

            if v1070 == 71 then
                t13.Faces = (t13.Faces or 0) + 1
                t14.Faces = (t14.Faces or 0) + 2
                n4 += 1

                return
            end

            if v1070 == 72 then
                local v1103 = buffer.readu32(p51, n4)
                local v1104 = n4

                n4 = v1104 + (v1103 + 4 + 8)

                local v1105 = v1103 + 13

                t13.Font = (t13.Font or 0) + 1
                t14.Font = (t14.Font or 0) + v1105

                return
            end

            if v1070 == 73 then
                t13.NumberRange = (t13.NumberRange or 0) + 1
                t14.NumberRange = (t14.NumberRange or 0) + 9
                n4 += 8

                return
            end

            if v1070 == 74 then
                t13.NumSeqKeypoint = (t13.NumSeqKeypoint or 0) + 1
                t14.NumSeqKeypoint = (t14.NumSeqKeypoint or 0) + 13
                n4 += 12

                return
            end

            if v1070 == 75 then
                local v1107 = buffer.readu32(p51, n4)
                local v1108 = n4

                n4 = v1108 + (v1107 * 12 + 4)

                local v1109 = v1107 * 12 + 5

                t13.NumberSequence = (t13.NumberSequence or 0) + 1
                t14.NumberSequence = (t14.NumberSequence or 0) + v1109

                return
            end

            if v1070 == 76 then
                t13.PhysicalProperties = (t13.PhysicalProperties or 0) + 1
                t14.PhysicalProperties = (t14.PhysicalProperties or 0) + 21
                n4 += 20

                return
            end

            if v1070 == 77 then
                t13.Ray = (t13.Ray or 0) + 1
                t14.Ray = (t14.Ray or 0) + 25
                n4 += 24

                return
            end

            if v1070 == 78 then
                t13.Rect = (t13.Rect or 0) + 1
                t14.Rect = (t14.Rect or 0) + 17
                n4 += 16

                return
            end

            if v1070 == 79 then
                t13.Region3 = (t13.Region3 or 0) + 1
                t14.Region3 = (t14.Region3 or 0) + 25
                n4 += 24

                return
            end

            if v1070 == 80 then
                t13.Region3int16 = (t13.Region3int16 or 0) + 1
                t14.Region3int16 = (t14.Region3int16 or 0) + 13
                n4 += 12

                return
            end

            if v1070 == 81 then
                t13.TweenInfo = (t13.TweenInfo or 0) + 1
                t14.TweenInfo = (t14.TweenInfo or 0) + 22
                n4 += 21

                return
            end

            if v1070 == 82 then
                t13.UDim = (t13.UDim or 0) + 1
                t14.UDim = (t14.UDim or 0) + 9
                n4 += 8

                return
            end

            if v1070 == 83 then
                t13.UDim2 = (t13.UDim2 or 0) + 1
                t14.UDim2 = (t14.UDim2 or 0) + 17
                n4 += 16

                return
            end

            if v1070 == 84 then
                t13.Vector2 = (t13.Vector2 or 0) + 1
                t14.Vector2 = (t14.Vector2 or 0) + 9
                n4 += 8

                return
            end

            if v1070 == 85 then
                t13.Vector2int16 = (t13.Vector2int16 or 0) + 1
                t14.Vector2int16 = (t14.Vector2int16 or 0) + 5
                n4 += 4

                return
            end

            if v1070 == 86 then
                t13.Vector3 = (t13.Vector3 or 0) + 1
                t14.Vector3 = (t14.Vector3 or 0) + 13
                n4 += 12

                return
            end

            if v1070 == 87 then
                t13.Vector3int16 = (t13.Vector3int16 or 0) + 1
                t14.Vector3int16 = (t14.Vector3int16 or 0) + 7
                n4 += 6

                return
            end

            if v1070 == 88 then
                t13.PathWaypoint = (t13.PathWaypoint or 0) + 1
                t14.PathWaypoint = (t14.PathWaypoint or 0) + 14
                n4 += 13

                return
            end

            if v1070 == 89 then
                t13.FloatCurveKey = (t13.FloatCurveKey or 0) + 1
                t14.FloatCurveKey = (t14.FloatCurveKey or 0) + 10
                n4 += 9
            elseif v1070 == 90 then
                t13.RotationCurveKey = (t13.RotationCurveKey or 0) + 1
                t14.RotationCurveKey = (t14.RotationCurveKey or 0) + 54
                n4 += 53
            elseif v1070 == 91 then
                t13.Path2DControlPoint = (t13.Path2DControlPoint or 0) + 1
                t14.Path2DControlPoint = (t14.Path2DControlPoint or 0) + 49
                n4 += 48
            elseif v1070 == 92 then
                t13.Instance = (t13.Instance or 0) + 1
                t14.Instance = (t14.Instance or 0) + 5
                n4 += 4
            else
                local v1110 = ("unknown(%*)"):format(v1070)

                t13[v1110] = (t13[v1110] or 0) + 1
                t14[v1110] = (t14[v1110] or 0) + 1
            end
        end
    end

    walk()

    local t15 = {}

    for v1111, v1112 in t14 do
        table.insert(t15, {
            name = v1111,
            count = t13[v1111],
            bytes = v1112
        })
    end

    table.sort(t15, function(p54, p55) -- line: 1679
        return p54.bytes > p55.bytes
    end)

    local t17 = { string.format("Total: %d bytes\n%-25s %8s %8s %6s", v1068, "TYPE", "COUNT", "BYTES", "%") }

    table.insert(t17, (string.rep("-", 51)))

    for _, v1114 in t15 do
        table.insert(t17, string.format("%-25s %8d %8d %5.1f%%", v1114.name, v1114.count, v1114.bytes, v1114.bytes / v1068 * 100))
    end

    return table.concat(t17, "\n")
end

function t1.reset() -- line: 1696
    -- upvalues: v1 (ref), n1 (ref), n2 (ref)
    v1 = buffer.create(256)
    n2 = 256
    n1 = 0
end

return table.freeze(t1)
