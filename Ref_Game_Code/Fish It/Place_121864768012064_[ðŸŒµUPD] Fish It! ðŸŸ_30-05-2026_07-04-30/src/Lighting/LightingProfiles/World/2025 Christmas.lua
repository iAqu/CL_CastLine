-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 40,
	ForcedClockTime = 0,
	GeographicLatitude = 0,
	WaitForSignal = false,
	SignalName = "Christmas2025",
	Ambience = {
		SoundId = "rbxassetid://551546110",
		Volume = 0.09
	},
	Lighting = {
		Ambient = Color3.fromRGB(53, 54, 131),
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(0, 0, 0),
		OutdoorAmbient = Color3.fromRGB(82, 70, 144)
	},
	Atmosphere = {
		Density = 0.47,
		Offset = 0.25,
		Glare = 0.2,
		Haze = 2.24,
		Color = Color3.fromRGB(172, 233, 255),
		Decay = Color3.fromRGB(219, 175, 255)
	},
	Clouds = {
		Enabled = false
	},
	Sky = script.Sky
}