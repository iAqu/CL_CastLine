-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "If you\'re bad with heat, do not eat the fish here!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 20 Lava Butterfly",
			Goal = 20,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Lava Butterfly",
			Requirements = {
				Fish = "Lava Butterfly"
			}
		},
		{
			Id = 2,
			Name = "Catch 5 Magma Goby",
			Goal = 5,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Magma Goby",
			Requirements = {
				Fish = "Magma Goby"
			}
		},
		{
			Id = 3,
			Name = "Catch 1 Lavafin Tuna",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Lavafin Tuna",
			Requirements = {
				Fish = "Lavafin Tuna"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck I Potion", 3)
}