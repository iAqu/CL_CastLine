-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.HoverSway = {
        IDLE_AMP = 0.1,
        IDLE_RATE = 1.2,
        HOVER_EASE = 2,
        register = function(p3) -- register | line: 18
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local v2 = math.random() * 6.28

            v1.hover = 0
            v1.idle = v2

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 24
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local HoverSway = p1.HoverSway

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local n1 = 1

            if attr(model, "StrokeAt") then
                n1 = if fightHooked(model) then 1 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            p4.hover = p4.hover + (1 - math.clamp(n1, 0, 1) - p4.hover) * math.min(1, p5 * HoverSway.HOVER_EASE)
            p4.idle += p5 * HoverSway.IDLE_RATE

            if not (p4.hover < 0.01) then
                for _, v7 in ipairs(p4.segs) do
                    v7.bone.Transform = v7.bone.Transform * CFrame.fromAxisAngle(v7.axis, p4.hover * HoverSway.IDLE_AMP * v7.gain * math.sin(p4.idle - v7.t * 2.6))
                end
            end
        end
    }
end
