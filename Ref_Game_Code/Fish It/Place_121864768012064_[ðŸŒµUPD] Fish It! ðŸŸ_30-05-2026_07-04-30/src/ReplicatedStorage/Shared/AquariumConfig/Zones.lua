-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	["Area 1"] = {
		Id = "Area 1",
		UnlockCost = 500000,
		RequiredZoneId = "Base"
	},
	["Area 2"] = {
		Id = "Area 2",
		UnlockCost = 500000,
		RequiredZoneId = "Area 1"
	},
	["Area 3"] = {
		Id = "Area 3",
		UnlockCost = 1000000,
		RequiredZoneId = "Area 2"
	},
	["Area 4"] = {
		Id = "Area 4",
		UnlockCost = 2000000,
		RequiredZoneId = "Area 3"
	}
}