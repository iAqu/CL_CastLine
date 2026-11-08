-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveButterflies",
    Description = "Give (or take, with a negative amount) butterflies of one tier: Green, Blue, Purple or Golden.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players to give butterflies to."
        },
        {
            Type = "string",
            Name = "Tier",
            Description = "Green, Blue, Purple or Golden."
        },
        {
            Type = "integer",
            Name = "Amount",
            Description = "How many to give."
        }
    }
}
