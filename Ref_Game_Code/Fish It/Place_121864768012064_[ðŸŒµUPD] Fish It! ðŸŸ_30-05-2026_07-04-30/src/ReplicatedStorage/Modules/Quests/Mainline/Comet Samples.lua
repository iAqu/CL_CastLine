-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "The research team needs Comet Shards to study!",
	AssociatedTier = 4,
	NPC = "D.M.C Meteorologist",
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Collect 5 Comet Shards",
			Goal = 5,
			Type = "Search",
			Requirements = {
				Object = "CometShard"
			}
		},
		{
			Id = 2,
			Name = "Return to the D.M.C Meteorologist",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "D.M.C Meteorologist",
				Path = 1,
				Index = 4
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).emoteReward("Clipboard")
}