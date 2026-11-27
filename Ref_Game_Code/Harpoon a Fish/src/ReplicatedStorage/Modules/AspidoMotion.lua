-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local t1 = {
    HEAD = Vector3.new(0, 4.8, -107.1),
    LENGTH = 214
}
local t2 = {
    FlipL_1 = Vector3.new(-59.7, -24.7, -27.9),
    FlipR_1 = Vector3.new(60.3, -16.2, -64.7),
    RearL = Vector3.new(-62, -25.1, 31.6),
    RearR = Vector3.new(61.9, -24.9, 30.7)
}

t1.BODY = {
    CHORD = 100,
    HEAVE = 2.5,
    NOD = 1.5,
    BANK = {
        GAIN = 60,
        MAX = 22
    }
}
t1.STROKE = {
    STRIDE = 240,
    BASE_HZ = 0.12,
    DOWN = 0.38,
    V_FULL = 250,
    MIN_AMP = 0.45,
    SWEEP = 16,
    TWIST = 28,
    LAG = 20,
    ELEV = {
        MID = 6,
        A = 36
    }
}
t1.REAR = {
    BACK = 14,
    PADDLE = 7,
    STEER = {
        GAIN = 50,
        MAX = 18
    }
}
t1.NECK = {
    COUNTER = 0.8,
    TURN = {
        GAIN = 40,
        MAX = 14
    },
    WANDER = {
        YAW = { 5, 7.3 },
        PITCH = { 3, 11.1 }
    }
}
t1.TAIL = {
    FOLLOW = {
        GAIN = 30,
        MAX = 12
    },
    SWAY = { 4, 0.35 }
}

local BODY, STROKE = t1.BODY, t1.STROKE

function t1.StrokeAt(p1) -- line: 49
    -- upvalues: STROKE (copy)
    local v1 = 1 - STROKE.DOWN

    if p1 < v1 then
        local v2 = p1 / v1

        return -math.cos(3.141592653589793 * v2), (math.sin(3.141592653589793 * v2))
    end

    local v6 = (p1 - v1) / STROKE.DOWN

    return math.cos(3.141592653589793 * v6), -math.sin(3.141592653589793 * v6)
end

function t1.Place(p2, p3, p4, p5, p6, p7, p8) -- line: 62
    -- upvalues: t1 (copy), BODY (copy), STROKE (copy)
    local v10 = (p7 * STROKE.BASE_HZ + p5 / STROKE.STRIDE) % 1
    local v13 = STROKE.MIN_AMP + (1 - STROKE.MIN_AMP) * math.clamp(p6 / STROKE.V_FULL, 0, 1)
    local v14 = 1 - STROKE.DOWN
    local v15

    if v10 < v14 then
        local v16 = v10 / v14

        v15 = -math.cos(3.141592653589793 * v16)
        math.sin(3.141592653589793 * v16)
    else
        local v19 = (v10 - v14) / STROKE.DOWN

        v15 = math.cos(3.141592653589793 * v19)

        local _ = -math.sin(3.141592653589793 * v19)
    end

    local v25 = math.rad((math.clamp(p8 * BODY.BANK.GAIN, -BODY.BANK.MAX, BODY.BANK.MAX)))
    local v28 = CFrame.lookAt(p2, p2 + p3, p4) * CFrame.new(-t1.HEAD) * CFrame.Angles(math.rad(-BODY.NOD * v13 * v15), 0, v25)

    return v28 + v28.UpVector * (-BODY.HEAVE * v13 * v15), {
        f = v10,
        amp = v13,
        kd = p8
    }
end

local function lineAt(p9, p10, p11) -- line: 73
    -- upvalues: TitanPath (copy), BODY (copy)
    local v29 = TitanPath.At(p9, p10, p11)
    local v30 = v29 - TitanPath.At(p9, p10 - BODY.CHORD, p11)
    local Unit = v30.Magnitude > 0.001 and v30.Unit or Vector3.new(0, 1, 0)

    return v29, Unit, (-select(3, TitanPath.At(p9, p10 - BODY.CHORD / 2, p11))):Cross(Unit)
