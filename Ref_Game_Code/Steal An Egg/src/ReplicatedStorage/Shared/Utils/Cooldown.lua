-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1) -- line: 5
    assert(p1 >= 0 and p1 == p1, "cooldown duration must be a non-negative number")

    local v2 = true

    return function(p2) -- line: 9
        -- upvalues: p1 (copy), v2 (ref)
        if not v2 then
            return false
        end

        v2 = false
        task.delay(p1, function() -- line: 14
            -- upvalues: v2 (ref)
            v2 = true
        end)

        if p2 then
            p2()
        end

        return true
    end
end
