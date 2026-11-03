-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Milestone = 2000,
		Reward = RewardInfo.fishingRodReward("Divine Staff"),
		AltReward = RewardInfo.fishingRodReward("Fallen Staff")
	}
}