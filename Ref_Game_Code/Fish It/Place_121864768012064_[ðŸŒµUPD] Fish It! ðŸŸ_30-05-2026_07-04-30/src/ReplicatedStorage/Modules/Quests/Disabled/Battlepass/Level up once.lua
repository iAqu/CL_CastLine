-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Special event pass! Earn Doubloons for limited time",
	AssociatedTier = 2,
	Expirable = true,
	ExpirationSettings = {
		Type = "Duration",
		Value = 14400
	},
	Objectives = {
		{
			Goal = 1,
			Id = 1,
			Name = "Level up once",
			Type = "LevelUp"
		}
	},
	Reward = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 400)
}