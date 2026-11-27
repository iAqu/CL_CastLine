-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 20
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PelaSwim = {
        LIFT0 = -0.25,
        FLAP = 0.38,
        SWEEP = 0.2,
        TWIST = 0.2,
        FOLD0 = 0.2,
        FOLDA = 0.15,
        FOLD_LAG = 0.3,
        KE = 0.4,
        KW = 0.6,
        TIP = 0.15,
        TIP_LAG = 0.8,
        FTH = { 0.05, 0.15, 0.2 },
        FTH_LAG = 0.4,
        SPAN_LAG = 0.3,
        TURN_GAIN = 0.2,
        CHEST_PITCH = 0.025,
        BANK = 0.25,
        NECK_STEADY = 0.9,
        LOOK = 0.2,
        TAIL_P = 0.05,
        TAIL_LAG = 0.9,
        RUDDER = 0.15,
        FEET_A = 0.04,
        FEET_LAG = 1.4,
        FEET_RUD = 0.12,
        STRIDE = 0.75,
        MIN_HZ = 0.3,
        MAX_HZ = 2.5,
        HOOK_HZ = 1.6,
        PEN_HZ = 0.5,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPARN = { "Arm", "Fore", "Hand", "Tip" },
        BONES = {
            "Chest",
            "Pelvis",
            "Tail",
            "Neck_1",
            "Neck_2",
            "Head",
            "Feet",
            "Arm_L",
            "Fore_L",
            "Hand_L",
            "Tip_L",
            "Fth1_L",
            "Fth2_L",
            "Fth3_L",
            "Arm_R",
            "Fore_R",
            "Hand_R",
            "Tip_R",
            "Fth1_R",
            "Fth2_R",
            "Fth3_R"
        },
        wing = function(p3, p4, p5) -- wing | line: 44
            -- upvalues: p1 (copy)
            local PelaSwim = p1.PelaSwim
            local s = p3.s
            local v1 = 6.283185307179586 * (p4 % 1)
            local v2 = 1 - s * PelaSwim.TURN_GAIN * p5
            local v3 = PelaSwim.LIFT0 + PelaSwim.FLAP * v2 * math.cos(v1)
            local v4 = PelaSwim.SWEEP * v2 * math.sin(v1)
            local Unit = (p3.P[5] - p3.P[1]).Unit
            local v5 = CFrame.fromAxisAngle(p3.up, -s * v4) * CFrame.fromAxisAngle(p3.back, -s * v3)
            local v7 = PelaSwim.FOLD0 - PelaSwim.FOLDA * math.sin(v1 - PelaSwim.FOLD_LAG)
            local v8 = CFrame.fromAxisAngle(v5:VectorToWorldSpace(p3.up), s * PelaSwim.KE * v7) * CFrame.fromAxisAngle(v5:VectorToWorldSpace(Unit), s * PelaSwim.TWIST * math.sin(v1)) * v5
            local v9 = CFrame.fromAxisAngle(v8:VectorToWorldSpace(p3.up), s * PelaSwim.KW * v7) * v8
            local t2 = {
                v5,
                v8,
                v9,
                CFrame.fromAxisAngle(p3.back, -s * PelaSwim.TIP * math.cos(v1 - PelaSwim.TIP_LAG)) * v9
            }
            local t3 = {}

            for i = 1, 3 do
                local Unit = t2[i]:VectorToWorldSpace(p3.P[i + 1] - p3.P[i]).Unit

                t3[i] = CFrame.fromAxisAngle(Unit, s * PelaSwim.FTH[i] * math.sin(v1 - PelaSwim.FTH_LAG - (i - 1) * PelaSwim.SPAN_LAG)) * t2[i]
            end

            return t2, t3
        end,
        body = function(p6, p7) -- body | line: 66
            -- upvalues: p1 (copy)
            local PelaSwim = p1.PelaSwim
            local v14 = 6.283185307179586 * p6
            local v15 = PelaSwim.CHEST_PITCH * math.sin(v14)

            return {
                Chest = {
                    {
                        "nose",
                        -PelaSwim.BANK * p7
                    },
                    { "lat", v15 }
                },
                Neck_1 = {
                    {
                        "lat",
                        -PelaSwim.NECK_STEADY * v15
                    },
                    {
                        "up",
                        PelaSwim.LOOK * p7 / 2
                    }
                },
                Neck_2 = {
                    {
                        "up",
                        PelaSwim.LOOK * p7 / 2
                    }
                },
                Pelvis = {
                    {
                        "lat",
                        -0.5 * v15
                    }
                },
                Tail = {
                    {
                        "lat",
                        PelaSwim.TAIL_P * math.sin(v14 - PelaSwim.TAIL_LAG)
                    },
                    {
                        "up",
                        PelaSwim.RUDDER * p7
                    }
                },
                Feet = {
                    {
                        "lat",
                        PelaSwim.FEET_A * math.sin(v14 - PelaSwim.FEET_LAG)
                    },
                    {
                        "up",
                        PelaSwim.FEET_RUD * p7
                    }
                }
            }
        end,
        register = function(p8) -- register | line: 79
            -- upvalues: p1 (copy), attr (copy)
            local PelaSwim = p1.PelaSwim
            local MeshPart = p8:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p8, "AnatomyInverse")
            local t5 = {
                L = attr(p8, "WingTipL"),
                R = attr(p8, "WingTipR")
            }

            if MeshPart and typeof(AnatomyInverse) == "CFrame" and typeof(t5.L) == "Vector3" and typeof(t5.R) == "Vector3" then
                local t6 = {}

                for _, descendant in ipairs(MeshPart:GetDescendants()) do
                    if descendant:IsA("Bone") then
                        t6[descendant.Name] = descendant
                    end
                end

                for _, v18 in ipairs(PelaSwim.BONES) do
                    if not t6[v18] then
                        return nil
                    end
                end

                local CFrame = MeshPart.CFrame
                local v19 = p8:GetPivot() * AnatomyInverse:Inverse()
                local v20 = CFrame:VectorToObjectSpace(v19.RightVector)
                local v21 = CFrame:VectorToObjectSpace(v19.UpVector)
                local v22 = -v21:Cross(v20).Unit
                local Size = MeshPart.Size
                local v25 = math.abs(v20.X) * Size.X + math.abs(v20.Y) * Size.Y + math.abs(v20.Z) * Size.Z
                local t7 = {}

                for _, v26 in ipairs(PelaSwim.BONES) do
                    local v27 = CFrame:ToObjectSpace(t6[v26].WorldCFrame)

                    t7[v26] = {
                        bone = t6[v26],
                        nose = v27:VectorToObjectSpace(v20),
                        up = v27:VectorToObjectSpace(v21),
                        lat = v27:VectorToObjectSpace(v22),
                        pos = v27.Position,
                        M = v27.Rotation
                    }
                end

                local t8 = {}

                for _, v28 in ipairs({ "L", "R" }) do
                    local v29 = if v28 == "L" then 1 else -1
                    local t9 = {}
                    local t10 = {}
                    local t11 = {}
                    local t12 = {}
                    local t13 = {}

                    for v30, v31 in ipairs(PelaSwim.SPARN) do
                        local v32 = t7[v31 .. "_" .. v28]

                        t9[v30] = v32.pos
                        t10[v30] = v32.bone
                        t11[v30] = v32.M

                        if v30 <= 3 then
                            local v33 = t7["Fth" .. v30 .. "_" .. v28]

                            t12[v30] = v33.bone
                            t13[v30] = v33.M
                        end
                    end

                    t9[5] = t5[v28] * Size
                    t8[#t8 + 1] = {
                        s = v29,
                        P = t9,
                        sb = t10,
                        sm = t11,
                        fb = t12,
                        fm = t13,
                        back = -v20,
                        up = v21
                    }
                end

                return {
                    turn = 0,
                    v = 0,
                    model = p8,
                    mesh = MeshPart,
                    A = t7,
                    wings = t8,
                    noseM = v20,
                    phase = math.random(),
                    length = v25
                }
            end

            return nil
        end,
        update = function(p9, p10) -- update | line: 124
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PelaSwim = p1.PelaSwim
            local model = p9.model
            local _CFrame = p9.mesh.CFrame

            if p9.lastPos and p10 > 1E-04 then
                local v34 = (_CFrame.Position - p9.lastPos).Magnitude / p10

                if v34 < 2000 then
                    p9.v = p9.v + (v34 - p9.v) * math.min(1, p10 / PelaSwim.V_TAU)
                end
            end

            p9.lastPos = _CFrame.Position

            local v37 = _CFrame:VectorToWorldSpace(p9.noseM)
            local v38 = Vector3.new(v37.X, 0, v37.Z)

            if v38.Magnitude > 1E-04 then
                local Unit = v38.Unit

                if p9.lastFlat and p10 > 1E-04 then
                    local v40 = math.atan2(p9.lastFlat:Cross(Unit).Y, (p9.lastFlat:Dot(Unit))) / p10

                    p9.turn = p9.turn + (math.clamp(v40 / PelaSwim.TURN_FULL, -1, 1) - p9.turn) * math.min(1, p10 / PelaSwim.TURN_TAU)
                end

                p9.lastFlat = Unit
            end

            local PEN_HZ = PelaSwim.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = PelaSwim.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(PelaSwim.MAX_HZ, (math.max(p9.v / (PelaSwim.STRIDE * math.max(p9.length, 0.001)), PelaSwim.MIN_HZ)))
            end

            p9.phase = (p9.phase + p10 * PEN_HZ) % 1

            local phase, turn = p9.phase, p9.turn

            for v46, v47 in pairs(PelaSwim.body(phase, turn)) do
                local v48 = p9.A[v46]
                local v49 = CFrame.identity

                for _, v50 in ipairs(v47) do
                    v49 *= CFrame.fromAxisAngle(v48[v50[1]], v50[2])
                end

                v48.bone.Transform = v49
            end

            for _, v51 in ipairs(p9.wings) do
                local v52, v53 = PelaSwim.wing(v51, phase, turn)
                local v54 = CFrame.identity

                for i = 1, 4 do
                    v51.sb[i].Transform = v51.sm[i]:Inverse() * v54:Inverse() * v52[i] * v51.sm[i]

                    if i <= 3 then
                        v51.fb[i].Transform = v51.fm[i]:Inverse() * v52[i]:Inverse() * v53[i] * v51.fm[i]
                    end

                    v54 = v52[i]
                end
            end
        end
    }
end
