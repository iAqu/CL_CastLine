-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Weight = 60,
		RewardName = "200 Easter Coins",
		RewardInfo = RewardInfo.currencyReward("Easter Coins", 200)
	},
	{
		Weight = 35,
		RewardName = "400 Easter Coins",
		RewardInfo = RewardInfo.currencyReward("Easter Coins", 400)
	},
	{
		Weight = 5,
		RewardName = "Cracked Egg Halo",
		Unique = true,
		RewardInfo = RewardInfo.haloReward("Cracked Egg Halo")
	}
}