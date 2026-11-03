-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Priority = 50000000,
	ForcedClockTime = 7,
	Music = {
		SoundId = "rbxassetid://97939870066711",
		Volume = 0.04
	},
	Ambiance = {
		SoundId = "rbxassetid://73546652192165",
		Volume = 0.12
	},
	Lighting = {
		GeographicLatitude = 69,
		Ambient = Color3.fromRGB(63, 68, 172)
	},
	Atmosphere = {
		Density = 0.35,
		Glare = 0.16,
		Haze = 2.13,
		Color = Color3.fromRGB(207, 112, 255),
		Decay = Color3.fromRGB(148, 162, 193)
	},
	Clouds = {
		Enabled = false
	},
	Sky = script:WaitForChild("Sky"),
	WaterColor = Color3.fromRGB(83, 101, 129)
}