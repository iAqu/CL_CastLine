-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanConfig = require(script.Parent:WaitForChild("TitanConfig"))
local t1 = {
    AXIS = Vector3.new(50, 0, 0)
}
local line = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("WorldConfig")).PIT_DROP

t1.START_Y = -2250 + line
t1.PLANKS_Y = -2104 + line
t1.SPEED = 350
t1.RISE = {
    EASE = 1.2
}
t1.SURFACE = 40
t1.SAND = {
    IN = 60,
    Y = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("WorldConfig")).PIT.SAND
}
t1.PIECES = {
    {
        line = t1.SURFACE - t1.START_Y
    },
    {
        arc = 400,
        turn = -175
    },
    {
        line = 285
    }
}
t1.FADE = 1.5
t1.DIRECTIONS = { 45, 135, 225, 315 }
t1.CAVE = {
    CENTRE = Vector3.new(50, -4000, 0),
    POOL_Y = -4113,
    CEIL_Y = -3740,
    UNDER = 620,
    REAR = 170,
    TURN_R = 60,
    WALL = 560,
    PILLARS = {
        RADIUS = 260,
        EDGE = 15,
        ANGLES = { 0, 60, 120, 180, 240, 300 }
    }
}
t1.RING = {
    R = 150,
    Y = -25,
    THROW_LAP = 0.22,
    SWIM = 150,
    DECEL = 2.5,
    HUMP = {
        A = 45,
        N = 2
    },
    THRASH = {
        A = 30,
        N = 1.5,
        LAP = 0.55
    },
    SURGE = {
        K = 0.3,
        PERIOD = 9
    }
}
t1.STYLES = {
    TitanJormungandr = {
        SWIM = 340,
        DECEL = 1.5,
        WIGGLE = {
            A = 35,
            WAVE = 330
        },
        ARENA = {
            STEP = 3,
            MAX = 250000,
            RHO = 100,
            EDGE = 195,
            MARGIN = 15,
            LOW = -140,
            BLEND = 100,
            VGAIN = 0.35,
            PITCH = 35,
            PITCH_RATE = 0.6,
            WIGGLE = 0.3,
            FADE = 200,
            TURNS = {
                { "turn", 6 },
                { "straight", 3 },
                { "hard", 1.5 }
            },
            SEG = { 300, 700 },
            KAPPA = { 0.08, 0.3 },
            HARD = { 0.4, 0.48 },
            HEIGHTS = {
                { "cruise", 5 },
                { "dive", 2 }
            },
            VSEG = { 300, 700 },
            CRUISE = { -70, -45 },
            DIVE = { -230, -150 },
            JUMP = {
                RETRY = 2500,
                DEEP = -200,
                FROM_Y = -130,
                SURF = 80,
                SLACK = 60,
                LINE = 0.7,
                WAIT = 1500,
                UP = 85,
                TURN_UP = 1,
                TURN_OVER = 1.5,
                OUT = -60,
                FIRST = { 12000, 16000 },
                GAP = { 12000, 20000 },
                APEX = { 50, 100 }
            }
        },
        SURGES = {
            {
                K = 0.32,
                P = 22.3
            },
            {
                K = 0.2,
                P = 14.1
            },
            {
                K = 0.12,
                P = 35.9
            }
        }
    },
    Karkinos = {
        CLIMB = {
            BOUNDS = 9,
            FROM = 0.62,
            CATCH = 0.7,
            LAST_Y = 5,
            EXIT_AT = 0.1,
            EXIT_K = 2.6,
            SPEED = {
                { 0, 0.03 },
                { 0.18, 0.03 },
                { 0.3, 1.3 },
                { 0.5, 2.2 },
                { 0.66, 1.8 },
                { 0.7, 1.5 },
                { 0.74, 0.15 },
                { 0.85, 0.05 },
                { 1, 0.03 }
            }
        }
    },
    Aspidochelone = {
        SWIM = 190,
        DECEL = 2,
        ARENA = {
            STEP = 3,
            MAX = 250000,
            RHO = 85,
            EDGE = 168,
            MARGIN = 15,
            LOW = -140,
            BLEND = 140,
            VGAIN = 0.3,
            PITCH = 28,
            PITCH_RATE = 0.4,
            FADE = 200,
            TURNS = {
                { "turn", 6 },
                { "straight", 4 },
                { "hard", 1 }
            },
            SEG = { 350, 800 },
            KAPPA = { 0.08, 0.3 },
            HARD = { 0.4, 0.47 },
            HEIGHTS = {
                { "cruise", 6 },
                { "dive", 2 }
            },
            VSEG = { 300, 700 },
            CRUISE = { -24, -14 },
            DIVE = { -200, -140 },
            JUMP = {
                RETRY = 2500,
                DEEP = -190,
                FROM_Y = -130,
                SURF = 90,
                SLACK = 35,
                LINE = 0.7,
                WAIT = 1500,
                UP = 70,
                TURN_UP = 0.8,
                TURN_OVER = 1.1,
                OUT = -60,
                FIRST = { 9000, 13000 },
                GAP = { 13000, 20000 },
                APEX = { 35, 60 }
            }
        },
        SURGES = {
            {
                K = 0.25,
                P = 21.7
            },
            {
                K = 0.15,
                P = 13.3
            },
            {
                K = 0.1,
                P = 33.1
            }
        }
    },
    Umibozu = {
        SWIM = 230,
        DECEL = 2,
        ARENA = {
            STEP = 3,
            MAX = 250000,
            RHO = 65,
            EDGE = 165,
            MARGIN = 15,
            LOW = -140,
            BLEND = 120,
            VGAIN = 0.3,
            PITCH = 30,
            PITCH_RATE = 0.5,
            FADE = 200,
            TURNS = {
                { "turn", 6 },
                { "straight", 3 },
                { "hard", 1.5 }
            },
            SEG = { 300, 700 },
            KAPPA = { 0.08, 0.3 },
            HARD = { 0.4, 0.47 },
            HEIGHTS = {
                { "cruise", 5 },
                { "dive", 2 }
            },
            VSEG = { 300, 700 },
            CRUISE = { -45, -30 },
            DIVE = { -210, -150 },
            JUMP = {
                RETRY = 2500,
                DEEP = -200,
                FROM_Y = -130,
                SURF = 85,
                SLACK = 30,
                LINE = 0.7,
                WAIT = 1500,
                UP = 85,
                TURN_UP = 1,
                TURN_OVER = 1.6,
                OUT = -60,
                FIRST = { 7000, 10000 },
                GAP = { 10000, 16000 },
                APEX = { 30, 55 }
            }
        },
        SURGES = {
            {
                K = 0.28,
                P = 19.9
            },
            {
                K = 0.16,
                P = 12.7
            },
            {
                K = 0.1,
                P = 31.3
            }
        }
    }
}
t1.STYLES.Ammonarch = t1.STYLES.Aspidochelone
t1.STYLES.Spinosauron = t1.STYLES.Umibozu
t1.STYLES.Dunkeltorian = t1.STYLES.Aspidochelone
t1.STYLES.Plessiomother = t1.STYLES.Umibozu
t1.STYLES.Bagosaurus = t1.STYLES.Umibozu
t1.FIGHT = {
    HAND = 1.9,
    START = 9.25,
    MAX = 300,
    OUTRO = 5
}
t1.cave = false

