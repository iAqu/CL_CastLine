-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Keep fishing and upgrade your gear!",
	AssociatedTier = 1,
	IsOnboarding = true,
	OnboardingQuest = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 5 fish",
			Goal = 5,
			Type = "Catch",
			TrackQuestCFrame = { CFrame.new(Vector3.new(130, 4.032, 2768)), CFrame.new(Vector3.new(-62.462, 4.032, 2767.469)) }
		},
		{
			Id = 2,
			Name = "Sell your fish",
			Goal = 1,
			Type = "SoldFish",
			ScreenMessage = "Sell your fish to buy a better Bait!",
			TrackQuestCFrame = CFrame.new(Vector3.new(48.068, 18.534, 2873.599))
		},
		{
			Id = 3,
			Name = "Purchase a Topwater Bait",
			Goal = 1,
			Type = "TopwaterBaitOwner",
			AssociatedItem = "Topwater Bait",
			AssociatedType = "Baits",
			TrackQuestCFrame = CFrame.new(Vector3.new(111.468, 18.034, 2873.509))
		}
	},
	Reward = { RewardInfo.currencyReward("Coins", 300) }
}