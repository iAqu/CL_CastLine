-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Aura farm your way into the sunset with this Indonesian legend",
	AssociatedTier = 6,
	Objectives = {
		{
			Id = 1,
			Name = "Catch a SECRET Crystal Crab",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Crystal Crab",
			Requirements = {
				Tier = 7,
				Fish = "Crystal Crab"
			}
		},
		{
			Id = 2,
			Name = "Catch 100 Epic fish",
			Goal = 100,
			Type = "Catch",
			Requirements = {
				Tier = 4
			}
		},
		{
			Id = 3,
			Name = "Catch 10,000 fish",
			Goal = 10000,
			Type = "Catch"
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).boatReward("Aura Boat")
}