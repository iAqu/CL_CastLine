-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Phil & Bill will tell you about the rumors they\'ve heard in exchange for some fish!",
	AssociatedTier = 0,
	Ordered = true,
	Objectives = {
		{
			Id = 1,
			Name = "Catch fish in the new Laboratory area at Kohana",
			Goal = 10,
			Type = "Catch",
			Requirements = {
				Location = "Kohana Lab"
			}
		},
		{
			Id = 2,
			Name = "Speak with Bill to hear the rumor",
			Goal = 1,
			Type = "SpeakWithNPC",
			Requirements = {
				NPC = "Bill",
				Path = 2,
				Index = 1
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).currencyReward("Coins", 5000)
}