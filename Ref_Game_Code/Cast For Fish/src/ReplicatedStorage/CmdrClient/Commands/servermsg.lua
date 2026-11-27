-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "announcement",
    Description = "Broadcasts a filtered announcement to every live server.",
    Group = "Admin",
    Aliases = { "servermsg", "globalannounce", "ga" },
    Args = {
        {
            Type = "string",
            Name = "text",
            Description = "Announcement text."
        }
    }
}
