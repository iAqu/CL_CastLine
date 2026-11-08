-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "announceAsSelf",
    Description = "Send announcements under your own name instead of the admin persona.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players to change."
        },
        {
            Type = "boolean",
            Name = "AsSelf",
            Description = "true to announce as yourself, false to use the persona."
        }
    }
}
