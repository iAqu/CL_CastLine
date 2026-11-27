-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 12
    local fightHooked, attr = p2.fightHooked, p2.attr
    local sin, cos, clamp = math.sin, math.cos, math.clamp

    local function ss(p3) -- line: 17
        -- upvalues: clamp (copy)
        local v1 = clamp(p3, 0, 1)

        return v1 * v1 * (3 - 2 * v1)
    end

    local function mOf(p4, p5) -- line: 21
        -- upvalues: clamp (copy)
        return clamp(p4, 0, 1) * (1 + p5.KICK * clamp(p4 - 1, 0, 1))
    end

    local t1 = {
        Theriz = {
            K = {
                POWER = 0.5,
                TH_F = 0.35,
                TH_B = -0.35,
                KN_EXT = -0.1,
                KN_FLEX = 0.65,
                FT_PUSH = -0.2,
                FT_FOLD = 0.7,
                AR_IN = -0.05,
                AR_OUT = 0.4,
                DIP = -0.12,
                EL_FLEX = 0.35,
                HAND_LAG = 0.3,
                ROLL = 0.06,
                YAW = 0.04,
                BOB = 0.035,
                A_T1 = 0.06,
                A_T2 = 0.1,
                A_T3 = 0.14,
                LAG_T1 = 0.8,
                LAG_T2 = 1.5,
                LAG_T3 = 2.2,
                T_PITCH = 0.05,
                NECK_STEADY = 0.6,
                N_SWAY = 0.035,
                TURN_GAIN = 0.3,
                BEND = 0.1,
                LOOK = 0.22,
                KICK = 0.25,
                PASS_STRIDE = 1.2,
                PASS_MIN_HZ = 0.25,
                W_TAU = 0.25,
                TURN_REF = 0.6,
                POST_SHIN_L = -0.42,
                POST_SHIN_R = 0.4,
                POST_THIGH_L = 0.08,
                POST_THIGH_R = -0.08,
                POST_ARM_L = 0.18,
                POST_ARM_R = -0.18
            }
        }
    }

    function t1.Theriz.cycle(p6, p7) -- line: 41
        -- upvalues: sin (copy), clamp (copy)
        local POWER = p7.POWER

        if p6 < POWER then
            local v4 = p6 / POWER
            local v5 = clamp(v4, 0, 1)

            return v5 * v5 * (3 - 2 * v5), 4 * v4 * (1 - v4), sin(3.141592653589793 * v4), 0
        end

        local v9 = (p6 - POWER) / (1 - POWER)
        local v10 = clamp(v9, 0, 1)

        return 1 - v10 * v10 * (3 - 2 * v10), -4 * v9 * (1 - v9), 0, (sin(3.141592653589793 * v9))
    end

    function t1.Theriz.pose(p8, p9, p10) -- line: 50
        -- upvalues: sin (copy), cos (copy), clamp (copy), t1 (copy)
        local K, cycle = t1.Theriz.K, t1.Theriz.cycle
        local v16 = clamp(p9, 0, 1) * (1 + K.KICK * clamp(p9 - 1, 0, 1))
        local v17 = p8 / 6.283185307179586 % 1
        local v18 = (v17 + 0.5) % 1
        local _, _, v19 = cycle(v17, K)
        local _, _, v20 = cycle(v18, K)
        local v23 = K.BOB * v16 * cos(2 * p8)
        local t2 = {}

        t2.Chest = {
            { "lat", v23 },
            {
                "up",
                K.YAW * v16 * (v19 - v20)
            }
        }
        t2.Belly = {
            {
                "up",
                -0.5 * K.YAW * v16 * (v19 - v20)
            }
        }
        t2.Pelvis = {
            {
                "nose",
                K.ROLL * v16 * (v20 - v19)
            },
            {
                "up",
                -K.BEND * p10
            }
        }

        for _, v24 in ipairs({
                {
                    "Tail_1",
                    K.A_T1,
                    K.LAG_T1
                },
                {
                    "Tail_2",
                    K.A_T2,
                    K.LAG_T2
                },
                {
                    "Tail_3",
                    K.A_T3,
                    K.LAG_T3
                }
            }) do
            t2[v24[1]] = {
                {
                    "up",
                    v24[2] * v16 * sin(p8 - v24[3]) - K.BEND * p10
                },
                {
                    "lat",
                    K.T_PITCH * v16 * cos(2 * p8 - v24[3])
                }
            }
        end

        t2.Neck_1 = {
            {
                "lat",
                -K.NECK_STEADY * v23
            },
            {
                "up",
                K.N_SWAY * v16 * sin(p8 - 0.6) + 0.2 * K.LOOK * p10
            }
        }
        t2.Neck_2 = {
            {
                "up",
                -0.7 * K.N_SWAY * v16 * sin(p8 - 0.6) + 0.3 * K.LOOK * p10
            }
        }
        t2.Neck_3 = {
            {
                "up",
                -0.3 * K.N_SWAY * v16 * sin(p8 - 0.6) + 0.3 * K.LOOK * p10
            }
        }
        t2.Head = {
            {
                "up",
                0.2 * K.LOOK * p10
            }
        }

        for _, v36 in ipairs({
                { "L", 1, v17, v18 },
                { "R", -1, v18, v17 }
            }) do
            local v37 = v36[1]
            local v38 = v36[2]
            local v39 = v36[3]
            local v40 = v36[4]
            local v41 = v16 * (1 - K.TURN_GAIN * p10 * v38)
            local v42, _, v43, v44 = cycle(v39, K)
            local v45 = K.TH_F + (K.TH_B - K.TH_F) * v42
            local v46 = 0.5 * (K.TH_F + K.TH_B)

            t2["Thigh_" .. v37] = {
                {
                    "lat",
                    K["POST_THIGH_" .. v37] + v46 + (v45 - v46) * v41
                }
            }
            t2["Shin_" .. v37] = {
                {
                    "lat",
                    K["POST_SHIN_" .. v37] + (K.KN_EXT * (1 - v44) + K.KN_FLEX * v44) * v41
                }
            }
            t2["Foot_" .. v37] = {
                {
                    "lat",
                    (K.FT_PUSH * v43 + K.FT_FOLD * v44) * v41
                }
            }

            local v47, v48, v49, v50 = cycle(v40, K)
            local v51 = K.AR_IN + (K.AR_OUT - K.AR_IN) * v47

            t2["Arm_" .. v37] = {
                {
                    "lat",
                    K["POST_ARM_" .. v37] + K.DIP * v49 * v41
                },
                {
                    "up",
                    v38 * v51 * v41
                }
            }
            t2["Fore_" .. v37] = {
                {
                    "lat",
                    K.EL_FLEX * v50 * v41
                }
            }
            t2["Hand_" .. v37] = {
                {
                    "up",
                    -v38 * K.HAND_LAG * v48 * v41
                }
            }
        end

        return t2
    end

    t1.Pachy = {
        K = {
            A_P = 0.06,
            A_T1 = 0.12,
            A_T2 = 0.18,
            A_T3 = 0.22,
            A_T4 = 0.24,
            LAG_P = 0.4,
            LAG_T1 = 0.9,
            LAG_T2 = 1.5,
            LAG_T3 = 2.1,
            LAG_T4 = 2.7,
            COUNTER = 0.05,
            NECK_STEADY = 0.7,
            BOB = 0.025,
            POWER = 0.5,
            TH_F = 0.3,
            TH_B = -0.4,
            KN_EXT = -0.05,
            KN_FLEX = 0.55,
            FT_PUSH = -0.15,
            FT_FOLD = 0.6,
            ROLL = 0.04,
            ARM_TUCK = -0.45,
            ARM_FLUTTER = 0.08,
            RAM_E0 = 1.25,
            RAM_E1 = 1.9,
            RAM_NECK = -0.3,
            RAM_HEAD = -0.15,
            RAM_TAIL = 0.6,
            RAM_LEGS = -0.35,
            TURN_GAIN = 0.3,
            BEND = 0.12,
            LOOK = 0.22,
            KICK = 0.25,
            PASS_STRIDE = 1.3,
            PASS_MIN_HZ = 0.25,
            W_TAU = 0.25,
            TURN_REF = 0.6,
            POST_THIGH_L = -0.25,
            POST_THIGH_R = 0.25
        }
    }

    function t1.Pachy.cycle(p11, p12) -- line: 101
        -- upvalues: sin (copy), clamp (copy)
        local POWER = p12.POWER

        if p11 < POWER then
            local v52 = p11 / POWER
            local v53 = clamp(v52, 0, 1)

            return v53 * v53 * (3 - 2 * v53), sin(3.141592653589793 * v52), 0
        end

        local v56 = (p11 - POWER) / (1 - POWER)
        local v57 = clamp(v56, 0, 1)

        return 1 - v57 * v57 * (3 - 2 * v57), 0, (sin(3.141592653589793 * v56))
    end

    function t1.Pachy.pose(p13, p14, p15) -- line: 110
        -- upvalues: sin (copy), cos (copy), clamp (copy), t1 (copy)
        local K, cycle = t1.Pachy.K, t1.Pachy.cycle
        local v62 = clamp(p14, 0, 1) * (1 + K.KICK * clamp(p14 - 1, 0, 1))
        local v64 = clamp((p14 - K.RAM_E0) / (K.RAM_E1 - K.RAM_E0), 0, 1)
        local v65 = v64 * v64 * (3 - 2 * v64)
        local v66 = v62 * (1 + K.RAM_TAIL * v65)
        local v67 = -K.COUNTER * v66 * sin(p13)
        local v70 = K.BOB * v62 * cos(2 * p13)
        local t5 = {}

        t5.Chest = {
            { "up", v67 },
            { "lat", v70 }
        }
        t5.Neck = {
            {
                "up",
                -K.NECK_STEADY * v67 + 0.4 * K.LOOK * p15
            },
            {
                "lat",
                K.RAM_NECK * v65 - K.NECK_STEADY * v70
            }
        }
        t5.Head = {
            {
                "up",
                0.6 * K.LOOK * p15
            },
            {
                "lat",
                K.RAM_HEAD * v65
            }
        }

        local v71 = p13 / 6.283185307179586 % 1
        local v72 = (v71 + 0.5) % 1
        local _, v73 = cycle(v71, K)
        local _, v74 = cycle(v72, K)

        t5.Belly = {
            {
                "up",
                0.4 * v67
            }
        }
        t5.Pelvis = {
            {
                "up",
                K.A_P * v66 * sin(p13 - K.LAG_P) - K.BEND * p15
            },
            {
                "nose",
                K.ROLL * v62 * (v74 - v73)
            }
        }

        for _, v77 in ipairs({
                {
                    "1",
                    K.A_T1,
                    K.LAG_T1
                },
                {
                    "2",
                    K.A_T2,
                    K.LAG_T2
                },
                {
                    "3",
                    K.A_T3,
                    K.LAG_T3
                },
                {
                    "4",
                    K.A_T4,
                    K.LAG_T4
                }
            }) do
            t5["Tail_" .. v77[1]] = {
                {
                    "up",
                    v77[2] * v66 * sin(p13 - v77[3]) - K.BEND * p15
                }
            }
        end

        for _, v81 in ipairs({
                { "L", 1, v71 },
                { "R", -1, v72 }
            }) do
            local v82 = v81[1]
            local v83 = v81[2]
            local v84 = v81[3]
            local v85 = v62 * (1 - K.TURN_GAIN * p15 * v83) * (1 - 0.6 * v65)
            local v86, v87, v88 = cycle(v84, K)
            local v89 = 0.5 * (K.TH_F + K.TH_B)
            local v90 = K.TH_F + (K.TH_B - K.TH_F) * v86

            t5["Thigh_" .. v82] = {
                {
                    "lat",
                    K["POST_THIGH_" .. v82] + v89 + (v90 - v89) * v85 + K.RAM_LEGS * v65
                }
            }
            t5["Shin_" .. v82] = {
                {
                    "lat",
                    (K.KN_EXT * (1 - v88) + K.KN_FLEX * v88) * v85
                }
            }
            t5["Foot_" .. v82] = {
                {
                    "lat",
                    (K.FT_PUSH * v87 + K.FT_FOLD * v88) * v85
                }
            }

            local v91 = if v83 > 0 then 0 else 3.141592653589793

            t5["Arm_" .. v82] = {
                {
                    "lat",
                    K.ARM_TUCK + K.ARM_FLUTTER * v62 * sin(2 * p13 + v91)
                }
            }
            t5["Hand_" .. v82] = {
                {
                    "lat",
                    0.5 * K.ARM_FLUTTER * v62 * sin(2 * p13 - 0.8 + v91)
                }
            }
        end

        return t5
    end

    t1.Sloth = {
        K = {
            POWER = 0.55,
            AR_REACH = 0.42,
            AR_PULL = -0.5,
            AR_OUT = 0.22,
            EL_OPEN = -0.15,
            EL_BEND = 0.45,
            HOOK = -0.55,
            SPREAD = 0.2,
            ROLL = 0.07,
            YAW = 0.05,
            A_B = 0.03,
            A_P = 0.05,
            A_T1 = 0.1,
            A_T2 = 0.14,
            A_T3 = 0.18,
            LAG_B = 0.5,
            LAG_P = 1,
            LAG_T1 = 1.5,
            LAG_T2 = 2.1,
            LAG_T3 = 2.7,
            NECK_STEADY = 0.6,
            LEG_POWER = 0.5,
            TH_F = 0.15,
            TH_B = -0.2,
            KN_FLEX = 0.35,
            FT_PUSH = -0.1,
            FT_FOLD = 0.35,
            TURN_GAIN = 0.3,
            BEND = 0.1,
            LOOK = 0.22,
            KICK = 0.25,
            PASS_STRIDE = 1.1,
            PASS_MIN_HZ = 0.25,
            W_TAU = 0.25,
            TURN_REF = 0.6,
            POST_FORE_L = 0.18,
            POST_FORE_R = -0.18,
            POST_THIGH_L = 0.17,
            POST_THIGH_R = -0.17
        }
    }

    function t1.Sloth.cyc(p16, p17) -- line: 159
        -- upvalues: sin (copy), clamp (copy)
        if p16 < p17 then
            local v98 = p16 / p17
            local v99 = clamp(v98, 0, 1)

            return v99 * v99 * (3 - 2 * v99), sin(3.141592653589793 * v98), 0
        end

        local v102 = (p16 - p17) / (1 - p17)
        local v103 = clamp(v102, 0, 1)

        return 1 - v103 * v103 * (3 - 2 * v103), 0, (sin(3.141592653589793 * v102))
    end

    function t1.Sloth.pose(p18, p19, p20) -- line: 167
        -- upvalues: sin (copy), clamp (copy), t1 (copy)
        local K, cyc = t1.Sloth.K, t1.Sloth.cyc
        local v108 = clamp(p19, 0, 1) * (1 + K.KICK * clamp(p19 - 1, 0, 1))
        local v109 = p18 / 6.283185307179586 % 1
        local v110 = (v109 + 0.5) % 1
        local _, v111 = cyc(v109, K.POWER)
        local _, v112 = cyc(v110, K.POWER)
        local t6 = {}

        t6.Chest = {
            {
                "up",
                K.YAW * v108 * (v111 - v112)
            },
            {
                "nose",
                K.ROLL * v108 * (v112 - v111)
            }
        }
        t6.Neck = {
            {
                "up",
                -K.NECK_STEADY * K.YAW * v108 * (v111 - v112) + 0.4 * K.LOOK * p20
            },
            {
                "nose",
                -K.NECK_STEADY * K.ROLL * v108 * (v112 - v111)
            }
        }
        t6.Head = {
            {
                "up",
                0.6 * K.LOOK * p20
            }
        }

        local function wave(p21, p22) -- line: 179
            -- upvalues: p18 (copy), v108 (copy), sin (copy)
            return p21 * v108 * sin(p18 - p22)
        end

        local A_B, LAG_B = K.A_B, K.LAG_B

        t6.Belly = {
            {
                "up",
                A_B * v108 * sin(p18 - LAG_B)
            }
        }

        local A_P, LAG_P = K.A_P, K.LAG_P

        t6.Pelvis = {
            {
                "up",
                A_P * v108 * sin(p18 - LAG_P) - K.BEND * p20
            }
        }

        local A_T1, LAG_T1 = K.A_T1, K.LAG_T1

        t6.Tail_1 = {
            {
                "up",
                A_T1 * v108 * sin(p18 - LAG_T1) - K.BEND * p20
            }
        }

        local A_T2, LAG_T2 = K.A_T2, K.LAG_T2

        t6.Tail_2 = {
            {
                "up",
                A_T2 * v108 * sin(p18 - LAG_T2) - K.BEND * p20
            }
        }

        local A_T3, LAG_T3 = K.A_T3, K.LAG_T3

        t6.Tail_3 = {
            {
                "up",
                A_T3 * v108 * sin(p18 - LAG_T3) - K.BEND * p20
            }
        }

        for _, v125 in ipairs({
                { "L", 1, v109, v110 },
                { "R", -1, v110, v109 }
            }) do
            local v126 = v125[1]
            local v127 = v125[2]
            local v128 = v125[3]
            local v129 = v125[4]
            local v130 = v108 * (1 - K.TURN_GAIN * p20 * v127)
            local v131, v132, v133 = cyc(v128, K.POWER)
            local v134 = K.AR_REACH + (K.AR_PULL - K.AR_REACH) * v131
            local v135 = 0.5 * (K.AR_REACH + K.AR_PULL)

            t6["Arm_" .. v126] = {
                {
                    "lat",
                    v135 + (v134 - v135) * v130
                },
                {
                    "up",
                    v127 * K.AR_OUT * v133 * v130
                }
            }

            local v136 = K.EL_OPEN * v133
            local EL_BEND = K.EL_BEND
            local v138 = clamp((v131 - 0.6) / 0.4, 0, 1)
            local v139 = v136 + EL_BEND * (v138 * v138 * (3 - 2 * v138)) * (1 - v133)

            t6["Fore_" .. v126] = {
                {
                    "lat",
                    K["POST_FORE_" .. v126] + v139 * v130
                }
            }
            t6["Hand_" .. v126] = {
                {
                    "lat",
                    (K.HOOK * v132 + K.SPREAD * v133) * v130
                }
            }

            local v140, v141, v142 = cyc(v129, K.LEG_POWER)
            local v143 = 0.5 * (K.TH_F + K.TH_B)
            local v144 = K.TH_F + (K.TH_B - K.TH_F) * v140

            t6["Thigh_" .. v126] = {
                {
                    "lat",
                    K["POST_THIGH_" .. v126] + v143 + (v144 - v143) * v130
                }
            }
            t6["Shin_" .. v126] = {
                {
                    "lat",
                    K.KN_FLEX * v142 * v130
                }
            }
            t6["Foot_" .. v126] = {
                {
                    "lat",
                    (K.FT_PUSH * v141 + K.FT_FOLD * v142) * v130
                }
            }
        end

        return t6
    end

    p1.LimbSwim = {
        V_TAU = 0.3,
        HOOK_HZ = 2,
        HOOK_EFFORT = 1.5,
        PEN_HZ = 0.8,
        KINDS = t1,
        register = function(p23) -- register | line: 207
            -- upvalues: attr (copy), t1 (copy)
            local v145 = t1[attr(p23, "LimbKind") or ""]
            local MeshPart = p23:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p23, "AnatomyInverse")

            if not v145 or not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v146 = p23:GetPivot() * AnatomyInverse:Inverse()
            local v147 = CFrame:VectorToObjectSpace(v146.RightVector)
            local v148 = CFrame:VectorToObjectSpace(v146.UpVector)
            local Unit = v147:Cross(v148).Unit
            local t8 = {}
            local n1 = 0

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    local v149 = CFrame:ToObjectSpace(descendant.WorldCFrame)

                    t8[descendant.Name] = {
                        bone = descendant,
                        nose = v149:VectorToObjectSpace(v147),
                        up = v149:VectorToObjectSpace(v148),
                        lat = v149:VectorToObjectSpace(Unit)
                    }
                    n1 += 1
                end
            end

            if n1 == 0 then
                return nil
            end

            local Size = MeshPart.Size

            return {
                w = 0,
                v = 0,
                model = p23,
                mesh = MeshPart,
                kind = v145,
                A = t8,
                nose = v147,
                phase = math.random() * 6.283185307179586,
                length = math.abs(v147.X) * Size.X + math.abs(v147.Y) * Size.Y + math.abs(v147.Z) * Size.Z
            }
        end,
        update = function(p24, p25, _) -- update | line: 233
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy), clamp (copy)
            local LimbSwim = p1.LimbSwim
            local K = p24.kind.K
            local model = p24.model
            local _CFrame = p24.mesh.CFrame
            local v152 = _CFrame:VectorToWorldSpace(p24.nose)
            local v153 = Vector3.new(v152.X, 0, v152.Z)

            if p24.lastPos and p24.lastNose and p25 > 1E-04 and (_CFrame.Position - p24.lastPos).Magnitude < 20 and v153.Magnitude > 0.001 then
                local lastNose = p24.lastNose
                local Unit = v153.Unit
                local v155 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p25
                local v156 = (_CFrame.Position - p24.lastPos).Magnitude / p25

                p24.w = p24.w + (v155 - p24.w) * math.min(1, p25 / K.W_TAU)
                p24.v = p24.v + (v156 - p24.v) * math.min(1, p25 / LimbSwim.V_TAU)
            end

            p24.lastPos = _CFrame.Position

            if v153.Magnitude > 0.001 then
                p24.lastNose = v153.Unit
            end

            local PassCruise = attr(model, "PassCruise")
            local n2 = 1

            if fightHooked(model) then
                p24.phase += p25 * 6.283185307179586 * LimbSwim.HOOK_HZ
                n2 = LimbSwim.HOOK_EFFORT
            elseif PassCruise then
                p24.phase = p24.phase + p25 * 6.283185307179586 * math.max(p24.v / (K.PASS_STRIDE * math.max(p24.length, 0.001)), K.PASS_MIN_HZ)
                n2 = type(PassCruise) == "number" and p24.v / math.max(PassCruise, 0.001) or 1
            else
                p24.phase += p25 * 6.283185307179586 * LimbSwim.PEN_HZ
            end

            local v164 = p24.kind.pose(p24.phase, n2, (clamp(p24.w / K.TURN_REF, -1, 1)))

            for v165, v166 in pairs(v164) do
                local v167 = p24.A[v165]

                if v167 then
                    local v168 = CFrame.identity

                    for _, v169 in ipairs(v166) do
                        v168 *= CFrame.fromAxisAngle(v167[v169[1]], v169[2])
                    end

                    v167.bone.Transform = v168
                end
            end
        end
    }
end
