-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Conquering the depths ocean was never enough of a task",
	AssociatedTier = 7,
	Objectives = {
		{
			Id = 1,
			Name = "Own Ghostfinn Rod",
			Goal = 1,
			Type = "GhostfinnRodOwner",
			Reconcile = true,
			AssociatedItem = "Ghostfinn Rod",
			AssociatedType = "Fishing Rods"
		},
		{
			Id = 2,
			Name = "Catch 1 SECRET fish at Ancient Jungle",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Tier = 7,
				Location = "Ancient Jungle"
			}
		},
		{
			Id = 3,
			Name = "Catch 1 SECRET fish at Sacred Temple",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Tier = 7,
				Location = "Sacred Temple"
			}
		},
		{
			Id = 4,
			Name = "Create 3 Transcended Stones",
			Goal = 3,
			Type = "CreateTranscendedStone",
			AssociatedItem = "Transcended Stone",
			AssociatedType = "Enchant Stones",
			TrackQuestCFrame = CFrame.new(Vector3.new(1491.477, 127.5, -593.159))
		}
	},
	Reward = RewardInfo.fishingRodReward("Element Rod")
}