-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Replion)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Modules.Util.TableUtil)
require(ReplicatedStorage.Types.Modifiers)
local _ = {
	Variant1 = {
		Name = "Perfect Withering Rod",
		BonusMultiplier = NumberRange.new(0.75, 1),
		BonusStats = {
			ReelMultiplier = {
				Weight = 5,
				Range = NumberRange.new(0.05, 0.1)
			},
			MutationMultiplier = {
				Weight = 12,
				Range = NumberRange.new(0.1, 0.15)
			},
			ShinyMultiplier = {
				Weight = 15,
				Range = NumberRange.new(0.1, 0.15)
			}
		}
	},
	Variant2 = {
		Name = "Excelent Withering Rod",
		BonusMultiplier = NumberRange.new(0.5, 0.75),
		BonusStats = {
			ReelMultiplier = {
				Weight = 5,
				Range = NumberRange.new(0.02, 0.05)
			},
			MutationMultiplier = {
				Weight = 12,
				Range = NumberRange.new(0.05, 0.1)
			},
			ShinyMultiplier = {
				Weight = 15,
				Range = NumberRange.new(0.05, 0.1)
			}
		}
	},
	Variant3 = {
		Name = "Withering Rod",
		BonusMultiplier = NumberRange.new(0, 0.5),
		BonusStats = {
			MutationMultiplier = {
				Weight = 12,
				Range = NumberRange.new(0.05, 0.1)
			},
			XPMultiplier = {
				Weight = 15,
				Range = NumberRange.new(0.1, 0.15)
			}
		}
	}
}
return {
	Items = {
		["Winged Charm"] = {
			Type = "Charms",
			Minigame = "Basic",
			Ingredients = { RewardInfo.itemReward("Rope", 2), RewardInfo.itemReward("Driftwood", 1) },
			Reward = RewardInfo.charmReward("Winged Charm", 1)
		},
		["Oculus Charm"] = {
			Type = "Charms",
			Minigame = "Basic",
			Ingredients = {
				RewardInfo.itemReward("Veilshard", 2),
				RewardInfo.itemReward("Cave Crystal", 1),
				RewardInfo.itemReward("Embercrux", 1),
				RewardInfo.itemReward("Pyrafruit Relic", 1)
			},
			Reward = RewardInfo.charmReward("Oculus Charm", 1)
		},
		["Anchor Charm"] = {
			Type = "Charms",
			Minigame = "Basic",
			Ingredients = { RewardInfo.itemReward("Pyrafruit Relic", 1), RewardInfo.itemReward("Embercrux", 1) },
			Reward = RewardInfo.charmReward("Anchor Charm", 1)
		},
		["Hook Charm"] = {
			Type = "Charms",
			Minigame = "Basic",
			Ingredients = { RewardInfo.itemReward("Rope", 3) },
			Reward = RewardInfo.charmReward("Hook Charm", 1)
		}
	},
	Weighted = {
		["Hook Charm"] = 60,
		["Winged Charm"] = 25,
		["Anchor Charm"] = 10,
		["Oculus Charm"] = 5
	},
	Verify = function(p1, p2, p3) --[[ Verify | Line: 202 | Upvalues: ItemUtility (copy), InventoryMapping (copy), PlayerStatsUtility (copy) ]]
		local count = 0
		local t = {}
		for i, v in ipairs(p3.Ingredients) do
			local v2 = ItemUtility.GetItemDataFromItemType(v.Type, v.Identifier)
			if v2 then
				local v3 = v.Quantity or 1
				local v4, v5 = PlayerStatsUtility:GetItemFromInventory(p2, function(p1) --[[ Line: 217 | Upvalues: v2 (copy), v3 (copy) ]]
					if p1.Id ~= v2.Data.Id then
						return false
					end
					return v3 <= (p1.Quantity or 1)
				end, InventoryMapping[v.Type] or "Items")
				if v4 then
					local v6 = ItemUtility.GetItemDataFromItemType(v5.Category, v4.Id)
					if v6 and (if v2.Data.Id == v6.Data.Id then v2.Data.Type == v6.Data.Type else false) then
						table.insert(t, v4.UUID)
						count = count + 1
					end
				end
			end
		end
		return count == #p3.Ingredients, t
	end
}