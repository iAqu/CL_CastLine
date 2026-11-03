-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Purchase a boat and explore the open ocean!",
	AssociatedTier = 2,
	IsOnboarding = true,
	OnboardingQuest = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Purchase a Small Boat",
			Goal = 1,
			Type = "SmallBoatOwner",
			AssociatedItem = "Small Boat",
			AssociatedType = "Boats",
			TrackQuestCFrame = CFrame.new(Vector3.new(33.318, 9.8, 2783.009))
		},
		{
			Id = 2,
			Name = "Visit the Ocean",
			Goal = 1,
			Type = "VisitLocation",
			Requirements = {
				Location = "Ocean"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(-72.025, 2.818, 2251.09))
		}
	},
	Reward = { RewardInfo.currencyReward("Coins", 500) }
}