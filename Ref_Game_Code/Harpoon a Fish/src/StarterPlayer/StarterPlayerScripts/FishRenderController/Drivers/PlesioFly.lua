-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PlesioFly = {
        W_TAU = 0.2,
        V_TAU = 0.3,
        TURN_REF = 0.6,
        FIN_RATE = 1,
        FLAP = 0.5,
        HIND = 0.85,
        TIP = 0.25,
        TIP_LAG = 0.8,
        FEATHER = 0.4,
        SWEEP = 0.4,
        TURN_GAIN = 0.35,
        HIND_SWEEP = 0.35,
        LAG_SLOW = -0.7853981633974483,
        LAG_FAST = 1.5707963267948966,
        NECK_TILT = 0.2,
        LOOK = 0.12,
        LOOK_HEAD = 0.06,
        NOD = 0.05,
        TAIL_SWAY = 0.08,
        BEND = 0.6,
        HOOK_RATE = 7,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 2.8,
        PEN_SPEED = 0.5,
        PASS_STRIDE = 1.5,
        PASS_MIN_HZ = 0.2,
        NECK_SHARE = { 0.5, 0.3, 0.2 },
        TAIL = { "Tail_1", "Tail_2", "Tail_3" },
        TAIL_G = { 0.4, 0.7, 1 },
        pose = function(p3, p4, p5, p6, p7, p8) -- pose | line: 24
            -- upvalues: p1 (copy)
            local PlesioFly = p1.PlesioFly
            local t2 = {}
            local v3 = math.clamp(p4, 0, 1) * (math.clamp(p4 - 1, 0, 1) * 0.3 + 1)
            local v4 = 1 - math.clamp(p4, 0, 1)
            local v5 = PlesioFly.LAG_SLOW + (PlesioFly.LAG_FAST - PlesioFly.LAG_SLOW) * math.clamp(p7, 0, 1)

            for _, v6 in ipairs({
                    { "F", 0, 1, 1 },
                    {
                        "B",
                        v5,
                        PlesioFly.HIND,
                        PlesioFly.HIND_SWEEP
                    }
                }) do
                local v7 = p3 - v6[2]
                local v8 = v6[3]

                for _, v9 in ipairs({
                        { "L", 1, "outL" },
                        { "R", -1, "outR" }
                    }) do
                    local v10 = v9[2]
                    local v11 = PlesioFly.FLAP * v8 * v3 * (1 - v10 * PlesioFly.TURN_GAIN * p5)
                    local v12 = "Flip_" .. v6[1] .. v9[1]

                    t2[v12] = {
                        {
                            "nose",
                            v10 * v11 * math.sin(v7)
                        },
                        {
                            v9[3],
                            v10 * PlesioFly.FEATHER * v8 * v3 * math.cos(v7)
                        },
                        {
                            "up",
                            v10 * PlesioFly.SWEEP * v6[4] * v4
                        }
                    }
                    t2[v12 .. "_Tip"] = {
                        {
                            "nose",
                            v10 * PlesioFly.TIP * v8 * v3 * math.sin(v7 - PlesioFly.TIP_LAG)
                        }
                    }
                end
            end

            for v16, v17 in ipairs(PlesioFly.TAIL) do
                t2[v17] = {
                    {
                        "up",
                        PlesioFly.TAIL_SWAY * PlesioFly.TAIL_G[v16] * math.sin(p8 - 0.9 * (v16 - 1)) - PlesioFly.BEND * p6 / 3
                    }
                }
            end

            for v20, v21 in ipairs({ "Neck_1", "Neck_2", "Neck_3" }) do
                t2[v21] = {
                    {
                        "right",
                        -PlesioFly.NECK_TILT * PlesioFly.NECK_SHARE[v20]
                    },
                    {
                        "up",
                        PlesioFly.LOOK * p6 / 3
                    }
                }
            end

            table.insert(t2.Neck_1, {
                "right",
                -PlesioFly.NOD * v3 * math.max(0, (math.sin(p3 - 1.2)))
            })
            t2.Head = {
                {
                    "right",
                    PlesioFly.NECK_TILT
                },
                {
                    "up",
                    PlesioFly.LOOK_HEAD * p6
                }
            }

            return t2
        end,
        register = function(p9) -- register | line: 51
            local MeshPart = p9:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t4 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t4[descendant.Name] = descendant
                end
            end

            if not (t4.Body_1 and t4.Body_2 and t4.Head and t4.Flip_FL and t4.Flip_BR) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v25 = CFrame:VectorToObjectSpace(t4.Body_1.WorldPosition - t4.Body_2.WorldPosition)
            local Unit = Vector3.new(v25.X, 0, v25.Z).Unit
            local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit
            local t5 = {}

            for v26, v27 in pairs(t4) do
                local v28 = CFrame:ToObjectSpace(v27.WorldCFrame)

                t5[v26] = {
                    bone = v27,
                    up = v28:VectorToObjectSpace((Vector3.new(0, 1, 0))),
                    right = v28:VectorToObjectSpace(Unit2),
                    nose = v28:VectorToObjectSpace(Unit),
                    outL = v28:VectorToObjectSpace(-Unit2),
                    outR = v28:VectorToObjectSpace(Unit2)
                }
            end

            local Size = MeshPart.Size

            return {
                w = 0,
                v = 0,
                model = p9,
                mesh = MeshPart,
                A = t5,
                nose = Unit,
                phase = math.random() * 3.141592653589793 * 2,
                fin = math.random() * 6.28,
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            }
        end,
        update = function(p10, p11) -- update | line: 79
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PlesioFly = p1.PlesioFly
            local model = p10.model
            local PassCruise, v31

            if fightHooked(model) then
                p10.phase += p11 * PlesioFly.HOOK_RATE
                v31 = PlesioFly.HOOK_EFFORT
            elseif attr(model, "PassCruise") then
                PassCruise = attr(model, "PassCruise")
                p10.phase = p10.phase + p11 * 2 * 3.141592653589793 * math.max(p10.v / (PlesioFly.PASS_STRIDE * math.max(p10.length, 0.001)), PlesioFly.PASS_MIN_HZ)
                v31 = p10.v / math.max(PassCruise, 0.001)
            else
                p10.phase += p11 * PlesioFly.PEN_RATE
                v31 = 1
            end

            p10.fin += p11 * PlesioFly.FIN_RATE

            local _CFrame = p10.mesh.CFrame
            local v34 = _CFrame:VectorToWorldSpace(p10.nose)
            local v35 = Vector3.new(v34.X, 0, v34.Z)

            if p10.lastPos and p10.lastNose and p11 > 1E-04 and (_CFrame.Position - p10.lastPos).Magnitude < 20 and v35.Magnitude > 0.001 then
                local lastNose = p10.lastNose
                local Unit = v35.Unit
                local v37 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p11
                local v38 = (_CFrame.Position - p10.lastPos).Magnitude / p11

                p10.w = p10.w + (v37 - p10.w) * math.min(1, p11 / PlesioFly.W_TAU)
                p10.v = p10.v + (v38 - p10.v) * math.min(1, p11 / PlesioFly.V_TAU)
            end

            p10.lastPos = _CFrame.Position

            if v35.Magnitude > 0.001 then
                p10.lastNose = v35.Unit
            end

            local v44 = math.clamp(p10.w / PlesioFly.TURN_REF, -1, 1)
            local v47 = math.clamp(p10.length * p10.w / math.max(p10.v, 5), -0.9, 0.9)
            local v48 = PassCruise and p10.v / math.max(PassCruise, 1) or PlesioFly.PEN_SPEED

            for v49, v50 in pairs(PlesioFly.pose(p10.phase, math.max(v31, 0), v44, v47, v48, p10.fin)) do
                local v51 = p10.A[v49]

                if v51 then
                    local v52 = CFrame.identity

                    for _, v53 in ipairs(v50) do
                        v52 *= CFrame.fromAxisAngle(v51[v53[1]], v53[2])
                    end

                    v51.bone.Transform = v52
                end
            end
        end
    }
end
