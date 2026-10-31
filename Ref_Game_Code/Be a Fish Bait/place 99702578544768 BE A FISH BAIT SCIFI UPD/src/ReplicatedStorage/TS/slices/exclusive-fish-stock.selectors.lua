-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectExclusiveFishStock = function(p1) -- selectExclusiveFishStock | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            return p2.exclusiveFishStock[p1]
        end
    end
}
