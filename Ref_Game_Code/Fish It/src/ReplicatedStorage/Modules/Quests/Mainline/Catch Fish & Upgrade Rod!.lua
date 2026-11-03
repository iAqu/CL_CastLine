-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Learn to fish and sell your catch!",
	AssociatedTier = 1,
	IsOnboarding = true,
	OnboardingQuest = 1,
	UnlockIndex = true,
	TriggerStarterPack = true,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 2 fish",
			Goal = 2,
			Type = "Catch",
			TrackQuestCFrame = { CFrame.new(Vector3.new(130, 4.032, 2768)), CFrame.new(Vector3.new(-62.462, 4.032, 2767.469)) }
		},
		{
			Id = 2,
			Name = "Sell your fish",
			Goal = 1,
			Type = "SoldFish",
			ScreenMessage = "Sell your fish for a better fishing rod!",
			TrackQuestCFrame = CFrame.new(Vector3.new(48.068, 18.534, 2873.599))
		},
		{
			Id = 3,
			Name = "Purchase a Luck Rod",
			Goal = 1,
			Type = "LuckRodOwner",
			AssociatedItem = "Luck Rod",
			AssociatedType = "Fishing Rods",
			TrackQuestCFrame = CFrame.new(Vector3.new(148.091, 23.627, 2833.644))
		}
	},
	Reward = { RewardInfo.currencyReward("Coins", 50) }
}