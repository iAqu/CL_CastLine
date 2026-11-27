-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TripSet = require(script.Parent.TripSet)
local t1 = {}

local function lerp(p1, p2, p3) -- line: 16
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 19
    local v1 = math.clamp(p4, 0, 1)

    return v1 * v1 * (3 - v1 * 2)
end

local t2 = {
    linear = function(p5) -- linear | line: 24
        return p5
    end,
    inn = function(p6) -- inn | line: 27
        return p6 * p6
    end,
    out = function(p7) -- out | line: 30
        return 1 - (1 - p7) * (1 - p7)
    end,
    inout = smooth
}

local function track(p8) -- line: 37
    -- upvalues: t2 (copy)
    return function(p9) -- line: 38
        -- upvalues: p8 (copy), t2 (copy)
        if p9 <= p8[1][1] then
            return p8[1][2], p8[1][3], p8[1][4] or 0
        end

        for i = 2, #p8 do
            local v2 = p8[i - 1]
            local v3 = p8[i]

            if p9 < v3[1] then
                local v4 = t2[v3[5] or "linear"]((p9 - v2[1]) / (v3[1] - v2[1]))
                local v5 = v2[2]:Lerp(v3[2], v4)
                local Unit = v2[3]:Lerp(v3[3], v4).Unit
                local v6 = v2[4] or 0

                return v5, Unit, v6 + ((v3[4] or 0) - v6) * v4
            end
        end

        local v7 = p8[#p8]

        return v7[2], v7[3], v7[4] or 0
    end
end

local function curve(p10) -- line: 55
    return function(p11) -- line: 56
        -- upvalues: p10 (copy)
        if p11 <= p10[1][1] then
            return p10[1][2]
        end

        for i = 2, #p10 do
            if p11 < p10[i][1] then
                local v8 = p10[i - 1][2]
                local v9 = p10[i][2]
                local v11 = math.clamp((p11 - p10[i - 1][1]) / (p10[i][1] - p10[i - 1][1]), 0, 1)
                local v12 = v11 * v11 * (3 - v11 * 2)

                return v8 + (v9 - v8) * v12
            end
        end

        return p10[#p10][2]
    end
end

local CRACK_Z, CLIFF_X = TripSet.CRACK_Z, TripSet.CLIFF_X
local t3 = {
    {
        0,
        (Vector3.new(9000, -1060, -5700)),
        (Vector3.new(0, 0, -1)),
        0
    },
    {
        14.5,
        (Vector3.new(9000, -1060, -5830.5)),
        (Vector3.new(0, 0, -1)),
        0,
        "linear"
    },
    {
        16.3,
        (Vector3.new(9000, -1060, -5838)),
        (Vector3.new(0, 0, -1)),
        0,
        "out"
    },
    {
        19.8,
        (Vector3.new(9000, -1060, -5838)),
        (Vector3.new(0, 0, -1)),
        0
    },
    {
        20.8,
        (Vector3.new(9002, -1061, -5839)),
        (Vector3.new(0.7, 0, -0.7)),
        14,
        "inout"
    },
    {
        22.6,
        Vector3.new(9008, -1062, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        -6,
        "inout"
    },
    {
        24.4,
        Vector3.new(9051, -1066, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        0,
        "inn"
    },
    {
        32,
        Vector3.new(9440, -1074, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        0,
        "linear"
    },
    {
        33.4,
        Vector3.new(9497, -1076, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        0,
        "linear"
    },
    {
        34.8,
        Vector3.new(9522, -1076, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        0,
        "out"
    },
    {
        48,
        Vector3.new(9524, -1076, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        0,
        "linear"
    },
    {
        50,
        Vector3.new(9567, -1076, CRACK_Z),
        (Vector3.new(1, 0, 0)),
        0,
        "inn"
    },
    {
        58,
        Vector3.new(9911, -1076, CRACK_Z),
        Vector3.new(1, 0, 0),
        0,
        "linear"
    }
}

local function v13(p12) -- line: 38
    -- upvalues: t2 (copy), t3 (copy)
    if p12 <= t3[1][1] then
        return t3[1][2], t3[1][3], t3[1][4] or 0
    end

    for i = 2, #t3 do
        local v14 = t3[i - 1]
        local v15 = t3[i]

        if p12 < v15[1] then
            local v16 = t2[v15[5] or "linear"]((p12 - v14[1]) / (v15[1] - v14[1]))
            local v17 = v14[2]:Lerp(v15[2], v16)
            local Unit = v14[3]:Lerp(v15[3], v16).Unit
            local v18 = v14[4] or 0

            return v17, Unit, v18 + ((v15[4] or 0) - v18) * v16
        end
    end

    local v19 = t3[#t3]

    return v19[2], v19[3], v19[4] or 0
end

t1.LAUGH = 36.8
t1.CALL = 40.8
t1.TURN = 41.4
t1.WORRY = 44
t1.TRENCH = 45.6
t1.DRIVE = 48
t1.EXIT = 55.2
t1.END = 56.2

local t4 = {
    { 0, Vector3.new(9000, -985, -5300), Vector3.new(0, 0, -1), 0 },
    { 8.5, Vector3.new(9000, -1006, -5590), Vector3.new(0, 0, -1), 0, "linear" },
    { 14.5, Vector3.new(9000, -1015, -5950), Vector3.new(0, 0, -1), 0, "linear" }
}

local function v20(p13) -- line: 38
    -- upvalues: t2 (copy), t4 (copy)
    if p13 <= t4[1][1] then
        return t4[1][2], t4[1][3], t4[1][4] or 0
    end

    for i = 2, #t4 do
        local v21 = t4[i - 1]
        local v22 = t4[i]

        if p13 < v22[1] then
            local v23 = t2[v22[5] or "linear"]((p13 - v21[1]) / (v22[1] - v21[1]))
            local v24 = v21[2]:Lerp(v22[2], v23)
            local Unit = v21[3]:Lerp(v22[3], v23).Unit
            local v25 = v21[4] or 0

            return v24, Unit, v25 + ((v22[4] or 0) - v25) * v23
        end
    end

    local v26 = t4[#t4]

    return v26[2], v26[3], v26[4] or 0
end

local t5 = {
    { 15, -1097 },
    { 16.3, -1097 },
    { 16.6, -1104 },
    { 17, -1086 },
    { 19.8, -1090 }
}

local function v27(p14) -- line: 56
    -- upvalues: t5 (copy)
    if p14 <= t5[1][1] then
        return t5[1][2]
    end

    for i = 2, #t5 do
        if p14 < t5[i][1] then
            local v28 = t5[i - 1][2]
            local v29 = t5[i][2]
            local v31 = math.clamp((p14 - t5[i - 1][1]) / (t5[i][1] - t5[i - 1][1]), 0, 1)
            local v32 = v31 * v31 * (3 - v31 * 2)

            return v28 + (v29 - v28) * v32
        end
    end

    return t5[#t5][2]
end

local t6 = {
    { 20.8, 26 },
    { 22.6, 34 },
    { 25.5, 120 },
    { 28, 85 },
    { 30, 50 },
    { 31.5, 24 },
    { 32.6, 4 },
    { 33.2, 2 }
}

local function v33(p15) -- line: 56
    -- upvalues: t6 (copy)
    if p15 <= t6[1][1] then
        return t6[1][2]
    end

    for i = 2, #t6 do
        if p15 < t6[i][1] then
            local v34 = t6[i - 1][2]
            local v35 = t6[i][2]
            local v37 = math.clamp((p15 - t6[i - 1][1]) / (t6[i][1] - t6[i - 1][1]), 0, 1)
            local v38 = v37 * v37 * (3 - v37 * 2)

            return v34 + (v35 - v34) * v38
        end
    end

    return t6[#t6][2]
end

t1.CENTER_UP = 44

local function monsterFrame(p16, p17, p18, p19, p20) -- line: 112
    return CFrame.lookAt(p16, p16 + p17) * CFrame.Angles(0, 3.141592653589793 + math.rad(p20 or 0), 0) * CFrame.new(0, 44, 0) * CFrame.Angles(math.rad(p18 or 0), 0, (math.rad(p19 or 0))) * CFrame.new(0, -44, 0)
end

function t1.paths(_) -- line: 117
    -- upvalues: TripSet (copy), t1 (copy), CRACK_Z (copy), CLIFF_X (copy), v13 (copy), v20 (copy), v27 (copy), v33 (copy), monsterFrame (copy)
    local v45
    local t7 = {}

    function t7.sub(p22) -- line: 121
        -- upvalues: v13 (copy)
        local v46, v47, v48 = v13(p22)

        if p22 > 24.4 and p22 < 32 then
            local v50 = math.sin((p22 - 24.4) / 7.6 * 3.141592653589793)

            v46 += Vector3.new(0, 0, math.sin((p22 - 24.4) * 1.4) * 7 * v50)
            v48 += -math.cos((p22 - 24.4) * 1.4) * 12 * v50
        end

        local v56 = v46 + Vector3.new(0, math.sin(p22 * 1.1) * 0.5, 0)

        return CFrame.lookAt(v56, v56 + v47) * CFrame.Angles(0, 0, (math.rad(v48 + math.sin(p22 * 0.8) * 1.5)))
    end

    function t7.spinRate(p23) -- line: 133
        -- upvalues: t1 (copy)
        if p23 < 15 then
            return 6
        end

        if p23 < 22.6 then
            return 3
        end

        if p23 < 33.4 then
            return 30
        end

        if p23 < t1.DRIVE then
            return 4
        end

        return 14
    end

    function t7.monster(p24) -- line: 138
        -- upvalues: t7 (copy), v45 (ref), TripSet (copy), CRACK_Z (copy), CLIFF_X (copy), v20 (copy), v27 (copy), v33 (copy), monsterFrame (copy)
        if p24 < 15 then
            local v60, v61 = v20(p24)

            return monsterFrame(v60, v61, 4, 0), {
                walk = 0.5,
                speed = 0.7,
                open = 0.2,
                prop = 1.2
            }
        end

        if p24 < 20.8 then
            local v63 = math.clamp((p24 - 16.6) / 0.4, 0, 1)
            local v64 = v63 * v63 * (3 - v63 * 2)
            local v65 = p24 > 17 and p24 < 18.6

            return monsterFrame(Vector3.new(9000, v27(p24), -5943), Vector3.new(0, 0, 1), -v64 * 8, 0), {
                walk = 0.3,
                speed = 0.8,
                prop = 1.5,
                open = v64 * 0.8 + 0.2,
                snap = p24 > 17.6,
                raise = v64,
                jaw = v65 and 0.95 or 0.3
            }
        end

        if p24 < 33.2 then
            local v69 = math.clamp((p24 - 20.8) / 4.7, 0, 1)
            local v70 = v69 * v69 * (3 - v69 * 2) * 3.141592653589793 / 2
            local v73 = Vector3.new(math.sin(v70), 0, (math.cos(v70)))
            local Position = t7.sub(p24).Position
            local v74 = Position - v73 * (79 + v33(p24))
            local v78 = Vector3.new(math.min(v74.X, CLIFF_X - 62), Position.Y - 36, v74.Z)

            v45 = v78

            local v80 = math.clamp((p24 - 30.9) / 0.6, 0, 1)
            local v81 = v80 * v80 * (3 - v80 * 2)

            return monsterFrame(v78, v73, 6 - v81 * 10, math.sin(p24 * 3) * 4 * (1 - v81)), {
                walk = 1,
                speed = 2.6,
                prop = 3,
                open = v81 * 0.15 + 0.85,
                snap = v81 < 0.5,
                raise = v81 * 0.3 + 0.25,
                jaw = v81 * 0.4 + 0.6
            }
        end

        local v84 = v45

        if not v84 then
            v84 = Vector3.new(CLIFF_X - 62, -1110, CRACK_Z)
        end

        if p24 < 33.8 then
            local v86 = (p24 - 33.2) / 0.6
            local v87 = 1 - (1 - v86) * (1 - v86)

            return monsterFrame(v84 - Vector3.new(v87 * 26, 0, 0), Vector3.new(1, 0, 0), -18 * v87, 8 * v87), {
                walk = 0.2,
                open = 1,
                jaw = 0.8,
                prop = 0.5,
                limp = v87
            }
        end

        local v90 = math.clamp((p24 - 33.8) / 1.5, 0, 1)
        local v91 = v90 * v90 * (3 - v90 * 2)
        local v94 = v84 - Vector3.new(26, 0, 0) + Vector3.new(0, 0 + (TripSet.FLOOR_Y + 8 - v84.Y - 0) * v91, 0)
        local v96 = math.sin(p24 * 2.2) * v91

        return monsterFrame(v94, Vector3.new(1, 0, 0), -18 + 18 * v91 + v96 * 3, 8 + 172 * v91 + math.cos(p24 * 2.2) * 8 * v91, v96 * 8), {
            walk = 0,
            open = 0.4,
            jaw = 0.45,
            prop = 0.2,
            limp = 1
        }
    end

    return t7
end

local t9 = {
    { "A", 1.7 },
    { "B", 1.4 },
    { "C", 1.2 },
    { "D", 1 },
    { "A", 0.9 },
    { "B", 0.8 },
    { "E", 0.7 },
    { "D", 0.6 }
}

t1.CHASE_CUTS = {}

local n1 = 22.6

for _, v100 in t9 do
    table.insert(t1.CHASE_CUTS, n1)
    v100[3] = n1
    n1 += v100[2]
end

local function chaseKind(p25) -- line: 198
    -- upvalues: t9 (copy)
    for i = #t9, 1, -1 do
        if t9[i][3] <= p25 then
            return t9[i][1], (p25 - t9[i][3]) / t9[i][2]
        end
    end

    return nil, 0
end

local function handheld(p26, p27) -- line: 208
    return CFrame.Angles(math.sin(p26 * 1.3) * 0.004 * p27, math.sin(p26 * 0.9 + 1) * 0.005 * p27, 0)
end

local v105 = Vector3.new(CLIFF_X + 420, -1066, CRACK_Z)
local v106 = Vector3.new(CLIFF_X, -1062, CRACK_Z)

function t1.camera(p28, p29, p30, p31, p32) -- line: 216
    -- upvalues: TripSet (copy), t1 (copy), CRACK_Z (copy), CLIFF_X (copy), chaseKind (copy), v105 (copy), v106 (copy)
    local Position = p30.Position
    local v107 = TripSet.seat(p29.sub, p30)
    local Position2 = (p31 * CFrame.new(0, 36, 62)).Position

    local function at(p33, p34) -- line: 220
        return CFrame.lookAt(p33.Position, p34)
    end

    if p28 < 4 then
        local v110 = Position + Vector3.new(55 - p28 * 3, 14, 30 - p28 * 2)

        return CFrame.lookAt(v110, Position + Vector3.new(0, -2, -10)) * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 1, math.sin(p28 * 0.9 + 1) * 0.005 * 1, 0), 60, nil
    end

    if p28 < 8.5 then
        local v115 = (p28 - 4) / 4.5
        local v117 = at(p30 * CFrame.new(3.6, 1.9, -20.5 + 1.8999999999999986 * v115), p32)

        return v117 * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 0.6, math.sin(p28 * 0.9 + 1) * 0.005 * 0.6, 0), 55, (v117.Position - p32).Magnitude
    end

    if p28 < 11.5 then
        local v121 = Position + Vector3.new(0, 30, -10)

        return CFrame.lookAt(Vector3.new(8972, -1093, -5762), v121) * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 1, math.sin(p28 * 0.9 + 1) * 0.005 * 1, 0), 78, nil
    end

    if p28 < 14.5 then
        return at(p30 * CFrame.new(3.2, 1.6, -18.5), p32) * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 0.5, math.sin(p28 * 0.9 + 1) * 0.005 * 0.5, 0), 50, nil
    end

    if p28 < 15.1 then
        return at(p30 * CFrame.new(2.7, 1.6, -17.4), p32), 40, nil
    end

    if p28 < 16.3 then
        local v133 = math.clamp((p28 - 15.1) / 1.2, 0, 1)
        local v134 = v133 * v133 * (3 - v133 * 2)
        local v135 = (p30 * CFrame.new(2.7, 1.6, -17.4)).Position - p32
        local v136 = CFrame.lookAt(p32 + v135 * (1 + 0.30000000000000004 * v134), p32)
        local Magnitude = (v136.Position - p32).Magnitude

        return v136, math.deg(math.atan(0.42447481620960476 * v135.Magnitude / Magnitude) * 2), nil
    end

    if p28 < 17 then
        local v140 = math.clamp((p28 - 16.3) / 0.7, 0, 1)
        local v141 = v140 * v140 * (3 - v140 * 2)

        return at(v107 * CFrame.new(1.6, 4.2, 4.4 + -0.8000000000000003 * v141), Position2 + Vector3.new(0, 10, 0)) * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 1.5, math.sin(p28 * 0.9 + 1) * 0.005 * 1.5, 0), 72, nil
    end

    if p28 < 19.8 then
        local v149 = math.clamp((p28 - 17) / 2.8, 0, 1)
        local v150 = v149 * v149 * (3 - v149 * 2)
        local Position3 = (p30 * CFrame.new(-14, -6, 42 + -6 * v150)).Position

        return CFrame.lookAt(Position3, Position2:Lerp(Position, 0.35) + Vector3.new(0, 12, 0)) * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 2, math.sin(p28 * 0.9 + 1) * 0.005 * 2, 0), 74, nil
    end

    if p28 < 20.8 then
        local v156 = at(p30 * CFrame.new(-3.5, 1.6, -15), p32)
        local v157 = p28 * 3

        return v156 * CFrame.Angles(math.sin(v157 * 1.3) * 0.004 * 3, math.sin(v157 * 0.9 + 1) * 0.005 * 3, 0), 60, nil
    end

    if p28 < 22.6 then
        local v161 = v107 * CFrame.new(-2.6, 4.6, 5.5)
        local v162 = CFrame.lookAt(v161.Position, v106)
        local v164 = math.clamp((p28 - 20.8) / 1.2, 0, 1)
        local v165 = v164 * v164 * (3 - v164 * 2)

        return v162 * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 1, math.sin(p28 * 0.9 + 1) * 0.005 * 1, 0), 45, 8 + ((v106 - v162.Position).Magnitude - 8) * v165
    end

    if p28 < 30.9 then
        local v169, v170 = chaseKind(p28)
        local LookVector, RightVector = p30.LookVector, p30.RightVector

        if v169 == "A" then
            local v171 = Position + LookVector * (45 - v170 * 6) - RightVector * 16 + Vector3.new(0, 4, 0)
            local v172 = CFrame.lookAt(v171, Position - LookVector * 20)
            local v173 = p28 * 2

            return v172 * CFrame.Angles(math.sin(v173 * 1.3) * 0.004 * 2, math.sin(v173 * 0.9 + 1) * 0.005 * 2, 0), 45, nil
        end

        if v169 == "B" then
            local v177 = p31.LookVector * -1
            local v178 = p31.RightVector * -1
            local v181 = Position2 + v177 * 30 + v178 * 18 + Vector3.new(0, -8 + v170 * 3, 0)
            local v182 = CFrame.lookAt(v181, Position2 + Vector3.new(0, 6, 0))
            local v183 = p28 * 3

            return v182 * CFrame.Angles(math.sin(v183 * 1.3) * 0.004 * 3, math.sin(v183 * 0.9 + 1) * 0.005 * 3, 0), 65, nil
        end

        if v169 == "C" then
            local v188 = at(p30 * CFrame.new(3.2, 1.6, -18.5), p32)
            local v189 = p28 * 4

            return v188 * CFrame.Angles(math.sin(v189 * 1.3) * 0.004 * 3, math.sin(v189 * 0.9 + 1) * 0.005 * 3, 0), 55, nil
        end

        if v169 == "D" then
            local Position2 = (p31 * CFrame.new(0, 82, -6)).Position
            local v193 = CFrame.lookAt(Position2, Position)
            local v194 = p28 * 3

            return v193 * CFrame.Angles(math.sin(v194 * 1.3) * 0.004 * 2, math.sin(v194 * 0.9 + 1) * 0.005 * 2, 0), 60, nil
        end

        local v198 = Position + RightVector * 34 - LookVector * (5 - v170 * 10) + Vector3.new(0, -7, 0)
        local v199 = CFrame.lookAt(v198, Position + LookVector * 15)
        local v200 = p28 * 2

        return v199 * CFrame.Angles(math.sin(v200 * 1.3) * 0.004 * 2, math.sin(v200 * 0.9 + 1) * 0.005 * 2, 0), 72, nil
    end

    if p28 < 32.7 then
        local v204 = Position + p30.LookVector * 14 + Vector3.new(0, 15, 0) + p30.RightVector * 7
        local v205 = CFrame.lookAt(v204, Position2 + Vector3.new(0, 4, 0))
        local v206 = p28 * 3

        return v205 * CFrame.Angles(math.sin(v206 * 1.3) * 0.004 * 2.5, math.sin(v206 * 0.9 + 1) * 0.005 * 2.5, 0), 64, nil
    end

    if p28 < 33.2 then
        return CFrame.lookAt(Vector3.new(CLIFF_X - 40, -1060, CRACK_Z + 80), (Vector3.new(CLIFF_X - 14, -1066, CRACK_Z))), 60, nil
    end

    if p28 < 34.6 then
        return CFrame.lookAt(Vector3.new(CLIFF_X - 165, -1012, CRACK_Z + 95), (Vector3.new(CLIFF_X - 30, -1060, CRACK_Z))), 66, nil
    end

    if p28 < t1.LAUGH then
        local v218 = (p31 * CFrame.new(0, 44, 40)).Position + Vector3.new(0, 58, 0)
        local v219 = (p28 - 34.6) / 2.2

        return CFrame.lookAt(v218 + Vector3.new(v219 * 10 + -30, 6, 125 - v219 * 10), v218 - Vector3.new(0, 34, 0)), 58, nil
    end

    if p28 < t1.TURN then
        return at(p30 * CFrame.new(3.4, 1.8, -18.6), p32) * CFrame.Angles(math.sin(p28 * 1.3) * 0.004 * 1, math.sin(p28 * 0.9 + 1) * 0.005 * 1, 0), 55, nil
    end

    if p28 < t1.TRENCH then
        local v228 = math.clamp((p28 - t1.TURN) / (t1.TRENCH - t1.TURN), 0, 1)
        local v229 = v228 * v228 * (3 - v228 * 2)

        return at(p30 * CFrame.new(3.4 + -0.8999999999999999 * v229, 1.8 + 0.09999999999999987 * v229, -18.8 + 1.9000000000000021 * v229), p32 + Vector3.new(0, v229 * 0.6, 0)), 48, nil
    end

    if p28 < t1.DRIVE then
        local v234 = math.clamp((p28 - t1.TRENCH) / (t1.DRIVE - t1.TRENCH), 0, 1)
        local v235 = v234 * v234 * (3 - v234 * 2)
        local v236 = v107 * CFrame.new(2.8, 5.4 + 0.39999999999999947 * v235, 7.5 + -1 * v235)

        return CFrame.lookAt(v236.Position, v105), 50, nil
    end

    local v237 = Position - p30.LookVector * 36 + Vector3.new(0, 9, 0) + p30.RightVector * 3

    return CFrame.lookAt(v237, Position + p30.LookVector * 60), 60, nil
end

function t1.subAt(p35) -- line: 316
    -- upvalues: v13 (copy)
    local v238, v239 = v13(p35)

    return CFrame.lookAt(v238, v238 + v239)
end

return t1
