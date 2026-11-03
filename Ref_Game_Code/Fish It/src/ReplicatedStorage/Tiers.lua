-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	[1] = {
		Name = "Common",
		Rarity = 1,
		Tier = 1,
		TierColor = ColorSequence.new(Color3.fromRGB(255, 250, 246))
	},
	[2] = {
		Name = "Uncommon",
		Rarity = 0.02,
		Tier = 2,
		TierColor = ColorSequence.new(Color3.fromRGB(195, 255, 85))
	},
	[3] = {
		Name = "Rare",
		Rarity = 0.004,
		Tier = 3,
		TierColor = ColorSequence.new(Color3.fromRGB(85, 162, 255))
	},
	[4] = {
		Name = "Epic",
		Rarity = 0.001,
		Tier = 4,
		TierColor = ColorSequence.new(Color3.fromRGB(178, 114, 247))
	},
	[5] = {
		Name = "Legendary",
		Rarity = 0.0002,
		Tier = 5,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 184, 42)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 184, 42)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 232, 142)) })
	},
	[6] = {
		Name = "Mythic",
		Rarity = 0.00002,
		Tier = 6,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 24, 24)), ColorSequenceKeypoint.new(1, Color3.fromRGB(102, 0, 0)) })
	},
	[7] = {
		Name = "SECRET",
		Rarity = 4e-6,
		Tier = 7,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 255, 151)), ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 149, 255)) })
	},
	[8] = {
		Name = "FORGOTTEN",
		Rarity = 8.333333333333334e-8,
		Tier = 8,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(127, 127, 127)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) })
	},
	[90] = {
		Name = "Trophy",
		Rarity = -1,
		Tier = 90,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 106, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 195, 14)) })
	},
	[95] = {
		Name = "Collectible",
		Rarity = -1,
		Tier = 100,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(174, 158, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(101, 122, 255)) })
	},
	[100] = {
		Name = "Exclusive",
		Rarity = -1,
		Tier = 100,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 89, 225)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 183, 251)) })
	},
	[1000] = {
		Name = "DEV",
		Rarity = -1,
		Tier = 1000,
		TierColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 21, 25)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 10, 10)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 21, 25)) })
	}
}