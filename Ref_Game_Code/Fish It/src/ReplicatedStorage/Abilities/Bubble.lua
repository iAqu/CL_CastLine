-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Bubble",
	Description = "A little extra luck when the giant bubble bursts",
	Weight = 24,
	VFX = "Bubble",
	CastNumberTrigger = 225,
	NumOfRollsEffectStays = 30,
	Data = {
		Type = "Abilities",
		Name = "Bubble",
		Description = "A little extra luck when the giant bubble bursts",
		Icon = "rbxassetid://76019485378312",
		Tier = 1
	},
	Color = ColorSequence.new(Color3.fromRGB(88, 221, 255)),
	Sounds = { "Ability Bubble" },
	Modifiers = {
		BaseLuck = 1.5,
		SizeMultiplier = -0.1
	}
}