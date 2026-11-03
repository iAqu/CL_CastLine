-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Travel the Seas in search for the infamous Black Pearl Ship",
	AssociatedTier = 6,
	Objectives = {
		{
			Id = 1,
			Name = "Give Captain Jones a Leviathan Rage mutated fish",
			Goal = 1,
			Type = "Exchange",
			Requirements = {
				Metadata = {
					VariantId = 23
				}
			}
		},
		{
			Id = 2,
			Name = "Find the SECRET Dead Man\'s Compass",
			Goal = 1,
			Type = "Search",
			Requirements = {
				Object = "DeadManCompass"
			}
		},
		{
			Id = 3,
			Name = "Return to the Captain",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Captain Jones",
				Path = 3,
				Index = 2
			}
		},
		{
			Id = 4,
			Name = "Bring Captain a Cursed Kraken",
			Goal = 1,
			Type = "Exchange",
			AssociatedItem = "Cursed Kraken",
			AssociatedType = "Fish",
			Requirements = {
				Id = 589
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).boatReward("Colossal Pirate Ship")
}