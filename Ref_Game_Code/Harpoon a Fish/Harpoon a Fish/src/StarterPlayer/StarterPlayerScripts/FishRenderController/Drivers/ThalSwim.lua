-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 25
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ThalSwim = {
        AOUT = 0.02,
        PHI0 = -0.25,
        SWING = 0.55,
        FOLD = 0.15,
        FOLD_LEAD = 0.6,
        HOOK0 = 0.1,
        HOOK = 0.35,
        HOOK_LAG = 0.3,
        RAM_SWING = 0.25,
        PHI_L0 = 0,
        LSWING = 0.35,
        THIGH = 0.06,
        TOE0 = 0.1,
        TOE = 0.25,
        TOE_LAG = 0.6,
        RAM_KICK = 0.25,
        TURN_GAIN = 0.25,
        CHEST_ROLL = 0.06,
        CHEST_YAW = 0.05,
        BOB = 0.02,
        HIP_ROLL = 0.03,
        TAIL_SWAY = {
            { 0.03, 0.9 },
            { 0.025, 1.5 },
            { 0.02, 2.1 }
        },
        RUDDER = 0.1,
        NECK_STEADY = 0.8,
        LOOK = 0.25,
        TURN_BEND = 0.1,
        RAM_NECK = 0.15,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        PASS_STRIDE = 1.1,
        PASS_MIN_HZ = 0.25,
        PASS_MAX_HZ = 3.5,
        HOOK_HZ = 2,
        PEN_HZ = 0.6,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPEC_L = 1.8924831,
        BONES = {
            "Chest",
            "Belly",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Tail_3",
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
        ramOf = function(p3) -- ramOf | line: 51
            -- upvalues: p1 (copy)
            local ThalSwim = p1.ThalSwim
            local v2 = math.clamp((p3 - ThalSwim.RAM_E0) / (ThalSwim.RAM_E1 - ThalSwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        turnTo = function(p4, p5) -- turnTo | line: 57
            local Unit = p4.Unit
            local Unit2 = p5.Unit
            local v3 = Unit:Cross(Unit2)
            local Magnitude = v3.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v3 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p6, p7, p8, p9, p10) -- ik | line: 65
            -- upvalues: p1 (copy)
            local ThalSwim = p1.ThalSwim
            local Magnitude = (p7 - p6).Magnitude
            local Magnitude2 = (p8 - p7).Magnitude
            local v6 = p9 - p6
            local v8 = math.min(v6.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v6.Unit
            local Unit2 = (p10 - Unit * p10:Dot(Unit)).Unit
            local v9 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v8 * v8) / (v8 * 2)
            local v12 = math.sqrt((math.max(0, Magnitude * Magnitude - v9 * v9)))
            local v13 = p6 + Unit * v9 + Unit2 * v12
            local v14 = ThalSwim.turnTo(p7 - p6, v13 - p6)

            return v14, ThalSwim.turnTo(v14 * (p8 - p7), p9 - v13) * v14
        end,
        arm = function(p11, p12, p13, p14) -- arm | line: 80
            -- upvalues: p1 (copy)
            local ThalSwim = p1.ThalSwim
            local s = p11.s
            local v15 = (p12 + (if s == 1 then 0 else 0.5)) % 1
            local v16 = 1 - s * ThalSwim.TURN_GAIN * p13
            local v17 = p11.W + p11.left * (s * ThalSwim.AOUT * p11.sc) - p11.S
            local v20 = ThalSwim.PHI0 - ThalSwim.SWING * (1 + ThalSwim.RAM_SWING * p14) * v16 * math.cos(6.283185307179586 * v15)
            local v23 = p11.S + CFrame.fromAxisAngle(p11.left, v20) * v17 * (1 - ThalSwim.FOLD * (1 - math.sin(6.283185307179586 * v15 + ThalSwim.FOLD_LEAD)) / 2)
            local v24, v25 = ThalSwim.ik(p11.S, p11.E, p11.W, v23, p11.pole)

            return v24, v25, CFrame.fromAxisAngle(v25 * p11.left, ThalSwim.HOOK0 + ThalSwim.HOOK * math.sin(6.283185307179586 * v15 - ThalSwim.HOOK_LAG)) * v25
        end,
        leg = function(p15, p16, p17, p18) -- leg | line: 93
            -- upvalues: p1 (copy)
            local ThalSwim = p1.ThalSwim
            local s = p15.s
            local v28 = (p16 + (if s == 1 then 0.5 else 0)) % 1
            local v29 = 1 - s * ThalSwim.TURN_GAIN * p17
            local v30 = 6.283185307179586 * v28
            local v31 = CFrame.fromAxisAngle(p15.left, -ThalSwim.THIGH * v29 * math.cos(v30))
            local v32 = CFrame.fromAxisAngle(p15.left, ThalSwim.PHI_L0 - ThalSwim.LSWING * (1 + ThalSwim.RAM_KICK * p18) * v29 * math.cos(v30)) * v31

            return v31, v32, CFrame.fromAxisAngle(p15.left, ThalSwim.TOE0 - ThalSwim.TOE * math.sin(v30 - ThalSwim.TOE_LAG)) * v32
        end,
        body = function(p19, p20, p21) -- body | line: 105
            -- upvalues: p1 (copy)
            local ThalSwim = p1.ThalSwim
            local v34 = 6.283185307179586 * p19
            local v35 = ThalSwim.TURN_BEND * p20 / 2
            local t2 = {
                Chest = {
                    {
                        "up",
                        ThalSwim.CHEST_YAW * math.sin(v34)
                    },
                    {
                        "nose",
                        -ThalSwim.CHEST_ROLL * math.sin(v34)
                    },
                    {
                        "lat",
                        ThalSwim.BOB * math.sin(2 * v34)
                    }
                },
                Belly = {
                    {
                        "up",
                        v35 - ThalSwim.CHEST_YAW * math.sin(v34)
                    }
                },
                Pelvis = {
                    {
                        "up",
                        v35
                    },
                    {
                        "nose",
                        ThalSwim.HIP_ROLL * math.sin(v34)
                    },
                    {
                        "lat",
                        -ThalSwim.BOB * math.sin(2 * v34 - 0.6)
                    }
                },
                Neck = {
                    {
                        "up",
                        -ThalSwim.NECK_STEADY * ThalSwim.CHEST_YAW * math.sin(v34) + ThalSwim.LOOK * p20 / 2
                    },
                    {
                        "nose",
                        ThalSwim.NECK_STEADY * ThalSwim.CHEST_ROLL * math.sin(v34)
                    },
                    {
                        "lat",
                        -ThalSwim.BOB * math.sin(2 * v34) - ThalSwim.RAM_NECK * p21
                    }
                },
                Head = {
                    {
                        "up",
                        ThalSwim.LOOK * p20 / 2
                    }
                }
            }

            for v41, v42 in ipairs(ThalSwim.TAIL_SWAY) do
                t2["Tail_" .. v41] = {
                    {
                        "up",
                        v42[1] * math.sin(v34 - v42[2]) + ThalSwim.RUDDER * p20 / 3
                    }
                }
            end

            return t2
        end,
        register = function(p22) -- register | line: 121
            -- upvalues: p1 (copy), attr (copy)
            local ThalSwim = p1.ThalSwim
            local MeshPart = p22:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p22, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t9 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t9[descendant.Name] = descendant
                end
            end

            for _, v46 in ipairs(ThalSwim.BONES) do
                if not t9[v46] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v47 = p22:GetPivot() * AnatomyInverse:Inverse()
            local v48 = CFrame:VectorToObjectSpace(v47.RightVector)
            local v49 = CFrame:VectorToObjectSpace(v47.UpVector)
            local Unit = v49:Cross(v48).Unit
            local v50 = -Unit
            local Size = MeshPart.Size
            local v53 = math.abs(v48.X) * Size.X + math.abs(v48.Y) * Size.Y + math.abs(v48.Z) * Size.Z
            local v54 = v53 / ThalSwim.SPEC_L
            local t10 = {}

            for _, v55 in ipairs(ThalSwim.BONES) do
                local v56 = CFrame:ToObjectSpace(t9[v55].WorldCFrame)

                t10[v55] = {
                    bone = t9[v55],
                    nose = v56:VectorToObjectSpace(v48),
                    up = v56:VectorToObjectSpace(v49),
                    lat = v56:VectorToObjectSpace(v50),
                    pos = v56.Position,
                    M = v56.Rotation
                }
            end

            local t11 = {}
            local t12 = {}

            for _, v57 in ipairs({ "L", "R" }) do
                local v58 = if v57 == "L" then 1 else -1
                local v59 = t10["Arm_" .. v57]
                local v60 = t10["Fore_" .. v57]
                local v61 = t10["Hand_" .. v57]
                local pos = v59.pos
                local pos2 = v60.pos
                local pos3 = v61.pos
                local Unit2 = (pos3 - pos).Unit

                t11[#t11 + 1] = {
                    s = v58,
                    b = {
                        v59.bone,
                        v60.bone,
                        v61.bone
                    },
                    M = {
                        v59.M,
                        v60.M,
                        v61.M
                    },
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2),
                    left = Unit,
                    sc = v54
                }

                local v62 = t10["Thigh_" .. v57]
                local v63 = t10["Shin_" .. v57]
                local v64 = t10["Foot_" .. v57]

                t12[#t12 + 1] = {
                    s = v58,
                    b = {
                        v62.bone,
                        v63.bone,
                        v64.bone
                    },
                    M = {
                        v62.M,
                        v63.M,
                        v64.M
                    },
                    left = Unit
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p22,
                mesh = MeshPart,
                A = t10,
                arms = t11,
                legs = t12,
                noseM = v48,
                phase = math.random(),
                length = v53
            }
        end,
        update = function(p23, p24) -- update | line: 162
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local ThalSwim = p1.ThalSwim
            local model = p23.model
            local _CFrame = p23.mesh.CFrame

            if p23.lastPos and p24 > 1E-04 then
                local v65 = (_CFrame.Position - p23.lastPos).Magnitude / p24

                if v65 < 2000 then
                    p23.v = p23.v + (v65 - p23.v) * math.min(1, p24 / ThalSwim.V_TAU)
                end
            end

            p23.lastPos = _CFrame.Position

            local v68 = _CFrame:VectorToWorldSpace(p23.noseM)
            local v69 = Vector3.new(v68.X, 0, v68.Z)

            if v69.Magnitude > 1E-04 then
                local Unit = v69.Unit

                if p23.lastFlat and p24 > 1E-04 then
                    local v71 = math.atan2(p23.lastFlat:Cross(Unit).Y, (p23.lastFlat:Dot(Unit))) / p24

                    p23.turn = p23.turn + (math.clamp(v71 / ThalSwim.TURN_FULL, -1, 1) - p23.turn) * math.min(1, p24 / ThalSwim.TURN_TAU)
                end

                p23.lastFlat = Unit
            end

            local PEN_HZ = ThalSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n1 = 0

            if fightHooked(model) then
                PEN_HZ = ThalSwim.HOOK_HZ
            elseif PassCruise then
                PEN_HZ = math.min(ThalSwim.PASS_MAX_HZ, (math.max(p23.v / (ThalSwim.PASS_STRIDE * math.max(p23.length, 0.001)), ThalSwim.PASS_MIN_HZ)))
                n1 = if type(PassCruise) == "number" then ThalSwim.ramOf(p23.v / math.max(PassCruise, 0.001)) else 0
            end

            p23.phase = (p23.phase + p24 * PEN_HZ) % 1

            local phase, turn = p23.phase, p23.turn

            for v77, v78 in pairs(ThalSwim.body(phase, turn, n1)) do
                local v79 = p23.A[v77]
                local v80 = CFrame.identity

                for _, v81 in ipairs(v78) do
                    v80 *= CFrame.fromAxisAngle(v79[v81[1]], v81[2])
                end

                v79.bone.Transform = v80
            end

            for _, v82 in ipairs(p23.arms) do
                local v83, v84, v85 = ThalSwim.arm(v82, phase, turn, n1)
                local t13 = {
                    CFrame.identity,
                    v83,
                    v84,
                    v85
                }

                for i = 1, 3 do
                    v82.b[i].Transform = v82.M[i]:Inverse() * t13[i]:Inverse() * t13[i + 1] * v82.M[i]
                end
            end

            for _, v86 in ipairs(p23.legs) do
                local v87, v88, v89 = ThalSwim.leg(v86, phase, turn, n1)
                local t14 = {
                    CFrame.identity,
                    v87,
                    v88,
                    v89
                }

                for j = 1, 3 do
                    v86.b[j].Transform = v86.M[j]:Inverse() * t14[j]:Inverse() * t14[j + 1] * v86.M[j]
                end
            end
        end
    }
end
