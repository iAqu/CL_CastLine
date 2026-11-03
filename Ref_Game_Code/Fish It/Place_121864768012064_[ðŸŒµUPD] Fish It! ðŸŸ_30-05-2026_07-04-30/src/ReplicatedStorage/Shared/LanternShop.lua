-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Price = 1000,
		SinglePurchase = true,
		RewardInfo = RewardInfo.lanternReward("Adventure Lantern")
	},
	{
		Price = 30000,
		SinglePurchase = true,
		RewardInfo = RewardInfo.lanternReward("Hourglass Lantern")
	},
	{
		Price = 55000,
		SinglePurchase = true,
		RewardInfo = RewardInfo.lanternReward("Fairy Lantern")
	},
	{
		Price = 100000,
		SinglePurchase = true,
		RewardInfo = RewardInfo.lanternReward("Crystal Fruit Lantern")
	}
}