-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.UserGenerated.Randoms.Base)

local GenerateSeed = require(ReplicatedStorage.UserGenerated.IO.Crypto.GenerateSeed)
local Theory = require(script.Theory)
local bxor, bor, band, lshift = bit32.bxor, bit32.bor, bit32.band, bit32.lshift
local rshift, floor, ldexp, sqrt = bit32.rshift, math.floor, math.ldexp, math.sqrt
local log, max, sin, cos = math.log, math.max, math.sin, math.cos
local clamp, format, new, new2 = math.clamp, string.format, Vector2.new, Vector3.new

assert(true)

local v1 = Random.new()

local function Mul32(p1, p2) -- line: 42
    -- upvalues: band (copy), lshift (copy), rshift (copy)
    local v2 = rshift(p1, 16)
    local v3 = band(p1, 65535)
    local v4 = rshift(p2, 16)
    local v5 = band(p2, 65535)

    return lshift(band(v2 * v5 + v3 * v4, 65535), 16) + v3 * v5
end

local function IsInteger(p3) -- line: 53
    -- upvalues: floor (copy)
    if type(p3) ~= "number" or floor(p3) ~= p3 or p3 == 1e999 then
        return false
    end

    return p3 ~= (-1e999)
end

local function AssertInteger(p4) -- line: 57
    -- upvalues: floor (copy)
    if type(p4) ~= "number" or floor(p4) ~= p4 or p4 == 1e999 or p4 == (-1e999) then
        error("Integer", 2)
    end
end

local function AssertIntegerNonNegative(p5) -- line: 64
    -- upvalues: floor (copy)
    if type(p5) ~= "number" or floor(p5) ~= p5 or p5 == 1e999 or p5 == (-1e999) then
        error("Integer", 2)
    end

    if not (p5 >= 0) then
        error("NonNegative", 2)
    end
end

local function NextU32(p6) -- line: 89
    -- upvalues: bxor (copy), lshift (copy), rshift (copy)
    local x, w = p6.x, p6.w
    local v9 = bxor(x, (lshift(x, 11)))
    local v14 = bxor(bxor(bxor(v9, (rshift(v9, 8))), w), (rshift(w, 19)))
    local y, z = p6.y, p6.z

    p6.x = y
    p6.y = z
    p6.z = w
    p6.w = v14

    return v14
end

