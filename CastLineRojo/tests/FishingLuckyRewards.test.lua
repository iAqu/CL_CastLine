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
local rarities = {
	ByName = { Common = { Index = 1 }, Rare = { Index = 3 } },
	Normalize = function(name)
		return name
	end,
}
local roll = loadSource(
	root .. "FishingRoll.lua",
	setmetatable({
		script = {
			Parent = { FishingConfig = config, PetFeatureConfig = { Enabled = false }, RarityConfig = rarities },
		},
		require = function(value)
			return value
		end,
	}, { __index = getfenv() })
)

local mutations = loadSource("src/ReplicatedFirst/Data/MutationsData.lua")
local ranges = roll.BuildMutationRanges(mutations)
for _, luck in ipairs({ -1, 0, 1, 2, 10, 100000, math.huge }) do
	assert(roll.GetLuckRollCount(luck) == 1)
	local calls = 0
	local rng = {
		NextNumber = function()
			calls += 1
			return 0.15
		end,
	}
	assert(roll.RollMutationLucky(ranges, luck, rng) == "Rainbow" and calls == 1)
	calls = 0
	rng.NextNumber = function()
		calls += 1
		return 0.5
	end
	assert(roll.RollWeightLucky(10, math.huge, luck, rng) == 10 and calls == 1)
end
-- A configured baseline above 50% is no longer thinned by the retired luck cap.
local certain = roll.BuildMutationRanges({ Golden = { MutationId = "Golden", Index = 1, Chance = 1, PriceRate = 1.5 } })
assert(roll.RollMutationLucky(certain, 100, {
	NextNumber = function()
		return 0.99
	end,
}) == "Golden")
