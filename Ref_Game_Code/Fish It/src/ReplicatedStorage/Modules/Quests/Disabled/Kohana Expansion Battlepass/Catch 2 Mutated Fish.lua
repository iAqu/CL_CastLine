-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 2,
			Id = 1,
			Name = "Catch 2 mutated fish!",
			Type = "Catch",
			Requirements = {
				HasVariant = true
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Mutation I Potion", 5)
}