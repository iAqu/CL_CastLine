local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", environment or getfenv()))()
end

local modules = "src/ReplicatedStorage/Modules/"
local config = loadSource(modules .. "FishingConfig.lua")
-- Retain regression coverage for restoring rod limits. Disabled limits have separate tests.
assert(config.RodWeightLimitEnabled == false)
config.RodWeightLimitEnabled = true
local petFeatureConfig = loadSource(modules .. "PetFeatureConfig.lua")
local rarityNames = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Divine", "Celestial", "Eternal", "Cosmic", "Exclusive" }
local rarities = {}
for index, name in ipairs(rarityNames) do
	rarities[name] = { Index = index }
end
local roll = loadSource(modules .. "FishingRoll.lua", setmetatable({
	script = { Parent = { FishingConfig = config, PetFeatureConfig = petFeatureConfig, RarityConfig = { ByName = rarities, Normalize = function(name) return name end } } },
	require = function(value) return value end,
}, { __index = getfenv() }))
local function data(name)
	return loadSource("src/ReplicatedFirst/Data/" .. name .. ".lua")
end
local baits, rods = data("BaitsData"), data("RodsData")
-- Fixed species keep service regressions independent of live balance-table changes.
local fishes = {}
for _, entry in {
	{ "Fish_101", "Common", 0.5, 1000, 0 },
	{ "Fish_105", "Common", 8, 900, 0 },
	{ "Fish_106", "Common", 11, 800, 0 },
	{ "Fish_109", "Rare", 130, 700, 1 },
	{ "Fish_117", "Legendary", 500, 1, 3 },
	{ "Fish_201", "Uncommon", 0.5, 600, 0.5 },
	{ "Fish_203", "Uncommon", 1.5, 500, 0.5 },
} do
	fishes[entry[1]] = {
		FishID = entry[1], Model = if entry[1] == "Fish_203" then "Fish_109" else entry[1],
		Rarity = entry[2], DefaultWeight = entry[3], RollWeight = entry[4], LuckExponent = entry[5],
	}
end
local mutations = data("MutationsData")
local mutationRanges = roll.BuildMutationRanges(mutations)
for _, example in ipairs({
	{ 0, "Golden" },
	{ 0.099999, "Golden" },
	{ 0.10, "Diamond" },
	{ 0.149999, "Diamond" },
	{ 0.15, "Rainbow" },
	{ 0.169999, "Rainbow" },
	{ 0.17 },
	{ 0.999999 },
}) do
	local calls = 0
	local mutationId = roll.RollMutation(mutationRanges, {
		NextNumber = function()
			calls += 1
			return example[1]
		end,
	})
	assert(mutationId == example[2] and calls == 1, "Expected one mutation roll at " .. tostring(example[1]))
