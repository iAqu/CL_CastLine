-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Venture far into the ocean to discover this tropical island",
	AssociatedTier = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Visit the island Kohana",
			Goal = 1,
			Type = "VisitLocation",
			Requirements = {
				Location = "Kohana"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(-593.021, 0.535, 799.921))
		}
	},
	Reward = RewardInfo.currencyReward("Coins", 500)
}