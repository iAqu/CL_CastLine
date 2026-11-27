-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.SpikeSwim = {
        DFOLD = 1.1,
        VFOLD = 0.9,
        FLARE_RIPPLE = 0.06,
        FOLD_EASE = 5,
        FIN_RATE = 2,
        TURN_REF = 0.8,
        PEN_EFFORT = 0.6,
        register = function(p3) -- register | line: 20
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            v1.fans = {}

            for _, v2 in ipairs({ "Dorsal_1", "Dorsal_2", "Dorsal_3", "Dorsal_4", "Ventral_1", "Ventral_2", "Ventral_3" }) do
                local v3 = v1.mesh:FindFirstChild(v2, true)

                if not v3 then
                    return nil
                end

                local v4 = CFrame:ToObjectSpace(v3.WorldCFrame)

                v1.fans[#v1.fans + 1] = {
                    bone = v3,
                    right = v4:VectorToObjectSpace(Unit),
                    nose = v4:VectorToObjectSpace(nose),
                    sign = v2:sub(1, 1) == "D" and 1 or -1,
                    k = tonumber(v2:sub(-1)) - 1
                }
            end

            local v6 = math.random() * 6.28

            v1.fold = 0.16
            v1.fin = v6

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 40
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local SpikeSwim = p1.SpikeSwim

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v7 = fightHooked(model)
            local v8 = if v7 then 0
                elseif attr(model, "StrokeAt") then (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
                elseif attr(model, "School") then 1
                else SpikeSwim.PEN_EFFORT
            local v11 = if v8 <= 0.3 then -0.15 elseif v8 <= 1 then -0.15 + 0.45 * (v8 - 0.3) / 0.7 else math.min(1, (v8 - 1) / 0.5) * 0.7 + 0.3
            local v16 = math.max(-0.15, v11 - math.min(1, math.abs(p4.w or 0) / SpikeSwim.TURN_REF) * 0.4)

            p4.fold = p4.fold + (v16 - p4.fold) * math.min(1, p5 * SpikeSwim.FOLD_EASE)
            p4.fin += p5 * SpikeSwim.FIN_RATE * (v7 and 3 or 1)

            local v20 = math.max(0, 1 - math.max(p4.fold, 0)) * (if v7 then 2.5 else 1)

            for _, v21 in ipairs(p4.fans) do
                local v22 = v21.sign == 1 and SpikeSwim.DFOLD * p4.fold or -SpikeSwim.VFOLD * p4.fold
                local v23 = if v21.sign == 1 then 0 else 1.5

                v21.bone.Transform = CFrame.fromAxisAngle(v21.right, v22) * CFrame.fromAxisAngle(v21.nose, SpikeSwim.FLARE_RIPPLE * v20 * math.sin(p4.fin - 0.8 * v21.k + v23))
            end
        end
    }
end
