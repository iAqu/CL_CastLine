-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Special event pass! Earn Doubloons for limited time",
	AssociatedTier = 6,
	Expirable = true,
	ExpirationSettings = {
		Type = "Duration",
		Value = 14400
	},
	Objectives = {
		{
			Goal = 1,
			Id = 1,
			Name = "Catch a Mythic Fish",
			Type = "Catch",
			Requirements = {
				Tier = 6
			}
		}
	},
	Reward = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 2000)
}