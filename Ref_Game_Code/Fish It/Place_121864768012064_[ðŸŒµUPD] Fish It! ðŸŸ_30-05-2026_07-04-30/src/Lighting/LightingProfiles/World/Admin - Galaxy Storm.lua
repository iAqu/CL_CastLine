-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 5000,
	ForcedClockTime = 3,
	Ambiance = {
		SoundId = "rbxassetid://90083112491064",
		Volume = 0.12
	},
	Lighting = {
		Ambient = Color3.fromRGB(92, 86, 124),
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(0, 0, 0),
		OutdoorAmbient = Color3.fromRGB(136, 70, 250)
	},
	Atmosphere = {
		Density = 0.288,
		Glare = 0.99,
		Haze = 1.89,
		Color = Color3.fromRGB(109, 17, 166),
		Decay = Color3.fromRGB(109, 17, 166)
	},
	Clouds = {
		Enabled = false
	},
	WaterColor = Color3.fromRGB(101, 85, 163),
	Sky = script.Sky
}