local t2 = {}
local n1 = 0
local START_Y = t1.START_Y
local n2 = 0
local n3 = 0
local n4 = 90
local v1, v2

for _, v3 in ipairs(t1.PIECES) do
    line = v3.line

    local v4

    if not line then
        v1 = v3.turn
        v4 = math.abs(v1)
        line = math.rad(v4) * v3.arc
    end

    t2[#t2 + 1] = {
        piece = v3,
        s0 = n2,
        len = line,
        u = n3,
        y = START_Y,
        h = n4
    }

    if v3.line then
        v1 = math.rad(n4)
        n3 += math.cos(v1) * line
        v1 = math.rad(n4)
        START_Y += math.sin(v1) * line
    else
        local v5 = if v3.turn > 0 then 1 else -1

        v2 = v5 * v3.arc
        v4 = n3 + v2 * -math.sin((math.rad(n4)))
        v2 = v5 * v3.arc
        v1 = START_Y + v2 * math.cos((math.rad(n4)))
        n4 += v3.turn
        v2 = v5 * v3.arc
        n3 = v4 - v2 * -math.sin((math.rad(n4)))
        v2 = v5 * v3.arc
        START_Y = v1 - v2 * math.cos((math.rad(n4)))
    end

    n2 += line
    n1 = n2
end

t2.endU = n3
t2.endY = START_Y
t2.endH = n4
t1.LENGTH = n2
t1.JUMP_S = n2
t1.PLANKS_S = t1.PLANKS_Y - t1.START_Y
t1.LEAD_IN = t1.PLANKS_S / t1.SPEED

function t1.At2D(p1) -- line: 240
    -- upvalues: t1 (copy), t2 (copy), n1 (ref)
    if p1 <= 0 then
        return 0, t1.START_Y + p1, 90
    end

    for _, v9 in ipairs(t2) do
        if p1 <= v9.s0 + v9.len then
            local v10 = p1 - v9.s0

            if v9.piece.line then
                return v9.u + math.cos((math.rad(v9.h))) * v10, v9.y + math.sin((math.rad(v9.h))) * v10, v9.h
            end

            local v14 = if v9.piece.turn > 0 then 1 else -1
            local arc = v9.piece.arc
            local v17 = v9.u + v14 * arc * -math.sin((math.rad(v9.h)))
            local v20 = v9.y + v14 * arc * math.cos((math.rad(v9.h)))
            local v22 = v9.h + v14 * math.deg(v10 / arc)

            return v17 - v14 * arc * -math.sin((math.rad(v22))), v20 - v14 * arc * math.cos((math.rad(v22))), v22
        end
    end

    local v28 = p1 - n1

    return t2.endU + math.cos((math.rad(t2.endH))) * v28, t2.endY + math.sin((math.rad(t2.endH))) * v28, t2.endH
end

