-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 18
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.CarnoSwim = {
        SKEW = 0.35,
        KN = 1.1746,
        LEG_PH = 0,
        SIDE_LAG = 0.03,
        TURN_GAIN = 0.3,
        CHEST_P = 0.03,
        CHEST_LAG = 0.05,
        NECK_STEADY = 0.85,
        TAIL_LAG = 0.08,
        BEND = 0.1,
        RUDDER = 0.12,
        LOOK = 0.2,
        STRIDE = 1,
        MIN_HZ = 0.5,
        MAX_HZ = 4,
        HOOK_HZ = 3,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        LEGB = { "Thigh", "Shin", "Foot", "Toes" },
        LAG = {
            Thigh = 0,
            Shin = 0.06,
            Foot = 0.12,
            Toes = 0.18
        },
        AMP = {
            Thigh = 0.12,
            Shin = 0.7,
            Foot = 0.45,
            Toes = 0.35
        },
        TAIL_P = { 0.02, 0.03, 0.04, 0.05, 0.05 },
        TAILS = { "Tail_1", "Tail_2", "Tail_3", "Tail_4", "Tail_5" },
        BONES = {
            "Chest",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Tail_3",
            "Tail_4",
            "Tail_5",
            "Neck",
            "Head",
            "Thigh_L",
            "Shin_L",
            "Foot_L",
            "Toes_L",
            "Thigh_R",
            "Shin_R",
            "Foot_R",
            "Toes_R"
        },
        kick = function(p3) -- kick | line: 39
            -- upvalues: p1 (copy)
            local CarnoSwim = p1.CarnoSwim
            local v1 = 6.283185307179586 * (p3 % 1)

            return (1 + (math.sin(v1) + CarnoSwim.SKEW * math.sin(2 * v1)) / CarnoSwim.KN) / 2
        end,
        leg = function(p4, p5, p6) -- leg | line: 45
            -- upvalues: p1 (copy)
            local CarnoSwim = p1.CarnoSwim
            local s = p4.s
            local v4 = 1 - s * CarnoSwim.TURN_GAIN * p6
            local t2 = {}
            local v5 = CFrame.identity

            for v6, v7 in ipairs(CarnoSwim.LEGB) do
                local v8 = p5 + CarnoSwim.LEG_PH - CarnoSwim.LAG[v7] - (if s == 1 then 0 else CarnoSwim.SIDE_LAG)

                v5 = CFrame.fromAxisAngle(p4.left, -CarnoSwim.AMP[v7] * v4 * (1 - CarnoSwim.kick(v8))) * v5
                t2[v6] = v5
            end

            return t2
        end,
        body = function(p7, p8) -- body | line: 58
            -- upvalues: p1 (copy)
            local CarnoSwim = p1.CarnoSwim
            local v9 = CarnoSwim.CHEST_P * (CarnoSwim.kick(p7 - CarnoSwim.CHEST_LAG) - 0.5)
            local t3 = {
                Chest = { { "lat", -v9 } },
                Neck = {
                    {
                        "lat",
                        CarnoSwim.NECK_STEADY * v9
                    },
                    {
                        "up",
                        CarnoSwim.LOOK * p8 / 2
                    }
                },
                Head = {
                    {
                        "up",
                        CarnoSwim.LOOK * p8 / 2
                    }
                },
                Pelvis = {
                    {
                        "up",
                        CarnoSwim.BEND * p8 / 3
                    }
                }
            }

            for v10, v11 in ipairs(CarnoSwim.TAILS) do
                t3[v11] = {
                    {
                        "lat",
                        CarnoSwim.TAIL_P[v10] * (CarnoSwim.kick(p7 - v10 * CarnoSwim.TAIL_LAG) - 0.5)
                    },
                    {
                        "up",
                        (v10 <= 2 and CarnoSwim.BEND * p8 / 3 or 0) + CarnoSwim.RUDDER * p8 / 5
                    }
                }
            end

            return t3
        end,
        register = function(p9) -- register | line: 72
            -- upvalues: p1 (copy), attr (copy)
            local CarnoSwim = p1.CarnoSwim
            local MeshPart = p9:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p9, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t7 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t7[descendant.Name] = descendant
                end
            end

            for _, v13 in ipairs(CarnoSwim.BONES) do
                if not t7[v13] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v14 = p9:GetPivot() * AnatomyInverse:Inverse()
            local v15 = CFrame:VectorToObjectSpace(v14.RightVector)
            local v16 = CFrame:VectorToObjectSpace(v14.UpVector)
            local Unit = v16:Cross(v15).Unit
            local v17 = -Unit
            local Size = MeshPart.Size
            local v20 = math.abs(v15.X) * Size.X + math.abs(v15.Y) * Size.Y + math.abs(v15.Z) * Size.Z
            local t8 = {}

            for _, v21 in ipairs(CarnoSwim.BONES) do
                local v22 = CFrame:ToObjectSpace(t7[v21].WorldCFrame)

                t8[v21] = {
                    bone = t7[v21],
                    nose = v22:VectorToObjectSpace(v15),
                    up = v22:VectorToObjectSpace(v16),
                    lat = v22:VectorToObjectSpace(v17),
                    M = v22.Rotation
                }
            end

            local t9 = {}

            for _, v23 in ipairs({ "L", "R" }) do
                local t10 = {}
                local t11 = {}

                for v24, v25 in ipairs(CarnoSwim.LEGB) do
                    t10[v24] = t8[v25 .. "_" .. v23].bone
                    t11[v24] = t8[v25 .. "_" .. v23].M
                end

                t9[#t9 + 1] = {
                    s = v23 == "L" and 1 or -1,
                    b = t10,
                    M = t11,
                    left = Unit
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p9,
                mesh = MeshPart,
                A = t8,
                legs = t9,
                noseM = v15,
                phase = math.random(),
                length = v20
            }
        end,
        update = function(p10, p11) -- update | line: 110
            -- upvalues: p1 (copy), fightHooked (copy)
            local CarnoSwim = p1.CarnoSwim
            local model = p10.model
            local _CFrame = p10.mesh.CFrame

            if p10.lastPos and p11 > 1E-04 then
                local v27 = (_CFrame.Position - p10.lastPos).Magnitude / p11

                if v27 < 2000 then
                    p10.v = p10.v + (v27 - p10.v) * math.min(1, p11 / CarnoSwim.V_TAU)
                end
            end

            p10.lastPos = _CFrame.Position

            local v30 = _CFrame:VectorToWorldSpace(p10.noseM)
            local v31 = Vector3.new(v30.X, 0, v30.Z)

            if v31.Magnitude > 1E-04 then
                local Unit = v31.Unit

                if p10.lastFlat and p11 > 1E-04 then
                    local v33 = math.atan2(p10.lastFlat:Cross(Unit).Y, (p10.lastFlat:Dot(Unit))) / p11

                    p10.turn = p10.turn + (math.clamp(v33 / CarnoSwim.TURN_FULL, -1, 1) - p10.turn) * math.min(1, p11 / CarnoSwim.TURN_TAU)
                end

                p10.lastFlat = Unit
            end

            local v37 = if fightHooked(model) then CarnoSwim.HOOK_HZ else math.clamp(p10.v / (CarnoSwim.STRIDE * math.max(p10.length, 0.001)), CarnoSwim.MIN_HZ, CarnoSwim.MAX_HZ)

            p10.phase = (p10.phase + p11 * v37) % 1

            local phase, turn = p10.phase, p10.turn

            for v39, v40 in pairs(CarnoSwim.body(phase, turn)) do
                local v41 = p10.A[v39]
                local v42 = CFrame.identity

                for _, v43 in ipairs(v40) do
                    v42 *= CFrame.fromAxisAngle(v41[v43[1]], v43[2])
                end

                v41.bone.Transform = v42
            end

            for _, v44 in ipairs(p10.legs) do
                local v45 = CarnoSwim.leg(v44, phase, turn)
                local v46 = CFrame.identity

                for i = 1, 4 do
                    v44.b[i].Transform = v44.M[i]:Inverse() * v46:Inverse() * v45[i] * v44.M[i]
                    v46 = v45[i]
                end
            end
        end
    }
end
