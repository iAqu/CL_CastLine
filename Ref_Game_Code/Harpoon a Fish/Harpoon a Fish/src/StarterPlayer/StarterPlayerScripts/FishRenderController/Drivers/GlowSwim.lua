-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.GlowSwim = {
        STREAM = 0.8,
        RIPPLE = 0.12,
        RIPPLE_RATE = 2,
        RIPPLE_LAG = 1,
        D_FOLD = 0.25,
        D_SWAY = 0.1,
        D_LAG = 0.8,
        register = function(p3) -- register | line: 19
            -- upvalues: p1 (copy)
            return p1.SpikeSwim.register(p3)
        end,
        update = function(p4, p5, p6) -- update | line: 22
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local GlowSwim, SpikeSwim = p1.GlowSwim, p1.SpikeSwim

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v1 = fightHooked(model)
            local v2 = (attr(model, "StrokeCruise") or 4) * (attr(model, "StrokeStride") or 1)
            local v3 = attr(model, "StrokeAt") and math.clamp((p4.v or 0) / math.max(v2, 1), 0, 1.3) or 0.4

            if v1 then
                v3 = -0.25
            end

            p4.fold = p4.fold + (v3 - p4.fold) * math.min(1, p5 * 3)
            p4.fin += p5 * GlowSwim.RIPPLE_RATE * (v1 and 3 or 1)

            local v7 = GlowSwim.RIPPLE * (if v1 then 2.5 else 1)

            for _, v8 in ipairs(p4.fans) do
                if v8.sign == 1 then
                    v8.bone.Transform = CFrame.fromAxisAngle(v8.right, SpikeSwim.DFOLD * GlowSwim.D_FOLD * p4.fold) * CFrame.fromAxisAngle(v8.nose, GlowSwim.D_SWAY * math.sin(p4.fin * 0.7 - GlowSwim.D_LAG * v8.k))
                else
                    v8.bone.Transform = CFrame.fromAxisAngle(v8.right, -SpikeSwim.VFOLD * GlowSwim.STREAM * p4.fold + v7 * math.sin(p4.fin - GlowSwim.RIPPLE_LAG * v8.k)) * CFrame.fromAxisAngle(v8.nose, 0.5 * v7 * math.sin(p4.fin * 0.8 - GlowSwim.RIPPLE_LAG * v8.k + 1))
                end
            end
        end
    }
end