local function NextU64(p7) -- line: 99
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy)
    local x, w = p7.x, p7.w
    local v16 = bxor(x, (lshift(x, 11)))
    local v21 = bxor(bxor(bxor(v16, (rshift(v16, 8))), w), (rshift(w, 19)))
    local y, z = p7.y, p7.z

    p7.x = y
    p7.y = z
    p7.z = w
    p7.w = v21

    local v22 = ldexp(v21, 32)
    local x2, w2 = p7.x, p7.w
    local v24 = bxor(x2, (lshift(x2, 11)))
    local v29 = bxor(bxor(bxor(v24, (rshift(v24, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p7.y, p7.z

    p7.x = y2
    p7.y = z2
    p7.z = w2
    p7.w = v29

    return v22 + v29
end

local function NextFloat(p8) -- line: 103
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy)
    local x, w = p8.x, p8.w
    local v31 = bxor(x, (lshift(x, 11)))
    local v36 = bxor(bxor(bxor(v31, (rshift(v31, 8))), w), (rshift(w, 19)))
    local y, z = p8.y, p8.z

    p8.x = y
    p8.y = z
    p8.z = w
    p8.w = v36

    return (ldexp(v36, -32))
end

local function NextDouble(p9) -- line: 107
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy)
    local x, w = p9.x, p9.w
    local v38 = bxor(x, (lshift(x, 11)))
    local v43 = bxor(bxor(bxor(v38, (rshift(v38, 8))), w), (rshift(w, 19)))
    local y, z = p9.y, p9.z

    p9.x = y
    p9.y = z
    p9.z = w
    p9.w = v43

    local v44 = ldexp(v43, 32)
    local x2, w2 = p9.x, p9.w
    local v46 = bxor(x2, (lshift(x2, 11)))
    local v51 = bxor(bxor(bxor(v46, (rshift(v46, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p9.y, p9.z

    p9.x = y2
    p9.y = z2
    p9.z = w2
    p9.w = v51

    return (ldexp(v44 + v51, -64))
end

local function NextNumber(p10, p11, p12) -- line: 111
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy)
    local v53 = p12 - p11
    local x, w = p10.x, p10.w
    local v55 = bxor(x, (lshift(x, 11)))
    local v60 = bxor(bxor(bxor(v55, (rshift(v55, 8))), w), (rshift(w, 19)))
    local y, z = p10.y, p10.z

    p10.x = y
    p10.y = z
    p10.z = w
    p10.w = v60

    local v61 = ldexp(v60, 32)
    local x2, w2 = p10.x, p10.w
    local v63 = bxor(x2, (lshift(x2, 11)))
    local v68 = bxor(bxor(bxor(v63, (rshift(v63, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p10.y, p10.z

    p10.x = y2
    p10.y = z2
    p10.z = w2
    p10.w = v68

    return p11 + v53 * ldexp(v61 + v68, -64)
end

local function NextInteger(p13, p14, p15) -- line: 115
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), floor (copy), ldexp (copy)
    local v70 = p15 - p14 + 1
    local x, w = p13.x, p13.w
    local v72 = bxor(x, (lshift(x, 11)))
    local v77 = bxor(bxor(bxor(v72, (rshift(v72, 8))), w), (rshift(w, 19)))
    local y, z = p13.y, p13.z

    p13.x = y
    p13.y = z
    p13.z = w
    p13.w = v77

    local v78 = ldexp(v77, 32)
    local x2, w2 = p13.x, p13.w
    local v80 = bxor(x2, (lshift(x2, 11)))
    local v85 = bxor(bxor(bxor(v80, (rshift(v80, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p13.y, p13.z

    p13.x = y2
    p13.y = z2
    p13.z = w2
    p13.w = v85

    return (floor(p14 + v70 * ldexp(v78 + v85, -64)))
end

local function NextNormal(p16, p17, p18) -- line: 119
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy), sqrt (copy), log (copy), max (copy), sin (copy), cos (copy)
    local x, w = p16.x, p16.w
    local v89 = bxor(x, (lshift(x, 11)))
    local v94 = bxor(bxor(bxor(v89, (rshift(v89, 8))), w), (rshift(w, 19)))
    local y, z = p16.y, p16.z

    p16.x = y
    p16.y = z
    p16.z = w
    p16.w = v94

    local v95 = ldexp(v94, 32)
    local x2, w2 = p16.x, p16.w
    local v97 = bxor(x2, (lshift(x2, 11)))
    local v102 = bxor(bxor(bxor(v97, (rshift(v97, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p16.y, p16.z

    p16.x = y2
    p16.y = z2
    p16.z = w2
    p16.w = v102

    local v107 = sqrt(log((max(2.2250738585072014E-308, (ldexp(v95 + v102, -64))))) * -2) * (p18 or 0)
    local x3, w3 = p16.x, p16.w
    local v109 = bxor(x3, (lshift(x3, 11)))
    local v114 = bxor(bxor(bxor(v109, (rshift(v109, 8))), w3), (rshift(w3, 19)))
    local y3, z3 = p16.y, p16.z

    p16.x = y3
    p16.y = z3
    p16.z = w3
    p16.w = v114

    local v115 = ldexp(v114, 32)
    local x4, w4 = p16.x, p16.w
    local v117 = bxor(x4, (lshift(x4, 11)))
    local v122 = bxor(bxor(bxor(v117, (rshift(v117, 8))), w4), (rshift(w4, 19)))
    local y4, z4 = p16.y, p16.z

    p16.x = y4
    p16.y = z4
    p16.z = w4
    p16.w = v122

    local v124 = 6.283185307179586 * ldexp(v115 + v122, -64)

    p17 = p17 or 0

    return cos(v124) * v107 + p17, sin(v124) * v107 + p17
end

local function NextBoolean(p19, p20) -- line: 126
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy)
    local x, w = p19.x, p19.w
    local v127 = bxor(x, (lshift(x, 11)))
    local v132 = bxor(bxor(bxor(v127, (rshift(v127, 8))), w), (rshift(w, 19)))
    local y, z = p19.y, p19.z

    p19.x = y
    p19.y = z
    p19.z = w
    p19.w = v132

    local v133 = ldexp(v132, 32)
    local x2, w2 = p19.x, p19.w
    local v135 = bxor(x2, (lshift(x2, 11)))
    local v140 = bxor(bxor(bxor(v135, (rshift(v135, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p19.y, p19.z

    p19.x = y2
    p19.y = z2
    p19.z = w2
    p19.w = v140

    return ldexp(v133 + v140, -64) < (p20 or 0.5)
end

local function NextVector2(p21, p22) -- line: 130
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy), sin (copy), cos (copy), new (copy)
    p22 = p22 or 1

    local x, w = p21.x, p21.w
    local v144 = bxor(x, (lshift(x, 11)))
    local v149 = bxor(bxor(bxor(v144, (rshift(v144, 8))), w), (rshift(w, 19)))
    local y, z = p21.y, p21.z

    p21.x = y
    p21.y = z
    p21.z = w
    p21.w = v149

    local v150 = ldexp(v149, 32)
    local x2, w2 = p21.x, p21.w
    local v152 = bxor(x2, (lshift(x2, 11)))
    local v157 = bxor(bxor(bxor(v152, (rshift(v152, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p21.y, p21.z

    p21.x = y2
    p21.y = z2
    p21.z = w2
    p21.w = v157

    local v159 = 6.283185307179586 * ldexp(v150 + v157, -64)

    return new(cos(v159) * p22, sin(v159) * p22)
end

local function NextVector3(p23, p24) -- line: 136
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), ldexp (copy), sqrt (copy), sin (copy), cos (copy), new2 (copy)
    p24 = p24 or 1

    local x, w = p23.x, p23.w
    local v162 = bxor(x, (lshift(x, 11)))
    local v167 = bxor(bxor(bxor(v162, (rshift(v162, 8))), w), (rshift(w, 19)))
    local y, z = p23.y, p23.z

    p23.x = y
    p23.y = z
    p23.z = w
    p23.w = v167

    local v168 = ldexp(v167, 32)
    local x2, w2 = p23.x, p23.w
    local v170 = bxor(x2, (lshift(x2, 11)))
    local v175 = bxor(bxor(bxor(v170, (rshift(v170, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p23.y, p23.z

    p23.x = y2
    p23.y = z2
    p23.z = w2
    p23.w = v175

    local v177 = 6.283185307179586 * ldexp(v168 + v175, -64)
    local x3, w3 = p23.x, p23.w
    local v179 = bxor(x3, (lshift(x3, 11)))
    local v184 = bxor(bxor(bxor(v179, (rshift(v179, 8))), w3), (rshift(w3, 19)))
    local y3, z3 = p23.y, p23.z

    p23.x = y3
    p23.y = z3
    p23.z = w3
    p23.w = v184

    local v185 = ldexp(v184, 32)
    local x4, w4 = p23.x, p23.w
    local v187 = bxor(x4, (lshift(x4, 11)))
    local v192 = bxor(bxor(bxor(v187, (rshift(v187, 8))), w4), (rshift(w4, 19)))
    local y4, z4 = p23.y, p23.z

    p23.x = y4
    p23.y = z4
    p23.z = w4
    p23.w = v192

    local v194 = ldexp(v185 + v192, -64) * 2 - 1
    local v196 = sqrt(1 - v194 * v194)

    return (new2(cos(v177) * v196 * p24, sin(v177) * v196 * p24, v194 * p24))
end

local function NextUUIDv4(p25) -- line: 144
    -- upvalues: bxor (copy), bor (copy), band (copy), lshift (copy), rshift (copy), format (copy)
    local x, w = p25.x, p25.w
    local v201 = bxor(x, (lshift(x, 11)))
    local v206 = bxor(bxor(bxor(v201, (rshift(v201, 8))), w), (rshift(w, 19)))
    local y, z = p25.y, p25.z

    p25.x = y
    p25.y = z
    p25.z = w
    p25.w = v206

    local x2, w2 = p25.x, p25.w
    local v208 = bxor(x2, (lshift(x2, 11)))
    local v213 = bxor(bxor(bxor(v208, (rshift(v208, 8))), w2), (rshift(w2, 19)))
    local y2, z2 = p25.y, p25.z

    p25.x = y2
    p25.y = z2
    p25.z = w2
    p25.w = v213

    local v215 = bor(band(v213, 4294905855), 16384)
    local x3, w3 = p25.x, p25.w
    local v217 = bxor(x3, (lshift(x3, 11)))
    local v222 = bxor(bxor(bxor(v217, (rshift(v217, 8))), w3), (rshift(w3, 19)))
    local y3, z3 = p25.y, p25.z

    p25.x = y3
    p25.y = z3
    p25.z = w3
    p25.w = v222

    local v224 = bor(band(v222, 1073741823), 2147483648)
    local x4, w4 = p25.x, p25.w
    local v226 = bxor(x4, (lshift(x4, 11)))
    local v231 = bxor(bxor(bxor(v226, (rshift(v226, 8))), w4), (rshift(w4, 19)))
    local y4, z4 = p25.y, p25.z

    p25.x = y4
    p25.y = z4
    p25.z = w4
    p25.w = v231

    return format("%08x%08x%08x%08x", v206, v215, v224, v231)
end

local function Seed(p26, p27) -- line: 154
    -- upvalues: bor (copy), band (copy), lshift (copy), rshift (copy), v1 (copy)
    local v232 = if p27 == nil then {} elseif type(p27) == "number" then { p27 } else p27
    local v233 = v232[1]
    local v234 = v232[2]
    local v235 = v232[3]
    local v236 = v232[4]
    local v238 = bor(v233 or v1:NextInteger(0, 4294967295), 0)

    if not v234 then
        local v239 = rshift(v238, 16)
        local v240 = band(v238, 65535)

        v234 = lshift(band(v240 * 27655 + v239 * 35173, 65535), 16) + v240 * 35173 + 1
    end

    local v243 = bor(v234, 0)

    if not v235 then
        local v244 = rshift(v243, 16)
        local v245 = band(v243, 65535)

        v235 = lshift(band(v245 * 27655 + v244 * 35173, 65535), 16) + v245 * 35173 + 1
    end

    local v248 = bor(v235, 0)

    if not v236 then
        local v249 = rshift(v248, 16)
        local v250 = band(v248, 65535)

        v236 = lshift(band(v250 * 27655 + v249 * 35173, 65535), 16) + v250 * 35173 + 1
    end

    local v253 = bor(v236, 0)

    p26.x = v238
    p26.y = v243
    p26.z = v248
    p26.w = v253
end

local function Shuffle(p28, p29) -- line: 185
    -- upvalues: bxor (copy), lshift (copy), rshift (copy), floor (copy), ldexp (copy)
    assert(type(p29) == "table")

    for i = #p29, 2, -1 do
        local v255 = i - 1 + 1
        local x, w = p28.x, p28.w
        local v257 = bxor(x, (lshift(x, 11)))
        local v262 = bxor(bxor(bxor(v257, (rshift(v257, 8))), w), (rshift(w, 19)))
        local y, z = p28.y, p28.z

        p28.x = y
        p28.y = z
        p28.z = w
        p28.w = v262

        local v263 = ldexp(v262, 32)
        local x2, w2 = p28.x, p28.w
        local v265 = bxor(x2, (lshift(x2, 11)))
        local v270 = bxor(bxor(bxor(v265, (rshift(v265, 8))), w2), (rshift(w2, 19)))
        local y2, z2 = p28.y, p28.z

        p28.x = y2
        p28.y = z2
        p28.z = w2
        p28.w = v270

        local v273 = floor(v255 * ldexp(v263 + v270, -64) + 1)
        local v274 = p29[v273]
        local v275 = p29[i]

        p29[i] = v274
        p29[v273] = v275
    end
end

local function Clone(p30) -- line: 193
    return (setmetatable({
        x = p30.x,
        y = p30.y,
        z = p30.z,
        w = p30.w
    }, (getmetatable(p30))))
end

local function GetState(p31) -- line: 203
    return {
        p31.x,
        p31.y,
        p31.z,
        p31.w
    }
end

local function Skip(p32, p33) -- line: 207
    -- upvalues: Theory (copy), floor (copy)
    if type(p33) ~= "number" or floor(p33) ~= p33 or p33 == 1e999 or p33 == (-1e999) then
        error("Integer", 2)
    end

    local v276, v277, v278, v279 = Theory.Transform(p32.x, p32.y, p32.z, p32.w, p33)

    p32.x = v276
    p32.y = v277
    p32.z = v278
    p32.w = v279
end

local v280 = table.freeze({
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
    Clone = Clone,
    GetState = GetState,
    Skip = Skip
})
local v281 = table.freeze({
    __index = v280
})
local t2 = {}

function t2.new(p34) -- line: 234
    -- upvalues: Seed (copy), v281 (copy)
    local t3 = {
        x = 0,
        y = 0,
        z = 0,
        w = 0
    }

    Seed(t3, p34)

    return (setmetatable(t3, v281))
end

function t2.Unique(p35) -- line: 245
    -- upvalues: GenerateSeed (copy), floor (copy), clamp (copy), t2 (copy)
    if p35 ~= nil then
        if type(p35) ~= "number" or floor(p35) ~= p35 or p35 == 1e999 or p35 == (-1e999) then
            error("Integer", 2)
        end

        if not (p35 >= 0) then
            error("NonNegative", 2)
        end
    end

    local v283 = clamp(p35 or 4, 0, 4)

    return t2.new(GenerateSeed(v283))
end

t2.R = t2.Unique()

return table.freeze(t2)
