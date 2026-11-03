-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Admin - Meteor Rain",
	Icon = "rbxassetid://85808602968553",
	Description = "Fish in Meteor Rain area!",
	GlobalDescription = "Fish in Meteor Rain area for x9 mutation chance!",
	Tier = 7,
	QueueTime = 0,
	Duration = 3600,
	Coordinates = { Vector3.new(383, -1.4, 2452) },
	LinkedEvents = {
		Fish = {},
		Variants = {},
		Modifiers = {
			["Admin - Black Hole"] = {
				MutationMultiplier = 9,
				BaseLuck = 0.3
			}
		}
	},
	Modifiers = {}
}