end
local function hasModel() return true end
local starterCap = rods.Rod_101.MaxWeight
local none = roll.GetPool(fishes, starterCap, nil, hasModel)
local uncommon = roll.GetPool(fishes, starterCap, baits.Bait_103, hasModel)
assert(#none == 4, "The starter rod must retain the four eligible fixture fish")
for _, entry in ipairs(none) do
	assert(entry.fish.DefaultWeight <= starterCap, "Exclude fish above the rod's cap")
end
assert(#roll.GetPool(fishes, 1_250, nil, hasModel) == 7, "The highest cap must allow every fixture fish")
local atCap = roll.GetPool({ fishes.Fish_105, fishes.Fish_106 }, 8, nil, hasModel)
assert(#atCap == 1 and atCap[1].fish == fishes.Fish_105, "Allow fish with a base weight exactly at the cap")
assert(#roll.GetPool(fishes, starterCap, nil, function()
	return false
end) == 0, "Exclude fish without a model")
assert(uncommon[1].fish == fishes.Fish_201 and uncommon[1].weight == fishes.Fish_201.RollWeight / 2,
	"Keep the bait's partial rarity filter")
assert(#roll.GetPool(fishes, starterCap, { FilterRarity = "Exclusive", FilterRatio = 1 }, hasModel) == 0,
	"Apply the bait filter after removing overweight fish")
assert(roll.GetLuck(rods.Rod_101, baits.Bait_102, 100) == 24)
assert(roll.GetLuck(rods.Rod_101, baits.Bait_102, 100, 0.5) == 12)
local sample = { NextNumber = function() return 0.5 end }
local rarityPool = roll.GetPool({ fishes.Fish_101, fishes.Fish_117 }, 260_000, nil, hasModel)
assert(roll.Choose(rarityPool, 1, sample).Rarity == "Common", "Use the configured roll weights at baseline luck")
assert(roll.Choose(rarityPool, 96, sample).Rarity == "Legendary", "Apply luck to the rarity roll")

local function weightRoll(defaultWeight, maxWeight, values)
	local calls = 0
	local weight = roll.RollWeight(defaultWeight, maxWeight, {
		NextNumber = function()
			calls += 1
			return assert(values[calls], "Unexpected weight roll")
		end,
	})
	assert(calls == #values, "Expected each supplied weight roll to be used")
	return weight
end

assert(weightRoll(1, 10, { 0.2 }) == 1, "A failed first step keeps the base weight")
assert(weightRoll(1, 10, { 0.19 }) == 3.375, "Keep the first full step when the second would exceed the cap")
assert(weightRoll(1, 3.375, { 0.19 }) == 3.375, "Allow a rolled weight exactly at the cap")
assert(weightRoll(10, 10, {}) == 10, "Skip growth when the base weight is already at the cap")
assert(weightRoll(1, 1_000_000, { 0.19, 0.24, 0.29, 0.34, 0.39, 0.39, 0.4 }) == 1.5 ^ 18,
	"Increase the growth chance up to 40 percent")
local maxStepsWeight = weightRoll(1, 1e23, table.create(40, 0))
assert(math.abs(maxStepsWeight / 1.5 ^ 120 - 1) < 1e-12, "Stop growth after 40 successful steps")

local now, cash, charges, grants = 1000, 100, 0, 0
local grantedId, grantedWeight, grantedMutationId
local mutationRolls = 0
local randomValue = 0.5
local function instance(class, children)
	return {
		IsA = function(_, kind) return class == kind end,
		FindFirstChild = function(_, name) return children and children[name] end,
		FindFirstChildOfClass = function(_, name) return children and children[name] end,
	}
end
local function vector()
	return setmetatable({}, {
		__mul = function() return vector() end,
		__sub = function() return vector() end,
	})
end
local start = instance("BasePart")
start.Size = { X = 10, Y = 1, Z = 10 }
local footZ = 0
start.CFrame = { PointToObjectSpace = function() return { X = 0, Y = 0.5, Z = footZ } end }
local root = instance("BasePart")
root.Position, root.Size = vector(), { Y = 2 }
local player = { Character = instance("Model", {
	HumanoidRootPart = root,
	Humanoid = { Health = 100, HipHeight = 2, RigType = "R15" },
}) }
local ownPlot = instance("Model", { FishingStartPart = start })
local assignedPlot = ownPlot
local workspace = instance("Workspace")
workspace.GetServerTimeNow = function() return now end

local fishHook = instance("BasePart")
fishHook.Size = vector()
local defaultBait = instance("Model", { FishHook = fishHook })
defaultBait.PrimaryPart = fishHook
local paidBait = instance("BasePart")
paidBait.Size = vector()
local baitFolder = {
	DefaultBait = defaultBait,
	[baits.Bait_101.Model] = instance("Folder", { ["1"] = paidBait }),
	[baits.Bait_102.Model] = instance("Folder", { ["1"] = paidBait }),
	[baits.Bait_103.Model] = instance("Folder", { ["1"] = paidBait }),
}

local profile = { Data = { Wins = cash } }
local profileReady = true
local purchaseSucceeds = true
local client
local token, catchRound, clickAt
local biteSize, biteFish
local services = {
	HttpService = { GenerateGUID = function() return "cast" end },
	Players = {},
	Workspace = workspace,
	ReplicatedFirst = { WaitForChild = function()
		return { WaitForChild = function(_, name)
			return ({ FishesData = fishes, BaitsData = baits, RodsData = rods, MutationsData = mutations })[name]
		end }
	end },
	ReplicatedStorage = instance("ReplicatedStorage", {
		Models = instance("Folder", {
			FishBait = instance("Folder", baitFolder),
		}),
	}),
}
services.ReplicatedStorage.Packages = { Knit = {
	CreateService = function(value) return value end,
	GetService = function(name)
		if name == "EventFishService" then return { GetActiveFish = function() return nil end } end
		if name == "PetService" then return { GetLuckMultiplier = function() return 1 end } end
		assert(name == "PlotSlotService")
		return { GetPlayerPlot = function(_, requester)
			assert(requester == player)
			return assignedPlot
		end }
	end,
} }
local fishingRoll = table.clone(roll)
function fishingRoll.RollMutationLucky(ranges, luck, rng)
	mutationRolls += 1
	return roll.RollMutationLucky(ranges, luck, rng)
end
services.ReplicatedStorage.Modules = {
	PetFeatureConfig = petFeatureConfig,
	FishingConfig = config,
	FishingBiteSequence = { GetBiteWindow = function(_, size, _, readyAt, _, _, _, fish)
		biteSize, biteFish = size, fish
		return readyAt + 1, readyAt + 2
	end },
	FishingProjectileMath = {
		FlightTime = function() return 1 end,
	},
	FishingRoll = fishingRoll,
}
local modulesEnv = setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	script = { Parent = services.ReplicatedStorage.Modules },
}, { __index = getfenv() })
local assets = loadSource(modules .. "FishingAssets.lua", modulesEnv)
local hook, model = assets.GetBait(nil)
assert(hook == fishHook and model == defaultBait, "NONE must resolve the entire default model and its hook")
local legacy, legacyModel = assets.GetBait(baits.Bait_101.Model)
assert(legacy == paidBait and legacyModel == nil, "Paid bait 1 must resolve the configured mesh")
assets.GetFish = hasModel
assets.GetRod = hasModel
services.ReplicatedStorage.Modules.FishingAssets = assets
services.ReplicatedStorage.Modules.RodInventory = loadSource(modules .. "RodInventory.lua", modulesEnv)
services.ReplicatedStorage.Modules.FishingSpotUtil = loadSource(modules .. "FishingSpotUtil.lua", setmetatable({
	Enum = { HumanoidRigType = { R6 = "R6" } },
	Vector3 = { yAxis = vector() },
}, { __index = getfenv() }))
local fishing = loadSource("src/ServerScriptService/Services/FishingService.lua", setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	Random = { new = function()
		return { NextNumber = function() return randomValue end, NextInteger = function() return 1 end }
	end },
	Enum = { HumanoidRigType = { R6 = "R6" } },
	Vector3 = { yAxis = vector() },
	script = { Parent = {
		ItemGrantUtil = { Grant = function(_, id, options)
			grants += 1
			grantedId, grantedWeight, grantedMutationId = id, options.Weight, options.MutationId
			assert(options.CountTowardTotalWeight, "Caught fish must count toward total weight")
			assert(not client:Hook(player, token, catchRound, clickAt).ok, "Concurrent claim entered the grant path")
			return { ItemId = id, Weight = options.Weight, MutationId = options.MutationId }
		end },
		PlayerDataService = {
			GetProfile = function() return if profileReady then profile else nil end,
			AdjustWins = function(_, _, amount)
				if not purchaseSucceeds then return false end
				charges += 1
				profile.Data.Wins += amount
				return true
			end,
		},
	} },
}, { __index = getfenv() }))
client = fishing.Client

