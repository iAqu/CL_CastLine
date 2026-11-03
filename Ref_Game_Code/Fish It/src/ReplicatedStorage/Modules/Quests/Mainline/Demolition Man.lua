-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Clear the fallen rocks blocking the cave at Pirate Cove Island",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Find a stack TNT explosives",
			Goal = 3,
			Type = "Search",
			Requirements = {
				Object = "TNT"
			}
		},
		{
			Id = 2,
			Name = "Give the TNT to the Carpenter",
			Goal = 1,
			Type = "SpeakWithNPC",
			GoalNPC = "Carpenter",
			Requirements = {
				NPC = "Carpenter",
				Path = 1,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck II Potion", 2)
}