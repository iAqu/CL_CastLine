-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.JawStrike = {
        GAPE = 0.45,
        BREATH = 0.07,
        BREATH_RATE = 1.2,
        OPEN_T = 0.35,
        OPEN_EASE = 10,
        SNAP_EASE = 25,
        STRIKE_E = 1.3,
        register = function(p3) -- register | line: 17
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local v2 = v1.mesh:FindFirstChild("Jaw", true)

            if not v2 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            v1.jaw = {
                bone = v2,
                right = CFrame:ToObjectSpace(v2.WorldCFrame):VectorToObjectSpace(Unit)
            }

            local v3 = math.random() * 6.28

            v1.gape = 0
            v1.fin = v3
            v1.strikeT = 99
            v1.lastE = 0

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 30
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local JawStrike = p1.JawStrike

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v4 = fightHooked(model)

            p4.fin += p5

            local n1 = 0.6

            if attr(model, "StrokeAt") then
                n1 = if v4 then 0.6 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            if JawStrike.STRIKE_E < n1 and p4.lastE <= JawStrike.STRIKE_E then
                p4.strikeT = 0
            end

            p4.lastE = n1
            p4.strikeT += p5

            local v7 = if v4 then JawStrike.GAPE * (math.sin(p6 * 9) * 0.5 + 0.5) elseif p4.strikeT < JawStrike.OPEN_T then JawStrike.GAPE else JawStrike.BREATH * (math.sin(JawStrike.BREATH_RATE * p4.fin) * 0.5 + 0.5)
            local OPEN_EASE = p4.gape < v7 and JawStrike.OPEN_EASE or JawStrike.SNAP_EASE

            p4.gape = p4.gape + (v7 - p4.gape) * math.min(1, p5 * OPEN_EASE)
            p4.jaw.bone.Transform = CFrame.fromAxisAngle(p4.jaw.right, -p4.gape)
        end
    }
end
