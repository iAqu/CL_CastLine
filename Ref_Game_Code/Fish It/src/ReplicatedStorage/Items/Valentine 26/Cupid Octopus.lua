-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then 0.0005 else 0.0003333333333333333
return {
	SellPrice = 3000,
	EventTag = "VAL26",
	Data = {
		Id = 745,
		Type = "Fish",
		Name = "Cupid Octopus",
		Description = "",
		Icon = "rbxassetid://82155168095486",
		Tier = 4
	},
	Weight = {
		Big = NumberRange.new(0.52, 0.67),
		Default = NumberRange.new(0.32, 0.44)
	},
	Probability = {
		Chance = v1
	},
	Events = { "Valentines Event" },
	_moduleScript = script
}