-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Merry Christmas! Complete this list of quests for an awesome reward",
	AssociatedTier = 5,
	Objectives = {
		{
			Goal = 100,
			Id = 1,
			Name = "Exchange 100 Presents at the Gift Factory",
			Type = "ExchangePresent",
			TrackQuestCFrame = CFrame.new(Vector3.new(1026.207, 26.981, 1677.768))
		},
		{
			Goal = 300,
			Id = 2,
			Name = "Catch 300 fish at Christmas Island",
			Type = "Catch",
			Requirements = {
				Location = "Christmas Island"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(1154.313, 19.267, 1552.781))
		},
		{
			Goal = 150,
			Id = 3,
			Name = "Catch 150 fish at Christmas Cave",
			Type = "Catch",
			Requirements = {
				Location = "Christmas Cave"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(714.021, -31.973, 1606.108))
		}
	},
	Reward = RewardInfo.boatReward("Christmas Car")
}