-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 5000,
	ForcedClockTime = 0,
	Music = {
		SoundId = "rbxassetid://1847704797",
		Volume = 0.2
	},
	Ambiance = {
		SoundId = "rbxassetid://131592882216748",
		Volume = 0.16
	},
	Lighting = {
		Ambient = Color3.fromRGB(92, 86, 124),
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(0, 0, 0),
		OutdoorAmbient = Color3.fromRGB(177, 128, 172)
	},
	Atmosphere = {
		Density = 0.288,
		Glare = 1.81,
		Haze = 2,
		Color = Color3.fromRGB(255, 255, 255),
		Decay = Color3.fromRGB(255, 255, 255)
	},
	Clouds = {
		Enabled = false
	},
	Sky = script.Sky,
	WaterColor = Color3.fromRGB(9, 9, 9)
}