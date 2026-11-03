-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 10,
			Id = 1,
			Name = "Fish up 10 shells!",
			Type = "Catch",
			Requirements = {
				IsShell = true
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).charmReward("Clover Charm", 3)
}