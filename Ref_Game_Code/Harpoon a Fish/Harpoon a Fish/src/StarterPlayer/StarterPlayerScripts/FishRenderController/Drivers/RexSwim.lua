-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 25
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.RexSwim = {
        PHI_L0 = 0.3,
        LSWING = 0.1,
        FOLD_L = 0.25,
        FOLD_L_LEAD = 0,
        SPLAY = 0.04,
        SPEC_L = 1.897737,
        FOOT0 = 0,
        FOOT = 0.3,
        FOOT_LAG = 0.3,
        LEG_POLE = Vector3.new(0, -1, 0),
        RAM_SWING = 0.2,
        TURN_GAIN = 0.3,
        ARM_PH = 0.1,
        ARM_A = 0.15,
        ARM_F = 0.2,
        ARM_LAG = 0.6,
        HAND_C = 0.25,
        TRUNK = {
            { "Chest", 0.02 },
            { "Belly", 0.03 },
            { "Pelvis", 0.04 }
        },
        LAG = 0.6,
        BEND = 0.1,
        CHEST_ROLL = 0.03,
        HIP_ROLL = 0.05,
        TAIL = {
            { "Tail_1", 0.05, 0.9 },
            { "Tail_2", 0.07, 1.5 },
            { "Tail_3", 0.09, 2.1 },
            { "Tail_4", 0.11, 2.7 },
            { "Tail_5", 0.13, 3.3 }
        },
        RAM_TAIL = 0.5,
        RUDDER = 0.1,
        HEAD_STEADY = 0.85,
        LOOK = 0.15,
        RAM_NECK = 0.06,
        RAM_HEAD = 0.06,
        DART_E0 = 0.75,
        DART_E1 = 1.5,
        BITE = 0.42,
        BITE_R = 0.5,
        CLOSE_T = 0.12,
        HOLD_T = 0.15,
        OPEN_T = 0.35,
        STRIDE = 0.6,
        MIN_HZ = 0.5,
        MAX_HZ = 4,
        HOOK_HZ = 3,
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
            "Neck",
            "Head",
            "Jaw",
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
        ss = function(p3) -- ss | line: 52
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        dartOf = function(p4) -- dartOf | line: 56
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim

            return RexSwim.ss((p4 - RexSwim.DART_E0) / (RexSwim.DART_E1 - RexSwim.DART_E0))
        end,
        biteEnv = function(p5) -- biteEnv | line: 61
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim

            if p5 == nil then
                return 0
            end

            return RexSwim.ss(p5 / RexSwim.CLOSE_T) * (1 - RexSwim.ss((p5 - RexSwim.CLOSE_T - RexSwim.HOLD_T) / RexSwim.OPEN_T))
        end,
        turnTo = function(p6, p7) -- turnTo | line: 67
            local Unit = p6.Unit
            local Unit2 = p7.Unit
            local v2 = Unit:Cross(Unit2)
            local Magnitude = v2.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v2 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p8, p9, p10, p11, p12) -- ik | line: 75
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim
            local Magnitude = (p9 - p8).Magnitude
            local Magnitude2 = (p10 - p9).Magnitude
            local v5 = p11 - p8
            local v7 = math.min(v5.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v5.Unit
            local Unit2 = (p12 - Unit * p12:Dot(Unit)).Unit
            local v8 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v7 * v7) / (v7 * 2)
            local v11 = math.sqrt((math.max(0, Magnitude * Magnitude - v8 * v8)))
            local v12 = p8 + Unit * v8 + Unit2 * v11
            local v13 = RexSwim.turnTo(p9 - p8, v12 - p8)

            return v13, RexSwim.turnTo(v13 * (p10 - p9), p11 - v12) * v13
        end,
        target = function(p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23) -- target | line: 91
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim
            local v14 = 6.283185307179586 * p16
            local v15 = p17 - p18 * (1 + RexSwim.RAM_SWING * p22) * p21 * math.cos(v14)
            local v17 = (1 - math.sin(v14 + p20)) / 2

            return p14 + CFrame.fromAxisAngle(p13.left, v15) * (p15 - p14) * (1 - p19 * v17) + p13.left * (p23 * RexSwim.SPLAY * p13.sc * v17)
        end,
        leg = function(p24, p25, p26, p27) -- leg | line: 99
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim
            local s = p24.s
            local v18 = (p25 + (if s == 1 then 0 else 0.5)) % 1
            local v19 = 1 - s * RexSwim.TURN_GAIN * p26
            local v20, v21 = RexSwim.ik(p24.S, p24.E, p24.W, RexSwim.target(p24, p24.S, p24.W, v18, RexSwim.PHI_L0, RexSwim.LSWING, RexSwim.FOLD_L, RexSwim.FOLD_L_LEAD, v19, p27, s), p24.pole)

            return v20, v21, CFrame.fromAxisAngle(v21 * p24.left, RexSwim.FOOT0 - RexSwim.FOOT * math.sin(6.283185307179586 * v18 - RexSwim.FOOT_LAG)) * v21
        end,
        arm = function(p28, p29) -- arm | line: 109
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim
            local v24 = 6.283185307179586 * ((2 * p29 + RexSwim.ARM_PH + (if p28.s == 1 then 0 else 0.5)) % 1)
            local v25 = CFrame.fromAxisAngle(p28.left, RexSwim.ARM_A * math.sin(v24))
            local v27 = CFrame.fromAxisAngle(p28.left, RexSwim.ARM_F * math.sin(v24 - RexSwim.ARM_LAG)) * v25

            return v25, v27, CFrame.fromAxisAngle(p28.left, RexSwim.HAND_C * math.sin(v24 - 2 * RexSwim.ARM_LAG)) * v27
        end,
        body = function(p30, p31, p32, p33) -- body | line: 119
            -- upvalues: p1 (copy)
            local RexSwim = p1.RexSwim
            local v29 = 6.283185307179586 * p30
            local t2 = {}
            local n1 = 0

            for v30, v31 in ipairs(RexSwim.TRUNK) do
                local v34 = v31[2] * math.sin(v29 - (v30 - 1) * RexSwim.LAG)

                if v31[1] == "Chest" then
                    n1 = v34
                    t2[v31[1]] = { { "up", v34 } }
                else
                    t2[v31[1]] = {
                        {
                            "up",
                            v34 + RexSwim.BEND * p31 / 4
                        }
                    }
                end
            end

            for _, v35 in ipairs(RexSwim.TAIL) do
                t2[v35[1]] = {
                    {
                        "up",
                        v35[2] * (1 + RexSwim.RAM_TAIL * p32) * math.sin(v29 - v35[3]) + RexSwim.RUDDER * p31 / 5
                    }
                }
            end

            table.insert(t2.Chest, {
                "nose",
                RexSwim.CHEST_ROLL * math.sin(v29)
            })
            table.insert(t2.Pelvis, {
                "nose",
                -RexSwim.HIP_ROLL * math.sin(v29)
            })
            t2.Neck = {
                {
                    "up",
                    -RexSwim.HEAD_STEADY * n1 + RexSwim.LOOK * p31 / 2
                },
                {
                    "nose",
                    -RexSwim.HEAD_STEADY * RexSwim.CHEST_ROLL * math.sin(v29)
                },
                {
                    "lat",
                    -RexSwim.RAM_NECK * p32
                }
            }
            t2.Head = {
                {
                    "up",
                    RexSwim.LOOK * p31 / 2
                },
                {
                    "lat",
                    -RexSwim.RAM_HEAD * p32
                }
            }
            t2.Jaw = {
                {
                    "lat",
                    RexSwim.BITE * p33
                }
            }

            return t2
        end,
        register = function(p34) -- register | line: 143
            -- upvalues: p1 (copy), attr (copy)
            local RexSwim = p1.RexSwim
            local MeshPart = p34:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p34, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t5 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t5[descendant.Name] = descendant
                end
            end

            for _, v39 in ipairs(RexSwim.BONES) do
                if not t5[v39] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v40 = p34:GetPivot() * AnatomyInverse:Inverse()
            local v41 = CFrame:VectorToObjectSpace(v40.RightVector)
            local v42 = CFrame:VectorToObjectSpace(v40.UpVector)
            local Unit = v42:Cross(v41).Unit
            local v43 = -Unit
            local v44 = -v41
            local Size = MeshPart.Size
            local v47 = math.abs(v41.X) * Size.X + math.abs(v41.Y) * Size.Y + math.abs(v41.Z) * Size.Z
            local t6 = {}

            for _, v48 in ipairs(RexSwim.BONES) do
                local v49 = CFrame:ToObjectSpace(t5[v48].WorldCFrame)

                t6[v48] = {
                    bone = t5[v48],
                    nose = v49:VectorToObjectSpace(v41),
                    up = v49:VectorToObjectSpace(v42),
                    lat = v49:VectorToObjectSpace(v43),
                    pos = v49.Position,
                    M = v49.Rotation
                }
            end

            local function bodyVec(p35, p36) -- line: 170
                -- upvalues: v42 (copy), Unit (copy), v44 (copy)
                return Unit * (p36 * p35.X) + v44 * p35.Y + v42 * p35.Z
            end

            local t7 = {}
            local t8 = {}

            for _, v50 in ipairs({ "L", "R" }) do
                local v51 = if v50 == "L" then 1 else -1
                local v52 = t6["Arm_" .. v50]
                local v53 = t6["Fore_" .. v50]
                local v54 = t6["Hand_" .. v50]

                t7[#t7 + 1] = {
                    s = v51,
                    b = {
                        v52.bone,
                        v53.bone,
                        v54.bone
                    },
                    M = {
                        v52.M,
                        v53.M,
                        v54.M
                    },
                    left = Unit
                }

                local v55 = t6["Thigh_" .. v50]
                local v56 = t6["Shin_" .. v50]
                local v57 = t6["Foot_" .. v50]
                local v58 = #t8 + 1
                local t9 = {
                    s = v51,
                    b = {
                        v55.bone,
                        v56.bone,
                        v57.bone
                    },
                    M = {
                        v55.M,
                        v56.M,
                        v57.M
                    },
                    S = v55.pos,
                    E = v56.pos,
                    W = v57.pos
                }
                local LEG_POLE = RexSwim.LEG_POLE

                t9.pole = Unit * (v51 * LEG_POLE.X) + v44 * LEG_POLE.Y + v42 * LEG_POLE.Z
                t9.left = Unit
                t9.sc = v47 / RexSwim.SPEC_L
                t8[v58] = t9
            end

            return {
                turn = 0,
                v = 0,
                t = 0,
                armed = true,
                biteT0 = nil,
                model = p34,
                mesh = MeshPart,
                A = t6,
                arms = t7,
                legs = t8,
                noseM = v41,
                phase = math.random(),
                length = v47
            }
        end,
        update = function(p37, p38) -- update | line: 187
            -- upvalues: p1 (copy), fightHooked (copy)
            local RexSwim = p1.RexSwim
            local model = p37.model
            local _CFrame = p37.mesh.CFrame

            p37.t += p38

            if p37.lastPos and p38 > 1E-04 then
                local v59 = (_CFrame.Position - p37.lastPos).Magnitude / p38

                if v59 < 2000 then
                    p37.v = p37.v + (v59 - p37.v) * math.min(1, p38 / RexSwim.V_TAU)
                end
            end

            p37.lastPos = _CFrame.Position

            local v62 = _CFrame:VectorToWorldSpace(p37.noseM)
            local v63 = Vector3.new(v62.X, 0, v62.Z)

            if v63.Magnitude > 1E-04 then
                local Unit = v63.Unit

                if p37.lastFlat and p38 > 1E-04 then
                    local v65 = math.atan2(p37.lastFlat:Cross(Unit).Y, (p37.lastFlat:Dot(Unit))) / p38

                    p37.turn = p37.turn + (math.clamp(v65 / RexSwim.TURN_FULL, -1, 1) - p37.turn) * math.min(1, p38 / RexSwim.TURN_TAU)
                end

                p37.lastFlat = Unit
            end

            local v69 = math.max(p37.length, 0.001)
            local v70 = if fightHooked(model) then RexSwim.HOOK_HZ else math.clamp(p37.v / (RexSwim.STRIDE * v69), RexSwim.MIN_HZ, RexSwim.MAX_HZ)
            local v72 = RexSwim.dartOf(p37.v / v69)

            if p37.armed and RexSwim.BITE_R < v72 then
                p37.biteT0 = p37.t
                p37.armed = false
            elseif not p37.armed and v72 < RexSwim.BITE_R / 2 then
                p37.armed = true
            end

            local v73 = RexSwim.biteEnv(p37.biteT0 and p37.t - p37.biteT0 or nil)

            p37.phase = (p37.phase + p38 * v70) % 1

            local phase, turn = p37.phase, p37.turn

            for v74, v75 in pairs(RexSwim.body(phase, turn, v72, v73)) do
                local v76 = p37.A[v74]
                local v77 = CFrame.identity

                for _, v78 in ipairs(v75) do
                    v77 *= CFrame.fromAxisAngle(v76[v78[1]], v78[2])
                end

                v76.bone.Transform = v77
            end

            for _, v79 in ipairs(p37.arms) do
                local v80, v81, v82 = RexSwim.arm(v79, phase)
                local t10 = {
                    CFrame.identity,
                    v80,
                    v81,
                    v82
                }

                for i = 1, 3 do
                    v79.b[i].Transform = v79.M[i]:Inverse() * t10[i]:Inverse() * t10[i + 1] * v79.M[i]
                end
            end

            for _, v83 in ipairs(p37.legs) do
                local v84, v85, v86 = RexSwim.leg(v83, phase, turn, v72)
                local t11 = {
                    CFrame.identity,
                    v84,
                    v85,
                    v86
                }

                for j = 1, 3 do
                    v83.b[j].Transform = v83.M[j]:Inverse() * t11[j]:Inverse() * t11[j + 1] * v83.M[j]
                end
            end
        end
    }
end
