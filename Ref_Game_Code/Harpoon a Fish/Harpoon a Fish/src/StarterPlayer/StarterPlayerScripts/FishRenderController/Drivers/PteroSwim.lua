-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 21
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PteroSwim = {
        LIFT0 = -0.3,
        FLAP = 0.45,
        TWIST = 0.15,
        TIP = 0.12,
        TIP_LAG = 0.8,
        MEM = { 0.1, 0.18, 0.25, 0.3 },
        SPAN_LAG = 0.3,
        TURN_GAIN = 0.2,
        THIGH = 0.12,
        SHIN = 0.1,
        FOOT = 0.25,
        FOOT_LAG = 0.6,
        CHEST_PITCH = 0.03,
        BANK = 0.25,
        NECK_STEADY = 0.9,
        LOOK = 0.25,
        TAIL = {
            { 0.03, 0.6 },
            { 0.04, 1.2 },
            { 0.05, 1.8 }
        },
        RUDDER = 0.1,
        STRIDE = 1.5,
        MIN_HZ = 0.3,
        MAX_HZ = 2,
        HOOK_HZ = 1.6,
        PEN_HZ = 0.5,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPARN = { "Arm", "Fore", "Fin1", "Fin2" },
        BONES = {
            "Chest",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Tail_3",
            "Neck_1",
            "Neck_2",
            "Head",
            "Arm_L",
            "Fore_L",
            "Fin1_L",
            "Fin2_L",
            "Mem1_L",
            "Mem2_L",
            "Mem3_L",
            "Mem4_L",
            "Arm_R",
            "Fore_R",
            "Fin1_R",
            "Fin2_R",
            "Mem1_R",
            "Mem2_R",
            "Mem3_R",
            "Mem4_R",
            "Thigh_L",
            "Shin_L",
            "Foot_L",
            "Thigh_R",
            "Shin_R",
            "Foot_R"
        },
        wing = function(p3, p4, p5) -- wing | line: 44
            -- upvalues: p1 (copy)
            local PteroSwim = p1.PteroSwim
            local s = p3.s
            local v1 = 6.283185307179586 * (p4 % 1)
            local v2 = 1 - s * PteroSwim.TURN_GAIN * p5
            local v3 = PteroSwim.LIFT0 + PteroSwim.FLAP * v2 * math.cos(v1)
            local Unit = (p3.P[5] - p3.P[1]).Unit
            local v4 = CFrame.fromAxisAngle(p3.back, -s * v3) * CFrame.fromAxisAngle(Unit, s * PteroSwim.TWIST * math.sin(v1))
            local t2 = {
                v4,
                v4,
                v4,
                CFrame.fromAxisAngle(p3.back, -s * PteroSwim.TIP * math.cos(v1 - PteroSwim.TIP_LAG)) * v4
            }
            local t3 = {}

            for i = 1, 4 do
                local Unit = (t2[i] * (p3.P[i + 1] - p3.P[i])).Unit

                t3[i] = CFrame.fromAxisAngle(Unit, s * PteroSwim.MEM[i] * math.sin(v1 - (i - 1) * PteroSwim.SPAN_LAG)) * t2[i]
            end

            return t2, t3
        end,
        leg = function(p6, p7) -- leg | line: 61
            -- upvalues: p1 (copy)
            local PteroSwim = p1.PteroSwim
            local v9 = 6.283185307179586 * ((p7 + (if p6.s == 1 then 0 else 0.5)) % 1)
            local v10 = CFrame.fromAxisAngle(p6.left, PteroSwim.THIGH * math.cos(v9))
            local v11 = CFrame.fromAxisAngle(p6.left, PteroSwim.SHIN * math.sin(v9)) * v10

            return v10, v11, CFrame.fromAxisAngle(p6.left, PteroSwim.FOOT * math.sin(v9 - PteroSwim.FOOT_LAG)) * v11
        end,
        body = function(p8, p9) -- body | line: 70
            -- upvalues: p1 (copy)
            local PteroSwim = p1.PteroSwim
            local v13 = 6.283185307179586 * p8
            local t4 = {
                Chest = {
                    {
                        "nose",
                        -PteroSwim.BANK * p9
                    },
                    {
                        "lat",
                        PteroSwim.CHEST_PITCH * math.sin(v13)
                    }
                },
                Neck_1 = {
                    {
                        "lat",
                        -PteroSwim.NECK_STEADY * PteroSwim.CHEST_PITCH * math.sin(v13)
                    },
                    {
                        "up",
                        PteroSwim.LOOK * p9 / 2
                    }
                },
                Neck_2 = {
                    {
                        "up",
                        PteroSwim.LOOK * p9 / 2
                    }
                },
                Pelvis = {
                    {
                        "lat",
                        -0.5 * PteroSwim.CHEST_PITCH * math.sin(v13)
                    }
                }
            }

            for v14, v15 in ipairs(PteroSwim.TAIL) do
                t4["Tail_" .. v14] = {
                    {
                        "lat",
                        v15[1] * math.sin(v13 - v15[2])
                    },
                    {
                        "up",
                        PteroSwim.RUDDER * p9 / 3
                    }
                }
            end

            return t4
        end,
        register = function(p10) -- register | line: 84
            -- upvalues: p1 (copy), attr (copy)
            local PteroSwim = p1.PteroSwim
            local MeshPart = p10:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p10, "AnatomyInverse")
            local t5 = {
                L = attr(p10, "WingTipL"),
                R = attr(p10, "WingTipR")
            }

            if MeshPart and typeof(AnatomyInverse) == "CFrame" and typeof(t5.L) == "Vector3" and typeof(t5.R) == "Vector3" then
                local t6 = {}

                for _, descendant in ipairs(MeshPart:GetDescendants()) do
                    if descendant:IsA("Bone") then
                        t6[descendant.Name] = descendant
                    end
                end

                for _, v19 in ipairs(PteroSwim.BONES) do
                    if not t6[v19] then
                        return nil
                    end
                end

                local CFrame = MeshPart.CFrame
                local v20 = p10:GetPivot() * AnatomyInverse:Inverse()
                local v21 = CFrame:VectorToObjectSpace(v20.RightVector)
                local v22 = CFrame:VectorToObjectSpace(v20.UpVector)
                local Unit = v22:Cross(v21).Unit
                local v23 = -Unit
                local Size = MeshPart.Size
                local v26 = math.abs(v21.X) * Size.X + math.abs(v21.Y) * Size.Y + math.abs(v21.Z) * Size.Z
                local t7 = {}

                for _, v27 in ipairs(PteroSwim.BONES) do
                    local v28 = CFrame:ToObjectSpace(t6[v27].WorldCFrame)

                    t7[v27] = {
                        bone = t6[v27],
                        nose = v28:VectorToObjectSpace(v21),
                        up = v28:VectorToObjectSpace(v22),
                        lat = v28:VectorToObjectSpace(v23),
                        pos = v28.Position,
                        M = v28.Rotation
                    }
                end

                local t8 = {}
                local t9 = {}

                for _, v29 in ipairs({ "L", "R" }) do
                    local v30 = if v29 == "L" then 1 else -1
                    local t10 = {}
                    local t11 = {}
                    local t12 = {}
                    local t13 = {}
                    local t14 = {}

                    for v31, v32 in ipairs(PteroSwim.SPARN) do
                        local v33 = t7[v32 .. "_" .. v29]

                        t10[v31] = v33.pos
                        t11[v31] = v33.bone
                        t12[v31] = v33.M

                        local v34 = t7["Mem" .. v31 .. "_" .. v29]

                        t13[v31] = v34.bone
                        t14[v31] = v34.M
                    end

                    t10[5] = t5[v29] * Size
                    t8[#t8 + 1] = {
                        s = v30,
                        P = t10,
                        sb = t11,
                        sm = t12,
                        mb = t13,
                        mm = t14,
                        back = -v21,
                        left = Unit
                    }

                    local v35 = t7["Thigh_" .. v29]
                    local v36 = t7["Shin_" .. v29]
                    local v37 = t7["Foot_" .. v29]

                    t9[#t9 + 1] = {
                        s = v30,
                        b = {
                            v35.bone,
                            v36.bone,
                            v37.bone
                        },
                        M = {
                            v35.M,
                            v36.M,
                            v37.M
                        },
                        left = Unit
                    }
                end

                return {
                    turn = 0,
                    v = 0,
                    model = p10,
                    mesh = MeshPart,
                    A = t7,
                    wings = t8,
                    legs = t9,
                    noseM = v21,
                    phase = math.random(),
                    length = v26
                }
            end

            return nil
        end,
        update = function(p11, p12) -- update | line: 129
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PteroSwim = p1.PteroSwim
            local model = p11.model
            local _CFrame = p11.mesh.CFrame

            if p11.lastPos and p12 > 1E-04 then
                local v38 = (_CFrame.Position - p11.lastPos).Magnitude / p12

                if v38 < 2000 then
                    p11.v = p11.v + (v38 - p11.v) * math.min(1, p12 / PteroSwim.V_TAU)
                end
            end

            p11.lastPos = _CFrame.Position

            local v41 = _CFrame:VectorToWorldSpace(p11.noseM)
            local v42 = Vector3.new(v41.X, 0, v41.Z)

            if v42.Magnitude > 1E-04 then
                local Unit = v42.Unit

                if p11.lastFlat and p12 > 1E-04 then
                    local v44 = math.atan2(p11.lastFlat:Cross(Unit).Y, (p11.lastFlat:Dot(Unit))) / p12

                    p11.turn = p11.turn + (math.clamp(v44 / PteroSwim.TURN_FULL, -1, 1) - p11.turn) * math.min(1, p12 / PteroSwim.TURN_TAU)
                end

                p11.lastFlat = Unit
            end

            local PEN_HZ = PteroSwim.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = PteroSwim.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(PteroSwim.MAX_HZ, (math.max(p11.v / (PteroSwim.STRIDE * math.max(p11.length, 0.001)), PteroSwim.MIN_HZ)))
            end

            p11.phase = (p11.phase + p12 * PEN_HZ) % 1

            local phase, turn = p11.phase, p11.turn

            for v50, v51 in pairs(PteroSwim.body(phase, turn)) do
                local v52 = p11.A[v50]
                local v53 = CFrame.identity

                for _, v54 in ipairs(v51) do
                    v53 *= CFrame.fromAxisAngle(v52[v54[1]], v54[2])
                end

                v52.bone.Transform = v53
            end

            for _, v55 in ipairs(p11.wings) do
                local v56, v57 = PteroSwim.wing(v55, phase, turn)
                local v58 = CFrame.identity

                for i = 1, 4 do
                    v55.sb[i].Transform = v55.sm[i]:Inverse() * v58:Inverse() * v56[i] * v55.sm[i]
                    v55.mb[i].Transform = v55.mm[i]:Inverse() * v56[i]:Inverse() * v57[i] * v55.mm[i]
                    v58 = v56[i]
                end
            end

            for _, v59 in ipairs(p11.legs) do
                local v60, v61, v62 = PteroSwim.leg(v59, phase)
                local t15 = {
                    CFrame.identity,
                    v60,
                    v61,
                    v62
                }

                for j = 1, 3 do
                    v59.b[j].Transform = v59.M[j]:Inverse() * t15[j]:Inverse() * t15[j + 1] * v59.M[j]
                end
            end
        end
    }
end
