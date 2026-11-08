-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveCandyCorn",
    Description = "Gives the player Candy Corn (Halloween Tokens). Counts toward the Headless Horseman battlepass.",
    Group = "Admin",
    Aliases = { "" },
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players to give Candy Corn to."
        },
        {
            Type = "integer",
            Name = "Amount",
            Description = "The amount of Candy Corn to give."
        }
    }
}
