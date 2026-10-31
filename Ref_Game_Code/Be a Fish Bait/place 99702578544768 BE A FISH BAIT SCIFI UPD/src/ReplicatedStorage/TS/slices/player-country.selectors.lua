-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectPlayerCountry = function(p1) -- selectPlayerCountry | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            return p2.playerCountry[p1]
        end
    end
}
