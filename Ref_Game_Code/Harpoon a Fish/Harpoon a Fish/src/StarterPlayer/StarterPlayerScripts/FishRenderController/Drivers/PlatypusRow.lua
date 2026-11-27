-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 20
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PlatypusRow = {
        UA_SWAY = 0.15,
        UA_SHARE = 0.35,
        AZ_MID = 1.3962634015954636,
        AZ_AMP = 1.0471975511965976,
        EL_MID = 0.8203047484373349,
        EL_AMP = 0.3839724354387525,
        F_PEAK = 0.25,
        PALM = 1.2217304763960306,
        FLEX = 0.6108652381980153,
        TURN_GAIN = 0.25,
        YAW = 0.06,
        YAW_LAG = 0.6,
        ROLL = 0.04,
        WAVE = {
            { "Lumbar", 0.04, 1.1 },
            { "Pelvis", 0.07, 1.6 },
            { "Tail_1", 0.14, 2.2 },
            { "Tail_2", 0.18, 2.8 }
        },
        NECK_STEADY = 0.6,
        NOD = 0.02,
        BEND = 0.12,
        LOOK = 0.2,
        HIND_TRAIL = -0.3,
        HIND_IN = 0.1,
        HIND_RUDDER = -0.08,
        FOOT_FLUTTER = 0.06,
        PASS_STRIDE = 0.8,
        PASS_MIN_HZ = 0.2,
        HOOK_HZ = 2,
        PEN_HZ = 0.8,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        BONES = {
            "Chest",
            "Lumbar",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Neck",
            "Head",
            "Fore_L",
            "Fore_L_2",
            "Fore_L_3",
            "Fore_R",
            "Fore_R_2",
            "Fore_R_3",
            "Hind_L",
            "Hind_L_2",
            "Hind_R",
            "Hind_R_2"
        },
        turn = function(p3, p4, p5) -- turn | line: 37
            local Unit = p3.Unit
            local Unit2 = p4.Unit
            local v1 = Unit:Cross(Unit2)
            local Magnitude = v1.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v1 / Magnitude, math.atan2(Magnitude, (Unit:Dot(Unit2))) * (p5 or 1))
        end,
        body = function(p6, p7) -- body | line: 45
            -- upvalues: p1 (copy)
            local PlatypusRow = p1.PlatypusRow
            local v4 = 6.283185307179586 * p6
            local v7 = -PlatypusRow.YAW * math.sin(v4 - PlatypusRow.YAW_LAG)
            local t2 = {
                Chest = {
                    {
                        "up",
                        v7
                    },
                    {
                        "nose",
                        PlatypusRow.ROLL * math.sin(v4 - PlatypusRow.YAW_LAG)
                    }
                },
                Neck = {
                    {
                        "up",
                        -PlatypusRow.NECK_STEADY * v7 + 0.4 * PlatypusRow.LOOK * p7
                    },
                    {
                        "lat",
                        PlatypusRow.NOD * math.sin(2 * v4)
                    }
                },
                Head = {
                    {
                        "up",
                        0.6 * PlatypusRow.LOOK * p7
                    }
                }
            }

            for _, v10 in ipairs(PlatypusRow.WAVE) do
                t2[v10[1]] = {
                    {
                        "up",
                        v10[2] * math.sin(v4 - v10[3]) - PlatypusRow.BEND * p7 / #PlatypusRow.WAVE
                    }
                }
            end

            for _, v14 in ipairs({ "L", "R" }) do
                local v15 = if v14 == "L" then 1 else -1

                t2["Hind_" .. v14] = {
                    {
                        "up",
                        -PlatypusRow.BEND * p7 - PlatypusRow.HIND_RUDDER * p7
                    },
                    {
                        "lat",
                        PlatypusRow.HIND_TRAIL
                    },
                    {
                        "nose",
                        -v15 * PlatypusRow.HIND_IN
                    }
                }
                t2["Hind_" .. v14 .. "_2"] = {
                    {
                        "up",
                        v15 * PlatypusRow.FOOT_FLUTTER * math.sin(2 * v4 - 1)
                    }
                }
            end

            return t2
        end,
        arm = function(p8, p9, p10) -- arm | line: 65
            -- upvalues: p1 (copy)
            local PlatypusRow = p1.PlatypusRow
            local s = p8.s
            local v19 = (p9 + (if s == 1 then 0 else 0.5)) % 1
            local v20 = 6.283185307179586 * v19
            local v21 = 1 - s * PlatypusRow.TURN_GAIN * p10
            local v22 = PlatypusRow.AZ_MID - v21 * PlatypusRow.AZ_AMP * math.cos(v20)
            local v23 = PlatypusRow.EL_MID - v21 * PlatypusRow.EL_AMP * math.sin(v20)
            local v24 = p8.left * (s * math.sin(v22) * math.cos(v23)) + p8.back * (-math.cos(v22) * math.cos(v23)) + p8.up * -math.sin(v23)
            local v25 = CFrame.fromAxisAngle(p8.up, -s * PlatypusRow.UA_SWAY * math.cos(v20)) * PlatypusRow.turn(p8.fore0, v24, PlatypusRow.UA_SHARE)
            local v26 = PlatypusRow.turn(v25 * p8.fore0, v24) * v25
            local v28 = math.cos(6.283185307179586 * (v19 - PlatypusRow.F_PEAK)) * 0.5 + 0.5
            local v29 = v28 * v28 * (3 - v28 * 2)
            local Unit = (v26 * p8.paw0).Unit
            local v30 = v26 * p8.hinge0

            return v25, v26, CFrame.fromAxisAngle(Unit, s * PlatypusRow.PALM * v29) * CFrame.fromAxisAngle(v30, -PlatypusRow.FLEX * (1 - v29)) * v26
        end,
        register = function(p11) -- register | line: 83
            -- upvalues: p1 (copy), attr (copy)
            local PlatypusRow = p1.PlatypusRow
            local MeshPart = p11:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p11, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t5 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t5[descendant.Name] = descendant
                end
            end

            for _, v31 in ipairs(PlatypusRow.BONES) do
                if not t5[v31] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v32 = p11:GetPivot() * AnatomyInverse:Inverse()
            local v33 = CFrame:VectorToObjectSpace(v32.RightVector)
            local v34 = CFrame:VectorToObjectSpace(v32.UpVector)
            local Unit = v33:Cross(v34).Unit
            local t6 = {}

            for _, v35 in ipairs(PlatypusRow.BONES) do
                local v36 = t5[v35]
                local v37 = CFrame:ToObjectSpace(v36.WorldCFrame)

                t6[v35] = {
                    bone = v36,
                    nose = v37:VectorToObjectSpace(v33),
                    up = v37:VectorToObjectSpace(v34),
                    lat = v37:VectorToObjectSpace(Unit),
                    pos = v37.Position,
                    M = v37.Rotation
                }
            end

            local t7 = {}

            for _, v38 in ipairs({ "L", "R" }) do
                local v39 = t6["Fore_" .. v38]
                local v40 = t6["Fore_" .. v38 .. "_2"]
                local v41 = t6["Fore_" .. v38 .. "_3"]
                local v42 = v41.M * Vector3.new(0, 1, 0)

                t7[#t7 + 1] = {
                    s = v38 == "L" and 1 or -1,
                    b = {
                        v39.bone,
                        v40.bone,
                        v41.bone
                    },
                    M = {
                        v39.M,
                        v40.M,
                        v41.M
                    },
                    fore0 = v41.pos - v40.pos,
                    paw0 = v42,
                    hinge0 = v42:Cross(v34).Unit,
                    left = -Unit,
                    back = -v33,
                    up = v34
                }
            end

            local Size = MeshPart.Size

            return {
                turn = 0,
                v = 0,
                model = p11,
                mesh = MeshPart,
                A = t6,
                legs = t7,
                nose = v33,
                phase = math.random(),
                length = math.abs(v33.X) * Size.X + math.abs(v33.Y) * Size.Y + math.abs(v33.Z) * Size.Z
            }
        end,
        update = function(p12, p13, _) -- update | line: 121
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PlatypusRow = p1.PlatypusRow
            local model = p12.model
            local _CFrame = p12.mesh.CFrame
            local v46 = _CFrame:VectorToWorldSpace(p12.nose)
            local v47 = Vector3.new(v46.X, 0, v46.Z)

            if p12.lastPos and p12.lastNose and p13 > 1E-04 and (_CFrame.Position - p12.lastPos).Magnitude < 20 and v47.Magnitude > 0.001 then
                local lastNose = p12.lastNose
                local Unit = v47.Unit
                local v49 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p13
                local v50 = (_CFrame.Position - p12.lastPos).Magnitude / p13

                p12.turn = p12.turn + (math.clamp(v49 / PlatypusRow.TURN_FULL, -1, 1) - p12.turn) * math.min(1, p13 / PlatypusRow.TURN_TAU)
                p12.v = p12.v + (v50 - p12.v) * math.min(1, p13 / PlatypusRow.V_TAU)
            end

            p12.lastPos = _CFrame.Position

            if v47.Magnitude > 0.001 then
                p12.lastNose = v47.Unit
            end

            local v56 = if fightHooked(model) then PlatypusRow.HOOK_HZ elseif attr(model, "PassCruise") then math.max(p12.v / (PlatypusRow.PASS_STRIDE * math.max(p12.length, 0.001)), PlatypusRow.PASS_MIN_HZ) else PlatypusRow.PEN_HZ

            p12.phase = (p12.phase + p13 * v56) % 1

            local phase, turn = p12.phase, p12.turn

            for v58, v59 in pairs(PlatypusRow.body(phase, turn)) do
                local v60 = p12.A[v58]
                local v61 = CFrame.identity

                for _, v62 in ipairs(v59) do
                    v61 *= CFrame.fromAxisAngle(v60[v62[1]], v62[2])
                end

                v60.bone.Transform = v61
            end

            for _, v63 in ipairs(p12.legs) do
                local v64, v65, v66 = PlatypusRow.arm(v63, phase, turn)
                local t10 = {
                    CFrame.identity,
                    v64,
                    v65,
                    v66
                }

                for i = 1, 3 do
                    v63.b[i].Transform = v63.M[i]:Inverse() * t10[i]:Inverse() * t10[i + 1] * v63.M[i]
                end
            end
        end
    }
end
