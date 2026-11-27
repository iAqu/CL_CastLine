-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.JellyPulse = {
        N_RIM = 8,
        N_TENT = 8,
        SEGS = 3,
        CONTRACT = 0.3,
        RIM_CLOSE = 0.8,
        TENT_PULL = 0.16,
        TENT_DRIFT = 0.08,
        TENT_LAG = 0.1,
        WAVE = 0.1,
        WAVE_RATE = 1.6,
        WAVE_LAG = 0.8,
        TENT_TURN = 0.15,
        MIN_PULSE = 0.35,
        HOOK_PULSE = 1.3,
        HOOK_RATE = 12,
        HOOK_EFFORT = 1,
        PEN_RATE = 5,
        TURN_REF = 0.6,
        FLOW_PULL = 0.24,
        FLOW_DRIFT = 0.1,
        FLOW_LAG = 0.3,
        FLOW_WAVE = 1.5,
        FLOW_ROOT = 0.3,
        FLOW_RATE = 2.2,
        FLOW_K = 4,
        FLOW_PITCH = 0.6,
        FLOW_PRATE = 0.83,
        FLOW_SPREAD = 0.6,
        RIB_RIM_CLOSE = 0.8,
        RIB_PULL = 0.42,
        RIB_DRIFT = 0.14,
        RIB_G0 = 0.25,
        RIB_G1 = 0.6,
        RIB_LAG = 0.32,
        RIB_WAVE = 0.075,
        RIB_ROOT = 0.25,
        RIB_RATE = 1.9,
        RIB_WLAG = 0.9,
        RIB_SPREAD = 1.2,
        RIB_FLUT = 0.035,
        RIB_TURN = 0.18,
        HY_RIM_CLOSE = 0.65,
        HY_LIFT = 0.03,
        HY_TENT_PULL = 0.55,
        HY_TENT_DRIFT = 0.15,
        HY_TENT_LAG = 0.12,
        HY_WAVE = 0.1,
        HY_WAVE_RATE = 1.2,
        HY_WAVE_LAG = 0.9,
        HY_STREAM = 0.6,
        HY_V_FULL = 0.6,
        HY_STREAM_CAP = 0.5,
        HY_TURN = 0.15,
        HY_NECK_PULL = 0.14,
        HY_NECK_DRIFT = 0.05,
        HY_NECK_LAG = 0.06,
        HY_JAW_WIDE = 0.15,
        HY_JAW_SNAP = 0.85,
        HY_GNASH_EVERY = { 0.9, 2.8 },
        HY_GNASH_TIME = 0.34,
        HY_GNASH_CLOSE = 0.25,
        HY_GNASH_SHUT = 0.55,
        HY_BREATH = 0.04,
        HY_BREATH_RATE = 2.4,
        HY_CHATTER = 14,
        HY_CHATTER_SHUT = 0.5,
        HY_GAPE = 1.15,
        HY_LOCK = {
            HOOK_RATE = 12,
            HOOK_EFFORT = 1,
            PEN_RATE = 3.2
        },
        HY_DISPLAY_TAU = 0.35,
        jawStrike = function(p3, p4) -- jawStrike | line: 56
            -- upvalues: p1 (copy)
            local JellyPulse, HydraSwim = p1.JellyPulse, p1.HydraSwim

            if p3 <= 0 or p3 >= 1 then
                return 0
            end

            local STRIKE_UP, STRIKE_HIT = HydraSwim.STRIKE_UP, HydraSwim.STRIKE_HIT

            if p3 < STRIKE_UP then
                return -JellyPulse.HY_JAW_WIDE * JellyPulse.smooth(p3 / STRIKE_UP)
            end

            if p3 < STRIKE_UP + STRIKE_HIT then
                return -JellyPulse.HY_JAW_WIDE + (JellyPulse.HY_JAW_SNAP * p4 + JellyPulse.HY_JAW_WIDE) * JellyPulse.smooth((p3 - STRIKE_UP) / STRIKE_HIT)
            end

            return JellyPulse.HY_JAW_SNAP * p4 * (1 - JellyPulse.smooth((p3 - STRIKE_UP - STRIKE_HIT) / (1 - STRIKE_UP - STRIKE_HIT)))
        end,
        jawGnash = function(p5, p6) -- jawGnash | line: 67
            -- upvalues: p1 (copy)
            local JellyPulse = p1.JellyPulse

            if p5 <= 0 or p5 >= 1 then
                return 0
            end

            if p5 < JellyPulse.HY_GNASH_CLOSE then
                return JellyPulse.HY_GNASH_SHUT * p6 * JellyPulse.smooth(p5 / JellyPulse.HY_GNASH_CLOSE)
            end

            return JellyPulse.HY_GNASH_SHUT * p6 * (1 - JellyPulse.smooth((p5 - JellyPulse.HY_GNASH_CLOSE) / (1 - JellyPulse.HY_GNASH_CLOSE)))
        end,
        poseHydra = function(p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17) -- poseHydra | line: 74
            -- upvalues: p1 (copy)
            local JellyPulse, HydraSwim = p1.JellyPulse, p1.HydraSwim
            local HOOK_PULSE = p15 and JellyPulse.HOOK_PULSE or JellyPulse.MIN_PULSE + (1 - JellyPulse.MIN_PULSE) * math.clamp(p8, 0, 1)
            local v1 = JellyPulse.contract(p7)
            local t2 = {
                Bell = {
                    {
                        "lift",
                        HOOK_PULSE * JellyPulse.HY_LIFT * v1
                    }
                }
            }

            for i = 1, p14 do
                t2["Rim_" .. i] = {
                    {
                        "in",
                        HOOK_PULSE * JellyPulse.HY_RIM_CLOSE * v1
                    }
                }
            end

            local v3 = math.max(#p13, 1)

            for v4, v5 in ipairs(p13) do
                local v6 = v5[1]
                local v7 = v5[2]
                local v8 = v4 * 2 * 3.141592653589793 / v3

                for j = 1, v7 do
                    local v9 = JellyPulse.contract(p7 - JellyPulse.HY_TENT_LAG * j)
                    local v10 = HOOK_PULSE * (JellyPulse.HY_TENT_PULL * v9 - JellyPulse.HY_TENT_DRIFT * (1 - v9)) / v7
                    local v13 = JellyPulse.HY_WAVE * (1 - 0.6 * v9) * math.sin(p11 * JellyPulse.HY_WAVE_RATE + v8 - JellyPulse.HY_WAVE_LAG * j)
                    local t3 = {
                        { "in", v10 },
                        { "side", v13 }
                    }

                    if j == 1 then
                        table.insert(t3, {
                            "stream",
                            JellyPulse.HY_STREAM * p10 * v6
                        })
                        table.insert(t3, {
                            "up",
                            -JellyPulse.HY_TURN * p9
                        })
                    end

                    t2["Tent_" .. v4 .. "_" .. j] = t3
                end
            end

            local v14 = JellyPulse.contract(p7 - JellyPulse.HY_NECK_LAG)
            local v15 = HOOK_PULSE * (JellyPulse.HY_NECK_PULL * v14 - JellyPulse.HY_NECK_DRIFT * (1 - v14)) / 2

            for _, v16 in ipairs(p12) do
                local v17 = HydraSwim.pose(v16.k, v16.n, v16.side, p11, p17, p15, p16, v16.strike)

                for k = 1, v16.n do
                    local t6 = {
                        {
                            "hup",
                            v17[k][1]
                        },
                        {
                            "hright",
                            v17[k][2]
                        }
                    }

                    if k <= 2 then
                        table.insert(t6, 1, {
                            "hin",
                            v15
                        })
                    end

                    t2[v16.name .. "_" .. k] = t6
                end

                local v18 = if p15 then JellyPulse.HY_CHATTER_SHUT * v16.gape * 0.5 * (math.sin(p11 * JellyPulse.HY_CHATTER + HydraSwim.GOLD * v16.k) + 1) else (if v16.su > 0 then JellyPulse.jawStrike(v16.su, v16.gape) else JellyPulse.jawGnash(v16.gu, v16.gape)) + JellyPulse.HY_BREATH * math.sin(p11 * JellyPulse.HY_BREATH_RATE + HydraSwim.GOLD * v16.k)

                t2[v16.name .. "_Jaw"] = { { "jaw", v18 } }
            end

            return t2
        end,
        registerHydra = function(p18) -- registerHydra | line: 119
            -- upvalues: p1 (copy), attr (copy)
            local JellyPulse, StrokeClock, HydraSwim = p1.JellyPulse, p1.StrokeClock, p1.HydraSwim
            local v23 = StrokeClock.setup(p18, { "Body", "Bell", "Rim_1", "Tent_1_1" })

            if not v23 then
                return nil
            end

            local bones = v23.bones

            local function pos(p19) -- line: 126
                -- upvalues: v23 (copy), bones (copy)
                return v23.mcf:PointToObjectSpace(bones[p19].WorldPosition)
            end

            local v24 = v23.mcf:PointToObjectSpace(bones.Body.WorldPosition)
            local n1 = 0
            local v25 = Vector3.new(0, 0, 0)

            while bones["Rim_" .. n1 + 1] do
                n1 += 1

                local v26 = "Rim_" .. n1

                v25 += v23.mcf:PointToObjectSpace(bones[v26].WorldPosition)
            end

            local Unit = (v24 - v25 / n1).Unit
            local v27 = -Unit

            local function perp(p20) -- line: 135
                -- upvalues: Unit (copy)
                return p20 - Unit * p20:Dot(Unit)
            end

            v23.A = {
                Bell = {
                    bone = bones.Bell,
                    lift = StrokeClock.axis(v23, bones.Bell, Unit)
                }
            }

            for i = 1, n1 do
                local v28 = bones["Rim_" .. i]
                local A = v23.A
                local v29 = "Rim_" .. i
                local t8 = {
                    bone = v28
                }
                local axis = StrokeClock.axis
                local v30 = "Rim_" .. i
                local v31 = v23.mcf:PointToObjectSpace(bones[v30].WorldPosition) - v24

                t8["in"] = axis(v23, v28, (v31 - Unit * v31:Dot(Unit)).Unit:Cross(v27))
                A[v29] = t8
            end

            local t9 = {}
            local n2 = 1

            while bones["Tent_" .. n2 .. "_1"] do
                local n3 = 0
                local v32 = Vector3.new(0, 0, 0)

                while bones["Tent_" .. n2 .. "_" .. n3 + 1] do
                    n3 += 1

                    local v33 = "Tent_" .. n2 .. "_" .. n3

                    v32 += v23.mcf:PointToObjectSpace(bones[v33].WorldPosition)
                end

                local v34 = v32 / n3 - v24
                local Unit2 = (v34 - Unit * v34:Dot(Unit)).Unit
                local v35 = Unit2:Cross(v27)
                local v36 = n3 > 1
                local Unit3

                if v36 then
                    local v37 = "Tent_" .. n2 .. "_2"
                    local v38 = v23.mcf:PointToObjectSpace(bones[v37].WorldPosition)
                    local v39 = "Tent_" .. n2 .. "_1"

                    Unit3 = (v38 - v23.mcf:PointToObjectSpace(bones[v39].WorldPosition)).Unit
                end

                local v40 = if not v36 or not Unit3 then v27 else Unit3
                local v41 = v40:Cross(-v23.nose)

                if v41.Magnitude < 1E-04 then
                    v41 = v23.up
                end

                t9[n2] = {
                    math.min(math.acos((math.clamp(v40:Dot(-v23.nose), -1, 1))), JellyPulse.HY_STREAM_CAP),
                    n3
                }

                for i = 1, n3 do
                    local v45 = bones["Tent_" .. n2 .. "_" .. i]

                    v23.A["Tent_" .. n2 .. "_" .. i] = {
                        bone = v45,
                        ["in"] = StrokeClock.axis(v23, v45, v35),
                        side = StrokeClock.axis(v23, v45, Unit2),
                        up = StrokeClock.axis(v23, v45, v23.up),
                        stream = StrokeClock.axis(v23, v45, v41.Unit)
                    }
                end

                n2 += 1
            end

            local t10 = {}

            for v46 in pairs(bones) do
                local v47 = string.match(v46, "^(Head%w*)_Jaw$")

                if v47 then
                    table.insert(t10, v47)
                end
            end

            table.sort(t10)

            local t11 = {}
            local n4 = 0

            for v48, v49 in ipairs(t10) do
                local n5 = 0

                while bones[v49 .. "_" .. n5 + 1] do
                    n5 += 1
                end

                if n5 > 0 then
                    local v50 = v49 .. "_" .. n5
                    local v51 = v23.mcf:PointToObjectSpace(bones[v50].WorldPosition)
                    local v52 = v49 .. "_Jaw"
                    local Unit2 = (v23.mcf:PointToObjectSpace(bones[v52].WorldPosition) - v51).Unit
                    local Unit3 = (v23.up - Unit2 * Unit2:Dot(v23.up)).Unit
                    local v53 = Unit2:Cross(Unit3)
                    local v54 = v51 - v24
                    local v55 = (v54 - Unit * v54:Dot(Unit)).Unit:Cross(v27)

                    for j = 1, n5 do
                        local v56 = bones[v49 .. "_" .. j]

                        v23.A[v49 .. "_" .. j] = {
                            bone = v56,
                            hup = StrokeClock.axis(v23, v56, Unit3),
                            hright = StrokeClock.axis(v23, v56, v53),
                            hin = StrokeClock.axis(v23, v56, v55)
                        }
                    end

                    local v57 = bones[v49 .. "_Jaw"]

                    v23.A[v49 .. "_Jaw"] = {
                        bone = v57,
                        jaw = StrokeClock.axis(v23, v57, v53)
                    }

                    local v58 = v51:Dot(v23.up)

                    table.insert(t11, {
                        side = 1,
                        strike = 0,
                        su = 0,
                        gu = 0,
                        name = v49,
                        k = v48,
                        n = n5,
                        z = v58,
                        gape = v57:GetAttribute("Gape") or JellyPulse.HY_GAPE
                    })
                    n4 += v58
                end
            end

            local v60 = n4 / math.max(#t11, 1)
            local v61 = attr(p18, "HeadStrike") == true
            local v62 = math.random() * 10

            for _, v63 in ipairs(t11) do
                v63.side = v60 < v63.z and 1 or -1

                if v61 then
                    v63.nextStrike = v62 + HydraSwim.STRIKE_EVERY[1] + math.random() * (HydraSwim.STRIKE_EVERY[2] - HydraSwim.STRIKE_EVERY[1]) * 1.5
                end

                v63.nextGnash = v62 + JellyPulse.HY_GNASH_EVERY[1] + math.random() * (JellyPulse.HY_GNASH_EVERY[2] - JellyPulse.HY_GNASH_EVERY[1])
            end

            v23.fin = v62
            v23.disp = 0
            v23.hydra = {
                heads = t11,
                tents = t9,
                nRim = n1,
                amp = attr(p18, "HeadSway") or 1
            }

            return v23
        end,
        updateHydra = function(p21, p22, _) -- updateHydra | line: 203
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local JellyPulse, StrokeClock, HydraSwim = p1.JellyPulse, p1.StrokeClock, p1.HydraSwim
            local model = p21.model
            local v64 = StrokeClock.lock(p21, p22, JellyPulse.HY_LOCK)
            local v66 = math.clamp(StrokeClock.turn(p21, p22) / JellyPulse.TURN_REF, -1, 1)
            local v68 = math.clamp(p21.v / math.max(p21.length, 0.001) / JellyPulse.HY_V_FULL, 0, 1)

            p21.fin += p22
            p21.disp = p21.disp + ((if attr(model, "Display") then 1 else 0) - p21.disp) * math.min(1, p22 / JellyPulse.HY_DISPLAY_TAU)

            local v71 = fightHooked(model)
            local fin, hydra = p21.fin, p21.hydra

            for _, v72 in ipairs(hydra.heads) do
                v72.strike = 0
                v72.su = 0
                v72.gu = 0

                if v72.nextStrike and not v71 then
                    if v72.strikeAt then
                        local v73 = (fin - v72.strikeAt) / HydraSwim.STRIKE_TIME

                        if v73 >= 1 then
                            v72.strikeAt = nil
                            v72.nextStrike = fin + HydraSwim.STRIKE_EVERY[1] + math.random() * (HydraSwim.STRIKE_EVERY[2] - HydraSwim.STRIKE_EVERY[1])
                        else
                            v72.strike = HydraSwim.strikePitch(v73)
                            v72.su = v73
                        end
                    elseif v72.nextStrike <= fin then
                        v72.strikeAt = fin
                    end
                end

                if v72.gnashAt then
                    local v74 = (fin - v72.gnashAt) / JellyPulse.HY_GNASH_TIME

                    if v74 >= 1 then
                        v72.gnashAt = nil
                        v72.nextGnash = fin + JellyPulse.HY_GNASH_EVERY[1] + math.random() * (JellyPulse.HY_GNASH_EVERY[2] - JellyPulse.HY_GNASH_EVERY[1])
                    else
                        v72.gu = v74
                    end
                elseif v72.nextGnash <= fin and v72.su == 0 then
                    v72.gnashAt = fin
                end
            end

            local v75 = JellyPulse.poseHydra(p21.phase / 6.283185307179586, v64, v66, v68, fin, hydra.heads, hydra.tents, hydra.nRim, v71, hydra.amp, p21.disp)

            for v76, v77 in pairs(v75) do
                local v78 = p21.A[v76]

                if v78 then
                    local v79 = CFrame.identity

                    for _, v80 in ipairs(v77) do
                        if v80[1] == "lift" then
                            v79 *= CFrame.new(v78.lift * (v80[2] * p21.length))
                        else
                            v79 *= CFrame.fromAxisAngle(v78[v80[1]], v80[2])
                        end
                    end

                    v78.bone.Transform = v79
                end
            end
        end,
        smooth = function(p24) -- smooth | line: 259
            local v81 = math.clamp(p24, 0, 1)

            return v81 * v81 * (3 - 2 * v81)
        end,
        contract = function(p25) -- contract | line: 264
            -- upvalues: p1 (copy)
            local JellyPulse = p1.JellyPulse
            local v82 = (p25 + JellyPulse.CONTRACT / 2) % 1

            if v82 < JellyPulse.CONTRACT then
                return JellyPulse.smooth(v82 / JellyPulse.CONTRACT)
            end

            return 1 - JellyPulse.smooth((v82 - JellyPulse.CONTRACT) / (1 - JellyPulse.CONTRACT))
        end,
        pose = function(p26, p27, p28, p29, p30, p31) -- pose | line: 272
            -- upvalues: p1 (copy)
            local JellyPulse = p1.JellyPulse

            p31 = p31 or JellyPulse.SEGS

            local HOOK_PULSE = p30 and JellyPulse.HOOK_PULSE or JellyPulse.MIN_PULSE + (1 - JellyPulse.MIN_PULSE) * math.clamp(p27, 0, 1)
            local v84 = JellyPulse.contract(p26)
            local t13 = {}

            for i = 1, JellyPulse.N_RIM do
                t13["Rim_" .. i] = {
                    {
                        "in",
                        HOOK_PULSE * JellyPulse.RIM_CLOSE * v84
                    }
                }
            end

            for i = 1, JellyPulse.N_TENT do
                local v85 = i * 2 * 3.141592653589793 / JellyPulse.N_TENT

                for j = 1, p31 do
                    local v86 = JellyPulse.contract(p26 - JellyPulse.TENT_LAG * j)
                    local v87 = HOOK_PULSE * (JellyPulse.TENT_PULL * v86 - JellyPulse.TENT_DRIFT * (1 - v86)) / p31
                    local v90 = JellyPulse.WAVE * (1 - 0.6 * v86) * math.sin(p29 * JellyPulse.WAVE_RATE + v85 - JellyPulse.WAVE_LAG * j)
                    local t14 = {
                        { "in", v87 },
                        { "side", v90 }
                    }

                    if j == 1 then
                        table.insert(t14, {
                            "up",
                            -JellyPulse.TENT_TURN * p28
                        })
                    end

                    t13["Tent_" .. i .. "_" .. j] = t14
                end
            end

            return t13
        end,
        poseFlow = function(p32, p33, p34, p35, p36, p37, p38) -- poseFlow | line: 296
            -- upvalues: p1 (copy)
            local JellyPulse = p1.JellyPulse
            local HOOK_PULSE = p37 and JellyPulse.HOOK_PULSE or JellyPulse.MIN_PULSE + (1 - JellyPulse.MIN_PULSE) * math.clamp(p33, 0, 1)
            local v91 = JellyPulse.contract(p32)
            local t16 = {}

            for i = 1, JellyPulse.N_RIM do
                t16["Rim_" .. i] = {
                    {
                        "in",
                        HOOK_PULSE * JellyPulse.RIM_CLOSE * v91
                    }
                }
            end

            for v92, v93 in pairs(p36) do
                local v94 = v93[1]
                local v95 = v93[2]

                for j = 1, p38 do
                    local v96 = (j - 0.5) / p38
                    local v97 = JellyPulse.contract(p32 - JellyPulse.FLOW_LAG * v96)
                    local v98 = HOOK_PULSE * (JellyPulse.FLOW_PULL * v97 - JellyPulse.FLOW_DRIFT * (1 - v97)) / p38
                    local v99 = (JellyPulse.FLOW_ROOT + (1 - JellyPulse.FLOW_ROOT) * v96) * (1 - 0.4 * v97) * JellyPulse.FLOW_WAVE / p38
                    local v101 = v99 * math.sin(p35 * JellyPulse.FLOW_RATE - JellyPulse.FLOW_K * v96 + JellyPulse.FLOW_SPREAD * v95)
                    local v104 = JellyPulse.FLOW_PITCH * v99 * math.sin(p35 * JellyPulse.FLOW_RATE * JellyPulse.FLOW_PRATE - JellyPulse.FLOW_K * v96 + 1.9 + JellyPulse.FLOW_SPREAD * v94)
                    local t17 = {
                        { "in", v98 },
                        { "up", v101 },
                        { "right", v104 }
                    }

                    if j == 1 then
                        table.insert(t17, {
                            "up",
                            -JellyPulse.TENT_TURN * p34
                        })
                    end

                    t16["Tent_" .. v92 .. "_" .. j] = t17
                end
            end

            return t16
        end,
        poseRibbon = function(p39, p40, p41, p42, p43, p44, p45) -- poseRibbon | line: 321
            -- upvalues: p1 (copy)
            local JellyPulse = p1.JellyPulse
            local HOOK_PULSE = p44 and JellyPulse.HOOK_PULSE or JellyPulse.MIN_PULSE + (1 - JellyPulse.MIN_PULSE) * math.clamp(p40, 0, 1)
            local v105 = JellyPulse.contract(p39)
            local t19 = {}

            for i = 1, JellyPulse.N_RIM do
                t19["Rim_" .. i] = {
                    {
                        "in",
                        HOOK_PULSE * JellyPulse.RIB_RIM_CLOSE * v105
                    }
                }
            end

            for v106, v107 in pairs(p43) do
                local v108 = v107[1]
                local v109 = v107[2]
                local v110 = JellyPulse.smooth((math.abs(v108) - JellyPulse.RIB_G0) / (JellyPulse.RIB_G1 - JellyPulse.RIB_G0))

                for j = 1, p45 do
                    local v111 = p45 - 1
                    local v112 = (j - 1) / math.max(v111, 1)
                    local v113 = JellyPulse.contract(p39 - JellyPulse.RIB_LAG * v112)
                    local v114 = v110 * HOOK_PULSE * (JellyPulse.RIB_PULL * v113 - JellyPulse.RIB_DRIFT * (1 - v113)) / p45
                    local v115 = JellyPulse.RIB_ROOT + (1 - JellyPulse.RIB_ROOT) * v112
                    local v118 = v109 * JellyPulse.RIB_WAVE * v115 * (1 - 0.5 * v113) * math.sin(p42 * JellyPulse.RIB_RATE - JellyPulse.RIB_SPREAD * v108 - JellyPulse.RIB_WLAG * j)
                    local v121 = JellyPulse.RIB_FLUT * v112 * math.sin(p42 * JellyPulse.RIB_RATE * 1.3 + 2.5 * v108 - JellyPulse.RIB_WLAG * j)
                    local t20 = {
                        {
                            "in",
                            v114 + v118
                        },
                        { "side", v121 }
                    }

                    if j == 1 then
                        table.insert(t20, {
                            "up",
                            -JellyPulse.RIB_TURN * p41
                        })
                    end

                    t19["Tent_" .. v106 .. "_" .. j] = t20
                end
            end

            return t19
        end,
        register = function(p46) -- register | line: 346
            -- upvalues: p1 (copy), attr (copy)
            if attr(p46, "JellyHydra") then
                return p1.JellyPulse.registerHydra(p46)
            end

            local JellyPulse, StrokeClock = p1.JellyPulse, p1.StrokeClock
            local v122 = StrokeClock.setup(p46, { "Body", "Rim_1", "Tent_1_1", "Tent_8_3" })

            if not v122 then
                return nil
            end

            local v123 = v122.mcf:PointToObjectSpace(v122.bones.Body.WorldPosition)
            local v124 = -v122.nose

            v122.A = {}

            for v125, v126 in pairs(v122.bones) do
                if v125:match("^Rim_") or v125:match("^Tent_") then
                    local v127 = v122.mcf:PointToObjectSpace(v126.WorldPosition) - v123
                    local Unit = (v127 - v122.nose * v127:Dot(v122.nose)).Unit

                    v122.A[v125] = {
                        bone = v126,
                        ["in"] = StrokeClock.axis(v122, v126, Unit:Cross(v124).Unit),
                        side = StrokeClock.axis(v122, v126, Unit),
                        up = StrokeClock.axis(v122, v126, v122.up)
                    }
                end
            end

            local n6 = 0

            while v122.bones["Tent_1_" .. n6 + 1] do
                n6 += 1
            end

            v122.segs = n6

            if attr(p46, "JellyFlow") then
                local t23 = {}
                local N_TENT = JellyPulse.N_TENT
                local n7 = 1E-06

                for i = 1, N_TENT do
                    if v122.bones["Tent_" .. i .. "_1"] then
                        local v128 = Vector3.new(0, 0, 0)
                        local n8 = 0

                        for j = 1, n6 do
                            local v129 = v122.bones["Tent_" .. i .. "_" .. j]

                            if v129 then
                                v128 += v122.mcf:PointToObjectSpace(v129.WorldPosition)
                                n8 += 1
                            end
                        end

                        local v130 = v128 / n8 - v123
                        local v131 = v130:Dot(v122.right)
                        local v132 = v130:Dot(v122.up)

                        n7 = math.max(n7, math.abs(v131), (math.abs(v132)))
                        t23[i] = { v131, v132 }
                    end
                end

                for _, v135 in pairs(t23) do
                    v135[1] /= n7
                    v135[2] /= n7
                end

                for v136, v137 in pairs(v122.A) do
                    if v136:match("^Tent_") then
                        v137.right = StrokeClock.axis(v122, v137.bone, v122.right)
                    end
                end

                v122.flow = {
                    chains = t23
                }
            end

            if attr(p46, "JellyRibbon") then
                local n9 = 0

                while v122.bones["Tent_1_" .. n9 + 1] do
                    n9 += 1
                end

                local t24 = {}
                local N_TENT = JellyPulse.N_TENT
                local n10 = 1E-06

                for i = 1, N_TENT do
                    if v122.bones["Tent_" .. i .. "_1"] then
                        local v138 = Vector3.new(0, 0, 0)
                        local n11 = 0

                        for j = 1, n9 do
                            local v139 = v122.bones["Tent_" .. i .. "_" .. j]

                            if v139 then
                                v138 += v122.mcf:PointToObjectSpace(v139.WorldPosition)
                                n11 += 1
                            end
                        end

                        local v140 = v138 / n11 - v123
                        local Unit = (v140 - v122.nose * v140:Dot(v122.nose)).Unit
                        local Unit2 = Unit:Cross(v124).Unit
                        local v141 = v140:Dot(v122.right)

                        n10 = math.max(n10, (math.abs(v141)))
                        t24[i] = {
                            v141,
                            if Unit2:Dot(v122.up) > 0 then 1 else -1
                        }

                        for k = 1, n9 do
                            local v144 = "Tent_" .. i .. "_" .. k
                            local v145 = v122.bones[v144]

                            if v145 then
                                v122.A[v144] = {
                                    bone = v145,
                                    ["in"] = StrokeClock.axis(v122, v145, Unit2),
                                    side = StrokeClock.axis(v122, v145, Unit),
                                    up = StrokeClock.axis(v122, v145, v122.up)
                                }
                            end
                        end
                    end
                end

                for _, v146 in pairs(t24) do
                    v146[1] /= n10
                end

                v122.ribbon = {
                    segs = n9,
                    chains = t24
                }
            end

            return v122
        end,
        update = function(p47, p48, p49) -- update | line: 423
            -- upvalues: p1 (copy), fightHooked (copy)
            if p47.hydra then
                return p1.JellyPulse.updateHydra(p47, p48, p49)
            end

            local JellyPulse, StrokeClock = p1.JellyPulse, p1.StrokeClock
            local v147 = StrokeClock.lock(p47, p48, JellyPulse)
            local v149 = math.clamp(StrokeClock.turn(p47, p48) / JellyPulse.TURN_REF, -1, 1)

            p47.fin += p48

            local ribbon = p47.ribbon
            local v150 = if ribbon then JellyPulse.poseRibbon(p47.phase / 6.283185307179586, v147, v149, p47.fin, ribbon.chains, fightHooked(p47.model), ribbon.segs) elseif p47.flow then JellyPulse.poseFlow(p47.phase / 6.283185307179586, v147, v149, p47.fin, p47.flow.chains, fightHooked(p47.model), p47.segs) else JellyPulse.pose(p47.phase / 6.283185307179586, v147, v149, p47.fin, fightHooked(p47.model), p47.segs)

            for v151, v152 in pairs(v150) do
                local v153 = p47.A[v151]

                if v153 then
                    local v154 = CFrame.identity

                    for _, v155 in ipairs(v152) do
                        v154 *= CFrame.fromAxisAngle(v153[v155[1]], v155[2])
                    end

                    v153.bone.Transform = v154
                end
            end
        end
    }
end
