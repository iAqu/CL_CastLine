-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "fishingLoot",
    Description = "Roll and grant the Haunted Rod fishing loot (Game.FishingLoot flags), or list the odds.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Players",
            Description = "Players receiving the loot."
        },
        {
            Type = "string",
            Name = "Kind",
            Description = "roll (normal odds), tokens, egg, mutation, pet, or odds (list chances, grants nothing)",
            Default = "roll"
        },
        {
            Type = "number",
            Name = "Luck",
            Description = "Luck multiplier, 1 = normal cast, clamped by Game.FishingLoot.LuckMax.",
            Default = 1
        }
    }
}
