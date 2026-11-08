-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1) -- line: 2
    p1:RegisterType("scrambleAction", p1.Cmdr.Util.MakeEnumType("Scramble action", {
        "status",
        "start",
        "stop",
        "drops",
        "scrap",
        "reactor",
        "augmented",
        "quest",
        "drone",
        "reset",
        "complete"
    }))
end
