-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Lava",
	Description = "Boosted luck with an additional boost target at catching sharks",
	Weight = 14,
	VFX = "Lava",
	CastNumberTrigger = 400,
	NumOfRollsEffectStays = 40,
	Data = {
		Type = "Abilities",
		Name = "Lava",
		Description = "Boosted luck with an additional boost target at catching sharks",
		Icon = "rbxassetid://85418953540646",
		Tier = 4
	},
	Color = ColorSequence.new(Color3.fromRGB(255, 91, 33)),
	Sounds = { "Ability Lava" },
	Modifiers = {
		BaseLuck = 1.2,
		FireMutation = 7,
		SharkMultiplier = 100
	}
}