local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(environment or {}, { __index = getfenv() })))()
end

local stats = require("./helpers/ItemStats")
local root = "src/ReplicatedStorage/Modules/"
local fish = { ItemID = "Fish", DefaultWeight = 10, DefaultPrice = 3000, CpsPrice = 100, Rarity = "Common" }
local event = { ItemID = "Event", DefaultWeight = 2, DefaultPrice = 5000, CpsPrice = 2, Rarity = "Event" }
local conditions = { Codition_1 = { ValueMult = 1 }, Great = { ValueMult = 2.2 } }
local mutationConfigs = loadSource("src/ReplicatedFirst/Data/MutationsData.lua")
local replicatedFirst = { Data = { ConditionsData = conditions, MutationsData = mutationConfigs } }
local mutations = loadSource(root .. "MutationDataUtil.lua", {
	game = { GetService = function() return replicatedFirst end }, require = function(value) return value end,
})
local modules = {
	SellShopZone = { CanSell = function() return true end },
	FishInventoryData = { Fish = fish, Event = event }, ItemStatUtil = stats, MutationDataUtil = mutations,
	PlotPlacementUtil = loadSource(root .. "PlotPlacementUtil.lua", require("./helpers/PlotUpgrades").environment),
}
local income = loadSource(root .. "PlotFishIncome.lua", {
	script = { Parent = modules }, require = function(value) return value end,
})
modules.PlotFishIncome = income
local function near(actual, expected)
	assert(math.abs(actual - expected) < 1e-9, tostring(actual) .. " ~= " .. tostring(expected))
end

near(stats.GetWeightValueMultiplier(fish, 10), 1)
near(stats.GetWeightValueMultiplier(fish, 1297.46337890625), 18.52921690319818)
assert(stats.CalculatePrice(fish, 1297.46337890625, 1) == 55588, "Sale value must use size^1.8 rather than size^3")
assert(stats.CalculatePrice(fish, 1297.46337890625, 1.5) == 83381, "Keep the existing mutation sale multiplier")
assert(income.GetCpsPrice(fish, 1.5, nil, 1297.46337890625) == 2779, "CPS must use the same size factor and keep flooring")
assert(stats.CalculatePrice(fish, 10, 2) == 6000, "Only the mutation multiplies the base sale price")
for id, rate in pairs({ Golden = 2, Diamond = 5, Rainbow = 10 }) do
	assert(stats.CalculatePrice(fish, 10, mutations.GetPriceRate(id)) == 3000 * rate)
	assert(income.GetCpsPrice(fish, mutations.GetEarnCashRate(id), nil, 10) == 100 * rate)
end
assert(income.GetCpsPrice(fish, 1) == 100, "Missing historical/display weight defaults to base size")
for _, weight in { math.huge, -math.huge, 0 / 0, -1 } do
	assert(stats.GetWeightValueMultiplier(fish, weight) == 1, "Malformed weights must not yield invalid money")
end

local data = {
	Items = {
		held = { ItemId = "Fish", Weight = 1297.46337890625, ConditionId = "Codition_1", MutationId = "Golden", Price = 1e15 },
		placed = { ItemId = "Fish", Weight = 10, ConditionId = "Great", MutationId = "Diamond", Price = 999999 },
		event = { ItemId = "Event", Weight = 6.75, ConditionId = "Codition_1", MutationId = "Rainbow", Price = 1 },
		unknown = { ItemId = "Missing", Weight = 10, Price = 123 },
		invalid = { ItemId = "Fish", Weight = -1, Price = 456 },
		broken = false,
	},
	PlotPlacements = { [1] = "placed", [2] = "event", [3] = "placed" },
	LastOnlineTime = 100, PendingPlotOfflineCash = 0,
}
local migrate = loadSource(root .. "ItemPriceMigration.lua", {
	game = { GetService = function() return replicatedFirst end }, script = { Parent = modules },
	require = function(value) return value end,
})
migrate(data)
assert(data.Items.held.Price == 111175 and data.Items.placed.Price == 15000, "Reprice carried and placed legacy fish")
assert(data.Items.held.Weight == 1297.46337890625 and data.Items.held.MutationId == "Golden", "Migration changes only cached sale values")
assert(data.Items.unknown.Price == 123 and data.Items.invalid.Price == 456, "Invalid records are not deleted or repriced")
local eventPrice = data.Items.event.Price
migrate(data)
assert(data.Items.held.Price == 111175 and data.Items.event.Price == eventPrice, "Repricing is idempotent")
migrate({ Items = false })
assert(income.GetBestOwnedBaseCps(data) == 100, "A large mutated fish must not inflate the Event baseline")
assert(income.GetCpsPrice(event, 2.5, 100, 6.75) == 1037, "Apply an Event fish's own weight exactly once")
assert(income.GetRate(data) == 4649, "Online income must count placed fish once with their actual weights")
income.PrepareOffline(data, 110)
assert(data.PendingPlotOfflineCash == 23245, "Offline income shares weighted CPS and the existing 50% rate")

-- Exercise authoritative quotes and bulk sales against stale cached prices.
local heldTool = { uid = "held", Parent = true }
local backpack = { GetChildren = function() return {} end }
local player = {
	Character = { GetChildren = function() return { heldTool } end },
	FindFirstChildOfClass = function() return backpack end,
}
function heldTool:Destroy() self.Parent = nil end
modules.ItemToolUtil = { IsItemTool = function() return true end, GetInstanceId = function(tool) return tool.uid end }
modules.GamePassEffectUtil = { GetSaleMultiplier = function() return 1.5 end }
local refreshes, removed, credits = 0, nil, 0
local knit = {
	CreateService = function(service) return service end,
	GetService = function(name)
		if name == "PlotFishService" then return { RefreshInventoryIncome = function() refreshes += 1 end } end
		assert(name == "HotbarLayoutService")
		return { RemoveItemDescriptors = function(_, _, ids) removed = ids end }
	end,
}
local services = {
	ReplicatedFirst = replicatedFirst, ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
	ServerScriptService = { Services = { PlayerDataService = {
		GetProfile = function() return { Data = data } end,
		AdjustWins = function(_, _, cash, progress)
			assert(progress == false, "Sales must not change TotalWins")
			credits += cash
			return true
		end,
	} } },
}
local sell = loadSource("src/ServerScriptService/Services/SellService.lua", {
	game = { GetService = function(_, name) return services[name] end }, require = function(value) return value end,
})
data.Items.held.Price = 1e15
assert(sell:GetHeldItemQuote(player).price == 166763, "Quotes must ignore the historical price and keep the sale game pass")
assert(data.Items.held.Price == 111175, "Quotes repair the cached price")
data.Items.held.Price = 1e15
data.Items.unknown, data.Items.invalid, data.Items.broken = nil, nil, nil
local sold = sell:SellAllItems(player)
assert(sold.success and sold.soldCount == 1 and sold.earnedCash == 166763 and credits == 166763)
assert(data.Items.held == nil and data.Items.placed and data.Items.event, "Bulk sales must preserve placed fish")
assert(refreshes == 1 and #removed == 1 and removed[1] == "held")
