-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "AddCoins",
	Description = "Adds a global event",
	Group = "DefaultAdmin",
	Aliases = { "ac" },
	Args = {
		{
			Type = "player",
			Name = "Player Name",
			Description = ""
		},
		{
			Type = "number",
			Name = "Amount",
			Description = "Coins to add"
		}
	}
}