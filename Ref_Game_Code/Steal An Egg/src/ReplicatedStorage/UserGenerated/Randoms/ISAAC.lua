-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.UserGenerated.Randoms.Base)

local GenerateSeed = require(ReplicatedStorage.UserGenerated.IO.Crypto.GenerateSeed)
local bxor, bor, band, lshift = bit32.bxor, bit32.bor, bit32.band, bit32.lshift
local rshift, floor, ldexp, sqrt = bit32.rshift, math.floor, math.ldexp, math.sqrt
local log, max, sin, cos = math.log, math.max, math.sin, math.cos
local clamp, create, clone, format = math.clamp, table.create, table.clone, string.format
local new, new2 = Vector2.new, Vector3.new

assert(true)

local v1 = Random.new()

local function IsInteger(p1) -- line: 43
    -- upvalues: floor (copy)
    if type(p1) ~= "number" or floor(p1) ~= p1 or p1 == 1e999 then
        return false
    end

    return p1 ~= (-1e999)
end

local function AssertIntegerNonNegative(p2) -- line: 48
    -- upvalues: floor (copy)
    if type(p2) ~= "number" or floor(p2) ~= p2 or p2 == 1e999 or p2 == (-1e999) then
        error("Integer", 2)
    end

    if not (p2 >= 0) then
        error("NonNegative", 2)
    end
end

local function IsaacMix(p3) -- line: 76
    -- upvalues: bxor (copy), bor (copy), lshift (copy), rshift (copy)
    local v2 = p3[1]
    local v3 = p3[2]
    local v4 = p3[3]
    local v5 = p3[4]
    local v6 = p3[5]
    local v7 = p3[6]
    local v8 = p3[7]
    local v9 = p3[8]
    local v11 = bxor(v2, (lshift(v3, 11)))
    local v13 = bor(v5 + v11, 0)
    local v17 = bxor(bor(v3 + v4, 0), (rshift(v4, 2)))
    local v19 = bor(v6 + v17, 0)
    local v23 = bxor(bor(v4 + v13, 0), (lshift(v13, 8)))
    local v25 = bor(v7 + v23, 0)
    local v29 = bxor(bor(v13 + v19, 0), (rshift(v19, 16)))
    local v31 = bor(v8 + v29, 0)
    local v35 = bxor(bor(v19 + v25, 0), (lshift(v25, 10)))
    local v37 = bor(v9 + v35, 0)
    local v41 = bxor(bor(v25 + v31, 0), (rshift(v31, 4)))
    local v43 = bor(v11 + v41, 0)
    local v47 = bxor(bor(v31 + v37, 0), (lshift(v37, 8)))
    local v49 = bor(v17 + v47, 0)
    local v53 = bxor(bor(v37 + v43, 0), (rshift(v43, 9)))
    local v55 = bor(v23 + v53, 0)

    p3[1] = bor(v43 + v49, 0)
    p3[2] = v49
    p3[3] = v55
    p3[4] = v29
    p3[5] = v35
    p3[6] = v41
    p3[7] = v47
    p3[8] = v53
end

local function Isaac(p4) -- line: 105
    -- upvalues: bxor (copy), bor (copy), band (copy), lshift (copy), rshift (copy)
    local v57, BB, CC, MM = p4.AA, p4.BB, p4.CC, p4.MM
    local RSL = p4.RSL
    local v59 = bor(CC + 1, 0)
    local v61 = bor(BB + v59, 0)

    for i = 1, 256 do
        local v62 = MM[i]
        local v63 = band(i, 3)

        if v63 == 0 then
            v57 = bxor(v57, (rshift(v57, 16)))
        elseif v63 == 1 then
            v57 = bxor(v57, (lshift(v57, 13)))
        elseif v63 == 2 then
            v57 = bxor(v57, (rshift(v57, 6)))
        elseif v63 == 3 then
            v57 = bxor(v57, (lshift(v57, 2)))
        end

        v57 = bor(MM[band(i + 127, 255) + 1] + v57, 0)

        local v71 = bor(MM[band(rshift(v62, 2), 255) + 1] + v57 + v61, 0)

        MM[i] = v71
        v61 = bor(MM[band(rshift(v71, 10), 255) + 1] + v62, 0)
        RSL[i] = v61
    end

    p4.AA = v57
    p4.BB = v61
    p4.CC = v59
