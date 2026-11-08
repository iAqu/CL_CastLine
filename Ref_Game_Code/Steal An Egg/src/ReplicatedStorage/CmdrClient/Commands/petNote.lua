-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "petNote",
    Description = "Save mount feedback for the pet currently in mount review.",
    Group = "Admin",
    Aliases = { "note" },
    Args = {
        {
            Name = "Text",
            Type = "string",
            Description = "Feedback for this pet."
        }
    }
}
