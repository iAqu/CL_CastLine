-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help The Scientist gather subjects for a new experiment...",
	AssociatedTier = 1,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 1 Darwin Clownfish",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Fish = "Darwin Clownfish"
			}
		},
		{
			Id = 2,
			Name = "Catch 1 Barracuda Fish",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Fish = "Barracuda Fish"
			}
		},
		{
			Id = 3,
			Name = "Catch 1 Dogfish",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Fish = "Dogfish"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck II Potion", 1)
}