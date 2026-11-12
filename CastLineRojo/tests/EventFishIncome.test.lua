local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end

local prefix = "src/ReplicatedStorage/Modules/"
local fishes = loadSource("src/ReplicatedFirst/Data/FishesData.lua")
local placements = loadSource(prefix .. "PlotPlacementUtil.lua")
local mutations = {
	NormalizeMutationId = function(id) return id end,
	GetEarnCashRate = function(id) return if id == "Golden" then 1.5 else 1 end,
}
local income = loadSource(prefix .. "PlotFishIncome.lua", {
	script = { Parent = { FishInventoryData = fishes, MutationDataUtil = mutations, PlotPlacementUtil = placements } },
	require = function(module) return module end,
})

local ratios = { 0.8, 1, 1.2, 1.5, 2 }
local models = { "NeonCyber", "Flamingo", "HellShark", "UndeadMegalodon", "GalaxyMegalodon" }
for index, ratio in ipairs(ratios) do
	local fish = fishes["Fish_00" .. index]
	assert(fish.Rarity == "Event" and fish.CpsPrice == ratio and fish.Model == models[index])
	assert(income.GetCpsPrice(fish, 1, 100) == ratio * 100)
	assert(income.GetCpsPrice(fish, 1.5, 100) == ratio * 150)
	assert(income.GetCpsPrice(fish, 1, 1) == math.max(1, math.floor(ratio)))
	assert(income.GetCpsPrice(fish, 1, 0) == 1)
end
assert(income.GetCpsPrice({ Rarity = "Secret", CpsPrice = 10 }, 1.5, 999999) == 15,
	"Secret keeps fixed CPS, even when a stronger owned fish exists")

local data = { Items = {}, PlotPlacements = {} }
assert(income.GetBestOwnedBaseCps(data) == fishes.Fish_101.CpsPrice)
data.Items.event = { ItemId = "Fish_005", MutationId = "Golden" }
data.PlotPlacements[1] = "event"
assert(income.GetBestOwnedBaseCps(data) == 1 and income.GetRate(data) == 3,
	"Event cannot become its own baseline")
data.Items.best = { ItemId = "Fish_517", MutationId = "Golden" }
assert(income.GetBestOwnedBaseCps(data) == fishes.Fish_517.CpsPrice,
	"An unplaced best fish counts, without its mutation multiplier")
assert(income.GetRate(data) == fishes.Fish_517.CpsPrice * 3)
data.Items.best = nil
assert(income.GetRate(data) == 3, "Losing the best fish lowers Event income")
data.Items.invalid = { ItemId = "unknown" }
data.Items.broken = false
assert(income.GetBestOwnedBaseCps(data) == 1)
data.LastOnlineTime, data.PendingPlotOfflineCash = 100, 0
income.PrepareOffline(data, 110)
assert(data.PendingPlotOfflineCash == 15, "Offline rewards share Event CPS and the existing 50% rate")

local roll = loadSource(prefix .. "FishingRoll.lua", {
	script = { Parent = {
		FishingConfig = {}, PetFeatureConfig = { Enabled = false },
		RarityConfig = { Normalize = function(name) return name end,
			ByName = { Common = { Index = 1 }, Event = { Index = 13 } } },
	} },
	require = function(module) return module end,
})
local pool = roll.GetPool({ fishes.Fish_101, fishes.Fish_005 }, math.huge, nil, function() return true end)
assert(#pool == 1 and pool[1].fish == fishes.Fish_101, "Activity-only fish never enter normal fishing")
assert(#roll.GetPool({ fishes.Fish_005 }, math.huge, { FilterRarity = "Event", FilterRatio = 0 },
	function() return true end) == 0, "Even an Event bait filter cannot enable normal Event drops")
local legacy = { FishID = "A", LayoutOrder = 21 }
local explicit = { FishID = "B", LuckExponent = 0, LayoutOrder = 100 }
assert(roll.Choose({ { fish = legacy, weight = 1 }, { fish = explicit, weight = 1 } }, 100,
	{ NextNumber = function() return 0.5 end }) == legacy, "Missing exponents derive from layout order")
legacy.LuckExponent = 0
assert(roll.Choose({ { fish = legacy, weight = 1 }, { fish = explicit, weight = 1 } }, 100,
	{ NextNumber = function() return 0.5 end }) == explicit, "An explicit zero exponent must win")

-- Real title code must update against its owner, and release its listener on destroy.
local callbacks, disconnected = {}, false
local owner = { base = 100 }
function owner:GetAttribute() return self.base end
function owner:GetAttributeChangedSignal(name)
	assert(name == "BestOwnedFishBaseCps")
	return { Connect = function(_, callback)
		callbacks.changed = callback
		return { Disconnect = function() disconnected = true end }
	end }
end
local labels = { NameLabel = {}, CpsLabel = {} }
for _, label in pairs(labels) do function label:IsA(class) return class == "TextLabel" end end
local frame = { FindFirstChild = function(_, name) return labels[name] end }
local title = { FindFirstChild = function() return frame end,
	Destroying = { Once = function(_, callback) callbacks.destroy = callback end } }
local template = { IsA = function() return true end, Clone = function() return title end }
local titleUtil = loadSource(prefix .. "FishTitleUtil.lua", {
	game = { GetService = function() return { Modules = {
		MutationDataUtil = mutations, PlotFishIncome = income, NumberUtil = { FormatItemPriceCompact = tostring },
	} } end }, require = function(module) return module end,
})
assert(titleUtil.Create({ FindFirstChild = function() return template end }, fishes.Fish_001, nil, owner) == title)
assert(labels.CpsLabel.Text == "$80/s")
owner.base = 200
callbacks.changed()
assert(labels.CpsLabel.Text == "$160/s", "Remote and local titles follow the supplied owner")
callbacks.destroy()
assert(disconnected, "Destroyed titles release their owner listener")
