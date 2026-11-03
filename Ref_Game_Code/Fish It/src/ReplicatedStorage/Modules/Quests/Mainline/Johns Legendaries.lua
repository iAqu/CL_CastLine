-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "John needs you to catch 10 Legendaries on Classic Island",
	AssociatedTier = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 10 Legendaries at Classic Island!",
			Goal = 10,
			Type = "Catch",
			Requirements = {
				Tier = 5,
				Location = "Classic Island"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Noobed")
}