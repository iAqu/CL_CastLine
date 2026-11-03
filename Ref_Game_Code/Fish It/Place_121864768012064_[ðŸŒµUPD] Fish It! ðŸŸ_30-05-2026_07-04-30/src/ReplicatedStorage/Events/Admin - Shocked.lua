-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Admin - Shocked",
	Icon = "rbxassetid://85808602968553",
	Description = "Fish in Shocked area!",
	GlobalDescription = "Fish in Shocked area for x8 Lightning mutation chance!",
	Tier = 7,
	QueueTime = 0,
	Duration = 3600,
	Coordinates = { Vector3.new(137.4, -1.4, 2268.5) },
	LinkedEvents = {
		Fish = {},
		Variants = {},
		Modifiers = {
			["Admin - Shocked"] = {
				LightningMutationMultiplier = 7
			}
		}
	},
	Modifiers = {}
}