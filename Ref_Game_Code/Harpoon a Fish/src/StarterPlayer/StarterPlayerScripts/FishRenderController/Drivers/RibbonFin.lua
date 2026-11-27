-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.RibbonFin = {
        RIB = 0.32,
        LAM = 0.9,
        HOVER_RIP = 0.4,
        DFOLD = 0.8,
        BODY_CRUISE = 0.15,
        PFOLD = 0.4,
        PFLUT = 0.12,
        BURST_EASE = 6,
        register = function(p3) -- register | line: 22
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit
            local t2 = {}

            v1.spines = {}
            v1.pecs = t2

            for i = 1, 7 do
                local v2 = v1.mesh:FindFirstChild("Dorsal_" .. i, true)

                if not v2 then
                    return nil
                end

                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

                v1.spines[#v1.spines + 1] = {
                    sign = 1,
                    bone = v2,
                    k = i,
                    right = v3:VectorToObjectSpace(Unit2),
                    nose = v3:VectorToObjectSpace(nose)
                }

                local v4 = v1.mesh:FindFirstChild("Anal_" .. i, true)

                if v4 then
                    local v5 = CFrame:ToObjectSpace(v4.WorldCFrame)

                    v1.spines[#v1.spines + 1] = {
                        sign = -1,
                        bone = v4,
                        k = i,
                        right = v5:VectorToObjectSpace(Unit2),
                        nose = v5:VectorToObjectSpace(nose)
                    }
                end
            end

            for _, v6 in ipairs({
                    { "Fin_L", 1, 0 },
                    { "Fin_R", -1, 1.3 }
                }) do
                local v7 = v1.mesh:FindFirstChild(v6[1], true)

                if v7 then
                    v1.pecs[#v1.pecs + 1] = {
                        bone = v7,
                        side = v6[2],
                        off = v6[3],
                        up = CFrame:ToObjectSpace(v7.WorldCFrame):VectorToObjectSpace(Unit)
                    }
                end
            end

            v1.ampBase = v1.ampMul
            v1.fin = math.random() * 6.28
            v1.burst = 0

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 51
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local RibbonFin = p1.RibbonFin
            local model = p4.model
            local v8 = fightHooked(model)
            local n1 = 1

            if v8 then
                n1 = 1.8
            elseif attr(model, "StrokeAt") then
                n1 = (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            p4.burst = p4.burst + (math.clamp((n1 - 1.1) / 0.5, 0, 1) - p4.burst) * math.min(1, p5 * RibbonFin.BURST_EASE)

            local burst2 = p4.burst
            local v14 = math.clamp(n1, 0, 1)

            p4.ampMul = p4.ampBase * (RibbonFin.BODY_CRUISE + (1 - RibbonFin.BODY_CRUISE) * burst2)
            p1.SharkSwim.update(p4, p5, p6)
            p4.fin += p5 * (v8 and 3 or 1)

            local v15 = p4.phase or 0
            local fin = p4.fin

            for _, v16 in ipairs(p4.spines) do
                local v21 = v14 * math.sin(v15 - RibbonFin.LAM * v16.k) + (1 - v14) * RibbonFin.HOVER_RIP * math.sin(2 * fin - RibbonFin.LAM * v16.k)

                v16.bone.Transform = CFrame.fromAxisAngle(v16.right, v16.sign * RibbonFin.DFOLD * burst2) * CFrame.fromAxisAngle(v16.nose, v16.sign * (1 - burst2) * RibbonFin.RIB * v21)
            end

            for _, v22 in ipairs(p4.pecs) do
                v22.bone.Transform = CFrame.fromAxisAngle(v22.up, v22.side * (RibbonFin.PFOLD * burst2 + (1 - burst2) * RibbonFin.PFLUT * math.sin(1.5 * fin + v22.off)))
            end
        end
    }
end
