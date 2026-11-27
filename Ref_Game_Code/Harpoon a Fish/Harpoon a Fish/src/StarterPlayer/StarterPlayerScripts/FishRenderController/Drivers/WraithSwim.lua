-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    local function clamp(p3, p4, p5) -- line: 43
        local v1 = if p3 < p4 and p4 then p4 elseif p5 < p3 and p5 then p5 else p3

        return v1
    end

    local function clampv(p6, p7) -- line: 46
        local Magnitude = p6.Magnitude

        return p7 < Magnitude and p6 * (p7 / Magnitude) or p6
    end

    local function sstep(p8) -- line: 50
        local v2 = if p8 < 0 then 0 elseif p8 > 1 then 1 else p8

        return v2 * v2 * (3 - 2 * v2)
    end

    local function spring(p9, p10, p11, p12, p13, p14, p15) -- line: 55
        local v3 = p10 + ((p11 - p9) * p12 - p10 * p13) * p14
        local v4 = p9 + v3 * p14
        local Magnitude = v4.Magnitude

        v4 = p15 < Magnitude and v4 * (p15 / Magnitude) or v4

        return v4, v3
    end

    p1.WraithSwim = {
        DIRS = {
            Jaw = Vector3.new(0.9642, -0.2652, 0),
            HatA_1 = Vector3.new(0.3759, 0.522, 0.7656),
            HatA_2 = Vector3.new(0.0485, 0.2423, 0.969),
            HatA_3 = Vector3.new(0.1826, 0, 0.9832),
            HatA_Bell = Vector3.new(0.2746, -0.659, 0.7002),
            HatB_1 = Vector3.new(-0.8612, 0.5044, -0.0615),
            HatB_2 = Vector3.new(-0.7344, 0.4365, -0.5197),
            HatB_3 = Vector3.new(-0.8306, 0.1846, -0.5254),
            HatB_Bell = Vector3.new(-0.846, -0.4525, -0.282),
            HatB_Jingle = Vector3.new(-0.117, -0.983, 0.1414),
            Fin_L = Vector3.new(-0.1978, -0.6594, -0.7253),
            FinTip_L = Vector3.new(-0.2021, -0.7412, -0.6401),
            PecBell_L = Vector3.new(-0.4675, -0.8334, -0.2947),
            Fin_R = Vector3.new(-0.3625, -0.659, 0.659),
            FinTip_R = Vector3.new(-0.1732, -0.7623, 0.6237),
            PecBell_R = Vector3.new(-0.5258, -0.8412, 0.1262),
            Dorsal_1 = Vector3.new(-0.8619, 0.4972, -0.0994),
            Dorsal_2 = Vector3.new(-0.917, 0.3821, -0.1146),
            Dorsal_Bell = Vector3.new(-0.9856, -0.1643, -0.0389),
            Spike_1 = Vector3.new(-0.9855, 0.1524, -0.0743),
            Spike_2 = Vector3.new(-0.9945, 0.0904, -0.052),
            Spike_3 = Vector3.new(-0.9998, 0, 0.0181),
            LobeU = Vector3.new(-0.7743, 0.6195, 0.1291),
            LobeUTip = Vector3.new(-0.7371, 0.6701, 0.0871),
            LobeU_Bell = Vector3.new(-0.8624, 0.5048, 0.0389),
            LobeL = Vector3.new(-0.8489, -0.5093, 0.1415),
            LobeLTip = Vector3.new(-0.8381, -0.5334, 0.1143),
            LobeL_Bell = Vector3.new(-0.7998, -0.5979, 0.0531)
        },
        ARMS = {
            HatA = Vector3.new(0, 0.19, 0.218),
            HatB = Vector3.new(0, 0.22, -0.147),
            PecL = Vector3.new(0, -0.192, -0.214),
            PecR = Vector3.new(0, -0.191, 0.199)
        },
        BODY = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        LOCK = 10,
        HOOK_RATE = 15,
        SP_BL = 2,
        SP_MAX = 1.3,
        SP_EASE = 3,
        SP_HOOK = 1.3,
        AMP0 = 0.18,
        AMP1 = 0.27,
        HOOK_AMP = 0.45,
        STIFF = 2,
        WAVE_K = 3,
        WARP = 0,
        HEAD_SNAP = 0.05,
        CRUISE0 = 3.6,
        CRUISE1 = 1,
        F_T1 = 3.8,
        F_T2 = 5.6,
        F_BOB = 0.04,
        F_SWAY = 0.025,
        F_PITCH = 0.07,
        F_ROLL = 0.09,
        BEND = 0.5,
        BEND_MAX = 0.9,
        ARC_EASE = 4,
        ACC_TAU = 0.1,
        H_K = 14,
        H_C = 5.5,
        TURN_G = 0.9,
        SURGE_G = 0.012,
        ACC_MAX = 12,
        KICK_G = 0.04,
        KICK_UP = 0.03,
        HEAD_LAG = 1.6,
        ROLL_LAG = 0.02,
        STREAM = 0.4,
        S_MAX = 0.8,
        FRAC = { 0.3, 0.35, 0.35 },
        FL_RATE0 = 2.2,
        FL_RATE1 = 1,
        FL_E0 = 0.75,
        FL_E1 = 0.25,
        FL_K = 0.9,
        FL_B = 0.45,
        HF_A = { 0.24, 0.27, 0.3 },
        DF_A = { 0.24, 0.27 },
        LF_A = { 0.24, 0.28 },
        B_K = 22,
        B_C = 6,
        B_HANG = 0.8,
        B_MAX = 0.7,
        B_SW = 0.2,
        B_SW_RATE = 1.3,
        JINGLE_G = 0.9,
        P_K = 18,
        P_C = 6,
        P_STREAM = 0.3,
        P_TURN = 0.5,
        P_HEAVE = 0.06,
        P_ROLL = 0.012,
        P_FRAC = { 0.35, 0.65 },
        P_FLAP = 0.32,
        P_BIAS = 0.06,
        P_SWEEP = 0.08,
        P_TFLAP = 0.3,
        P_LAG = 1,
        D_K = 20,
        D_C = 6,
        D_A = 0.35,
        D_PH = 1.2,
        D_TURN = 0.25,
        D_STREAM = 0.08,
        D_FRAC = { 0.4, 0.6 },
        SPK_A = 0.2,
        SPK_PH = 1,
        SPK_LAG = 0.6,
        SPK_RATTLE = 0.06,
        LOBE_A = 0.7,
        LOBE_LAG = 0.9,
        CH_EVERY = { 4, 7 },
        CH_MAX = 1,
        CT = 1.6,
        HOLD = 0.7,
        WIND = 0.6,
        GAPE = -0.12,
        SHUT = 0.42,
        BREATH = 0.04,
        SNAP_EASE = 3.5,
        OPEN_EASE = 2.5,
        HOOK_CHOMP = 8,
        HOOK_SHAKE = 0.25,
        HOOK_SHAKE_RATE = 11,
        LG_EVERY = { 9, 14 },
        LG_T = 2.6,
        LG_MIN_SP = 0.3,
        LG_BITE = 1.01,
        LG_ROLL = 6.283185307179586,
        LG_DX = 0.02,
        LG_PITCH = 0.15,
        LG_COIL = 0.15,
        LG_GAPE = -0.2,
        LG_SHUD = 0,
        LG_SHUD_HZ = 17,
        LG_PUSH = 0.25,
        lungeCurves = function(p16) -- lungeCurves | line: 115
            local v6 = math.sin(3.141592653589793 * (if p16 < 0 then 0 elseif p16 > 1 then 1 else p16))
            local v8 = 0.5 - math.cos(3.141592653589793 * (if p16 < 0 then 0 elseif p16 > 1 then 1 else p16)) * 0.5
            local v9 = v6 * v6
            local v10 = if v6 < 0 then 0 elseif v6 > 1 then 1 else v6

            return v6, v8, v9, v6, v10 * v10 * (3 - 2 * v10), 0, v6
        end,
        rateOf = function(_, p18, p19) -- rateOf | line: 122
            -- upvalues: p1 (copy)
            local WraithSwim = p1.WraithSwim

            return WraithSwim.CRUISE0 + WraithSwim.CRUISE1 * math.min(1, p18 / math.max(p19, 0.001) / WraithSwim.SP_BL)
        end,
        rot = function(p20, p21) -- rot | line: 127
            local Magnitude = p21.Magnitude

            if Magnitude < 1E-06 then
                p20.bone.Transform = CFrame.identity
            else
                p20.bone.Transform = CFrame.fromAxisAngle((p20.ln * p21.X + p20.lu * p21.Y + p20.lr * p21.Z) / Magnitude, Magnitude)
            end
        end,
        flag = function(p22, p23, p24, p25) -- flag | line: 136
            -- upvalues: p1 (copy)
            return p22.a1 * (p24 * math.sin(p23) + p25) + p22.a2 * (p24 * p1.WraithSwim.FL_B * math.sin(2 * p23 + 1.3))
        end,
        bell = function(p26, p27, p28, p29, p30) -- bell | line: 140
            -- upvalues: p1 (copy)
            local WraithSwim = p1.WraithSwim
            local v15 = WraithSwim.B_SW_RATE * p26.ft + p29
            local v16 = WraithSwim.B_SW * (WraithSwim.FL_E0 + WraithSwim.FL_E1 * p26.sp)

            return (p27.d:Cross(p28) + p27.a1 * (v16 * math.sin(v15)) + p27.a2 * (0.6 * v16 * math.cos(v15))) * p30
        end,
        register = function(p31) -- register | line: 146
            -- upvalues: p1 (copy)
            local WraithSwim = p1.WraithSwim
            local MeshPart = p31:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            for _, v17 in ipairs(WraithSwim.BODY) do
                if not t2[v17] then
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
            local t3 = {}

            for v18, v19 in pairs(t2) do
                local v20 = CFrame:ToObjectSpace(v19.WorldCFrame)
                local t4 = {
                    bone = v19,
                    ln = v20:VectorToObjectSpace(Unit),
                    lu = v20:VectorToObjectSpace(Unit2),
                    lr = v20:VectorToObjectSpace(Unit3)
                }
                local v21 = WraithSwim.DIRS[v18]

                if v21 then
                    local v22 = Vector3.new(-1, -0, -0) - v21 * v21:Dot((Vector3.new(-1, -0, -0)))

                    if v22.Magnitude < 0.35 then
                        v22 = Vector3.new(0, 1, 0) - v21 * v21:Dot((Vector3.new(0, 1, 0)))
                    end

                    local Unit = v22.Unit

                    t4.d = v21
                    t4.a1 = Unit
                    t4.a2 = v21:Cross(t4.a1).Unit
                end

                t3[v18] = t4
            end

            local Size = MeshPart.Size

            local function list(p32) -- line: 177
                -- upvalues: t3 (copy)
                local t5 = {}

                for v23, v24 in ipairs(p32) do
                    t5[v23] = t3[v24] or false
                end

                return t5
            end

            local t6 = {
                model = p31,
                mesh = MeshPart,
                nose = Unit,
                B = t3
            }
            local BODY = WraithSwim.BODY
            local t7 = {}

            for v25, v26 in ipairs(BODY) do
                t7[v25] = t3[v26] or false
            end

            t6.body = t7

            local t8 = {
                "HatA_1",
                "HatA_2",
                "HatA_3"
            }
            local t9 = {}

            for v27, v28 in ipairs(t8) do
                t9[v27] = t3[v28] or false
            end

            t6.hornA = t9

            local t10 = {
                "HatB_1",
                "HatB_2",
                "HatB_3"
            }
            local t11 = {}

            for v29, v30 in ipairs(t10) do
                t11[v29] = t3[v30] or false
            end

            t6.hornB = t11

            local t12 = {
                "Dorsal_1",
                "Dorsal_2"
            }
            local t13 = {}

            for v31, v32 in ipairs(t12) do
                t13[v31] = t3[v32] or false
            end

            t6.dorsal = t13

            local t14 = {
                "Spike_1",
                "Spike_2",
                "Spike_3"
            }
            local t15 = {}

            for v33, v34 in ipairs(t14) do
                t15[v33] = t3[v34] or false
            end

            t6.spikes = t15

            local t16 = {
                "LobeU",
                "LobeUTip"
            }
            local t17 = {}

            for v35, v36 in ipairs(t16) do
                t17[v35] = t3[v36] or false
            end

            t6.lobeU = t17

            local t18 = {
                "LobeL",
                "LobeLTip"
            }
            local t19 = {}

            for v37, v38 in ipairs(t18) do
                t19[v37] = t3[v38] or false
            end

            t6.lobeL = t19
            t6.length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            t6.w = 0
            t6.v = 0
            t6.phase = math.random() * 6.283185307179586
            t6.ft = math.random() * 6.283185307179586
            t6.t = 0
            t6.sp = 0.5
            t6.arc = 0
            t6.acc = 0
            t6.prevV = nil
            t6.hsA = Vector3.new(0, 0, 0)
            t6.hvA = Vector3.new(0, 0, 0)
            t6.hsB = Vector3.new(0, 0, 0)
            t6.hvB = Vector3.new(0, 0, 0)
            t6.bsA = Vector3.new(0, 0, 0)
            t6.bvA = Vector3.new(0, 0, 0)
            t6.bsB = Vector3.new(0, 0, 0)
            t6.bvB = Vector3.new(0, 0, 0)
            t6.bsJ = Vector3.new(0, 0, 0)
            t6.bvJ = Vector3.new(0, 0, 0)
            t6.bsL = Vector3.new(0, 0, 0)
            t6.bvL = Vector3.new(0, 0, 0)
            t6.bsR = Vector3.new(0, 0, 0)
            t6.bvR = Vector3.new(0, 0, 0)
            t6.bsD = Vector3.new(0, 0, 0)
            t6.bvD = Vector3.new(0, 0, 0)
            t6.bsU = Vector3.new(0, 0, 0)
            t6.bvU = Vector3.new(0, 0, 0)
            t6.bsW = Vector3.new(0, 0, 0)
            t6.bvW = Vector3.new(0, 0, 0)
            t6.psL = Vector3.new(0, 0, 0)
            t6.pvL = Vector3.new(0, 0, 0)
            t6.psR = Vector3.new(0, 0, 0)
            t6.pvR = Vector3.new(0, 0, 0)
            t6.dz = 0
            t6.dzv = 0
            t6.lgT = nil
            t6.lgDir = 1
            t6.lgNext = WraithSwim.LG_EVERY[1] * (0.5 + math.random())
            t6.lgU = 1
            t6.roll = 0
            t6.rollRate = 0
            t6.since = 99
            t6.chomps = 1
            t6.chNext = WraithSwim.CH_EVERY[1] * math.random()
            t6.jaw = 0
            t6.jawT = 0
            t6.a0 = 0
            t6.dx = 0
            t6.pitch = 0
            t6.coil = 0
            t6.shud = 0

            return t6
        end,
        update = function(p33, p34, _) -- update | line: 199
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local WraithSwim = p1.WraithSwim
            local model = p33.model
            local v41 = fightHooked(model)

            p1.SharkSwim.readTurn(p33, p34)

            local v, sp, length = p33.v, p33.w, p33.length
            local StrokeAt = attr(model, "StrokeAt")
            local v42, v43, v44, v45, B_K

            if v41 then
                p33.locked = nil
                p33.phase += p34 * WraithSwim.HOOK_RATE
            elseif StrokeAt then
                v43 = attr(model, "StrokeRate") or 0
                v42 = (attr(model, "StrokePhase") or 0) + v43 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p33.locked then
                    p33.phase += p34 * v43
                    v44 = p33.phase
                    v45 = (v42 - p33.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                    B_K = p34 * WraithSwim.LOCK
                    p33.phase = v44 + v45 * math.min(1, B_K)
                else
                    p33.phase = v42
                    p33.locked = true
                end
            else
                p33.locked = nil
                p33.phase += p34 * WraithSwim.rateOf(attr(model, "StrokeHz"), v, length)
            end

            p33.t += p34
            StrokeAt = v / math.max(length, 0.001)

            local roll = if v41 then WraithSwim.SP_HOOK else nil

            if not v41 or not roll then
                roll = StrokeAt / WraithSwim.SP_BL
                v42 = WraithSwim.SP_MAX

                if roll < 0 then
                    roll = 0
                elseif v42 < roll and v42 then
                    roll = v42
                end
            end

            p33.sp = p33.sp + (roll - p33.sp) * math.min(1, p34 * WraithSwim.SP_EASE)
            v43 = WraithSwim.BEND * length * sp / math.max(v, 5)
            v42 = -WraithSwim.BEND_MAX
            v44 = WraithSwim.BEND_MAX

            local v46 = if v43 < v42 and v42 then v42 elseif v44 < v43 and v44 then v44 else v43

            v43 = p33.arc
            v44 = v46 - p33.arc

            local DIRS = p34 * WraithSwim.ARC_EASE

            p33.arc = v43 + v44 * math.min(1, DIRS)

            if p34 > 1E-04 and p33.prevV then
                v46 = (v - p33.prevV) / p34
                v43 = p33.acc
                v44 = v46 - p33.acc
                DIRS = p34 / WraithSwim.ACC_TAU
                p33.acc = v43 + v44 * math.min(1, DIRS)
            end

            p33.prevV = v
            sp = p33.sp
            v43 = math.min(sp, 1)
            p33.ft += p34 * (WraithSwim.FL_RATE0 + WraithSwim.FL_RATE1 * sp)
            roll = p33.roll

            if not p33.lgT then
                p33.lgNext -= p34

                if p33.lgNext <= 0 and not v41 and WraithSwim.LG_MIN_SP < sp then
                    p33.lgT = 0
                    p33.lgDir = -p33.lgDir
                    p33.lgNext = WraithSwim.LG_EVERY[1] + math.random() * (WraithSwim.LG_EVERY[2] - WraithSwim.LG_EVERY[1])
                end
            end

            p33.dx = 0
            p33.roll = 0
            p33.pitch = 0
            p33.coil = 0
            p33.shud = 0

            local v47, v48, B_C, B_MAX, B_HANG, S_MAX, v49

            if p33.lgT then
                p33.lgT += p34
                v44 = p33.lgT / WraithSwim.LG_T

                if v44 >= 1 or v41 then
                    v47 = 0
                    v48 = 0
                    p33.lgT = nil
                else
                    B_C, B_MAX, B_HANG, S_MAX, v47, v49, v48 = WraithSwim.lungeCurves(v44)
                    B_C = WraithSwim.LG_DX * B_C
                    B_MAX = p33.lgDir * WraithSwim.LG_ROLL * B_MAX
                    p33.dx = B_C
                    p33.roll = B_MAX
                    B_C = WraithSwim.LG_PITCH * B_HANG
                    B_MAX = WraithSwim.LG_COIL * S_MAX
                    B_HANG = WraithSwim.LG_SHUD * v49
                    p33.pitch = B_C
                    p33.coil = B_MAX
                    p33.shud = B_HANG
                    p33.lgU = v44
                end
            else
                v47 = 0
                v48 = 0
            end

            p33.rollRate = (p33.roll - roll) / math.max(p34, 1E-04)
            roll = p33.since < p33.chomps * WraithSwim.CT or p33.lgT ~= nil

            if not v41 then
                p33.chNext -= p34

                if p33.chNext <= 0 and not roll then
                    p33.since = -WraithSwim.WIND
                    v45 = math.random() * WraithSwim.CH_MAX
                    p33.chomps = math.floor(v45) + 1
                    p33.chNext = WraithSwim.CH_EVERY[1] + math.random() * (WraithSwim.CH_EVERY[2] - WraithSwim.CH_EVERY[1])
                end
            end

            p33.since += p34

            local v50

            if v41 then
                v50 = WraithSwim.SHUT
                B_K = p33.t * WraithSwim.HOOK_CHOMP
                v50 *= math.sin(B_K) * 0.5 + 0.5
            elseif p33.lgT then
                v50 = if p33.lgU < WraithSwim.LG_BITE then WraithSwim.LG_GAPE * v47 else p33.lgU < WraithSwim.LG_BITE + 0.2 and WraithSwim.SHUT or 0
            elseif p33.since < 0 then
                v50 = WraithSwim.GAPE
            elseif p33.since < p33.chomps * WraithSwim.CT then
                v50 = p33.since % WraithSwim.CT < WraithSwim.HOLD and WraithSwim.SHUT or 0
            else
                v50 = WraithSwim.BREATH
                B_K = 1.1 * p33.t
                v50 *= math.sin(B_K) * 0.5 + 0.5
            end

            local v51 = p33.jawT < v50 and WraithSwim.SNAP_EASE or WraithSwim.OPEN_EASE

            p33.jawT = p33.jawT + (v50 - p33.jawT) * math.min(1, p34 * v51)
            p33.jaw = p33.jaw + (p33.jawT - p33.jaw) * math.min(1, p34 * v51)

            local HOOK_AMP = v41 and WraithSwim.HOOK_AMP or WraithSwim.AMP0 + (WraithSwim.AMP1 - WraithSwim.AMP0) * v43

            v51 = p33.phase + WraithSwim.WARP * math.sin(2 * p33.phase)
            v45 = HOOK_AMP * 0.05 * math.sin(v51)

            local ARMS = WraithSwim.HEAD_SNAP * v43

            B_C = v51 - WraithSwim.WAVE_K
            p33.a0 = v45 - ARMS * math.sin(B_C)
            v50 = math.min(p34, 0.03333333333333333)
            v45 = p33.acc / math.max(length, 0.001)
            DIRS = -WraithSwim.ACC_MAX
            ARMS = WraithSwim.ACC_MAX

            local v52 = if v45 < DIRS and DIRS then DIRS elseif ARMS < v45 and ARMS then ARMS else v45

            v45 = Vector3.new(0, 0, 1) * (WraithSwim.TURN_G * p33.arc * v43) + Vector3.new(-1, -0, -0) * (WraithSwim.SURGE_G * v52 + WraithSwim.KICK_G * v43 * math.cos(2 * v51) + WraithSwim.LG_PUSH * v48) + Vector3.new(0, 1, 0) * (WraithSwim.KICK_UP * v43 * math.sin(2 * v51))

            if v41 then
                B_C = WraithSwim.HOOK_SHAKE
                B_HANG = p33.t * WraithSwim.HOOK_SHAKE_RATE
                v45 += Vector3.new(0, 0, 1) * (B_C * math.sin(B_HANG))
            end

            DIRS = WraithSwim.DIRS
            ARMS = WraithSwim.ARMS
            B_K = WraithSwim.B_K
            B_C = WraithSwim.B_C
            B_MAX = WraithSwim.B_MAX
            B_HANG = WraithSwim.B_HANG
            S_MAX = WraithSwim.S_MAX
            v52 = ARMS.HatA
            v47 = v45 + Vector3.new(-1, -0, -0) * (WraithSwim.STREAM * sp) + (Vector3.new(0, 1, 0)):Cross(DIRS.HatA_3) * (-WraithSwim.HEAD_LAG * p33.a0) + (Vector3.new(1, 0, 0)):Cross(v52) * (-WraithSwim.ROLL_LAG * p33.rollRate / v52.Magnitude)
            v49 = v47.Magnitude
            v47 = S_MAX < v49 and v47 * (S_MAX / v49) or v47

            local hsA = p33.hsA
            local rot = p33.hvA
            local bell, H_C = WraithSwim.H_K, WraithSwim.H_C

            rot += ((v47 - hsA) * bell - rot * H_C) * v50

            local v53 = hsA + rot * v50
            local Magnitude = v53.Magnitude

            v53 = S_MAX < Magnitude and v53 * (S_MAX / Magnitude) or v53
            p33.hsA = v53
            p33.hvA = rot
            hsA = p33.bsA
            rot = p33.bvA
            bell = p33.hsA * -B_HANG + v45
            H_C = bell.Magnitude
            bell = B_MAX < H_C and bell * (B_MAX / H_C) or bell
            rot += ((bell - hsA) * B_K - rot * B_C) * v50
            bell = hsA + rot * v50
            H_C = bell.Magnitude

            local v54 = B_MAX < H_C
            local v55 = if v54 then bell * (B_MAX / H_C) else nil

            if v54 and v55 then
                bell = v55
            end

            p33.bsA = bell
            p33.bvA = rot
            v52 = ARMS.HatB
            v55 = v45 + Vector3.new(-1, -0, -0) * (WraithSwim.STREAM * sp) + (Vector3.new(0, 1, 0)):Cross(DIRS.HatB_3) * (-WraithSwim.HEAD_LAG * p33.a0) + (Vector3.new(1, 0, 0)):Cross(v52) * (-WraithSwim.ROLL_LAG * p33.rollRate / v52.Magnitude)
            v49 = v55.Magnitude
            v55 = S_MAX < v49 and v55 * (S_MAX / v49) or v55
            hsA = p33.hsB
            rot = p33.hvB
            bell = WraithSwim.H_K
            H_C = WraithSwim.H_C
            rot += ((v55 - hsA) * bell - rot * H_C) * v50
            v53 = hsA + rot * v50
            DIRS = v53.Magnitude
            v53 = S_MAX < DIRS and v53 * (S_MAX / DIRS) or v53
            p33.hsB = v53
            p33.hvB = rot
            hsA = p33.bsB
            rot = p33.bvB
            bell = p33.hsB * -B_HANG + v45
            H_C = bell.Magnitude
            bell = B_MAX < H_C and bell * (B_MAX / H_C) or bell
            rot += ((bell - hsA) * B_K - rot * B_C) * v50
            bell = hsA + rot * v50
            H_C = bell.Magnitude
            bell = B_MAX < H_C and bell * (B_MAX / H_C) or bell
            p33.bsB = bell
            p33.bvB = rot
            hsA = p33.bsJ
            rot = p33.bvJ
            bell = p33.hsB * -B_HANG + v45
            H_C = bell.Magnitude

            local v56 = B_MAX < H_C
            local v57 = if v56 then bell * (B_MAX / H_C) else nil

            if v56 and v57 then
                bell = v57
            end

            rot += ((bell - hsA) * B_K - rot * B_C) * v50
            bell = hsA + rot * v50
            H_C = bell.Magnitude

            local v58 = B_MAX < H_C
            local v59 = if v58 then bell * (B_MAX / H_C) else nil

            if v58 and v59 then
                bell = v59
            end

            p33.bsJ = bell
            p33.bvJ = rot
            v59 = WraithSwim.P_HEAVE * v43 * math.cos(2 * v51)
            v49 = Vector3.new(-1, -0, -0) * (WraithSwim.P_STREAM * sp + 0.5 * WraithSwim.LG_PUSH * v48)
            v52 = ARMS.PecL
            v48 = v49 + Vector3.new(0, 1, 0) * (WraithSwim.P_TURN * p33.arc * v43 + v59) + (Vector3.new(1, 0, 0)):Cross(v52) * (-WraithSwim.P_ROLL * p33.rollRate / v52.Magnitude)
            v42 = v48.Magnitude
            v48 = S_MAX < v42 and v48 * (S_MAX / v42) or v48
            v57 = p33.psL
            bell = p33.pvL
            v53 = WraithSwim.P_K
            Magnitude = WraithSwim.P_C
            bell += ((v48 - v57) * v53 - bell * Magnitude) * v50

            local v60 = v57 + bell * v50
            local Magnitude2 = v60.Magnitude

            v60 = S_MAX < Magnitude2 and v60 * (S_MAX / Magnitude2) or v60
            p33.psL = v60
            p33.pvL = bell
            v57 = p33.bsL
            bell = p33.bvL
            v53 = p33.psL * -B_HANG + v45
            Magnitude = v53.Magnitude
            v53 = B_MAX < Magnitude and v53 * (B_MAX / Magnitude) or v53
            bell += ((v53 - v57) * B_K - bell * B_C) * v50
            v53 = v57 + bell * v50
            Magnitude = v53.Magnitude

            local v61 = B_MAX < Magnitude
            local v62 = if v61 then v53 * (B_MAX / Magnitude) else nil

            if v61 and v62 then
                v53 = v62
            end

            p33.bsL = v53
            p33.bvL = bell
            v52 = ARMS.PecR
            v62 = v49 + Vector3.new(0, 1, 0) * (-WraithSwim.P_TURN * p33.arc * v43 + v59) + (Vector3.new(1, 0, 0)):Cross(v52) * (-WraithSwim.P_ROLL * p33.rollRate / v52.Magnitude)
            ARMS = v62.Magnitude

            local v63 = S_MAX < ARMS
            local v64 = if v63 then v62 * (S_MAX / ARMS) else nil

            if v63 and v64 then
                v62 = v64
            end

            v57 = p33.psR
            bell = p33.pvR
            v53 = WraithSwim.P_K
            Magnitude = WraithSwim.P_C
            bell += ((v62 - v57) * v53 - bell * Magnitude) * v50
            v60 = v57 + bell * v50
            v49 = v60.Magnitude
            v60 = S_MAX < v49 and v60 * (S_MAX / v49) or v60
            p33.psR = v60
            p33.pvR = bell
            v57 = p33.bsR
            bell = p33.bvR
            v53 = p33.psR * -B_HANG + v45
            v59 = v53.Magnitude
            v53 = B_MAX < v59 and v53 * (B_MAX / v59) or v53
            bell += ((v53 - v57) * B_K - bell * B_C) * v50
            v53 = v57 + bell * v50
            S_MAX = v53.Magnitude
            v53 = B_MAX < S_MAX and v53 * (B_MAX / S_MAX) or v53
            p33.bsR = v53
            p33.bvR = bell
            B_HANG = WraithSwim.D_A * v43 * math.sin(v51 - WraithSwim.D_PH) + WraithSwim.D_TURN * p33.arc * v43
            p33.dzv += (WraithSwim.D_K * (B_HANG - p33.dz) - WraithSwim.D_C * p33.dzv) * v50
            p33.dz += p33.dzv * v50
            v57 = p33.bsD
            bell = p33.bvD
            v53 = Vector3.new(0, 0, 1) * (-0.5 * p33.dz) + v45
            B_HANG = v53.Magnitude

            local v65 = B_MAX < B_HANG
            local v66 = if v65 then v53 * (B_MAX / B_HANG) else nil

            if v65 and v66 then
                v53 = v66
            end

            bell += ((v53 - v57) * B_K - bell * B_C) * v50
            v53 = v57 + bell * v50
            v52 = v53.Magnitude
            v53 = B_MAX < v52 and v53 * (B_MAX / v52) or v53
            p33.bsD = v53
            p33.bvD = bell
            v64 = Vector3.new(0, 0, 1) * (-0.5 * WraithSwim.LOBE_A * HOOK_AMP * math.sin(v51 - WraithSwim.WAVE_K - WraithSwim.LOBE_LAG))
            v57 = p33.bsU
            bell = p33.bvU
            v53 = v64 + v45
            Magnitude = v53.Magnitude
            v53 = B_MAX < Magnitude and v53 * (B_MAX / Magnitude) or v53
            bell += ((v53 - v57) * B_K - bell * B_C) * v50
            v53 = v57 + bell * v50
            Magnitude = v53.Magnitude
            v53 = B_MAX < Magnitude and v53 * (B_MAX / Magnitude) or v53
            p33.bsU = v53
            p33.bvU = bell
            v57 = p33.bsW
            bell = p33.bvW
            v53 = v64 + v45
            Magnitude = v53.Magnitude

            local v67 = B_MAX < Magnitude
            local v68 = if v67 then v53 * (B_MAX / Magnitude) else nil

            if v67 and v68 then
                v53 = v68
            end

            bell += ((v53 - v57) * B_K - bell * B_C) * v50
            v53 = v57 + bell * v50
            Magnitude = v53.Magnitude

            local v69 = B_MAX < Magnitude
            local v70 = if v69 then v53 * (B_MAX / Magnitude) else nil

            if v69 and v70 then
                v53 = v70
            end

            p33.bsW = v53
            p33.bvW = bell
            v70 = p33.B
            rot = WraithSwim.rot
            v57 = WraithSwim.flag
            bell = WraithSwim.bell
            B_MAX = -p33.arc / 6
            B_C = p33.shud * math.sin(6.283185307179586 * WraithSwim.LG_SHUD_HZ * p33.t)

            local v71, lr, v72, v73, fromAxisAngle, F_ROLL, v74, fromAxisAngle2

            for i = 1, 7 do
                B_K = p33.body[i]
                v45 = (i - 1) / 6

                if i == 1 then
                    local v75 = CFrame.fromAxisAngle(B_K.lu, p33.a0)

                    Magnitude2 = p33.pitch

                    if math.abs(Magnitude2) > 1E-06 then
                        v75 = CFrame.fromAxisAngle(B_K.lr, p33.pitch) * v75
                    end

                    roll = p33.roll + 0.3 * B_C
                    v64 = if math.abs(roll) > 1E-06 then CFrame.fromAxisAngle(B_K.ln, roll) * v75 else v75
                    Magnitude2 = p33.dx

                    if math.abs(Magnitude2) > 1E-06 then
                        v64 = CFrame.new(B_K.ln * (p33.dx * length)) * v64
                    end

                    roll = 6.283185307179586 * p33.t / WraithSwim.F_T1
                    fromAxisAngle2 = CFrame.new
                    v71 = B_K.lu * (WraithSwim.F_BOB * length * math.sin(roll))
                    lr = B_K.lr
                    v72 = WraithSwim.F_SWAY * length
                    v73 = 2 * roll
                    fromAxisAngle2 = fromAxisAngle2(v71 + lr * (v72 * math.sin(v73)))
                    fromAxisAngle = CFrame.fromAxisAngle
                    v71 = B_K.lr
                    lr = WraithSwim.F_PITCH
                    v72 = roll - 0.9
                    Magnitude2 = fromAxisAngle2 * fromAxisAngle(v71, lr * math.sin(v72))
                    fromAxisAngle2 = CFrame.fromAxisAngle
                    fromAxisAngle = B_K.ln
                    F_ROLL = WraithSwim.F_ROLL
                    v74 = 6.283185307179586 * p33.t / WraithSwim.F_T2
                    v60 = Magnitude2 * fromAxisAngle2(fromAxisAngle, F_ROLL * math.sin(v74))
                    B_K.bone.Transform = v60 * v64
                else
                    Magnitude2 = HOOK_AMP * (0.05 + 1.2 * v45 ^ WraithSwim.STIFF)
                    fromAxisAngle = v51 - v45 * WraithSwim.WAVE_K
                    v60 = Magnitude2 * math.sin(fromAxisAngle)
                    Magnitude2 = B_K.bone
                    fromAxisAngle2 = CFrame.fromAxisAngle
                    fromAxisAngle = B_K.lu
                    F_ROLL = v60 + B_MAX
                    v74 = p33.coil
                    Magnitude2.Transform = fromAxisAngle2(fromAxisAngle, F_ROLL + v74 * math.sin(5.654866776461628 * v45 + 0.4))
                end
            end

            if v70.Jaw then
                v70.Jaw.bone.Transform = CFrame.fromAxisAngle(v70.Jaw.lr, p33.jaw)
            end

            B_MAX = WraithSwim.FL_E0 + WraithSwim.FL_E1 * sp
            v68 = WraithSwim.FRAC
            v53 = WraithSwim.HF_A
            length = p33.hsA

            for i = 1, 3 do
                fromAxisAngle2 = p33.hornA[i]

                if fromAxisAngle2 then
                    rot(fromAxisAngle2, fromAxisAngle2.d:Cross(length) * v68[i] + v57(fromAxisAngle2, p33.ft - WraithSwim.FL_K * (i - 1), v53[i] * B_MAX, B_C))
                end
            end

            if v70.HatA_Bell then
                rot(v70.HatA_Bell, bell(p33, v70.HatA_Bell, p33.bsA, 0.7, 1))
            end

            length = p33.hsB

            for i = 1, 3 do
                fromAxisAngle2 = p33.hornB[i]

                if fromAxisAngle2 then
                    rot(fromAxisAngle2, fromAxisAngle2.d:Cross(length) * v68[i] + v57(fromAxisAngle2, p33.ft - WraithSwim.FL_K * (i - 1) + 2.1, v53[i] * B_MAX, B_C))
                end
            end

            if v70.HatB_Bell then
                rot(v70.HatB_Bell, bell(p33, v70.HatB_Bell, p33.bsB, 2.8, 1))
            end

            if v70.HatB_Jingle then
                rot(v70.HatB_Jingle, bell(p33, v70.HatB_Jingle, p33.bsJ, 4, WraithSwim.JINGLE_G))
            end

            v53 = Vector3.new(1, 0, 0) * (WraithSwim.P_BIAS + WraithSwim.P_FLAP * math.sin(v51))
            v68 = Vector3.new(0, 0, 1) * (WraithSwim.P_SWEEP * math.cos(v51))
            Magnitude2 = WraithSwim.P_TFLAP
            fromAxisAngle = v51 - WraithSwim.P_LAG
            length = Vector3.new(1, 0, 0) * (Magnitude2 * math.sin(fromAxisAngle))
            Magnitude = p33.psL

            if v70.Fin_L then
                rot(v70.Fin_L, v70.Fin_L.d:Cross(Magnitude) * WraithSwim.P_FRAC[1] + v53 + v68 + Vector3.new(1, 0, 0) * B_C)
            end

            if v70.FinTip_L then
                rot(v70.FinTip_L, v70.FinTip_L.d:Cross(Magnitude) * WraithSwim.P_FRAC[2] + length + Vector3.new(1, 0, 0) * B_C)
            end

            if v70.PecBell_L then
                rot(v70.PecBell_L, bell(p33, v70.PecBell_L, p33.bsL, 2.5, 1))
            end

            Magnitude = p33.psR

            if v70.Fin_R then
                rot(v70.Fin_R, v70.Fin_R.d:Cross(Magnitude) * WraithSwim.P_FRAC[1] - v53 + v68 - Vector3.new(1, 0, 0) * B_C)
            end

            if v70.FinTip_R then
                rot(v70.FinTip_R, v70.FinTip_R.d:Cross(Magnitude) * WraithSwim.P_FRAC[2] - length - Vector3.new(1, 0, 0) * B_C)
            end

            if v70.PecBell_R then
                rot(v70.PecBell_R, bell(p33, v70.PecBell_R, p33.bsR, 0.5, 1))
            end

            Magnitude = Vector3.new(0, 0, 1) * p33.dz + Vector3.new(-1, -0, -0) * (WraithSwim.D_STREAM * sp)

            for i = 1, 2 do
                v53 = p33.dorsal[i]

                if v53 then
                    rot(v53, v53.d:Cross(Magnitude) * WraithSwim.D_FRAC[i] + v57(v53, p33.ft - WraithSwim.FL_K * (i - 1) + 1, WraithSwim.DF_A[i] * B_MAX, B_C))
                end
            end

            if v70.Dorsal_Bell then
                rot(v70.Dorsal_Bell, bell(p33, v70.Dorsal_Bell, p33.bsD, 2.6, 1))
            end

            for i = 1, 3 do
                Magnitude = p33.spikes[i]

                if Magnitude then
                    fromAxisAngle = WraithSwim.SPK_A * (v43 * 0.4 + 0.6)
                    F_ROLL = v51 - WraithSwim.SPK_PH - WraithSwim.SPK_LAG * (i - 1)
                    v68 = fromAxisAngle * math.sin(F_ROLL)
                    v74 = Magnitude.a1
                    lr = v74 * (v68 + WraithSwim.SPK_RATTLE * math.sin(2 * p33.ft + (i - 1) * 1.7) + B_C)
                    v72 = Magnitude.a2
                    v73 = 0.5 * WraithSwim.SPK_RATTLE
                    rot(Magnitude, lr + v72 * (v73 * math.cos(p33.ft + (i - 1))))
                end
            end

            length = Vector3.new(0, 0, 1) * (WraithSwim.LOBE_A * HOOK_AMP * math.sin(v51 - WraithSwim.WAVE_K - WraithSwim.LOBE_LAG))

            for i = 1, 2 do
                HOOK_AMP = p33.lobeU[i]

                if HOOK_AMP then
                    rot(HOOK_AMP, HOOK_AMP.d:Cross(length) * ((i - 1) * 0.5 + 0.5) + v57(HOOK_AMP, p33.ft - WraithSwim.FL_K * (i - 1) + 0.4, WraithSwim.LF_A[i] * B_MAX, B_C))
                end

                HOOK_AMP = p33.lobeL[i]

                if HOOK_AMP then
                    rot(HOOK_AMP, HOOK_AMP.d:Cross(length) * ((i - 1) * 0.5 + 0.5) + v57(HOOK_AMP, p33.ft - WraithSwim.FL_K * (i - 1) + 2, WraithSwim.LF_A[i] * B_MAX, B_C))
                end
            end

            if v70.LobeU_Bell then
                rot(v70.LobeU_Bell, bell(p33, v70.LobeU_Bell, p33.bsU, 1.5, 1))
            end

            if v70.LobeL_Bell then
                rot(v70.LobeL_Bell, bell(p33, v70.LobeL_Bell, p33.bsW, 3.1, 1))
            end
        end
    }
end
