-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "mountPets",
    Description = "List owned pets, their UIDs, scales and rideable status.",
    Group = "Admin",
    Args = {
        {
            Name = "Player",
            Type = "player",
            Description = "Owner; defaults to you.",
            Optional = true
        }
    }
}
