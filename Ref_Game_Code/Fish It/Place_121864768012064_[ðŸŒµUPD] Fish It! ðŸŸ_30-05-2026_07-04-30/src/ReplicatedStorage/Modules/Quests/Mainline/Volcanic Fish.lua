-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "It\'s hot in here! Make sure not to fall in the lava!",
	AssociatedTier = 3,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Talk to the Lava Fisherman at Kohana Volcano",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Lava Fisherman"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(-615.318, 48.671, 186.823))
		},
		{
			Id = 2,
			Name = "Catch 10 fish at Kohana Volcano",
			Goal = 10,
			Type = "Catch",
			Requirements = {
				Location = "Kohana Volcano"
			},
			TrackQuestCFrame = CFrame.new(Vector3.new(-620.218, 39.45, 165.41))
		}
	},
	Reward = RewardInfo.fishingRodReward("Lava Rod")
}