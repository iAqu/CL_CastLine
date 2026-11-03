-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Scuba Steve lost something else, his keys, but this time they\'re in the Tropical Grove!",
	AssociatedTier = 4,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Visit the Tropical Grove",
			Goal = 1,
			Type = "VisitLocation",
			Requirements = {
				Location = "Tropical Grove"
			}
		},
		{
			Id = 2,
			Name = "Find Steve\'s boat keys",
			Goal = 1,
			Type = "Search",
			Requirements = {
				Object = "StevesBoatKey"
			}
		},
		{
			Id = 3,
			Name = "Return the coins to Scuba Steve",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Scuba Steve",
				Path = 1,
				Index = 4
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).potionReward("Luck II Potion", 2)
}