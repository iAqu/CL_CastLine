local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end
local stats = require("./helpers/ItemStats")
local fish = {
	Fish_101 = {
		ItemID = "Fish_101",
		LayoutOrder = 1,
		DefaultWeight = 10,
		DefaultPrice = 11,
		CpsPrice = 4,
		Rarity = "Common",
	},
	Rare = { ItemID = "Rare", LayoutOrder = 2, DefaultWeight = 10, DefaultPrice = 100, CpsPrice = 20, Rarity = "Rare" },
}
local mutations = {
	NormalizeMutationId = function(id)
		return if id == "Golden" then id else nil
	end,
	GetPriceRate = function(id)
		return if id == "Golden" then 1.5 else 1
	end,
	GetEarnCashRate = function(id)
		return if id == "Golden" then 1.5 else 1
	end,
}
local modules = { FishInventoryData = fish, ItemStatUtil = stats, MutationDataUtil = mutations, PlotPlacementUtil = {} }
modules.PlotFishIncome = loadSource("src/ReplicatedStorage/Modules/PlotFishIncome.lua", {
	script = { Parent = modules },
	require = function(value)
		return value
	end,
})
local backpack, character = { tools = {} }, { tools = {} }
for _, container in { backpack, character } do
	function container:GetChildren()
		return table.clone(self.tools)
	end
end
local player = { UserId = 42, Character = character }
function player:FindFirstChildOfClass()
	return backpack
end
local profile, atShop, multiplier, allowPayment, onCredit
local refreshes, removed, credits, payments
modules.SellShopZone = {
	CanSell = function(_, serverTolerance)
		assert(serverTolerance == true, "Service requests must use the generous server boundary")
		return atShop
	end,
}
modules.Constants = { GAMEPASS = { VIP = "VIP", DOUBLE_WINS = "DoubleWins" } }
local saleEffects = loadSource("src/ReplicatedStorage/Modules/GamePassEffectUtil.lua", {
	game = { GetService = function() return { Modules = modules } end },
	require = function(value) return value end,
})
modules.GamePassEffectUtil = { GetSaleMultiplier = function(data)
	return multiplier or saleEffects.GetSaleMultiplier(data)
end }
modules.ItemToolUtil = {
	IsItemTool = function(tool)
		return tool.uid ~= nil
	end,
	GetInstanceId = function(tool)
		return tool.uid
	end,
}
local service
local knit = {
	CreateService = function(value)
		value.Client.Server = value
		return value
	end,
	GetService = function(name)
		if name == "PlotFishService" then
			return {
				RefreshInventoryIncome = function()
					refreshes += 1
				end,
			}
		end
		assert(name == "HotbarLayoutService")
		return {
			RemoveItemDescriptors = function(_, _, ids)
				removed = table.clone(ids)
			end,
		}
	end,
}
local services = {
	ReplicatedFirst = { Data = { ConditionsData = { Normal = { ValueMult = 1 } } } },
	ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
	ServerScriptService = {
		Services = {
			PlayerDataService = {
				GetProfile = function()
					return profile
				end,
				AdjustWins = function(_, _, amount, countTowardTotalWins)
					assert(countTowardTotalWins == false)
					if onCredit then
						onCredit()
					end
					if not allowPayment then
						return false
					end
					credits += amount
					payments += 1
					return true
				end,
			},
		},
	},
}
service = loadSource("src/ServerScriptService/Services/SellService.lua", {
	game = {
		GetService = function(_, name)
			return assert(services[name], name)
		end,
	},
	require = function(value)
		return value
	end,
})
local function record(itemId, mutation)
	return { ItemId = itemId or "Fish_101", Weight = 10, ConditionId = "Normal", MutationId = mutation, Price = 999999 }
end
local function tool(id, container)
	local value = { uid = id }
	function value:Destroy()
		self.destroyed = true
		local index = table.find(container.tools, self)
		if index then
			table.remove(container.tools, index)
		end
	end
	table.insert(container.tools, value)
	return value
end
local function reset()
	profile = {
		Data = {
			Items = { a = record(), b = record(), placed = record("Rare"), gold = record("Rare", "Golden") },
			PlotPlacements = { "placed" },
			GamePasses = { VIP = true },
		},
	}
	atShop, multiplier, allowPayment, onCredit = true, nil, true, nil
	refreshes, removed, credits, payments = 0, nil, 0, 0
	backpack.tools, character.tools = {}, {}
	tool("a", backpack)
	tool("b", character)
	tool("placed", backpack)
	tool("gold", backpack)
