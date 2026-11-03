-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Frost",
	Description = "Boosted luck with a chance for frost mutations",
	Weight = 18,
	VFX = "Frost",
	CastNumberTrigger = 350,
	NumOfRollsEffectStays = 35,
	Data = {
		Type = "Abilities",
		Name = "Frost",
		Description = "Boosted luck with a chance for frost mutations",
		Icon = "rbxassetid://134576341080583",
		Tier = 3
	},
	Color = ColorSequence.new(Color3.fromRGB(159, 220, 255)),
	Sounds = { "Ability Frost" },
	Modifiers = {
		BaseLuck = 2.75,
		FrozenMutation = 8
	}
}