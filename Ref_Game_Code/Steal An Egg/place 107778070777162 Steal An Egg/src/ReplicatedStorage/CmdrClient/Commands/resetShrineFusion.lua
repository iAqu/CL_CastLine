-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "resetShrineFusion",
    Description = "Clear a player's once-per-account shrine fusion so it can be run again.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players to reset."
        },
        {
            Type = "shrineFusionTier",
            Name = "Tier",
            Description = "One fusion tier, or All.",
            Default = "All",
            Optional = true
        }
    }
}
