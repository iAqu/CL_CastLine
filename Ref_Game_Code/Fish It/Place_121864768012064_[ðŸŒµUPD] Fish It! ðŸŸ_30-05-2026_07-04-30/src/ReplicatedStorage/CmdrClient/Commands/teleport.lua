-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "teleport",
	Description = "Teleports a player or set of players to one target.",
	Group = "DefaultStaff",
	Aliases = { "tp", "tele" },
	Args = {
		{
			Type = "players",
			Name = "From",
			Description = "The players to teleport"
		},
		{
			Type = "player",
			Name = "To",
			Description = "The player to teleport to"
		}
	}
}