local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local prefix = "src/ReplicatedStorage/Modules/"
local config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local petFeatureConfig = assert(loadstring(read(prefix .. "PetFeatureConfig.lua")))()
assert(not petFeatureConfig.Enabled, "The first release must disable pet gameplay")
local rarities = {
	ByName = { Common = { Index = 1 } },
	Normalize = function(name)
		return name
	end,
}
local roll = assert(load(
	read(prefix .. "FishingRoll.lua"),
	"FishingRoll",
	"t",
	setmetatable({
		script = { Parent = { FishingConfig = config, PetFeatureConfig = petFeatureConfig, RarityConfig = rarities } },
		require = function(value)
			return value
		end,
	}, { __index = getfenv() })
))()
local function near(actual, expected, message)
	assert(math.abs(actual - expected) < 1e-9, message)
end
near(roll.GetCastLuckMultiplier(0), 0.1, "The bottom of the meter must use 10%")
near(roll.GetCastLuckMultiplier(0.5), 0.55, "The middle of the meter must use 55%")
near(roll.GetCastLuckMultiplier(1), 1, "The top of the meter must use 100%")
assert(roll.GetCastLuckMultiplier(nil) == 1, "Legacy casts keep the full multiplier")
local rod = { LuckBoost = 0, MaxWeight = 100, BaitsSelect = { "Bait_Test" } }
local paidBait = { Model = "TestBait", Price = 10, LuckBoost = 1 }
local fish =
	{ FishID = "Fish_Test", Model = "Test", Rarity = "Common", DefaultWeight = 1, RollWeight = 1, LuckExponent = 1 }
near(roll.GetLuck(rod, nil, 30, 0.1), 0.13, "Actual luck can be below one")
near(roll.GetLuck(rod, nil, 30, 0.55), 1.3 * 0.55, "Use only the locked cast result")

local new = require("./helpers/FishingHarness")
for _, luck in ipairs({ 0, 1, 2, 100000 }) do
	local h = new()
	h.rods.Rod_101.LuckBoost = luck
	h.baits.Bait_102.LuckBoost = luck
	h.begin("Bait_102")
	h.cast()
	assert(h.hook().ok)
	assert(
		h.lastFish == "Fish_103" and h.lastOptions.Weight == 3 and h.lastOptions.MutationId == "Golden",
		"Luck must not alter species, weight or mutation"
	)
end
for _, invalid in ipairs({ -0.01, 1.01, 0 / 0, math.huge, -math.huge, "0.5", {} }) do
	local h = new()
	h.begin("NONE")
	assert(not h.client:Cast(h.player, h.token, invalid).ok, "Invalid meter progress")
end
local h = new()
h.begin("NONE")
h.now += 600
assert(not h.client:Cast(h.player, "wrong-token", 0.5).ok)
assert(h.client:Cast(h.player, h.token, 0.5).ok, "Delayed cast remains valid")
h.now += 5
h.round = h.client:NextRound(h.player, h.token, 0)
assert(h.round.ok)
-- Events are decided at cast time, then remain fixed for retries in that session.
local event = new()
event.activeEvent = event.fishes.Event
event.begin("Bait_104")
event.cast()
assert(event.round.fishId == "Event")
event.activeEvent = nil
event.now = event.round.retryAt + 0.1
event.round = event.client:NextRound(event.player, event.token, event.round.round)
assert(event.round.fishId == "Event" and event.hook().mutationId == "Diamond")
assert(event.profile.Data.FishingProgress.Count == 0 and event.profile.Data.FishingProgress.Rods.Rod_101.MissHigh == 0)
event.cancel()
event.reload()
event.begin("NONE")
assert(event.cast().fishId ~= "Event", "A new session must use the event active at its own cast")
local later = new()
later.begin("NONE")
assert(later.client:Cast(later.player, later.token, 1).ok)
later.activeEvent = later.fishes.Event
later.now += 5
later.round = later.client:NextRound(later.player, later.token, 0)
assert(later.round.fishId ~= "Event", "An event starting after cast cannot replace the pending fish")
