-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "experimentVariant",
    Description = "Forces an experiment variant on this server through the ExperimentService testing override. Use clear to remove it.",
    Group = "Admin",
    Aliases = { "" },
    Args = {
        {
            Type = "string",
            Name = "ExperimentId",
            Description = "Experiment id from Shared.Experiments.Definitions."
        },
        {
            Type = "string",
            Name = "Variant",
            Description = "Variant name, or clear."
        }
    }
}
