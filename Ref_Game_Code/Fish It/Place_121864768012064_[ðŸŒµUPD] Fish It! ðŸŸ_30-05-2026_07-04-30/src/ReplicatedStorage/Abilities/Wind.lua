-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Wind",
	Description = "Swirling wind increases luck and reeling speed",
	Weight = 20,
	VFX = "Wind",
	CastNumberTrigger = 300,
	NumOfRollsEffectStays = 30,
	Data = {
		Type = "Abilities",
		Name = "Wind",
		Description = "Swirling wind increases luck and reeling speed",
		Icon = "rbxassetid://92889423893851",
		Tier = 2
	},
	Color = ColorSequence.new(Color3.fromRGB(182, 255, 209)),
	Sounds = { "Ability Wind" },
	Modifiers = {
		BaseLuck = 2,
		ReelMultiplier = 0.06,
		SizeMultiplier = 0.08
	}
}