-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 26
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ArgentoSwim = {
        PHI0 = -0.2,
        SWING = 0.35,
        FOLD = 0.1,
        FOLD_LEAD = -0.5,
        HAND0 = 0.45,
        HAND = 0.25,
        HAND_LAG = 0.3,
        ARM_POLE = Vector3.new(0.4, 1, 0),
        DIAG = 0.1,
        PHI_L0 = 0.1,
        LSWING = 0.28,
        FOLD_L = 0.1,
        FOLD_L_LEAD = 0.5,
        FOOT0 = 0,
        FOOT = 0.2,
        FOOT_LAG = 0.3,
        LEG_POLE = Vector3.new(0, -1, 0),
        RAM_SWING = 0.2,
        TURN_GAIN = 0.3,
        TRUNK = {
            { "Chest", 0.03 },
            { "Belly", 0.025 },
            { "Pelvis", 0.03 }
        },
        LAG = 0.6,
        BEND = 0.1,
        CHEST_ROLL = 0.04,
        HIP_ROLL = 0.03,
        ROCK = 0.015,
        TAIL = {
            { "Tail_1", 0.05, 1 },
            { "Tail_2", 0.07, 1.6 },
            { "Tail_3", 0.09, 2.2 },
            { "Tail_4", 0.11, 2.8 },
            { "Tail_5", 0.13, 3.4 }
        },
        RUDDER = 0.08,
        NECK = {
            { "Neck_1", 0.025, 0.4 },
            { "Neck_2", 0.03, 0.8 },
            { "Neck_3", 0.03, 1.2 },
            { "Neck_4", 0.025, 1.6 }
        },
        HEAD_STEADY = 0.85,
        LOOK = 0.12,
        NOD = 0.02,
        NOD_LAG = 0.5,
        RAM_CHEST = 0.03,
        RAM_NECK = 0.03,
        RAM_HEAD = 0.03,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        STRIDE = 0.29,
        MIN_HZ = 0.3,
        MAX_HZ = 1.6,
        HOOK_HZ = 1.2,
        PEN_HZ = 0.5,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        BONES = {
            "Chest",
            "Belly",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Tail_3",
            "Tail_4",
            "Tail_5",
            "Neck_1",
            "Neck_2",
            "Neck_3",
            "Neck_4",
            "Head",
            "Arm_L",
            "Fore_L",
            "Hand_L",
            "Arm_R",
            "Fore_R",
            "Hand_R",
            "Thigh_L",
            "Shin_L",
            "Foot_L",
            "Thigh_R",
            "Shin_R",
            "Foot_R"
        },
        ramOf = function(p3) -- ramOf | line: 54
            -- upvalues: p1 (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local v2 = math.clamp((p3 - ArgentoSwim.RAM_E0) / (ArgentoSwim.RAM_E1 - ArgentoSwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        turnTo = function(p4, p5) -- turnTo | line: 60
            local Unit = p4.Unit
            local Unit2 = p5.Unit
            local v3 = Unit:Cross(Unit2)
            local Magnitude = v3.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v3 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p6, p7, p8, p9, p10) -- ik | line: 68
            -- upvalues: p1 (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local Magnitude = (p7 - p6).Magnitude
            local Magnitude2 = (p8 - p7).Magnitude
            local v6 = p9 - p6
            local v8 = math.min(v6.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v6.Unit
            local Unit2 = (p10 - Unit * p10:Dot(Unit)).Unit
            local v9 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v8 * v8) / (v8 * 2)
            local v12 = math.sqrt((math.max(0, Magnitude * Magnitude - v9 * v9)))
            local v13 = p6 + Unit * v9 + Unit2 * v12
            local v14 = ArgentoSwim.turnTo(p7 - p6, v13 - p6)

            return v14, ArgentoSwim.turnTo(v14 * (p8 - p7), p9 - v13) * v14
        end,
        target = function(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- target | line: 83
            -- upvalues: p1 (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local v15 = 6.283185307179586 * p14
            local v16 = p15 - p16 * (1 + ArgentoSwim.RAM_SWING * p20) * p19 * math.cos(v15)

            return p12 + CFrame.fromAxisAngle(p11.left, v16) * (p13 - p12) * (1 - p17 * (1 - math.sin(v15 + p18)) / 2)
        end,
        arm = function(p21, p22, p23, p24) -- arm | line: 90
            -- upvalues: p1 (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local s = p21.s
            local v19 = (p22 + (if s == 1 then 0 else 0.5)) % 1
            local v20 = 1 - s * ArgentoSwim.TURN_GAIN * p23
            local v21, v22 = ArgentoSwim.ik(p21.S, p21.E, p21.W, ArgentoSwim.target(p21, p21.S, p21.W, v19, ArgentoSwim.PHI0, ArgentoSwim.SWING, ArgentoSwim.FOLD, ArgentoSwim.FOLD_LEAD, v20, p24), p21.pole)

            return v21, v22, CFrame.fromAxisAngle(v22 * p21.left, ArgentoSwim.HAND0 - ArgentoSwim.HAND * math.sin(6.283185307179586 * v19 - ArgentoSwim.HAND_LAG)) * v22
        end,
        leg = function(p25, p26, p27, p28) -- leg | line: 100
            -- upvalues: p1 (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local s = p25.s
            local v25 = (p26 - ArgentoSwim.DIAG + (if s == 1 then 0.5 else 0)) % 1
            local v26 = 1 - s * ArgentoSwim.TURN_GAIN * p27
            local v27, v28 = ArgentoSwim.ik(p25.S, p25.E, p25.W, ArgentoSwim.target(p25, p25.S, p25.W, v25, ArgentoSwim.PHI_L0, ArgentoSwim.LSWING, ArgentoSwim.FOLD_L, ArgentoSwim.FOLD_L_LEAD, v26, p28), p25.pole)

            return v27, v28, CFrame.fromAxisAngle(v28 * p25.left, ArgentoSwim.FOOT0 - ArgentoSwim.FOOT * math.sin(6.283185307179586 * v25 - ArgentoSwim.FOOT_LAG)) * v28
        end,
        body = function(p29, p30, p31) -- body | line: 110
            -- upvalues: p1 (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local v31 = 6.283185307179586 * p29
            local t2 = {}
            local n1 = 0

            for v32, v33 in ipairs(ArgentoSwim.TRUNK) do
                local v36 = v33[2] * math.sin(v31 - (v32 - 1) * ArgentoSwim.LAG)

                if v33[1] == "Chest" then
                    n1 = v36
                    t2[v33[1]] = { { "up", v36 } }
                else
                    t2[v33[1]] = {
                        {
                            "up",
                            v36 + ArgentoSwim.BEND * p30 / 4
                        }
                    }
                end
            end

            for _, v37 in ipairs(ArgentoSwim.TAIL) do
                t2[v37[1]] = {
                    {
                        "up",
                        v37[2] * math.sin(v31 - v37[3]) + ArgentoSwim.RUDDER * p30 / 5
                    }
                }
            end

            table.insert(t2.Chest, {
                "nose",
                -ArgentoSwim.CHEST_ROLL * math.sin(v31)
            })
            table.insert(t2.Chest, {
                "lat",
                ArgentoSwim.ROCK * math.sin(2 * v31) - ArgentoSwim.RAM_CHEST * p31
            })
            table.insert(t2.Belly, {
                "lat",
                ArgentoSwim.RAM_CHEST * p31 / 2
            })
            table.insert(t2.Pelvis, {
                "nose",
                ArgentoSwim.HIP_ROLL * math.sin(v31 - 6.283185307179586 * ArgentoSwim.DIAG)
            })
            table.insert(t2.Pelvis, {
                "lat",
                -ArgentoSwim.ROCK * math.sin(2 * v31)
            })

            local n2 = 0

            for v45, v46 in ipairs(ArgentoSwim.NECK) do
                local v49 = -v46[2] * math.sin(v31 - v46[3])

                n2 += v49

                if v45 == 1 then
                    t2[v46[1]] = {
                        {
                            "up",
                            v49 - ArgentoSwim.HEAD_STEADY * n1 + ArgentoSwim.LOOK * p30 / 5
                        },
                        {
                            "nose",
                            ArgentoSwim.HEAD_STEADY * ArgentoSwim.CHEST_ROLL * math.sin(v31)
                        },
                        {
                            "lat",
                            -ArgentoSwim.HEAD_STEADY * ArgentoSwim.ROCK * math.sin(2 * v31) - ArgentoSwim.RAM_NECK * p31
                        }
                    }
                else
                    t2[v46[1]] = {
                        {
                            "up",
                            v49 + ArgentoSwim.LOOK * p30 / 5
                        }
                    }
                end
            end

            t2.Head = {
                {
                    "up",
                    -ArgentoSwim.HEAD_STEADY * n2 + ArgentoSwim.LOOK * p30 / 5
                },
                {
                    "lat",
                    ArgentoSwim.NOD * math.sin(2 * v31 - ArgentoSwim.NOD_LAG) - ArgentoSwim.RAM_HEAD * p31
                }
            }

            return t2
        end,
        register = function(p32) -- register | line: 146
            -- upvalues: p1 (copy), attr (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local MeshPart = p32:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p32, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t11 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t11[descendant.Name] = descendant
                end
            end

            for _, v54 in ipairs(ArgentoSwim.BONES) do
                if not t11[v54] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v55 = p32:GetPivot() * AnatomyInverse:Inverse()
            local v56 = CFrame:VectorToObjectSpace(v55.RightVector)
            local v57 = CFrame:VectorToObjectSpace(v55.UpVector)
            local Unit = v57:Cross(v56).Unit
            local v58 = -Unit
            local v59 = -v56
            local Size = MeshPart.Size
            local v62 = math.abs(v56.X) * Size.X + math.abs(v56.Y) * Size.Y + math.abs(v56.Z) * Size.Z
            local t12 = {}

            for _, v63 in ipairs(ArgentoSwim.BONES) do
                local v64 = CFrame:ToObjectSpace(t11[v63].WorldCFrame)

                t12[v63] = {
                    bone = t11[v63],
                    nose = v64:VectorToObjectSpace(v56),
                    up = v64:VectorToObjectSpace(v57),
                    lat = v64:VectorToObjectSpace(v58),
                    pos = v64.Position,
                    M = v64.Rotation
                }
            end

            local function bodyVec(p33, p34) -- line: 173
                -- upvalues: v57 (copy), Unit (copy), v59 (copy)
                return Unit * (p34 * p33.X) + v59 * p33.Y + v57 * p33.Z
            end

            local t13 = {}
            local t14 = {}

            for _, v65 in ipairs({ "L", "R" }) do
                local v66 = if v65 == "L" then 1 else -1
                local v67 = t12["Arm_" .. v65]
                local v68 = t12["Fore_" .. v65]
                local v69 = t12["Hand_" .. v65]
                local v70 = #t13 + 1
                local t15 = {
                    s = v66,
                    b = {
                        v67.bone,
                        v68.bone,
                        v69.bone
                    },
                    M = {
                        v67.M,
                        v68.M,
                        v69.M
                    },
                    S = v67.pos,
                    E = v68.pos,
                    W = v69.pos
                }
                local ARM_POLE = ArgentoSwim.ARM_POLE

                t15.pole = Unit * (v66 * ARM_POLE.X) + v59 * ARM_POLE.Y + v57 * ARM_POLE.Z
                t15.left = Unit
                t13[v70] = t15

                local v71 = t12["Thigh_" .. v65]
                local v72 = t12["Shin_" .. v65]
                local v73 = t12["Foot_" .. v65]
                local v74 = #t14 + 1
                local t16 = {
                    s = v66,
                    b = {
                        v71.bone,
                        v72.bone,
                        v73.bone
                    },
                    M = {
                        v71.M,
                        v72.M,
                        v73.M
                    },
                    S = v71.pos,
                    E = v72.pos,
                    W = v73.pos
                }
                local LEG_POLE = ArgentoSwim.LEG_POLE

                t16.pole = Unit * (v66 * LEG_POLE.X) + v59 * LEG_POLE.Y + v57 * LEG_POLE.Z
                t16.left = Unit
                t14[v74] = t16
            end

            return {
                turn = 0,
                v = 0,
                model = p32,
                mesh = MeshPart,
                A = t12,
                arms = t13,
                legs = t14,
                noseM = v56,
                phase = math.random(),
                length = v62
            }
        end,
        update = function(p35, p36) -- update | line: 190
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local ArgentoSwim = p1.ArgentoSwim
            local model = p35.model
            local _CFrame = p35.mesh.CFrame

            if p35.lastPos and p36 > 1E-04 then
                local v75 = (_CFrame.Position - p35.lastPos).Magnitude / p36

                if v75 < 2000 then
                    p35.v = p35.v + (v75 - p35.v) * math.min(1, p36 / ArgentoSwim.V_TAU)
                end
            end

            p35.lastPos = _CFrame.Position

            local v78 = _CFrame:VectorToWorldSpace(p35.noseM)
            local v79 = Vector3.new(v78.X, 0, v78.Z)

            if v79.Magnitude > 1E-04 then
                local Unit = v79.Unit

                if p35.lastFlat and p36 > 1E-04 then
                    local v81 = math.atan2(p35.lastFlat:Cross(Unit).Y, (p35.lastFlat:Dot(Unit))) / p36

                    p35.turn = p35.turn + (math.clamp(v81 / ArgentoSwim.TURN_FULL, -1, 1) - p35.turn) * math.min(1, p36 / ArgentoSwim.TURN_TAU)
                end

                p35.lastFlat = Unit
            end

            local PEN_HZ = ArgentoSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n3 = 0

            if fightHooked(model) then
                PEN_HZ = ArgentoSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(ArgentoSwim.MAX_HZ, (math.max(p35.v / (ArgentoSwim.STRIDE * math.max(p35.length, 0.001)), ArgentoSwim.MIN_HZ)))
                n3 = if type(PassCruise) == "number" then ArgentoSwim.ramOf(p35.v / math.max(PassCruise, 0.001)) else 0
            end

            p35.phase = (p35.phase + p36 * PEN_HZ) % 1

            local phase, turn = p35.phase, p35.turn

            for v87, v88 in pairs(ArgentoSwim.body(phase, turn, n3)) do
                local v89 = p35.A[v87]
                local v90 = CFrame.identity

                for _, v91 in ipairs(v88) do
                    v90 *= CFrame.fromAxisAngle(v89[v91[1]], v91[2])
                end

                v89.bone.Transform = v90
            end

            for _, v92 in ipairs(p35.arms) do
                local v93, v94, v95 = ArgentoSwim.arm(v92, phase, turn, n3)
                local t17 = {
                    CFrame.identity,
                    v93,
                    v94,
                    v95
                }

                for i = 1, 3 do
                    v92.b[i].Transform = v92.M[i]:Inverse() * t17[i]:Inverse() * t17[i + 1] * v92.M[i]
                end
            end

            for _, v96 in ipairs(p35.legs) do
                local v97, v98, v99 = ArgentoSwim.leg(v96, phase, turn, n3)
                local t18 = {
                    CFrame.identity,
                    v97,
                    v98,
                    v99
                }

                for j = 1, 3 do
                    v96.b[j].Transform = v96.M[j]:Inverse() * t18[j]:Inverse() * t18[j + 1] * v96.M[j]
                end
            end
        end
    }
end
