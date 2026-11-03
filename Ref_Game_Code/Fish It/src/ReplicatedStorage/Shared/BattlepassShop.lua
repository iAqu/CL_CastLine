-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Price = 2000,
		RewardInfo = RewardInfo.charmReward("Boombox Charm", 2)
	},
	{
		Price = 4000,
		RewardInfo = RewardInfo.baitReward("Catseye")
	},
	{
		Price = 5000,
		RewardInfo = RewardInfo.potionReward("Luck I Potion", 2)
	},
	{
		Price = 11000,
		RewardInfo = RewardInfo.fishingRodReward("Crystalized Fedora")
	},
	{
		Price = 17000,
		RewardInfo = RewardInfo.enchantStoneReward("Super Enchant Stone", 1)
	},
	{
		Price = 22000,
		RewardInfo = RewardInfo.lanternReward("Gravity Coil Lantern")
	},
	{
		Price = 27000,
		RewardInfo = RewardInfo.baitReward("Redcliff Orb")
	},
	{
		Price = 33000,
		RewardInfo = RewardInfo.lanternReward("Domino Crown Lantern")
	},
	{
		Price = 38000,
		RewardInfo = RewardInfo.fishingRodReward("Korblox Vengeance")
	},
	{
		Price = 45000,
		RewardInfo = RewardInfo.lanternReward("Subspace Tripmine Lantern")
	},
	{
		Price = 52000,
		RewardInfo = RewardInfo.itemReward("2026 Retro Plaque", 1)
	},
	{
		Price = 55000,
		RewardInfo = RewardInfo.boatReward("Rainbow Magic Carpet")
	},
	{
		Price = 65000,
		RewardInfo = RewardInfo.boatReward("Minecart Boat")
	}
}