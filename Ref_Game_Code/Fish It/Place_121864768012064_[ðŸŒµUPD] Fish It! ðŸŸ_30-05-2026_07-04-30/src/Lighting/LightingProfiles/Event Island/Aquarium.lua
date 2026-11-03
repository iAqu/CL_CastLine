-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 5000,
	ForcedClockTime = 1.7,
	ExposureCompensation = 0.25,
	Ambiance = {
		SoundId = "rbxassetid://112240876596143",
		Volume = 0.13
	},
	Lighting = {
		Ambient = Color3.fromRGB(42, 63, 90),
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(75, 177, 255),
		OutdoorAmbient = Color3.fromRGB(54, 85, 131)
	},
	Atmosphere = {
		Density = 0.4,
		Glare = 0.35,
		Haze = 2.35,
		Color = Color3.fromRGB(15, 37, 84),
		Decay = Color3.fromRGB(149, 157, 184)
	},
	Clouds = {
		Enabled = false,
		Color = Color3.fromRGB(139, 224, 255)
	},
	Sky = script.Sky
}