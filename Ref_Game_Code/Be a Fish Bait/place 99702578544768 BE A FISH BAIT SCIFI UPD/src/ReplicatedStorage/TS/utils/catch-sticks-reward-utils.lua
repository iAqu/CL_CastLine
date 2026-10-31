-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        maxScore = 3,
        tickets = 2
    },
    {
        maxScore = 7,
        tickets = 5
    },
    {
        maxScore = 10,
        tickets = 10
    }
}

return {
    getCatchSticksTicketReward = function(p1, p2) -- getCatchSticksTicketReward | line: 16
        -- upvalues: t1 (copy)
        local v1

        for v2, v3 in t1 do
            local _ = v2 - 1

            if p1 <= v3.maxScore == true then
                v1 = v3
                break
            end

            v1 = nil
        end

        if v1 ~= nil then
            v1 = v1.tickets
        end

        if v1 == nil then
            v1 = 0
        end

        if p2 == "insane" then
            return v1 * 2
        end

        return v1
    end
}
