-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	BattlepassId = "PiratesCoveEvent",
	CurrencyName = "",
	BPItems = {
		{
			Cost = 250,
			CurrencyRewardInfo = RewardInfo.currencyReward("Coins", 1000)
		},
		{
			Cost = 400,
			CurrencyRewardInfo = RewardInfo.potionReward("Luck I Potion", 3)
		},
		{
			Cost = 1000,
			CurrencyRewardInfo = RewardInfo.fishingRodReward("Rocky Prism")
		},
		{
			Cost = 2500,
			CurrencyRewardInfo = RewardInfo.itemReward("Enchant Stone", 1)
		},
		{
			Cost = 4000,
			CurrencyRewardInfo = RewardInfo.potionReward("Luck II Potion", 2)
		},
		{
			Cost = 6500,
			CurrencyRewardInfo = RewardInfo.potionReward("Mutation I Potion", 1)
		},
		{
			Cost = 8000,
			CurrencyRewardInfo = RewardInfo.currencyReward("Coins", 5000)
		},
		{
			Cost = 10000,
			CurrencyRewardInfo = RewardInfo.itemReward("Enchant Stone", 1)
		},
		{
			Cost = 12500,
			CurrencyRewardInfo = RewardInfo.potionReward("Mutation I Potion", 1)
		},
		{
			Cost = 18000,
			CurrencyRewardInfo = RewardInfo.potionReward("Luck II Potion", 3)
		},
		{
			Cost = 30000,
			CurrencyRewardInfo = RewardInfo.baitReward("Hooke\'s Bait")
		},
		{
			Cost = 42000,
			CurrencyRewardInfo = RewardInfo.potionReward("Mutation I Potion", 2)
		},
		{
			Cost = 48000,
			CurrencyRewardInfo = RewardInfo.potionReward("Luck II Potion", 2)
		},
		{
			Cost = 50000,
			CurrencyRewardInfo = RewardInfo.itemReward("2026 Pirates Plaque", 1)
		},
		{
			Cost = 54000,
			CurrencyRewardInfo = RewardInfo.fishingRodReward("Sea Wisp")
		},
		{
			Cost = 58000,
			CurrencyRewardInfo = RewardInfo.boatReward("Banana Pirate Raft")
		}
	}
}