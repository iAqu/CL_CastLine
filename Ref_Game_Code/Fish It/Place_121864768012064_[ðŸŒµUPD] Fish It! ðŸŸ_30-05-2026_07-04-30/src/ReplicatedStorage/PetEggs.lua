-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	["Cat Egg"] = {
		TradeLocked = true,
		HatchDurationSeconds = 900,
		SellPrice = 100,
		Data = {
			Id = 1,
			Type = "Pet Eggs",
			Name = "Cat Egg",
			Description = "Hatches into a starter pet.",
			Icon = "rbxassetid://92263422288773",
			Tier = 1
		},
		CurrencyCost = {
			Name = "Coins",
			Amount = 5000
		},
		Rolls = {
			{
				Weight = 1,
				RewardName = "Axolotl",
				RewardInfo = RewardInfo.petReward("Axolotl")
			}
		}
	},
	["Exclusive Egg"] = {
		TradeLocked = false,
		HatchDurationSeconds = 3600,
		VariantChance = 0.01,
		SellPrice = 500,
		Data = {
			Id = 2,
			Type = "Pet Eggs",
			Name = "Founders Exclusive Egg",
			Description = "Hatches into a founder pet.",
			Icon = "rbxassetid://92263422288773",
			Tier = 4
		},
		Rolls = {
			{
				Weight = 51,
				RewardName = "Otter",
				RewardInfo = RewardInfo.petReward("Otter")
			},
			{
				Weight = 20,
				RewardName = "Frog",
				RewardInfo = RewardInfo.petReward("Frog")
			},
			{
				Weight = 15,
				RewardName = "Cow",
				RewardInfo = RewardInfo.petReward("Cow")
			},
			{
				Weight = 8,
				RewardName = "Capybara",
				RewardInfo = RewardInfo.petReward("Capybara")
			},
			{
				Weight = 5,
				RewardName = "Penguin",
				RewardInfo = RewardInfo.petReward("Penguin")
			},
			{
				Weight = 1,
				RewardName = "Axolotl",
				RewardInfo = RewardInfo.petReward("Axolotl")
			}
		},
		Metadata = {
			Exclusive = true
		}
	}
}