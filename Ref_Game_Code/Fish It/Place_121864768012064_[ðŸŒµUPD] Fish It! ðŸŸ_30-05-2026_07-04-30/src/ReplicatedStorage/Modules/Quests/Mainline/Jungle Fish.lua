-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help Astrid by catching a bunch of fish",
	AssociatedTier = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 100 fish",
			Goal = 100,
			Type = "Catch"
		},
		{
			Id = 2,
			Name = "Catch 10 Epic fish",
			Goal = 10,
			Type = "Catch",
			Requirements = {
				Tier = 4
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck I Potion", 3)
}