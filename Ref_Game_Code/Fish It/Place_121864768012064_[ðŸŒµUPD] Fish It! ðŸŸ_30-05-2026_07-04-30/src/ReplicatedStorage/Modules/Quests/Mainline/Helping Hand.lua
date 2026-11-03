-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Description = "Head to your nearest Pet Emporium and help Clara feed the animals!",
	AssociatedTier = 2,
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Speak to Clara",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Clara"
			},
			TrackQuestCFrame = { CFrame.new(Vector3.new(-38.532, 20.222, 2886.134)), CFrame.new(Vector3.new(-4276.879, 24.853, 638.684)) }
		},
		{
			Id = 2,
			Name = "Catch 20 Salmon",
			Goal = 20,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Salmon",
			QuestItem = true,
			Requirements = {
				Fish = "Salmon"
			}
		},
		{
			Id = 3,
			Name = "Catch 5 Pet Collars",
			Goal = 5,
			Type = "Catch",
			AssociatedType = "Gears",
			AssociatedItem = "Pet Collar",
			QuestItem = true,
			Requirements = {
				Fish = "Pet Collar"
			}
		}
	},
	Reward = RewardInfo.petReward("Tabby Cat")
}