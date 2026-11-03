-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Scientist Samantha has asked you to take a few measurements around Crater Island.",
	AssociatedTier = 0,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Take measurements at Crater Island",
			Goal = 15,
			Type = "TakeMeasurement",
			Requirements = {
				Location = "Crater Island"
			}
		},
		{
			Id = 2,
			Name = "Report the findings back to the Scientist",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Scientist Samantha",
				Path = 2,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Mutation I Potion", 1),
	NeededQuestItems = {
		{ "Gears", "Measurement Device", 1 }
	}
}