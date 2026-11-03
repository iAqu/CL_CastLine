-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 5,
	["Valentines Event"] = {
		Priority = 10,
		Ambiance = {
			SoundId = "rbxassetid://106359821741155",
			Volume = 0.2
		}
	},
	Day = {
		Priority = 5,
		Ambiance = {
			SoundId = "rbxassetid://106359821741155",
			Volume = 0.2
		},
		Lighting = {
			Ambient = Color3.fromRGB(149, 72, 84)
		},
		Atmosphere = {
			Color = Color3.fromRGB(219, 216, 255)
		}
	},
	Night = {
		Priority = 5,
		Music = {
			SoundId = "rbxassetid://106359821741155",
			Volume = 0.2
		},
		Lighting = {
			Ambient = Color3.fromRGB(115, 55, 65)
		},
		Atmosphere = {
			Color = Color3.fromRGB(219, 216, 255)
		}
	}
}