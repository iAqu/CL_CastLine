-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "mountAudit",
    Description = "Audit every pet, or one species, for mount attachments and R15 reach at four sizes.",
    Group = "Admin",
    Args = {
        {
            Name = "Species",
            Type = "string",
            Description = "Optional exact species; omit to scan all pets.",
            Optional = true
        }
    }
}
