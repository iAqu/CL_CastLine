-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help the pizza man!",
	NPC = "Pizza Man",
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Fish out 8 Pizza Slices",
			Goal = 8,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Pizza Slice",
			QuestItem = true,
			Requirements = {
				Fish = "Pizza Slice"
			}
		},
		{
			Id = 2,
			Name = "Place the 8 slices in the box",
			Goal = 1,
			Type = "PizzaSlice"
		},
		{
			Id = 3,
			Name = "Return the slices to the pizza man",
			Goal = 1,
			Type = "SpeakWithNPC",
			GoalNPC = "Pizza Man",
			Requirements = {
				NPC = "Pizza Man",
				Path = 1,
				Index = 3
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Pizzeria Rod")
}