end

local function IsaacInit(p5, p6) -- line: 132
    -- upvalues: bor (copy), create (copy), IsaacMix (copy)
    p5.AA = 0
    p5.BB = 0
    p5.CC = 0
    p5.Count = 256

    local MM, RSL = p5.MM, p5.RSL
    local v74 = create(8, 2654435769)

    IsaacMix(v74)
    IsaacMix(v74)
    IsaacMix(v74)
    IsaacMix(v74)

    for i = 0, 255, 8 do
        if p6 then
            for j = 1, 8 do
                v74[j] = bor(v74[j] + RSL[i + j], 0)
            end
        end

        IsaacMix(v74)
        MM[i + 1] = v74[1]
        MM[i + 2] = v74[2]
        MM[i + 3] = v74[3]
        MM[i + 4] = v74[4]
        MM[i + 5] = v74[5]
        MM[i + 6] = v74[6]
        MM[i + 7] = v74[7]
        MM[i + 8] = v74[8]
    end

    if p6 then
        for i = 0, 255, 8 do
            for j = 1, 8 do
                v74[j] = bor(v74[j] + MM[i + j], 0)
            end

            IsaacMix(v74)
            MM[i + 1] = v74[1]
            MM[i + 2] = v74[2]
            MM[i + 3] = v74[3]
            MM[i + 4] = v74[4]
            MM[i + 5] = v74[5]
            MM[i + 6] = v74[6]
            MM[i + 7] = v74[7]
            MM[i + 8] = v74[8]
        end
    end
end

local function NextU32(p7) -- line: 169
    -- upvalues: Isaac (copy)
    local v77 = p7.Count + 1

    if v77 > 256 then
        v77 = 1
        Isaac(p7)
    end

    p7.Count = v77

    return p7.RSL[v77]
end

local function NextU64(p8) -- line: 179
    -- upvalues: ldexp (copy), Isaac (copy)
    local v78 = p8.Count + 1

    if v78 > 256 then
        v78 = 1
        Isaac(p8)
    end

    p8.Count = v78

    local v80 = ldexp(p8.RSL[v78], 32)
    local v81 = p8.Count + 1

    if v81 > 256 then
        v81 = 1
        Isaac(p8)
    end

    p8.Count = v81

    return v80 + p8.RSL[v81]
end

local function NextFloat(p9) -- line: 183
    -- upvalues: ldexp (copy), Isaac (copy)
    local v82 = p9.Count + 1

    if v82 > 256 then
        v82 = 1
        Isaac(p9)
    end

    p9.Count = v82

    return (ldexp(p9.RSL[v82], -32))
end

local function NextDouble(p10) -- line: 187
    -- upvalues: ldexp (copy), Isaac (copy)
    local v84 = p10.Count + 1

    if v84 > 256 then
        v84 = 1
        Isaac(p10)
    end

    p10.Count = v84

    local v86 = ldexp(p10.RSL[v84], 32)
    local v87 = p10.Count + 1

    if v87 > 256 then
        v87 = 1
        Isaac(p10)
    end

    p10.Count = v87

    return (ldexp(v86 + p10.RSL[v87], -64))
end

local function NextNumber(p11, p12, p13) -- line: 191
    -- upvalues: ldexp (copy), Isaac (copy)
    local v89 = p13 - p12
    local v90 = p11.Count + 1

    if v90 > 256 then
        v90 = 1
        Isaac(p11)
    end

    p11.Count = v90

    local v92 = ldexp(p11.RSL[v90], 32)
    local v93 = p11.Count + 1

    if v93 > 256 then
        v93 = 1
        Isaac(p11)
    end

    p11.Count = v93

    return p12 + v89 * ldexp(v92 + p11.RSL[v93], -64)
end

local function NextInteger(p14, p15, p16) -- line: 195
    -- upvalues: floor (copy), ldexp (copy), Isaac (copy)
    local v95 = p16 - p15 + 1
    local v96 = p14.Count + 1

    if v96 > 256 then
        v96 = 1
        Isaac(p14)
    end

    p14.Count = v96

    local v98 = ldexp(p14.RSL[v96], 32)
    local v99 = p14.Count + 1

    if v99 > 256 then
        v99 = 1
        Isaac(p14)
    end

    p14.Count = v99

    return (floor(p15 + v95 * ldexp(v98 + p14.RSL[v99], -64)))
