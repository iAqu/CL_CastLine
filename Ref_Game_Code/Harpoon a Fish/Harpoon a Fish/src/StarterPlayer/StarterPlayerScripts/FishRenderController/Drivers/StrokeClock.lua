-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.StrokeClock = {
        lock = function(p3, p4, p5) -- lock | line: 21
            -- upvalues: fightHooked (copy), attr (copy)
            local model = p3.model
            local StrokeAt = attr(model, "StrokeAt")

            if fightHooked(model) then
                p3.phase += p4 * p5.HOOK_RATE
                p3.locked = nil

                return p5.HOOK_EFFORT
            end

            if StrokeAt then
                local v1 = attr(model, "StrokeRate") or 0
                local v2 = (attr(model, "StrokePhase") or 0) + v1 * (workspace:GetServerTimeNow() - 0.1 - StrokeAt)

                if p3.locked then
                    p3.phase += p4 * v1
                    p3.phase = p3.phase + ((v2 - p3.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p4 * 10)
                else
                    p3.phase = v2
                    p3.locked = true
                end

                return v1 / math.max(attr(model, "StrokeCruise") or v1, 0.001)
            end

            p3.phase += p4 * (attr(model, "StrokeHz") or p5.PEN_RATE)
            p3.locked = nil

            return 1
        end,
        turn = function(p6, p7) -- turn | line: 44
            local CFrame = p6.mesh.CFrame
            local v6 = CFrame:VectorToWorldSpace(p6.nose)
            local v7 = Vector3.new(v6.X, 0, v6.Z)

            if p6.lastPos and p6.lastNose and p7 > 1E-04 and (CFrame.Position - p6.lastPos).Magnitude < 20 and v7.Magnitude > 0.001 then
                local lastNose = p6.lastNose
                local Unit = v7.Unit
                local v9 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p7
                local v10 = (CFrame.Position - p6.lastPos).Magnitude / p7

                p6.w = p6.w + (v9 - p6.w) * math.min(1, p7 / 0.15)
                p6.v = p6.v + (v10 - p6.v) * math.min(1, p7 / 0.3)
            end

            p6.lastPos = CFrame.Position

            if v7.Magnitude > 0.001 then
                p6.lastNose = v7.Unit
            end

            return (math.clamp(p6.length * p6.w / math.max(p6.v, 5), -0.9, 0.9))
        end,
        setup = function(p8, p9) -- setup | line: 59
            -- upvalues: attr (copy)
            local v17 = p8:FindFirstChildWhichIsA("MeshPart", true)

            if not v17 then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(v17:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            for _, v18 in ipairs(p9) do
                if not t2[v18] then
                    return nil
                end
            end

            local AnatomyInverse = attr(p8, "AnatomyInverse")

            if typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local v19 = p8:GetPivot() * AnatomyInverse:Inverse()
            local CFrame = v17.CFrame
            local v20 = CFrame:VectorToObjectSpace(v19.RightVector)
            local v21 = CFrame:VectorToObjectSpace(v19.UpVector)
            local Size = v17.Size

            return {
                w = 0,
                v = 0,
                model = p8,
                mesh = v17,
                bones = t2,
                mcf = CFrame,
                nose = v20,
                up = v21,
                right = v20:Cross(v21).Unit,
                phase = math.random() * 3.141592653589793 * 2,
                fin = math.random() * 6.28,
                length = math.abs(v20.X) * Size.X + math.abs(v20.Y) * Size.Y + math.abs(v20.Z) * Size.Z
            }
        end,
        axis = function(p10, p11, p12) -- axis | line: 83
            return p10.mcf:ToObjectSpace(p11.WorldCFrame):VectorToObjectSpace(p12)
        end
    }
end