n3 = t2[#t2].s0
START_Y = n1

for _ = 1, 40 do
    local v32 = (n3 + START_Y) / 2

    if select(2, t1.At2D(v32)) > t1.SAND.Y then
        n3 = v32
    else
        START_Y = v32
    end
end

t1.SAND_S = START_Y

local CAVE, RING = t1.CAVE, t1.RING
local v33 = CAVE.POOL_Y + CAVE.REAR
local v34 = CAVE.POOL_Y + RING.Y - RING.HUMP.A
local v36 = math.sqrt(RING.R * RING.R + CAVE.TURN_R * CAVE.TURN_R) / 2
local v37 = CAVE.UNDER + CAVE.REAR
local v38 = 3.141592653589793 * v36
local v39 = v33 - (v34 + CAVE.TURN_R)
local v40 = CAVE.TURN_R * 3.141592653589793 / 2

v1 = CAVE.UNDER

local v41 = n1 + v1
local v42 = n1 + v37 + v38 / 2
local v43 = n1 + v37 + v38 + (v33 - CAVE.POOL_Y)

v2 = n1 + v37 + v38 + v39 + v40

local function ringRY(p2, p3) -- line: 290
    -- upvalues: CAVE (copy), RING (copy)
    local R = RING.R

    if p3 then
        local THRASH = RING.THRASH
        local v44 = THRASH.LAP * 6.283185307179586

        if p2 < v44 then
            R += THRASH.A * math.sin(6.283185307179586 * THRASH.N * p2 / v44) * math.sin(3.141592653589793 * p2 / v44)
        end
    end

    return R, CAVE.POOL_Y + RING.Y - RING.HUMP.A * math.cos(RING.HUMP.N * p2)
end

local function ringLocal(p4, p5) -- line: 299
    -- upvalues: ringRY (copy)
    local v50, v51 = ringRY(p4, p5)

    return (Vector3.new(v50 * math.cos(p4), v51, v50 * math.sin(p4)))
end

local function lapTable(p6) -- line: 306
    -- upvalues: ringRY (copy)
    local t3 = {
        0
    }
    local v54, v55 = ringRY(0, p6)
    local v58 = Vector3.new(v54 * 1, v55, v54 * 0)

    for i = 1, 720 do
        local v59 = 6.283185307179586 * i / 720
        local v60, v61 = ringRY(v59, p6)
        local v64 = Vector3.new(v60 * math.cos(v59), v61, v60 * math.sin(v59))

        t3[i + 1] = t3[i] + (v64 - v58).Magnitude
        v58 = v64
    end

    return t3
end

local v65 = lapTable(true)
local v66 = lapTable(false)

local function phiAt(p7, p8) -- line: 316
    local n5 = 1
    local n6 = 721

    while n6 - n5 > 1 do
        local v67 = (n5 + n6) // 2

        if p7[v67] <= p8 then
            n5 = v67
        else
            n6 = v67
        end
    end

    local v70 = (p8 - p7[n5]) / math.max(p7[n5 + 1] - p7[n5], 1E-06)

    return 6.283185307179586 * (n5 - 1 + v70) / 720
end

local function ringPhi(p9) -- line: 326
    -- upvalues: v65 (copy), v66 (copy), phiAt (copy)
    if p9 < v65[721] then
        return phiAt(v65, p9), true
    end

    local v71 = p9 - v65[721]
    local v72 = v66[721]
    local v73 = v71 // v72

    return 6.283185307179586 * (1 + v73) + phiAt(v66, v71 - v73 * v72), false
end

local v75 = v2 + v65[math.floor(RING.THROW_LAP * 720) + 1]
local v76 = v75 / t1.SPEED

t1.ERUPT_S = v41
t1.APEX_S = v42
t1.REENTER_S = v43
t1.RING_S = v2
t1.THROW_S = v75

local function caveOf(p10) -- line: 339
    -- upvalues: CAVE (copy), RING (copy), v34 (copy)
    local v78 = Vector3.new(-p10.Z, 0, p10.X)
    local v79 = Vector3.new(CAVE.CENTRE.X, 0, CAVE.CENTRE.Z)
    local v80 = v79 - v78 * RING.R + Vector3.new(0, 1, 0) * v34
    local v81 = v80 - p10 * CAVE.TURN_R + Vector3.new(0, 1, 0) * CAVE.TURN_R

    return v79, v78, v80, v81, Vector3.new(v81.X - v79.X, 0, v81.Z - v79.Z).Unit
end

function t1.RingCentre() -- line: 347
    -- upvalues: CAVE (copy)
    return (Vector3.new(CAVE.CENTRE.X, CAVE.POOL_Y, CAVE.CENTRE.Z))
end

function t1.Direction(p11) -- line: 352
    -- upvalues: TitanConfig (copy), t1 (copy)
    local v84 = TitanConfig.Seed(p11)
    local v85 = t1.DIRECTIONS[Random.new(v84):NextInteger(1, #t1.DIRECTIONS)]

    return (Vector3.new(math.cos((math.rad(v85))), 0, (math.sin((math.rad(v85))))))
end

local v90, TitanTest, v91
local n7 = 0

local function styleOf(p12) -- line: 361
    -- upvalues: TitanConfig (copy), t1 (copy), v90 (ref), TitanTest (ref), v91 (ref), n7 (ref)
    local TitanTest2 = workspace:GetAttribute("TitanTest")

    if p12 ~= v90 or TitanTest2 ~= TitanTest then
        v90 = p12
        TitanTest = TitanTest2

        local v92 = TitanConfig.SPECIES[TitanConfig.RiseTitan(p12)]

        v91 = v92 and t1.STYLES[v92.shape] or nil
        n7 = v92 and v92.late or 0
    end

    return v91, n7
end

local t4 = {}
local t5 = {}

local function slowOf(p13) -- line: 377
    -- upvalues: t1 (copy), t5 (copy)
    if t5[p13] then
        return t5[p13]
    end

    local PLANKS_S = t1.PLANKS_S
    local line = t1.PIECES[1].line
    local EASE = t1.RISE.EASE
    local v93 = (line - PLANKS_S) / t1.SPEED + p13
    local t6 = {
        slow = true,
        late = p13,
        D = v93,
        XE = v93,
        E = EASE,
        S0 = PLANKS_S,
        S1 = line,
        VC = (line - PLANKS_S - EASE * t1.SPEED) / (v93 - EASE)
    }

    t5[p13] = t6

    return t6
end

local function eased(p14, p15, p16, p17) -- line: 388
    local v95 = math.clamp(p17 / p16, 0, 1)

    return p14 * v95 * p16 + (p15 - p14) * p16 * (v95 * v95 * v95 - v95 * v95 * v95 * v95 / 2)
end

local function slowS(p18, p19) -- line: 392
    -- upvalues: t1 (copy)
    local v96 = math.clamp(p19, 0, p18.D)
    local SPEED = t1.SPEED
    local E = p18.E

    if v96 <= E then
        local S0, VC = p18.S0, p18.VC
        local v98 = math.clamp(v96 / E, 0, 1)

        return S0 + (SPEED * v98 * E + (VC - SPEED) * E * (v98 * v98 * v98 - v98 * v98 * v98 * v98 / 2))
    end

    local v99 = p18.S0 + E * (SPEED + p18.VC) / 2

    if v96 <= p18.D - E then
        return v99 + p18.VC * (v96 - E)
    end

    local v100 = v99 + p18.VC * (p18.D - 2 * E)
    local VC = p18.VC
    local v102 = math.clamp((v96 - (p18.D - E)) / E, 0, 1)

    return v100 + (VC * v102 * E + (SPEED - VC) * E * (v102 * v102 * v102 - v102 * v102 * v102 * v102 / 2))
end

local function climbOf(p20, p21) -- line: 400
    -- upvalues: t1 (copy), t4 (copy), slowOf (copy)
    local v103 = p20 and p20.CLIMB

    if not v103 then
        return (p21 or 0) > 0 and slowOf(p21) or nil
    end

    if t4[v103] and t4[v103].late == p21 then
        return t4[v103]
    end

    local function v(p22) -- line: 406
        -- upvalues: v103 (copy)
        local SPEED = v103.SPEED

        for i = 2, #SPEED do
            if p22 <= SPEED[i][1] then
                return SPEED[i - 1][2] + (SPEED[i][2] - SPEED[i - 1][2]) * (p22 - SPEED[i - 1][1]) / (SPEED[i][1] - SPEED[i - 1][1])
            end
        end

        return SPEED[#SPEED][2]
    end

    local t7 = {
        0
    }

    for i = 1, 400 do
        t7[i + 1] = t7[i] + (v((i - 1) / 400) + v(i / 400)) / 800
    end

    local v104 = t7[401]

    for i = 1, 401 do
        t7[i] /= v104
    end

    local function g(p23) -- line: 417
        -- upvalues: t7 (copy)
        local v105 = math.clamp(p23, 0, 1) * 400
        local v107 = math.min(math.floor(v105), 399)

        return t7[v107 + 1] + (t7[v107 + 2] - t7[v107 + 1]) * (v105 - v107)
    end

    local PLANKS_S = t1.PLANKS_S
    local line = t1.PIECES[1].line
    local v108 = v103.LAST_Y - t1.START_Y - PLANKS_S
    local v109 = v103.BOUNDS - 1
    local v110 = math.clamp(v103.CATCH, 0, 1) * 400
    local v112 = math.min(math.floor(v110), 399)
    local v113 = v109 + (t7[v112 + 1] + (t7[v112 + 2] - t7[v112 + 1]) * (v110 - v112))
    local v114 = math.clamp(v103.FROM, 0, 1) * 400
    local v116 = math.min(math.floor(v114), 399)
    local v117 = v108 / (v113 - (t7[v116 + 1] + (t7[v116 + 2] - t7[v116 + 1]) * (v114 - v116)))
    local v118 = (line - PLANKS_S) / t1.SPEED + p21
    local BOUNDS = v103.BOUNDS
    local v119 = math.clamp(v103.EXIT_AT, 0, 1) * 400
    local v121 = math.min(math.floor(v119), 399)
    local v122 = BOUNDS + (t7[v121 + 1] + (t7[v121 + 2] - t7[v121 + 1]) * (v119 - v121))
    local v123 = math.clamp(v103.FROM, 0, 1) * 400
    local v125 = math.min(math.floor(v123), 399)
    local v126 = PLANKS_S + v117 * (v122 - (t7[v125 + 1] + (t7[v125 + 2] - t7[v125 + 1]) * (v123 - v125)))
    local v128 = math.clamp(v103.EXIT_K * (line - v126) / t1.SPEED, 0.12, 0.8)
    local v129 = (v118 - v128) / (v103.BOUNDS + v103.EXIT_AT - v103.FROM)
    local t8 = {
        C = v103,
        late = p21,
        g = g,
        B = v117,
        D = v118,
        T = v129,
        E = v128,
        XE = v118 - v128,
        SE = v126,
        VE = v117 * v(v103.EXIT_AT) / v104 / v129,
        S0 = PLANKS_S,
        S1 = line
    }

    t4[v103] = t8

    return t8
end

local function climbS(p24, p25) -- line: 436
    -- upvalues: t1 (copy), slowS (copy)
    if p24.slow then
        return (slowS(p24, p25))
    end

    if p24.XE <= p25 then
        local E = p24.E
        local v131 = math.clamp((p25 - p24.XE) / E, 0, 1)
        local v132 = v131 * v131
        local v133 = v131 * v131 * v131

        return (v133 * 2 - v132 * 3 + 1) * p24.SE + (v133 - v132 * 2 + v131) * E * p24.VE + (v133 * -2 + v132 * 3) * p24.S1 + (v133 - v132) * E * t1.SPEED
    end

    local v134 = p24.C.FROM + p25 / p24.T
    local v135 = math.floor(v134)

    return p24.S0 + p24.B * (v135 + p24.g(v134 - v135) - p24.g(p24.C.FROM))
end

local function climbX(p26, p27) -- line: 450
    -- upvalues: climbS (copy)
    local v136 = 0
    local v137 = p26.D

    for _ = 1, 40 do
        local v138 = (v136 + v137) / 2

        if climbS(p26, v138) < p27 then
            v136 = v138
        else
            v137 = v138
        end
    end

    return (v136 + v137) / 2
end

function t1.Climb(p28) -- line: 461
    -- upvalues: styleOf (copy), climbOf (copy)
    local v139 = climbOf(styleOf(p28))

    return if v139 and v139.C then v139 else nil
end

t1.ClimbS = climbS

local function plainT(p29, p30) -- line: 468
    -- upvalues: t1 (copy)
    if not p29 or p30 <= t1.LEAD_IN then
        return p30
    end

    return if not (p30 < t1.LEAD_IN + p29.D) then p30 - p29.late else nil
end

local function wiggled(p31, p32, p33, p34, p35, p36, p37) -- line: 475
    local v140 = 6.283185307179586 / p31.WAVE
    local v142 = p31.A * math.sin(v140 * p32)

    return p35 + p37 * (v142 * p33), (p36 + p37 * (p31.A * v140 * math.cos(v140 * p32) * p33 + v142 * p34)).Unit, p37
end

local function worldPoint(p38, p39, p40) -- line: 481
    -- upvalues: t1 (copy), wiggled (copy)
    local v146, v147, v148 = t1.At2D(p39)
    local v149 = Vector3.new(t1.AXIS.X, v147, t1.AXIS.Z) + p40 * v146
    local v153 = p40 * math.cos((math.rad(v148))) + Vector3.new(0, 1, 0) * math.sin((math.rad(v148)))
    local Unit = (Vector3.new(0, 1, 0)):Cross(p40).Unit

    if not (p38 and p38.WIGGLE) then
        return v149, v153, Unit
    end

    return wiggled(p38.WIGGLE, p39, 1, 0, v149, v153, Unit)
end

local v154 = v37 + v38 + v39 + v40

local function caveRun(p41, p42, p43, p44, p45, p46) -- line: 492
    -- upvalues: CAVE (copy), v33 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy), v40 (copy), wiggled (copy)
    local Unit = (Vector3.new(0, 1, 0)):Cross(p44).Unit
    local Unit2 = (Vector3.new(0, 1, 0)):Cross(p45).Unit
    local v155, v156

    if p46 <= v37 then
        v155 = p42 + Vector3.new(0, 1, 0) * (CAVE.POOL_Y - CAVE.UNDER + p46)
        v156 = Vector3.new(0, 1, 0)
    elseif p46 <= v37 + v38 then
        local v157 = (p46 - v37) / v36

        v155 = p42 + p44 * v36 + Vector3.new(0, 1, 0) * v33 + (-p44 * math.cos(v157) + Vector3.new(0, 1, 0) * math.sin(v157)) * v36
        v156 = p44 * math.sin(v157) + Vector3.new(0, 1, 0) * math.cos(v157)
    elseif p46 <= v37 + v38 + v39 then
        local v158 = p46 - v37 - v38
        local v159 = v158 / v39
        local v160 = v159 * v159 * (3 - 2 * v159)

        v155 = Vector3.new(p43.X, v33 - v158, p43.Z)
        v156 = Vector3.new(-0, -1, -0, -0)
        Unit = Unit:Lerp(Unit2, v160).Unit
    else
        local v163 = math.min(p46 - v37 - v38 - v39, v40) / CAVE.TURN_R

        v155 = p43 + p45 * CAVE.TURN_R + (-p45 * math.cos(v163) - Vector3.new(0, 1, 0) * math.sin(v163)) * CAVE.TURN_R
        v156 = p45 * math.sin(v163) - Vector3.new(0, 1, 0) * math.cos(v163)
        Unit = Unit2
    end

    if not (p41 and p41.WIGGLE) then
        return v155, v156, Unit
    end

    local v164 = v37 + v38
    local v165 = v39 + v40
    local v166, v167

    if not (v164 < p46) then
        v166 = 1
        v167 = 0

        return wiggled(p41.WIGGLE, p46, v166, v167, v155, v156, Unit)
    end

    local v169 = math.min((p46 - v164) / v165, 1)

    v166 = 1 - v169 * v169 * (3 - v169 * 2)
    v167 = v169 * -6 * (1 - v169) / v165

    return wiggled(p41.WIGGLE, p46, v166, v167, v155, v156, Unit)
end

local function rollOf(p47) -- line: 530
    return function(p48) -- line: 530
        -- upvalues: p47 (copy)
        return p48[1] + (p48[2] - p48[1]) * p47:NextNumber()
    end
end

local function pickOf(p49, p50) -- line: 531
    local n8 = 0

    for _, v170 in ipairs(p50) do
        n8 += v170[2]
    end

    local v171 = p49:NextNumber() * n8

    for _, v172 in ipairs(p50) do
        v171 -= v172[2]

        if v171 <= 0 then
            return v172[1]
        end
    end

    return p50[#p50][1]
end

local function room(p51, p52, p53, p54, p55) -- line: 543
    return p55 - ((Vector3.new(p52.X, 0, p52.Z) + Vector3.new(math.cos(p53), 0, -math.sin(p53)) * (p51.RHO * p54)).Magnitude + p51.RHO)
end

local function leapRoom(p56, p57, p58) -- line: 549
    local v178 = p57 + Vector3.new(math.sin(p58), 0, (math.cos(p58))) * p56.JUMP.SURF

    return p56.EDGE - p56.JUMP.SLACK - Vector3.new(v178.X, 0, v178.Z).Magnitude
end

local function arenaStep(p59) -- line: 554
    -- upvalues: pickOf (copy)
    local A = p59.A
    local JUMP = p59.A.JUMP
    local rng = p59.rng

    local function v180(p60) -- line: 530
        -- upvalues: rng (copy)
        return p60[1] + (p60[2] - p60[1]) * rng:NextNumber()
    end

    local PITCH_RATE = A.PITCH_RATE
    local v181, v182

    if p59.mode == "sink" then
        v181 = math.clamp((JUMP.DEEP - p59.pos.Y) * A.VGAIN, -A.PITCH, A.PITCH)
        p59.vLeft -= A.STEP

        if p59.pos.Y < JUMP.FROM_Y then
            local pos, heading = p59.pos, p59.heading
            local v187 = pos + Vector3.new(math.sin(heading), 0, (math.cos(heading))) * A.JUMP.SURF

            if A.EDGE - A.JUMP.SLACK - Vector3.new(v187.X, 0, v187.Z).Magnitude > 0 then
                p59.mode = "launch"
                p59.nextLeap = p59.plain + v180(JUMP.GAP)
            end
        end

        if p59.vLeft <= 0 and p59.mode ~= "launch" then
            local v189 = v180(A.CRUISE)
            local v190 = v180(A.VSEG)

            p59.mode = "cruise"
            p59.goal = v189
            p59.vLeft = v190
            p59.nextLeap = p59.plain + JUMP.RETRY
        end

        v182 = true
    else
        if p59.mode == "launch" then
            v181 = JUMP.UP
            PITCH_RATE = JUMP.TURN_UP

            if p59.pos.Y >= p59.apex then
                p59.mode = "over"
            end
        elseif p59.mode == "over" then
            v181 = -JUMP.UP
            PITCH_RATE = JUMP.TURN_OVER

            if p59.pos.Y <= JUMP.OUT then
                p59.mode = "recover"
            end
        elseif p59.mode == "recover" then
            PITCH_RATE = JUMP.TURN_UP

            if p59.pitch > -10 then
                local v191 = v180(A.CRUISE)
                local v192 = v180(A.VSEG)

                p59.mode = "cruise"
                p59.goal = v191
                p59.vLeft = v192
            end

            v181 = 0
        else
            p59.vLeft -= A.STEP

            if p59.vLeft <= 0 then
                if p59.plain >= p59.nextLeap then
                    local v193 = v180(JUMP.APEX)
                    local WAIT = JUMP.WAIT

                    p59.mode = "sink"
                    p59.apex = v193
                    p59.vLeft = WAIT
                else
                    local v194 = pickOf(rng, A.HEIGHTS)
                    local v195 = v180(v194 == "dive" and A.DIVE or A.CRUISE)
                    local v196 = v180(A.VSEG)

                    p59.mode = v194
                    p59.goal = v195
                    p59.vLeft = v196
                end
            end

            v181 = math.clamp(((p59.goal or p59.pos.Y) - p59.pos.Y) * A.VGAIN, -A.PITCH, A.PITCH)
        end

        v182 = false
    end

    if p59.mode ~= "launch" and p59.mode ~= "over" then
        local pos, heading = p59.pos, p59.heading
        local v202 = A.EDGE - ((Vector3.new(pos.X, 0, pos.Z) + Vector3.new(math.cos(heading), 0, -math.sin(heading)) * (A.RHO * 1)).Magnitude + A.RHO)
        local pos2, heading2 = p59.pos, p59.heading

        if math.max(v202, A.EDGE - ((Vector3.new(pos2.X, 0, pos2.Z) + Vector3.new(math.cos(heading2), 0, -math.sin(heading2)) * (A.RHO * -1)).Magnitude + A.RHO)) < 0 then
            v181 = math.min(v181, (math.clamp((A.LOW - p59.pos.Y) * A.VGAIN, -A.PITCH, A.PITCH)))
        end
    end

    local v210 = p59.pos.Y > -15 and (p59.mode == "launch" or p59.mode == "over")

    p59.segLeft -= A.STEP

    if p59.segLeft <= 0 then
        local v211 = pickOf(rng, A.TURNS)
        local v212 = if rng:NextNumber() < 0.5 then -1 else 1
        local kNow = p59.kNow
        local v213 = if v211 == "straight" then 0 else v212 * math.rad((v180(v211 == "hard" and A.HARD or A.KAPPA)))

        p59.kFrom = kNow
        p59.kTo = v213
        p59.segLen = v180(A.SEG)
        p59.segLeft = p59.segLen
    end

    local v216 = math.min((p59.segLen - p59.segLeft) / A.BLEND, 1)

    p59.kNow = p59.kFrom + (p59.kTo - p59.kFrom) * v216 * v216 * (3 - v216 * 2)

    local v217 = 1 / A.RHO
    local v218 = if v210 then 0 else math.clamp(p59.kNow, -v217, v217)

    if v182 then
        v218 = 0

        local n9 = (-1e999)

        for _, v220 in ipairs({
                -v217 * JUMP.LINE,
                0,
                v217 * JUMP.LINE
            }) do
            local v221 = p59.heading + v220 * A.STEP
            local v227 = p59.pos + Vector3.new(math.sin(v221), 0, (math.cos(v221))) * A.STEP + Vector3.new(math.sin(v221), 0, (math.cos(v221))) * A.JUMP.SURF
            local v229 = A.EDGE - A.JUMP.SLACK - Vector3.new(v227.X, 0, v227.Z).Magnitude

            if n9 < v229 then
                n9 = v229
                v218 = v220
            end
        end
    end

    local function bestRoom(p61, p62) -- line: 635
        -- upvalues: A (copy)
        local v233 = A.EDGE - ((Vector3.new(p61.X, 0, p61.Z) + Vector3.new(math.cos(p62), 0, -math.sin(p62)) * (A.RHO * 1)).Magnitude + A.RHO)
        local v237 = A.EDGE - ((Vector3.new(p61.X, 0, p61.Z) + Vector3.new(math.cos(p62), 0, -math.sin(p62)) * (A.RHO * -1)).Magnitude + A.RHO)
        local v238 = math.max(v233, v237)

        if v233 < v237 then
            return v238, -1
        end

        return v238, 1
    end

    local pos, heading = p59.pos, p59.heading
    local v242 = A.EDGE - ((Vector3.new(pos.X, 0, pos.Z) + Vector3.new(math.cos(heading), 0, -math.sin(heading)) * (A.RHO * 1)).Magnitude + A.RHO)
    local v246 = A.EDGE - ((Vector3.new(pos.X, 0, pos.Z) + Vector3.new(math.cos(heading), 0, -math.sin(heading)) * (A.RHO * -1)).Magnitude + A.RHO)
    local v247 = math.max(v242, v246)
    local v248 = if v242 < v246 then -1 else 1
    local v249 = p59.heading + v218 * A.STEP
    local v252 = p59.pos + Vector3.new(math.sin(v249), 0, (math.cos(v249))) * A.STEP
    local v256 = A.EDGE - ((Vector3.new(v252.X, 0, v252.Z) + Vector3.new(math.cos(v249), 0, -math.sin(v249)) * (A.RHO * 1)).Magnitude + A.RHO)
    local v260 = A.EDGE - ((Vector3.new(v252.X, 0, v252.Z) + Vector3.new(math.cos(v249), 0, -math.sin(v249)) * (A.RHO * -1)).Magnitude + A.RHO)
    local v261 = math.max(v256, v260)

    if v256 < v260 then
    end

    if v261 < A.MARGIN and v261 < v247 then
        v218 = v248 * v217
    end

    p59.heading += v218 * A.STEP
    p59.pitch = p59.pitch + math.clamp(v181 - p59.pitch, -PITCH_RATE * A.STEP, PITCH_RATE * A.STEP)

    local v265 = math.rad(p59.pitch)
    local v269 = Vector3.new(math.sin(p59.heading) * math.cos(v265), math.sin(v265), math.cos(p59.heading) * math.cos(v265))

    p59.pos += v269 * A.STEP
    p59.plain += A.STEP

    local v271 = math.min(p59.plain / A.FADE, 1)
    local v274 = Vector3.new(math.cos(p59.heading), 0, -math.sin(p59.heading)) * math.cos(v265)
    local v275 = if p59.W then p59.pos + v274 * (p59.W.A * A.WIGGLE * v271 * v271 * (3 - v271 * 2) * math.sin(6.283185307179586 * p59.plain / p59.W.WAVE)) or p59.pos else p59.pos

    p59.cum[#p59.cum + 1] = p59.cum[#p59.cum] + (v275 - p59.q[#p59.q]).Magnitude
    p59.q[#p59.q + 1] = v275
end

local v278, v279, t9

local function arenaOf(p63, p64) -- line: 659
    -- upvalues: TitanConfig (copy), CAVE (copy), RING (copy), v34 (copy), v278 (ref), v279 (ref), t9 (ref)
    if v278 == p63 and v279 == p64 then
        return t9
    end

    local v281 = Vector3.new(RING.R, v34 - CAVE.POOL_Y, 0)

    t9 = {
        heading = 0,
        pitch = 0,
        plain = 0,
        kNow = 0,
        kFrom = 0,
        kTo = 0,
        segLeft = 0,
        segLen = 1,
        mode = "cruise",
        vLeft = 0,
        apex = 0,
        A = p64.ARENA,
        W = p64.WIGGLE,
        rng = Random.new(TitanConfig.Seed(p63) * 9173 + 5),
        pos = v281,
        goal = v281.Y,
        q = { v281 },
        cum = { 0 }
    }

    local FIRST = p64.ARENA.JUMP.FIRST
    local t10 = t9

    t10.nextLeap = FIRST[1] + (FIRST[2] - FIRST[1]) * t9.rng:NextNumber()
    v278 = p63
    v279 = p64

    return t9
end

local function arenaAt(p65, p66) -- line: 672
    -- upvalues: arenaStep (copy)
    local v282 = math.clamp(p66, 0, p65.A.MAX)

    while p65.cum[#p65.cum] < v282 + 1 do
        arenaStep(p65)
    end

    local cum = p65.cum
    local v283 = 1
    local v284 = #cum

    while v284 - v283 > 1 do
        local v285 = (v283 + v284) // 2

        if cum[v285] <= v282 then
            v283 = v285
        else
            v284 = v285
        end
    end

    local v288 = (v282 - cum[v283]) / math.max(cum[v283 + 1] - cum[v283], 1E-06)

    return p65.q[v283]:Lerp(p65.q[v283 + 1], v288)
end

local function trueTable(p67, p68, p69) -- line: 689
    local v290 = math.ceil((p68 - p67) / 2)
    local t11 = {
        0
    }
    local v291 = p69(p67)

    for i = 1, v290 do
        local v293 = p69((math.min(p67 + i * 2, p68)))

        t11[i + 1] = t11[i] + (v293 - v291).Magnitude
        v291 = v293
    end

    return {
        s0 = p67,
        s1 = p68,
        cum = t11
    }
end

local function trueOf(p70, p71) -- line: 699
    local cum = p70.cum

    if p71 <= p70.s0 then
        return p71 - p70.s0
    end

    if p70.s1 <= p71 then
        return cum[#cum] + (p71 - p70.s1)
    end

    local v297 = math.min(math.floor((p71 - p70.s0) / 2), #cum - 2)
    local v298 = p70.s0 + v297 * 2
    local v300 = math.min(v298 + 2, p70.s1)

    return cum[v297 + 1] + (cum[v297 + 2] - cum[v297 + 1]) * (p71 - v298) / (v300 - v298)
end

local function plainOf(p72, p73) -- line: 708
    local cum = p72.cum

    if p73 <= 0 then
        return p72.s0 + p73
    end

    if cum[#cum] <= p73 then
        return p72.s1 + (p73 - cum[#cum])
    end

    local v301 = 1
    local v302 = #cum

    while v302 - v301 > 1 do
        local v303 = (v301 + v302) // 2

        if cum[v303] <= p73 then
            v301 = v303
        else
            v302 = v303
        end
    end

    local v304 = p72.s0 + (v301 - 1) * 2

    return v304 + (math.min(v304 + 2, p72.s1) - v304) * (p73 - cum[v301]) / math.max(cum[v301 + 1] - cum[v301], 1E-06)
end

local t12 = {}
local v308 = Vector3.new(CAVE.CENTRE.X, 0, CAVE.CENTRE.Z)
local v309 = v308 - Vector3.new(-0, 0, 1) * RING.R + Vector3.new(0, 1, 0) * v34 - Vector3.new(1, 0, 0) * CAVE.TURN_R + Vector3.new(0, 1, 0) * CAVE.TURN_R
local Unit = Vector3.new(v309.X - v308.X, 0, v309.Z - v308.Z).Unit

for _, v312 in pairs(t1.STYLES) do
    if v312.WIGGLE then
        local t13 = {}

        t13.world = trueTable(-900, n1 + 100, function(p74) -- line: 728
            -- upvalues: worldPoint (copy), v312 (copy)
            return (worldPoint(v312, p74, (Vector3.new(1, 0, 0))))
        end)

        local v314 = n1

        t13.cave = trueTable(v314, n1 + v154, function(p75) -- line: 729
            -- upvalues: n1 (ref), caveRun (copy), v308 (copy), v309 (copy), Unit (copy), v312 (copy)
            return (caveRun(v312, v308, v309, Unit, Vector3.new(1, 0, 0), p75 - n1))
        end)
        t12[v312] = t13
    end
end

function t1.HasArena(p76) -- line: 734
    -- upvalues: TitanConfig (copy), t1 (copy), v90 (ref), TitanTest (ref), v91 (ref), n7 (ref)
    local TitanTest2 = workspace:GetAttribute("TitanTest")

    if p76 ~= v90 or TitanTest2 ~= TitanTest then
        v90 = p76
        TitanTest = TitanTest2

        local v315 = TitanConfig.SPECIES[TitanConfig.RiseTitan(p76)]

        v91 = v315 and t1.STYLES[v315.shape] or nil
        n7 = v315 and v315.late or 0
    end

    local v316 = v91

    return v316 ~= nil and v316.ARENA ~= nil
end

function t1.Back(p77, p78, p79) -- line: 739
    -- upvalues: TitanConfig (copy), t1 (copy), v90 (ref), TitanTest (ref), v91 (ref), n7 (ref), trueOf (copy), plainOf (copy), t12 (copy)
    local TitanTest2 = workspace:GetAttribute("TitanTest")

    if p77 ~= v90 or TitanTest2 ~= TitanTest then
        v90 = p77
        TitanTest = TitanTest2

        local v317 = TitanConfig.SPECIES[TitanConfig.RiseTitan(p77)]

        v91 = v317 and t1.STYLES[v317.shape] or nil
        n7 = v317 and v317.late or 0
    end

    local v318 = v91

    if v318 and t12[v318] then
        local v320 = t12[v318][if t1.cave then "cave" else "world"]

        return (plainOf(v320, trueOf(v320, p78) - p79))
    end

    return p78 - p79
end

function t1.At(p80, p81, p82) -- line: 748
    -- upvalues: TitanConfig (copy), t1 (copy), n1 (ref), CAVE (copy), ringRY (copy), v65 (copy), v66 (copy), phiAt (copy), caveOf (copy), v90 (ref), TitanTest (ref), v91 (ref), n7 (ref), worldPoint (copy), v154 (copy), caveRun (copy), arenaOf (copy), arenaAt (copy)
    local v321 = p82

    p82 = p82 or t1.Direction(p80)
    v321 = p82

    local TitanTest2 = workspace:GetAttribute("TitanTest")

    if p80 ~= v90 or TitanTest2 ~= TitanTest then
        v90 = p80
        TitanTest = TitanTest2

        local v323 = TitanConfig.SPECIES[TitanConfig.RiseTitan(p80)]

        v91 = v323 and t1.STYLES[v323.shape] or nil
        n7 = v323 and v323.late or 0
    end

    local v324 = v91

    if not t1.cave then
        return worldPoint(v324, p81, p82)
    end

    local v325, v326, _, v327, v328 = caveOf(p82)
    local v329 = p81 - n1

    if v329 <= v154 then
        return caveRun(v324, v325, v327, v328, p82, v329)
    end

    local v330 = v329 - v154

    if not (v324 and v324.ARENA) then
        local v331, v332

        if v330 < v65[721] then
            v331 = phiAt(v65, v330)
            v332 = true
        else
            local v333 = v330 - v65[721]
            local v334 = v66[721]
            local v335 = v333 // v334

            v331 = 6.283185307179586 * (1 + v335) + phiAt(v66, v333 - v335 * v334)
            v332 = false
        end

        local function world(p83) -- line: 766
            -- upvalues: v321 (ref), v325 (copy), v326 (copy)
            return v325 + -v326 * p83.X + v321 * p83.Z + Vector3.new(0, 1, 0) * p83.Y
        end

        local v336, v337 = ringRY(v331, v332)
        local v340 = Vector3.new(v336 * math.cos(v331), v337, v336 * math.sin(v331))
        local v341 = v325 + -v326 * v340.X
        local Z = v340.Z
        local v342 = v341 + v321 * Z + Vector3.new(0, 1, 0) * v340.Y
        local v343 = v331 + 0.002
        local v344, v345 = ringRY(v343, v332)
        local v348 = Vector3.new(v344 * math.cos(v343), v345, v344 * math.sin(v343))
        local v349 = v325 + -v326 * v348.X
        local Z2 = v348.Z
        local v350 = v349 + v321 * Z2 + Vector3.new(0, 1, 0) * v348.Y
        local v352 = math.max(0, v331 - 0.002)
        local v353, v354 = ringRY(v352, v332)
        local v357 = Vector3.new(v353 * math.cos(v352), v354, v353 * math.sin(v352))
        local v358 = v325 + -v326 * v357.X
        local Z3 = v357.Z
        local Unit = (v350 - (v358 + v321 * Z3 + Vector3.new(0, 1, 0) * v357.Y)).Unit

        return v342, Unit, (Vector3.new(0, 1, 0)):Cross(Unit).Unit
    end

    local v359 = arenaOf(p80, v324)

    local function place(p84) -- line: 759
        -- upvalues: v321 (ref), v325 (copy), v326 (copy), CAVE (copy)
        return v325 + -v326 * p84.X + v321 * p84.Z + Vector3.new(0, 1, 0) * (CAVE.POOL_Y + p84.Y)
    end

    local v360 = arenaAt(v359, v330)
    local v361 = v325 + -v326 * v360.X
    local Z = v360.Z
    local v362 = v361 + v321 * Z + Vector3.new(0, 1, 0) * (CAVE.POOL_Y + v360.Y)
    local v363 = arenaAt(v359, v330 + 0.5)
    local v364 = v325 + -v326 * v363.X
    local Z2 = v363.Z
    local v365 = v364 + v321 * Z2 + Vector3.new(0, 1, 0) * (CAVE.POOL_Y + v363.Y)
    local v367 = arenaAt(v359, (math.max(0, v330 - 0.5)))
    local v368 = v325 + -v326 * v367.X
    local Z3 = v367.Z
    local Unit = (v365 - (v368 + v321 * Z3 + Vector3.new(0, 1, 0) * (CAVE.POOL_Y + v367.Y))).Unit

    return v362, Unit, (Vector3.new(0, 1, 0)):Cross(Unit).Unit
end

function t1.HeadS(p85, p86) -- line: 775
    -- upvalues: TitanConfig (copy), t1 (copy), RING (copy), v75 (copy), v76 (copy), v90 (ref), TitanTest (ref), v91 (ref), n7 (ref), climbOf (copy), climbS (copy)
    local TitanTest2 = workspace:GetAttribute("TitanTest")

    if p85 ~= v90 or TitanTest2 ~= TitanTest then
        v90 = p85
        TitanTest = TitanTest2

        local v369 = TitanConfig.SPECIES[TitanConfig.RiseTitan(p85)]

        v91 = v369 and t1.STYLES[v369.shape] or nil
        n7 = v369 and v369.late or 0
    end

    local v370 = v91
    local v372 = climbOf(v370, n7)
    local v373 = p86 - (p85 - t1.LEAD_IN)
    local v374 = if not v372 or v373 <= t1.LEAD_IN then v373 elseif not (v373 < t1.LEAD_IN + v372.D) then v373 - v372.late else nil

    if not v374 then
        return (climbS(v372, v373 - t1.LEAD_IN))
    end

    if v374 <= v76 then
        return v374 * t1.SPEED
    end

    local v375 = if v370 and v370.SWIM then v370 else RING
    local v376 = v374 - v76
    local SPEED = t1.SPEED
    local SWIM, DECEL = v375.SWIM, v375.DECEL

    if v376 <= DECEL then
        return v75 + SPEED * v376 - (SPEED - SWIM) * v376 * v376 / (2 * DECEL)
    end

    local v377 = v376 - DECEL
    local v378 = v75 + (SPEED + SWIM) / 2 * DECEL + SWIM * v377

    if v375.SURGES then
        for _, v379 in ipairs(v375.SURGES) do
            v378 += SWIM * v379.K * v379.P / 6.283185307179586 * (1 - math.cos(6.283185307179586 * v377 / v379.P))
        end

        return v378
    end

    return v378 + SWIM * v375.SURGE.K * v375.SURGE.PERIOD / 6.283185307179586 * (1 - math.cos(6.283185307179586 * v377 / v375.SURGE.PERIOD))
end

local function atS(p87, p88) -- line: 800
    -- upvalues: t1 (copy), styleOf (copy), climbOf (copy), climbX (copy)
    local v384 = climbOf(styleOf(p87))

    if v384 and v384.S0 < p88 then
        if p88 < v384.S1 then
            return p87 + climbX(v384, p88)
        end

        return p87 - t1.LEAD_IN + p88 / t1.SPEED + v384.late
    end

    return p87 - t1.LEAD_IN + p88 / t1.SPEED
end

t1.TimeAt = atS

function t1.BreachAt(p89) -- line: 811
    -- upvalues: t1 (copy), atS (copy)
    return (atS(p89, -t1.START_Y))
end

function t1.SandAt(p90) -- line: 815
    -- upvalues: t1 (copy), atS (copy)
    return (atS(p90, t1.SAND_S))
end

t1.BLACK_IN = 0.4

function t1.CaveAt(p91) -- line: 820
    -- upvalues: t1 (copy)
    return t1.SandAt(p91) + t1.BLACK_IN
end

function t1.EruptAt(p92) -- line: 824
    -- upvalues: v41 (copy), atS (copy)
    return (atS(p92, v41))
end

function t1.ApexAt(p93) -- line: 825
    -- upvalues: v42 (copy), atS (copy)
    return (atS(p93, v42))
end

function t1.ReenterAt(p94) -- line: 826
    -- upvalues: v43 (copy), atS (copy)
    return (atS(p94, v43))
end

function t1.ThrowAt(p95) -- line: 828
    -- upvalues: t1 (copy), v76 (copy), styleOf (copy), climbOf (copy)
    local v385 = climbOf(styleOf(p95))

    return p95 - t1.LEAD_IN + v76 + (v385 and v385.late or 0)
end

function t1.HandAt(p96) -- line: 833
    -- upvalues: t1 (copy)
    return t1.ThrowAt(p96) + t1.FIGHT.HAND
end

function t1.FightAt(p97) -- line: 836
    -- upvalues: t1 (copy)
    return t1.HandAt(p97) + t1.FIGHT.START
end

function t1.EndsAt(p98) -- line: 841
    -- upvalues: t1 (copy)
    local TitanEndAt = workspace:GetAttribute("TitanEndRise") == p98 and workspace:GetAttribute("TitanEndAt") or nil

    if type(TitanEndAt) ~= "number" then
        TitanEndAt = t1.FightAt(p98) + t1.FIGHT.MAX
    end

    return TitanEndAt + t1.FIGHT.OUTRO
end

return t1
