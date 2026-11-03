-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "The Carpenter needs TNT to blow up the entrance to a cave!",
	AssociatedTier = 4,
	NPC = "Carpenter",
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Collect 4 TNT",
			Goal = 4,
			Type = "Search",
			Requirements = {
				Object = "TNT"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Doubloons", 50)
}