end

local function NextNormal(p17, p18, p19) -- line: 199
    -- upvalues: ldexp (copy), sqrt (copy), log (copy), max (copy), sin (copy), cos (copy), Isaac (copy)
    local v102 = p17.Count + 1

    if v102 > 256 then
        v102 = 1
        Isaac(p17)
    end

    p17.Count = v102

    local v104 = ldexp(p17.RSL[v102], 32)
    local v105 = p17.Count + 1

    if v105 > 256 then
        v105 = 1
        Isaac(p17)
    end

    p17.Count = v105

    local v110 = sqrt(log((max(2.2250738585072014E-308, (ldexp(v104 + p17.RSL[v105], -64))))) * -2) * (p19 or 0)
    local v111 = p17.Count + 1

    if v111 > 256 then
        v111 = 1
        Isaac(p17)
    end

    p17.Count = v111

    local v113 = ldexp(p17.RSL[v111], 32)
    local v114 = p17.Count + 1

    if v114 > 256 then
        v114 = 1
        Isaac(p17)
    end

    p17.Count = v114

    local v116 = 6.283185307179586 * ldexp(v113 + p17.RSL[v114], -64)

    p18 = p18 or 0

    return cos(v116) * v110 + p18, sin(v116) * v110 + p18
end

local function NextBoolean(p20, p21) -- line: 206
    -- upvalues: ldexp (copy), Isaac (copy)
    local v118 = p20.Count + 1

    if v118 > 256 then
        v118 = 1
        Isaac(p20)
    end

    p20.Count = v118

    local v120 = ldexp(p20.RSL[v118], 32)
    local v121 = p20.Count + 1

    if v121 > 256 then
        v121 = 1
        Isaac(p20)
    end

    p20.Count = v121

    return ldexp(v120 + p20.RSL[v121], -64) < (p21 or 0.5)
end

local function NextVector2(p22, p23) -- line: 210
    -- upvalues: ldexp (copy), sin (copy), cos (copy), new (copy), Isaac (copy)
    p23 = p23 or 1

    local v124 = p22.Count + 1

    if v124 > 256 then
        v124 = 1
        Isaac(p22)
    end

    p22.Count = v124

    local v126 = ldexp(p22.RSL[v124], 32)
    local v127 = p22.Count + 1

    if v127 > 256 then
        v127 = 1
        Isaac(p22)
    end

    p22.Count = v127

    local v129 = 6.283185307179586 * ldexp(v126 + p22.RSL[v127], -64)

    return new(cos(v129) * p23, sin(v129) * p23)
end

local function NextVector3(p24, p25) -- line: 216
    -- upvalues: ldexp (copy), sqrt (copy), sin (copy), cos (copy), new2 (copy), Isaac (copy)
    p25 = p25 or 1

    local v131 = p24.Count + 1

    if v131 > 256 then
        v131 = 1
        Isaac(p24)
    end

    p24.Count = v131

    local v133 = ldexp(p24.RSL[v131], 32)
    local v134 = p24.Count + 1

    if v134 > 256 then
        v134 = 1
        Isaac(p24)
    end

    p24.Count = v134

    local v136 = 6.283185307179586 * ldexp(v133 + p24.RSL[v134], -64)
    local v137 = p24.Count + 1

    if v137 > 256 then
        v137 = 1
        Isaac(p24)
    end

    p24.Count = v137

    local v139 = ldexp(p24.RSL[v137], 32)
    local v140 = p24.Count + 1

    if v140 > 256 then
        v140 = 1
        Isaac(p24)
    end

    p24.Count = v140

    local v142 = ldexp(v139 + p24.RSL[v140], -64) * 2 - 1
    local v144 = sqrt(1 - v142 * v142)

    return (new2(cos(v136) * v144 * p25, sin(v136) * v144 * p25, v142 * p25))
end

