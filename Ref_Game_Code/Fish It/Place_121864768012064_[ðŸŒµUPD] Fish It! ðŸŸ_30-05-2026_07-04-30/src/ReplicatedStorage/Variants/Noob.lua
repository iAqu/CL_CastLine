-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession() then 10 else 1
return {
	Versions = 1,
	Colors = 4,
	SellMultiplier = 2.2,
	Data = {
		Id = 21,
		Type = "Variant",
		Name = "Noob",
		Description = "",
		Icon = "",
		TierColor = ColorSequence.new(Color3.fromRGB(255, 224, 47))
	},
	Probability = {
		Chance = v1
	},
	Modifiers = {},
	_moduleScript = script
}