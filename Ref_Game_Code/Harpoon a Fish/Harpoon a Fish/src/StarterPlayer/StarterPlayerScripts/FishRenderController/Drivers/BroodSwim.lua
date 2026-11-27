-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 12
    local fightHooked = p2.fightHooked

    p1.BroodSwim = {
        FRY_STRIDE = 0.7,
        FRY_MIN = 1.5,
        FRY_MAX = 5,
        FRY_A1 = 0.15,
        FRY_A2 = 0.45,
        FRY_LAG = 1,
        DRIFT = 0.015,
        BOB = 0.01,
        SLOW_HZ = 0.35,
        OFFSET = 2.1,
        DRIFT_OFF = 1.7,
        BOB_OFF = 2.3,
        SPAN = 0.3,
        MAX_FRY = 3,
        rate = function(p3, p4, p5) -- rate | line: 21
            -- upvalues: p1 (copy)
            local BroodSwim = p1.BroodSwim

            if p5 then
                return BroodSwim.FRY_MAX
            end

            return (math.clamp(p3 / (BroodSwim.FRY_STRIDE * math.max(p4, 0.001)), BroodSwim.FRY_MIN, BroodSwim.FRY_MAX))
        end,
        pose = function(p6, p7, p8) -- pose | line: 27
            -- upvalues: p1 (copy)
            local BroodSwim = p1.BroodSwim
            local v2 = 6.283185307179586 * p7 + p6 * BroodSwim.OFFSET

            return BroodSwim.FRY_A1 * math.sin(v2), BroodSwim.FRY_A2 * math.sin(v2 - BroodSwim.FRY_LAG), BroodSwim.DRIFT * math.sin(6.283185307179586 * p8 + p6 * BroodSwim.DRIFT_OFF), BroodSwim.BOB * math.sin(6.283185307179586 * p8 * 1.3 + p6 * BroodSwim.BOB_OFF)
        end,
        register = function(p9) -- register | line: 33
            -- upvalues: p1 (copy)
            local BroodSwim = p1.BroodSwim
            local v9 = p1.SharkSwim.register(p9)

            if not v9 then
                return nil
            end

            local CFrame = v9.mesh.CFrame
            local nose, up = v9.nose, v9.up
            local t2 = {}

            for i = 1, BroodSwim.MAX_FRY do
                local v10 = v9.mesh:FindFirstChild("Fry" .. i .. "_1", true)
                local v11 = v9.mesh:FindFirstChild("Fry" .. i .. "_2", true)

                if v10 and v11 then
                    local v12 = CFrame:ToObjectSpace(v10.WorldCFrame)
                    local v13 = CFrame:ToObjectSpace(v11.WorldCFrame)

                    t2[#t2 + 1] = {
                        f = 0,
                        n = i,
                        b1 = v10,
                        b2 = v11,
                        up1 = v12:VectorToObjectSpace(up),
                        up2 = v13:VectorToObjectSpace(up),
                        nose1 = v12:VectorToObjectSpace(nose),
                        studs = (v13.Position - v12.Position).Magnitude / BroodSwim.SPAN
                    }
                end
            end

            if #t2 == 0 then
                return nil
            end

            v9.fry = t2
            v9.frySlow = 0

            return v9
        end,
        update = function(p10, p11, p12) -- update | line: 53
            -- upvalues: p1 (copy), fightHooked (copy)
            local BroodSwim = p1.BroodSwim

            p1.SharkSwim.update(p10, p11, p12)

            local v14 = fightHooked(p10.model)

            p10.frySlow += p11 * BroodSwim.SLOW_HZ

            local length = p10.length

            for _, v15 in ipairs(p10.fry) do
                v15.f += p11 * BroodSwim.rate(p10.v, v15.studs, v14)

                local v16, v17, v18, v19 = BroodSwim.pose(v15.n, v15.f, p10.frySlow)

                v15.b1.Transform = CFrame.new((v15.nose1 * v18 + v15.up1 * v19) * length) * CFrame.fromAxisAngle(v15.up1, v16)
                v15.b2.Transform = CFrame.fromAxisAngle(v15.up2, v17)
            end
        end
    }
end
