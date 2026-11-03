-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "giverod",
	Description = "Give yourself a rod",
	Group = "DefaultDeveloper",
	Aliases = { "rod", "giverod" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "string",
			Name = "RodName",
			Description = "Rod to give"
		}
	}
}