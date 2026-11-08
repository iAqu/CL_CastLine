-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "convertTimestamp",
    Description = "Convert a timestamp to a human-readable format.",
    Group = "DefaultUtil",
    Aliases = { "date" },
    Args = {
        {
            Type = "number",
            Name = "timestamp",
            Description = "A numerical representation of a specific moment in time.",
            Optional = true
        }
    },
    ClientRun = function(_, p2) -- ClientRun | line: 14
        p2 = p2 or os.time()

        return (("%* %*"):format(os.date("%x", p2), (os.date("%X", p2))))
    end
}
