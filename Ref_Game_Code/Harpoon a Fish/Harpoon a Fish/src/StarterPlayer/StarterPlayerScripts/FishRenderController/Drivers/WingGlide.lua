-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.WingGlide = {
        SPREAD1 = 0.9,
        SPREAD2 = 0.35,
        FWD = 0.25,
        FLUTTER = 0.08,
        SCULL = 0.1,
        D_UP = 0.15,
        D_BACK = 0.45,
        SPREAD_EASE = 4,
        register = function(p3) -- register | line: 20
            -- upvalues: p1 (copy), attr (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit

            local function part(p4) -- line: 27
                -- upvalues: v1 (copy), CFrame (copy), nose (copy), Unit (copy), Unit2 (copy)
                local v2 = v1.mesh:FindFirstChild(p4, true)

                if not v2 then
                    return nil
                end

                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

                return {
                    bone = v2,
                    right = v3:VectorToObjectSpace(Unit2),
                    nose = v3:VectorToObjectSpace(nose),
                    up = v3:VectorToObjectSpace(Unit)
                }
            end

            local v4 = if attr(p3, "WingAxis") == "Up" then "up" else "nose"
            local t2 = {}

            v1.wings = {}
            v1.sail = t2

            for _, v5 in ipairs({
                    { "Wing_L", 1, 0 },
                    { "Wing_R", -1, 1.1 }
                }) do
                local v6 = part(v5[1] .. "1")
                local v7 = part(v5[1] .. "2")

                if not v6 or not v7 then
                    return nil
                end

                v1.wings[#v1.wings + 1] = {
                    a = v6,
                    b = v7,
                    axA = v6[v4],
                    axB = v7[v4],
                    side = v4 == "up" and -v5[2] or v5[2],
                    off = v5[3]
                }
            end

            local v9 = part("Dorsal_" .. 1)

            if not v9 then
                return nil
            end

            v9.k = 1
            v1.sail[1] = v9

            local v10 = part("Dorsal_" .. 2)

            if not v10 then
                return nil
            end

            v10.k = 2
            v1.sail[2] = v10

            local v11 = part("Dorsal_" .. 3)

            if not v11 then
                return nil
            end

            v11.k = 3
            v1.sail[3] = v11

            local v12 = math.random() * 6.28

            v1.s = 0
            v1.fin = v12

            return v1
        end,
        update = function(p5, p6, p7) -- update | line: 49
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local WingGlide = p1.WingGlide

            p1.SharkSwim.update(p5, p6, p7)

            local model = p5.model
            local v13 = fightHooked(model)
            local n1 = 1

            if attr(model, "StrokeAt") then
                n1 = if v13 then 1 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            local v16 = if v13 then 1 else math.clamp((0.8 - n1) / 0.4, 0, 1)

            p5.s = p5.s + (v16 - p5.s) * math.min(1, p6 * WingGlide.SPREAD_EASE)
            p5.fin += p6 * (v13 and 3 or 1)

            local s2, fin = p5.s, p5.fin
            local v20 = p5.phase or 0
            local v21 = 1 - s2

            if v13 then
                n1 = 0
            end

            local v22 = v21 * math.clamp(n1, 0, 1.5)

            for _, v23 in ipairs(p5.wings) do
                v23.a.bone.Transform = CFrame.fromAxisAngle(v23.a.right, WingGlide.FWD * s2 - 0.15 * v22 + WingGlide.SCULL * (1 - s2) * math.sin(v20)) * CFrame.fromAxisAngle(v23.axA, v23.side * WingGlide.SPREAD1 * s2)
                v23.b.bone.Transform = CFrame.fromAxisAngle(v23.axB, v23.side * (WingGlide.SPREAD2 * s2 + WingGlide.FLUTTER * s2 * math.sin(2 * fin + v23.off)))
            end

            for _, v27 in ipairs(p5.sail) do
                v27.bone.Transform = CFrame.fromAxisAngle(v27.right, -WingGlide.D_UP * s2 + WingGlide.D_BACK * v22 * (0.6 + 0.2 * v27.k))
            end
        end
    }
end
