-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 5000,
	ForcedClockTime = 3,
	Ambiance = {
		SoundId = "rbxassetid://89072921123246",
		Volume = 0.18
	},
	Lighting = {
		Ambient = Color3.fromRGB(85, 73, 62),
		OutdoorAmbient = Color3.fromRGB(117, 74, 74)
	},
	Atmosphere = {
		Density = 0.298,
		Glare = 0.1,
		Haze = 2.1,
		Color = Color3.fromRGB(255, 255, 255),
		Decay = Color3.fromRGB(255, 197, 115)
	},
	Clouds = {
		Enabled = false
	},
	WaterColor = Color3.fromRGB(129, 95, 84),
	Sky = script.Sky
}