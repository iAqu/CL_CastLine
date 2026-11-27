-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, _, attr = p2.fightHooked, p2.SwimScale, p2.attr

    p1.WhaleSwim = {
        register = function(p3) -- register | line: 15
            -- upvalues: attr (copy)
            local MeshPart = p3:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            if not (t2.body and t2["tail.01"]) then
                return nil
            end

            local CFrame = MeshPart.CFrame

            local function lp(p4) -- line: 24
                -- upvalues: CFrame (copy)
                return CFrame:PointToObjectSpace(p4.WorldPosition)
            end

            local Unit = (CFrame:PointToObjectSpace(t2.body.WorldPosition) - CFrame:PointToObjectSpace(t2["tail.01"].WorldPosition)).Unit
            local Unit2 = if t2["fin.L"] and t2["fin.R"] then CFrame:VectorToObjectSpace(t2["fin.R"].WorldPosition - t2["fin.L"].WorldPosition).Unit else Unit:Cross((Vector3.new(0, 1, 0))).Unit

            local function seg(p5, p6, p7) -- line: 33
                -- upvalues: CFrame (copy), Unit2 (copy)
                return {
                    bone = p5,
                    axis = CFrame:ToObjectSpace(p5.WorldCFrame):VectorToObjectSpace(Unit2),
                    gain = p6,
                    lag = p7
                }
            end

            local body = t2.body
            local t3 = {
                gain = 0.14,
                lag = 0,
                bone = body,
                axis = CFrame:ToObjectSpace(body.WorldCFrame):VectorToObjectSpace(Unit2)
            }
            local v1 = t2["tail.01"]
            local t4 = {
                t3,
                {
                    gain = 0.5,
                    lag = 0.7,
                    bone = v1,
                    axis = CFrame:ToObjectSpace(v1.WorldCFrame):VectorToObjectSpace(Unit2)
                }
            }

            if t2["tail.02"] then
                local v2 = #t4 + 1
                local v3 = t2["tail.02"]

                t4[v2] = {
                    gain = 1,
                    lag = 1.3,
                    bone = v3,
                    axis = CFrame:ToObjectSpace(v3.WorldCFrame):VectorToObjectSpace(Unit2)
                }
            end

            local v4 = Random.new()
            local t5 = {}

            for _, v5 in ipairs({ "L", "R" }) do
                local v6 = t2["fin." .. v5]

                if v6 then
                    local v7 = CFrame:ToObjectSpace(v6.WorldCFrame)

                    t5[#t5 + 1] = {
                        bone = v6,
                        axis = v7:VectorToObjectSpace(Unit),
                        phase = v4:NextNumber(0, 6.283185307179586),
                        freq = v4:NextNumber(0.25, 0.45),
                        sign = v5 == "L" and 1 or -1
                    }
                end
            end

            return {
                slowSpeed = 0,
                warp = 0.3,
                model = p3,
                mesh = MeshPart,
                chain = t4,
                fins = t5,
                phase = v4:NextNumber(0, 6.283185307179586),
                ampMul = attr(p3, "WaveAmp") or 1,
                beatMul = attr(p3, "WaveBeat") or 1
            }
        end,
        update = function(p8, p9, p10) -- update | line: 61
            -- upvalues: fightHooked (copy), attr (copy)
            local AssemblyLinearVelocity = p8.mesh.AssemblyLinearVelocity
            local Magnitude = AssemblyLinearVelocity.Magnitude

            p8.slowSpeed = p8.slowSpeed + (Magnitude - p8.slowSpeed) * math.min(1, p9 * 2)

            local v12 = math.clamp(AssemblyLinearVelocity.Y / 6, -1, 1)

            p8.warp = p8.warp + (v12 * 0.5 - p8.warp) * math.min(1, p9 * 2)

            local v15

            if fightHooked(p8.model) then
                v15 = 0.5
                p8.phase += p9 * 7
            else
                local v16 = (0.1 + 0.008 * p8.slowSpeed) * p8.ampMul

                v15 = math.clamp(v16, 0.1, 0.5)

                local v17 = (1.6 + p8.slowSpeed * 0.1) * p8.beatMul / (attr(p8.model, "Size") or 1)
                local v23 = (math.clamp((Magnitude - p8.slowSpeed) / math.max(p8.slowSpeed * 0.22, 1.5), -1.2, 1.2) - math.sin(p8.phase)) * math.cos(p8.phase)

                p8.phase += p9 * (v17 + v23 * 4)
            end

            for _, v24 in ipairs(p8.chain) do
                local v25 = p8.phase - v24.lag
                local v26 = v25 - p8.warp * math.sin(v25)
                local v27 = v15 * v24.gain * math.sin(v26)

                if v24.gain < 0.2 then
                    v27 -= v15 * 0.35 * math.sin(v26 - 1.6)
                end

                v24.bone.Transform = CFrame.fromAxisAngle(v24.axis, v27)
            end

            for _, v30 in ipairs(p8.fins) do
                local v34 = v30.sign * (math.sin(p10 * v30.freq * 3.141592653589793 * 2 + v30.phase) * 0.1 + math.sin(p8.phase - 1) * 0.05)

                v30.bone.Transform = CFrame.fromAxisAngle(v30.axis, v34)
            end
        end
    }
end
