-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	SellPrice = 440000,
	OverrideLocation = "Sacred Temple",
	Data = {
		Id = 269,
		Type = "Fish",
		Name = "Elshark Gran Maja",
		Description = "",
		Icon = "rbxassetid://115522161459382",
		Tier = 7
	},
	Variants = { "Color Burn" },
	Weight = {
		Big = NumberRange.new(560000, 650000),
		Default = NumberRange.new(450000, 520000)
	},
	Probability = {
		Chance = 2.5e-7
	},
	QuestConfiguration = {
		CatchFish = {
			Tier = 7,
			AreaName = "Sacred Temple"
		}
	},
	_moduleScript = script
}