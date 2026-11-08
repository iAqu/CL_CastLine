-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    FirstArrivalAt = function(p1, p2, p3) -- FirstArrivalAt | line: 4
        assert(p1 > 0 and p1 < 1e999, "Invalid train unlock time")
        assert(p2 > 0 and p2 < 1e999, "Invalid train interval")
        assert(p3 == p3 and math.abs(p3) < 1e999, "Invalid train offset")

        local v4 = p3 % p2

        return (math.floor((p1 + v4) / p2) + 2) * p2 - v4
    end
}

return table.freeze(t1)
