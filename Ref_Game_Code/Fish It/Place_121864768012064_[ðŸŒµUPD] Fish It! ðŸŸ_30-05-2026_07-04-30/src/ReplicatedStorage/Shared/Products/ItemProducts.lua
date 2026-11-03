-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Products = {
		[2676109232] = { RewardInfo.potionReward("Luck I Potion", 1) },
		[2676109155] = { RewardInfo.potionReward("Luck I Potion", 10) },
		[3274772526] = { RewardInfo.potionReward("Luck II Potion", 1) },
		[3274773921] = { RewardInfo.potionReward("Luck II Potion", 10) },
		[2678950020] = { RewardInfo.potionReward("Mutation I Potion", 1) },
		[2678950936] = { RewardInfo.potionReward("Mutation I Potion", 10) },
		[3535923766] = {
			RewardInfo.potionReward("Easter I Potion", 5),
			RewardInfo.potionReward("Carrot I Potion", 5),
			RewardInfo.charmReward("Pastel Egg Charm", 10),
			RewardInfo.totemReward("Super Easter Totem", 1),
			RewardInfo.totemReward("Super Easter Totem", 1),
			RewardInfo.totemReward("Super Easter Totem", 1)
		},
		[3592930102] = { RewardInfo.boothReward(2) }
	},
	Limiteds = {
		[3591974517] = { RewardInfo.fishingRodReward("Overdrive") },
		[3597017700] = { RewardInfo.fishingRodReward("Blossom Guitar") }
	}
}