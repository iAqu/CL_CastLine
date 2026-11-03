-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help Forager Jen by collecting small mushrooms found on the ground in the Ancient Jungle!",
	AssociatedTier = 2,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Collect 30 mushrooms!",
			Goal = 30,
			Type = "Search",
			Requirements = {
				Object = "Mushroom"
			}
		},
		{
			Id = 2,
			Name = "Handover mushrooms to Forager Jen",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Forager Jen",
				Path = 1,
				Index = 3
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).lanternReward("Mushroom Lantern")
}