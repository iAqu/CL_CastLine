-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "GiveBrainrot",
	Description = "Gives global brainrot",
	Group = "DefaultAdmin",
	Aliases = { "gbb" },
	Args = {
		{
			Type = "player",
			Name = "Player Name",
			Description = ""
		},
		{
			Type = "brainrot",
			Name = "Brainrot Name",
			Description = ""
		},
		{
			Type = "mutation",
			Name = "Mutation Name",
			Description = "",
			Optional = true
		}
	}
}