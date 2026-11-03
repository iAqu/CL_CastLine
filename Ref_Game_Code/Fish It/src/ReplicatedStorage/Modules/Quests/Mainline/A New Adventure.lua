-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "This beginner guide will teach you the ins and outs of Fish It!",
	AssociatedTier = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 2 fish",
			Goal = 2,
			Type = "Catch",
			TrackQuestCFrame = { CFrame.new(Vector3.new(143.081, -0.068, 2766.819)), CFrame.new(Vector3.new(-76.519, -0.068, 2767.519)) }
		},
		{
			Id = 2,
			Name = "Sell a fish",
			Goal = 1,
			Type = "SoldFish",
			TrackQuestCFrame = CFrame.new(Vector3.new(48.068, 18.534, 2873.599))
		},
		{
			Id = 3,
			Name = "Purchase a Luck Rod",
			Goal = 1,
			Type = "LuckRodOwner",
			AssociatedItem = "Luck Rod",
			AssociatedType = "Fishing Rods",
			TrackQuestCFrame = CFrame.new(Vector3.new(149.718, 21.659, 2834.509))
		},
		{
			Id = 4,
			Name = "Purchase a Topwater Bait",
			Goal = 1,
			Type = "TopwaterBaitOwner",
			AssociatedItem = "Topwater Bait",
			AssociatedType = "Baits",
			TrackQuestCFrame = CFrame.new(Vector3.new(111.468, 18.034, 2873.509))
		}
	},
	Reward = RewardInfo.currencyReward("Coins", 500)
}