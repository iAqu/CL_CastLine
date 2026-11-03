-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession() then 0.001 else 0.0005
return {
	RecordData = true,
	TradeLocked = true,
	SellPrice = 0,
	Data = {
		Id = 267,
		Type = "Gears",
		Name = "Diamond Artifact",
		Description = "",
		Icon = "rbxassetid://72233825405890",
		Tier = 4
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