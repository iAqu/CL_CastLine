-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Lightning",
	Description = "Zeus themed power that wields a great deal of luck",
	Weight = 8,
	VFX = "Lightning",
	CastNumberTrigger = 400,
	NumOfRollsEffectStays = 40,
	Data = {
		Type = "Abilities",
		Name = "Lightning",
		Description = "Zeus themed power that wields a great deal of luck",
		Icon = "rbxassetid://132225783568970",
		Tier = 5
	},
	Color = ColorSequence.new(Color3.fromRGB(255, 245, 102)),
	Sounds = { "Ability Lightning" },
	Modifiers = {
		BaseLuck = 4.5
	}
}