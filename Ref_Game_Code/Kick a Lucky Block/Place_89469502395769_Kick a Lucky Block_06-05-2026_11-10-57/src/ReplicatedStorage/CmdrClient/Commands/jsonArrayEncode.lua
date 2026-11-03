-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
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
	Run = function(p1, p2) --[[ Run | Line: 16 | Upvalues: HttpService (copy) ]]
		return HttpService:JSONEncode(p2:split(","))
	end
}