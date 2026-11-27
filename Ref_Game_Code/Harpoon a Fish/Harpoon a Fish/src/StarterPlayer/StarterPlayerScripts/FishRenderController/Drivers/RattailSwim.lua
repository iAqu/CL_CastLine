-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.RattailSwim = {
        WAVE_K = 5,
        ATT_MAX = 0.45,
        ATT_E = 1.4,
        ATT_EASE = 1.5,
        register = function(p3) -- register | line: 16
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local v2 = v1.mesh:FindFirstChild("Spine_01", true)
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            v1.root = {
                bone = v2,
                right = v1.mesh.CFrame:ToObjectSpace(v2.WorldCFrame):VectorToObjectSpace(Unit)
            }
            v1.waveK = p1.RattailSwim.WAVE_K
            v1.att = 0

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 27
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local RattailSwim = p1.RattailSwim

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v3 = fightHooked(model)
            local n1 = 1

            if attr(model, "StrokeAt") then
                n1 = if v3 then 1 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            local v6 = if v3 then 0 else RattailSwim.ATT_MAX * math.clamp((RattailSwim.ATT_E - n1) / RattailSwim.ATT_E, 0, 1)

            p4.att = p4.att + (v6 - p4.att) * math.min(1, p5 * RattailSwim.ATT_EASE)
            p4.root.bone.Transform = CFrame.fromAxisAngle(p4.root.right, -p4.att) * p4.root.bone.Transform
        end
    }
end
