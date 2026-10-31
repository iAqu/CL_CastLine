-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    2, 4
}

return {
    getServerLuckMultiplierForTier = function(p1) -- getServerLuckMultiplierForTier | line: 10
        -- upvalues: t1 (copy)
        local v1 = t1[p1]

        if v1 == nil then
            v1 = 1
        end

        return v1
    end,
    getMaxServerLuckMultiplier = function() -- getMaxServerLuckMultiplier | line: 19
        -- upvalues: t1 (copy)
        local n1 = 1

        for _, v2 in t1 do
            if n1 < v2 then
                n1 = v2
            end
        end

        return n1
    end,
    serverLuckTiers = t1
}
