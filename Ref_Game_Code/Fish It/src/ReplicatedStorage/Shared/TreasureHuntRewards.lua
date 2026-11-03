-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Common = {
		{
			Type = "Coins",
			Weight = 20,
			RewardData = {
				Notification = "You got 1k Coins!",
				Info = RewardInfo.currencyReward("Coins", 1000)
			}
		},
		{
			Type = "Coins",
			Weight = 19.05,
			RewardData = {
				Notification = "You got 2k Coins!",
				Info = RewardInfo.currencyReward("Coins", 2000)
			}
		},
		{
			Type = "Coins",
			Weight = 15,
			RewardData = {
				Notification = "You got 3k Coins!",
				Info = RewardInfo.currencyReward("Coins", 3000)
			}
		},
		{
			Type = "Coins",
			Weight = 15,
			RewardData = {
				Notification = "You got 4k Coins!",
				Info = RewardInfo.currencyReward("Coins", 4000)
			}
		},
		{
			Id = 3,
			Type = "Lanterns",
			Weight = 15,
			RewardData = {
				Notification = "You got a Soul Lantern!",
				Info = RewardInfo.lanternReward("Soul Lantern", 1)
			}
		},
		{
			Id = 10,
			Type = "Enchant Stones",
			Weight = 10,
			RewardData = {
				Notification = "You got an Enchant Stone!",
				Info = RewardInfo.enchantStoneReward("Enchant Stone", 1)
			}
		},
		{
			Id = 1,
			Amount = 1,
			Type = "Potion",
			Weight = 0.5,
			RewardData = {
				Notification = "You got a Luck I Potion!",
				Info = RewardInfo.potionReward("Luck I Potion", 1)
			}
		},
		{
			Id = 397,
			Type = "Fishing Rods",
			Weight = 0.05,
			RewardData = {
				Notification = "You got the Dark Seahorse!",
				Info = RewardInfo.fishingRodReward("Dark Seahorse", 1)
			}
		}
	},
	Rare = {
		{
			Type = "Coins",
			Weight = 35,
			RewardData = {
				Notification = "You got 5k Coins!",
				Info = RewardInfo.currencyReward("Coins", 5000)
			}
		},
		{
			Type = "Coins",
			Weight = 30,
			RewardData = {
				Notification = "You got 10k Coins!",
				Info = RewardInfo.currencyReward("Coins", 10000)
			}
		},
		{
			Id = 4,
			Type = "Potion",
			Weight = 15,
			RewardData = {
				Notification = "You got a Mutation I Potion!",
				Info = RewardInfo.potionReward("Mutation I Potion", 1)
			}
		},
		{
			Id = 3,
			Type = "Lanterns",
			Weight = 15,
			RewardData = {
				Notification = "You got a Soul Lantern!",
				Info = RewardInfo.lanternReward("Soul Lantern", 1)
			}
		},
		{
			Id = 6,
			Type = "Potion",
			Weight = 9.79,
			RewardData = {
				Notification = "You got a Luck II Potion!",
				Info = RewardInfo.potionReward("Luck II Potion", 1)
			}
		},
		{
			Id = 397,
			Type = "Fishing Rods",
			Weight = 0.2,
			RewardData = {
				Notification = "You got the Dark Seahorse!",
				Info = RewardInfo.fishingRodReward("Dark Seahorse", 1)
			}
		},
		{
			Id = 125,
			Type = "Enchant Stones",
			Weight = 0.01,
			RewardData = {
				Notification = "You got a Super Enchant Stone!",
				Info = RewardInfo.enchantStoneReward("Super Enchant Stone", 1)
			}
		}
	}
}