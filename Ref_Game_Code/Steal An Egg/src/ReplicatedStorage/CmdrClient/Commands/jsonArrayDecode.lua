-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "json-array-decode",
    Description = "Decodes a JSON Array into a comma-separated list",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "json",
            Name = "JSON",
            Description = "The JSON array."
        }
    },
    ClientRun = function(_, p2) -- ClientRun | line: 14
        local v1 = if type(p2) == "table" then p2 else { p2 }

        return table.concat(v1, ",")
    end
}
