-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "AddServerMulti",
	Description = "Adds server multiplier",
	Group = "DefaultAdmin",
	Aliases = { "amm" },
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