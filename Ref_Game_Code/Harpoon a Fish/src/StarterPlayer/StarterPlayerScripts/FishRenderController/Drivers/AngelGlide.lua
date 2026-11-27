-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.AngelGlide = {
        SWEEP = 0.3,
        FLEX = 1.2,
        FLEX_LAG = 0.9,
        TIP = 0.8,
        FLEX_MAX = 0.35,
        SAIL_T = 0.45,
        LEAN = 0.18,
        LEAN_REF = 1.5,
        IDLE = 0.06,
        IDLE_RATE = 1.6,
        STREAM = 0.5,
        RIP = 0.14,
        register = function(p3) -- register | line: 22
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit
            local t2 = {}

            v1.sails = {}
            v1.streamers = t2

            for _, v2 in ipairs({ "Dorsal_1", "Dorsal_2", "Anal_1", "Anal_2", "Pelvic_L", "Pelvic_R" }) do
                local v3 = v1.mesh:FindFirstChild(v2, true)

                if not v3 then
                    return nil
                end

                local v4 = CFrame:ToObjectSpace(v3.WorldCFrame)
                local t3 = {
                    bone = v3,
                    right = v4:VectorToObjectSpace(Unit),
                    nose = v4:VectorToObjectSpace(nose)
                }

                if v2:sub(1, 1) == "P" then
                    t3.off = v2 == "Pelvic_R" and 3.141592653589793 or 0
                    v1.streamers[#v1.streamers + 1] = t3
                else
                    t3.sign = v2:sub(1, 1) == "D" and 1 or -1
                    t3.k = tonumber(v2:sub(-1))
                    v1.sails[#v1.sails + 1] = t3
                end
            end

            local v5 = math.random() * 6.28

            v1.sp = 0.4
            v1.lean = 0
            v1.fin = v5

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 47
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local AngelGlide = p1.AngelGlide

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v6 = fightHooked(model)
            local StrokeAt = attr(model, "StrokeAt")
            local v7 = attr(model, "StrokeRate") or 0
            local v8 = attr(model, "StrokeStride") or 0
            local v9 = StrokeAt and not v6
            local v10 = v9 and math.clamp((0.04 + 0.009 * v7 * v8) * p4.ampMul, 0.05, 0.6) or 0.12
            local phase = if v9 then p4.phase or p4.fin * 2 else p4.fin * 2
            local v12 = (attr(model, "StrokeCruise") or 4) * math.max(v8, 0.1)
            local v13 = v9 and math.clamp((p4.v or 0) / math.max(v12, 1), 0, 1.3) or 0.4

            if v6 then
                v13 = -0.2
            end

            p4.sp = p4.sp + (v13 - p4.sp) * math.min(1, p5 * 3)
            p4.lean = p4.lean + ((v9 and math.clamp((p4.w or 0) / AngelGlide.LEAN_REF, -1, 1) or 0) - p4.lean) * math.min(1, p5 * 4)
            p4.fin += p5 * AngelGlide.IDLE_RATE * (v6 and 3 or 1)

            local v21 = AngelGlide.IDLE * (if v6 then 3 else 1)

            for _, v22 in ipairs(p4.sails) do
                local v23 = if v22.k == 1 then 1 else AngelGlide.TIP
                local v30 = v23 * (math.clamp(AngelGlide.FLEX * v10 * math.sin(phase - 2.6 * AngelGlide.SAIL_T - AngelGlide.FLEX_LAG * v22.k), -AngelGlide.FLEX_MAX, AngelGlide.FLEX_MAX) + v21 * math.sin(p4.fin - 0.7 * v22.k + (if v22.sign == 1 then 0 else 2)))
                local v31 = v22.sign * AngelGlide.SWEEP * p4.sp * (if v22.k == 1 then 1 else 0.5)

                v22.bone.Transform = CFrame.fromAxisAngle(v22.right, v31) * CFrame.fromAxisAngle(v22.nose, v30 + v22.sign * v23 * AngelGlide.LEAN * p4.lean)
            end

            for _, v32 in ipairs(p4.streamers) do
                v32.bone.Transform = CFrame.fromAxisAngle(v32.right, -AngelGlide.STREAM * p4.sp + AngelGlide.RIP * math.sin(p4.fin * 1.3 + v32.off * 0.3)) * CFrame.fromAxisAngle(v32.nose, 0.5 * AngelGlide.RIP * math.sin(p4.fin * 0.9 + v32.off))
            end
        end
    }
end
