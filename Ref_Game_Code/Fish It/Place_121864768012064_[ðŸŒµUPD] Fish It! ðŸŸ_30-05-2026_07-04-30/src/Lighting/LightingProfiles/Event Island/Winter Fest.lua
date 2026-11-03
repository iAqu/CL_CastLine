-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 1,
	Day = {
		Priority = 110,
		Ambiance = {
			SoundId = "rbxassetid://131592882216748",
			Volume = 0.08
		},
		Lighting = {
			Ambient = Color3.fromRGB(50, 60, 122),
			ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
			ColorShift_Top = Color3.fromRGB(0, 0, 0),
			OutdoorAmbient = Color3.fromRGB(117, 74, 74)
		},
		Atmosphere = {
			Density = 0.35,
			Glare = 0.2,
			Haze = 2.24,
			Color = Color3.fromRGB(205, 244, 255),
			Decay = Color3.fromRGB(236, 210, 239)
		},
		Clouds = {
			Color = Color3.fromRGB(255, 230, 189)
		}
	},
	Night = {
		Priority = 110,
		Ambiance = {
			SoundId = "rbxassetid://73546652192165",
			Volume = 0.08
		},
		Lighting = {
			Ambient = Color3.fromRGB(54, 100, 157),
			ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
			ColorShift_Top = Color3.fromRGB(0, 0, 0),
			OutdoorAmbient = Color3.fromRGB(106, 67, 67)
		},
		Atmosphere = {
			Density = 0.37,
			Glare = 0.2,
			Haze = 2.24,
			Color = Color3.fromRGB(205, 244, 255),
			Decay = Color3.fromRGB(236, 210, 239)
		},
		Clouds = {
			Color = Color3.fromRGB(105, 165, 193)
		}
	}
}