-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "",
	AssociatedTier = 0,
	Ordered = false,
	Repeatable = false,
	RepeatCooldown = 25,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 2 fish",
			Goal = 2,
			Type = "Catch",
			Requirements = {},
			TrackQuestCFrame = { CFrame.new(Vector3.new(143.081, -0.068, 2766.819)), CFrame.new(Vector3.new(-76.519, -0.068, 2767.519)) }
		}
	},
	Reward = RewardInfo.currencyReward("Coins", 500)
}