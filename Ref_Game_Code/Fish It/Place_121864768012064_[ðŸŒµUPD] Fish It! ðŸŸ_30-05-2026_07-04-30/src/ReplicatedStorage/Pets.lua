-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Types.Modifiers)
local v1 = if UserPriority:IsValidTestSession() then 0.1 else 1
return {
	["Tabby Cat"] = {
		TradeLocked = true,
		ModelName = "Tabby Cat",
		Downloadable = true,
		SellPrice = 250,
		Data = {
			Id = 1,
			Type = "Pets",
			Name = "Tabby Cat",
			Description = "A loyal fishing companion.",
			Icon = "rbxassetid://110533898909600",
			Tier = 1
		},
		Perk = {
			Type = "Fishing",
			Value = 1
		},
		Modifiers = {
			BaseLuck = 0.04
		},
		PetFishing = {
			Enabled = false
		}
	},
	Bunny = {
		ModelName = "Bunny",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 2,
			Type = "Pets",
			Name = "Bunny",
			Description = "A lucky founder companion.",
			Icon = "",
			Tier = 3
		},
		Perk = {
			Type = "Luck",
			Value = 0.3
		},
		Modifiers = {
			BaseLuck = 0.3
		},
		PetFishing = {
			Enabled = false
		}
	},
	Otter = {
		ModelName = "Otter",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 3,
			Type = "Pets",
			Name = "Otter",
			Description = "A quick founder companion.",
			Icon = "rbxassetid://124620947719787",
			Tier = 3
		},
		Perk = {
			Type = "ReelSpeed",
			Value = 0.18
		},
		Modifiers = {
			ReelMultiplier = 0.18
		},
		PetFishing = {
			Enabled = false
		}
	},
	Frog = {
		ModelName = "Frog",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 4,
			Type = "Pets",
			Name = "Frog",
			Description = "A very lucky founder companion.",
			Icon = "rbxassetid://81698994110892",
			Tier = 4
		},
		Perk = {
			Type = "Luck",
			Value = 0.7
		},
		Modifiers = {
			BaseLuck = 0.7
		},
		PetFishing = {
			Enabled = false
		}
	},
	Cow = {
		ModelName = "Cow",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 5,
			Type = "Pets",
			Name = "Cow",
			Description = "A strong reeling founder companion.",
			Icon = "rbxassetid://88226351374670",
			Tier = 4
		},
		Perk = {
			Type = "ReelSpeed",
			Value = 0.3
		},
		Modifiers = {
			ReelMultiplier = 0.3
		},
		PetFishing = {
			Enabled = false
		}
	},
	Capybara = {
		ModelName = "Capybara",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 6,
			Type = "Pets",
			Name = "Capybara",
			Description = "A patient fishing founder companion.",
			Icon = "rbxassetid://98095048836673",
			Tier = 5
		},
		Perk = {
			Type = "Luck",
			Value = 0.2
		},
		Modifiers = {
			BaseLuck = 0.2
		},
		PetFishing = {
			Enabled = true,
			CastCooldownSeconds = v1 * 0.5 * 12,
			ReelDurationSeconds = v1 * 65
		}
	},
	Axolotl = {
		ModelName = "Axolotl",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 7,
			Type = "Pets",
			Name = "Axolotl",
			Description = "A steady fishing founder companion.",
			Icon = "rbxassetid://99239886597615",
			Tier = 7
		},
		Perk = {
			Type = "Luck",
			Value = 0.7
		},
		Modifiers = {
			BaseLuck = 0.7
		},
		PetFishing = {
			Enabled = true,
			CastCooldownSeconds = v1 * 0.5 * 6,
			ReelDurationSeconds = v1 * 22
		}
	},
	Penguin = {
		ModelName = "Penguin",
		Downloadable = true,
		SellPrice = 1000,
		Data = {
			Id = 8,
			Type = "Pets",
			Name = "Penguin",
			Description = "A reliable fishing founder companion.",
			Icon = "rbxassetid://95119341920121",
			Tier = 6
		},
		Perk = {
			Type = "Luck",
			Value = 0.4
		},
		Modifiers = {
			BaseLuck = 0.4
		},
		PetFishing = {
			Enabled = true,
			CastCooldownSeconds = v1 * 0.5 * 10,
			ReelDurationSeconds = v1 * 35
		}
	}
}