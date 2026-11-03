-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then 0.0005 else 0.0003333333333333333
return {
	SellPrice = 3000,
	EventTag = "VAL26",
	Data = {
		Id = 740,
		Type = "Fish",
		Name = "Lovtopus",
		Description = "",
		Icon = "rbxassetid://102560082182215",
		Tier = 4
	},
	Weight = {
		Big = NumberRange.new(0.38, 0.51),
		Default = NumberRange.new(0.26, 0.34)
	},
	Probability = {
		Chance = v1
	},
	Events = { "Valentines Event" },
	_moduleScript = script
}