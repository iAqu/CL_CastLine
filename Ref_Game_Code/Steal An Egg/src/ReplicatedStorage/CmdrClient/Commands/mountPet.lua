-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "mountPet",
    Description = "Start riding an owned rideable pet.",
    Group = "Admin",
    Args = {
        {
            Name = "UID",
            Type = "string",
            Description = "Pet UID; use mountPets to list your pets."
        },
        {
            Name = "Player",
            Type = "player",
            Description = "Rider; defaults to you.",
            Optional = true
        }
    }
}
