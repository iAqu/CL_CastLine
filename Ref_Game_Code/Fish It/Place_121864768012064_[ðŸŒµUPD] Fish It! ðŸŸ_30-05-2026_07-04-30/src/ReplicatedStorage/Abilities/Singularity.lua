-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Singularity",
	Description = "Black hole power with a large luck boost",
	Weight = 4,
	VFX = "Singularity",
	CastNumberTrigger = 400,
	NumOfRollsEffectStays = 40,
	Data = {
		Type = "Abilities",
		Name = "Singularity",
		Description = "Black hole power with a large luck boost",
		Icon = "rbxassetid://108910293419502",
		Tier = 6
	},
	Color = ColorSequence.new(Color3.fromRGB(142, 89, 255)),
	Sounds = { "Ability Singularity" },
	Modifiers = {
		BaseLuck = 7
	}
}