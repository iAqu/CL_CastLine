-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Bring Chavez the ingredients hes listed and he\'ll craft a rod using them!",
	AssociatedTier = 3,
	Objectives = {
		{
			Id = 1,
			Name = "Hand over a Lettuce",
			Goal = 1,
			Type = "Exchange",
			QuestItem = true,
			AssociatedType = "Fish",
			AssociatedItem = "Lettuce",
			AreaRestriction = "Classic Cave",
			Requirements = {
				Id = 917
			}
		},
		{
			Id = 2,
			Name = "Hand over a Tomato",
			Goal = 1,
			Type = "Exchange",
			QuestItem = true,
			AssociatedType = "Fish",
			AssociatedItem = "Tomato",
			AreaRestriction = "Classic Cave",
			Requirements = {
				Id = 915
			}
		},
		{
			Id = 3,
			Name = "Hand over a Tortilla",
			Goal = 1,
			Type = "Exchange",
			QuestItem = true,
			AssociatedType = "Fish",
			AssociatedItem = "Tortilla",
			AreaRestriction = "Classic Cave",
			Requirements = {
				Id = 916
			}
		},
		{
			Id = 4,
			Name = "Hand over a Taco Fish",
			Goal = 1,
			Type = "Exchange",
			AssociatedType = "Fish",
			AssociatedItem = "Taco Fish",
			Requirements = {
				Id = 905
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Taco Tuesday")
}