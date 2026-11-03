-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Radiant",
	Icon = "rbxassetid://9940992285",
	Description = "Increases shiny chance",
	Tier = 3,
	Duration = 900,
	WeatherMachine = true,
	WeatherMachinePrice = 50000,
	AreaConfiguration = {
		Fish = {
			["Crystal Depths"] = { "Cute Dumbo" }
		},
		Variants = {},
		Modifiers = {}
	},
	LinkedEvents = {
		Fish = {},
		Variants = {},
		Modifiers = {}
	},
	Modifiers = {
		ShinyMultiplier = 1
	}
}