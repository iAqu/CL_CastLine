-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Fish up the missing train wheels for the Christmas Express!",
	AssociatedTier = 4,
	Objectives = {
		{
			Goal = 4,
			Id = 1,
			Name = "Fish up 4 Train Wheel",
			Type = "Catch",
			AssociatedItem = "Train Wheel",
			AssociatedType = "Gears",
			QuestItem = true,
			Requirements = {
				Id = 540
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(1155.7, 19.267, 1552.413))
		}
	},
	Reward = RewardInfo.lanternReward("Gingerbread Lantern")
}