-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
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
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 14 ]]
		if type(p2) ~= "table" then
			p2 = { p2 }
		end
		return table.concat(p2, ",")
	end
}