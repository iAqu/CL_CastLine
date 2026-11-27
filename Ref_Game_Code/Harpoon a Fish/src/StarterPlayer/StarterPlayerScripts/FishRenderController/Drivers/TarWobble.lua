-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 11
    local fightHooked = p2.fightHooked

    p1.TarWobble = {
        ROLL = 0.1,
        RLAG = 0.6,
        BOB = 0.012,
        HOOK_G = 1.5,
        rolls = function(p3, p4, p5, p6) -- rolls | line: 17
            -- upvalues: p1 (copy)
            local TarWobble = p1.TarWobble
            local HOOK_G = p5 and TarWobble.HOOK_G or 1
            local n1 = 0

            for i = 1, p4 do
                local v3 = TarWobble.ROLL * HOOK_G * math.sin(p3 - (i - 1) * TarWobble.RLAG)

                p6[i] = v3 - n1
                n1 = v3
            end

            return TarWobble.BOB * HOOK_G * math.sin(2 * p3)
        end,
        register = function(p7) -- register | line: 28
            -- upvalues: p1 (copy)
            local v6 = p1.SharkSwim.register(p7)

            if v6 and v6.chain and v6.chain[1] then
                v6.tarUp = v6.mesh.CFrame:ToObjectSpace(v6.chain[1].seg.bone.WorldCFrame):VectorToObjectSpace(v6.up)
                v6.tarRel = {}

                return v6
            end

            return nil
        end,
        update = function(p8, p9, p10) -- update | line: 36
            -- upvalues: p1 (copy), fightHooked (copy)
            local TarWobble = p1.TarWobble

            p1.SharkSwim.update(p8, p9, p10)

            local chain = p8.chain
            local v7 = TarWobble.rolls(p8.phase or 0, #chain, fightHooked(p8.model), p8.tarRel)

            for v8, v9 in ipairs(chain) do
                local bone = v9.seg.bone
                local v10 = bone.Transform * CFrame.fromAxisAngle(v9.roll, p8.tarRel[v8])

                bone.Transform = if v8 == 1 then CFrame.new(p8.tarUp * (v7 * p8.length)) * v10 else v10
            end
        end
    }
end
