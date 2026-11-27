-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.FishWave = {
        register = function(p3) -- register | line: 18
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

            local Spine_01 = t2.Spine_01
            local v1 = t2.Spine_04 or t2.Spine_03
            local v2, v3

            if Spine_01 and v1 then
                v3 = v1
                v2 = Spine_01
            else
                v2 = t2.Head
                v3 = t2.Tail_03 or t2.Tail_0 or t2.Tail_01
            end

            if not v2 or not v3 then
                v2 = t2.body
                v3 = t2["tail.01"]
            end

            if not (v2 and v3) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local Unit = CFrame:VectorToObjectSpace(v2.WorldPosition - v3.WorldPosition).Unit
            local v4 = t2.Fin_L or t2["fin.L"]
            local v5 = t2.Fin_R or t2["fin.R"]
            local v6 = if not v4 or not v5 then Vector3.new(0, 1, 0) - Unit * Unit.Y else CFrame:VectorToObjectSpace(v5.WorldPosition - v4.WorldPosition).Unit:Cross(Unit)

            if v6.Magnitude < 0.001 then
                return nil
            end

            local Unit2 = v6.Unit
            local v7 = if attr(p3, "WaveVertical") then Unit2:Cross(Unit).Unit else Unit2
            local t3 = {}
            local n1 = 1e999
            local n2 = (-1e999)

            for _, v8 in pairs(t2) do
                local v9 = CFrame:PointToObjectSpace(v8.WorldPosition):Dot(Unit)

                n1 = math.min(n1, v9)
                n2 = math.max(n2, v9)
                t3[#t3 + 1] = {
                    bone = v8,
                    proj = v9
                }
            end

            local v11 = math.max(n2 - n1, 0.001)
            local v12 = (attr(p3, "WaveStiffness") or 2.6) * (0.85 + math.random() * 0.3)
            local t4 = {}

            for _, v13 in ipairs(t3) do
                local v14 = 1 - (v13.proj - n1) / v11
                local v15 = CFrame:ToObjectSpace(v13.bone.WorldCFrame)

                t4[#t4 + 1] = {
                    bone = v13.bone,
                    t = v14,
                    gain = 0.05 + 1.2 * v14 ^ v12,
                    axis = v15:VectorToObjectSpace(v7)
                }
            end

            return {
                model = p3,
                mesh = MeshPart,
                segs = t4,
                phase = math.random() * 3.141592653589793 * 2,
                up = Unit2,
                ampMul = (attr(p3, "WaveAmp") or 1) * (0.75 + math.random() * 0.5),
                beatMul = (attr(p3, "WaveBeat") or 1) * (0.72 + math.random() * 0.56)
            }
        end,
        update = function(p4, p5, _) -- update | line: 85
            -- upvalues: fightHooked (copy), attr (copy)
            local Magnitude = p4.mesh.AssemblyLinearVelocity.Magnitude
            local v16, StrokeHz

            if fightHooked(p4.model) then
                v16 = 0.55
                StrokeHz = 14
            else
                v16 = math.clamp((0.04 + 0.009 * Magnitude) * p4.ampMul, 0.05, 0.6)
                StrokeHz = attr(p4.model, "StrokeHz")

                if not StrokeHz then
                    StrokeHz = math.min((1.2 + Magnitude * 0.28) * p4.beatMul / (attr(p4.model, "Size") or 1), 16)
                end
            end

            p4.phase += p5 * StrokeHz

            for _, v19 in ipairs(p4.segs) do
                local v22 = v16 * v19.gain * math.sin(p4.phase - v19.t * 2.6)

                v19.bone.Transform = CFrame.fromAxisAngle(v19.axis, v22)
            end
        end
    }
end
