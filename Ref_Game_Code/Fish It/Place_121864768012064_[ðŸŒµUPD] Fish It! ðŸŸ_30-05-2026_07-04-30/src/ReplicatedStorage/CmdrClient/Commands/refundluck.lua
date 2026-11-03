-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "refundLuck",
	Description = "Refund a player with saved luck",
	Group = "DefaultStaff",
	Aliases = { "refundLuck" },
	Args = {
		{
			Type = "number",
			Name = "Amount",
			Description = "Amount of luck x2 -> x8"
		},
		{
			Type = "number",
			Name = "Duration",
			Description = "Amount of hours 0h -> 3h"
		},
		{
			Type = "player",
			Name = "Player",
			Description = "Player to refund"
		}
	}
}