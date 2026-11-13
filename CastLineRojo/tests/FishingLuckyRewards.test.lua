local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", environment or getfenv()))()
end

local root = "src/ReplicatedStorage/Modules/"
local config = loadSource(root .. "FishingConfig.lua")
assert(config.MutationMaxChance == 0.5 and config.RodWeightLimitEnabled == false)
assert(config.WaitLuckMaxMultiplier == nil and config.WaitLuckRampSeconds == nil)
local rarities = { ByName = { Common = { Index = 1 }, Rare = { Index = 3 } }, Normalize = function(name) return name end }
local roll = loadSource(root .. "FishingRoll.lua", setmetatable({
	script = { Parent = { FishingConfig = config, PetFeatureConfig = { Enabled = false }, RarityConfig = rarities } },
	require = function(value) return value end,
}, { __index = getfenv() }))

for _, example in {
	{ -1, 1 }, { 0, 1 }, { 0.26, 1 }, { 1, 1 }, { 1.99, 1 }, { 2, 2 }, { 3.99999, 2 },
	{ 4, 3 }, { 7.99999, 3 }, { 8, 4 }, { 15.6, 4 }, { 16, 5 }, { 54.6, 6 }, { 1128.4, 11 },
	{ 0 / 0, 1 }, { math.huge, 1 },
} do
	assert(roll.GetLuckRollCount(example[1]) == example[2], "Unexpected reward roll count at " .. tostring(example[1]))
end

local function sequence(values)
	local calls = 0
	return {
		NextNumber = function()
			calls += 1
			return assert(values[calls], "Unexpected random draw " .. calls)
		end,
	}, function() assert(calls == #values, "Every supplied random draw must be consumed") end
end

local mutations = loadSource("src/ReplicatedFirst/Data/MutationsData.lua")
local ranges = roll.BuildMutationRanges(mutations)
local function mutation(luck, values, expected, customRanges)
	local random, done = sequence(values)
	assert(roll.RollMutationLucky(customRanges or ranges, luck, random) == expected, "Unexpected best mutation")
	done()
end
mutation(1, { 0.15 }, "Rainbow")
mutation(2, { 0.1, 0.01 }, "Diamond")
mutation(4, { 0.15, 0.01, 0.1 }, "Rainbow")
mutation(4, { 0.9, 0.9, 0.9 }, nil)

-- Four single draws yield 52.541679% mutations before thinning to exactly 50%.
local keep = 0.5 / 0.52541679
for _, sample in { { 0.01, "Golden" }, { 0.1, "Diamond" }, { 0.15, "Rainbow" } } do
	mutation(8, { sample[1], 0.9, 0.9, 0.9, keep - 1e-9 }, sample[2])
	mutation(8, { sample[1], 0.9, 0.9, 0.9, keep }, nil)
end
mutation(8, { 0.9, 0.9, 0.9, 0.9 }, nil) -- No extra cap draw for an ordinary fish.

-- Studio currently uses 20% for each mutation, so even one draw needs thinning.
local liveRates = roll.BuildMutationRanges({
	Golden = { MutationId = "Golden", Index = 1, Chance = 0.2, PriceRate = 1.5 },
	Diamond = { MutationId = "Diamond", Index = 2, Chance = 0.2, PriceRate = 2 },
	Rainbow = { MutationId = "Rainbow", Index = 3, Chance = 0.2, PriceRate = 2.5 },
})
mutation(1, { 0.4, 0.8 }, "Rainbow", liveRates)
mutation(1, { 0.4, 0.9 }, nil, liveRates)

local certain = roll.BuildMutationRanges({ Golden = { MutationId = "Golden", Index = 1, Chance = 1, PriceRate = 1.5 } })
mutation(1, { 0.2, 0.499999 }, "Golden", certain)
mutation(1, { 0.2, 0.5 }, nil, certain)
local equalToCap = roll.BuildMutationRanges({ Golden = { MutationId = "Golden", Index = 1, Chance = 0.5, PriceRate = 1.5 } })
mutation(1, { 0.499999 }, "Golden", equalToCap) -- Exactly the cap consumes no thinning draw.
mutation(1, {}, nil, {})
mutation(8, {}, nil, roll.BuildMutationRanges({ Golden = { MutationId = "Golden", Index = 1, Chance = 0, PriceRate = 1.5 } }))

local tied = roll.BuildMutationRanges({
	First = { MutationId = "First", Index = 1, Chance = 0.1, PriceRate = 2 },
	Second = { MutationId = "Second", Index = 2, Chance = 0.1, PriceRate = 2 },
	Last = { MutationId = "Last", Index = 3, Chance = 0.1, PriceRate = 1.5 },
})
-- Raise the cap temporarily to isolate score selection from the thinning gate.
config.MutationMaxChance = 1
mutation(4, { 0.1, 0.01, 0.2 }, "Second", tied)
config.MutationMaxChance = 0.5

local function weight(luck, values, expected)
	local random, done = sequence(values)
	local result = roll.RollWeightLucky(1, 1, luck, random)
	assert(math.abs(result - expected) < 1e-9, "Keep the largest independently generated size")
	done()
end
weight(1, { 0.2 }, 1)
weight(4, { 0.2, 0.19, 0.24, 0.3, 0.2 }, 1.5 ^ 6)
weight(2, { 0.19, 0.3, 0.2 }, 3.375)
local random, done = sequence(table.create(40, 0))
assert(math.abs(roll.RollWeight(1, 1, random) / 1.5 ^ 120 - 1) < 1e-12, "Forty successful steps remain the growth limit")
done()

local fish = { FishID = "Heavy", Model = "Heavy", Rarity = "Rare", DefaultWeight = 100, RollWeight = 1 }
local event = { FishID = "Event", Model = "Event", Rarity = "Event", DefaultWeight = 1, RollWeight = 1 }
local egg = { EggId = "HeavyEgg", Model = "HeavyEgg", DefaultWeight = 100, RollWeight = 1 }
local function hasModel() return true end
assert(#roll.GetPool({ fish, event }, 1, nil, hasModel) == 1, "Disable the rod cap but continue excluding event fish")
assert(#roll.GetEggPool({ egg }, 1, hasModel) == 1, "Disable egg weight filtering too")
assert(#roll.GetPool({ fish }, 1, { FilterRarity = "Rare", FilterRatio = 1 }, hasModel) == 0, "Keep bait filters without rod limits")
assert(#roll.GetPool({ fish }, 1, nil, function() return false end) == 0, "Keep model checks without rod limits")
config.RodWeightLimitEnabled = true
assert(#roll.GetPool({ fish }, 1, nil, hasModel) == 0, "Restore fish filtering when limits are enabled")
assert(#roll.GetEggPool({ egg }, 1, hasModel) == 0, "Restore egg filtering when limits are enabled")
weight(4, {}, 1)
local cappedRandom, cappedDone = sequence({ 0.19 })
assert(roll.RollWeight(1, 3.375, cappedRandom) == 3.375, "Allow growth exactly to the restored limit")
cappedDone()
