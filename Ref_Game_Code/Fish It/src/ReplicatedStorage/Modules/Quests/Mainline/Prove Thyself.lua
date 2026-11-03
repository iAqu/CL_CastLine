-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Prove to Sam you have what it takes to be on his level!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 3 Epic fish",
			Goal = 3,
			Type = "Catch",
			Requirements = {
				Tier = 4
			}
		},
		{
			Id = 2,
			Name = "Catch 1 Pink Dolphin",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Pink Dolphin",
			Requirements = {
				Fish = "Pink Dolphin"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 25000)
}