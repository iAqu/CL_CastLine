-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    hueForElapsed = function(p1, p2) -- hueForElapsed | line: 3
        if p2 <= 0 then
            return 0
        end

        return p1 % p2 / p2
    end
}
