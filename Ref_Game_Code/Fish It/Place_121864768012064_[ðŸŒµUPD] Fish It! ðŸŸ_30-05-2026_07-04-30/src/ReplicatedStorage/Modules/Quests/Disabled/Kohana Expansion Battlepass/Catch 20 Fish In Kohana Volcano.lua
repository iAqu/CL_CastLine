-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 20,
			Id = 1,
			Name = "Catch 20 fish in Kohana Volcano!",
			Type = "Catch",
			Requirements = {
				Location = "Kohana Volcano"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck I Potion", 2)
}