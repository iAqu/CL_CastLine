-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 17
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.NingenCrawl = {
        LAG = 0.6,
        RAM_TAIL = 0.5,
        HEAD_STEADY = 0.85,
        BEND = 0.12,
        LOOK = 0.2,
        RAM_NECK = 0.06,
        SH = 0.2,
        FA = 0.4,
        OUT = 0.12,
        TUCK = 0.35,
        HAND = 0.25,
        HAND_LAG = 0.6,
        ROLL = 0.1,
        HEAD_ROLL = 0.8,
        TURN_GAIN = 0.25,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        STRIDE = 0.4,
        MIN_HZ = 0.5,
        MAX_HZ = 2.6,
        HOOK_HZ = 2.2,
        PEN_HZ = 0.6,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        WAVE = {
            { "Chest", 0.01 },
            { "Belly", 0.02 },
            { "Pelvis", 0.04 },
            { "Tail_1", 0.08 },
            { "Tail_2", 0.13 },
            { "Tail_3", 0.18 },
            { "Tail_4", 0.22 },
            { "Tail_5", 0.25 }
        },
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
            "Hand_R"
        },
        ramOf = function(p3) -- ramOf | line: 35
            -- upvalues: p1 (copy)
            local NingenCrawl = p1.NingenCrawl
            local v2 = math.clamp((p3 - NingenCrawl.RAM_E0) / (NingenCrawl.RAM_E1 - NingenCrawl.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        arm = function(p4, p5, p6, p7) -- arm | line: 41
            -- upvalues: p1 (copy)
            local NingenCrawl = p1.NingenCrawl
            local s = p4.s
            local v3 = 6.283185307179586 * ((p5 + (if s == 1 then 0 else 0.5)) % 1)
            local v4 = 1 - s * NingenCrawl.TURN_GAIN * p6
            local v5 = 1 - p7
            local v6 = CFrame.fromAxisAngle(p4.left, NingenCrawl.SH * v5 * math.sin(v3))
            local v7 = CFrame.fromAxisAngle(p4.up, s * NingenCrawl.OUT * v5 * v4 * math.sin(v3)) * CFrame.fromAxisAngle(p4.left, -NingenCrawl.FA * v5 * v4 * math.cos(v3) + NingenCrawl.TUCK * p7) * v6

            return v6, v7, CFrame.fromAxisAngle(p4.left, NingenCrawl.HAND * v5 * math.sin(v3 - NingenCrawl.HAND_LAG)) * v7
        end,
        body = function(p8, p9, p10) -- body | line: 54
            -- upvalues: p1 (copy)
            local NingenCrawl = p1.NingenCrawl
            local v10 = 6.283185307179586 * p8
            local t2 = {}
            local n1 = 0

            for v11, v12 in ipairs(NingenCrawl.WAVE) do
                local v15 = v12[2] * (1 + (v11 >= 3 and NingenCrawl.RAM_TAIL * p10 or 0)) * math.sin(v10 - (v11 - 1) * NingenCrawl.LAG)

                if v12[1] == "Chest" then
                    n1 = v15
                    t2[v12[1]] = {
                        { "up", v15 },
                        {
                            "nose",
                            NingenCrawl.ROLL * (1 - p10) * math.sin(v10)
                        }
                    }
                else
                    t2[v12[1]] = {
                        {
                            "up",
                            v15 + NingenCrawl.BEND * p9 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -NingenCrawl.HEAD_STEADY * n1 + NingenCrawl.LOOK * p9 / 2
                },
                {
                    "nose",
                    -NingenCrawl.HEAD_ROLL * NingenCrawl.ROLL * (1 - p10) * math.sin(v10)
                },
                {
                    "lat",
                    NingenCrawl.RAM_NECK * p10
                }
            }
            t2.Head = {
                {
                    "up",
                    NingenCrawl.LOOK * p9 / 2
                }
            }

            return t2
        end,
        register = function(p11) -- register | line: 72
            -- upvalues: p1 (copy), attr (copy)
            local NingenCrawl = p1.NingenCrawl
            local MeshPart = p11:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p11, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t3 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t3[descendant.Name] = descendant
                end
            end

            for _, v16 in ipairs(NingenCrawl.BONES) do
                if not t3[v16] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v17 = p11:GetPivot() * AnatomyInverse:Inverse()
            local v18 = CFrame:VectorToObjectSpace(v17.RightVector)
            local v19 = CFrame:VectorToObjectSpace(v17.UpVector)
            local Unit = v19:Cross(v18).Unit
            local v20 = -Unit
            local Size = MeshPart.Size
            local v23 = math.abs(v18.X) * Size.X + math.abs(v18.Y) * Size.Y + math.abs(v18.Z) * Size.Z
            local t4 = {}

            for _, v24 in ipairs(NingenCrawl.BONES) do
                local v25 = CFrame:ToObjectSpace(t3[v24].WorldCFrame)

                t4[v24] = {
                    bone = t3[v24],
                    nose = v25:VectorToObjectSpace(v18),
                    up = v25:VectorToObjectSpace(v19),
                    lat = v25:VectorToObjectSpace(v20),
                    M = v25.Rotation
                }
            end

            local t5 = {}

            for _, v26 in ipairs({ "L", "R" }) do
                local v27 = t4["Arm_" .. v26]
                local v28 = t4["Fore_" .. v26]
                local v29 = t4["Hand_" .. v26]

                t5[#t5 + 1] = {
                    s = v26 == "L" and 1 or -1,
                    b = {
                        v27.bone,
                        v28.bone,
                        v29.bone
                    },
                    M = {
                        v27.M,
                        v28.M,
                        v29.M
                    },
                    left = Unit,
                    up = v19
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p11,
                mesh = MeshPart,
                A = t4,
                arms = t5,
                noseM = v18,
                phase = math.random(),
                length = v23
            }
        end,
        update = function(p12, p13) -- update | line: 104
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local NingenCrawl = p1.NingenCrawl
            local model = p12.model
            local _CFrame = p12.mesh.CFrame

            if p12.lastPos and p13 > 1E-04 then
                local v31 = (_CFrame.Position - p12.lastPos).Magnitude / p13

                if v31 < 2000 then
                    p12.v = p12.v + (v31 - p12.v) * math.min(1, p13 / NingenCrawl.V_TAU)
                end
            end

            p12.lastPos = _CFrame.Position

            local v34 = _CFrame:VectorToWorldSpace(p12.noseM)
            local v35 = Vector3.new(v34.X, 0, v34.Z)

            if v35.Magnitude > 1E-04 then
                local Unit = v35.Unit

                if p12.lastFlat and p13 > 1E-04 then
                    local v37 = math.atan2(p12.lastFlat:Cross(Unit).Y, (p12.lastFlat:Dot(Unit))) / p13

                    p12.turn = p12.turn + (math.clamp(v37 / NingenCrawl.TURN_FULL, -1, 1) - p12.turn) * math.min(1, p13 / NingenCrawl.TURN_TAU)
                end

                p12.lastFlat = Unit
            end

            local PEN_HZ = NingenCrawl.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = NingenCrawl.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(NingenCrawl.MAX_HZ, (math.max(p12.v / (NingenCrawl.STRIDE * math.max(p12.length, 0.001)), NingenCrawl.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then NingenCrawl.ramOf(p12.v / math.max(PassCruise, 0.001)) else 0
            end

            p12.phase = (p12.phase + p13 * PEN_HZ) % 1

            local phase, turn = p12.phase, p12.turn

            for v43, v44 in pairs(NingenCrawl.body(phase, turn, n2)) do
                local v45 = p12.A[v43]
                local v46 = CFrame.identity

                for _, v47 in ipairs(v44) do
                    v46 *= CFrame.fromAxisAngle(v45[v47[1]], v47[2])
                end

                v45.bone.Transform = v46
            end

            for _, v48 in ipairs(p12.arms) do
                local v49, v50, v51 = NingenCrawl.arm(v48, phase, turn, n2)
                local t7 = {
                    CFrame.identity,
                    v49,
                    v50,
                    v51
                }

                for i = 1, 3 do
                    v48.b[i].Transform = v48.M[i]:Inverse() * t7[i]:Inverse() * t7[i + 1] * v48.M[i]
                end
            end
        end
    }
end
