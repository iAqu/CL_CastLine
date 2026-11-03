-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Collect Corals for Dorian",
	AssociatedTier = 2,
	NPC = "Dorian",
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Collect 30 corals!",
			Goal = 30,
			Type = "Search",
			Requirements = {
				Object = "Coral"
			}
		},
		{
			Id = 2,
			Name = "Handover corals to Dorian",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Dorian",
				Path = 1,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).lanternReward("Coral Lantern")
}