-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then 0.0002 else 0.00015384615384615385
return {
	SellPrice = 5500,
	EventTag = "VAL26",
	Data = {
		Id = 742,
		Type = "Fish",
		Name = "Walrus Gentlemen",
		Description = "",
		Icon = "rbxassetid://137825373191082",
		Tier = 5
	},
	Weight = {
		Big = NumberRange.new(24, 31),
		Default = NumberRange.new(16, 22)
	},
	Probability = {
		Chance = v1
	},
	Events = { "Valentines Event" },
	_moduleScript = script
}