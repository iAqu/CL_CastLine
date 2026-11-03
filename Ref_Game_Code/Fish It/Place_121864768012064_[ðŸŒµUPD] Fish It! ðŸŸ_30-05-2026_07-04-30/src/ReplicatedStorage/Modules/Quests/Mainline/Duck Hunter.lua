-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Catch 10 Rubber Duckies for a special rod skin!",
	AssociatedTier = 1,
	NPC = "Duck Boy",
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 10 Rubber Ducky",
			Goal = 10,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Rubber Ducky",
			Requirements = {
				Fish = "Rubber Ducky"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Ducky Paradise")
}