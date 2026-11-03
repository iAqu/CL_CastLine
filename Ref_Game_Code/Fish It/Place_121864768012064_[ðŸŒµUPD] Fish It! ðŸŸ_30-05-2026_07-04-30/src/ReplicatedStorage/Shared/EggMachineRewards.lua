-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Weight = 40,
		RewardName = "50 Easter Coins",
		RewardInfo = RewardInfo.currencyReward("Easter Coins", 50)
	},
	{
		Weight = 38,
		RewardName = "Carrot I Potion",
		RewardInfo = RewardInfo.potionReward("Carrot I Potion", 1)
	},
	{
		Weight = 33,
		RewardName = "Easter I Potion",
		RewardInfo = RewardInfo.potionReward("Easter I Potion", 1)
	},
	{
		Weight = 16,
		RewardName = "Luck I Potion 2x",
		RewardInfo = RewardInfo.potionReward("Luck I Potion", 2)
	},
	{
		Weight = 4,
		RewardName = "Meadow Spring Lantern",
		Unique = true,
		RewardInfo = RewardInfo.lanternReward("Meadow Spring Lantern")
	},
	{
		Weight = 4,
		RewardName = "Carrot Bait",
		Unique = true,
		RewardInfo = RewardInfo.baitReward("Carrot Bait")
	},
	{
		Weight = 3,
		RewardName = "Golden Egg Bait",
		Unique = true,
		RewardInfo = RewardInfo.baitReward("Gold Egg Bait")
	},
	{
		Weight = 2,
		RewardName = "Bunny Halo",
		Unique = true,
		RewardInfo = RewardInfo.haloReward("Bunny Halo")
	}
}