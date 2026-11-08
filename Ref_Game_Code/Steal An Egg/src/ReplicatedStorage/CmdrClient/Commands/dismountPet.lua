-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "dismountPet",
    Description = "Stop riding and restore your character.",
    Group = "Admin",
    Args = {
        {
            Name = "Player",
            Type = "player",
            Description = "Rider; defaults to you.",
            Optional = true
        }
    }
}
