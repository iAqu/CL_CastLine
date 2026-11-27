-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local t1 = {
    HEAD = Vector3.new(13.4, 6.7, -75.5),
    LENGTH = 180,
    FRONT = 0,
    TOP = 24
}
local t2 = {
    Head = Vector3.new(-25.9, 33.1, -51.6),
    HandR = Vector3.new(-23.7, -26.3, -98.9),
    HandL = Vector3.new(-63.3, -27.4, -36.2),
    FootL = Vector3.new(-23.7, -38.4, 1.2),
    FootR = Vector3.new(59.9, -38.4, -50.5),
    TA_3 = Vector3.new(28, -1, 73.8),
    TB_3 = Vector3.new(24.7, -6.5, 103.5),
    TC_3 = Vector3.new(7.1, -18.6, 100.2),
    TD_3 = Vector3.new(4.9, -39.5, 66.1)
}

t1.TIPS = t2
t1.BODY = {
    CHORD = 90
}
t1.WAVE = {
    LAMBDA = 175,
    A0 = 1.2,
    A1 = 24,
    POW = 1.6,
    STRIDE = 300,
    BASE_HZ = 0.08,
    V_FULL = 260,
    MIN_AMP = 0.4,
    LAG = 0.35,
    WANDER = {
        YAW = { 3, 9.7 },
        PITCH = { 2, 13.1 }
    }
}

local t3 = {
    Hips = Vector3.new(0, 0, -1),
    Spine = Vector3.new(0, 0, -1),
    Chest = Vector3.new(0, 0, -1),
    Neck = Vector3.new(0, 0.05, -1),
    Head = Vector3.new(0, -0.06, -1),
    UpperArmR = Vector3.new(0.3, -0.35, 1),
    ForearmR = Vector3.new(0.1, -0.15, 1),
    HandR = Vector3.new(0.02, -0.05, 1),
    ThighR = Vector3.new(-0.08, -0.05, 1),
    ShinR = Vector3.new(-0.03, 0, 1),
    FootR = Vector3.new(0, -0.1, 1)
}
local t4 = {
    Head = 7,
    Hips = 56,
    Spine = 42,
    Chest = 29,
    Neck = 19,
    UpperArm = 37,
    Forearm = 64,
    Hand = 92,
    Thigh = 70,
    Shin = 92,
    Foot = 115,
    Tail = 92,
    T1 = 115,
    T2 = 141,
    T3 = 169,
    ROOT = 64
}
local t5 = {
    7, 19, 29, 37, 42, 56, 64, 70,
    92, 115, 141, 169
}

t1.TENDRIL = {
    LAG = 0.12,
    SWAY_S = 6.7,
    LINES = {
        Tail = Vector3.new(0, -0.1, 1),
        TA = Vector3.new(0.14, 0.12, 1),
        TB = Vector3.new(0.02, 0, 1),
        TC = Vector3.new(-0.12, -0.08, 1),
        TD = Vector3.new(0.05, -0.22, 1)
    },
    PHASE = {
        TA = 0,
        TB = 0.35,
        TC = 0.7,
        TD = 1.05
    },
    AMP = { 7, 13, 20 },
    SWAY = { 3, 6, 9 },
    FOLLOW = {
        GAIN = 30,
        MAX = 14
    }
}
t1.LOOM = {
    FROM = 0.6,
    TO = 0.88,
    AROUND = { -150, 50 },
    pose = {
        Hips = Vector3.new(0, 0.02, -1),
        Spine = Vector3.new(0, 0.15, -1),
        Chest = Vector3.new(0, 0.3, -1),
        Neck = Vector3.new(0, 0.2, -1),
        Head = Vector3.new(0, -0.6, -1),
        UpperArmR = Vector3.new(0.9, -0.3, 0.1),
        ForearmR = Vector3.new(0.7, -0.5, -0.5),
        HandR = Vector3.new(0.4, -0.65, -0.65),
        ThighR = Vector3.new(0.3, -0.3, 1),
        ShinR = Vector3.new(0.15, 0.1, 1),
        FootR = Vector3.new(0.1, -0.3, 1)
    }
}

