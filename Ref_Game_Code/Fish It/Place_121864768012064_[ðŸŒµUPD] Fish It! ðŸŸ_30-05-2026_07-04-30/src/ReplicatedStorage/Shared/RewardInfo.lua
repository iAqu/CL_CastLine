-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Modules.CurrencyUtility)
require(ReplicatedStorage.Types.Modifiers)
return {
	BattlepassCurrency = "Tix",
	BattlepassNPC = "Epic Guide",
	BattlepassShopNPC = "Epic Guide",
	BattlepassCurrencyFishing = { "Classic Island", "No Fishing", "Classic Cave", "Iron Cafe", "Classic School" },
	boothReward = function(p1) --[[ boothReward | Line: 31 ]]
		return {
			Type = "Booths",
			Quantity = 1,
			Identifier = p1
		}
	end,
	haloReward = function(p1) --[[ haloReward | Line: 39 ]]
		return {
			Type = "Halos",
			Quantity = 1,
			Identifier = p1
		}
	end,
	charmReward = function(p1, p2) --[[ charmReward | Line: 47 ]]
		return {
			Type = "Charms",
			Quantity = p2,
			Identifier = p1
		}
	end,
	enchantStoneReward = function(p1, p2) --[[ enchantStoneReward | Line: 55 ]]
		return {
			Type = "Enchant Stones",
			Quantity = p2,
			Identifier = p1
		}
	end,
	totemReward = function(p1, p2, p3) --[[ totemReward | Line: 63 ]]
		return {
			Type = "Totems",
			Quantity = p2,
			Identifier = p1,
			Metadata = p3
		}
	end,
	lanternReward = function(p1) --[[ lanternReward | Line: 72 ]]
		return {
			Type = "Lanterns",
			Quantity = 1,
			Identifier = p1
		}
	end,
	itemReward = function(p1, p2, p3) --[[ itemReward | Line: 80 ]]
		return {
			Type = "Items",
			Quantity = p2,
			Identifier = p1,
			Metadata = p3
		}
	end,
	potionReward = function(p1, p2) --[[ potionReward | Line: 89 ]]
		return {
			Type = "Potions",
			Quantity = p2,
			Identifier = p1
		}
	end,
	fishingRodReward = function(p1, p2) --[[ fishingRodReward | Line: 97 ]]
		return {
			Type = "Fishing Rods",
			Quantity = 1,
			Identifier = p1,
			Metadata = p2
		}
	end,
	baitReward = function(p1) --[[ baitReward | Line: 106 ]]
		return {
			Type = "Baits",
			Quantity = 1,
			Identifier = p1
		}
	end,
	emoteReward = function(p1) --[[ emoteReward | Line: 114 ]]
		return {
			Type = "Emotes",
			Quantity = 1,
			Identifier = p1
		}
	end,
	boatReward = function(p1, p2) --[[ boatReward | Line: 122 ]]
		return {
			Type = "Boats",
			Quantity = 1,
			Identifier = p1,
			Metadata = p2
		}
	end,
	petReward = function(p1, p2) --[[ petReward | Line: 132 ]]
		return {
			Type = "Pets",
			Quantity = 1,
			Identifier = p1,
			Metadata = p2
		}
	end,
	petEggReward = function(p1, p2, p3) --[[ petEggReward | Line: 141 ]]
		return {
			Type = "Pet Eggs",
			Identifier = p1,
			Metadata = p3,
			Quantity = p2
		}
	end,
	inventoryReward = function(p1, p2, p3, p4) --[[ inventoryReward | Line: 150 ]]
		return {
			Type = p1,
			Identifier = p2,
			Metadata = p4,
			Quantity = p3
		}
	end,
	currencyReward = function(p1, p2) --[[ currencyReward | Line: 159 ]]
		return {
			Type = "Currency",
			Name = p1,
			Amount = p2
		}
	end
}