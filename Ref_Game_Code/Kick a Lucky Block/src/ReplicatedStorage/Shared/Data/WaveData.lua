-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Waves = script:WaitForChild("Waves")
return {
	Waves = {
		Common = {
			Speed = 11,
			CameraDistance = 120,
			Start_X = 549.768,
			Wave_Y = 14.5,
			Model = Waves.Common
		},
		Rare = {
			Speed = 18,
			CameraDistance = 120,
			Start_X = 372.268,
			Wave_Y = 14.5,
			Model = Waves.Rare
		},
		Epic = {
			Speed = 32,
			CameraDistance = 120,
			Start_X = 132.268,
			Wave_Y = 14.5,
			Model = Waves.Epic
		},
		Legendary = {
			Speed = 45,
			CameraDistance = 120,
			Start_X = -142.731,
			Wave_Y = 14.5,
			Model = Waves.Legendary
		},
		Mythic = {
			Speed = 55,
			CameraDistance = 120,
			Start_X = -462.731,
			Wave_Y = 14.5,
			Model = Waves.Mythic
		},
		Godly = {
			Speed = 68,
			CameraDistance = 120,
			Start_X = -809.732,
			Wave_Y = 14.5,
			Model = Waves.Godly
		},
		Secret = {
			Speed = 80,
			CameraDistance = 120,
			Start_X = -1196.231,
			Wave_Y = 30,
			Model = Waves.Secret
		},
		Rainbow = {
			Speed = 90,
			CameraDistance = 120,
			Start_X = -1631.231,
			Wave_Y = 30,
			Model = Waves.Rainbow
		},
		Hacked = {
			Speed = 100,
			CameraDistance = 120,
			Start_X = -2111.231,
			Wave_Y = 30,
			Model = Waves.Hacked
		},
		Demon = {
			Speed = 110,
			CameraDistance = 120,
			Start_X = -2586.231,
			Wave_Y = 35.2,
			Model = Waves.Demon
		},
		Celestial = {
			Speed = 125,
			CameraDistance = 120,
			Start_X = -3287.86,
			Wave_Y = 35.2,
			Model = Waves.Celestial
		}
	}
}