profileReady = false
local loading = client:Begin(player)
assert(not loading.ok and loading.code == "ProfileNotReady")
profileReady = true

assignedPlot = nil
assert(not client:Begin(player).ok, "A player without an assigned plot cannot start fishing")
assignedPlot = instance("Model")
assert(not client:Begin(player).ok, "An assigned plot without a marker cannot start fishing")
assignedPlot = ownPlot
footZ = -1000
assert(not client:Begin(player).ok, "A player outside their own marker cannot start fishing")
footZ = 0
local begin = client:Begin(player)
assert(begin.ok and begin.rodId == "Rod_101", "Standing on the assigned marker must start fishing")
token = begin.token
assert(not client:SelectBait(player, "wrong-token", "Bait_102").ok)
assert(not client:SelectBait(player, token, "Bait_106").ok, "Reject an unavailable bait")
assert(not client:SelectBait(player, token, "Bait_103").ok, "Reject an unaffordable bait")
assets.GetFish = function(modelName)
	return modelName == fishes.Fish_106.Model
end
local emptyPool = client:SelectBait(player, token, "Bait_102")
assert(not emptyPool.ok and emptyPool.message == "No fish match this bait",
	"Report an empty pool when the only available model is overweight")
assert(charges == 0 and profile.Data.Wins == 100, "An empty pool must not charge for bait")
assets.GetFish = hasModel
now += 61
purchaseSucceeds = false
local rejectedPurchase = client:SelectBait(player, token, "Bait_102")
assert(not rejectedPurchase.ok and rejectedPurchase.message == "Could not purchase bait")
assert(charges == 0 and profile.Data.Wins == 100)
now += 61
purchaseSucceeds = true
local duplicateBegin = client:Begin(player)
assert(not duplicateBegin.ok and duplicateBegin.message == "Already fishing", "Keep the current bait selection open")
local selectedBait = client:SelectBait(player, token, "Bait_102")
assert(selectedBait.ok, "Allow paid bait after waiting and retrying")
assert(selectedBait.luck == roll.GetLuck(rods.Rod_101, baits.Bait_102, 30), "Return initial authoritative luck")
assert(not client:SelectBait(player, token, "Bait_102").ok)
assert(charges == 1 and profile.Data.Wins == 0)
now += 59
assert(client:Cast(player, token).distance == 30)
assert(not client:NextRound(player, token, 0).ok, "No fish before landing")
now += 5
local first = client:NextRound(player, token, 0)
assert(first.ok and first.round == 1 and first.luck == roll.GetLuck(rods.Rod_101, baits.Bait_102, 30))
assert(biteSize == paidBait.Size, "Use the configured paid bait dimensions for the bite window")
assert(biteFish == fishes[first.fishId], "Use the selected fish's config for the server bite window")
assert(fishes[first.fishId].Rarity ~= "Common")
assert(not client:Hook(player, token, first.round, now).ok and grants == 0 and mutationRolls == 0)
assert(not client:NextRound(player, token, first.round).ok, "No reroll during the current round")
now = first.retryAt + 0.1
randomValue = 0
local second = client:NextRound(player, token, first.round)
assert(second.ok and second.luck == first.luck and charges == 1)
now = second.readyAt + 1.25
catchRound, clickAt = second.round, now
assert(not client:Hook(player, token, first.round, now).ok, "Old round cannot claim")
local character = player.Character
local humanoid = character:FindFirstChildOfClass("Humanoid")
humanoid.Health = 0
assert(not client:Begin(player).ok and not client:Hook(player, token, catchRound, clickAt).ok and grants == 0)
humanoid.Health = 100
player.Character = instance("Model", {
	HumanoidRootPart = root,
	Humanoid = humanoid,
})
assert(not client:Hook(player, token, catchRound, clickAt).ok and grants == 0, "A replacement character cannot use the old token")
player.Character = character
local catch = client:Hook(player, token, catchRound, clickAt)
assert(catch.ok and catch.weight == grantedWeight, "Reveal the actual granted weight to the client")
assert(catch.mutationId == "Golden" and catch.mutationId == grantedMutationId, "Reveal the granted mutation")
assert(grants == 1 and grantedId == "Fish_201" and grantedId == second.fishId, "Grant the selected fish once")
assert(grantedWeight == 0.5 * 1.5 ^ 6 and grantedWeight <= starterCap, "Grant the rolled weight within the cap")
assert(not client:Hook(player, token, catchRound, clickAt).ok and grants == 1 and mutationRolls == 1)

