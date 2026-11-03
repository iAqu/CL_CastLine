-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then 0.000018181818181818182 else 0.000013333333333333333
return {
	SellPrice = 45000,
	EventTag = "VAL26",
	Data = {
		Id = 744,
		Type = "Fish",
		Name = "Choco Shark",
		Description = "",
		Icon = "rbxassetid://108699083842154",
		Tier = 6
	},
	Weight = {
		Big = NumberRange.new(2300, 2800),
		Default = NumberRange.new(1400, 1900)
	},
	Probability = {
		Chance = v1
	},
	Events = { "Valentines Event" },
	_moduleScript = script
}