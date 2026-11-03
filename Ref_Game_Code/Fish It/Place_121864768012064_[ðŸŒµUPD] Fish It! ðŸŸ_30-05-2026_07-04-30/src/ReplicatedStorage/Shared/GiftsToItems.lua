-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Rewards = {
		{
			RewardData = {
				Notification = "You got 250 Candy Canes!",
				K = false,
				Reward = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 250)
			}
		},
		{
			RewardData = {
				Notification = "You got a Mutation I Potion!",
				Reward = RewardInfo.potionReward("Mutation I Potion", 1)
			}
		},
		{
			RewardData = {
				Notification = "You got a Luck I Potion!",
				Reward = RewardInfo.potionReward("Luck I Potion", 1)
			}
		},
		{
			RewardData = {
				Notification = "You got a Frozen Bait!",
				Reward = RewardInfo.baitReward("Frozen Bait")
			}
		},
		{
			RewardData = {
				Notification = "You got an Snowglobe Lantern!",
				Reward = RewardInfo.lanternReward("Snowglobe Lantern")
			}
		},
		{
			RewardData = {
				Notification = "You got the Candy Cane Rod!",
				Reward = RewardInfo.fishingRodReward("Candy Cane Rod")
			}
		},
		{
			RewardData = {
				Notification = "You got the Peppermint Jetski!",
				Reward = RewardInfo.boatReward("Peppermint Jetski")
			}
		}
	},
	Weights = {
		{ 60, 25, 10, 3, 1.5, 0.5 },
		{ 50, 25, 13, 7, 3.5, 1.5 },
		{ 40, 24, 16, 12, 6, 2 },
		{ 32, 22, 18, 12, 10, 4, 1 }
	}
}