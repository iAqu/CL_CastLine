-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 17
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.MakaraSwim = {
        WAVE = {
            { "Chest", 0.015 },
            { "Belly", 0.025 },
            { "Pelvis", 0.045 },
            { "Tail_1", 0.09 },
            { "Tail_2", 0.14 },
            { "Tail_3", 0.19 },
            { "Tail_4", 0.23 },
            { "Tail_5", 0.26 }
        },
        LAG = 0.6,
        RAM_TAIL = 0.5,
        HEAD_STEADY = 0.85,
        BEND = 0.12,
        LOOK = 0.2,
        RAM_NECK = 0.08,
        ARM = {
            PH = 0.2,
            FOLD = 0.3,
            PADDLE = 0.2,
            BEND0 = 0,
            BENDA = 0,
            LAG2 = 0.9,
            PAW0 = 0,
            PAWA = 0,
            LAG3 = 1.5
        },
        LEG = {
            PH = 0.45,
            FOLD = 0.35,
            PADDLE = 0.18,
            BEND0 = 0,
            BENDA = 0,
            LAG2 = 0.9,
            PAW0 = 0,
            PAWA = 0,
            LAG3 = 1.5
        },
        RAM_TUCK = 0.2,
        STEER = 0.12,
        TRUNK_A = 0,
        TRUNK_LAG = 0.8,
        TRUNK_TIP = 1.6,
        RAM_TRUNK = 0.5,
        TRUNK_LOOK = 0,
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
            "Tail_5",
            "Arm_L",
            "Arm_R",
            "Thigh_L",
            "Thigh_R"
        },
        HEADS = { "Neck", "Head", "Trunk_1", "Trunk_2" },
        LOWER = { "Fore_L", "Hand_L", "Fore_R", "Hand_R", "Shin_L", "Foot_L", "Shin_R", "Foot_R" },
        ramOf = function(p3) -- ramOf | line: 40
            -- upvalues: p1 (copy)
            local MakaraSwim = p1.MakaraSwim
            local v2 = math.clamp((p3 - MakaraSwim.RAM_E0) / (MakaraSwim.RAM_E1 - MakaraSwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        limb = function(p4, p5, p6, p7, p8) -- limb | line: 46
            -- upvalues: p1 (copy)
            local MakaraSwim = p1.MakaraSwim
            local v3 = 6.283185307179586 * ((p6 + p4.PH + (if p5.s == 1 then 0 else 0.5)) % 1)
            local v4 = CFrame.fromAxisAngle(p5.up, -MakaraSwim.STEER * p7) * CFrame.fromAxisAngle(p5.left, p4.FOLD + MakaraSwim.RAM_TUCK * p8 + p4.PADDLE * (1 - p8) * math.cos(v3))
            local v7 = CFrame.fromAxisAngle(p5.left, p4.BEND0 + p4.BENDA * (1 - p8) * math.sin(v3 - p4.LAG2)) * v4

            return v4, v7, CFrame.fromAxisAngle(p5.left, p4.PAW0 + p4.PAWA * (1 - p8) * math.sin(v3 - p4.LAG3)) * v7
        end,
        body = function(p9, p10, p11) -- body | line: 55
            -- upvalues: p1 (copy)
            local MakaraSwim = p1.MakaraSwim
            local v10 = 6.283185307179586 * p9
            local t2 = {}
            local n1 = 0

            for v11, v12 in ipairs(MakaraSwim.WAVE) do
                local v15 = v12[2] * (1 + (v11 >= 3 and MakaraSwim.RAM_TAIL * p11 or 0)) * math.sin(v10 - (v11 - 1) * MakaraSwim.LAG)

                if v12[1] == "Chest" then
                    n1 = v15
                    t2[v12[1]] = { { "up", v15 } }
                else
                    t2[v12[1]] = {
                        {
                            "up",
                            v15 + MakaraSwim.BEND * p10 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -MakaraSwim.HEAD_STEADY * n1 + MakaraSwim.LOOK * p10 / 2
                },
                {
                    "lat",
                    MakaraSwim.RAM_NECK * p11
                }
            }
            t2.Head = {
                {
                    "up",
                    MakaraSwim.LOOK * p10 / 2
                }
            }

            for v16, v17 in ipairs({ "Trunk_1", "Trunk_2" }) do
                t2[v17] = {
                    {
                        "lat",
                        MakaraSwim.TRUNK_A * (1 + MakaraSwim.RAM_TRUNK * p11) * (v16 == 2 and MakaraSwim.TRUNK_TIP or 1) * math.sin(v10 - v16 * MakaraSwim.TRUNK_LAG)
                    },
                    {
                        "up",
                        MakaraSwim.TRUNK_LOOK * p10 / 2
                    }
                }
            end

            return t2
        end,
        register = function(p12) -- register | line: 77
            -- upvalues: p1 (copy), attr (copy)
            local MakaraSwim = p1.MakaraSwim
            local MeshPart = p12:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p12, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t3 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t3[descendant.Name] = descendant
                end
            end

            for _, v20 in ipairs(MakaraSwim.BONES) do
                if not t3[v20] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v21 = p12:GetPivot() * AnatomyInverse:Inverse()
            local v22 = CFrame:VectorToObjectSpace(v21.RightVector)
            local v23 = CFrame:VectorToObjectSpace(v21.UpVector)
            local Unit = v23:Cross(v22).Unit
            local v24 = -Unit
            local Size = MeshPart.Size
            local v27 = math.abs(v22.X) * Size.X + math.abs(v22.Y) * Size.Y + math.abs(v22.Z) * Size.Z
            local t4 = {}

            for _, v28 in ipairs({
                    MakaraSwim.BONES,
                    MakaraSwim.HEADS,
                    MakaraSwim.LOWER
                }) do
                for _, v29 in ipairs(v28) do
                    if t3[v29] then
                        local v30 = CFrame:ToObjectSpace(t3[v29].WorldCFrame)

                        t4[v29] = {
                            bone = t3[v29],
                            nose = v30:VectorToObjectSpace(v22),
                            up = v30:VectorToObjectSpace(v23),
                            lat = v30:VectorToObjectSpace(v24),
                            pos = v30.Position,
                            M = v30.Rotation
                        }
                    end
                end
            end

            local function chain(p13, p14, p15, p16) -- line: 106
                -- upvalues: v23 (copy), Unit (copy), t4 (copy)
                local t5 = {
                    s = p13,
                    b = {},
                    M = {},
                    left = Unit,
                    up = v23
                }

                for v31, v32 in ipairs({ p14, p15, p16 }) do
                    if t4[v32] then
                        local b, M = t5.b, t5.M
                        local bone, M2 = t4[v32].bone, t4[v32].M

                        b[v31] = bone
                        M[v31] = M2
                    end
                end

                return t5
            end

            local t6 = {}
            local t7 = {}

            for _, v33 in ipairs({ "L", "R" }) do
                local v34 = if v33 == "L" then 1 else -1

                t6[#t6 + 1] = chain(v34, "Arm_" .. v33, "Fore_" .. v33, "Hand_" .. v33)
                t7[#t7 + 1] = chain(v34, "Thigh_" .. v33, "Shin_" .. v33, "Foot_" .. v33)
            end

            return {
                turn = 0,
                v = 0,
                model = p12,
                mesh = MeshPart,
                A = t4,
                arms = t6,
                legs = t7,
                noseM = v22,
                phase = math.random(),
                length = v27
            }
        end,
        update = function(p17, p18) -- update | line: 123
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local MakaraSwim = p1.MakaraSwim
            local model = p17.model
            local _CFrame = p17.mesh.CFrame

            if p17.lastPos and p18 > 1E-04 then
                local v35 = (_CFrame.Position - p17.lastPos).Magnitude / p18

                if v35 < 2000 then
                    p17.v = p17.v + (v35 - p17.v) * math.min(1, p18 / MakaraSwim.V_TAU)
                end
            end

            p17.lastPos = _CFrame.Position

            local v38 = _CFrame:VectorToWorldSpace(p17.noseM)
            local v39 = Vector3.new(v38.X, 0, v38.Z)

            if v39.Magnitude > 1E-04 then
                local Unit = v39.Unit

                if p17.lastFlat and p18 > 1E-04 then
                    local v41 = math.atan2(p17.lastFlat:Cross(Unit).Y, (p17.lastFlat:Dot(Unit))) / p18

                    p17.turn = p17.turn + (math.clamp(v41 / MakaraSwim.TURN_FULL, -1, 1) - p17.turn) * math.min(1, p18 / MakaraSwim.TURN_TAU)
                end

                p17.lastFlat = Unit
            end

            local PEN_HZ = MakaraSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = MakaraSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(MakaraSwim.MAX_HZ, (math.max(p17.v / (MakaraSwim.STRIDE * math.max(p17.length, 0.001)), MakaraSwim.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then MakaraSwim.ramOf(p17.v / math.max(PassCruise, 0.001)) else 0
            end

            p17.phase = (p17.phase + p18 * PEN_HZ) % 1

            local phase, turn = p17.phase, p17.turn

            for v47, v48 in pairs(MakaraSwim.body(phase, turn, n2)) do
                local v49 = p17.A[v47]

                if v49 then
                    local v50 = CFrame.identity

                    for _, v51 in ipairs(v48) do
                        v50 *= CFrame.fromAxisAngle(v49[v51[1]], v51[2])
                    end

                    v49.bone.Transform = v50
                end
            end

            for _, v52 in ipairs(p17.arms) do
                local v53, v54, v55 = MakaraSwim.limb(MakaraSwim.ARM, v52, phase, turn, n2)
                local t8 = {
                    CFrame.identity,
                    v53,
                    v54,
                    v55
                }

                for i = 1, 3 do
                    if v52.b[i] then
                        v52.b[i].Transform = v52.M[i]:Inverse() * t8[i]:Inverse() * t8[i + 1] * v52.M[i]
                    end
                end
            end

            for _, v56 in ipairs(p17.legs) do
                local v57, v58, v59 = MakaraSwim.limb(MakaraSwim.LEG, v56, phase, turn, n2)
                local t9 = {
                    CFrame.identity,
                    v57,
                    v58,
                    v59
                }

                for j = 1, 3 do
                    if v56.b[j] then
                        v56.b[j].Transform = v56.M[j]:Inverse() * t9[j]:Inverse() * t9[j + 1] * v56.M[j]
                    end
                end
            end
        end
    }
end
