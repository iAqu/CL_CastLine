-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 12
    local fightHooked = p2.fightHooked

    p1.MothClap = {
        FLAP = 0.3,
        TIP = 0.22,
        TIP_LAG = 0.8,
        SWEEP = 0.08,
        FLAP_U = 0.42,
        TIP_U = 0.27,
        STRIDE = 0.37,
        MIN_HZ = 0.8,
        MAX_HZ = 2.8,
        HOOK_HZ = 3,
        WINGS = {
            { "UL", 1, true },
            { "UR", -1, true },
            { "DL", 1, false },
            { "DR", -1, false }
        },
        rate = function(p3, p4, p5) -- rate | line: 21
            -- upvalues: p1 (copy)
            local MothClap = p1.MothClap

            if p5 then
                return MothClap.HOOK_HZ
            end

            return (math.clamp(p3 / (MothClap.STRIDE * math.max(p4, 0.001)), MothClap.MIN_HZ, MothClap.MAX_HZ))
        end,
        pose = function(p6, p7) -- pose | line: 27
            -- upvalues: p1 (copy)
            local MothClap = p1.MothClap
            local v2 = 6.283185307179586 * p7
            local s = p6.s

            if p6.upper then
                return CFrame.fromAxisAngle(p6.nose1, s * MothClap.FLAP_U * math.sin(v2)), CFrame.fromAxisAngle(p6.nose2, s * MothClap.TIP_U * math.sin(v2 - MothClap.TIP_LAG))
            end

            return CFrame.fromAxisAngle(p6.up1, s * MothClap.SWEEP * math.cos(v2)) * CFrame.fromAxisAngle(p6.nose1, -s * MothClap.FLAP * math.sin(v2)), CFrame.fromAxisAngle(p6.nose2, -s * MothClap.TIP * math.sin(v2 - MothClap.TIP_LAG))
        end,
        register = function(p8) -- register | line: 37
            -- upvalues: p1 (copy)
            local MothClap = p1.MothClap
            local v9 = p1.SharkSwim.register(p8)

            if not v9 then
                return nil
            end

            local CFrame = v9.mesh.CFrame
            local nose, up = v9.nose, v9.up
            local t2 = {}

            for _, v10 in ipairs(MothClap.WINGS) do
                local v11 = v9.mesh:FindFirstChild("Wing" .. v10[1] .. "_1", true)
                local v12 = v9.mesh:FindFirstChild("Wing" .. v10[1] .. "_2", true)

                if not v11 or not v12 then
                    return nil
                end

                local v13 = CFrame:ToObjectSpace(v11.WorldCFrame)
                local v14 = CFrame:ToObjectSpace(v12.WorldCFrame)

                t2[#t2 + 1] = {
                    b1 = v11,
                    b2 = v12,
                    s = v10[2],
                    upper = v10[3],
                    nose1 = v13:VectorToObjectSpace(nose),
                    up1 = v13:VectorToObjectSpace(up),
                    nose2 = v14:VectorToObjectSpace(nose)
                }
            end

            local v15 = math.random()

            v9.wings = t2
            v9.wingF = v15

            return v9
        end,
        update = function(p9, p10, p11) -- update | line: 55
            -- upvalues: p1 (copy), fightHooked (copy)
            local MothClap = p1.MothClap

            p1.SharkSwim.update(p9, p10, p11)
            p9.wingF += p10 * MothClap.rate(p9.v or 0, p9.length, fightHooked(p9.model))

            for _, v16 in ipairs(p9.wings) do
                local v17, v18 = MothClap.pose(v16, p9.wingF)

                v16.b1.Transform = v17
                v16.b2.Transform = v18
            end
        end
    }
end
