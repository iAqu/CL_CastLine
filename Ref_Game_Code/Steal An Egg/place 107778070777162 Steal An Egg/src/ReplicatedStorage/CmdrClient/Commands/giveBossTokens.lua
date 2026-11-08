-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveBossTokens",
    Description = "Gives the player Boss Tokens.",
    Group = "Admin",
    Aliases = { "" },
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players to give tokens to."
        },
        {
            Type = "integer",
            Name = "Amount",
            Description = "The amount of tokens to give."
        }
    }
}
