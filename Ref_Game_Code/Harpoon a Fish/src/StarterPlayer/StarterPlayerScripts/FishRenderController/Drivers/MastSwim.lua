-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 25
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.MastSwim = {
        WAVE = {
            { "Chest", 0.015 },
            { "Belly", 0.025 },
            { "Pelvis", 0.045 },
            { "Tail_1", 0.09 },
            { "Tail_2", 0.15 },
            { "Tail_3", 0.21 },
            { "Tail_4", 0.26 }
        },
        LAG = 0.6,
        RAM_TAIL = 0.5,
        HEAD_STEADY = 0.85,
        BEND = 0.12,
        LOOK = 0.2,
        RAM_NECK = 0.08,
        ARM_PH = 0.2,
        PHI0 = 0.45,
        SWING = 0.12,
        LIFT = 0.06,
        FOLD = 0.06,
        HAND0 = 0.2,
        HAND = 0.15,
        HAND_LAG = 0.9,
        RAM_TUCK = 0.25,
        TURN_GAIN = 0.3,
        LEG_PH = 0.45,
        FOLD_H = 0.32,
        PADDLE = 0.12,
        STEER = 0.12,
        SHIN_TRAIL = 0.15,
        FOOT = 0.2,
        FOOT_LAG = 0.6,
        RAM_TUCK_L = 0.12,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        STRIDE = 0.8,
        MIN_HZ = 0.25,
        MAX_HZ = 2.5,
        HOOK_HZ = 1.8,
        PEN_HZ = 0.4,
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
        ramOf = function(p3) -- ramOf | line: 50
            -- upvalues: p1 (copy)
            local MastSwim = p1.MastSwim
            local v2 = math.clamp((p3 - MastSwim.RAM_E0) / (MastSwim.RAM_E1 - MastSwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        turnTo = function(p4, p5) -- turnTo | line: 56
            local Unit = p4.Unit
            local Unit2 = p5.Unit
            local v3 = Unit:Cross(Unit2)
            local Magnitude = v3.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v3 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p6, p7, p8, p9, p10) -- ik | line: 64
            -- upvalues: p1 (copy)
            local MastSwim = p1.MastSwim
            local Magnitude = (p7 - p6).Magnitude
            local Magnitude2 = (p8 - p7).Magnitude
            local v6 = p9 - p6
            local v8 = math.min(v6.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v6.Unit
            local Unit2 = (p10 - Unit * p10:Dot(Unit)).Unit
            local v9 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v8 * v8) / (v8 * 2)
            local v12 = math.sqrt((math.max(0, Magnitude * Magnitude - v9 * v9)))
            local v13 = p6 + Unit * v9 + Unit2 * v12
            local v14 = MastSwim.turnTo(p7 - p6, v13 - p6)

            return v14, MastSwim.turnTo(v14 * (p8 - p7), p9 - v13) * v14
        end,
        arm = function(p11, p12, p13, p14) -- arm | line: 79
            -- upvalues: p1 (copy)
            local MastSwim = p1.MastSwim
            local s = p11.s
            local v15 = 6.283185307179586 * ((p12 + MastSwim.ARM_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v16 = 1 - s * MastSwim.TURN_GAIN * p13
            local v17 = CFrame.fromAxisAngle(p11.up, s * (MastSwim.PHI0 + MastSwim.RAM_TUCK * p14 - MastSwim.SWING * (1 - p14) * v16 * math.cos(v15))) * CFrame.fromAxisAngle(p11.back, s * MastSwim.LIFT * (1 - p14) * math.sin(v15))
            local v18 = p11.S + v17 * (p11.W - p11.S) * (1 - MastSwim.FOLD * (1 - math.sin(v15)) / 2)
            local v19, v20 = MastSwim.ik(p11.S, p11.E, p11.W, v18, p11.pole)

            return v19, v20, CFrame.fromAxisAngle(v20 * p11.left, MastSwim.HAND0 + MastSwim.HAND * (1 - p14) * math.sin(v15 - MastSwim.HAND_LAG)) * v20
        end,
        leg = function(p15, p16, p17, p18) -- leg | line: 91
            -- upvalues: p1 (copy)
            local MastSwim = p1.MastSwim
            local s = p15.s
            local v24 = 6.283185307179586 * ((p16 + MastSwim.LEG_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v25 = CFrame.fromAxisAngle(p15.up, s * (MastSwim.FOLD_H + MastSwim.RAM_TUCK_L * p18 + MastSwim.PADDLE * (1 - p18) * math.cos(v24)) - MastSwim.STEER * p17)
            local v26 = CFrame.fromAxisAngle(p15.up, s * MastSwim.SHIN_TRAIL) * v25

            return v25, v26, CFrame.fromAxisAngle(p15.left, MastSwim.FOOT * (1 - p18) * math.sin(v24 - MastSwim.FOOT_LAG)) * v26
        end,
        body = function(p19, p20, p21) -- body | line: 101
            -- upvalues: p1 (copy)
            local MastSwim = p1.MastSwim
            local v29 = 6.283185307179586 * p19
            local t2 = {}
            local n1 = 0

            for v30, v31 in ipairs(MastSwim.WAVE) do
                local v34 = v31[2] * (1 + (v30 >= 3 and MastSwim.RAM_TAIL * p21 or 0)) * math.sin(v29 - (v30 - 1) * MastSwim.LAG)

                if v31[1] == "Chest" then
                    n1 = v34
                    t2[v31[1]] = { { "up", v34 } }
                else
                    t2[v31[1]] = {
                        {
                            "up",
                            v34 + MastSwim.BEND * p20 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -MastSwim.HEAD_STEADY * n1 + MastSwim.LOOK * p20 / 2
                },
                {
                    "lat",
                    MastSwim.RAM_NECK * p21
                }
            }
            t2.Head = {
                {
                    "up",
                    MastSwim.LOOK * p20 / 2
                }
            }

            return t2
        end,
        register = function(p22) -- register | line: 119
            -- upvalues: p1 (copy), attr (copy)
            local MastSwim = p1.MastSwim
            local MeshPart = p22:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p22, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t3 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t3[descendant.Name] = descendant
                end
            end

            for _, v35 in ipairs(MastSwim.BONES) do
                if not t3[v35] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v36 = p22:GetPivot() * AnatomyInverse:Inverse()
            local v37 = CFrame:VectorToObjectSpace(v36.RightVector)
            local v38 = CFrame:VectorToObjectSpace(v36.UpVector)
            local Unit = v38:Cross(v37).Unit
            local v39 = -Unit
            local Size = MeshPart.Size
            local v42 = math.abs(v37.X) * Size.X + math.abs(v37.Y) * Size.Y + math.abs(v37.Z) * Size.Z
            local t4 = {}

            for _, v43 in ipairs(MastSwim.BONES) do
                local v44 = CFrame:ToObjectSpace(t3[v43].WorldCFrame)

                t4[v43] = {
                    bone = t3[v43],
                    nose = v44:VectorToObjectSpace(v37),
                    up = v44:VectorToObjectSpace(v38),
                    lat = v44:VectorToObjectSpace(v39),
                    pos = v44.Position,
                    M = v44.Rotation
                }
            end

            local t5 = {}
            local t6 = {}

            for _, v45 in ipairs({ "L", "R" }) do
                local v46 = if v45 == "L" then 1 else -1
                local v47 = t4["Arm_" .. v45]
                local v48 = t4["Fore_" .. v45]
                local v49 = t4["Hand_" .. v45]
                local pos = v47.pos
                local pos2 = v48.pos
                local pos3 = v49.pos
                local Unit2 = (pos3 - pos).Unit

                t5[#t5 + 1] = {
                    s = v46,
                    b = {
                        v47.bone,
                        v48.bone,
                        v49.bone
                    },
                    M = {
                        v47.M,
                        v48.M,
                        v49.M
                    },
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2),
                    left = Unit,
                    up = v38,
                    back = -v37
                }

                local v50 = t4["Thigh_" .. v45]
                local v51 = t4["Shin_" .. v45]
                local v52 = t4["Foot_" .. v45]

                t6[#t6 + 1] = {
                    s = v46,
                    b = {
                        v50.bone,
                        v51.bone,
                        v52.bone
                    },
                    M = {
                        v50.M,
                        v51.M,
                        v52.M
                    },
                    left = Unit,
                    up = v38
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p22,
                mesh = MeshPart,
                A = t4,
                arms = t5,
                legs = t6,
                noseM = v37,
                phase = math.random(),
                length = v42
            }
        end,
        update = function(p23, p24) -- update | line: 159
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local MastSwim = p1.MastSwim
            local model = p23.model
            local _CFrame = p23.mesh.CFrame

            if p23.lastPos and p24 > 1E-04 then
                local v53 = (_CFrame.Position - p23.lastPos).Magnitude / p24

                if v53 < 2000 then
                    p23.v = p23.v + (v53 - p23.v) * math.min(1, p24 / MastSwim.V_TAU)
                end
            end

            p23.lastPos = _CFrame.Position

            local v56 = _CFrame:VectorToWorldSpace(p23.noseM)
            local v57 = Vector3.new(v56.X, 0, v56.Z)

            if v57.Magnitude > 1E-04 then
                local Unit = v57.Unit

                if p23.lastFlat and p24 > 1E-04 then
                    local v59 = math.atan2(p23.lastFlat:Cross(Unit).Y, (p23.lastFlat:Dot(Unit))) / p24

                    p23.turn = p23.turn + (math.clamp(v59 / MastSwim.TURN_FULL, -1, 1) - p23.turn) * math.min(1, p24 / MastSwim.TURN_TAU)
                end

                p23.lastFlat = Unit
            end

            local PEN_HZ = MastSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = MastSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(MastSwim.MAX_HZ, (math.max(p23.v / (MastSwim.STRIDE * math.max(p23.length, 0.001)), MastSwim.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then MastSwim.ramOf(p23.v / math.max(PassCruise, 0.001)) else 0
            end

            p23.phase = (p23.phase + p24 * PEN_HZ) % 1

            local phase, turn = p23.phase, p23.turn

            for v65, v66 in pairs(MastSwim.body(phase, turn, n2)) do
                local v67 = p23.A[v65]
                local v68 = CFrame.identity

                for _, v69 in ipairs(v66) do
                    v68 *= CFrame.fromAxisAngle(v67[v69[1]], v69[2])
                end

                v67.bone.Transform = v68
            end

            for _, v70 in ipairs(p23.arms) do
                local v71, v72, v73 = MastSwim.arm(v70, phase, turn, n2)
                local t7 = {
                    CFrame.identity,
                    v71,
                    v72,
                    v73
                }

                for i = 1, 3 do
                    v70.b[i].Transform = v70.M[i]:Inverse() * t7[i]:Inverse() * t7[i + 1] * v70.M[i]
                end
            end

            for _, v74 in ipairs(p23.legs) do
                local v75, v76, v77 = MastSwim.leg(v74, phase, turn, n2)
                local t8 = {
                    CFrame.identity,
                    v75,
                    v76,
                    v77
                }

                for j = 1, 3 do
                    v74.b[j].Transform = v74.M[j]:Inverse() * t8[j]:Inverse() * t8[j + 1] * v74.M[j]
                end
            end
        end
    }
end
