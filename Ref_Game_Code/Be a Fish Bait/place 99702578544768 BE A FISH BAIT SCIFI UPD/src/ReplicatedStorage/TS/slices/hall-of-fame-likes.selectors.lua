-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectHallOfFameMessageLikeCount = function(p1) -- selectHallOfFameMessageLikeCount | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            local v1 = p2.hallOfFameLikes[p1]

            if v1 == nil then
                v1 = 0
            end

            return v1
        end
    end
}
