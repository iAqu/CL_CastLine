-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "ban",
	Description = "Ban a player",
	Group = "DefaultSeniorStaff",
	Aliases = { "ban" },
	Args = {
		{
			Type = "string",
			Name = "Player Name",
			Description = "Name of the player"
		},
		{
			Type = "string",
			Name = "Reason",
			Description = "Why were they banned"
		}
	}
}