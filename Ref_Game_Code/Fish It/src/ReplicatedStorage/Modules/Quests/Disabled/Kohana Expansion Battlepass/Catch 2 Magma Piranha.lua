-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Limited Time Kohana Event!",
	AssociatedTier = 1,
	Expirable = false,
	Objectives = {
		{
			Goal = 2,
			Id = 1,
			Name = "Catch 2 Magma Piranha",
			Type = "Catch",
			Requirements = {
				Fish = "Magma Piranha"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).lanternReward("Magma Lantern")
}