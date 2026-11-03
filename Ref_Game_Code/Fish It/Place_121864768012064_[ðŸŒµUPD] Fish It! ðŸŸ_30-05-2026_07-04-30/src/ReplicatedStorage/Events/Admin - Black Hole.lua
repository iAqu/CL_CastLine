-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Admin - Black Hole",
	Icon = "rbxassetid://85808602968553",
	Description = "Fish in Black Hole area!",
	GlobalDescription = "Fish in Black Hole for x7 Galaxy & Corrupt mutations!",
	Tier = 7,
	QueueTime = 0,
	Duration = 3600,
	Coordinates = { Vector3.new(883, -1, 2542) },
	LinkedEvents = {
		Fish = {},
		Variants = {},
		Modifiers = {
			["Admin - Black Hole"] = {
				CorruptMutationMultiplier = 7,
				GalaxyMutationMultiplier = 7
			}
		}
	},
	Modifiers = {}
}