local WAVE, TENDRIL = t1.WAVE, t1.TENDRIL
local v1 = 6.283185307179586 / WAVE.LAMBDA

function t1.Place(p1, p2, p3, p4, p5, p6, _, p8) -- line: 95
    -- upvalues: t1 (copy), WAVE (copy)
    local v2 = (p6 * WAVE.BASE_HZ + p4 / WAVE.STRIDE) % 1
    local v5 = WAVE.MIN_AMP + (1 - WAVE.MIN_AMP) * math.clamp(p5 / WAVE.V_FULL, 0, 1)

    return CFrame.lookAt(p1, p1 + p2, p3) * CFrame.new(-t1.HEAD), {
        f = v2,
        amp = v5,
        loom = p8 or 0
    }
end

function t1.Body(p9, p10, p11) -- line: 105
    -- upvalues: TitanPath (copy), t1 (copy), t5 (copy)
    p11 = p11 or TitanPath.Direction(p9)

    local v7 = TitanPath.HeadS(p9, p10)
    local v9 = math.max(0, (v7 - TitanPath.HeadS(p9, p10 - 0.1)) / 0.1)
    local v10, v11, v12 = TitanPath.At(p9, v7, p11)
    local v13 = 0

    if TitanPath.RING_S < v7 and TitanPath.HasArena(p9) then
        local LOOM = t1.LOOM
        local v14 = LOOM.AROUND[1]
        local v15 = LOOM.AROUND[2]
        local n1 = 0
        local n2 = 0

        for i = v14, v15, 50 do
            local v17 = math.clamp((select(2, TitanPath.At(p9, v7 + i, p11)).Y - LOOM.FROM) / (LOOM.TO - LOOM.FROM), 0, 1)

            n1 += v17 * v17 * (3 - v17 * 2)
            n2 += 1
        end

        v13 = n1 / n2
    end

    local v18, v19 = t1.Place(v10, v11, (-v12):Cross(v11), v7, v9, p10, 0, v13)
    local t6 = {}

    for _, v20 in ipairs(t5) do
        local v21, v22, v23 = TitanPath.At(p9, TitanPath.Back(p9, v7, v20), p11)

        t6[v20] = {
            pos = v18:PointToObjectSpace(v21),
            fwd = v18:VectorToObjectSpace(v22),
            up = v18:VectorToObjectSpace((-v23):Cross(v22))
        }
    end

    v19.path = t6

    return v18, v19
end

function t1.Rig(p12, p13) -- line: 134
    -- upvalues: t2 (copy)
    p13 = p13 or 1

    local PrimaryPart = p12.PrimaryPart
    local CFrame = PrimaryPart.CFrame
    local t7 = {
        bones = {},
        order = {},
        by = {},
        posed = {},
        dirs = {},
        scale = p13
    }

    for _, descendant in ipairs(PrimaryPart:GetDescendants()) do
        if descendant:IsA("Bone") then
            local v25 = CFrame:ToObjectSpace(descendant.WorldCFrame)
            local t8 = {
                depth = 0,
                bone = descendant,
                name = descendant.Name,
                rest = v25
            }
            local Parent = descendant.Parent

            while Parent and Parent:IsA("Bone") do
                t8.depth += 1
                Parent = Parent.Parent
            end

            if descendant.Parent:IsA("Bone") then
                t8.parent = descendant.Parent.Name
            end

            if t2[descendant.Name] then
                t8.tip = v25:PointToObjectSpace(t2[descendant.Name] * p13)
            end

            t7.bones[descendant.Name] = descendant
            t7.by[descendant.Name] = t8
            table.insert(t7.order, t8)
        end
    end

    table.sort(t7.order, function(p14, p15) -- line: 155
        return p14.depth < p15.depth
    end)

    for _, v26 in ipairs(t7.order) do
        if v26.parent then
            v26.L = t7.by[v26.parent].rest:ToObjectSpace(v26.rest)
        end
    end

    local by = t7.by

    by.Hips.side = by.Hips.rest:VectorToObjectSpace(by.ThighR.rest.Position - by.ThighL.rest.Position).Unit
    by.Chest.side = by.Chest.rest:VectorToObjectSpace(by.UpperArmR.rest.Position - by.UpperArmL.rest.Position).Unit

    return t7
