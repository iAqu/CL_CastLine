-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "globalSetFargateInstances",
    Description = "Sets fargate instances (default 5, for AA with 10m+ set to 900)",
    Group = "Moderator",
    Args = {
        {
            Type = "integer",
            Name = "Amount"
        }
    }
}
