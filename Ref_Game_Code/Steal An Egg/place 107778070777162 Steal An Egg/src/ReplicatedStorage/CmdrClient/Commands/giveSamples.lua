-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveSamples",
    Description = "Gives players Dr. Scramble Samples.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players to give Samples to."
        },
        {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of Samples to give."
        }
    }
}
