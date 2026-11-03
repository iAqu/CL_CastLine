-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "tpisland",
	Description = "Teleports a player or set of players to one target.",
	Group = "DefaultStaff",
	Aliases = { "warp", "island", "tpisland", "location", "tplocation" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to teleport"
		},
		{
			Type = "string",
			Name = "Location",
			Description = "Place you are teleporting too"
		}
	}
}