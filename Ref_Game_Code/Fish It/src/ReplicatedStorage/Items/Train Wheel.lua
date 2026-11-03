-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession() then 0.004 else 0.002
return {
	RecordData = true,
	TradeLocked = true,
	SellPrice = 0,
	Data = {
		Id = 540,
		Type = "Gears",
		Name = "Train Wheel",
		Description = "",
		Icon = "rbxassetid://100355026840614",
		Tier = 3
	},
	Variants = {},
	Weight = {
		Big = NumberRange.new(1, 1.25),
		Default = NumberRange.new(0.5, 0.75)
	},
	Probability = {
		Chance = v1
	},
	_moduleScript = script
}