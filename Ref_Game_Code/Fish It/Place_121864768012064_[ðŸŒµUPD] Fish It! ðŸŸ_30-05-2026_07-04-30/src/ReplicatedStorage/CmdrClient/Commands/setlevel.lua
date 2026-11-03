-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "setlevel",
	Description = "Set your level",
	Group = "DefaultDeveloper",
	Aliases = { "level" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to update"
		},
		{
			Type = "number",
			Name = "Level",
			Description = "Level 1 -> 9999"
		}
	}
}