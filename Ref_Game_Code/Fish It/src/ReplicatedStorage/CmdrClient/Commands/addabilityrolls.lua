-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "addabilityrolls",
	Description = "Add ability rolls",
	Group = "DefaultDeveloper",
	Aliases = { "abilityrolls", "addabilityroll", "addrolls" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "integer",
			Name = "Amount",
			Description = "Amount of ability rolls"
		}
	}
}