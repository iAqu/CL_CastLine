-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "petstate",
	Description = "Force replicated pet state",
	Group = "DefaultDeveloper",
	Aliases = { "petstate" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player"
		},
		{
			Type = "string",
			Name = "State",
			Description = "Follow | Fishing | Idle | Run | None"
		}
	}
}