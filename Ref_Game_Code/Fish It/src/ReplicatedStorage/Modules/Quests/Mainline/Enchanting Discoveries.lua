-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Practice your enchanting to receive a cool reward!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Use an Enchant Stone 30 times",
			Goal = 30,
			Type = "UseEnchantStone",
			AssociatedType = "Item",
			AssociatedItem = "Enchant Stone"
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).enchantStoneReward("Super Enchant Stone", 1)
}