end

function t1.Body(p12, p13, p14) -- line: 82
    -- upvalues: TitanPath (copy), t1 (copy), lineAt (copy)
    p14 = p14 or TitanPath.Direction(p12)

    local v32 = TitanPath.HeadS(p12, p13)
    local v34 = math.max(0, (v32 - TitanPath.HeadS(p12, p13 - 0.1)) / 0.1)
    local v35, v36, v37 = lineAt(p12, v32, p14)
    local v41 = math.deg((math.asin((math.clamp(select(2, lineAt(p12, v32 - 25, p14)):Cross(v36):Dot(v37), -1, 1))))) / 25

    return t1.Place(v35, v36, v37, v32, v34, p13, v41)
end

function t1.Rig(p15, p16) -- line: 94
    -- upvalues: t2 (copy)
    local v42 = p16 or 1
    local PrimaryPart = p15.PrimaryPart
    local CFrame = PrimaryPart.CFrame
    local t3 = {}

    for _, descendant in ipairs(PrimaryPart:GetDescendants()) do
        if descendant:IsA("Bone") then
            local v43 = CFrame:ToObjectSpace(descendant.WorldCFrame)

            t3[descendant.Name] = {
                bone = descendant,
                pos = v43.Position,
                R = v43.Rotation
            }
        end
    end

    local t4 = {
        bones = {},
        j = t3,
        front = {},
        rear = {}
    }

    for v44, v45 in pairs(t3) do
        t4.bones[v44] = v45.bone
    end

    local function aim(p17) -- line: 108
        -- upvalues: v42 (copy), t3 (copy), t2 (copy)
        local v46 = t2[p17] * v42 - t3[p17].pos

        return v46.Unit, math.atan2(-v46.Z, (math.abs(v46.X))), (math.atan2(v46.Y, Vector3.new(v46.X, 0, v46.Z).Magnitude))
    end

    for _, v50 in ipairs({
            {
                "FlipL_1",
                "FlipR_1",
                t4.front
            },
            {
                "RearL",
                "RearR",
                t4.rear
            }
        }) do
        local v51 = v50[1]
        local v52 = t2[v51] * v42 - t3[v51].pos
        local Unit = v52.Unit
        local v55 = math.atan2(-v52.Z, (math.abs(v52.X)))
        local v56 = math.atan2(v52.Y, Vector3.new(v52.X, 0, v52.Z).Magnitude)
        local v57 = v50[2]
        local v58 = t2[v57] * v42 - t3[v57].pos
        local Unit2 = v58.Unit
        local v61 = math.atan2(-v58.Z, (math.abs(v58.X)))
        local v62 = math.atan2(v58.Y, Vector3.new(v58.X, 0, v58.Z).Magnitude)
        local v63 = (v55 + v61) / 2
        local v64 = (v56 + v62) / 2

        table.insert(v50[3], {
            sR = -1,
            j = t3[v50[1]],
            outer = t3[v50[1]:gsub("_1", "_2")],
            axis = Unit,
            dPsi = v63 - v55,
            dEps = v64 - v56
        })
        table.insert(v50[3], {
            sR = 1,
            j = t3[v50[2]],
            outer = t3[v50[2]:gsub("_1", "_2")],
            axis = Unit2,
            dPsi = v63 - v61,
            dEps = v64 - v62
        })
    end

    local Neck, Head = t3.Neck, t3.Head

    t4.neck = Neck
    t4.head = Head
    t4.tail = {
        t3.Tail_1,
        t3.Tail_2,
        t3.Tail_3
    }

    return t4
end

local function turn(p18, p19) -- line: 125
    if p18 then
        p18.bone.Transform = p18.R:Inverse() * p19 * p18.R
    end
end

