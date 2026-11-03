-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Data = {
		Id = 32,
		Type = "Enchants",
		Name = "Empowered II",
		Description = "+35% luck, +15% faster reel",
		Icon = "",
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 171, 87)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 119)) })
	},
	Modifiers = {
		BaseLuck = 0.35,
		ReelMultiplier = 0.15
	},
	_moduleScript = script
}