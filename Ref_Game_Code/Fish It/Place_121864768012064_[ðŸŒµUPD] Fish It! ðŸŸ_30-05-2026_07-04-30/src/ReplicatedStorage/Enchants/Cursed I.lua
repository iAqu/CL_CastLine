-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Data = {
		Id = 12,
		Type = "Enchants",
		Name = "Cursed I",
		Description = "-75% Luck, +75% mutation chance",
		Icon = "",
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 52, 96)), ColorSequenceKeypoint.new(1, Color3.fromRGB(189, 9, 12)) })
	},
	Modifiers = {
		BaseLuck = -0.75,
		MutationMultiplier = 0.75
	},
	_moduleScript = script
}