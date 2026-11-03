-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = -1,
	Ambiance = {
		SoundId = "rbxassetid://131592882216748",
		Volume = 0.2
	},
	Lighting = {
		GeographicLatitude = 0,
		Ambient = Color3.fromRGB(124, 107, 90),
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(0, 0, 0),
		OutdoorAmbient = Color3.fromRGB(117, 74, 74)
	},
	Atmosphere = {
		Density = 0.275,
		Glare = 0.2,
		Haze = 2.24,
		Color = Color3.fromRGB(205, 244, 255),
		Decay = Color3.fromRGB(236, 210, 239)
	},
	Clouds = {
		Cover = 0.628,
		Density = 0.11,
		Color = Color3.fromRGB(255, 230, 189)
	},
	Sky = script:WaitForChild("Sky")
}