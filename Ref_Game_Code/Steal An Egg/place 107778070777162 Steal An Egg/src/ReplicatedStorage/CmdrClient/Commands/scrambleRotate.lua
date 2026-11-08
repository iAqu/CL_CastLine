-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "scrambleRotate",
    Description = "Rotate this server's Dr. Scramble laboratory banner now and restart its one-hour timer.",
    Group = "Admin",
    Aliases = { "labRotate" },
    Args = {
        {
            Type = "string",
            Name = "Banner",
            Description = "next (weighted), Biohazard, Experimental, or UnstableDNA.",
            Optional = true,
            Default = "next"
        }
    }
}
