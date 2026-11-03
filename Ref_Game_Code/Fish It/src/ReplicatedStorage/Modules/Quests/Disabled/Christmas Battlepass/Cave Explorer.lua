-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Collect a bunch of fish from this limited cave",
	AssociatedTier = 3,
	Objectives = {
		{
			Goal = 300,
			Id = 1,
			Name = "Catch 300 fish at Christmas Cave",
			Type = "Catch",
			Requirements = {
				Location = "Christmas Cave"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(1154.313, 19.267, 1552.781))
		}
	},
	Reward = RewardInfo.fishingRodReward("Arctic Explorer")
}