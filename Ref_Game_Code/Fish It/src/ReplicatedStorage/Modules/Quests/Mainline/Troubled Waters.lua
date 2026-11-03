-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help the Sheriff!",
	NPC = "Sheriff",
	Objectives = {
		{
			Id = 1,
			Name = "Catch a Bandit Octopus",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Bandit Octopus",
			Requirements = {
				Fish = "Bandit Octopus"
			}
		},
		{
			Id = 2,
			Name = "Catch an Outlaw Seahorse",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Outlaw Seahorse",
			Requirements = {
				Fish = "Outlaw Seahorse"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Desert Cactus")
}