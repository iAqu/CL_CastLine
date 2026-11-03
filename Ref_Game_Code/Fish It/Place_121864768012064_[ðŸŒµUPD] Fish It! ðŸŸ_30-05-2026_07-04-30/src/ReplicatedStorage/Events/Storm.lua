-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Storm",
	Icon = "rbxassetid://111709787385701",
	Description = "Increase rod speed and luck",
	Tier = 3,
	Duration = 900,
	WeatherMachine = true,
	WeatherMachinePrice = 35000,
	Modifiers = {
		BaseLuck = 0.2,
		ReelMultiplier = 0.1
	},
	AreaConfiguration = {
		Fish = {
			["No Fishing"] = { "Coral Manta Ray" },
			["Pirate Treasure Room"] = { "Stormy Dumbo" },
			["Pirate Cove"] = { "Rainy Dumbo" }
		},
		Variants = {},
		Modifiers = {}
	},
	LinkedEvents = {
		Fish = {},
		Variants = {},
		Modifiers = {}
	}
}