-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "nextKingEgg",
    Description = "Guarantee one Pumpkin King egg on each selected player's next Pumpkin King defeat in this server, including admin fights.",
    Group = "Admin",
    Aliases = { "pumpkinKingEgg" },
    Args = {
        {
            Type = "players",
            Name = "Players",
            Description = "Players to arm. Defaults to you; use all for current players.",
            Optional = true
        },
        {
            Type = "boolean",
            Name = "Enabled",
            Description = "False cancels the pending guarantee. Defaults to true.",
            Optional = true
        }
    }
}