end

local function arc(p16, p17) -- line: 166
    local v27 = p16:Dot(p17)

    if v27 > 0.999999 then
        return CFrame.identity
    end

    local v28 = p16:Cross(p17)

    if v28.Magnitude < 1E-06 then
        local v29 = if math.abs(p16.X) < 0.9 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)

        return CFrame.fromAxisAngle(p16:Cross(v29).Unit, 3.141592653589793)
    end

    return CFrame.fromAxisAngle(v28.Unit, (math.acos((math.clamp(v27, -1, 1)))))
end

function t1.Solve(p18) -- line: 181
    -- upvalues: arc (copy)
    local posed, dirs, shift = p18.posed, p18.dirs, p18.shift

    for _, v31 in ipairs(p18.order) do
        local v32 = v31.parent and posed[v31.parent] * v31.L or shift and CFrame.new(shift) * v31.rest or v31.rest
        local v33 = dirs[v31.name]
        local identity = CFrame.identity

        if v33 then
            local Rotation = v32.Rotation

            identity = Rotation:Inverse() * arc(Rotation.UpVector, v33) * Rotation

            if v31.side then
                local v34 = Rotation * identity
                local UpVector = v34.UpVector
                local v35 = v34:VectorToWorldSpace(v31.side)
                local v36 = v35 - UpVector * v35:Dot(UpVector)
                local v37 = p18.levelTo and p18.levelTo[v31.name] or Vector3.new(1, 0, 0)
                local v38 = v37 - UpVector * v37:Dot(UpVector)

                identity *= CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.atan2(UpVector:Dot(v36:Cross(v38)), (v36:Dot(v38)))))
            end
        end

        v31.bone.Transform = shift and not v31.parent and v31.rest:Inverse() * v32 * identity or identity
        posed[v31.name] = v32 * identity
    end
end

local function keyDir(p19, p20) -- line: 206
    local v41 = p19[p20]

    if v41 then
        return v41
    end

    local v42 = p20:sub(-1) == "L"
    local v43 = if v42 then p19[p20:sub(1, -2) .. "R"] else nil

    return if v42 and v43 then Vector3.new(-v43.X, v43.Y, v43.Z) else nil
end

local t9 = {
    "Hips",
    "Spine",
    "Chest",
    "Neck",
    "Head",
    "UpperArmR",
    "ForearmR",
    "HandR",
    "UpperArmL",
    "ForearmL",
    "HandL",
    "ThighR",
    "ShinR",
    "FootR",
    "ThighL",
    "ShinL",
    "FootL"
}

local function wave(p21, p22, p23) -- line: 219
    -- upvalues: t1 (copy), WAVE (copy), v1 (copy)
    local v46 = math.clamp(p21 / t1.LENGTH, 0, 1)
    local v47 = (WAVE.A0 + (WAVE.A1 - WAVE.A0) * v46 ^ WAVE.POW) * p23
    local v48 = (WAVE.A1 - WAVE.A0) * WAVE.POW * v46 ^ (WAVE.POW - 1) / t1.LENGTH * p23
    local v49 = v1 * p21 - p22

    return v47 * math.sin(v49), v48 * math.sin(v49) + v47 * v1 * math.cos(v49)
end

local function onSlope(p24, p25) -- line: 227
    return Vector3.new(p24.X, p24.Y + p25 * p24.Z, p24.Z).Unit
end

local function frameAt(p26, p27) -- line: 231
    local v51 = p26 and p26[p27]

    if v51 then
        return v51.fwd:Cross(v51.up), v51.up, -v51.fwd, v51.pos
    end

    return Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1), nil
end

local function toFrame(p28, p29, p30, p31) -- line: 236
    return p29 * p28.X + p30 * p28.Y + p31 * p28.Z
end

