-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "addcoins",
	Description = "Add coins",
	Group = "DefaultDeveloper",
	Aliases = { "add", "coins" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "number",
			Name = "Amount",
			Description = "Amount of coins"
		}
	}
}