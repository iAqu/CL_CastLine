-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Hunt down the ingredients to craft the Leviathan\'s Scale!",
	AssociatedTier = 6,
	Repeatable = true,
	RepeatCooldown = 86400,
	Objectives = {
		{
			Id = 1,
			Name = "Catch a Magma Core",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Gears",
			AssociatedItem = "Magma Core",
			QuestItem = true,
			Requirements = {
				Fish = "Magma Core"
			}
		},
		{
			Id = 2,
			Name = "Catch a Leviathan Essence",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Gears",
			AssociatedItem = "Leviathan Essence",
			QuestItem = true,
			Requirements = {
				Fish = "Leviathan Essence"
			}
		},
		{
			Id = 3,
			Name = "Catch an Ocean Core",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Gears",
			AssociatedItem = "Ocean Core",
			QuestItem = true,
			Requirements = {
				Fish = "Ocean Core"
			}
		},
		{
			Id = 4,
			Name = "Catch 200 fish while using PERFECT! throw",
			Goal = 200,
			Type = "Catch",
			Requirements = {
				EffectIndex = 5
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).itemReward("Leviathan Scale")
}