-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "GlobalMulti",
	Description = "Adds global multiplier",
	Group = "DefaultAdmin",
	Aliases = { "gmm" },
	Args = {
		{
			Type = "multiplier",
			Name = "Name",
			Description = ""
		},
		{
			Type = "number",
			Name = "Multiplier",
			Description = ""
		},
		{
			Type = "number",
			Name = "Duration",
			Description = "",
			Optional = true
		}
	}
}