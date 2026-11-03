-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "setluck",
	Description = "Set server luck (Max x8)",
	Group = "DefaultSeniorStaff",
	Aliases = { "luck", "serverluck" },
	Args = {
		{
			Type = "number",
			Name = "Amount",
			Description = "Amount of luck"
		},
		{
			Type = "number",
			Name = "Duration",
			Description = "Amount of hours 0 -> 3"
		}
	}
}