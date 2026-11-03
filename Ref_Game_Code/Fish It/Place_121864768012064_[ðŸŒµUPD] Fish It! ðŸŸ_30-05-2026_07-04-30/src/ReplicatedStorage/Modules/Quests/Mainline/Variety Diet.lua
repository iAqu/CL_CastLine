-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "If you\'re bad with heat, do not eat the fish here!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 12 fish with any mutation",
			Goal = 12,
			Type = "Catch",
			Requirements = {
				HasVariant = true
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Mutation I Potion", 4)
}