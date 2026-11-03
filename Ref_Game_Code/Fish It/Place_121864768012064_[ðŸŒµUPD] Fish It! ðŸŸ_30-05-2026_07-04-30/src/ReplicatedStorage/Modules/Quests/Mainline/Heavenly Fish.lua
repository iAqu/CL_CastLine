-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "The taste of these fish is heavenly!",
	AssociatedTier = 1,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 10 Bandit Angelfish",
			Goal = 10,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Bandit Angelfish",
			Requirements = {
				Fish = "Bandit Angelfish"
			}
		},
		{
			Id = 2,
			Name = "Catch 5 Flame Angelfish",
			Goal = 5,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Flame Angelfish",
			Requirements = {
				Fish = "Flame Angelfish"
			}
		},
		{
			Id = 3,
			Name = "Catch 1 Korean Angelfish",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Korean Angelfish",
			Requirements = {
				Fish = "Korean Angelfish"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 3000)
}