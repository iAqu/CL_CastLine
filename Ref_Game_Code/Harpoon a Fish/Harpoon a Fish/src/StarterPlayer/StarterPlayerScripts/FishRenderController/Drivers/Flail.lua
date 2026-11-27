-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.Flail = {
        BODY_SWING = 0.16,
        ROOT_SWING = 0.3,
        SWING_MIN = 0.3,
        swing = function(p3, p4, p5) -- swing | line: 64
            -- upvalues: p1 (copy)
            local Flail = p1.Flail

            p5 = p5 or 1

            local v2 = Flail.SWING_MIN + (1 - Flail.SWING_MIN) * p4

            return p5 * Flail.BODY_SWING * v2 * math.sin(p3), -p5 * Flail.ROOT_SWING * v2 * math.sin(p3 - 1)
        end,
        WHIP_LAG = 0.7,
        HOOK_X = 1.3,
        swim_hz = function(p6, p7, p8, p9) -- swim_hz | line: 72
            -- upvalues: p1 (copy)
            local Flail = p1.Flail

            if p7 then
                return (math.min(Flail.TAIL_HOOK_HZ, p9 * Flail.HOOK_X))
            end

            return (math.clamp(p6 / Flail.TAIL_STRIDE, p8, p9))
        end,
        whip = function(p10, p11, p12, p13) -- whip | line: 78
            -- upvalues: p1 (copy)
            local Flail = p1.Flail
            local v8 = Flail.SWING_MIN + (1 - Flail.SWING_MIN) * p12
            local v9 = p10 * (p10 - 1) / 2
            local t2 = {
                0
            }

            for i = 1, p10 - 1 do
                local v10 = -p13 * v8 * (i / v9)
                local v11 = p11 - 1 - Flail.WHIP_LAG * i

                t2[i + 1] = v10 * math.sin(v11)
            end

            return t2
        end,
        STREAM = 0.75,
        V_FULL = 1.2,
        STREAM_CAP = 0.7,
        W_IDLE = 0.12,
        W_FLAIL = 0.3,
        OM_IDLE = 1.5,
        OM_FLAIL = 6,
        LAG = 0.9,
        TURN = 0.3,
        SPLAY = 0.4,
        DROOP = 0.35,
        W_DAZED = 0.05,
        OM_DAZED = 0.8,
        W_HOOK = 0.35,
        OM_HOOK = 9,
        TAIL_A = 0.35,
        TAIL_STRIDE = 0.8,
        TAIL_MIN_HZ = 0.5,
        TAIL_MAX_HZ = 4,
        TAIL_HOOK_HZ = 5,
        ROLL = 0.04,
        ROLL_RATE = 0.7,
        DAZE_ROLL = 0.25,
        DAZE_PITCH = 0.1,
        DAZE_RATE = 1.3,
        GOLD = 2.39996,
        LEN_REF = 0.25,
        TURN_REF = 0.6,
        DAZE_TAU = 0.3,
        DISPLAY_TAU = 0.35,
        JET_IDLE = 2.6,
        JET_FULL = 1.3,
        JET_HOOK = 0.9,
        JET_RISE = 0.15,
        JET_DECAY = 3,
        JET_PINCH = 0.18,
        SWIPE_EVERY = { 4, 7 },
        SWIPE_HOOK = { 1.2, 2.2 },
        SWIPE_N = 3,
        SWIPE_T = 0.24,
        SWIPE_A = 0.3,
        SWIPE_EASE = 0.12,
        SWIPE_GAPE = 0.3,
        SWAY_A = 0.05,
        SWAY_HZ = 0.45,
        JAW_GAPE = 0.2,
        JAW_EVERY = { 1.6, 3.2 },
        JAW_SNAP = 0.12,
        JAW_HOOK = 2.5,
        smooth = function(p14) -- smooth | line: 98
            local v12 = math.clamp(p14, 0, 1)

            return v12 * v12 * (3 - 2 * v12)
        end,
        writhe_om = function(p15, p16, p17) -- writhe_om | line: 103
            -- upvalues: p1 (copy)
            local Flail = p1.Flail

            if p17 then
                return Flail.OM_HOOK
            end

            local v13 = Flail.OM_IDLE + (Flail.OM_FLAIL - Flail.OM_IDLE) * p15

            return v13 + (Flail.OM_DAZED - v13) * p16
        end,
        jet_period = function(p18, p19) -- jet_period | line: 109
            -- upvalues: p1 (copy)
            local Flail = p1.Flail

            return p19 and Flail.JET_HOOK or Flail.JET_IDLE + (Flail.JET_FULL - Flail.JET_IDLE) * p18
        end,
        jet = function(p20) -- jet | line: 116
            -- upvalues: p1 (copy)
            local Flail = p1.Flail
            local v15 = math.exp(-(1 - Flail.JET_RISE) * Flail.JET_DECAY)
            local v16 = p20 < Flail.JET_RISE
            local v17 = if v16 then Flail.smooth(p20 / Flail.JET_RISE) else nil

            if not v16 or not v17 then
                v17 = (math.exp(-(p20 - Flail.JET_RISE) * Flail.JET_DECAY) - v15) / (1 - v15)
            end

            return -Flail.JET_PINCH * v17
        end,
        spread_axis = function(p21, p22) -- spread_axis | line: 123
            local v19 = p21:Cross(p22)

            return v19.Magnitude > 1E-04 and v19.Unit or nil
        end,
        swipe = function(p23, p24) -- swipe | line: 128
            -- upvalues: p1 (copy)
            local Flail = p1.Flail
            local v20 = Flail.SWIPE_N * Flail.SWIPE_T
            local v21, v22

            if p23 < v20 then
                v21 = Flail.smooth(p23 / Flail.SWIPE_EASE) * Flail.smooth((v20 - p23) / Flail.SWIPE_EASE)
                v22 = Flail.SWIPE_A * math.sin(3.141592653589793 * p23 / Flail.SWIPE_T) * v21
            else
                v21 = 0
                v22 = 0
            end

            return v22 + Flail.SWAY_A * (1 - v21) * math.sin(6.283185307179586 * Flail.SWAY_HZ * p24), v21
        end,
        jaw = function(p25, p26, p27) -- jaw | line: 139
            -- upvalues: p1 (copy)
            local Flail = p1.Flail
            local v26 = p26 - Flail.JAW_SNAP
            local v28 = math.clamp(p25 / v26, 0, 1)
            local v29 = p25 < v26 and Flail.smooth(v28) or 1 - (p25 - v26) / Flail.JAW_SNAP

            return (math.max(Flail.JAW_GAPE * v29, Flail.SWIPE_GAPE * p27))
        end,
        perp = function(p28, p29, p30) -- perp | line: 146
            local v32 = p28:Cross(p29)

            if v32.Magnitude < 0.2 then
                v32 = p28:Cross(p30)
            end

            return v32.Unit
        end,
        arm = function(p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45) -- arm | line: 153
            -- upvalues: p1 (copy)
            local Flail = p1.Flail
            local v33 = #p32
            local v34, v35

            if p41 then
                v34 = Flail.W_HOOK
                v35 = Flail.OM_HOOK
            else
                local v36 = Flail.W_IDLE + (Flail.W_FLAIL - Flail.W_IDLE) * p36
                local v37 = Flail.OM_IDLE + (Flail.OM_FLAIL - Flail.OM_IDLE) * p36

                v34 = v36 + (Flail.W_DAZED - v36) * p40
                v35 = v37 + (Flail.OM_DAZED - v37) * p40
            end

            local v39 = v34 * (math.clamp(p33 / Flail.LEN_REF, 0.2, 1) * p42)
            local t3 = {}

            for i = 1, v33 do
                local v40 = p32[i]
                local v41 = Flail.perp(v40, p35, p34)
                local Unit = v40:Cross(v41).Unit
                local v42 = i * 0.5 / v33 + 0.5
                local v43 = (p44 or v35 * p38) - Flail.LAG * i
                local v44, v45

                if p43 and p43 > 0 then
                    local v46 = 6.283185307179586 * p31 / p43

                    if v46 then
                        v44 = v46
                        v45 = true
                    else
                        v45 = false
                    end
                else
                    v45 = false
                end

                if not v45 then
                    v44 = Flail.GOLD * p31
                end

                local v47 = v43 + v44
                local t4 = {
                    {
                        v41,
                        v39 * v42 * math.sin(v47)
                    },
                    {
                        Unit,
                        0.6 * v39 * v42 * math.cos(v47)
                    }
                }

                if i == 1 then
                    local v49 = math.clamp(v40:Dot(p34), -1, 1)
                    local v50 = v40:Cross(p34)

                    if v50.Magnitude > 1E-04 then
                        table.insert(t4, 1, {
                            v50.Unit,
                            (Flail.STREAM * p36 * (1 - p40) - Flail.SPLAY * p39) * math.min(math.acos(v49), p45 or Flail.STREAM_CAP) * p42
                        })
                    end

                    table.insert(t4, {
                        p35,
                        -Flail.TURN * p37 * p42
                    })

                    local v55 = v40:Cross(-p35)

                    if v55.Magnitude > 1E-04 and p40 > 0 then
                        table.insert(t4, {
                            v55.Unit,
                            Flail.DROOP * p40 * p42
                        })
                    end
                end

                t3[i] = t4
            end

            return t3
        end,
        tail = function(p46, p47, p48) -- tail | line: 188
            -- upvalues: p1 (copy)
            local Flail = p1.Flail
            local t8 = {}

            for i = 1, p46 do
                t8[i] = p48 * Flail.TAIL_A / p46 * (i / p46) * 2 * math.sin(p47 - i * 1)
            end

            return t8
        end,
        body = function(p49, p50) -- body | line: 194
            -- upvalues: p1 (copy)
            local Flail = p1.Flail

            return Flail.ROLL * math.sin(Flail.ROLL_RATE * p49) + Flail.DAZE_ROLL * p50 * math.sin(Flail.DAZE_RATE * p49), Flail.DAZE_PITCH * p50 * math.sin(0.7 * Flail.DAZE_RATE * p49 + 1)
        end,
        register = function(p51) -- register | line: 199
            -- upvalues: p1 (copy), attr (copy)
            local Flail = p1.Flail
            local v65 = p1.StrokeClock.setup(p51, { "Body" })

            if not v65 then
                return nil
            end

            local mcf = v65.mcf
            local v66 = -v65.nose
            local up, bones = v65.up, v65.bones

            local function head(p52) -- line: 206
                -- upvalues: mcf (copy)
                return mcf:PointToObjectSpace(p52.WorldPosition)
            end

            local t9 = {}

            v65.arms = {}
            v65.tails = t9

            for i = 1, 64 do
                local t10 = {}

                for j = 1, 12 do
                    local v67 = bones["Arm_" .. i .. "_" .. j]

                    if v67 then
                        t10[#t10 + 1] = v67
                    end
                end

                if #t10 > 0 then
                    local t11 = {}
                    local t12 = {}

                    for v68, v69 in ipairs(t10) do
                        t11[v68] = mcf:PointToObjectSpace(v69.WorldPosition)
                    end

                    local n1 = 0

                    for k = 1, #t10 do
                        t12[k] = (if t11[k + 1] then t11[k + 1] - t11[k] elseif k > 1 then t11[k] - t11[k - 1] else v66).Unit

                        if t11[k + 1] then
                            n1 += (t11[k + 1] - t11[k]).Magnitude
                        end
                    end

                    v65.arms[#v65.arms + 1] = {
                        k = i,
                        bones = t10,
                        dirs = t12,
                        share = n1 / v65.length,
                        h0 = t11[1]
                    }
                end
            end

            v65.ring = attr(p51, "FlailRing")
            v65.clk = 0

            if attr(p51, "FlailJet") and #v65.arms > 0 then
                local v71 = Vector3.new(0, 0, 0)

                for _, v72 in ipairs(v65.arms) do
                    v71 += v72.h0 / #v65.arms
                end

                for _, v73 in ipairs(v65.arms) do
                    local v74 = v73.h0 - v71
                    local v75 = v74 - v66 * v74:Dot(v66)

                    if v75.Magnitude > 1E-04 then
                        v73.spread = Flail.spread_axis(v73.dirs[1], v75.Unit)
                    end
                end

                v65.jet = math.random()
            end

            if attr(p51, "SawSwipe") and bones.Head then
                local Head, Jaw = bones.Head, bones.Jaw
                local v76 = up:Cross(-v66)

                v65.head = Head
                v65.jaw = Jaw
                v65.open = v76

                local v77 = Flail.SWIPE_EVERY[1] + math.random() * (Flail.SWIPE_EVERY[2] - Flail.SWIPE_EVERY[1])

                v65.tb = 9
                v65.nextb = v77

                local v78 = math.random() * 2
                local v79 = Flail.JAW_EVERY[1] + math.random() * (Flail.JAW_EVERY[2] - Flail.JAW_EVERY[1])

                v65.jt = v78
                v65.jp = v79
            end

            for i = 1, 12 do
                local v80 = bones["Tail_" .. i]

                if v80 then
                    v65.tails[#v65.tails + 1] = v80
                end
            end

            local v81 = math.random() * 6.28
            local v82 = attr(p51, "WaveAmp") or 1

            v65.back = v66
            v65.beat = v81
            v65.dazed = 0
            v65.disp = 0
            v65.amp = v82

            local SwimHz = attr(p51, "SwimHz")

            if typeof(SwimHz) == "NumberRange" then
                v65.swimHz = SwimHz
            end

            local v83 = attr(p51, "SwingAmp") or 1
            local FlailWhip = attr(p51, "FlailWhip")

            v65.swingAmp = v83
            v65.whip = FlailWhip

            local StreamCap = attr(p51, "StreamCap")
            local v84 = attr(p51, "TailAmp") or 1
            local FlailClock = attr(p51, "FlailClock")

            v65.cap = StreamCap
            v65.tailAmp = v84
            v65.integ = FlailClock

            return v65
        end,
        update = function(p53, p54, _) -- update | line: 259
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local Flail, StrokeClock = p1.Flail, p1.StrokeClock
            local model = p53.model
            local v86 = math.clamp(StrokeClock.turn(p53, p54) / Flail.TURN_REF, -1, 1)
            local v87 = p53.v / math.max(p53.length, 0.001)
            local v89 = math.clamp(v87 / Flail.V_FULL, 0, 1)
            local v90 = fightHooked(model)

            p53.fin += p54
            p53.dazed = p53.dazed + ((if attr(model, "Dazed") then 1 else 0) - p53.dazed) * math.min(1, p54 / Flail.DAZE_TAU)
            p53.disp = p53.disp + ((if attr(model, "Display") then 1 else 0) - p53.disp) * math.min(1, p54 / Flail.DISPLAY_TAU)

            local fin, back, up = p53.fin, p53.back, p53.up
            local v95 = #p53.tails
            local BodySwim = attr(model, "BodySwim")

            if v95 > 0 or BodySwim then
                local TAIL_HOOK_HZ

                if p53.swimHz then
                    TAIL_HOOK_HZ = Flail.swim_hz(v87, v90, p53.swimHz.Min, p53.swimHz.Max)
                elseif v90 then
                    TAIL_HOOK_HZ = Flail.TAIL_HOOK_HZ

                    if not TAIL_HOOK_HZ then
                        TAIL_HOOK_HZ = math.clamp(v87 / Flail.TAIL_STRIDE, Flail.TAIL_MIN_HZ, Flail.TAIL_MAX_HZ)
                    end
                else
                    TAIL_HOOK_HZ = math.clamp(v87 / Flail.TAIL_STRIDE, Flail.TAIL_MIN_HZ, Flail.TAIL_MAX_HZ)
                end

                p53.beat += p54 * 2 * 3.141592653589793 * TAIL_HOOK_HZ
            end

            local v98 = if BodySwim ~= "yaw" or not up then p53.right else up
            local v99, v100

            if BodySwim then
                v99, v100 = Flail.swing(p53.beat, v89, p53.swingAmp)
            else
                v99 = 0
                v100 = 0
            end

            if p53.ring or p53.integ then
                p53.clk += p54 * Flail.writhe_om(v89, p53.dazed, v90)
            end

            local v101 = 0

            if p53.jet then
                p53.jet = (p53.jet + p54 / Flail.jet_period(v89, v90)) % 1
                v101 = Flail.jet(p53.jet)
            end

            for _, v102 in ipairs(p53.arms) do
                local v103 = Flail.arm(v102.k, v102.dirs, v102.share, back, up, v89, v86, fin, p53.disp, p53.dazed, v90, p53.amp, p53.ring, (p53.ring or p53.integ) and p53.clk or nil, p53.cap)
                local v104 = p53.whip and BodySwim and Flail.whip(#v102.bones, p53.beat, v89, p53.whip) or nil

                for v105, v106 in ipairs(v102.bones) do
                    local v107 = p53.mcf:ToObjectSpace(v106.WorldCFrame)
                    local v108 = v105 == 1 and BodySwim and CFrame.fromAxisAngle(v107:VectorToObjectSpace(v98), v100) or CFrame.identity

                    if v104 and v105 > 1 then
                        v108 = CFrame.fromAxisAngle(v107:VectorToObjectSpace(v98), v104[v105])
                    end

                    if v105 == 1 and v102.spread then
                        v108 *= CFrame.fromAxisAngle(v107:VectorToObjectSpace(v102.spread), v101)
                    end

                    for _, v109 in ipairs(v103[v105]) do
                        v108 *= CFrame.fromAxisAngle(v107:VectorToObjectSpace(v109[1]), v109[2])
                    end

                    v106.Transform = v108
                end
            end

            if v95 > 0 then
                for v110, v111 in ipairs(Flail.tail(v95, p53.beat, p53.tailAmp)) do
                    local v112 = p53.tails[v110]

                    v112.Transform = CFrame.fromAxisAngle(StrokeClock.axis(p53, v112, up), v111)
                end
            end

            if p53.head then
                p53.tb += p54
                p53.nextb -= p54

                if p53.nextb <= 0 then
                    local SWIPE_HOOK = v90 and Flail.SWIPE_HOOK or Flail.SWIPE_EVERY
                    local v113 = SWIPE_HOOK[1] + math.random() * (SWIPE_HOOK[2] - SWIPE_HOOK[1])

                    p53.tb = 0
                    p53.nextb = v113
                end

                local v114, v115 = Flail.swipe(p53.tb, fin)

                p53.head.Transform = CFrame.fromAxisAngle(StrokeClock.axis(p53, p53.head, up), v114)

                if p53.jaw then
                    p53.jt += p54 * (v90 and Flail.JAW_HOOK or 1)

                    if p53.jt >= p53.jp then
                        p53.jt -= p53.jp
                        p53.jp = Flail.JAW_EVERY[1] + math.random() * (Flail.JAW_EVERY[2] - Flail.JAW_EVERY[1])
                    end

                    p53.jaw.Transform = CFrame.fromAxisAngle(StrokeClock.axis(p53, p53.jaw, p53.open), Flail.jaw(p53.jt, p53.jp, v115))
                end
            end

            local v116, v117 = Flail.body(fin, p53.dazed)
            local Body = p53.bones.Body
            local v118 = p53.mcf:ToObjectSpace(Body.WorldCFrame)

            Body.Transform = CFrame.fromAxisAngle(v118:VectorToObjectSpace(v98), v99) * CFrame.fromAxisAngle(v118:VectorToObjectSpace(back), v116) * CFrame.fromAxisAngle(v118:VectorToObjectSpace(p53.right), v117)
        end
    }
end
