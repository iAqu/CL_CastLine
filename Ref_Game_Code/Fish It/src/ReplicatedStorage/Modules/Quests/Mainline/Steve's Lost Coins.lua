-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Scuba Steve lost his coins somewhere in the depths of the Lost Isle!",
	AssociatedTier = 4,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Find the missing stacks of coins",
			Goal = 10,
			Type = "Search",
			Requirements = {
				Object = "Coin"
			}
		},
		{
			Id = 2,
			Name = "Return the coins to Scuba Steve",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Scuba Steve",
				Path = 1,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 25000)
}