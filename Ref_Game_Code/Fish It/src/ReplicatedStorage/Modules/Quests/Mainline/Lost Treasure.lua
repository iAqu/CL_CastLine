-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help him by finding and looting treasure chests underwater!",
	AssociatedTier = 4,
	NPC = "Capt Jack",
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Loot 5 Sunken Treasure Chests!",
			Goal = 5,
			Type = "LootTreasureChest"
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 40000)
}