-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Description = "Catch the SECRET fish within Crystal Depths for a special reward!",
	AssociatedTier = 7,
	Objectives = {
		{
			Id = 1,
			Name = "Own an Element Rod",
			Goal = 1,
			Type = "ElementRodOwner",
			AssociatedItem = "Element Rod",
			AssociatedType = "Fishing Rods"
		},
		{
			Id = 2,
			Name = "Own a Singularity Bait",
			Goal = 1,
			Type = "SingularityBaitOwner",
			AssociatedItem = "Singularity Bait",
			AssociatedType = "Baits"
		},
		{
			Id = 3,
			Name = "Exchange a Cursed Kraken",
			Goal = 1,
			Type = "Exchange",
			AssociatedItem = "Cursed Kraken",
			AssociatedType = "Fish",
			Requirements = {
				Id = 589
			}
		},
		{
			Id = 4,
			Name = "Catch an Elpirate Gran Maja",
			Goal = 1,
			Type = "Catch",
			AssociatedItem = "Elpirate Gran Maja",
			AssociatedType = "Fish",
			Requirements = {
				Id = 661
			}
		},
		{
			Id = 5,
			Name = "Catch a Legendary Crystalized mutation fish at Crystal Depths",
			Goal = 1,
			Type = "Catch",
			Requirements = {
				Tier = 5,
				Variant = "Crystalized"
			}
		}
	},
	Reward = require(ReplicatedStorage.Shared.RewardInfo).baitReward("Aetherion Bait")
}