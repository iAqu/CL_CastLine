-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Special event pass! Earn Doubloons for limited time",
	AssociatedTier = 5,
	Expirable = true,
	ExpirationSettings = {
		Type = "Duration",
		Value = 14400
	},
	Objectives = {
		{
			Goal = 2,
			Id = 1,
			Name = "Catch 2 Legendary Fish",
			Type = "Catch",
			Requirements = {
				Tier = 5
			}
		}
	},
	Reward = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 1200)
}