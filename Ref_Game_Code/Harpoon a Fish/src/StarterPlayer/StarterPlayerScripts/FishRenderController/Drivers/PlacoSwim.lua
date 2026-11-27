-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 24
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PlacoSwim = {
        WAVE = {
            { "Chest", 0.02 },
            { "Belly", 0.03 },
            { "Pelvis", 0.05 },
            { "Tail_1", 0.11 },
            { "Tail_2", 0.16 },
            { "Tail_3", 0.2 },
            { "Tail_4", 0.24 },
            { "Tail_5", 0.26 }
        },
        LAG = 0.55,
        HEAD_STEADY = 0.8,
        HEAD_UP = 0,
        BEND = 0.12,
        LOOK = 0.22,
        ARM_PH = 0.186,
        AOUT = 0,
        PHI0 = 0.15,
        SWING = 0.3,
        LIFT = 0.15,
        FOLD = 0,
        TWIST = 0.9,
        TW_SPLIT = 0.5,
        HAND0 = 0,
        HAND = 0.1,
        HAND_LAG = 0.9,
        TURN_GAIN = 0.3,
        LEG_PH = 0.432,
        FOLD_H = 0.3,
        PADDLE = 0.28,
        STEER = 0.2,
        SHIN_TRAIL = 0.1,
        FOOT = 0.15,
        FOOT_LAG = 0.6,
        STRIDE = 0.8,
        MIN_HZ = 0.25,
        MAX_HZ = 2.2,
        HOOK_HZ = 1.8,
        PEN_HZ = 0.5,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPEC_L = 1.9014972,
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
        turnTo = function(p3, p4) -- turnTo | line: 47
            local Unit = p3.Unit
            local Unit2 = p4.Unit
            local v1 = Unit:Cross(Unit2)
            local Magnitude = v1.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v1 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p5, p6, p7, p8, p9) -- ik | line: 55
            -- upvalues: p1 (copy)
            local PlacoSwim = p1.PlacoSwim
            local Magnitude = (p6 - p5).Magnitude
            local Magnitude2 = (p7 - p6).Magnitude
            local v4 = p8 - p5
            local v6 = math.min(v4.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v4.Unit
            local Unit2 = (p9 - Unit * p9:Dot(Unit)).Unit
            local v7 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v6 * v6) / (v6 * 2)
            local v10 = math.sqrt((math.max(0, Magnitude * Magnitude - v7 * v7)))
            local v11 = p5 + Unit * v7 + Unit2 * v10
            local v12 = PlacoSwim.turnTo(p6 - p5, v11 - p5)

            return v12, PlacoSwim.turnTo(v12 * (p7 - p6), p8 - v11) * v12
        end,
        arm = function(p10, p11, p12) -- arm | line: 70
            -- upvalues: p1 (copy)
            local PlacoSwim = p1.PlacoSwim
            local s = p10.s
            local v13 = 6.283185307179586 * ((p11 + PlacoSwim.ARM_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v14 = 1 - s * PlacoSwim.TURN_GAIN * p12
            local v15 = p10.W + p10.left * (s * PlacoSwim.AOUT * p10.sc) - p10.S
            local v16 = CFrame.fromAxisAngle(p10.up, s * (PlacoSwim.PHI0 - PlacoSwim.SWING * v14 * math.cos(v13))) * CFrame.fromAxisAngle(p10.back, s * PlacoSwim.LIFT * math.sin(v13))
            local v17 = p10.S + v16 * v15 * (1 - PlacoSwim.FOLD * (1 - math.sin(v13)) / 2)
            local v18, v19 = PlacoSwim.ik(p10.S, p10.E, p10.W, v17, p10.pole)
            local v20 = s * PlacoSwim.TWIST * (math.sin(v13) * 0.5 + 0.5)
            local v21 = CFrame.fromAxisAngle((v17 - p10.S).Unit, v20 * PlacoSwim.TW_SPLIT)
            local v22 = v21 * v18
            local v23 = v21 * v19
            local v24 = CFrame.fromAxisAngle((v23 * (p10.W - p10.E)).Unit, v20 * (1 - PlacoSwim.TW_SPLIT)) * v23

            return v22, v24, CFrame.fromAxisAngle(v24 * p10.left, PlacoSwim.HAND0 + PlacoSwim.HAND * math.sin(v13 - PlacoSwim.HAND_LAG)) * v24
        end,
        leg = function(p13, p14, p15) -- leg | line: 89
            -- upvalues: p1 (copy)
            local PlacoSwim = p1.PlacoSwim
            local s = p13.s
            local v27 = 6.283185307179586 * ((p14 + PlacoSwim.LEG_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v28 = CFrame.fromAxisAngle(p13.up, s * (PlacoSwim.FOLD_H + PlacoSwim.PADDLE * math.cos(v27)) - PlacoSwim.STEER * p15)
            local v29 = CFrame.fromAxisAngle(p13.up, s * PlacoSwim.SHIN_TRAIL) * v28

            return v28, v29, CFrame.fromAxisAngle(p13.left, PlacoSwim.FOOT * math.sin(v27 - PlacoSwim.FOOT_LAG)) * v29
        end,
        body = function(p16, p17) -- body | line: 99
            -- upvalues: p1 (copy)
            local PlacoSwim = p1.PlacoSwim
            local v31 = 6.283185307179586 * p16
            local t2 = {}
            local n1 = 0

            for v32, v33 in ipairs(PlacoSwim.WAVE) do
                local v36 = v33[2] * math.sin(v31 - (v32 - 1) * PlacoSwim.LAG)

                if v33[1] == "Chest" then
                    n1 = v36
                    t2[v33[1]] = { { "up", v36 } }
                else
                    t2[v33[1]] = {
                        {
                            "up",
                            v36 + PlacoSwim.BEND * p17 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -PlacoSwim.HEAD_STEADY * n1 + PlacoSwim.LOOK * p17 / 2
                },
                {
                    "lat",
                    PlacoSwim.HEAD_UP
                }
            }
            t2.Head = {
                {
                    "up",
                    PlacoSwim.LOOK * p17 / 2
                }
            }

            return t2
        end,
        register = function(p18) -- register | line: 117
            -- upvalues: p1 (copy), attr (copy)
            local PlacoSwim = p1.PlacoSwim
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

            for _, v37 in ipairs(PlacoSwim.BONES) do
                if not t3[v37] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v38 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v39 = CFrame:VectorToObjectSpace(v38.RightVector)
            local v40 = CFrame:VectorToObjectSpace(v38.UpVector)
            local Unit = v40:Cross(v39).Unit
            local v41 = -Unit
            local Size = MeshPart.Size
            local v44 = math.abs(v39.X) * Size.X + math.abs(v39.Y) * Size.Y + math.abs(v39.Z) * Size.Z
            local v45 = v44 / PlacoSwim.SPEC_L
            local t4 = {}

            for _, v46 in ipairs(PlacoSwim.BONES) do
                local v47 = CFrame:ToObjectSpace(t3[v46].WorldCFrame)

                t4[v46] = {
                    bone = t3[v46],
                    nose = v47:VectorToObjectSpace(v39),
                    up = v47:VectorToObjectSpace(v40),
                    lat = v47:VectorToObjectSpace(v41),
                    pos = v47.Position,
                    M = v47.Rotation
                }
            end

            local t5 = {}
            local t6 = {}

            for _, v48 in ipairs({ "L", "R" }) do
                local v49 = if v48 == "L" then 1 else -1
                local v50 = t4["Arm_" .. v48]
                local v51 = t4["Fore_" .. v48]
                local v52 = t4["Hand_" .. v48]
                local pos = v50.pos
                local pos2 = v51.pos
                local pos3 = v52.pos
                local Unit2 = (pos3 - pos).Unit

                t5[#t5 + 1] = {
                    s = v49,
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
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2),
                    left = Unit,
                    up = v40,
                    back = -v39,
                    sc = v45
                }

                local v53 = t4["Thigh_" .. v48]
                local v54 = t4["Shin_" .. v48]
                local v55 = t4["Foot_" .. v48]

                t6[#t6 + 1] = {
                    s = v49,
                    b = {
                        v53.bone,
                        v54.bone,
                        v55.bone
                    },
                    M = {
                        v53.M,
                        v54.M,
                        v55.M
                    },
                    left = Unit,
                    up = v40
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
                noseM = v39,
                phase = math.random(),
                length = v44
            }
        end,
        update = function(p19, p20) -- update | line: 158
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PlacoSwim = p1.PlacoSwim
            local model = p19.model
            local _CFrame = p19.mesh.CFrame

            if p19.lastPos and p20 > 1E-04 then
                local v56 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v56 < 2000 then
                    p19.v = p19.v + (v56 - p19.v) * math.min(1, p20 / PlacoSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v59 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v60 = Vector3.new(v59.X, 0, v59.Z)

            if v60.Magnitude > 1E-04 then
                local Unit = v60.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v62 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v62 / PlacoSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / PlacoSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local PEN_HZ = PlacoSwim.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = PlacoSwim.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(PlacoSwim.MAX_HZ, (math.max(p19.v / (PlacoSwim.STRIDE * math.max(p19.length, 0.001)), PlacoSwim.MIN_HZ)))
            end

            p19.phase = (p19.phase + p20 * PEN_HZ) % 1

            local phase, turn = p19.phase, p19.turn

            for v68, v69 in pairs(PlacoSwim.body(phase, turn)) do
                local v70 = p19.A[v68]
                local v71 = CFrame.identity

                for _, v72 in ipairs(v69) do
                    v71 *= CFrame.fromAxisAngle(v70[v72[1]], v72[2])
                end

                v70.bone.Transform = v71
            end

            for _, v73 in ipairs(p19.arms) do
                local v74, v75, v76 = PlacoSwim.arm(v73, phase, turn)
                local t7 = {
                    CFrame.identity,
                    v74,
                    v75,
                    v76
                }

                for i = 1, 3 do
                    v73.b[i].Transform = v73.M[i]:Inverse() * t7[i]:Inverse() * t7[i + 1] * v73.M[i]
                end
            end

            for _, v77 in ipairs(p19.legs) do
                local v78, v79, v80 = PlacoSwim.leg(v77, phase, turn)
                local t8 = {
                    CFrame.identity,
                    v78,
                    v79,
                    v80
                }

                for j = 1, 3 do
                    v77.b[j].Transform = v77.M[j]:Inverse() * t8[j]:Inverse() * t8[j + 1] * v77.M[j]
                end
            end
        end
    }
end