local function tendrils(p32, p33, p34, p35, p36, p37, p38) -- line: 240
    -- upvalues: TENDRIL (copy)
    local v54 = math.clamp(-p35 * TENDRIL.FOLLOW.GAIN, -TENDRIL.FOLLOW.MAX, TENDRIL.FOLLOW.MAX)
    local Tail = TENDRIL.LINES.Tail

    if p37 > 0 then
        Tail = Tail:Lerp(p38, p37)
    end

    p32.Tail = Tail.Unit

    for v55, v56 in pairs(TENDRIL.PHASE) do
        local v57 = TENDRIL.LINES[v55]

        if p37 > 0 then
            v57 = v57:Lerp(p38 + (v57 - TENDRIL.LINES.TB) * 0.6, p37)
        end

        local Unit = v57.Unit

        for i = 1, 3 do
            local v61 = math.rad(TENDRIL.AMP[i] * p34 * math.sin(6.283185307179586 * (p33 - i * TENDRIL.LAG) + v56))
            local v65 = math.rad(TENDRIL.SWAY[i] * math.sin(6.283185307179586 * p36 / TENDRIL.SWAY_S + v56 * 1.3 - i * 0.7) + v54 * i / 3)

            p32[v55 .. "_" .. i] = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v65) * CFrame.fromAxisAngle(Vector3.new(1, 0, 0), v61) * Unit
        end
    end
end

