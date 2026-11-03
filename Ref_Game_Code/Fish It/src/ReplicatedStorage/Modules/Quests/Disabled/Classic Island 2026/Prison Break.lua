-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Place an the item near the Prison Guard to distract him to help the prisoner escape!",
	AssociatedTier = 1,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Goal = 1,
			Name = "Place a Prisoner Fish",
			Type = "PlaceItem",
			AssociatedType = "Fish",
			AssociatedItem = "Prisoner Fish",
			Requirements = {
				Id = 939
			}
		},
		{
			Id = 2,
			Goal = 1,
			Name = "Return to the Prisoner",
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Prisoner",
				Path = 1,
				Index = 2
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).lanternReward("Retro Police Car")
}