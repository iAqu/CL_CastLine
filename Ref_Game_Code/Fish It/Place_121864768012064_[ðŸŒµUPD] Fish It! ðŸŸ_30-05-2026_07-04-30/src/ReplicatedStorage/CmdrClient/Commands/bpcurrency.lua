-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "bpcurrency",
	Description = "Add currency",
	Group = "DefaultDeveloper",
	Aliases = { "bpcurrency", "bp", "addbp", "addbpcurrency" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "number",
			Name = "Amount",
			Description = "Amount of currency"
		}
	}
}