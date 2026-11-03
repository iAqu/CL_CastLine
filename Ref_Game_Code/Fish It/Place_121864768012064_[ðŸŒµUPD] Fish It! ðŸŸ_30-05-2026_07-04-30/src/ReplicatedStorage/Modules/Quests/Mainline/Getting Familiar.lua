-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Look around and explore the area, find a NPC to speak to!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Find an NPC at the docks and speak to them!",
			Goal = 1,
			Type = "SpeakWithNPC"
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 2500)
}