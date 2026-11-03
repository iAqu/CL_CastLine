-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "The depths of the ocean call your name...",
	AssociatedTier = 6,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 300 Rare/Epic fish at Treasure Room",
			Goal = 300,
			Type = "TreasureRoomMarker"
		},
		{
			Id = 2,
			Name = "Catch 3 Mythic fish at Sisyphus Statue",
			Goal = 3,
			Type = "Catch",
			Requirements = {
				Tier = 6,
				Location = "Sisyphus Statue"
			}
		},
		{
			Id = 3,
			Name = "Catch 1 SECRET fish at Sisyphus Statue",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Tier = 7,
				Location = "Sisyphus Statue"
			}
		},
		{
			Id = 4,
			Name = "Earn 1M Coins",
			Goal = 1000000,
			Type = "EarnedCoins"
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).fishingRodReward("Ghostfinn Rod")
}