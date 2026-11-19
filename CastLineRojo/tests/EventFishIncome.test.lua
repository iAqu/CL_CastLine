local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end

local prefix = "src/ReplicatedStorage/Modules/"
local fishes = loadSource("src/ReplicatedFirst/Data/FishesData.lua")
local placements = loadSource(prefix .. "PlotPlacementUtil.lua", require("./helpers/PlotUpgrades").environment)
local stats = require("./helpers/ItemStats")
local mutations = {
	NormalizeMutationId = function(id) return id end,
	GetEarnCashRate = function(id) return if id == "Golden" then 1.5 else 1 end,
}
local income = loadSource(prefix .. "PlotFishIncome.lua", {
	script = { Parent = { FishInventoryData = fishes, ItemStatUtil = stats, MutationDataUtil = mutations, PlotPlacementUtil = placements } },
	require = function(module) return module end,
})

local percentageFish = {
	{ "Fish_001", "Exclusive", 80, "NeonCyber" },
	{ "Fish_002", "Exclusive", 100, "Flamingo" },
	{ "Fish_003", "Exclusive", 120, "HellShark" },
	{ "Fish_004", "Exclusive", 150, "UndeadMegalodon" },
	{ "Fish_005", "Exclusive", 200, "GalaxyMegalodon" },
	{ "Fish_901", "Event", 90, "SummertimeElk" },
	{ "Fish_902", "Event", 120, "CandyJellyfish" },
	{ "Fish_903", "Event", 150, "PrehistoricTurtle" },
	{ "Fish_904", "Event", 170, "Dragonfish" },
}
for _, case in ipairs(percentageFish) do
	local id, rarity, percent, model = table.unpack(case)
	local fish = fishes[id]
	local ratio = percent / 100
	assert(fish.Rarity == rarity and fish.CpsPrice == ratio and fish.Model == model, id)
	assert(income.GetCpsPrice(fish, 1, 100) == percent, id)
	assert(income.GetCpsPrice(fish, 1.5, 100, fish.DefaultWeight * 8) == math.floor(percent * 1.5 * 8 ^ 0.6), id)
	assert(income.GetCpsPrice(fish, 1, nil) == math.max(1, math.floor(ratio)), id)
	assert(income.GetCpsPrice(fish, 1, 0) == 1, id)
end
assert(income.GetCpsPrice({ Rarity = "Secret", CpsPrice = 10 }, 1.5, 999999) == 15,
	"Secret keeps fixed CPS, even when a stronger owned fish exists")

local data = { Items = {}, PlotPlacements = {} }
assert(income.GetBestOwnedBaseCps(data) == fishes.Fish_101.CpsPrice)
data.Items.exclusive = { ItemId = "Fish_005", MutationId = "Golden" }
data.Items.event = { ItemId = "Fish_904" }
data.PlotPlacements[1] = "exclusive"
data.PlotPlacements[2] = "event"
assert(income.GetBestOwnedBaseCps(data) == 1 and income.GetRate(data) == 4,
	"Neither percentage rarity can become the baseline")
data.Items.best = { ItemId = "Fish_197", MutationId = "Golden" }
local bestCps = fishes.Fish_197.CpsPrice
assert(income.GetBestOwnedBaseCps(data) == bestCps,
	"An unplaced best fish counts, without its mutation multiplier")
assert(income.GetRate(data) == bestCps * 3 + math.floor(bestCps * 1.7),
	"Online production adds both fish's scaled income")
data.Items.best = nil
assert(income.GetRate(data) == 4, "Losing the best fish lowers income for both percentage rarities")
data.Items.invalid = { ItemId = "unknown" }
data.Items.broken = false
assert(income.GetBestOwnedBaseCps(data) == 1)
data.LastOnlineTime, data.PendingPlotOfflineCash = 100, 0
income.PrepareOffline(data, 110)
assert(data.PendingPlotOfflineCash == 20, "Offline rewards share the percentage CPS formula and the existing 50% rate")

local roll = loadSource(prefix .. "FishingRoll.lua", {
	script = { Parent = {
		FishingConfig = {}, PetFeatureConfig = { Enabled = false },
		RarityConfig = { Normalize = function(name) return name end,
			ByName = { Common = { Index = 1 }, Event = { Index = 13 } } },
	} },
	require = function(module) return module end,
})
local progression=loadSource(prefix.."FishingProgression.lua",setmetatable({
 script={Parent={FishingConfig=loadSource(prefix.."FishingConfig.lua")}},require=function(v) return v end,
},{__index=getfenv()}))
local rod={RodID="starter",Rarity="Common",LayoutOrder=1}
local function hasModel()
	return true
end
local pool = progression.BuildPool({ fishes.Fish_101, fishes.Fish_005, fishes.Fish_901 }, rod, { rod }, hasModel)
assert(#pool==1 and pool[1].fish==fishes.Fish_101,"Activity-only fish never enter normal fishing")
assert(#progression.BuildPool({ fishes.Fish_901 }, rod, { rod }, hasModel) == 0,
	"Event fish do not supply fallback catches")
local legacy={FishID="A",LayoutOrder=21}
local explicit={FishID="B",LuckExponent=0,LayoutOrder=100}
assert(roll.Choose({{fish=legacy,weight=1},{fish=explicit,weight=1}},100,{NextNumber=function() return 0.5 end})==explicit,
 "Display luck and legacy exponents must not change the weighted roll")

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
local titleGui = {}
function titleGui:FindFirstChild()
	return template
end
for _, case in ipairs(percentageFish) do
	local id, _, percent = table.unpack(case)
	owner.base, disconnected = 100, false
	assert(titleUtil.Create(titleGui, fishes[id], nil, owner) == title, "Percentage title is created for " .. id)
	assert(labels.CpsLabel.Text == string.format("$%d/s (%d%%)", percent, percent), id)
	owner.base = 200
	callbacks.changed()
	assert(labels.CpsLabel.Text == string.format("$%d/s (%d%%)", percent * 2, percent),
		"Remote and local titles follow the supplied owner and keep their configured ratio")
	callbacks.destroy()
	assert(disconnected, "Destroyed titles release their owner listener")
end
callbacks = {}
assert(titleUtil.Create(titleGui, fishes.Fish_101, nil, owner) == title, "Fixed income title is created")
assert(labels.CpsLabel.Text == "$1/s" and next(callbacks) == nil,
	"Fixed income titles keep their existing format without observing the owner's baseline")
