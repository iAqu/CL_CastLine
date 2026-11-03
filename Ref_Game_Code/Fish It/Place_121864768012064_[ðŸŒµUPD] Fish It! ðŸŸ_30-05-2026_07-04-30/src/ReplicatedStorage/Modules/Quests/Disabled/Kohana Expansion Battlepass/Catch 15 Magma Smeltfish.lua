-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 15,
			Id = 1,
			Name = "Catch 15 Magma Smeltfish!",
			Type = "Catch",
			Requirements = {
				Fish = "Magma Smeltfish"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 10000)
}