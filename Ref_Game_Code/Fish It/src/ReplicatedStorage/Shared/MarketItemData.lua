-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.ItemUtility)
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Id = 1,
		Type = "Fishing Rods",
		Identifier = "Fluorescent Rod",
		Price = 685000,
		Currency = "Coins",
		SingleCopy = true,
		CurrencyRewardInfo = RewardInfo.fishingRodReward("Fluorescent Rod")
	},
	{
		Id = 2,
		Type = "Fishing Rods",
		Identifier = "Hazmat Rod",
		Price = 1380000,
		Currency = "Coins",
		SingleCopy = true,
		CurrencyRewardInfo = RewardInfo.fishingRodReward("Hazmat Rod")
	},
	{
		Id = 3,
		Type = "Baits",
		Identifier = "Singularity Bait",
		Price = 8200000,
		Currency = "Coins",
		SingleCopy = true,
		CurrencyRewardInfo = RewardInfo.baitReward("Singularity Bait")
	},
	{
		Id = 4,
		Type = "Baits",
		Identifier = "Royal Bait",
		Price = 425000,
		Currency = "Coins",
		SingleCopy = true,
		CurrencyRewardInfo = RewardInfo.baitReward("Royal Bait")
	},
	{
		Id = 5,
		Type = "Totems",
		Identifier = "Luck Totem",
		Price = 650000,
		Currency = "Coins",
		CurrencyRewardInfo = RewardInfo.totemReward("Luck Totem", 1)
	},
	{
		Id = 6,
		DisplayName = "Mystery Crate",
		Type = "Crate",
		Identifier = "Mystery Crate",
		Currency = "Robux",
		SkinCrate = true
	},
	{
		Id = 7,
		Type = "Totems",
		Identifier = "Shiny Totem",
		Price = 400000,
		Currency = "Coins",
		CurrencyRewardInfo = RewardInfo.totemReward("Shiny Totem", 1)
	},
	{
		Id = 8,
		Type = "Totems",
		Identifier = "Mutation Totem",
		Price = 800000,
		Currency = "Coins",
		CurrencyRewardInfo = RewardInfo.totemReward("Mutation Totem", 1)
	}
}