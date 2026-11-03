-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession()
return {
	TradeLocked = true,
	Hidden = true,
	Duration = 1800,
	VFX = "Love Potion",
	Data = {
		Id = 18,
		Type = "Potions",
		Name = "TALONS TESTING POTION",
		Description = "ONLY WORKS IN TEST SERVER",
		Icon = "",
		Tier = 100
	},
	Modifiers = {},
	_moduleScript = script
}