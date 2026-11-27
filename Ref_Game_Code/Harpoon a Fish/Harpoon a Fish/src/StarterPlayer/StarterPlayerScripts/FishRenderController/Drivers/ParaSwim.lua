-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 23
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ParaSwim = {
        THIGH_A = 0.12,
        THIGH_PH = 3.14,
        SPLAY = 0.12,
        SHIN0 = -0.42,
        SHIN_A = 0.42,
        FOOT0 = 0,
        FOOT = 0.6,
        FOOT_LAG = 0.5,
        ARM_PH = 0.62,
        PHI0 = 0.1,
        SWING = 0.4,
        FOLD = 0.25,
        HAND0 = 0.1,
        HAND = 0.35,
        HAND_LAG = 0.6,
        TURN_GAIN = 0.15,
        TAIL = {
            { "Tail_1", 0.12, 1.6 },
            { "Tail_2", 0.04, 2.1 },
            { "Tail_3", 0.05, 2.6 },
            { "Tail_4", 0.06, 3.1 }
        },
        PEL_YAW = 0.03,
        PEL_LAG = 1.4,
        CHEST_YAW = 0.025,
        CHEST_LAG = 1.2,
        ROLL = 0.05,
        ROLL_LAG = 0,
        CHEST_ROLL = 0.025,
        CHEST_ROLL_LAG = 0.5,
        PITCH = {
            { "Chest", 0.012 },
            { "Pelvis", 0.018 }
        },
        PLAG = 0.6,
        NECK_STEADY = 0.85,
        LOOK = 0.15,
        BEND = 0.1,
        TAIL_BEND = 0.08,
        STRIDE = 0.7,
        MIN_HZ = 0.25,
        MAX_HZ = 3.2,
        HOOK_HZ = 1.8,
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
            "Neck_1",
            "Neck_2",
            "Neck_3",
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
        turnTo = function(p3, p4) -- turnTo | line: 48
            local Unit = p3.Unit
            local Unit2 = p4.Unit
            local v1 = Unit:Cross(Unit2)
            local Magnitude = v1.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v1 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p5, p6, p7, p8, p9) -- ik | line: 56
            -- upvalues: p1 (copy)
            local ParaSwim = p1.ParaSwim
            local Magnitude = (p6 - p5).Magnitude
            local Magnitude2 = (p7 - p6).Magnitude
            local v4 = p8 - p5
            local v6 = math.min(v4.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v4.Unit
            local Unit2 = (p9 - Unit * p9:Dot(Unit)).Unit
            local v7 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v6 * v6) / (v6 * 2)
            local v10 = math.sqrt((math.max(0, Magnitude * Magnitude - v7 * v7)))
            local v11 = p5 + Unit * v7 + Unit2 * v10
            local v12 = ParaSwim.turnTo(p6 - p5, v11 - p5)

            return v12, ParaSwim.turnTo(v12:VectorToWorldSpace(p7 - p6), p8 - v11) * v12
        end,
        arm = function(p10, p11, p12) -- arm | line: 71
            -- upvalues: p1 (copy)
            local ParaSwim = p1.ParaSwim
            local s = p10.s
            local v13 = 6.283185307179586 * ((p11 + ParaSwim.ARM_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v14 = 1 - s * ParaSwim.TURN_GAIN * p12
            local v15 = p10.S + CFrame.fromAxisAngle(p10.left, ParaSwim.PHI0 - ParaSwim.SWING * v14 * math.cos(v13)):VectorToWorldSpace(p10.W - p10.S) * (1 - ParaSwim.FOLD * (1 - math.sin(v13)) / 2)
            local v16, v17 = ParaSwim.ik(p10.S, p10.E, p10.W, v15, p10.pole)

            return v16, v17, CFrame.fromAxisAngle(v17:VectorToWorldSpace(p10.left), ParaSwim.HAND0 + ParaSwim.HAND * math.sin(v13 - ParaSwim.HAND_LAG)) * v17
        end,
        leg = function(p13, p14, p15) -- leg | line: 82
            -- upvalues: p1 (copy)
            local ParaSwim = p1.ParaSwim
            local s = p13.s
            local v20 = 6.283185307179586 * ((p14 + (if s == 1 then 0 else 0.5)) % 1)
            local v21 = 1 - s * ParaSwim.TURN_GAIN * p15
            local v24 = CFrame.fromAxisAngle(p13.back, -s * ParaSwim.SPLAY) * CFrame.fromAxisAngle(p13.left, ParaSwim.THIGH_A * math.sin(v20 + ParaSwim.THIGH_PH))
            local v25 = CFrame.fromAxisAngle(v24:VectorToWorldSpace(p13.left), ParaSwim.SHIN0 - v21 * ParaSwim.SHIN_A * math.cos(v20)) * v24

            return v24, v25, CFrame.fromAxisAngle(v25:VectorToWorldSpace(p13.left), ParaSwim.FOOT0 - ParaSwim.FOOT * math.sin(v20 - ParaSwim.FOOT_LAG)) * v25
        end,
        body = function(p16, p17) -- body | line: 93
            -- upvalues: p1 (copy)
            local ParaSwim = p1.ParaSwim
            local v28 = 6.283185307179586 * p16
            local v30 = ParaSwim.CHEST_YAW * math.sin(v28 - ParaSwim.CHEST_LAG)
            local v32 = ParaSwim.CHEST_ROLL * math.sin(v28 - ParaSwim.CHEST_ROLL_LAG)
            local t2 = {
                Chest = {
                    { "up", v30 },
                    { "nose", v32 }
                },
                Belly = {
                    {
                        "up",
                        -v30 + ParaSwim.BEND * p17 / 3
                    }
                },
                Pelvis = {
                    {
                        "up",
                        -ParaSwim.PEL_YAW * math.sin(v28 - ParaSwim.PEL_LAG) + ParaSwim.BEND * p17 / 3
                    },
                    {
                        "nose",
                        -ParaSwim.ROLL * math.sin(v28 - ParaSwim.ROLL_LAG)
                    }
                }
            }

            for _, v37 in ipairs(ParaSwim.TAIL) do
                t2[v37[1]] = {
                    {
                        "up",
                        -v37[2] * math.sin(v28 - v37[3]) + (v37[1] == "Tail_1" and ParaSwim.BEND / 3 or ParaSwim.TAIL_BEND / 3) * p17
                    }
                }
            end

            local n1 = 0

            for v42, v43 in ipairs(ParaSwim.PITCH) do
                local v46 = v43[2] * math.sin(2 * v28 - (v42 - 1) * ParaSwim.PLAG)

                if v43[1] == "Chest" then
                    n1 = v46
                end

                t2[v43[1]] = t2[v43[1]] or {}
                table.insert(t2[v43[1]], {
                    "lat",
                    v46
                })
            end

            t2.Neck_1 = {
                {
                    "up",
                    -ParaSwim.NECK_STEADY * v30 + ParaSwim.LOOK * p17 / 3
                },
                {
                    "nose",
                    -ParaSwim.NECK_STEADY * v32
                },
                {
                    "lat",
                    -ParaSwim.NECK_STEADY * n1
                }
            }
            t2.Neck_2 = {
                {
                    "up",
                    ParaSwim.LOOK * p17 / 3
                }
            }
            t2.Neck_3 = {
                {
                    "up",
                    ParaSwim.LOOK * p17 / 3
                }
            }

            return t2
        end,
        register = function(p18) -- register | line: 118
            -- upvalues: p1 (copy), attr (copy)
            local ParaSwim = p1.ParaSwim
            local MeshPart = p18:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p18, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t7 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t7[descendant.Name] = descendant
                end
            end

            for _, v48 in ipairs(ParaSwim.BONES) do
                if not t7[v48] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v49 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v50 = CFrame:VectorToObjectSpace(v49.RightVector)
            local v51 = CFrame:VectorToObjectSpace(v49.UpVector)
            local Unit = v51:Cross(v50).Unit
            local v52 = -Unit
            local Size = MeshPart.Size
            local v55 = math.abs(v50.X) * Size.X + math.abs(v50.Y) * Size.Y + math.abs(v50.Z) * Size.Z
            local t8 = {}

            for _, v56 in ipairs(ParaSwim.BONES) do
                local v57 = CFrame:ToObjectSpace(t7[v56].WorldCFrame)

                t8[v56] = {
                    bone = t7[v56],
                    nose = v57:VectorToObjectSpace(v50),
                    up = v57:VectorToObjectSpace(v51),
                    lat = v57:VectorToObjectSpace(v52),
                    pos = v57.Position,
                    M = v57.Rotation
                }
            end

            local t9 = {}
            local t10 = {}

            for _, v58 in ipairs({ "L", "R" }) do
                local v59 = if v58 == "L" then 1 else -1
                local v60 = t8["Arm_" .. v58]
                local v61 = t8["Fore_" .. v58]
                local v62 = t8["Hand_" .. v58]
                local pos = v60.pos
                local pos2 = v61.pos
                local pos3 = v62.pos
                local Unit2 = (pos3 - pos).Unit

                t9[#t9 + 1] = {
                    s = v59,
                    b = {
                        v60.bone,
                        v61.bone,
                        v62.bone
                    },
                    M = {
                        v60.M,
                        v61.M,
                        v62.M
                    },
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2),
                    left = Unit
                }

                local v63 = t8["Thigh_" .. v58]
                local v64 = t8["Shin_" .. v58]
                local v65 = t8["Foot_" .. v58]

                t10[#t10 + 1] = {
                    s = v59,
                    b = {
                        v63.bone,
                        v64.bone,
                        v65.bone
                    },
                    M = {
                        v63.M,
                        v64.M,
                        v65.M
                    },
                    left = Unit,
                    back = -v50
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p18,
                mesh = MeshPart,
                A = t8,
                arms = t9,
                legs = t10,
                noseM = v50,
                phase = math.random(),
                length = v55
            }
        end,
        update = function(p19, p20) -- update | line: 158
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local ParaSwim = p1.ParaSwim
            local model = p19.model
            local _CFrame = p19.mesh.CFrame

            if p19.lastPos and p20 > 1E-04 then
                local v66 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v66 < 2000 then
                    p19.v = p19.v + (v66 - p19.v) * math.min(1, p20 / ParaSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v69 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v70 = Vector3.new(v69.X, 0, v69.Z)

            if v70.Magnitude > 1E-04 then
                local Unit = v70.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v72 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v72 / ParaSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / ParaSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local PEN_HZ = ParaSwim.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = ParaSwim.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(ParaSwim.MAX_HZ, (math.max(p19.v / (ParaSwim.STRIDE * math.max(p19.length, 0.001)), ParaSwim.MIN_HZ)))
            end

            p19.phase = (p19.phase + p20 * PEN_HZ) % 1

            local phase, turn = p19.phase, p19.turn

            for v78, v79 in pairs(ParaSwim.body(phase, turn)) do
                local v80 = p19.A[v78]
                local v81 = CFrame.identity

                for _, v82 in ipairs(v79) do
                    v81 *= CFrame.fromAxisAngle(v80[v82[1]], v82[2])
                end

                v80.bone.Transform = v81
            end

            for _, v83 in ipairs(p19.arms) do
                local v84, v85, v86 = ParaSwim.arm(v83, phase, turn)
                local t11 = {
                    CFrame.identity,
                    v84,
                    v85,
                    v86
                }

                for i = 1, 3 do
                    v83.b[i].Transform = v83.M[i]:Inverse() * t11[i]:Inverse() * t11[i + 1] * v83.M[i]
                end
            end

            for _, v87 in ipairs(p19.legs) do
                local v88, v89, v90 = ParaSwim.leg(v87, phase, turn)
                local t12 = {
                    CFrame.identity,
                    v88,
                    v89,
                    v90
                }

                for j = 1, 3 do
                    v87.b[j].Transform = v87.M[j]:Inverse() * t12[j]:Inverse() * t12[j + 1] * v87.M[j]
                end
            end
        end
    }
end
