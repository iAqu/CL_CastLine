-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Scientist Samantha forgot her measurement device, bring it to her to learn more about the mysterious lab.",
	AssociatedTier = 0,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Grab Scientist Samantha\'s tool",
			Goal = 1,
			Type = "Search",
			Requirements = {
				Object = "SamsTool"
			}
		},
		{
			Id = 2,
			Name = "Go to Crater Island",
			Goal = 1,
			Type = "VisitLocation",
			Requirements = {
				Location = "Crater Island"
			}
		},
		{
			Id = 3,
			Name = "Give the tool to Scientist Samantha",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Scientist Samantha",
				Path = 1,
				Index = 1
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 15000)
}