-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ZapSwim = {
        BRISTLE = -0.35,
        CRUISE = 0.2,
        REST = 0.45,
        JOLT_E = 1.2,
        REST_E = 0.5,
        FOLD_EASE = 9,
        SHIVER = 0.06,
        SHIVER_HZ = 55,
        SHIVER_DECAY = 3.5,
        register = function(p3) -- register | line: 21
            -- upvalues: p1 (copy)
            return p1.SpikeSwim.register(p3)
        end,
        update = function(p4, p5, p6) -- update | line: 24
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local ZapSwim, SpikeSwim = p1.ZapSwim, p1.SpikeSwim

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v1 = fightHooked(model)
            local v2 = if v1 then 2 elseif attr(model, "StrokeAt") then (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001) else SpikeSwim.PEN_EFFORT
            local v5 = ZapSwim.JOLT_E < v2

            if v5 and not p4.wasJolt then
                p4.zap = 1
            end

            p4.wasJolt = v5

            if v1 then
                p4.zap = 0.8
            else
                p4.zap = (p4.zap or 0) * math.exp(-ZapSwim.SHIVER_DECAY * p5)
            end

            local v8 = if v5 then ZapSwim.BRISTLE elseif v2 <= ZapSwim.REST_E then ZapSwim.REST else ZapSwim.CRUISE

            p4.fold = p4.fold + (v8 - p4.fold) * math.min(1, p5 * ZapSwim.FOLD_EASE)
            p4.fin += p5 * SpikeSwim.FIN_RATE * (v1 and 3 or 1)

            local v12 = math.max(0, 1 - math.max(p4.fold, 0)) * (if v1 then 2.5 else 1)

            for _, v13 in ipairs(p4.fans) do
                local v14 = v13.sign == 1 and SpikeSwim.DFOLD * p4.fold or -SpikeSwim.VFOLD * p4.fold
                local v15 = if v13.sign == 1 then 0 else 1.5

                v13.bone.Transform = CFrame.fromAxisAngle(v13.right, v14) * CFrame.fromAxisAngle(v13.nose, SpikeSwim.FLARE_RIPPLE * v12 * math.sin(p4.fin - 0.8 * v13.k + v15))
            end

            if not (p4.zap > 0.01) then
                return
            end

            local v21 = ZapSwim.SHIVER * p4.zap * math.sin(p6 * ZapSwim.SHIVER_HZ)

            for _, v22 in ipairs(p4.segs) do
                if p4.body[v22] then
                    v22.bone.Transform = v22.bone.Transform * CFrame.fromAxisAngle(v22.axis, v21 * (v22.t + 0.3))
                end
            end
        end
    }
end
