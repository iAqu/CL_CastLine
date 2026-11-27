-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 24
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.TherizSwim = {
        LOUT = 0.06,
        PHI_L0 = -0.1,
        LSWING = 0.5,
        LFOLD = 0.25,
        LREACH = 0.94,
        THIGH = 0.12,
        ANKLE_POLE = (Vector3.new(0, 1, 0.3)).Unit,
        F_PEAK = 0.25,
        AOUT = 0.045,
        ARM_LAG = 0,
        PHI0 = 0.1,
        SWING = 0.45,
        FOLDR = 0.15,
        HDIP = 0.7853981633974483,
        TURN_GAIN = 0.15,
        CHEST_ROLL = 0.05,
        CHEST_YAW = 0.03,
        HIP_ROLL = 0.05,
        BOB = 0.03,
        TAIL_YAW = {
            { 0.06, 0.9 },
            { 0.1, 1.6 },
            { 0.14, 2.3 }
        },
        TAIL_PITCH = 0.04,
        NECK_STEADY = 0.7,
        NOD = 0.025,
        LOOK = 0.25,
        TURN_BEND = 0.12,
        PASS_STRIDE = 1,
        PASS_MIN_HZ = 0.3,
        PASS_MAX_HZ = 4,
        HOOK_HZ = 2.4,
        PEN_HZ = 0.7,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPEC_L = 1.9120082,
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
        smoothF = function(p3) -- smoothF | line: 49
            -- upvalues: p1 (copy)
            local v2 = math.cos(6.283185307179586 * (p3 - p1.TherizSwim.F_PEAK)) * 0.5 + 0.5

            return v2 * v2 * (3 - v2 * 2)
        end,
        turnTo = function(p4, p5) -- turnTo | line: 55
            local Unit = p4.Unit
            local Unit2 = p5.Unit
            local v3 = Unit:Cross(Unit2)
            local Magnitude = v3.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v3 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p6, p7, p8, p9, p10) -- ik | line: 63
            -- upvalues: p1 (copy)
            local TherizSwim = p1.TherizSwim
            local Magnitude = (p7 - p6).Magnitude
            local Magnitude2 = (p8 - p7).Magnitude
            local v6 = p9 - p6
            local v8 = math.min(v6.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v6.Unit
            local Unit2 = (p10 - Unit * p10:Dot(Unit)).Unit
            local v9 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v8 * v8) / (v8 * 2)
            local v12 = math.sqrt((math.max(0, Magnitude * Magnitude - v9 * v9)))
            local v13 = p6 + Unit * v9 + Unit2 * v12
            local v14 = TherizSwim.turnTo(p7 - p6, v13 - p6)

            return v14, TherizSwim.turnTo(v14 * (p8 - p7), p9 - v13) * v14
        end,
        leg = function(p11, p12, p13) -- leg | line: 77
            -- upvalues: p1 (copy)
            local TherizSwim = p1.TherizSwim
            local s = p11.s
            local v15 = (p12 + (if s == 1 then 0 else 0.5)) % 1
            local v16 = 1 - s * TherizSwim.TURN_GAIN * p13
            local v19 = CFrame.fromAxisAngle(p11.left, -TherizSwim.THIGH * v16 * math.cos(6.283185307179586 * v15))
            local H = p11.H
            local v20 = H + v19 * (p11.K - H)
            local v21 = H + v19 * (p11.A - H)
            local v22 = H + v19 * (p11.T - H)
            local v23 = v22 + p11.left * (s * TherizSwim.LOUT * p11.sc) - v20
            local v26 = TherizSwim.PHI_L0 - TherizSwim.LSWING * v16 * math.cos(6.283185307179586 * v15)
            local v29 = v20 + CFrame.fromAxisAngle(p11.left, v26) * v23 * (TherizSwim.LREACH * (1 - TherizSwim.LFOLD * (1 - math.sin(6.283185307179586 * v15)) / 2))
            local v30, v31 = TherizSwim.ik(v20, v21, v22, v29, v19 * p11.anklePole)

            return v19, v30 * v19, v31 * v19
        end,
        arm = function(p14, p15, p16) -- arm | line: 91
            -- upvalues: p1 (copy)
            local TherizSwim = p1.TherizSwim
            local s = p14.s
            local v32 = (p15 + TherizSwim.ARM_LAG + (if s == 1 then 0.5 else 0)) % 1
            local v33 = 1 - s * TherizSwim.TURN_GAIN * p16
            local v34 = p14.W + p14.left * (s * TherizSwim.AOUT * p14.sc) - p14.S
            local v37 = TherizSwim.PHI0 - TherizSwim.SWING * v33 * math.cos(6.283185307179586 * v32)
            local v40 = p14.S + CFrame.fromAxisAngle(p14.left, v37) * v34 * (1 - TherizSwim.FOLDR * (1 - math.sin(6.283185307179586 * v32)) / 2)
            local v41, v42 = TherizSwim.ik(p14.S, p14.E, p14.W, v40, p14.pole)
            local v43 = TherizSwim.smoothF(v32)

            return v41, v42, CFrame.fromAxisAngle(v42 * p14.hinge0, -TherizSwim.HDIP * v43) * v42
        end,
        body = function(p17, p18) -- body | line: 105
            -- upvalues: p1 (copy)
            local TherizSwim = p1.TherizSwim
            local v44 = 6.283185307179586 * p17
            local v45 = TherizSwim.TURN_BEND * p18 / 3
            local t2 = {
                Chest = {
                    {
                        "up",
                        TherizSwim.CHEST_YAW * math.sin(v44 - 0.5)
                    },
                    {
                        "nose",
                        TherizSwim.CHEST_ROLL * math.sin(v44)
                    },
                    {
                        "lat",
                        TherizSwim.BOB * math.sin(2 * v44)
                    }
                },
                Belly = { { "up", v45 } },
                Pelvis = {
                    {
                        "up",
                        v45
                    },
                    {
                        "nose",
                        -TherizSwim.HIP_ROLL * math.sin(v44)
                    },
                    {
                        "lat",
                        -TherizSwim.BOB * math.sin(2 * v44 - 0.6)
                    }
                },
                Neck_1 = {
                    {
                        "up",
                        -TherizSwim.NECK_STEADY * TherizSwim.CHEST_YAW * math.sin(v44 - 0.5) + TherizSwim.LOOK * p18 / 3
                    },
                    {
                        "lat",
                        -TherizSwim.BOB * math.sin(2 * v44) + TherizSwim.NOD * math.sin(2 * v44 - 1)
                    }
                },
                Neck_2 = {
                    {
                        "up",
                        TherizSwim.LOOK * p18 / 3
                    }
                },
                Neck_3 = {
                    {
                        "up",
                        TherizSwim.LOOK * p18 / 3
                    },
                    {
                        "lat",
                        -TherizSwim.NOD * math.sin(2 * v44 - 1)
                    }
                }
            }

            for v58, v59 in ipairs(TherizSwim.TAIL_YAW) do
                t2["Tail_" .. v58] = {
                    {
                        "up",
                        v59[1] * math.sin(v44 - v59[2]) + (v58 == 1 and v45 or 0)
                    },
                    {
                        "lat",
                        TherizSwim.TAIL_PITCH * math.sin(2 * v44 - v59[2])
                    }
                }
            end

            return t2
        end,
        register = function(p19) -- register | line: 122
            -- upvalues: p1 (copy), attr (copy)
            local TherizSwim = p1.TherizSwim
            local MeshPart = p19:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p19, "AnatomyInverse")
            local t12 = {
                HandTipL = attr(p19, "HandTipL"),
                HandTipR = attr(p19, "HandTipR"),
                ToeTipL = attr(p19, "ToeTipL"),
                ToeTipR = attr(p19, "ToeTipR")
            }

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            for _, v65 in pairs(t12) do
                if typeof(v65) ~= "Vector3" then
                    return nil
                end
            end

            local t13 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t13[descendant.Name] = descendant
                end
            end

            for _, v66 in ipairs(TherizSwim.BONES) do
                if not t13[v66] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v67 = p19:GetPivot() * AnatomyInverse:Inverse()
            local v68 = CFrame:VectorToObjectSpace(v67.RightVector)
            local v69 = CFrame:VectorToObjectSpace(v67.UpVector)
            local Unit = v69:Cross(v68).Unit
            local v70 = -Unit
            local Size = MeshPart.Size
            local v73 = math.abs(v68.X) * Size.X + math.abs(v68.Y) * Size.Y + math.abs(v68.Z) * Size.Z
            local v74 = v73 / TherizSwim.SPEC_L
            local t14 = {}

            for _, v75 in ipairs(TherizSwim.BONES) do
                local v76 = CFrame:ToObjectSpace(t13[v75].WorldCFrame)

                t14[v75] = {
                    bone = t13[v75],
                    nose = v76:VectorToObjectSpace(v68),
                    up = v76:VectorToObjectSpace(v69),
                    lat = v76:VectorToObjectSpace(v70),
                    pos = v76.Position,
                    M = v76.Rotation
                }
            end

            local v77 = -v68
            local ANKLE_POLE = TherizSwim.ANKLE_POLE
            local Unit2 = (Unit * ANKLE_POLE.X + v77 * ANKLE_POLE.Y + v69 * ANKLE_POLE.Z).Unit
            local t15 = {}
            local t16 = {}

            for _, v78 in ipairs({ "L", "R" }) do
                local v79 = if v78 == "L" then 1 else -1
                local v80 = t14["Arm_" .. v78]
                local v81 = t14["Fore_" .. v78]
                local v82 = t14["Hand_" .. v78]
                local pos = v80.pos
                local pos2 = v81.pos
                local pos3 = v82.pos
                local v83 = t12["HandTip" .. v78] * Size
                local Unit3 = (pos3 - pos).Unit

                t15[#t15 + 1] = {
                    s = v79,
                    b = {
                        v80.bone,
                        v81.bone,
                        v82.bone
                    },
                    M = {
                        v80.M,
                        v81.M,
                        v82.M
                    },
                    S = pos,
                    E = pos2,
                    W = pos3,
                    pole = pos2 - pos - Unit3 * (pos2 - pos):Dot(Unit3),
                    hinge0 = (v83 - pos3):Cross(v69).Unit,
                    left = Unit,
                    sc = v74
                }

                local v84 = t14["Thigh_" .. v78]
                local v85 = t14["Shin_" .. v78]
                local v86 = t14["Foot_" .. v78]

                t16[#t16 + 1] = {
                    s = v79,
                    b = {
                        v84.bone,
                        v85.bone,
                        v86.bone
                    },
                    M = {
                        v84.M,
                        v85.M,
                        v86.M
                    },
                    H = v84.pos,
                    K = v85.pos,
                    A = v86.pos,
                    T = t12["ToeTip" .. v78] * Size,
                    left = Unit,
                    anklePole = Unit2,
                    sc = v74
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p19,
                mesh = MeshPart,
                A = t14,
                arms = t15,
                legs = t16,
                noseM = v68,
                phase = math.random(),
                length = v73
            }
        end,
        update = function(p20, p21) -- update | line: 172
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local TherizSwim = p1.TherizSwim
            local model = p20.model
            local _CFrame = p20.mesh.CFrame

            if p20.lastPos and p21 > 1E-04 then
                local v87 = (_CFrame.Position - p20.lastPos).Magnitude / p21

                if v87 < 2000 then
                    p20.v = p20.v + (v87 - p20.v) * math.min(1, p21 / TherizSwim.V_TAU)
                end
            end

            p20.lastPos = _CFrame.Position

            local v90 = _CFrame:VectorToWorldSpace(p20.noseM)
            local v91 = Vector3.new(v90.X, 0, v90.Z)

            if v91.Magnitude > 1E-04 then
                local Unit = v91.Unit

                if p20.lastFlat and p21 > 1E-04 then
                    local v93 = math.atan2(p20.lastFlat:Cross(Unit).Y, (p20.lastFlat:Dot(Unit))) / p21

                    p20.turn = p20.turn + (math.clamp(v93 / TherizSwim.TURN_FULL, -1, 1) - p20.turn) * math.min(1, p21 / TherizSwim.TURN_TAU)
                end

                p20.lastFlat = Unit
            end

            local v97 = if fightHooked(model) then TherizSwim.HOOK_HZ elseif attr(model, "PassCruise") then math.min(TherizSwim.PASS_MAX_HZ, (math.max(p20.v / (TherizSwim.PASS_STRIDE * math.max(p20.length, 0.001)), TherizSwim.PASS_MIN_HZ))) else TherizSwim.PEN_HZ

            p20.phase = (p20.phase + p21 * v97) % 1

            local phase, turn = p20.phase, p20.turn

            for v100, v101 in pairs(TherizSwim.body(phase, turn)) do
                local v102 = p20.A[v100]
                local v103 = CFrame.identity

                for _, v104 in ipairs(v101) do
                    v103 *= CFrame.fromAxisAngle(v102[v104[1]], v104[2])
                end

                v102.bone.Transform = v103
            end

            for _, v105 in ipairs(p20.arms) do
                local v106, v107, v108 = TherizSwim.arm(v105, phase, turn)
                local t17 = {
                    CFrame.identity,
                    v106,
                    v107,
                    v108
                }

                for i = 1, 3 do
                    v105.b[i].Transform = v105.M[i]:Inverse() * t17[i]:Inverse() * t17[i + 1] * v105.M[i]
                end
            end

            for _, v109 in ipairs(p20.legs) do
                local v110, v111, v112 = TherizSwim.leg(v109, phase, turn)
                local t18 = {
                    CFrame.identity,
                    v110,
                    v111,
                    v112
                }

                for j = 1, 3 do
                    v109.b[j].Transform = v109.M[j]:Inverse() * t18[j]:Inverse() * t18[j + 1] * v109.M[j]
                end
            end
        end
    }
end
