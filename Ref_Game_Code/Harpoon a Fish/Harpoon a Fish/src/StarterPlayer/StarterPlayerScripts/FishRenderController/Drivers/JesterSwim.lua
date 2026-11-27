-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 4
    local fightHooked, attr = p2.fightHooked, p2.attr

    local function clamp(p3, p4, p5) -- line: 45
        local v1 = if p3 < p4 and p4 then p4 elseif p5 < p3 and p5 then p5 else p3

        return v1
    end

    local function clampv(p6, p7) -- line: 48
        local Magnitude = p6.Magnitude

        return p7 < Magnitude and p6 * (p7 / Magnitude) or p6
    end

    p1.JesterSwim = {
        DIRS = {
            HatA_1 = Vector3.new(0.2546, 0.9168, 0.3077),
            HatA_2 = Vector3.new(0.5545, 0.0777, 0.8285),
            HatA_3 = Vector3.new(0.3976, -0.4187, 0.8165),
            HatA_Bell = Vector3.new(0.4651, -0.6631, 0.5865),
            HatB_1 = Vector3.new(-0.6339, 0.7421, -0.2176),
            HatB_2 = Vector3.new(-0.8501, 0.2361, -0.4708),
            HatB_3 = Vector3.new(-0.8813, -0.2555, -0.3975),
            HatB_Bell = Vector3.new(-0.6831, -0.6153, -0.3933),
            Fin_L = Vector3.new(-0.3373, -0.743, -0.5781),
            FinTip_L = Vector3.new(-0.3751, -0.7884, -0.4876),
            PecBell_L = Vector3.new(-0.4499, -0.8444, -0.2909),
            Fin_R = Vector3.new(-0.2568, -0.7637, 0.5923),
            FinTip_R = Vector3.new(-0.3071, -0.7586, 0.5747),
            PecBell_R = Vector3.new(-0.2409, -0.9003, 0.3625),
            Dorsal_1 = Vector3.new(-0.7933, 0.6089, 0),
            Dorsal_2 = Vector3.new(-0.9524, 0.3047, 0),
            Spike_1 = Vector3.new(-0.9346, 0.333, -0.1252),
            Spike_2 = Vector3.new(-0.9615, 0.2399, -0.1344),
            Spike_3 = Vector3.new(-0.9376, 0.3006, -0.1745),
            LobeU = Vector3.new(-0.7842, 0.6167, -0.0696),
            LobeL = Vector3.new(-0.7595, -0.6488, -0.048)
        },
        ARMS = {
            HatA = Vector3.new(0, 0.1958, 0.1855),
            HatB = Vector3.new(0, 0.2108, -0.1319),
            PecL = Vector3.new(0, -0.1926, -0.1955),
            PecR = Vector3.new(0, -0.1879, 0.1997)
        },
        BODY = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        PARTS = {
            "Jaw",
            "HatA_1",
            "HatA_2",
            "HatA_3",
            "HatA_Bell",
            "HatB_1",
            "HatB_2",
            "HatB_3",
            "HatB_Bell",
            "Fin_L",
            "FinTip_L",
            "PecBell_L",
            "Fin_R",
            "FinTip_R",
            "PecBell_R",
            "Dorsal_1",
            "Dorsal_2",
            "Spike_1",
            "Spike_2",
            "Spike_3",
            "LobeU",
            "LobeL"
        },
        LOCK = 10,
        HOOK_RATE = 15,
        SP_BL = 2,
        SP_MAX = 1.3,
        SP_EASE = 3,
        SP_HOOK = 1.3,
        AMP0 = 0.16,
        AMP1 = 0.26,
        HOOK_AMP = 0.45,
        STIFF = 2.5,
        WAVE_K = 2.6,
        WARP = 0,
        HEAD_SNAP = 0.05,
        CRUISE0 = 3.8,
        CRUISE1 = 1.2,
        F_T1 = 3.3,
        F_T2 = 4.9,
        F_BOB = 0.035,
        F_SWAY = 0.02,
        F_PITCH = 0.06,
        F_ROLL = 0.08,
        BEND = 0.5,
        BEND_MAX = 0.9,
        ARC_EASE = 4,
        ACC_TAU = 0.1,
        H_K = 16,
        H_C = 6,
        TURN_G = 0.9,
        SURGE_G = 0.012,
        ACC_MAX = 12,
        KICK_G = 0.04,
        KICK_UP = 0.03,
        HEAD_LAG = 1.6,
        ROLL_LAG = 0.03,
        STREAM = 0.45,
        S_MAX = 0.8,
        FRAC = { 0.3, 0.35, 0.35 },
        FL_RATE0 = 2.4,
        FL_RATE1 = 1.2,
        FL_A0 = 0.1,
        FL_A1 = 0.08,
        FL_K = 0.95,
        FL_UP = 0.5,
        FL_G = { 0.6, 0.8, 1 },
        B_K = 22,
        B_C = 5.5,
        B_HANG = 0.8,
        B_MAX = 0.7,
        HB_G = 1,
        P_K = 18,
        P_C = 6,
        P_STREAM = 0.3,
        P_TURN = 0.5,
        P_ROLL = 0.015,
        P_FRAC = { 0.25, 0.75 },
        FIN_FLOOR = 0.6,
        PEC_LIFT = 0.1,
        PEC_FLAP = 0.38,
        PEC_TIP = 0.3,
        PEC_BELL = 0.3,
        PEC_LAG = 1.1,
        PEC_SWEEP = 0.4,
        D_K = 20,
        D_C = 6,
        D_PH = 1.2,
        D_TURN = 0.25,
        D_STREAM = 0.08,
        D_FRAC = { 0.4, 0.6 },
        DS1 = 0.24,
        DS2 = 0.25,
        D_LAG = 0.8,
        SPK_A = 0.24,
        SPK_PH = 1,
        SPK_LAG = 0.5,
        LOBE_A = 0.9,
        LOBE_LAG = 0.9,
        CH_EVERY = { 4, 7 },
        CH_MAX = 1,
        CT = 1.6,
        HOLD = 0.7,
        WIND = 0.6,
        GAPE = -0.12,
        SHUT = 0.4,
        BREATH = 0.04,
        SNAP_EASE = 3.5,
        OPEN_EASE = 2.5,
        HOOK_CHOMP = 8,
        HOOK_SHAKE = 0.25,
        HOOK_SHAKE_RATE = 11,
        ROLL_EVERY = { 9, 14 },
        ROLL_T = 2.2,
        ROLL_MIN_SP = 0.3,
        rollEase = function(p8) -- rollEase | line: 104
            if p8 <= 0 then
                return 0
            end

            if p8 >= 1 then
                return 1
            end

            return 0.5 - math.cos(3.141592653589793 * p8) * 0.5
        end,
        rateOf = function(_, p10, p11) -- rateOf | line: 111
            -- upvalues: p1 (copy)
            local JesterSwim = p1.JesterSwim

            return JesterSwim.CRUISE0 + JesterSwim.CRUISE1 * math.min(1, p10 / math.max(p11, 0.001) / JesterSwim.SP_BL)
        end,
        rot = function(p12, p13) -- rot | line: 116
            local Magnitude = p13.Magnitude

            if Magnitude < 1E-06 then
                p12.bone.Transform = CFrame.identity
            else
                p12.bone.Transform = CFrame.fromAxisAngle((p12.ln * p13.X + p12.lu * p13.Y + p12.lr * p13.Z) / Magnitude, Magnitude)
            end
        end,
        register = function(p14) -- register | line: 124
            -- upvalues: p1 (copy)
            local JesterSwim = p1.JesterSwim
            local MeshPart = p14:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            for _, v4 in ipairs(JesterSwim.BODY) do
                if not t2[v4] then
                    return nil
                end
            end

            if not (t2.Fin_L and t2.Fin_R) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local Unit = CFrame:VectorToObjectSpace(t2.Spine_01.WorldPosition - t2.Spine_04.WorldPosition).Unit
            local Unit2 = CFrame:VectorToObjectSpace(t2.Fin_R.WorldPosition - t2.Fin_L.WorldPosition).Unit:Cross(Unit).Unit
            local Unit3 = Unit:Cross(Unit2).Unit

            local function entry(p15) -- line: 140
                -- upvalues: CFrame (copy), Unit (copy), Unit2 (copy), Unit3 (copy)
                local v5 = CFrame:ToObjectSpace(p15.WorldCFrame)

                return {
                    bone = p15,
                    ln = v5:VectorToObjectSpace(Unit),
                    lu = v5:VectorToObjectSpace(Unit2),
                    lr = v5:VectorToObjectSpace(Unit3)
                }
            end

            local t3 = {}

            for _, v6 in ipairs(JesterSwim.BODY) do
                t3[v6] = entry(t2[v6])
            end

            for _, v7 in ipairs(JesterSwim.PARTS) do
                if t2[v7] then
                    t3[v7] = entry(t2[v7])
                end
            end

            local Size = MeshPart.Size

            local function list(p16) -- line: 151
                -- upvalues: t3 (copy)
                local t4 = {}

                for v8, v9 in ipairs(p16) do
                    t4[v8] = t3[v9] or false
                end

                return t4
            end

            local t5 = {
                model = p14,
                mesh = MeshPart,
                nose = Unit,
                B = t3
            }
            local t6 = {
                "HatA_1",
                "HatA_2",
                "HatA_3"
            }
            local t7 = {}

            for v10, v11 in ipairs(t6) do
                t7[v10] = t3[v11] or false
            end

            t5.hornA = t7

            local t8 = {
                "HatB_1",
                "HatB_2",
                "HatB_3"
            }
            local t9 = {}

            for v12, v13 in ipairs(t8) do
                t9[v12] = t3[v13] or false
            end

            t5.hornB = t9

            local t10 = {
                "Spike_1",
                "Spike_2",
                "Spike_3"
            }
            local t11 = {}

            for v14, v15 in ipairs(t10) do
                t11[v14] = t3[v15] or false
            end

            t5.spikes = t11
            t5.length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            t5.w = 0
            t5.v = 0
            t5.phase = math.random() * 6.283185307179586
            t5.ft = math.random() * 6.283185307179586
            t5.t = 0
            t5.sp = 0.5
            t5.arc = 0
            t5.acc = 0
            t5.prevV = nil
            t5.hsA = Vector3.new(0, 0, 0)
            t5.hvA = Vector3.new(0, 0, 0)
            t5.hsB = Vector3.new(0, 0, 0)
            t5.hvB = Vector3.new(0, 0, 0)
            t5.bsA = Vector3.new(0, 0, 0)
            t5.bvA = Vector3.new(0, 0, 0)
            t5.bsB = Vector3.new(0, 0, 0)
            t5.bvB = Vector3.new(0, 0, 0)
            t5.bsL = Vector3.new(0, 0, 0)
            t5.bvL = Vector3.new(0, 0, 0)
            t5.bsR = Vector3.new(0, 0, 0)
            t5.bvR = Vector3.new(0, 0, 0)
            t5.psL = Vector3.new(0, 0, 0)
            t5.pvL = Vector3.new(0, 0, 0)
            t5.psR = Vector3.new(0, 0, 0)
            t5.pvR = Vector3.new(0, 0, 0)
            t5.dz = 0
            t5.dzv = 0
            t5.rollT = nil
            t5.rollDir = 1
            t5.rollNext = JesterSwim.ROLL_EVERY[1] * (0.5 + math.random())
            t5.roll = 0
            t5.rollRate = 0
            t5.since = 99
            t5.chomps = 1
            t5.chNext = JesterSwim.CH_EVERY[1] * math.random()
            t5.jaw = 0
            t5.jawT = 0
            t5.a0 = 0

            return t5
        end,
        update = function(p17, p18, _) -- update | line: 171
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local JesterSwim = p1.JesterSwim
            local model = p17.model
            local v18 = fightHooked(model)

            p1.SharkSwim.readTurn(p17, p18)

            local v, sp, length = p17.v, p17.w, p17.length
            local StrokeAt = attr(model, "StrokeAt")
            local v19, phase, v20, v21, v22

            if v18 then
                p17.locked = nil
                p17.phase += p18 * JesterSwim.HOOK_RATE
            elseif StrokeAt then
                v20 = attr(model, "StrokeRate") or 0
                v19 = (attr(model, "StrokePhase") or 0) + v20 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p17.locked then
                    p17.phase += p18 * v20
                    phase = p17.phase
                    v21 = (v19 - p17.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                    v22 = p18 * JesterSwim.LOCK
                    p17.phase = phase + v21 * math.min(1, v22)
                else
                    p17.phase = v19
                    p17.locked = true
                end
            else
                p17.locked = nil
                p17.phase += p18 * JesterSwim.rateOf(attr(model, "StrokeHz"), v, length)
            end

            p17.t += p18
            StrokeAt = v / math.max(length, 0.001)

            local SP_HOOK = if v18 then JesterSwim.SP_HOOK else nil

            if not v18 or not SP_HOOK then
                SP_HOOK = StrokeAt / JesterSwim.SP_BL
                v19 = JesterSwim.SP_MAX

                if SP_HOOK < 0 then
                    SP_HOOK = 0
                elseif v19 < SP_HOOK and v19 then
                    SP_HOOK = v19
                end
            end

            p17.sp = p17.sp + (SP_HOOK - p17.sp) * math.min(1, p18 * JesterSwim.SP_EASE)
            v20 = JesterSwim.BEND * length * sp / math.max(v, 5)
            v19 = -JesterSwim.BEND_MAX
            phase = JesterSwim.BEND_MAX

            local v23 = if v20 < v19 and v19 then v19 elseif phase < v20 and phase then phase else v20

            v20 = p17.arc
            phase = v23 - p17.arc

            local DIRS = p18 * JesterSwim.ARC_EASE

            p17.arc = v20 + phase * math.min(1, DIRS)

            if p18 > 1E-04 and p17.prevV then
                v23 = (v - p17.prevV) / p18
                v20 = p17.acc
                phase = v23 - p17.acc
                DIRS = p18 / JesterSwim.ACC_TAU
                p17.acc = v20 + phase * math.min(1, DIRS)
            end

            p17.prevV = v
            sp = p17.sp
            v20 = math.min(sp, 1)
            p17.ft += p18 * (JesterSwim.FL_RATE0 + JesterSwim.FL_RATE1 * sp)

            local v24 = p17.roll

            if not p17.rollT then
                p17.rollNext -= p18

                if p17.rollNext <= 0 and not v18 and JesterSwim.ROLL_MIN_SP < sp then
                    p17.rollT = 0
                    p17.rollDir = -p17.rollDir
                    p17.rollNext = JesterSwim.ROLL_EVERY[1] + math.random() * (JesterSwim.ROLL_EVERY[2] - JesterSwim.ROLL_EVERY[1])
                end
            end

            if p17.rollT then
                p17.rollT += p18
                SP_HOOK = p17.rollT / JesterSwim.ROLL_T

                if SP_HOOK >= 1 then
                    p17.rollT = nil
                    p17.roll = 0
                    p17.rollRate = 0
                else
                    p17.roll = p17.rollDir * 6.283185307179586 * JesterSwim.rollEase(SP_HOOK)
                    p17.rollRate = (p17.roll - v24) / math.max(p18, 1E-04)
                end
            else
                p17.rollRate = 0
            end

            v19 = p17.since < p17.chomps * JesterSwim.CT

            if not v18 then
                p17.chNext -= p18

                if p17.chNext <= 0 and not v19 then
                    p17.since = -JesterSwim.WIND
                    v21 = math.random() * JesterSwim.CH_MAX
                    p17.chomps = math.floor(v21) + 1
                    p17.chNext = JesterSwim.CH_EVERY[1] + math.random() * (JesterSwim.CH_EVERY[2] - JesterSwim.CH_EVERY[1])
                end
            end

            p17.since += p18

            local v25

            if v18 then
                v25 = JesterSwim.SHUT
                v22 = p17.t * JesterSwim.HOOK_CHOMP
                v25 *= math.sin(v22) * 0.5 + 0.5
            elseif p17.since < 0 then
                v25 = JesterSwim.GAPE
            elseif p17.since < p17.chomps * JesterSwim.CT then
                v25 = p17.since % JesterSwim.CT < JesterSwim.HOLD and JesterSwim.SHUT or 0
            else
                v25 = JesterSwim.BREATH
                v22 = 1.1 * p17.t
                v25 *= math.sin(v22) * 0.5 + 0.5
            end

            local v26 = p17.jawT < v25 and JesterSwim.SNAP_EASE or JesterSwim.OPEN_EASE
            local jawT = p17.jawT

            p17.jawT = jawT + (v25 - p17.jawT) * math.min(1, p18 * v26)
            p17.jaw = p17.jaw + (p17.jawT - p17.jaw) * math.min(1, p18 * v26)

            local HOOK_AMP = v18 and JesterSwim.HOOK_AMP or JesterSwim.AMP0 + (JesterSwim.AMP1 - JesterSwim.AMP0) * v20

            v26 = p17.phase + JesterSwim.WARP * math.sin(2 * p17.phase)
            v21 = HOOK_AMP * 0.05 * math.sin(v26)

            local ARMS = JesterSwim.HEAD_SNAP * v20
            local v27 = v26 - JesterSwim.WAVE_K

            p17.a0 = v21 - ARMS * math.sin(v27)
            v25 = math.min(p18, 0.03333333333333333)
            v21 = p17.acc / math.max(length, 0.001)
            DIRS = -JesterSwim.ACC_MAX
            ARMS = JesterSwim.ACC_MAX

            local v28 = if v21 < DIRS and DIRS then DIRS elseif ARMS < v21 and ARMS then ARMS else v21

            ARMS = Vector3.new(0, 0, 1) * (JesterSwim.TURN_G * p17.arc * v20)

            local v29 = JesterSwim.SURGE_G * v28

            v21 = ARMS + Vector3.new(-1, -0, -0) * (v29 + JesterSwim.KICK_G * v20 * math.cos(2 * v26)) + Vector3.new(0, 1, 0) * (JesterSwim.KICK_UP * v20 * math.sin(2 * v26))

            if v18 then
                v27 = JesterSwim.HOOK_SHAKE
                v29 = p17.t * JesterSwim.HOOK_SHAKE_RATE
                v21 += Vector3.new(0, 0, 1) * (v27 * math.sin(v29))
            end

            DIRS = JesterSwim.DIRS
            ARMS = JesterSwim.ARMS
            v28 = ARMS.HatA
            v22 = v21 + Vector3.new(-1, -0, -0) * (JesterSwim.STREAM * sp) + (Vector3.new(0, 1, 0)):Cross(DIRS.HatA_3) * (-JesterSwim.HEAD_LAG * p17.a0) + (Vector3.new(1, 0, 0)):Cross(v28) * (-JesterSwim.ROLL_LAG * p17.rollRate / math.max(v28.Magnitude, 0.001))
            v27 = JesterSwim.S_MAX

            local Magnitude = v22.Magnitude
            local v32 = v27 < Magnitude
            local v33 = if v32 then v22 * (v27 / Magnitude) else nil

            if v32 and v33 then
                v22 = v33
            end

            local hsA = p17.hsA

            v27 = p17.hvA
            v27 += ((v22 - hsA) * JesterSwim.H_K - v27 * JesterSwim.H_C) * v25
            Magnitude = hsA + v27 * v25
            v29 = JesterSwim.S_MAX
            v28 = Magnitude.Magnitude

            local v34 = v29 < v28
            local v35 = if v34 then Magnitude * (v29 / v28) else nil

            if v34 and v35 then
                Magnitude = v35
            end

            p17.hsA = Magnitude
            p17.hvA = v27
            Magnitude = Magnitude * -JesterSwim.B_HANG + v21
            v29 = JesterSwim.B_MAX
            v33 = Magnitude.Magnitude

            local v36 = v29 < v33
            local v37 = if v36 then Magnitude * (v29 / v33) else nil

            if v36 and v37 then
                Magnitude = v37
            end

            local bsA = p17.bsA

            v29 = p17.bvA
            v29 += ((Magnitude - bsA) * JesterSwim.B_K - v29 * JesterSwim.B_C) * v25

            local v30 = bsA + v29 * v25
            local B_MAX = JesterSwim.B_MAX

            v37 = v30.Magnitude

            local v38 = B_MAX < v37
            local v39 = if v38 then v30 * (B_MAX / v37) else nil

            if v38 and v39 then
                v30 = v39
            end

            p17.bsA = v30
            p17.bvA = v29
            v35 = ARMS.HatB
            Magnitude = v21 + Vector3.new(-1, -0, -0) * (JesterSwim.STREAM * sp) + (Vector3.new(0, 1, 0)):Cross(DIRS.HatB_3) * (-JesterSwim.HEAD_LAG * p17.a0) + (Vector3.new(1, 0, 0)):Cross(v35) * (-JesterSwim.ROLL_LAG * p17.rollRate / math.max(v35.Magnitude, 0.001))
            v29 = JesterSwim.S_MAX
            v39 = Magnitude.Magnitude

            local v40 = v29 < v39
            local v41 = if v40 then Magnitude * (v29 / v39) else nil

            if v40 and v41 then
                Magnitude = v41
            end

            bsA = p17.hsB
            v29 = p17.hvB
            v29 += ((Magnitude - bsA) * JesterSwim.H_K - v29 * JesterSwim.H_C) * v25
            v39 = bsA + v29 * v25
            v30 = JesterSwim.S_MAX
            v41 = v39.Magnitude

            local v42 = v30 < v41
            local v43 = if v42 then v39 * (v30 / v41) else nil

            if v42 and v43 then
                v39 = v43
            end

            p17.hsB = v39
            p17.hvB = v29
            v39 = v39 * -JesterSwim.B_HANG + v21
            v30 = JesterSwim.B_MAX
            v35 = v39.Magnitude

            local v44 = v30 < v35
            local v45 = if v44 then v39 * (v30 / v35) else nil

            if v44 and v45 then
                v39 = v45
            end

            local v31 = p17.bsB

            v30 = p17.bvB
            v30 += ((v39 - v31) * JesterSwim.B_K - v30 * JesterSwim.B_C) * v25

            local DIRB = v31 + v30 * v25
            local DIRS3 = JesterSwim.B_MAX

            v45 = DIRB.Magnitude
            DIRB = DIRS3 < v45 and DIRB * (DIRS3 / v45) or DIRB
            p17.bsB = DIRB
            p17.bvB = v30
            v35 = ARMS.PecL
            v43 = Vector3.new(-1, -0, -0) * (JesterSwim.P_STREAM * sp) + Vector3.new(0, 1, 0) * (JesterSwim.P_TURN * p17.arc * v20) + (Vector3.new(1, 0, 0)):Cross(v35) * (-JesterSwim.P_ROLL * p17.rollRate / math.max(v35.Magnitude, 0.001))
            v45 = JesterSwim.S_MAX
            v39 = v43.Magnitude

            local v46 = v45 < v39
            local v47 = if v46 then v43 * (v45 / v39) else nil

            if v46 and v47 then
                v43 = v47
            end

            Magnitude = p17.psL
            v45 = p17.pvL
            v45 += ((v43 - Magnitude) * JesterSwim.P_K - v45 * JesterSwim.P_C) * v25
            v39 = Magnitude + v45 * v25
            v30 = JesterSwim.S_MAX
            v47 = v39.Magnitude

            local v48 = v30 < v47
            local v49 = if v48 then v39 * (v30 / v47) else nil

            if v48 and v49 then
                v39 = v49
            end

            p17.psL = v39
            p17.pvL = v45
            v39 = v39 * -JesterSwim.B_HANG + v21
            v30 = JesterSwim.B_MAX
            v35 = v39.Magnitude

            local v50 = v30 < v35
            local v51 = if v50 then v39 * (v30 / v35) else nil

            if v50 and v51 then
                v39 = v51
            end

            v31 = p17.bsL
            v30 = p17.bvL
            v30 += ((v39 - v31) * JesterSwim.B_K - v30 * JesterSwim.B_C) * v25
            DIRB = v31 + v30 * v25
            DIRS3 = JesterSwim.B_MAX
            v51 = DIRB.Magnitude
            DIRB = DIRS3 < v51 and DIRB * (DIRS3 / v51) or DIRB
            p17.bsL = DIRB
            p17.bvL = v30
            v35 = ARMS.PecR
            v51 = Vector3.new(-1, -0, -0) * (JesterSwim.P_STREAM * sp) + Vector3.new(0, 1, 0) * (-JesterSwim.P_TURN * p17.arc * v20)
            v30 = (Vector3.new(1, 0, 0)):Cross(v35)
            DIRB = -JesterSwim.P_ROLL * p17.rollRate

            local Magnitude2 = v35.Magnitude

            v49 = v51 + v30 * (DIRB / math.max(Magnitude2, 0.001))
            v51 = JesterSwim.S_MAX
            v39 = v49.Magnitude

            local v52 = v51 < v39
            local v53 = if v52 then v49 * (v51 / v39) else nil

            if v52 and v53 then
                v49 = v53
            end

            v43 = p17.psR
            v51 = p17.pvR
            v51 += ((v49 - v43) * JesterSwim.P_K - v51 * JesterSwim.P_C) * v25
            v39 = v43 + v51 * v25
            v30 = JesterSwim.S_MAX
            v53 = v39.Magnitude

            local v54 = v30 < v53
            local v55 = if v54 then v39 * (v30 / v53) else nil

            if v54 and v55 then
                v39 = v55
            end

            p17.psR = v39
            p17.pvR = v51
            v39 = v39 * -JesterSwim.B_HANG + v21
            v30 = JesterSwim.B_MAX
            v35 = v39.Magnitude

            local v56 = v30 < v35
            local v57 = if v56 then v39 * (v30 / v35) else nil

            if v56 and v57 then
                v39 = v57
            end

            v31 = p17.bsR
            v30 = p17.bvR
            v30 += ((v39 - v31) * JesterSwim.B_K - v30 * JesterSwim.B_C) * v25
            DIRB = v31 + v30 * v25
            DIRS3 = JesterSwim.B_MAX
            v57 = DIRB.Magnitude

            local v58 = DIRS3 < v57
            local v59 = if v58 then DIRB * (DIRS3 / v57) else nil

            if v58 and v59 then
                DIRB = v59
            end

            p17.bsR = DIRB
            p17.bvR = v30
            ARMS = JesterSwim.D_TURN * p17.arc * v20
            p17.dzv += (JesterSwim.D_K * (ARMS - p17.dz) - JesterSwim.D_C * p17.dzv) * v25
            p17.dz += p17.dzv * v25
            v35 = p17.B
            v53 = JesterSwim.rot
            ARMS = -p17.arc / 6

            local v60, v61, v62, FL_UP, v63, v64, SWEEP, v65

            for v66, v67 in ipairs(JesterSwim.BODY) do
                v21 = (v66 - 1) / 6
                v24 = v35[v67]

                if v66 == 1 then
                    DIRB = CFrame.identity
                    Magnitude2 = p17.roll

                    if math.abs(Magnitude2) > 1E-06 then
                        DIRB = CFrame.fromAxisAngle(v24.ln, p17.roll)
                    end

                    DIRS3 = 6.283185307179586 * p17.t / JesterSwim.F_T1
                    v65 = CFrame.new
                    v63 = v24.lu * (JesterSwim.F_BOB * length * math.sin(DIRS3))
                    v62 = v24.lr
                    v60 = JesterSwim.F_SWAY * length
                    FL_UP = 2 * DIRS3
                    v65 = v65(v63 + v62 * (v60 * math.sin(FL_UP)))
                    v61 = CFrame.fromAxisAngle
                    v63 = v24.lr
                    v62 = JesterSwim.F_PITCH
                    v60 = DIRS3 - 0.9
                    SWEEP = v65 * v61(v63, v62 * math.sin(v60))
                    v65 = CFrame.fromAxisAngle
                    v61 = v24.ln
                    v64 = JesterSwim.F_ROLL
                    Magnitude2 = SWEEP * v65(v61, v64 * math.sin(6.283185307179586 * p17.t / JesterSwim.F_T2))
                    v24.bone.Transform = Magnitude2 * DIRB * CFrame.fromAxisAngle(v24.lu, p17.a0)
                else
                    DIRS3 = HOOK_AMP * (0.05 + 1.2 * v21 ^ JesterSwim.STIFF)
                    SWEEP = v26 - v21 * JesterSwim.WAVE_K
                    DIRB = DIRS3 * math.sin(SWEEP)
                    v24.bone.Transform = CFrame.fromAxisAngle(v24.lu, DIRB + ARMS)
                end
            end

            if v35.Jaw then
                v35.Jaw.bone.Transform = CFrame.fromAxisAngle(v35.Jaw.lr, p17.jaw)
            end

            ARMS = JesterSwim.FL_A0 + JesterSwim.FL_A1 * sp
            v55 = JesterSwim.FRAC
            v57 = JesterSwim.FL_G
            length = p17.hsA
            v59 = JesterSwim.DIRA
            DIRB = JesterSwim.DIRB
            DIRS3 = JesterSwim.DIRS3

            for i = 1, 3 do
                v30 = p17.hornA[i]

                if v30 then
                    v39 = v59[i]
                    v61 = p17.ft - JesterSwim.FL_K * (i - 1)
                    v62 = Vector3.new(0, 0, 1) * math.sin(v61)
                    FL_UP = JesterSwim.FL_UP
                    v63 = (v62 + Vector3.new(0, 1, 0) * (FL_UP * math.sin(2 * v61 + 1.3))) * (v57[i] * ARMS)
                    v53(v30, v39:Cross(length) * v55[i] + v39:Cross(v63))
                end
            end

            local FL_UP2, v70

            if v35.HatA_Bell then
                SWEEP = v35.HatA_Bell
                v65 = DIRS.HatA_Bell
                v64 = p17.bsA
                FL_UP2 = JesterSwim.HB_G * ARMS
                v70 = p17.ft - JesterSwim.FL_K * 3
                v53(SWEEP, v65:Cross(v64 + Vector3.new(0, 0, 1) * (FL_UP2 * math.sin(v70))))
            end

            length = p17.hsB

            for i = 1, 3 do
                v30 = p17.hornB[i]

                if v30 then
                    v39 = DIRB[i]
                    v59 = p17.ft - JesterSwim.FL_K * (i - 1) + 2.1
                    v64 = Vector3.new(0, 0, 1) * math.sin(v59)
                    FL_UP2 = JesterSwim.FL_UP
                    v70 = 2 * v59 + 1.3
                    v61 = (v64 + Vector3.new(0, 1, 0) * (FL_UP2 * math.sin(v70))) * (v57[i] * ARMS)
                    v53(v30, v39:Cross(length) * v55[i] + v39:Cross(v61))
                end
            end

            if v35.HatB_Bell then
                SWEEP = v35.HatB_Bell
                v65 = DIRS.HatB_Bell
                v64 = p17.bsB
                FL_UP2 = JesterSwim.HB_G * ARMS
                v70 = p17.ft - JesterSwim.FL_K * 3 + 2.1
                v53(SWEEP, v65:Cross(v64 + Vector3.new(0, 0, 1) * (FL_UP2 * math.sin(v70))))
            end

            DIRB = JesterSwim.FIN_FLOOR + (1 - JesterSwim.FIN_FLOOR) * v20
            Magnitude2 = JesterSwim.FLAP
            SWEEP = JesterSwim.SWEEP
            v57 = JesterSwim.PEC_LIFT + JesterSwim.PEC_FLAP * DIRB * math.sin(v26)
            v55 = v26 - JesterSwim.PEC_LAG
            v65 = JesterSwim.PEC_TIP * DIRB * math.sin(v55)
            v61 = JesterSwim.PEC_TIP * JesterSwim.PEC_SWEEP * DIRB * math.cos(v55)
            v55 = JesterSwim.PEC_BELL * DIRB * math.sin(v26 - 2 * JesterSwim.PEC_LAG)
            ARMS = p17.psL

            if v35.Fin_L then
                v53(v35.Fin_L, DIRS.Fin_L:Cross(ARMS) * JesterSwim.P_FRAC[1] + Magnitude2.Fin_L * v57)
            end

            if v35.FinTip_L then
                v53(v35.FinTip_L, DIRS.FinTip_L:Cross(ARMS) * JesterSwim.P_FRAC[2] + Magnitude2.FinTip_L * v65 + SWEEP.FinTip_L * v61)
            end

            if v35.PecBell_L then
                v53(v35.PecBell_L, DIRS.PecBell_L:Cross(p17.bsL) + Magnitude2.PecBell_L * v55)
            end

            ARMS = p17.psR

            if v35.Fin_R then
                v53(v35.Fin_R, DIRS.Fin_R:Cross(ARMS) * JesterSwim.P_FRAC[1] + Magnitude2.Fin_R * v57)
            end

            if v35.FinTip_R then
                v53(v35.FinTip_R, DIRS.FinTip_R:Cross(ARMS) * JesterSwim.P_FRAC[2] + Magnitude2.FinTip_R * v65 + SWEEP.FinTip_R * v61)
            end

            if v35.PecBell_R then
                v53(v35.PecBell_R, DIRS.PecBell_R:Cross(p17.bsR) + Magnitude2.PecBell_R * v55)
            end

            v61 = JesterSwim.DS1 * DIRB * math.sin(v26 - JesterSwim.D_PH)
            v65 = JesterSwim.DS2 * DIRB * math.sin(v26 - JesterSwim.D_PH - JesterSwim.D_LAG)

            if v35.Dorsal_1 then
                v53(v35.Dorsal_1, DIRS.Dorsal_1:Cross(Vector3.new(0, 0, 1) * (JesterSwim.D_FRAC[1] * p17.dz) + Vector3.new(-1, -0, -0) * (JesterSwim.D_FRAC[1] * JesterSwim.D_STREAM * sp)) + Vector3.new(1, 0, 0) * v61)
            end

            if v35.Dorsal_2 then
                v53(v35.Dorsal_2, DIRS.Dorsal_2:Cross(Vector3.new(0, 0, 1) * (JesterSwim.D_FRAC[2] * p17.dz) + Vector3.new(-1, -0, -0) * (JesterSwim.D_FRAC[2] * JesterSwim.D_STREAM * sp)) + Vector3.new(1, 0, 0) * v65)
            end

            for i = 1, 3 do
                v30 = p17.spikes[i]

                if v30 then
                    v39 = DIRS3[i]
                    v53(v30, v39:Cross(Vector3.new(0, 0, 1) * (JesterSwim.SPK_A * DIRB * math.sin(v26 - JesterSwim.SPK_PH - JesterSwim.SPK_LAG * (i - 1)))))
                end
            end

            v61 = Vector3.new(0, 0, 1) * (JesterSwim.LOBE_A * HOOK_AMP * math.sin(v26 - JesterSwim.WAVE_K - JesterSwim.LOBE_LAG))

            if v35.LobeU then
                v53(v35.LobeU, DIRS.LobeU:Cross(v61))
            end

            if v35.LobeL then
                v53(v35.LobeL, DIRS.LobeL:Cross(v61))
            end
        end
    }

    local JesterSwim = p1.JesterSwim

    JesterSwim.DIRA = {
        JesterSwim.DIRS.HatA_1,
        JesterSwim.DIRS.HatA_2,
        JesterSwim.DIRS.HatA_3
    }
    JesterSwim.DIRB = {
        JesterSwim.DIRS.HatB_1,
        JesterSwim.DIRS.HatB_2,
        JesterSwim.DIRS.HatB_3
    }
    JesterSwim.DIRS3 = {
        JesterSwim.DIRS.Spike_1,
        JesterSwim.DIRS.Spike_2,
        JesterSwim.DIRS.Spike_3
    }

    local t12 = {}

    JesterSwim.FLAP = {}
    JesterSwim.SWEEP = t12

    for _, v73 in ipairs({ "FinTip_L", "PecBell_L", "FinTip_R", "PecBell_R" }) do
        JesterSwim.FLAP[v73] = JesterSwim.DIRS[v73]:Cross((Vector3.new(0, 1, 0))).Unit
    end

    for _, v74 in ipairs({ "FinTip_L", "FinTip_R" }) do
        JesterSwim.SWEEP[v74] = JesterSwim.DIRS[v74]:Cross((Vector3.new(-1, -0, -0))).Unit
    end

    for _, v75 in ipairs({ "Fin_L", "Fin_R" }) do
        local FLAP = JesterSwim.FLAP

        if (Vector3.new(1, 0, 0)):Cross(JesterSwim.DIRS[v75]).Y > 0 then
            FLAP[v75] = Vector3.new(1, 0, 0)
        else
            FLAP[v75] = Vector3.new(-1, -0, -0)
        end
    end
end
