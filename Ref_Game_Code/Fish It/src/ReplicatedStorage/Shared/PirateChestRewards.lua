-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Common = {
		{
			Type = "Coins",
			Weight = 45,
			RewardData = {
				Notification = "You got 10 Doubloons!",
				Info = RewardInfo.currencyReward("Doubloons", 10)
			}
		},
		{
			Type = "Coins",
			Weight = 35,
			RewardData = {
				Notification = "You got 20 Doubloons!",
				Info = RewardInfo.currencyReward("Doubloons", 20)
			}
		},
		{
			Type = "Potion",
			Weight = 12,
			RewardData = {
				Notification = "You got 1 Luck I Potion!",
				Info = RewardInfo.potionReward("Luck I Potion", 1)
			}
		},
		{
			Type = "Potion",
			Weight = 9,
			RewardData = {
				Notification = "You got 1 Mutation I Potion!",
				Info = RewardInfo.potionReward("Mutation I Potion", 1)
			}
		},
		{
			Type = "Bait",
			Weight = 4,
			RewardData = {
				Notification = "You got the Doubloon Bobber skin!",
				Info = RewardInfo.baitReward("Pirate Doubloon")
			}
		}
	}
}