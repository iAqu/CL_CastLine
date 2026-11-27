-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.SquidJet = {
        W_TAU = 0.2,
        TURN_REF = 0.6,
        V_TAU = 0.3,
        PEN_JET = 1.4,
        HOOK_JET = 0.35,
        FIN_MIN_HZ = 1.2,
        FIN_STRIDE = 0.8,
        HOOK_RATE = 18,
        HOOK_EFFORT = 1.5,
        PEN_RATE = 4.5,
        SPREAD = 0.22,
        PINCH = 0.1,
        CURL = 0.12,
        WAVE = 0.07,
        WAVE_RATE = 2.4,
        WAVE_LAG = 0.9,
        ARM_TURN = 0.12,
        FIN_SLOW = 0.55,
        FIN_FAST = 0.15,
        FIN_VL = { 0.5, 2 },
        smooth = function(p3) -- smooth | line: 31
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        squeeze = function(p4, p5, p6) -- squeeze | line: 36
            -- upvalues: p1 (copy)
            if p4 < p5 then
                return p1.SquidJet.smooth(p4 / p5)
            end

            return (math.exp(-(p4 - p5) * p6))
        end,
        finAmp = function(p7) -- finAmp | line: 40
            -- upvalues: p1 (copy)
            local SquidJet = p1.SquidJet
            local v4 = math.clamp((p7 - SquidJet.FIN_VL[1]) / (SquidJet.FIN_VL[2] - SquidJet.FIN_VL[1]), 0, 1)

            return SquidJet.FIN_SLOW + (SquidJet.FIN_FAST - SquidJet.FIN_SLOW) * v4
        end,
        pose = function(p8, p9, p10, p11, p12, p13, p14, p15) -- pose | line: 47
            -- upvalues: p1 (copy)
            local SquidJet = p1.SquidJet
            local v5 = SquidJet.squeeze(p8, p13 or 0.15, p14 or 3)

            p15 = p15 or 1

            local t2 = {}

            for i = 1, 8 do
                local v7 = i * 0.785
                local v8 = 1 - v5
                local v9 = p15 * SquidJet.WAVE * (1 - 0.7 * v5)
                local v10 = -SquidJet.ARM_TURN * p10

                t2["Arm_" .. i .. "_1"] = {
                    {
                        "spread",
                        p15 * (SquidJet.SPREAD * v8 - SquidJet.PINCH * v5)
                    },
                    { "up", v10 }
                }

                for j = 2, 3 do
                    local v11 = p12 * SquidJet.WAVE_RATE + v7 - SquidJet.WAVE_LAG * j

                    t2["Arm_" .. i .. "_" .. j] = {
                        {
                            "spread",
                            p15 * SquidJet.CURL * v8
                        },
                        {
                            "up",
                            v10 + v9 * math.sin(v11)
                        },
                        {
                            "lat",
                            v9 * math.cos(v11)
                        }
                    }
                end
            end

            local v12 = SquidJet.finAmp(p9) * math.sin(p11)

            t2.Fin_U = { { "travel", v12 } }
            t2.Fin_D = { { "travel", -v12 } }

            return t2
        end,
        register = function(p16) -- register | line: 68
            -- upvalues: attr (copy)
            local MeshPart = p16:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p16, "AnatomyInverse")

            if MeshPart and typeof(AnatomyInverse) == "CFrame" then
                local t3 = {}

                for _, descendant in ipairs(MeshPart:GetDescendants()) do
                    if descendant:IsA("Bone") then
                        t3[descendant.Name] = descendant
                    end
                end

                local v13 = attr(p16, "SquidFinless") == true

                if t3.Mantle and (t3.Fin_U or t3.Fin_L or v13) and (t3.Fin_D or t3.Fin_R or v13) and t3.Arm_1_1 and t3.Arm_8_3 then
                    local CFrame = MeshPart.CFrame
                    local v14 = p16:GetPivot() * AnatomyInverse:Inverse()
                    local v15 = CFrame:VectorToObjectSpace(v14.RightVector)
                    local v16 = CFrame:VectorToObjectSpace(v14.UpVector)
                    local Unit = v15:Cross(v16).Unit
                    local v17 = CFrame:PointToObjectSpace(t3.Mantle.WorldPosition)
                    local t4 = {}

                    for v18, v19 in pairs(t3) do
                        local v20 = CFrame:ToObjectSpace(v19.WorldCFrame)
                        local t5 = {
                            bone = v19,
                            travel = v20:VectorToObjectSpace(v15),
                            up = v20:VectorToObjectSpace(v16),
                            lat = v20:VectorToObjectSpace(Unit)
                        }
                        local v21 = v18:match("^Arm_(%d)_")

                        if v21 then
                            local v22 = CFrame:PointToObjectSpace(t3["Arm_" .. v21 .. "_1"].WorldPosition) - v17
                            local Unit = (v22 - v15 * v22:Dot(v15)).Unit

                            t5.spread = v20:VectorToObjectSpace((-v15):Cross(Unit).Unit)
                        end

                        t4[v18] = t5
                    end

                    local v23 = t4.Fin_U or t4.Fin_L
                    local v24 = t4.Fin_D or t4.Fin_R

                    t4.Fin_U = v23
                    t4.Fin_D = v24

                    local Size = MeshPart.Size

                    return {
                        w = 0,
                        v = 0,
                        model = p16,
                        mesh = MeshPart,
                        A = t4,
                        travel = v15,
                        jet = math.random(),
                        fin = math.random() * 6.28,
                        phase = math.random() * 2 * 3.141592653589793,
                        arm = attr(p16, "ArmAmp") or 1,
                        length = math.abs(v15.X) * Size.X + math.abs(v15.Y) * Size.Y + math.abs(v15.Z) * Size.Z
                    }
                end
            end

            return nil
        end,
        update = function(p17, p18, p19) -- update | line: 105
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local SquidJet = p1.SquidJet
            local model = p17.model
            local JetAt = attr(model, "JetAt")
            local v27, v28, v29

            if fightHooked(model) then
                p17.jet = (p17.jet + p18 / SquidJet.HOOK_JET) % 1
                v27 = p17.jet
            elseif JetAt then
                local v30 = attr(model, "JetPeriod") or SquidJet.PEN_JET

                v27 = (workspace:GetServerTimeNow() - p2.renderLag() - JetAt) / v30 % 1
                v28 = attr(model, "JetRise")
                v29 = attr(model, "JetDecay")
            elseif attr(model, "StrokeAt") then
                p1.StrokeClock.lock(p17, p18, SquidJet)
                v27 = (p17.phase / 6.283185307179586 + 0.075) % 1
            else
                p17.jet = (p17.jet + p18 / SquidJet.PEN_JET) % 1
                v27 = p17.jet
            end

            local _CFrame = p17.mesh.CFrame
            local v31 = _CFrame:VectorToWorldSpace(p17.travel)
            local v32 = Vector3.new(v31.X, 0, v31.Z)

            if p17.lastPos and p17.lastFlat and p18 > 1E-04 and (_CFrame.Position - p17.lastPos).Magnitude < 20 and v32.Magnitude > 0.001 then
                local lastFlat = p17.lastFlat
                local Unit = v32.Unit

                p17.w = p17.w + (math.atan2(lastFlat:Cross(Unit).Y, (lastFlat:Dot(Unit))) / p18 - p17.w) * math.min(1, p18 / SquidJet.W_TAU)
                p17.v = p17.v + ((_CFrame.Position - p17.lastPos).Magnitude / p18 - p17.v) * math.min(1, p18 / SquidJet.V_TAU)
            end

            p17.lastPos = _CFrame.Position

            if v32.Magnitude > 0.001 then
                p17.lastFlat = v32.Unit
            end

            local v38 = p17.v / math.max(p17.length, 0.001)

            p17.fin = p17.fin + p18 * 2 * 3.141592653589793 * math.max(SquidJet.FIN_MIN_HZ, v38 / SquidJet.FIN_STRIDE)

            local v42 = SquidJet.pose(v27, v38, math.clamp(p17.w / SquidJet.TURN_REF, -1, 1), p17.fin, p19, v28, v29, p17.arm)

            for v43, v44 in pairs(v42) do
                local v45 = p17.A[v43]

                if v45 then
                    local v46 = CFrame.identity

                    for _, v47 in ipairs(v44) do
                        v46 *= CFrame.fromAxisAngle(v45[v47[1]], v47[2])
                    end

                    v45.bone.Transform = v46
                end
            end
        end
    }
end
