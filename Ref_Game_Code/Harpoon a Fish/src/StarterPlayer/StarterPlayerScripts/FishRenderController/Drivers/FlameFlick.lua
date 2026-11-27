-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.FlameFlick = {
        STREAM = 0.35,
        FLICK = 0.09,
        TIP = 1.8,
        LICK = 0.1,
        LICK_RATE = 2.1,
        SIDE = 0.7,
        PELVIC = 0.18,
        FLAMES = {
            { "FlameA", 1, 0 },
            { "FlameB", 1, 1.7 },
            { "FlameC", -1, 3.1 },
            { "FlameD", -1, 4.6 }
        },
        flick = function(p3, p4) -- flick | line: 20
            return math.sin(9 * p3 + p4) * 0.5 + math.sin(14.7 * p3 + 2.3 * p4) * 0.3 + math.sin(23.3 * p3 + 3.7 * p4) * 0.2
        end,
        register = function(p5) -- register | line: 23
            -- upvalues: p1 (copy)
            local FlameFlick = p1.FlameFlick
            local v6 = p1.SharkSwim.register(p5)

            if not v6 then
                return nil
            end

            local CFrame = v6.mesh.CFrame
            local nose = v6.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            local function axes(p6) -- line: 31
                -- upvalues: CFrame (copy), nose (copy), Unit (copy)
                local v7 = CFrame:ToObjectSpace(p6.WorldCFrame)

                return v7:VectorToObjectSpace(Unit), v7:VectorToObjectSpace(nose)
            end

            local t2 = {}

            v6.flames = {}
            v6.pelvic = t2

            for _, v8 in ipairs(FlameFlick.FLAMES) do
                for i = 1, 2 do
                    local v9 = v6.mesh:FindFirstChild(v8[1] .. "_" .. i, true)

                    if not v9 then
                        return nil
                    end

                    local v10 = CFrame:ToObjectSpace(v9.WorldCFrame)
                    local v11 = v10:VectorToObjectSpace(Unit)
                    local v12 = v10:VectorToObjectSpace(nose)

                    v6.flames[#v6.flames + 1] = {
                        bone = v9,
                        right = v11,
                        nose = v12,
                        sign = v8[2],
                        ph = v8[3],
                        k = i
                    }
                end
            end

            for _, v13 in ipairs({ "Pelvic_L", "Pelvic_R" }) do
                local v14 = v6.mesh:FindFirstChild(v13, true)

                if not v14 then
                    return nil
                end

                local v15 = CFrame:ToObjectSpace(v14.WorldCFrame)
                local v16 = v15:VectorToObjectSpace(Unit)

                v15:VectorToObjectSpace(nose)
                v6.pelvic[#v6.pelvic + 1] = {
                    bone = v14,
                    right = v16,
                    off = v13 == "Pelvic_R" and 3.141592653589793 or 0
                }
            end

            local v18 = math.random() * 6.28

            v6.sp = 0.4
            v6.fire = v18

            return v6
        end,
        update = function(p7, p8, p9) -- update | line: 53
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local FlameFlick = p1.FlameFlick

            p1.SharkSwim.update(p7, p8, p9)

            local model = p7.model
            local v19 = fightHooked(model)
            local v20 = attr(model, "StrokeAt") and not v19
            local v21 = attr(model, "StrokeStride") or 0
            local v22 = (attr(model, "StrokeCruise") or 4) * math.max(v21, 0.1)
            local v23 = if v20 then math.clamp((p7.v or 0) / math.max(v22, 1), 0, 1.3) else nil

            if not v20 or not v23 then
                v23 = if v19 then 0 else 0.4
            end

            p7.sp = p7.sp + (v23 - p7.sp) * math.min(1, p8 * 3)
            p7.fire += p8 * (1 + 0.5 * p7.sp) * (v19 and 2 or 1)

            local fire = p7.fire
            local v27 = if v19 then 2.2 else math.min(math.max(p7.sp, 0), 1.3) * 0.6 + 1

            for _, v29 in ipairs(p7.flames) do
                local v30 = if v29.k == 1 then 1 else FlameFlick.TIP
                local v31 = v29.sign * FlameFlick.STREAM * p7.sp * (if v29.k == 1 then 1 else 0.6)
                local v33 = FlameFlick.LICK * math.sin(FlameFlick.LICK_RATE * fire + v29.ph)
                local v34 = FlameFlick.FLICK * v30 * v27 * FlameFlick.flick(fire - 0.12 * v29.k, v29.ph)
                local v35 = FlameFlick.FLICK * v30 * v27 * FlameFlick.SIDE * FlameFlick.flick(fire * 0.93 - 0.12 * v29.k, v29.ph + 1.3)

                v29.bone.Transform = CFrame.fromAxisAngle(v29.right, v31 + v29.sign * (v33 * v30 + v34)) * CFrame.fromAxisAngle(v29.nose, v35)
            end

            for _, v36 in ipairs(p7.pelvic) do
                v36.bone.Transform = CFrame.fromAxisAngle(v36.right, -FlameFlick.PELVIC * math.sin(3 * fire + v36.off) - 0.3 * p7.sp)
            end
        end
    }
end