function t1.Pose(p20, p21, p22) -- line: 131
    -- upvalues: t1 (copy), BODY (copy), STROKE (copy)
    local f = p21.f
    local v67 = 1 - STROKE.DOWN
    local v68, v69

    if f < v67 then
        local v70 = f / v67

        v68 = -math.cos(3.141592653589793 * v70)
        v69 = math.sin(3.141592653589793 * v70)
    else
        local v73 = (f - v67) / STROKE.DOWN

        v68 = math.cos(3.141592653589793 * v73)
        v69 = -math.sin(3.141592653589793 * v73)
    end

    local amp, kd = p21.amp, p21.kd

    for _, v76 in ipairs(p20.front) do
        local v78 = math.rad(STROKE.ELEV.MID + STROKE.ELEV.A * amp * v68) + v76.dEps
        local v80 = math.rad(STROKE.SWEEP * amp * v69) + v76.dPsi
        local v82 = math.rad(-STROKE.TWIST * amp * v69)
        local j = v76.j
        local v83 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v76.sR * v80) * CFrame.fromAxisAngle(Vector3.new(0, 0, 1), v76.sR * v78) * CFrame.fromAxisAngle(v76.axis, -v76.sR * v82)

        if j then
            j.bone.Transform = j.R:Inverse() * v83 * j.R
        end

        local v84 = -STROKE.LAG * amp * v69 * (if v69 < 0 then 1 else STROKE.DOWN / (1 - STROKE.DOWN))
        local outer = v76.outer
        local v85 = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), v76.sR * math.rad(v84))

        if outer then
            outer.bone.Transform = outer.R:Inverse() * v85 * outer.R
        end
    end

    local REAR = t1.REAR

    for _, v86 in ipairs(p20.rear) do
        local v87 = kd < 0 == (v86.sR > 0)
        local v89 = math.min(math.abs(kd) * REAR.STEER.GAIN, REAR.STEER.MAX) * (if v87 then 1 else -0.4)
        local j = v86.j
        local v93 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v86.sR * (math.rad(-REAR.BACK + v89) + v86.dPsi)) * CFrame.fromAxisAngle(Vector3.new(0, 0, 1), v86.sR * (math.rad(REAR.PADDLE * amp * -v68) + v86.dEps))

        if j then
            j.bone.Transform = j.R:Inverse() * v93 * j.R
        end
    end

    local NECK = t1.NECK
    local v99 = math.clamp(kd * NECK.TURN.GAIN, -NECK.TURN.MAX, NECK.TURN.MAX) + NECK.WANDER.YAW[1] * math.sin(6.283185307179586 * p22 / NECK.WANDER.YAW[2])
    local v103 = NECK.COUNTER * BODY.NOD * amp * v68 + NECK.WANDER.PITCH[1] * math.sin(6.283185307179586 * p22 / NECK.WANDER.PITCH[2] + 1.1) + (p21.lift or 0)
    local neck = p20.neck
    local v107 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v99 * 0.6))) * CFrame.fromAxisAngle(Vector3.new(1, 0, 0), (math.rad(v103 * 0.6)))

    if neck then
        neck.bone.Transform = neck.R:Inverse() * v107 * neck.R
    end

    local head = p20.head
    local v111 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v99 * 0.4))) * CFrame.fromAxisAngle(Vector3.new(1, 0, 0), (math.rad(v103 * 0.4)))

    if head then
        head.bone.Transform = head.R:Inverse() * v111 * head.R
    end

    local TAIL = t1.TAIL
    local v114 = math.clamp(-kd * TAIL.FOLLOW.GAIN, -TAIL.FOLLOW.MAX, TAIL.FOLLOW.MAX)

    for v115, v116 in ipairs(p20.tail) do
        local v121 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v114 * v115 / #p20.tail + TAIL.SWAY[1] * math.sin(6.283185307179586 * TAIL.SWAY[2] * p22 - v115 * 0.9))))

        if v116 then
            v116.bone.Transform = v116.R:Inverse() * v121 * v116.R
        end
    end
end

return t1