local function NextUUIDv4(p26) -- line: 224
    -- upvalues: bor (copy), band (copy), format (copy), Isaac (copy)
    local v148 = p26.Count + 1

    if v148 > 256 then
        v148 = 1
        Isaac(p26)
    end

    p26.Count = v148

    local v149 = p26.RSL[v148]
    local v150 = p26.Count + 1

    if v150 > 256 then
        v150 = 1
        Isaac(p26)
    end

    p26.Count = v150

    local v153 = bor(band(p26.RSL[v150], 4294905855), 16384)
    local v154 = p26.Count + 1

    if v154 > 256 then
        v154 = 1
        Isaac(p26)
    end

    p26.Count = v154

    local v157 = bor(band(p26.RSL[v154], 1073741823), 2147483648)
    local v158 = p26.Count + 1

    if v158 > 256 then
        v158 = 1
        Isaac(p26)
    end

    p26.Count = v158

    return format("%08x%08x%08x%08x", v149, v153, v157, p26.RSL[v158])
end

local function Seed(p27, p28, p29) -- line: 234
    -- upvalues: bor (copy), v1 (copy), IsaacInit (copy)
    local v159

    if p28 ~= nil then
        if type(p28) == "number" then
            v159 = { p28 }
        else
            assert(type(p28) == "table")
            v159 = p28
        end
    else
        v159 = { v1:NextInteger(0, 4294967295) }
    end

    local v161 = true

    if p29 ~= nil then
        assert(type(p29) == "boolean")
        v161 = p29
    end

    local v164 = math.min(256, #v159)
    local MM, RSL = p27.MM, p27.RSL

    for i = 1, 256 do
        MM[i] = 0
        RSL[i] = 0
    end

    for i = 1, v164 do
        RSL[i] = bor(v159[i], 0)
    end

    IsaacInit(p27, v161)
end

local function Shuffle(p30, p31) -- line: 261
    -- upvalues: floor (copy), ldexp (copy), Isaac (copy)
    assert(type(p31) == "table")

    for i = #p31, 2, -1 do
        local v167 = i - 1 + 1
        local v168 = p30.Count + 1

        if v168 > 256 then
            v168 = 1
            Isaac(p30)
        end

        p30.Count = v168

        local v170 = ldexp(p30.RSL[v168], 32)
        local v171 = p30.Count + 1

        if v171 > 256 then
            v171 = 1
            Isaac(p30)
        end

        p30.Count = v171

        local v174 = floor(v167 * ldexp(v170 + p30.RSL[v171], -64) + 1)
        local v175 = p31[v174]
        local v176 = p31[i]

        p31[i] = v175
        p31[v174] = v176
    end
end

local function Clone(p32) -- line: 269
    -- upvalues: clone (copy)
    return (setmetatable({
        RSL = clone(p32.RSL),
        Count = p32.Count,
        MM = clone(p32.MM),
        AA = p32.AA,
        BB = p32.BB,
        CC = p32.CC
    }, (getmetatable(p32))))
end

local v177 = table.freeze({
    NextU32 = NextU32,
    NextU64 = NextU64,
    NextFloat = NextFloat,
    NextDouble = NextDouble,
    NextNumber = NextNumber,
    NextInteger = NextInteger,
    NextNormal = NextNormal,
    NextBoolean = NextBoolean,
    NextVector2 = NextVector2,
    NextVector3 = NextVector3,
    NextUUIDv4 = NextUUIDv4,
    Seed = Seed,
    Shuffle = Shuffle,
    Clone = Clone
})
local v178 = table.freeze({
    __index = v177
})
local t2 = {}

function t2.new(p33, p34) -- line: 301
    -- upvalues: create (copy), Seed (copy), v178 (copy)
    local t3 = {
        Count = 0,
        AA = 0,
        BB = 0,
        CC = 0,
        RSL = create(256, 0),
        MM = create(256, 0)
    }

    Seed(t3, p33, p34)

    return (setmetatable(t3, v178))
end

function t2.Unique(p35) -- line: 314
    -- upvalues: GenerateSeed (copy), floor (copy), clamp (copy), t2 (copy)
    if p35 ~= nil then
        if type(p35) ~= "number" or floor(p35) ~= p35 or p35 == 1e999 or p35 == (-1e999) then
            error("Integer", 2)
        end

        if not (p35 >= 0) then
            error("NonNegative", 2)
        end
    end

    local v180 = clamp(p35 or 32, 0, 256)

    return t2.new(GenerateSeed(v180), true)
end

t2.R = t2.Unique()

return table.freeze(t2)