client:Cancel(player, token)
profile.Data.OwnedRods = { Rod_105 = true }
profile.Data.EquippedRodId = "Rod_105"
begin = client:Begin(player)
assert(begin.ok and begin.rodId == "Rod_105")
now += 61
client:Cancel(player, begin.token)
local cancelledSelection = client:SelectBait(player, begin.token, "NONE")
assert(not cancelledSelection.ok and cancelledSelection.message == "Fishing selection unavailable")
begin = client:Begin(player)
assert(begin.ok, "Allow a new session after cancelling a long-open bait selection")
token = begin.token
profile.Data.EquippedRodId = "Rod_101"
assert(not client:SelectBait(player, token, "Bait_102").ok, "The session must use the original rod's bait selection")
defaultBait.PrimaryPart = nil
local missing = client:SelectBait(player, token, "NONE")
assert(not missing.ok and missing.message == "Bait model unavailable", "Reject an incomplete default model")
defaultBait.PrimaryPart = fishHook
assets.GetFish = function(modelName)
	return modelName == fishes.Fish_109.Model
end
assert(client:SelectBait(player, token, "NONE").ok and charges == 1)
assert(client:Cast(player, token).distance == 30, "Upgraded rods must cast the same fixed distance")
now += 5
local upgraded = client:NextRound(player, token, 0)
assert(biteSize == fishHook.Size, "Use the default hook dimensions for the bite window")
assert(upgraded.ok and upgraded.luck == roll.GetLuck(rods.Rod_105, nil, 30), "The session must keep the original rod's luck")
assert(upgraded.fishId == "Fish_109", "The session must keep the original rod's weight limit")
now = upgraded.readyAt + 1.25
catchRound, clickAt = upgraded.round, now
assert(client:Hook(player, token, catchRound, clickAt).ok, "Finish the cast with its original rod")
assert(grants == 2 and grantedId == upgraded.fishId and grantedWeight == 130, "Use the original rod's weight cap")

client:Cancel(player, token)
begin = client:Begin(player)
assert(begin.ok and begin.rodId == "Rod_101", "Start the next cast with the newly equipped rod")
assert(client:SelectBait(player, begin.token, "NONE").ok, "Allow the lighter fish that shares the model")
assert(client:Cast(player, begin.token).ok, "Cast with the newly equipped rod")
now += 5
local downgraded = client:NextRound(player, begin.token, 0)
assert(downgraded.ok and downgraded.fishId == "Fish_203", "Exclude the heavier fish using the new rod's cap")
client:Cancel(player, begin.token)

assets.GetFish = hasModel
begin = client:Begin(player)
assert(begin.ok and client:SelectBait(player, begin.token, "NONE").ok)
now += 60
assert(client:Cast(player, begin.token).ok, "Cast preparation must remain available after 60 seconds")
