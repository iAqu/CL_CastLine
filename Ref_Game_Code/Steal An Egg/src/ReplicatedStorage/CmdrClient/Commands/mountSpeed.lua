-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "mountSpeed",
    Description = "Override mount speed; omit speed or use 0 to inherit player speed again.",
    Group = "Admin",
    Args = {
        {
            Name = "Speed",
            Type = "number",
            Description = "Override in studs/s; 0 resets it.",
            Optional = true
        },
        {
            Name = "Player",
            Type = "player",
            Description = "Rider; defaults to you.",
            Optional = true
        }
    }
}
