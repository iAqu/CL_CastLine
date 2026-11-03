-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 1,
			Id = 1,
			Name = "Complete a Epic Bounty!",
			Type = "Bounty",
			Requirements = {
				Tier = 4
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Magmahook")
}