-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help the Hazmat Leader find more Magma and Lava fish!",
	AssociatedTier = 0,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 1,000 Magma/Lava fish",
			Goal = 1000,
			Type = "Catch",
			Requirements = {
				IsMagma = true
			}
		},
		{
			Id = 2,
			Name = "Earn 2M Coins",
			Goal = 2000000,
			Type = "EarnedCoins"
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).itemReward("Hazmat Suit", 1)
}