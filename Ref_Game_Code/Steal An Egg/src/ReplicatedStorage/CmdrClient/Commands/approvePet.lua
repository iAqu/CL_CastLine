-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "approvePet",
    Description = "Approve the mount fit of the pet currently in mount review.",
    Group = "Admin",
    Aliases = { "approve" },
    Args = {
        {
            Name = "Note",
            Type = "string",
            Description = "Optional comment.",
            Optional = true
        }
    }
}
