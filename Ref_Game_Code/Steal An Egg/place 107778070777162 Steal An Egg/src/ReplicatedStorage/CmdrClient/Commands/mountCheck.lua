-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "mountCheck",
    Description = "Check mount size and artist attachments for an owned pet.",
    Group = "Admin",
    Args = {
        {
            Name = "UID",
            Type = "string",
            Description = "Pet UID."
        },
        {
            Name = "Player",
            Type = "player",
            Description = "Owner; defaults to you.",
            Optional = true
        }
    }
}
