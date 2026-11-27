-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.TurtleFly = {
        LOCK = 10,
        W_TAU = 0.25,
        TURN_REF = 0.5,
        FIN_RATE = 1.2,
        HOOK_RATE = 6,
        HOOK_EFFORT = 1.4,
        PEN_RATE = 1.6,
        V_TAU = 0.3,
        PASS_MIN_HZ = 0.2,
        KEYS_U = { -0.16666666666666666, 0.16666666666666666, 0.5, 0.6666666666666666, 0.8333333333333334 },
        KEYS_F = { 0.7, -0.45, -0.15, 0.3, 0.7 },
        KEYS_S = { 0.3, -0.35, -1.15, -0.3, 0.3 },
        KEYS_P = { 0.45, -0.1, 0, -0.35, 0.45 },
        GLIDE = 3,
        TIP_LAG = 0.06,
        TIP_F = 1.2,
        TIP_S = 0.5,
        TURN_GAIN = 0.35,
        KICK = 0.25,
        REAR_BEAT = 0.12,
        RUDDER = 0.3,
        TAIL_SWAY = 0.12,
        BODY_BOB = 0.03,
        HEAD_BOB = 0.07,
        HEAD_LAG = 1,
        HEAD_TURN = 0.35,
        HEAD_LOOK = 0.12,
        HEAD_LOOK_RATE = 0.35,
        REAR_SWEEP = 0.45,
        REAR_TIP = 0.8,
        REAR_LAG = 0.6,
        curve = function(p3, p4) -- curve | line: 51
            -- upvalues: p1 (copy)
            local KEYS_U = p1.TurtleFly.KEYS_U
            local v1 = #KEYS_U - 1
            local v2 = (p4 - KEYS_U[1]) % 1 + KEYS_U[1]
            local n1 = 0

            while n1 < v1 - 1 and KEYS_U[n1 + 2] <= v2 do
                n1 += 1
            end

            local function key(p5) -- line: 59
                -- upvalues: p3 (copy), KEYS_U (copy), v1 (copy)
                local v3 = p5 % v1

                return KEYS_U[v3 + 1] + (p5 - v3) // v1, p3[v3 + 1]
            end

            local function slope(p6) -- line: 63
                -- upvalues: p3 (copy), KEYS_U (copy), v1 (copy)
                local v4 = p6 - 1
                local v5 = v4 % v1
                local v6 = KEYS_U[v5 + 1] + (v4 - v5) // v1
                local v7 = p3[v5 + 1]
                local v8 = p6 % v1
                local _ = KEYS_U[v8 + 1] + (p6 - v8) // v1
                local v9 = p3[v8 + 1]
                local v10 = p6 + 1
                local v11 = v10 % v1
                local v12 = KEYS_U[v11 + 1] + (v10 - v11) // v1
                local v13 = p3[v11 + 1]

                if (v9 - v7) * (v13 - v9) <= 0 then
                    return 0
                end

                return (v13 - v7) / (v12 - v6)
            end

            local v14 = n1 % v1
            local v15 = KEYS_U[v14 + 1] + (n1 - v14) // v1
            local v16 = p3[v14 + 1]
            local v17 = n1 + 1
            local v18 = v17 % v1
            local v19 = KEYS_U[v18 + 1] + (v17 - v18) // v1
            local v20 = p3[v18 + 1]
            local v21 = v19 - v15
            local v22 = (v2 - v15) / v21
            local v23 = n1 - 1
            local v24 = v23 % v1
            local v25 = KEYS_U[v24 + 1] + (v23 - v24) // v1
            local v26 = p3[v24 + 1]
            local v27 = n1 % v1
            local _ = KEYS_U[v27 + 1] + (n1 - v27) // v1
            local v28 = p3[v27 + 1]
            local v29 = n1 + 1
            local v30 = v29 % v1
            local v31 = KEYS_U[v30 + 1] + (v29 - v30) // v1
            local v32 = p3[v30 + 1]
            local v33 = (if (v28 - v26) * (v32 - v28) <= 0 then 0 else (v32 - v26) / (v31 - v25)) * v21
            local v34 = n1 + 1
            local v35 = v34 - 1
            local v36 = v35 % v1
            local v37 = KEYS_U[v36 + 1] + (v35 - v36) // v1
            local v38 = p3[v36 + 1]
            local v39 = v34 % v1
            local _ = KEYS_U[v39 + 1] + (v34 - v39) // v1
            local v40 = p3[v39 + 1]
            local v41 = v34 + 1
            local v42 = v41 % v1
            local v43 = KEYS_U[v42 + 1] + (v41 - v42) // v1
            local v44 = p3[v42 + 1]
            local v45 = (if (v40 - v38) * (v44 - v40) <= 0 then 0 else (v44 - v38) / (v43 - v37)) * v21
            local v46 = v22 * v22
            local v47 = v22 * v22 * v22

            return (2 * v47 - 3 * v46 + 1) * v16 + (v47 - 2 * v46 + v22) * v33 + (-2 * v47 + 3 * v46) * v20 + (v47 - v46) * v45
        end,
        pose = function(p7, p8, p9, p10, p11, p12) -- pose | line: 79
            -- upvalues: p1 (copy)
            local TurtleFly = p1.TurtleFly
            local v48 = p7 / 6.283185307179586
            local v51 = math.clamp(p8, 0, 1) * (1 + TurtleFly.KICK * math.clamp(p8 - 1, 0, 1))
            local t2 = {}

            for _, v52 in ipairs({
                    { "leg.F.L", 1 },
                    { "leg.F.R", -1 }
                }) do
                local v53 = v52[1]
                local v54 = v52[2]
                local v55 = v51 * (1 - TurtleFly.TURN_GAIN * v54 * p9)
                local v56 = TurtleFly.KEYS_F[TurtleFly.GLIDE]
                local v57 = TurtleFly.KEYS_S[TurtleFly.GLIDE]
                local v58 = TurtleFly.KEYS_P[TurtleFly.GLIDE]
                local v59 = v56 + (TurtleFly.curve(TurtleFly.KEYS_F, v48) - v56) * v55
                local v60 = v57 + (TurtleFly.curve(TurtleFly.KEYS_S, v48) - v57) * v55 + (p11 or 0)
                local v61 = v58 + (TurtleFly.curve(TurtleFly.KEYS_P, v48) - v58) * v55
                local v62 = TurtleFly.TIP_F * (TurtleFly.curve(TurtleFly.KEYS_F, v48 - TurtleFly.TIP_LAG) - TurtleFly.curve(TurtleFly.KEYS_F, v48)) * v55
                local v63 = TurtleFly.TIP_S * (TurtleFly.curve(TurtleFly.KEYS_S, v48 - TurtleFly.TIP_LAG) - TurtleFly.curve(TurtleFly.KEYS_S, v48)) * v55

                t2[v53] = {
                    {
                        "nose",
                        v54 * v59
                    },
                    {
                        "up",
                        -v54 * v60
                    },
                    {
                        "span",
                        v54 * v61
                    }
                }
                t2[v53 .. ".02"] = {
                    {
                        "nose",
                        v54 * v62
                    },
                    {
                        "up",
                        -v54 * v63
                    }
                }
            end

            for _, v64 in ipairs({
                    { "leg.B.L", 1 },
                    { "leg.B.R", -1 }
                }) do
                local v65 = v64[1]
                local v66 = v64[2]

                if p12 then
                    local v67 = -p12 * v51 * math.sin(p7)

                    t2[v65] = {
                        {
                            "up",
                            TurtleFly.RUDDER * p9 - v66 * TurtleFly.REAR_SWEEP * p12 * v51 * math.cos(p7)
                        },
                        {
                            "nose",
                            v66 * v67
                        }
                    }
                    t2[v65 .. ".02"] = {
                        {
                            "nose",
                            -v66 * TurtleFly.REAR_TIP * p12 * v51 * math.sin(p7 - TurtleFly.REAR_LAG)
                        }
                    }
                else
                    local v71 = TurtleFly.REAR_BEAT * v51 * math.sin(p7)

                    t2[v65] = {
                        {
                            "up",
                            TurtleFly.RUDDER * p9
                        },
                        {
                            "nose",
                            v66 * v71
                        }
                    }
                    t2[v65 .. ".02"] = {
                        {
                            "nose",
                            v66 * 0.5 * v71
                        }
                    }
                end
            end

            t2["tail.01"] = {
                {
                    "up",
                    TurtleFly.TAIL_SWAY * math.sin(p10) - 0.2 * p9
                }
            }
            t2.body = {
                {
                    "lat",
                    TurtleFly.BODY_BOB * v51 * math.sin(p7)
                }
            }
            t2.head = {
                {
                    "lat",
                    TurtleFly.HEAD_BOB * v51 * math.sin(p7 - TurtleFly.HEAD_LAG)
                },
                {
                    "up",
                    TurtleFly.HEAD_TURN * p9 + TurtleFly.HEAD_LOOK * math.sin(p10 * TurtleFly.HEAD_LOOK_RATE)
                }
            }

            return t2
        end,
        register = function(p13) -- register | line: 115
            -- upvalues: attr (copy)
            local MeshPart = p13:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p13, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t4 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t4[descendant.Name] = descendant
                end
            end

            for _, v76 in ipairs({ "body", "tail.01", "leg.F.L", "leg.F.L.02", "leg.F.R", "leg.F.R.02", "leg.B.L", "leg.B.R" }) do
                if not t4[v76] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v77 = p13:GetPivot() * AnatomyInverse:Inverse()
            local v78 = CFrame:VectorToObjectSpace(v77.RightVector)
            local v79 = CFrame:VectorToObjectSpace(v77.UpVector)
            local Unit = v78:Cross(v79).Unit
            local t5 = {}

            for v80, v81 in pairs(t4) do
                local v82 = CFrame:ToObjectSpace(v81.WorldCFrame)
                local t6 = {
                    bone = v81,
                    nose = v82:VectorToObjectSpace(v78),
                    up = v82:VectorToObjectSpace(v79),
                    lat = v82:VectorToObjectSpace(Unit)
                }
                local v83 = t4[v80 .. ".02"]

                if v83 and v80:find("^leg%.F") then
                    t6.span = v82:VectorToObjectSpace(CFrame:VectorToObjectSpace((v83.WorldPosition - v81.WorldPosition).Unit))
                end

                t5[v80] = t6
            end

            local t7 = {
                w = 0,
                model = p13,
                mesh = MeshPart,
                A = t5,
                nose = v78,
                phase = math.random() * 3.141592653589793 * 2,
                fin = math.random() * 6.28
            }
            local TurtleSweep = attr(p13, "TurtleSweep")

            if typeof(TurtleSweep) == "number" then
                t7.sweep = TurtleSweep
            end

            local TurtleRear = attr(p13, "TurtleRear")

            if typeof(TurtleRear) == "number" then
                t7.rear = TurtleRear
            end

            local TurtlePass = attr(p13, "TurtlePass")

            if typeof(TurtlePass) == "number" and TurtlePass > 0 then
                local Size = MeshPart.Size

                t7.pass = TurtlePass
                t7.v = 0
                t7.length = math.abs(v78.X) * Size.X + math.abs(v78.Y) * Size.Y + math.abs(v78.Z) * Size.Z
            end

            return t7
        end,
        update = function(p14, p15, _) -- update | line: 158
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local TurtleFly = p1.TurtleFly
            local model = p14.model
            local StrokeAt = attr(model, "StrokeAt")
            local HOOK_EFFORT = 1

            if fightHooked(model) then
                p14.phase += p15 * TurtleFly.HOOK_RATE
                HOOK_EFFORT = TurtleFly.HOOK_EFFORT
                p14.locked = nil
            elseif not StrokeAt and p14.pass and attr(model, "PassCruise") then
                local PassCruise = attr(model, "PassCruise")

                p14.phase = p14.phase + p15 * 2 * 3.141592653589793 * math.max(p14.v / (p14.pass * math.max(p14.length, 0.001)), TurtleFly.PASS_MIN_HZ)
                HOOK_EFFORT = p14.v / math.max(PassCruise, 0.001)
                p14.locked = nil
            elseif StrokeAt then
                local v88 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v88 / math.max(attr(model, "StrokeCruise") or v88, 0.001)

                local v90 = (attr(model, "StrokePhase") or 0) + v88 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p14.locked then
                    p14.phase += p15 * v88
                    p14.phase = p14.phase + ((v90 - p14.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p15 * TurtleFly.LOCK)
                else
                    p14.phase = v90
                    p14.locked = true
                end
            else
                p14.phase += p15 * (attr(model, "StrokeHz") or TurtleFly.PEN_RATE)
                p14.locked = nil
            end

            p14.fin += p15 * TurtleFly.FIN_RATE

            local _CFrame = p14.mesh.CFrame
            local v93 = _CFrame:VectorToWorldSpace(p14.nose)
            local v94 = Vector3.new(v93.X, 0, v93.Z)

            if p14.lastNose and p15 > 1E-04 and v94.Magnitude > 0.001 then
                local lastNose = p14.lastNose
                local Unit = v94.Unit
                local v96 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p15

                p14.w = p14.w + (v96 - p14.w) * math.min(1, p15 / TurtleFly.W_TAU)
            end

            if v94.Magnitude > 0.001 then
                p14.lastNose = v94.Unit
            end

            if p14.pass then
                if p14.lastPos and p15 > 1E-04 and (_CFrame.Position - p14.lastPos).Magnitude < 20 then
                    local v99 = (_CFrame.Position - p14.lastPos).Magnitude / p15

                    p14.v = p14.v + (v99 - p14.v) * math.min(1, p15 / TurtleFly.V_TAU)
                end

                p14.lastPos = _CFrame.Position
            end

            local v103 = TurtleFly.pose(p14.phase, HOOK_EFFORT, math.clamp(p14.w / TurtleFly.TURN_REF, -1, 1), p14.fin, p14.sweep, p14.rear)

            for v104, v105 in pairs(v103) do
                local v106 = p14.A[v104]

                if v106 then
                    local v107 = CFrame.identity

                    for _, v108 in ipairs(v105) do
                        v107 *= CFrame.fromAxisAngle(v106[v108[1]], v108[2])
                    end

                    v106.bone.Transform = v107
                end
            end
        end
    }
end
