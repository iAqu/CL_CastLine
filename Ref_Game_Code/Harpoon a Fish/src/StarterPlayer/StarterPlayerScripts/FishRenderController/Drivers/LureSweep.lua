-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.LureSweep = {
        SWEEP_Y = 0.75,
        SWEEP_P = 0.12,
        SWEEP_RATE = 2.2,
        HOVER_EASE = 2,
        register = function(p3) -- register | line: 18
            -- upvalues: p1 (copy)
            local v1 = p1.AnglerSwim.register(p3)

            if not v1 then
                return nil
            end

            local v2 = math.random() * 7

            v1.hover = 0
            v1.sweepT = v2
            v1.sweepY = 0
            v1.sweepP = 0

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 24
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local LureSweep = p1.LureSweep
            local model = p4.model
            local v3 = fightHooked(model)
            local n1 = 1

            if attr(model, "StrokeAt") then
                n1 = if v3 then 1 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            local v6 = if v3 then 0 else 1 - math.clamp(n1, 0, 1)

            p4.hover = p4.hover + (v6 - p4.hover) * math.min(1, p5 * LureSweep.HOVER_EASE)
            p4.sweepT += p5
            p4.sweepY = LureSweep.SWEEP_Y * p4.hover * math.sin(LureSweep.SWEEP_RATE * p4.sweepT)
            p4.sweepP = LureSweep.SWEEP_P * p4.hover * math.sin(2 * LureSweep.SWEEP_RATE * p4.sweepT)
            p1.AnglerSwim.update(p4, p5, p6)
        end
    }
end
