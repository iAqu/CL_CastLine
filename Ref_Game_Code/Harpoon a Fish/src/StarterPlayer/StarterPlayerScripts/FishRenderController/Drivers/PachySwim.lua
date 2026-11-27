-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 25
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PachySwim = {
        PHI_L0 = -0.1,
        LSWING = 0.55,
        TOE0 = 0.2,
        TOE = 0.25,
        TOE_LAG = 0.6,
        THIGH = 0.1,
        RAM_KICK = 0.2,
        ARM_RATE = 2,
        PHI0 = 0.05,
        SWING = 0.35,
        TUCK = 0.45,
        HAND = 0.3,
        HAND_LAG = 0.9,
        TURN_GAIN = 0.15,
        HIP_ROLL = 0.05,
        HIP_YAW = 0.04,
        BOB = 0.025,
        TAIL_FOLLOW = 0.025,
        TAIL_STIFF = 0.008,
        CHEST_ROLL = 0.02,
        CHEST_YAW = 0.02,
        NECK_STEADY = 0.8,
        LOOK = 0.25,
        TURN_BEND = 0.12,
        RAM_NECK = 0.3,
        RAM_HEAD = 0.15,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        PASS_STRIDE = 0.8,
        PASS_MIN_HZ = 0.3,
        PASS_MAX_HZ = 4,
        HOOK_HZ = 3,
        PEN_HZ = 0.8,
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
            "Hand_L",
            "Arm_R",
            "Hand_R",
            "Thigh_L",
            "Shin_L",
            "Foot_L",
            "Thigh_R",
            "Shin_R",
            "Foot_R"
        },
        ramOf = function(p3) -- ramOf | line: 49
            -- upvalues: p1 (copy)
            local PachySwim = p1.PachySwim
            local v2 = math.clamp((p3 - PachySwim.RAM_E0) / (PachySwim.RAM_E1 - PachySwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        leg = function(p4, p5, p6, p7) -- leg | line: 55
            -- upvalues: p1 (copy)
            local PachySwim = p1.PachySwim
            local s = p4.s
            local v3 = (p5 + (if s == 1 then 0 else 0.5)) % 1
            local v4 = 1 - s * PachySwim.TURN_GAIN * p6
            local v5 = 6.283185307179586 * v3
            local v6 = CFrame.fromAxisAngle(p4.left, -PachySwim.THIGH * v4 * math.cos(v5))
            local v7 = CFrame.fromAxisAngle(p4.left, PachySwim.PHI_L0 - PachySwim.LSWING * (1 + PachySwim.RAM_KICK * p7) * v4 * math.cos(v5)) * v6

            return v6, v7, CFrame.fromAxisAngle(p4.left, PachySwim.TOE0 - PachySwim.TOE * math.sin(v5 - PachySwim.TOE_LAG)) * v7
        end,
        arm = function(p8, p9, p10, p11) -- arm | line: 67
            -- upvalues: p1 (copy)
            local PachySwim = p1.PachySwim
            local s = p8.s
            local v9 = (PachySwim.ARM_RATE * p9 + (if s == 1 then 0.5 else 0)) % 1
            local v10 = 1 - s * PachySwim.TURN_GAIN * p10
            local v14 = CFrame.fromAxisAngle(p8.left, PachySwim.PHI0 + PachySwim.TUCK * p11 - PachySwim.SWING * (1 - p11) * v10 * math.cos(6.283185307179586 * v9))

            return v14, CFrame.fromAxisAngle(p8.left, PachySwim.HAND * math.sin(6.283185307179586 * v9 - PachySwim.HAND_LAG) * (1 - p11)) * v14
        end,
        body = function(p12, p13, p14) -- body | line: 77
            -- upvalues: p1 (copy)
            local PachySwim = p1.PachySwim
            local v16 = 6.283185307179586 * p12
            local v17 = PachySwim.TURN_BEND * p13 / 3

            return {
                Chest = {
                    {
                        "up",
                        -PachySwim.CHEST_YAW * math.sin(v16)
                    },
                    {
                        "nose",
                        PachySwim.CHEST_ROLL * math.sin(v16)
                    },
                    {
                        "lat",
                        PachySwim.BOB * math.sin(2 * v16)
                    }
                },
                Belly = { { "up", v17 } },
                Pelvis = {
                    {
                        "up",
                        v17 + PachySwim.HIP_YAW * math.sin(v16)
                    },
                    {
                        "nose",
                        -PachySwim.HIP_ROLL * math.sin(v16)
                    },
                    {
                        "lat",
                        -PachySwim.BOB * math.sin(2 * v16 - 0.6)
                    }
                },
                Tail_1 = {
                    {
                        "up",
                        v17 + PachySwim.TAIL_FOLLOW * math.sin(v16 - 0.8)
                    },
                    {
                        "lat",
                        0.5 * PachySwim.BOB * math.sin(2 * v16 - 1.2)
                    }
                },
                Tail_2 = {
                    {
                        "up",
                        PachySwim.TAIL_STIFF * math.sin(v16 - 1.4)
                    }
                },
                Tail_3 = {
                    {
                        "up",
                        PachySwim.TAIL_STIFF * math.sin(v16 - 1.9)
                    }
                },
                Tail_4 = {
                    {
                        "up",
                        PachySwim.TAIL_STIFF * math.sin(v16 - 2.4)
                    }
                },
                Neck = {
                    {
                        "up",
                        PachySwim.NECK_STEADY * PachySwim.CHEST_YAW * math.sin(v16) + PachySwim.LOOK * p13 / 2
                    },
                    {
                        "lat",
                        -PachySwim.BOB * math.sin(2 * v16) - PachySwim.RAM_NECK * p14
                    }
                },
                Head = {
                    {
                        "up",
                        PachySwim.LOOK * p13 / 2
                    },
                    {
                        "lat",
                        -PachySwim.RAM_HEAD * p14
                    }
                }
            }
        end,
        register = function(p15) -- register | line: 93
            -- upvalues: p1 (copy), attr (copy)
            local PachySwim = p1.PachySwim
            local MeshPart = p15:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p15, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t9 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t9[descendant.Name] = descendant
                end
            end

            for _, v29 in ipairs(PachySwim.BONES) do
                if not t9[v29] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v30 = p15:GetPivot() * AnatomyInverse:Inverse()
            local v31 = CFrame:VectorToObjectSpace(v30.RightVector)
            local v32 = CFrame:VectorToObjectSpace(v30.UpVector)
            local Unit = v32:Cross(v31).Unit
            local v33 = -Unit
            local Size = MeshPart.Size
            local v36 = math.abs(v31.X) * Size.X + math.abs(v31.Y) * Size.Y + math.abs(v31.Z) * Size.Z
            local t10 = {}

            for _, v37 in ipairs(PachySwim.BONES) do
                local v38 = CFrame:ToObjectSpace(t9[v37].WorldCFrame)

                t10[v37] = {
                    bone = t9[v37],
                    nose = v38:VectorToObjectSpace(v31),
                    up = v38:VectorToObjectSpace(v32),
                    lat = v38:VectorToObjectSpace(v33),
                    M = v38.Rotation
                }
            end

            local t11 = {}
            local t12 = {}

            for _, v39 in ipairs({ "L", "R" }) do
                local v40 = if v39 == "L" then 1 else -1
                local v41 = t10["Arm_" .. v39]
                local v42 = t10["Hand_" .. v39]

                t11[#t11 + 1] = {
                    s = v40,
                    b = {
                        v41.bone,
                        v42.bone
                    },
                    M = {
                        v41.M,
                        v42.M
                    },
                    left = Unit
                }

                local v43 = t10["Thigh_" .. v39]
                local v44 = t10["Shin_" .. v39]
                local v45 = t10["Foot_" .. v39]

                t12[#t12 + 1] = {
                    s = v40,
                    b = {
                        v43.bone,
                        v44.bone,
                        v45.bone
                    },
                    M = {
                        v43.M,
                        v44.M,
                        v45.M
                    },
                    left = Unit
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p15,
                mesh = MeshPart,
                A = t10,
                arms = t11,
                legs = t12,
                noseM = v31,
                phase = math.random(),
                length = v36
            }
        end,
        update = function(p16, p17) -- update | line: 130
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PachySwim = p1.PachySwim
            local model = p16.model
            local _CFrame = p16.mesh.CFrame

            if p16.lastPos and p17 > 1E-04 then
                local v46 = (_CFrame.Position - p16.lastPos).Magnitude / p17

                if v46 < 2000 then
                    p16.v = p16.v + (v46 - p16.v) * math.min(1, p17 / PachySwim.V_TAU)
                end
            end

            p16.lastPos = _CFrame.Position

            local v49 = _CFrame:VectorToWorldSpace(p16.noseM)
            local v50 = Vector3.new(v49.X, 0, v49.Z)

            if v50.Magnitude > 1E-04 then
                local Unit = v50.Unit

                if p16.lastFlat and p17 > 1E-04 then
                    local v52 = math.atan2(p16.lastFlat:Cross(Unit).Y, (p16.lastFlat:Dot(Unit))) / p17

                    p16.turn = p16.turn + (math.clamp(v52 / PachySwim.TURN_FULL, -1, 1) - p16.turn) * math.min(1, p17 / PachySwim.TURN_TAU)
                end

                p16.lastFlat = Unit
            end

            local PEN_HZ = PachySwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n1 = 0

            if fightHooked(model) then
                PEN_HZ = PachySwim.HOOK_HZ
            elseif PassCruise then
                PEN_HZ = math.min(PachySwim.PASS_MAX_HZ, (math.max(p16.v / (PachySwim.PASS_STRIDE * math.max(p16.length, 0.001)), PachySwim.PASS_MIN_HZ)))
                n1 = if type(PassCruise) == "number" then PachySwim.ramOf(p16.v / math.max(PassCruise, 0.001)) else 0
            end

            p16.phase = (p16.phase + p17 * PEN_HZ) % 1

            local phase, turn = p16.phase, p16.turn

            for v58, v59 in pairs(PachySwim.body(phase, turn, n1)) do
                local v60 = p16.A[v58]
                local v61 = CFrame.identity

                for _, v62 in ipairs(v59) do
                    v61 *= CFrame.fromAxisAngle(v60[v62[1]], v62[2])
                end

                v60.bone.Transform = v61
            end

            for _, v63 in ipairs(p16.arms) do
                local v64, v65 = PachySwim.arm(v63, phase, turn, n1)
                local t13 = {
                    CFrame.identity,
                    v64,
                    v65
                }

                for i = 1, 2 do
                    v63.b[i].Transform = v63.M[i]:Inverse() * t13[i]:Inverse() * t13[i + 1] * v63.M[i]
                end
            end

            for _, v66 in ipairs(p16.legs) do
                local v67, v68, v69 = PachySwim.leg(v66, phase, turn, n1)
                local t14 = {
                    CFrame.identity,
                    v67,
                    v68,
                    v69
                }

                for j = 1, 3 do
                    v66.b[j].Transform = v66.M[j]:Inverse() * t14[j]:Inverse() * t14[j + 1] * v66.M[j]
                end
            end
        end
    }
end
