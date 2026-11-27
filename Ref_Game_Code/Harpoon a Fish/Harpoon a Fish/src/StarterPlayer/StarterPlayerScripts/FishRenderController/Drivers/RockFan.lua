-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.RockFan = {
        HOVER_OPEN = 0.55,
        HOVER_RATE = 2.6,
        CRUISE_OPEN = 0.18,
        register = function(p3) -- register | line: 18
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit

            v1.fans = {}

            for _, v2 in ipairs({
                    { "Fin_L", 1 },
                    { "Fin_R", -1 }
                }) do
                local v3 = v1.mesh:FindFirstChild(v2[1], true)

                if not v3 then
                    return nil
                end

                v1.fans[#v1.fans + 1] = {
                    bone = v3,
                    side = v2[2],
                    up = CFrame:ToObjectSpace(v3.WorldCFrame):VectorToObjectSpace(Unit)
                }
            end

            v1.fin = math.random() * 6.28

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 33
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local RockFan = p1.RockFan

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v4 = fightHooked(model)
            local v5 = if attr(model, "School") then 1 else 0.6

            if v4 then
                v5 = 0
            elseif attr(model, "StrokeAt") then
                v5 = (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            p4.fin += p5 * (v4 and 3 or 1)

            local v8 = 1 - math.clamp(v5, 0, 1)
            local v10 = math.clamp(v5 - 1, 0, 0.5) / 0.5
            local v16 = v8 * RockFan.HOVER_OPEN * (math.sin(RockFan.HOVER_RATE * p4.fin) * 0.5 + 0.5) + (1 - v8) * (1 - v10) * RockFan.CRUISE_OPEN * (math.sin(p4.phase or 0) * 0.5 + 0.5)

            for _, v17 in ipairs(p4.fans) do
                v17.bone.Transform = CFrame.fromAxisAngle(v17.up, -v17.side * v16)
            end
        end
    }
end
