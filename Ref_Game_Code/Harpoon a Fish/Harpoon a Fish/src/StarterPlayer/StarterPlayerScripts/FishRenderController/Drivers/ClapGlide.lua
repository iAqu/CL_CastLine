-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ClapGlide = {
        FLAP = 0.55,
        SWEEP = 0.18,
        SWEEP_LAG = 0.6,
        TIP = 0.3,
        TIP_LAG = 0.8,
        GLIDE_BACK = 0.2,
        GLIDE_DOWN = 0.15,
        RIPPLE = 0.04,
        ACT_EASE = 5,
        PEN_EFFORT = 1,
        PASS_E = { 1.05, 1.45 },
        register = function(p3) -- register | line: 23
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit

            local function part(p4) -- line: 29
                -- upvalues: v1 (copy), CFrame (copy), nose (copy), Unit (copy)
                local v2 = v1.mesh:FindFirstChild(p4, true)

                if not v2 then
                    return nil
                end

                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

                return {
                    bone = v2,
                    up = v3:VectorToObjectSpace(Unit),
                    nose = v3:VectorToObjectSpace(nose)
                }
            end

            v1.wings = {}

            for _, v4 in ipairs({
                    { "Wing_L", 1 },
                    { "Wing_R", -1 }
                }) do
                local v5 = part(v4[1] .. "1")
                local v6 = part(v4[1] .. "2")

                if not v5 or not v6 then
                    return nil
                end

                v1.wings[#v1.wings + 1] = {
                    a = v5,
                    b = v6,
                    side = v4[2]
                }
            end

            local v7 = math.random() * 6.28

            v1.act = 0
            v1.fin = v7

            return v1
        end,
        update = function(p5, p6, p7) -- update | line: 44
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local ClapGlide = p1.ClapGlide

            p1.SharkSwim.update(p5, p6, p7)

            local model = p5.model
            local v8 = fightHooked(model)
            local PEN_EFFORT = ClapGlide.PEN_EFFORT

            if v8 then
                PEN_EFFORT = 2
            elseif attr(model, "StrokeAt") then
                PEN_EFFORT = (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            local v12 = math.clamp((PEN_EFFORT - 0.3) / 0.5, 0, 1)
            local PassCruise = attr(model, "PassCruise")

            if PassCruise and not (v8 or attr(model, "StrokeAt")) then
                v12 = math.clamp(((p5.v or 0) / math.max(PassCruise, 0.001) - ClapGlide.PASS_E[1]) / (ClapGlide.PASS_E[2] - ClapGlide.PASS_E[1]), 0, 1)
            end

            p5.act = p5.act + (v12 - p5.act) * math.min(1, p6 * ClapGlide.ACT_EASE)
            p5.fin += p6

            local act2 = p5.act
            local v16 = p5.phase or 0
            local fin = p5.fin

            for _, v17 in ipairs(p5.wings) do
                local v18 = act2 * ClapGlide.FLAP * math.sin(v16) - (1 - act2) * ClapGlide.GLIDE_DOWN
                local v21 = -act2 * ClapGlide.SWEEP * math.sin(v16 - ClapGlide.SWEEP_LAG) + (1 - act2) * ClapGlide.GLIDE_BACK

                v17.a.bone.Transform = CFrame.fromAxisAngle(v17.a.up, v17.side * v21) * CFrame.fromAxisAngle(v17.a.nose, v17.side * v18)
                v17.b.bone.Transform = CFrame.fromAxisAngle(v17.b.nose, v17.side * (act2 * ClapGlide.TIP * math.sin(v16 - ClapGlide.TIP_LAG) + (1 - act2) * ClapGlide.RIPPLE * math.sin(fin)))
            end
        end
    }
end
