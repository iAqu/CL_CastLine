-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 5,
			Id = 1,
			Name = "Catch 5 Magma Pufferfish!",
			Type = "Catch",
			Requirements = {
				Fish = "Magma Pufferfish"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).baitReward("Volcanic Bobber")
}