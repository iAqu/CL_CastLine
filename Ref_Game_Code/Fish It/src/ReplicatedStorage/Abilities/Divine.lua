-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Divine",
	Description = "Blesses nearby players with boosted luck giving you tripple fish pull",
	Weight = 4,
	VFX = "Divine",
	CastNumberTrigger = 400,
	NumOfRollsEffectStays = 100,
	SupportRange = 35,
	Data = {
		Type = "Abilities",
		Name = "Divine",
		Description = "Blesses nearby players with boosted luck giving you triple fish pull",
		Icon = "rbxassetid://96931853566479",
		Tier = 7
	},
	Color = ColorSequence.new(Color3.fromRGB(255, 245, 174)),
	Sounds = { "Ability Divine" },
	Modifiers = {
		BaseLuck = 2.5
	},
	SupportModifiers = {
		BaseLuck = 1.5
	},
	Callbacks = {
		OnFishCaught = "LightningPullSequence"
	}
}