-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Modules.Util.FormatUtil)
return {
	Description = "Help the Magma Fisher!",
	AssociatedTier = 1,
	NPC = "Magma Fisher",
	Ordered = false,
	Objectives = {
		{
			Id = 1,
			Name = "Catch 1 Blueflame Ray",
			Goal = 1,
			Type = "Catch",
			AssociatedType = "Fish",
			AssociatedItem = "Blueflame Ray",
			Requirements = {
				Fish = "Blueflame Ray"
			}
		},
		{
			Id = 2,
			Name = "Use 2 Magma Charms",
			Goal = 2,
			Type = "ConsumeCharm",
			AssociatedType = "Charms",
			AssociatedItem = "Magma Charm",
			Requirements = {
				Type = "Magma Charm"
			}
		}
	},
	Reward = RewardInfo.currencyReward("Coins", 5000)
}