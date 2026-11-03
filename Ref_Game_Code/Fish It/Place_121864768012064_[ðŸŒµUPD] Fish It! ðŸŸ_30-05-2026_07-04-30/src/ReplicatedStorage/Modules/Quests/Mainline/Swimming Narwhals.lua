-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help Narwhal get some food and find a friend!",
	AssociatedTier = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 150 fish!",
			Goal = 150,
			Type = "Catch",
			AssociatedType = "Fish"
		},
		{
			Id = 2,
			Name = "Fish up 1 Narwhal!",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedFish = "Narwhal",
			Requirements = {
				Fish = "Narwhal"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).enchantStoneReward("Enchant Stone", 3)
}