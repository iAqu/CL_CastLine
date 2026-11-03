-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Catch frogs to create an army!",
	AssociatedTier = 1,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 5 Frogs",
			Goal = 5,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Frog",
			Requirements = {
				Fish = "Frog"
			}
		},
		{
			Id = 2,
			Name = "Catch 1 King Frog",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "King Frog",
			Requirements = {
				Fish = "King Frog"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 5000)
}