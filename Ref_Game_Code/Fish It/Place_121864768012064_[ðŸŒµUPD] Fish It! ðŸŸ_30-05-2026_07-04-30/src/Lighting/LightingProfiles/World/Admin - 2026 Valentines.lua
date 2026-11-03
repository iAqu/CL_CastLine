-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 5000,
	ForcedClockTime = 11,
	Lighting = {
		Ambient = Color3.fromRGB(124, 107, 90)
	},
	Atmosphere = {
		Density = 0.27,
		Glare = 0.5,
		Haze = 2.24,
		Color = Color3.fromRGB(255, 124, 181),
		Decay = Color3.fromRGB(239, 173, 227)
	},
	Clouds = {
		Cover = 0.736,
		Density = 0.164,
		Enabled = true,
		Color = Color3.fromRGB(255, 143, 145)
	},
	WaterColor = Color3.fromRGB(121, 82, 82),
	Sky = script.Sky
}