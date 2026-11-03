-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help the Outlaws!",
	NPC = "Outlaw",
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Goal = 3,
			Name = "Catch a few supply barrels!",
			Type = "Catch",
			QuestItem = true,
			AssociatedType = "Fish",
			AssociatedItem = "Supply Barrel",
			Requirements = {
				Fish = "Supply Barrel"
			}
		},
		{
			Id = 2,
			Goal = 1,
			Name = "Return to the outlaw",
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Outlaw",
				Path = 1,
				Index = 3
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).baitReward(61)
}