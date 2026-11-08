-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "goto-player",
    Description = "Join a player's server by Roblox username.",
    Group = "Admin",
    Aliases = { "join-player" },
    Args = {
        {
            Type = "string",
            Name = "Username",
            Description = "The player's Roblox username"
        }
    }
}
