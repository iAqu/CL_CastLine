-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Scientist Jameson has dumped the task of collecting samples around Kohana onto you... good luck!",
	AssociatedTier = 0,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Collect Samples around Kohana Island",
			Goal = 10,
			Type = "Search",
			Requirements = {
				Object = "Sample"
			}
		},
		{
			Id = 2,
			Name = "Return the samples to Scientist Jameson",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Scientist Jameson",
				Path = 2,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck I Potion", 1)
}