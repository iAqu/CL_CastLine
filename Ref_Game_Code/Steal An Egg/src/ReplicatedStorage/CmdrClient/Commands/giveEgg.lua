-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveEgg",
    Description = "Gives the players an egg of the given asset.",
    Group = "Admin",
    Aliases = { "" },
    Args = {
        {
            Type = "players",
            Name = "Players",
            Description = "The players to give the egg to."
        },
        {
            Type = "assetDisplayName",
            Name = "Egg",
            Description = "The asset the egg hatches into, by asset name or display name."
        },
        {
            Type = "mutations",
            Name = "Mutations",
            Description = "Comma separated mutations. Defaults to none.",
            Optional = true
        },
        {
            Type = "number",
            Name = "Scale",
            Description = "Egg scale. Defaults to 1.",
            Optional = true
        }
    }
}
