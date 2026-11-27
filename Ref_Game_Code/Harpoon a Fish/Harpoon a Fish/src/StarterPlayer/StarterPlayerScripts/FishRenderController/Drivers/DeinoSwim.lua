-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 24
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.DeinoSwim = {
        PHI0 = 0.4,
        SWING = 0.45,
        FOLD = 0.25,
        FOLD_LEAD = 0,
        HAND0 = 0.15,
        HAND = 0.4,
        HAND_LAG = 0.5,
        LEG_LAG = 0.08,
        THIGH = 0.06,
        PHI_L0 = 0,
        LSWING = 0.35,
        SPLAY = 0.1,
        TOE0 = 0.1,
        TOE = 0.2,
        TOE_LAG = 0.6,
        TURN_GAIN = 0.25,
        CHEST_ROLL = 0.06,
        CHEST_YAW = 0.04,
        PITCH = {
            { "Chest", 0.02 },
            { "Belly", 0.025 },
            { "Pelvis", 0.03 },
            { "Tail_1", 0.04 },
            { "Tail_2", 0.05 },
            { "Tail_3", 0.06 }
        },
        PLAG = 0.5,
        TAIL_YAW = {
            { "Tail_1", 0.04, 0.9 },
            { "Tail_2", 0.06, 1.5 },
            { "Tail_3", 0.08, 2.1 }
        },
        NECK_STEADY = 0.85,
        LOOK = 0.25,
        TURN_BEND = 0.1,
        STRIDE = 0.8,
        MIN_HZ = 0.25,
        MAX_HZ = 2,
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
        turnTo = function(p3, p4) -- turnTo | line: 45
            local Unit = p3.Unit
            local Unit2 = p4.Unit
            local v1 = Unit:Cross(Unit2)
            local Magnitude = v1.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v1 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p5, p6, p7, p8, p9) -- ik | line: 53
            -- upvalues: p1 (copy)
            local DeinoSwim = p1.DeinoSwim
            local Magnitude = (p6 - p5).Magnitude
            local Magnitude2 = (p7 - p6).Magnitude
            local v4 = p8 - p5
            local v6 = math.min(v4.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v4.Unit
            local Unit2 = (p9 - Unit * p9:Dot(Unit)).Unit
            local v7 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v6 * v6) / (v6 * 2)
            local v10 = math.sqrt((math.max(0, Magnitude * Magnitude - v7 * v7)))
            local v11 = p5 + Unit * v7 + Unit2 * v10
            local v12 = DeinoSwim.turnTo(p6 - p5, v11 - p5)

            return v12, DeinoSwim.turnTo(v12 * (p7 - p6), p8 - v11) * v12
        end,
        arm = function(p10, p11, p12) -- arm | line: 68
            -- upvalues: p1 (copy)
            local DeinoSwim = p1.DeinoSwim
            local s = p10.s
            local v13 = 6.283185307179586 * ((p11 + (if s == 1 then 0 else 0.5)) % 1)
            local v14 = 1 - s * DeinoSwim.TURN_GAIN * p12
            local v17 = p10.S + CFrame.fromAxisAngle(p10.left, DeinoSwim.PHI0 - DeinoSwim.SWING * v14 * math.cos(v13)) * (p10.W - p10.S) * (1 - DeinoSwim.FOLD * (1 - math.sin(v13 + DeinoSwim.FOLD_LEAD)) / 2)
            local v18, v19 = DeinoSwim.ik(p10.S, p10.E, p10.W, v17, p10.pole)

            return v18, v19, CFrame.fromAxisAngle(v19 * p10.left, DeinoSwim.HAND0 + DeinoSwim.HAND * math.sin(v13 - DeinoSwim.HAND_LAG)) * v19
        end,
        leg = function(p13, p14, p15) -- leg | line: 79
            -- upvalues: p1 (copy)
            local DeinoSwim = p1.DeinoSwim
            local s = p13.s
            local v22 = 6.283185307179586 * ((p14 + DeinoSwim.LEG_LAG + (if s == 1 then 0.5 else 0)) % 1)
            local v23 = 1 - s * DeinoSwim.TURN_GAIN * p15
            local v24 = CFrame.fromAxisAngle(p13.back, -s * DeinoSwim.SPLAY) * CFrame.fromAxisAngle(p13.left, -DeinoSwim.THIGH * v23 * math.cos(v22))
            local v25 = CFrame.fromAxisAngle(p13.left, DeinoSwim.PHI_L0 - DeinoSwim.LSWING * v23 * math.cos(v22)) * v24

            return v24, v25, CFrame.fromAxisAngle(p13.left, DeinoSwim.TOE0 - DeinoSwim.TOE * math.sin(v22 - DeinoSwim.TOE_LAG)) * v25
        end,
        body = function(p16, p17) -- body | line: 90
            -- upvalues: p1 (copy)
            local DeinoSwim = p1.DeinoSwim
            local v27 = 6.283185307179586 * p16
            local v28 = DeinoSwim.TURN_BEND * p17 / 3
            local t2 = {
                Chest = {
                    {
                        "up",
                        DeinoSwim.CHEST_YAW * math.sin(v27)
                    },
                    {
                        "nose",
                        -DeinoSwim.CHEST_ROLL * math.sin(v27)
                    }
                },
                Belly = {
                    {
                        "up",
                        v28 - DeinoSwim.CHEST_YAW * math.sin(v27)
                    }
                },
                Pelvis = { { "up", v28 } },
                Tail_1 = { { "up", v28 } }
            }
            local n1 = 0

            for v29, v30 in ipairs(DeinoSwim.PITCH) do
                local v33 = v30[2] * math.sin(2 * v27 - (v29 - 1) * DeinoSwim.PLAG)

                if v30[1] == "Chest" then
                    n1 = v33
                end

                t2[v30[1]] = t2[v30[1]] or {}
                table.insert(t2[v30[1]], {
                    "lat",
                    v33
                })
            end

            for _, v35 in ipairs(DeinoSwim.TAIL_YAW) do
                t2[v35[1]] = t2[v35[1]] or {}
                table.insert(t2[v35[1]], {
                    "up",
                    v35[2] * math.sin(v27 - v35[3])
                })
            end

            t2.Neck_1 = {
                {
                    "up",
                    -DeinoSwim.NECK_STEADY * DeinoSwim.CHEST_YAW * math.sin(v27) + DeinoSwim.LOOK * p17 / 3
                },
                {
                    "nose",
                    DeinoSwim.NECK_STEADY * DeinoSwim.CHEST_ROLL * math.sin(v27)
                },
                {
                    "lat",
                    -DeinoSwim.NECK_STEADY * n1
                }
            }
            t2.Neck_2 = {
                {
                    "up",
                    DeinoSwim.LOOK * p17 / 3
                }
            }
            t2.Neck_3 = {
                {
                    "up",
                    DeinoSwim.LOOK * p17 / 3
                }
            }

            return t2
        end,
        register = function(p18) -- register | line: 116
            -- upvalues: p1 (copy), attr (copy)
            local DeinoSwim = p1.DeinoSwim
            local MeshPart = p18:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p18, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t5 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t5[descendant.Name] = descendant
                end
            end

            for _, v39 in ipairs(DeinoSwim.BONES) do
                if not t5[v39] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v40 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v41 = CFrame:VectorToObjectSpace(v40.RightVector)
            local v42 = CFrame:VectorToObjectSpace(v40.UpVector)
            local Unit = v42:Cross(v41).Unit
            local v43 = -Unit
            local Size = MeshPart.Size
            local v46 = math.abs(v41.X) * Size.X + math.abs(v41.Y) * Size.Y + math.abs(v41.Z) * Size.Z
            local t6 = {}

            for _, v47 in ipairs(DeinoSwim.BONES) do
                local v48 = CFrame:ToObjectSpace(t5[v47].WorldCFrame)

                t6[v47] = {
                    bone = t5[v47],
                    nose = v48:VectorToObjectSpace(v41),
                    up = v48:VectorToObjectSpace(v42),
                    lat = v48:VectorToObjectSpace(v43),
                    pos = v48.Position,
                    M = v48.Rotation
                }
            end

            local t7 = {}
            local t8 = {}

            for _, v49 in ipairs({ "L", "R" }) do
                local v50 = if v49 == "L" then 1 else -1
                local v51 = t6["Arm_" .. v49]
                local v52 = t6["Fore_" .. v49]
                local v53 = t6["Hand_" .. v49]
                local pos = v51.pos
                local pos2 = v52.pos
                local pos3 = v53.pos
                local Unit2 = (pos3 - pos).Unit

                t7[#t7 + 1] = {
                    s = v50,
                    b = {
                        v51.bone,
                        v52.bone,
                        v53.bone
                    },
                    M = {
                        v51.M,
                        v52.M,
                        v53.M
                    },
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2),
                    left = Unit
                }

                local v54 = t6["Thigh_" .. v49]
                local v55 = t6["Shin_" .. v49]
                local v56 = t6["Foot_" .. v49]

                t8[#t8 + 1] = {
                    s = v50,
                    b = {
                        v54.bone,
                        v55.bone,
                        v56.bone
                    },
                    M = {
                        v54.M,
                        v55.M,
                        v56.M
                    },
                    left = Unit,
                    back = -v41
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p18,
                mesh = MeshPart,
                A = t6,
                arms = t7,
                legs = t8,
                noseM = v41,
                phase = math.random(),
                length = v46
            }
        end,
        update = function(p19, p20) -- update | line: 156
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local DeinoSwim = p1.DeinoSwim
            local model = p19.model
            local _CFrame = p19.mesh.CFrame

            if p19.lastPos and p20 > 1E-04 then
                local v57 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v57 < 2000 then
                    p19.v = p19.v + (v57 - p19.v) * math.min(1, p20 / DeinoSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v60 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v61 = Vector3.new(v60.X, 0, v60.Z)

            if v61.Magnitude > 1E-04 then
                local Unit = v61.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v63 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v63 / DeinoSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / DeinoSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local PEN_HZ = DeinoSwim.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = DeinoSwim.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(DeinoSwim.MAX_HZ, (math.max(p19.v / (DeinoSwim.STRIDE * math.max(p19.length, 0.001)), DeinoSwim.MIN_HZ)))
            end

            p19.phase = (p19.phase + p20 * PEN_HZ) % 1

            local phase, turn = p19.phase, p19.turn

            for v69, v70 in pairs(DeinoSwim.body(phase, turn)) do
                local v71 = p19.A[v69]
                local v72 = CFrame.identity

                for _, v73 in ipairs(v70) do
                    v72 *= CFrame.fromAxisAngle(v71[v73[1]], v73[2])
                end

                v71.bone.Transform = v72
            end

            for _, v74 in ipairs(p19.arms) do
                local v75, v76, v77 = DeinoSwim.arm(v74, phase, turn)
                local t9 = {
                    CFrame.identity,
                    v75,
                    v76,
                    v77
                }

                for i = 1, 3 do
                    v74.b[i].Transform = v74.M[i]:Inverse() * t9[i]:Inverse() * t9[i + 1] * v74.M[i]
                end
            end

            for _, v78 in ipairs(p19.legs) do
                local v79, v80, v81 = DeinoSwim.leg(v78, phase, turn)
                local t10 = {
                    CFrame.identity,
                    v79,
                    v80,
                    v81
                }

                for j = 1, 3 do
                    v78.b[j].Transform = v78.M[j]:Inverse() * t10[j]:Inverse() * t10[j + 1] * v78.M[j]
                end
            end
        end
    }
end
