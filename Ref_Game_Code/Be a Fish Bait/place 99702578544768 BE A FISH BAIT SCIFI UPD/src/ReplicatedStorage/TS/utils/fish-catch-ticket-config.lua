-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        chance = 60,
        tickets = 1
    },
    {
        chance = 30,
        tickets = 2
    },
    {
        chance = 10,
        tickets = 3
    }
}

return {
    rollFishCatchTicketAmount = function() -- rollFishCatchTicketAmount | line: 14
        -- upvalues: t1 (copy)
        local n1 = 0

        for _, v1 in t1 do
            n1 += v1.chance
        end

        local v2 = math.random() * n1

        for _, v3 in t1 do
            v2 -= v3.chance

            if v2 <= 0 then
                return v3.tickets
            end
        end

        return t1[#t1].tickets
    end,
    fishCatchTicketOutcomes = t1
}
