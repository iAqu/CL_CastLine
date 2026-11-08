-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "forceNextCatch",
    Description = "Force the next Haunted Rod catch (one shot, consumed by the next cast).",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Players",
            Description = "Players to arm. Defaults to you.",
            Optional = true
        },
        {
            Type = "string",
            Name = "Reward",
            Description = "ghostfish, tokens, egg, mutation, pet (also the Ghost Fish), manorkey (sewer cave, key not claimed yet) or clear",
            Default = "ghostfish"
        }
    }
}
