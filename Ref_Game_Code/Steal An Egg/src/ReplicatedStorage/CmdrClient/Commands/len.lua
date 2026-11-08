-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "len",
    Description = "Returns the length of a comma-separated list",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "string",
            Name = "CSV",
            Description = "The comma-separated list"
        }
    },
    Run = function(_, p2) -- Run | line: 14
        return #p2:split(",")
    end
}
