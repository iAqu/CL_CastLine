-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Special event pass! Earn Doubloons for limited time",
	AssociatedTier = 4,
	Expirable = true,
	ExpirationSettings = {
		Type = "Duration",
		Value = 14400
	},
	Objectives = {
		{
			Goal = 2,
			Id = 1,
			Name = "Catch 1 Treasure Crab",
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Treasure Crab",
			Requirements = {
				Fish = "Treasure Crab"
			}
		}
	},
	Reward = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 1200)
}