function t1.Pose(p39, p40, p41) -- line: 261
    -- upvalues: t1 (copy), t3 (copy), t4 (copy), WAVE (copy), TENDRIL (copy), t9 (copy), wave (copy)
    local dirs = p39.dirs
    local path = p40.path
    local v66 = 6.283185307179586 * p40.f
    local amp = p40.amp
    local v67 = p40.loom or 0
    local v68 = 1 - v67

    local function slope(p42, p43) -- line: 265
        -- upvalues: v66 (copy), amp (copy), v68 (copy), wave (copy)
        return select(2, wave(p42, v66 + (p43 or 0), amp * v68))
    end

    for _, v69 in ipairs(t9) do
        local v70 = t3[v69]

        if not v70 then
            if v69:sub(-1) == "L" then
                local v71 = t3[v69:sub(1, -2) .. "R"]

                v70 = if v71 then Vector3.new(-v71.X, v71.Y, v71.Z) else nil
            else
                v70 = nil
            end
        end

        local v73 = v69:gsub("[RL]$", "")
        local v74

        if v69 == "Head" then
            local WANDER = WAVE.WANDER
            local v78 = math.rad(WANDER.YAW[1] * math.sin(6.283185307179586 * p41 / WANDER.YAW[2]))
            local v82 = math.rad(WANDER.PITCH[1] * math.sin(6.283185307179586 * p41 / WANDER.PITCH[2] + 0.9))

            v74 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v78) * CFrame.fromAxisAngle(Vector3.new(1, 0, 0), v82) * v70.Unit
        elseif v70.Z < 0 then
            local v83 = t4[v73]
            local v84 = select(2, wave(v83, v66 + 0, amp * v68))

            v74 = Vector3.new(v70.X, v70.Y - v84, -1).Unit
        else
            local v86 = t4[v73]
            local v87 = (v73 == "UpperArm" or v73 == "Forearm" or v73 == "Hand") and WAVE.LAG or 0
            local v88 = select(2, wave(v86, v66 + (v87 or 0), amp * v68))

            v74 = Vector3.new(v70.X, v70.Y + v88 * v70.Z, v70.Z).Unit
        end

        if v67 > 0 then
            local pose = t1.LOOM.pose
            local v90 = pose[v69]

            if not v90 then
                if v69:sub(-1) == "L" then
                    local v91 = pose[v69:sub(1, -2) .. "R"]

                    v90 = if v91 then Vector3.new(-v91.X, v91.Y, v91.Z) else nil
                else
                    v90 = nil
                end
            end

            v74 = v74:Lerp(v90.Unit, v67)
        end

        local Unit = v74.Unit
        local v93 = t4[v73]
        local v94 = path and path[v93]
        local v95, v96, v97

        if v94 then
            v95 = v94.fwd:Cross(v94.up)
            v96 = v94.up
            v97 = -v94.fwd

            local _ = v94.pos
        else
            v95 = Vector3.new(1, 0, 0)
            v96 = Vector3.new(0, 1, 0)
            v97 = Vector3.new(0, 0, 1)
        end

        dirs[v69] = (v95 * Unit.X + v96 * Unit.Y + v97 * Unit.Z).Unit
    end

    local v98 = path and path[64]
    local pos, v99, v100

    if v98 then
        v100 = v98.fwd:Cross(v98.up)
        v99 = v98.up

        local _ = -v98.fwd

        pos = v98.pos
    else
        v100 = Vector3.new(1, 0, 0)
        v99 = Vector3.new(0, 1, 0)
    end

    p39.shift = (pos or t1.HEAD + Vector3.new(0, 0, 64)) + v99 * wave(64, v66, amp * v68) - (t1.HEAD + Vector3.new(0, 0, 64))
    p39.levelTo = p39.levelTo or {}

    local levelTo, levelTo2 = p39.levelTo, p39.levelTo
    local v101 = path and path[29]
    local v102

    if v101 then
        v102 = v101.fwd:Cross(v101.up)

        local _ = v101.up
        local _ = -v101.fwd
        local _ = v101.pos
    else
        v102 = Vector3.new(1, 0, 0)
    end

    levelTo.Hips = v100
    levelTo2.Chest = v102

    local Tail = TENDRIL.LINES.Tail
    local v103 = select(2, wave(92, v66 + 0, amp * v68))
    local Unit = Vector3.new(Tail.X, Tail.Y + v103 * Tail.Z, Tail.Z).Unit
    local v105 = path and path[92]
    local v106, v107, v108

    if v105 then
        v106 = v105.fwd:Cross(v105.up)
        v107 = v105.up
        v108 = -v105.fwd

        local _ = v105.pos
    else
        v106 = Vector3.new(1, 0, 0)
        v107 = Vector3.new(0, 1, 0)
        v108 = Vector3.new(0, 0, 1)
    end

    dirs.Tail = (v106 * Unit.X + v107 * Unit.Y + v108 * Unit.Z).Unit

    for v109, v110 in pairs(TENDRIL.PHASE) do
        for i = 1, 3 do
            local v114 = math.rad(TENDRIL.SWAY[i] * math.sin(6.283185307179586 * p41 / TENDRIL.SWAY_S + v110 * 4 - i * 0.7))
            local v115 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v114)
            local v116 = TENDRIL.LINES[v109]
            local v117 = t4["T" .. i]
            local v118 = select(2, wave(v117, v66 + (v110 or 0), amp * v68))
            local v120 = v115 * Vector3.new(v116.X, v116.Y + v118 * v116.Z, v116.Z).Unit
            local v121 = v109 .. "_" .. i
            local v122 = t4["T" .. i]
            local v123 = path and path[v122]
            local v124, v125, v126

            if v123 then
                v124 = v123.fwd:Cross(v123.up)
                v125 = v123.up
                v126 = -v123.fwd

                local _ = v123.pos
            else
                v124 = Vector3.new(1, 0, 0)
                v125 = Vector3.new(0, 1, 0)
                v126 = Vector3.new(0, 0, 1)
            end

            dirs[v121] = (v124 * v120.X + v125 * v120.Y + v126 * v120.Z).Unit
        end
    end

    t1.Solve(p39)
end

function t1.PoseWith(p44, p45, p46, p47, p48, p49) -- line: 305
    -- upvalues: t1 (copy), t9 (copy), tendrils (copy)
    local dirs = p44.dirs

    p44.shift = nil
    p44.levelTo = nil

    for _, v127 in ipairs(t9) do
        local v128 = p45[v127]

        if not v128 then
            if v127:sub(-1) == "L" then
                local v129 = p45[v127:sub(1, -2) .. "R"]

                v128 = if v129 then Vector3.new(-v129.X, v129.Y, v129.Z) else nil
            else
                v128 = nil
            end
        end

        dirs[v127] = v128 and v128.Unit or nil
    end

    tendrils(dirs, p46, p47, p48, p49, 1, (Vector3.new(0, 0, 1)))
    t1.Solve(p44)
end

function t1.TipOf(p50, p51) -- line: 317
    local v131 = p50.by[p51]

    return v131 and v131.tip and p50.posed[p51] * v131.tip
end

return t1
