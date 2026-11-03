-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Ram needs help proving hes the best fisherman in Coral Reefs! Help him by catching BIG fish!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 8 Big fish!",
			Goal = 8,
			Type = "Catch",
			Requirements = {
				Big = true
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck I Potion", 2)
}