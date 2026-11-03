-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Catch Presents anywhere on Christmas Island and trade them in for rewards",
	AssociatedTier = 3,
	Objectives = {
		{
			Goal = 50,
			Id = 1,
			Name = "Exchange 50 Presents at the Gift Factory",
			Type = "ExchangePresent",
			TrackQuestCFrame = CFrame.new(Vector3.new(1026.207, 26.981, 1677.768))
		}
	},
	Reward = RewardInfo.baitReward("Wrapped Present")
}