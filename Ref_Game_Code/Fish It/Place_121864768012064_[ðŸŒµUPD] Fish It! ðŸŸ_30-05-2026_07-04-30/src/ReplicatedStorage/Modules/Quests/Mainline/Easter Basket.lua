-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help the bunny!",
	AssociatedTier = 1,
	RemoveItemOnComplete = "Easter Basket",
	NPC = "Rabbit",
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Find 5 carrots",
			Goal = 5,
			Type = "Search",
			Requirements = {
				Object = "Carrot"
			}
		},
		{
			Id = 2,
			Name = "Give the basket of carrots to the Rabbit",
			Goal = 1,
			Type = "SpeakWithNPC",
			GoalNPC = "Rabbit",
			Requirements = {
				NPC = "Rabbit",
				Path = 1,
				Index = 2
			}
		}
	},
	NeededQuestItems = {
		{ "Gears", "Easter Basket", 1 }
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Reinforced Carrot")
}