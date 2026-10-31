-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectServerLuckInfo = function(p1) -- selectServerLuckInfo | line: 2
        return p1.serverLuck
    end,
    selectServerLuckMultiplier = function(p2) -- selectServerLuckMultiplier | line: 5
        return p2.serverLuck.multiplier
    end
}
