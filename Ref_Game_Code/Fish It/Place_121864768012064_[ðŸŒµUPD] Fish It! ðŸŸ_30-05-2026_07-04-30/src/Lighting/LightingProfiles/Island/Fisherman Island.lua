-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 1,
	Day = {
		Priority = 5,
		Music = {
			SoundId = "rbxassetid://97939870066711",
			Volume = 0.05
		},
		Ambiance = {
			SoundId = "rbxassetid://131592882216748",
			Volume = 0.2
		},
		Lighting = {
			Ambient = Color3.fromRGB(92, 86, 124),
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
		}
	},
	Night = {
		Priority = 5,
		Music = {
			SoundId = "rbxassetid://97939870066711",
			Volume = 0.1
		},
		Ambiance = {
			SoundId = "rbxassetid://73546652192165",
			Volume = 0.05
		},
		Lighting = {
			Ambient = Color3.fromRGB(79, 94, 141),
			ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
			ColorShift_Top = Color3.fromRGB(0, 0, 0),
			OutdoorAmbient = Color3.fromRGB(106, 67, 67)
		},
		Atmosphere = {
			Density = 0.275,
			Glare = 0.2,
			Haze = 2.24,
			Color = Color3.fromRGB(205, 244, 255),
			Decay = Color3.fromRGB(236, 210, 239)
		}
	}
}