end
reset()
local snapshot = service.Client:GetSellInventory(player)
assert(snapshot.success and #snapshot.items == 3 and snapshot.totalPrice == 206)
assert(
	snapshot.items[1].instanceId == "a"
		and snapshot.items[2].instanceId == "b"
		and snapshot.items[3].instanceId == "gold"
)
assert(snapshot.items[1].price == 13 and snapshot.items[3].price == 180 and snapshot.items[3].income == 30)
multiplier = 1.5
local rounding = service:GetSellInventory(player)
assert(
	rounding.totalPrice ~= rounding.items[1].price + rounding.items[2].price + rounding.items[3].price,
	"Bulk rounding must happen after summing base prices, matching existing sales"
)
multiplier = nil
local carried, held = backpack.tools[1], character.tools[1]
local result = service.Client:RequestSellItems(player, { "a" }, 13)
assert(result.success and result.soldCount == 1 and result.earnedCash == 13)
assert(credits == 13 and refreshes == 1 and payments == 1 and removed[1] == "a")
assert(
	not profile.Data.Items.a
		and profile.Data.Items.b
		and profile.Data.Items.placed
		and carried.destroyed
		and not held.destroyed
)
assert(not service:SellItems(player, { "a" }, 13).success and payments == 1, "A repeated sale cannot pay twice")

for _, hasVIP in { false, true } do
	reset()
	profile.Data.GamePasses = { DoubleWins = true, VIP = hasVIP }
	local expected = if hasVIP then 13 else 11
	assert(service:GetSellInventory(player).items[1].price == expected)
	assert(service:SellItems(player, { "a" }, expected).earnedCash == expected and credits == expected,
		"DoubleWins must not increase sale quotes or credits")
end

reset()
for _, ids in { { "a", "a" }, { "a", "missing" }, { "a", "placed" }, { [2] = "a" }, { a = "a" }, {} } do
	assert(not service:SellItems(player, ids, 13).success)
	assert(profile.Data.Items.a and credits == 0 and refreshes == 0)
end
for _, total in { -1, math.huge, 0 / 0, "13", false } do
	assert(not service:SellItems(player, { "a" }, total).success)
end
assert(not service:SellItems(player, nil, 13).success)
assert(not service:SellItems(player, { "a" }, 1).success)
profile.Data.Items.a.Weight = 20
assert(not service:SellItems(player, { "a" }, 13).success, "Changed prices reject the entire sale")
reset()
profile.Data.PlotPlacements[2] = "a"
assert(not service:SellItems(player, { "a", "b" }, 26).success and profile.Data.Items.b)
reset()
profile.Data.Items.a = nil
assert(not service:SellItems(player, { "a", "b" }, 26).success and profile.Data.Items.b)

reset()
atShop = false
assert(not service:GetSellInventory(player).success)
assert(not service:SellItems(player, { "a" }, 13).success)
assert(not service:SellAllItems(player).success and not service:SellHeldItem(player).success and credits == 0)
atShop = true
profile = nil
assert(not service:GetSellInventory(player).success and not service:SellItems(player, { "a" }, 13).success)

reset()
local ids = {}
for _, item in service:GetSellInventory(player).items do
	table.insert(ids, item.instanceId)
end
profile.Data.Items.new = record("Rare")
local extra = tool("new", backpack)
result = service:SellItems(player, ids, 206)
assert(result.success and result.soldCount == 3 and credits == 206)
assert(
	profile.Data.Items.new and profile.Data.Items.placed and not extra.destroyed,
	"Only the confirmed snapshot is sold; newly received and placed fish survive"
)
assert(service:GetSellInventory(player).totalPrice == 120)

reset()
onCredit = function()
	assert(not service:SellItems(player, { "b" }, 13).success, "Reentrant sales must be rejected")
end
assert(service:SellItems(player, { "a" }, 13).success and payments == 1 and profile.Data.Items.b)
onCredit = nil
assert(service:SellItems(player, { "b" }, 13).success and payments == 2, "The transaction guard must be released")
reset()
allowPayment = false
assert(not service:SellItems(player, { "a" }, 13).success and profile.Data.Items.a)
assert(not backpack.tools[1].destroyed and refreshes == 0 and removed == nil)
allowPayment = true
assert(service:SellItems(player, { "a" }, 13).success, "Payment rejection restores inventory and releases the guard")

reset()
profile.Data.Items.invalid = { ItemId = "Fish_101", Weight = math.huge, ConditionId = "Normal" }
profile.Data.Items.unknown = record("Unknown")
profile.Data.Items.broken = false
assert(#service:GetSellInventory(player).items == 3)
assert(service:SellAllItems(player).soldCount == 3 and profile.Data.Items.invalid and profile.Data.Items.placed)
assert(#service:GetSellInventory(player).items == 0 and service:GetSellInventory(player).totalPrice == 0)
assert(not service:SellAllItems(player).success)

-- The shared zone resolves the owner's current slot, never another player's plot.
local slot = 1
local plots = {}
for index = 1, 6 do
	local anchor = {
		IsA = function(_, kind)
			return kind == "BasePart"
		end,
	}
	plots[index] = {
		GetAttribute = function()
			return 42
		end,
		FindFirstChild = function(_, name)
			return if name == "SellShopAnchor" then anchor else nil
		end,
	}
end
function player:GetAttribute()
	return slot
end
local contains = true
local zone = loadSource("src/ReplicatedStorage/Modules/SellShopZone.lua", {
	script = {
		Parent = {
			PlotWorkspaceUtil = {
				getPlotBySlot = function(id)
					return plots[id]
				end,
			},
			RodShopZone = {
				ExitMargin = 2,
				Contains = function()
					return contains
				end,
			},
		},
	},
	require = function(value)
		return value
	end,
})
for index = 1, 6 do
	slot = index
	assert(zone.GetOwnedAnchor(player) == plots[index]:FindFirstChild("SellShopAnchor") and zone.CanSell(player))
end
contains = false
assert(not zone.CanSell(player), "Outside or dead characters must fail the shared geometry check")
contains = true
player.UserId = 99
assert(zone.GetOwnedAnchor(player) == nil and not zone.CanSell(player))
player.UserId, slot = 42, nil
assert(not zone.CanSell(player))
