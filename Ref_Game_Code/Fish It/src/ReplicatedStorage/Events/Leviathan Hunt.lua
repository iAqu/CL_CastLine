-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Leviathan Hunt",
	Icon = "",
	Description = "Only 1 Leviathan!",
	GlobalDescription = "Be the first to catch the Leviathan!",
	Tier = 7,
	OptionalDuration = true,
	AreaConfiguration = {
		Fish = {},
		Variants = {},
		Modifiers = {}
	},
	LinkedEvents = {
		Fish = {},
		Variants = {},
		Modifiers = {
			LeviathanRageBoost = {
				LeviathanRageMutationMultiplier = 3
			}
		}
	},
	Modifiers = {}
}