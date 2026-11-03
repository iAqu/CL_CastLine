-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession() then 5 else 1
return {
	Versions = 1,
	Colors = 4,
	SellMultiplier = 2.2,
	Data = {
		Id = 29,
		Type = "Variant",
		Name = "Fire",
		Description = "",
		Icon = "",
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 132, 24)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 117, 83)) })
	},
	Probability = {
		Chance = v1
	},
	Modifiers = {},
	_moduleScript = script
}