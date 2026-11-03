-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Special event pass! Earn Doubloons for limited time",
	AssociatedTier = 3,
	Expirable = true,
	ExpirationSettings = {
		Type = "Duration",
		Value = 14400
	},
	Objectives = {
		{
			Goal = 3,
			Id = 1,
			Name = "Catch 3 Pirate Dreadfin",
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Pirate Dreadfin",
			Requirements = {
				Fish = "Pirate Dreadfin"
			}
		}
	},
	Reward = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 800)
}