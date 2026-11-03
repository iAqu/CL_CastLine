-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help Lary the Scientist complete his research to receive the Diamond Rod",
	AssociatedTier = 7,
	Objectives = {
		{
			Id = 1,
			Name = "Own an Element Rod",
			Goal = 1,
			Type = "ElementRodOwner",
			Reconcile = true,
			AssociatedItem = "Element Rod",
			AssociatedType = "Fishing Rods"
		},
		{
			Id = 2,
			Name = "Catch a SECRET fish at Coral Reefs",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Tier = 7,
				Location = "Coral Reefs"
			}
		},
		{
			Id = 3,
			Name = "Catch a SECRET fish at Tropical Grove",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Tier = 7,
				Location = "Tropical Grove"
			}
		},
		{
			Id = 4,
			Name = "Bring Lary a mutated Gemstone Ruby",
			Goal = 1,
			Type = "Exchange",
			AssociatedItem = "Ruby",
			AssociatedType = "Fish",
			Requirements = {
				Id = 243,
				Metadata = {
					VariantId = 3
				}
			}
		},
		{
			Id = 5,
			Name = "Bring Lary a Lochness Monster",
			Goal = 1,
			Type = "Exchange",
			AssociatedItem = "Lochness Monster",
			AssociatedType = "Fish",
			Requirements = {
				Id = 228
			}
		},
		{
			Id = 6,
			Name = "Catch 1,000 fish while using PERFECT! throw",
			Goal = 1000,
			Type = "Catch",
			Requirements = {
				EffectIndex = 5
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).itemReward("Diamond Key")
}