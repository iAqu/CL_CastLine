-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 24
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.DimetSwim = {
        WAVE = {
            { "Chest", 0.03 },
            { "Belly", 0.05 },
            { "Pelvis", 0.06 },
            { "Tail_1", 0.09 },
            { "Tail_2", 0.13 },
            { "Tail_3", 0.17 },
            { "Tail_4", 0.21 },
            { "Tail_5", 0.24 }
        },
        LAG = 0.55,
        RAM_TAIL = 0.5,
        HEAD_STEADY = 0.85,
        BEND = 0.12,
        LOOK = 0.2,
        ARM_PH = 0.2,
        PHI0 = 0.45,
        SWING = 0.12,
        LIFT0 = 0.1,
        LIFT = 0.06,
        HAND0 = 0.15,
        HAND = 0.15,
        HAND_LAG = 0.9,
        RAM_TUCK = 0.2,
        TURN_GAIN = 0.3,
        LEG_PH = 0.45,
        FOLD_H = 0.35,
        PADDLE = 0.12,
        STEER = 0.12,
        SHIN_TRAIL = 0.15,
        FOOT = 0.2,
        FOOT_LAG = 0.6,
        RAM_TUCK_L = 0.12,
        BITE = 0.4,
        BITE_R = 0.5,
        CLOSE_T = 0.12,
        HOLD_T = 0.15,
        OPEN_T = 0.35,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        STRIDE = 0.8,
        MIN_HZ = 0.25,
        MAX_HZ = 3.2,
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
            "Neck",
            "Head",
            "Jaw",
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
        ss = function(p3) -- ss | line: 50
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        ramOf = function(p4) -- ramOf | line: 54
            -- upvalues: p1 (copy)
            local DimetSwim = p1.DimetSwim

            return DimetSwim.ss((p4 - DimetSwim.RAM_E0) / (DimetSwim.RAM_E1 - DimetSwim.RAM_E0))
        end,
        biteEnv = function(p5) -- biteEnv | line: 59
            -- upvalues: p1 (copy)
            local DimetSwim = p1.DimetSwim

            if p5 == nil then
                return 0
            end

            return DimetSwim.ss(p5 / DimetSwim.CLOSE_T) * (1 - DimetSwim.ss((p5 - DimetSwim.CLOSE_T - DimetSwim.HOLD_T) / DimetSwim.OPEN_T))
        end,
        arm = function(p6, p7, p8, p9) -- arm | line: 65
            -- upvalues: p1 (copy)
            local DimetSwim = p1.DimetSwim
            local s = p6.s
            local v2 = 6.283185307179586 * ((p7 + DimetSwim.ARM_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v3 = 1 - s * DimetSwim.TURN_GAIN * p8
            local v4 = CFrame.fromAxisAngle(p6.up, s * (DimetSwim.PHI0 + DimetSwim.RAM_TUCK * p9 - DimetSwim.SWING * (1 - p9) * v3 * math.cos(v2))) * CFrame.fromAxisAngle(p6.back, -s * (DimetSwim.LIFT0 + DimetSwim.LIFT * (1 - p9) * math.sin(v2)))

            return v4, v4, CFrame.fromAxisAngle(v4 * p6.left, DimetSwim.HAND0 + DimetSwim.HAND * (1 - p9) * math.sin(v2 - DimetSwim.HAND_LAG)) * v4
        end,
        leg = function(p10, p11, p12, p13) -- leg | line: 75
            -- upvalues: p1 (copy)
            local DimetSwim = p1.DimetSwim
            local s = p10.s
            local v8 = 6.283185307179586 * ((p11 + DimetSwim.LEG_PH + (if s == 1 then 0 else 0.5)) % 1)
            local v9 = CFrame.fromAxisAngle(p10.up, s * (DimetSwim.FOLD_H + DimetSwim.RAM_TUCK_L * p13 + DimetSwim.PADDLE * (1 - p13) * math.cos(v8)) - DimetSwim.STEER * p12)
            local v10 = CFrame.fromAxisAngle(p10.up, s * DimetSwim.SHIN_TRAIL) * v9

            return v9, v10, CFrame.fromAxisAngle(p10.left, DimetSwim.FOOT * (1 - p13) * math.sin(v8 - DimetSwim.FOOT_LAG)) * v10
        end,
        body = function(p14, p15, p16, p17) -- body | line: 85
            -- upvalues: p1 (copy)
            local DimetSwim = p1.DimetSwim
            local v13 = 6.283185307179586 * p14
            local t2 = {}
            local n1 = 0

            for v14, v15 in ipairs(DimetSwim.WAVE) do
                local v18 = v15[2] * (1 + (v14 >= 2 and DimetSwim.RAM_TAIL * p16 or 0)) * math.sin(v13 - (v14 - 1) * DimetSwim.LAG)

                if v15[1] == "Chest" then
                    n1 = v18
                    t2[v15[1]] = { { "up", v18 } }
                else
                    t2[v15[1]] = {
                        {
                            "up",
                            v18 + DimetSwim.BEND * p15 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -DimetSwim.HEAD_STEADY * n1 + DimetSwim.LOOK * p15 / 2
                }
            }
            t2.Head = {
                {
                    "up",
                    DimetSwim.LOOK * p15 / 2
                }
            }
            t2.Jaw = {
                {
                    "lat",
                    DimetSwim.BITE * p17
                }
            }

            return t2
        end,
        register = function(p18) -- register | line: 104
            -- upvalues: p1 (copy), attr (copy)
            local DimetSwim = p1.DimetSwim
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

            for _, v19 in ipairs(DimetSwim.BONES) do
                if not t3[v19] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v20 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v21 = CFrame:VectorToObjectSpace(v20.RightVector)
            local v22 = CFrame:VectorToObjectSpace(v20.UpVector)
            local Unit = v22:Cross(v21).Unit
            local v23 = -Unit
            local Size = MeshPart.Size
            local v26 = math.abs(v21.X) * Size.X + math.abs(v21.Y) * Size.Y + math.abs(v21.Z) * Size.Z
            local t4 = {}

            for _, v27 in ipairs(DimetSwim.BONES) do
                local v28 = CFrame:ToObjectSpace(t3[v27].WorldCFrame)

                t4[v27] = {
                    bone = t3[v27],
                    nose = v28:VectorToObjectSpace(v21),
                    up = v28:VectorToObjectSpace(v22),
                    lat = v28:VectorToObjectSpace(v23),
                    M = v28.Rotation
                }
            end

            local t5 = {}
            local t6 = {}

            for _, v29 in ipairs({ "L", "R" }) do
                local v30 = if v29 == "L" then 1 else -1
                local v31 = t4["Arm_" .. v29]
                local v32 = t4["Fore_" .. v29]
                local v33 = t4["Hand_" .. v29]

                t5[#t5 + 1] = {
                    s = v30,
                    b = {
                        v31.bone,
                        v32.bone,
                        v33.bone
                    },
                    M = {
                        v31.M,
                        v32.M,
                        v33.M
                    },
                    left = Unit,
                    up = v22,
                    back = -v21
                }

                local v34 = t4["Thigh_" .. v29]
                local v35 = t4["Shin_" .. v29]
                local v36 = t4["Foot_" .. v29]

                t6[#t6 + 1] = {
                    s = v30,
                    b = {
                        v34.bone,
                        v35.bone,
                        v36.bone
                    },
                    M = {
                        v34.M,
                        v35.M,
                        v36.M
                    },
                    left = Unit,
                    up = v22
                }
            end

            return {
                turn = 0,
                v = 0,
                t = 0,
                armed = true,
                biteT0 = nil,
                model = p18,
                mesh = MeshPart,
                A = t4,
                arms = t5,
                legs = t6,
                noseM = v21,
                phase = math.random(),
                length = v26
            }
        end,
        update = function(p19, p20) -- update | line: 142
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local DimetSwim = p1.DimetSwim
            local model = p19.model
            local _CFrame = p19.mesh.CFrame

            p19.t += p20

            if p19.lastPos and p20 > 1E-04 then
                local v37 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v37 < 2000 then
                    p19.v = p19.v + (v37 - p19.v) * math.min(1, p20 / DimetSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v40 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v41 = Vector3.new(v40.X, 0, v40.Z)

            if v41.Magnitude > 1E-04 then
                local Unit = v41.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v43 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v43 / DimetSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / DimetSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local PEN_HZ = DimetSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = DimetSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(DimetSwim.MAX_HZ, (math.max(p19.v / (DimetSwim.STRIDE * math.max(p19.length, 0.001)), DimetSwim.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then DimetSwim.ramOf(p19.v / math.max(PassCruise, 0.001)) else 0
            end

            if p19.armed and DimetSwim.BITE_R < n2 then
                p19.biteT0 = p19.t
                p19.armed = false
            elseif not p19.armed and n2 < DimetSwim.BITE_R / 2 then
                p19.armed = true
            end

            local v49 = DimetSwim.biteEnv(p19.biteT0 and p19.t - p19.biteT0 or nil)

            p19.phase = (p19.phase + p20 * PEN_HZ) % 1

            local phase, turn = p19.phase, p19.turn

            for v50, v51 in pairs(DimetSwim.body(phase, turn, n2, v49)) do
                local v52 = p19.A[v50]
                local v53 = CFrame.identity

                for _, v54 in ipairs(v51) do
                    v53 *= CFrame.fromAxisAngle(v52[v54[1]], v54[2])
                end

                v52.bone.Transform = v53
            end

            for _, v55 in ipairs(p19.arms) do
                local v56, v57, v58 = DimetSwim.arm(v55, phase, turn, n2)
                local t7 = {
                    CFrame.identity,
                    v56,
                    v57,
                    v58
                }

                for i = 1, 3 do
                    v55.b[i].Transform = v55.M[i]:Inverse() * t7[i]:Inverse() * t7[i + 1] * v55.M[i]
                end
            end

            for _, v59 in ipairs(p19.legs) do
                local v60, v61, v62 = DimetSwim.leg(v59, phase, turn, n2)
                local t8 = {
                    CFrame.identity,
                    v60,
                    v61,
                    v62
                }

                for j = 1, 3 do
                    v59.b[j].Transform = v59.M[j]:Inverse() * t8[j]:Inverse() * t8[j + 1] * v59.M[j]
                end
            end
        end
    }
end
