-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Help the Hank find his sunken diary in exchange for a Pickaxe!",
	AssociatedTier = 4,
	NPC = "Hank",
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Fish up Hank\'s Diary",
			Goal = 1,
			Type = "Catch",
			Reconcile = true,
			AssociatedItem = "Hank\'s Diary",
			AssociatedType = "Gears",
			QuestItem = true,
			Requirements = {
				Id = 20222
			}
		},
		{
			Id = 2,
			Name = "Return the Diary to Hank",
			Goal = 1,
			Type = "Exchange",
			Requirements = {
				Id = 20222
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).itemReward("Pickaxe", 1)
}