-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 21
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.MegaSwim = {
        WAVE = {
            { "Chest", 0.03 },
            { "Belly", 0.05 },
            { "Pelvis", 0.07 },
            { "Tail_1", 0.1 },
            { "Tail_2", 0.14 },
            { "Tail_3", 0.18 },
            { "Tail_4", 0.21 },
            { "Tail_5", 0.23 }
        },
        LAG = 0.55,
        HEAD_STEADY = 0.8,
        HEAD_UP = 0.06,
        BEND = 0.12,
        LOOK = 0.22,
        ARM_PH = 0.186,
        AOUT = 0,
        PHI0 = 0.3,
        SWING = 0.38,
        LIFT = 0.15,
        FOLD = 0.15,
        HAND0 = 0.1,
        HAND = 0.3,
        HAND_LAG = 0.9,
        TURN_GAIN = 0.3,
        LEG_PH = 0.432,
        FOLD_H = 0.3,
        PADDLE = 0.15,
        STEER = 0.3,
        SHIN_TRAIL = 0.1,
        FOOT = 0.2,
        FOOT_LAG = 0.6,
        STRIDE = 1,
        MIN_HZ = 0.25,
        MAX_HZ = 2,
        HOOK_HZ = 1.8,
        PEN_HZ = 0.5,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPEC_L = 1.9052219,
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
        turnTo = function(p3, p4) -- turnTo | line: 43
            local Unit = p3.Unit
            local Unit2 = p4.Unit
            local v1 = Unit:Cross(Unit2)
            local Magnitude = v1.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v1 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p5, p6, p7, p8, p9) -- ik | line: 51
            -- upvalues: p1 (copy)
            local MegaSwim = p1.MegaSwim
            local Magnitude = (p6 - p5).Magnitude
            local Magnitude2 = (p7 - p6).Magnitude
            local v4 = p8 - p5
            local v6 = math.min(v4.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v4.Unit
            local Unit2 = (p9 - Unit * p9:Dot(Unit)).Unit
            local v7 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v6 * v6) / (v6 * 2)
            local v10 = math.sqrt((math.max(0, Magnitude * Magnitude - v7 * v7)))
            local v11 = p5 + Unit * v7 + Unit2 * v10
            local v12 = MegaSwim.turnTo(p6 - p5, v11 - p5)

            return v12, MegaSwim.turnTo(v12 * (p7 - p6), p8 - v11) * v12
        end,
        arm = function(p10, p11, p12) -- arm | line: 66
            -- upvalues: p1 (copy)
            local MegaSwim = p1.MegaSwim
            local s = p10.s
            local v13 = 6.283185307179586 * ((p11 + MegaSwim.ARM_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v14 = 1 - s * MegaSwim.TURN_GAIN * p12
            local v15 = p10.W + p10.left * (s * MegaSwim.AOUT * p10.sc) - p10.S
            local v16 = CFrame.fromAxisAngle(p10.up, s * (MegaSwim.PHI0 - MegaSwim.SWING * v14 * math.cos(v13))) * CFrame.fromAxisAngle(p10.back, s * MegaSwim.LIFT * math.sin(v13))
            local v17 = p10.S + v16 * v15 * (1 - MegaSwim.FOLD * (1 - math.sin(v13)) / 2)
            local v18, v19 = MegaSwim.ik(p10.S, p10.E, p10.W, v17, p10.pole)

            return v18, v19, CFrame.fromAxisAngle(v19 * p10.left, MegaSwim.HAND0 + MegaSwim.HAND * math.sin(v13 - MegaSwim.HAND_LAG)) * v19
        end,
        leg = function(p13, p14, p15) -- leg | line: 79
            -- upvalues: p1 (copy)
            local MegaSwim = p1.MegaSwim
            local s = p13.s
            local v22 = 6.283185307179586 * ((p14 + MegaSwim.LEG_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v23 = CFrame.fromAxisAngle(p13.up, s * (MegaSwim.FOLD_H + MegaSwim.PADDLE * math.cos(v22)) - MegaSwim.STEER * p15)
            local v24 = CFrame.fromAxisAngle(p13.up, s * MegaSwim.SHIN_TRAIL) * v23

            return v23, v24, CFrame.fromAxisAngle(p13.left, MegaSwim.FOOT * math.sin(v22 - MegaSwim.FOOT_LAG)) * v24
        end,
        body = function(p16, p17) -- body | line: 89
            -- upvalues: p1 (copy)
            local MegaSwim = p1.MegaSwim
            local v26 = 6.283185307179586 * p16
            local t2 = {}
            local n1 = 0

            for v27, v28 in ipairs(MegaSwim.WAVE) do
                local v31 = v28[2] * math.sin(v26 - (v27 - 1) * MegaSwim.LAG)

                if v28[1] == "Chest" then
                    n1 = v31
                    t2[v28[1]] = { { "up", v31 } }
                else
                    t2[v28[1]] = {
                        {
                            "up",
                            v31 + MegaSwim.BEND * p17 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -MegaSwim.HEAD_STEADY * n1 + MegaSwim.LOOK * p17 / 2
                },
                {
                    "lat",
                    MegaSwim.HEAD_UP
                }
            }
            t2.Head = {
                {
                    "up",
                    MegaSwim.LOOK * p17 / 2
                }
            }

            return t2
        end,
        register = function(p18) -- register | line: 107
            -- upvalues: p1 (copy), attr (copy)
            local MegaSwim = p1.MegaSwim
            local MeshPart = p18:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p18, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t3 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t3[descendant.Name] = descendant
                end
            end

            for _, v32 in ipairs(MegaSwim.BONES) do
                if not t3[v32] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v33 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v34 = CFrame:VectorToObjectSpace(v33.RightVector)
            local v35 = CFrame:VectorToObjectSpace(v33.UpVector)
            local Unit = v35:Cross(v34).Unit
            local v36 = -Unit
            local Size = MeshPart.Size
            local v39 = math.abs(v34.X) * Size.X + math.abs(v34.Y) * Size.Y + math.abs(v34.Z) * Size.Z
            local v40 = v39 / MegaSwim.SPEC_L
            local t4 = {}

            for _, v41 in ipairs(MegaSwim.BONES) do
                local v42 = CFrame:ToObjectSpace(t3[v41].WorldCFrame)

                t4[v41] = {
                    bone = t3[v41],
                    nose = v42:VectorToObjectSpace(v34),
                    up = v42:VectorToObjectSpace(v35),
                    lat = v42:VectorToObjectSpace(v36),
                    pos = v42.Position,
                    M = v42.Rotation
                }
            end

            local t5 = {}
            local t6 = {}

            for _, v43 in ipairs({ "L", "R" }) do
                local v44 = if v43 == "L" then 1 else -1
                local v45 = t4["Arm_" .. v43]
                local v46 = t4["Fore_" .. v43]
                local v47 = t4["Hand_" .. v43]
                local pos = v45.pos
                local pos2 = v46.pos
                local pos3 = v47.pos
                local Unit2 = (pos3 - pos).Unit

                t5[#t5 + 1] = {
                    s = v44,
                    b = {
                        v45.bone,
                        v46.bone,
                        v47.bone
                    },
                    M = {
                        v45.M,
                        v46.M,
                        v47.M
                    },
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2),
                    left = Unit,
                    up = v35,
                    back = -v34,
                    sc = v40
                }

                local v48 = t4["Thigh_" .. v43]
                local v49 = t4["Shin_" .. v43]
                local v50 = t4["Foot_" .. v43]

                t6[#t6 + 1] = {
                    s = v44,
                    b = {
                        v48.bone,
                        v49.bone,
                        v50.bone
                    },
                    M = {
                        v48.M,
                        v49.M,
                        v50.M
                    },
                    left = Unit,
                    up = v35
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p18,
                mesh = MeshPart,
                A = t4,
                arms = t5,
                legs = t6,
                noseM = v34,
                phase = math.random(),
                length = v39
            }
        end,
        update = function(p19, p20) -- update | line: 148
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local MegaSwim = p1.MegaSwim
            local model = p19.model
            local _CFrame = p19.mesh.CFrame

            if p19.lastPos and p20 > 1E-04 then
                local v51 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v51 < 2000 then
                    p19.v = p19.v + (v51 - p19.v) * math.min(1, p20 / MegaSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v54 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v55 = Vector3.new(v54.X, 0, v54.Z)

            if v55.Magnitude > 1E-04 then
                local Unit = v55.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v57 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v57 / MegaSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / MegaSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local PEN_HZ = MegaSwim.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = MegaSwim.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(MegaSwim.MAX_HZ, (math.max(p19.v / (MegaSwim.STRIDE * math.max(p19.length, 0.001)), MegaSwim.MIN_HZ)))
            end

            p19.phase = (p19.phase + p20 * PEN_HZ) % 1

            local phase, turn = p19.phase, p19.turn

            for v63, v64 in pairs(MegaSwim.body(phase, turn)) do
                local v65 = p19.A[v63]
                local v66 = CFrame.identity

                for _, v67 in ipairs(v64) do
                    v66 *= CFrame.fromAxisAngle(v65[v67[1]], v67[2])
                end

                v65.bone.Transform = v66
            end

            for _, v68 in ipairs(p19.arms) do
                local v69, v70, v71 = MegaSwim.arm(v68, phase, turn)
                local t7 = {
                    CFrame.identity,
                    v69,
                    v70,
                    v71
                }

                for i = 1, 3 do
                    v68.b[i].Transform = v68.M[i]:Inverse() * t7[i]:Inverse() * t7[i + 1] * v68.M[i]
                end
            end

            for _, v72 in ipairs(p19.legs) do
                local v73, v74, v75 = MegaSwim.leg(v72, phase, turn)
                local t8 = {
                    CFrame.identity,
                    v73,
                    v74,
                    v75
                }

                for j = 1, 3 do
                    v72.b[j].Transform = v72.M[j]:Inverse() * t8[j]:Inverse() * t8[j + 1] * v72.M[j]
                end
            end
        end
    }
end
