-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")

return {
    Name = "json-array-encode",
    Description = "Encodes a comma-separated list into a JSON array",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "string",
            Name = "CSV",
            Description = "The comma-separated list"
        }
    },
    Run = function(_, p2) -- Run | line: 16
        -- upvalues: HttpService (copy)
        return HttpService:JSONEncode(p2:split(","))
    end
}
