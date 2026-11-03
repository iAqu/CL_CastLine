-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Find all of Dead Skeleton\'s letters to recieve his secret treasure!",
	AssociatedTier = 5,
	NPC = "Dead Skeleton",
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Find 4 letters hidden in the Pirate Cove chests",
			Goal = 4,
			Type = "DeadSkeletonLetter"
		},
		{
			Id = 2,
			Name = "Return and speak with the Dead Skeleton",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Dead Skeleton",
				Path = 1,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Leviathan\'s Wrath")
}