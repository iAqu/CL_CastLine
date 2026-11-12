local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local prefix = "src/ReplicatedStorage/Modules/"
local config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local rarities = { ByName = { Common = { Index = 1 } }, Normalize = function(name) return name end }
local roll = assert(load(read(prefix .. "FishingRoll.lua"), "FishingRoll", "t", setmetatable({
	script = { Parent = { FishingConfig = config, RarityConfig = rarities } },
	require = function(value) return value end,
}, { __index = getfenv() })))()
local function near(actual, expected, message)
	assert(math.abs(actual - expected) < 1e-9, message)
end
near(roll.GetCastLuckMultiplier(0), 0.1, "The bottom of the meter must use 10%")
near(roll.GetCastLuckMultiplier(0.5), 0.55, "The middle of the meter must use 55%")
near(roll.GetCastLuckMultiplier(1), 1, "The top of the meter must use 100%")
assert(roll.GetCastLuckMultiplier(nil) == 1, "Legacy casts keep the full multiplier")
local rod = { LuckBoost = 0, MaxWeight = 100, BaitsSelect = { "Bait_Test" } }
local paidBait = { Model = "TestBait", Price = 10, LuckBoost = 1 }
local fish = { FishID = "Fish_Test", Model = "Test", Rarity = "Common", DefaultWeight = 1, RollWeight = 1, LuckExponent = 1 }
near(roll.GetLuck(rod, nil, 30, 0, 0.1), 0.13, "Actual luck can be below one")
near(roll.GetLuck(rod, nil, 30, 60, 0.55), 1.3 * config.WaitLuckMaxMultiplier * 0.55,
	"Waiting gains must multiply the locked cast result")

local now, guid, chosenLuck = 100, 0, nil
local root = { IsA = function(_, class) return class == "BasePart" end }
local humanoid = { Health = 100 }
local character = {
	FindFirstChild = function(_, name) return if name == "HumanoidRootPart" then root else nil end,
	FindFirstChildOfClass = function(_, class) return if class == "Humanoid" then humanoid else nil end,
}
local function signal()
	local callbacks = {}
	return {
		Connect = function(_, callback) table.insert(callbacks, callback) end,
		Fire = function(_, ...)
			for _, callback in ipairs(callbacks) do callback(...) end
		end,
	}
end
local player = { Character = character, CharacterRemoving = signal() }
local profile = { Data = { Wins = 1000 } }
local charges = 0
local Knit = {
	CreateService = function(service) return service end,
	GetService = function(name)
		if name == "PetService" then return {GetLuckMultiplier=function() return 1 end} end
		assert(name == "PlotSlotService", "Unexpected service dependency")
		return { GetPlayerPlot = function() return {} end }
	end,
}
local fishingRoll = roll
local originalChoose = roll.Choose
function fishingRoll.Choose(pool, luck, random)
	chosenLuck = luck
	return originalChoose(pool, luck, random)
end
local modules = {
	FishingConfig = config,
	FishingRoll = fishingRoll,
	FishingAssets = {
		GetBait = function() return { Size = { X = 1, Y = 1, Z = 1 } } end,
		GetFish = function() return {} end,
		GetEgg = function() return {} end,
	},
	FishingBiteSequence = { GetBiteWindow = function(_, _, startedAt, readyAt)
		return math.max(startedAt, readyAt) + 1, math.max(startedAt, readyAt) + 2
	end },
	FishingProjectileMath = { FlightTime = function() return 1 end },
	RodInventory = { GetEquippedId = function() return "Rod_Test" end },
	FishingSpotUtil = {
		GetStartPart = function() return {} end,
		Contains = function() return true end,
	},
}
local data = {
	EggsData = { Draw001 = {EggId="Draw001",Model="Draw001",RollWeight=1,DefaultWeight=1,LuckExponent=0} },
	FishesData = { Fish_Test = fish }, BaitsData = { Bait_Test = paidBait }, RodsData = { Rod_Test = rod }, MutationsData = {},
}
local dataFolder = { WaitForChild = function(_, name) return data[name] end }
local services = {
	Players = { PlayerAdded = signal(), PlayerRemoving = signal(), GetPlayers = function() return { player } end },
	ReplicatedFirst = { WaitForChild = function(_, name)
		assert(name == "Data", "Unexpected data folder")
		return dataFolder
	end },
	ReplicatedStorage = { Modules = modules, Packages = { Knit = Knit } },
	Workspace = { GetServerTimeNow = function() return now end },
	HttpService = { GenerateGUID = function()
		guid += 1
		return tostring(guid)
	end },
}
local grantResult
local service = assert(load(read("src/ServerScriptService/Services/FishingService.lua"), "FishingService", "t", setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	script = { Parent = {
		ItemGrantUtil = { Grant = function()
			return assert(grantResult, "Only catch response tests may grant fish")
		end },
		PlayerDataService = {
			GetProfile = function() return profile end,
			AdjustWins = function(_, requester, amount)
				assert(requester == player and amount == -paidBait.Price, "Charge only the selected bait's price")
				charges += 1
				profile.Data.Wins += amount
				return true
			end,
		},
	} },
	Random = { new = function()
		return {
			NextNumber = function() return 0.5 end,
			NextInteger = function(_, low) return low end,
		}
	end },
}, { __index = getfenv() })))()
local client = service.Client
local function prepare()
	local begin = client:Begin(player)
	assert(begin.ok, "Start a fresh fishing session")
	local selection = client:SelectBait(player, begin.token, "NONE")
	assert(selection.ok, "Select the free bait")
	near(selection.luck, 1.3, "Selection must return the unscaled luck ceiling")
	return begin.token
end

-- Capture discovery on the successful grant and carry it across the Hook API.
-- The fixture data stays fixed regardless of changes to the live fish tables.
for _, discoveryFlag in { true, false, "missing" } do
	local token = prepare()
	assert(client:Cast(player, token, 1).ok)
	now += 5
	local round = client:NextRound(player, token, 0)
	assert(round.ok)
	now = math.max(round.startedAt, round.readyAt) + 1.1
	grantResult = { Weight = 1, MutationId = "Golden",
		IsNewDiscovery = if discoveryFlag == "missing" then nil else discoveryFlag }
	local caught = client:Hook(player, token, round.round, now)
	assert(caught.ok and caught.weight == 1 and caught.mutationId == "Golden")
	assert(caught.isNewDiscovery == (discoveryFlag == true),
		"The catch response must preserve only a confirmed first discovery from the grant")
	assert(not client:Hook(player, token, round.round, now).ok,
		"Repeated hook requests must not grant the same discovery twice")
	client:Cancel(player, token)
end
grantResult = nil

for _, progress in { 0, 0.5, 1 } do
	local token = prepare()
	local cast = client:Cast(player, token, progress)
	assert(cast.ok and cast.distance == config.FixedCastDistance, "Luck must not change the fixed cast distance")
	local multiplier = roll.GetCastLuckMultiplier(progress)
	near(cast.luck, 1.3 * multiplier, "Confirm the locked luck in the cast response")
	assert(not client:Cast(player, token, 1).ok, "Duplicate casts must not overwrite the locked multiplier")
	now += 5
	local first = client:NextRound(player, token, 0)
	assert(first.ok, "Start the first fishing round")
	near(first.luck, cast.luck, "Use the locked luck exactly once")
	near(chosenLuck, first.luck, "Select the fish using the displayed luck")
	now = first.retryAt + 0.1
	local second = client:NextRound(player, token, first.round)
	assert(second.ok and second.luck > first.luck, "Retry rounds keep their waiting gain")
	near(second.luck, roll.GetLuck(rod, nil, config.FixedCastDistance,
		second.startedAt - first.startedAt, multiplier), "Retries must retain the same cast multiplier")
	near(chosenLuck, second.luck, "Retry selection must use the updated authoritative luck")
	client:Cancel(player, token)
end

local invalidToken = prepare()
for _, invalid in { -0.01, 1.01, 0 / 0, math.huge, -math.huge, "0.5", {} } do
	assert(not client:Cast(player, invalidToken, invalid).ok, "Reject invalid progress without consuming the cast")
end
assert(client:Cast(player, invalidToken, 0.5).ok, "A rejected value must leave the session ready to cast")
client:Cancel(player, invalidToken)
local legacy = prepare()
local response = client:Cast(player, legacy)
assert(response.ok, "Accept older callers without a meter value")
near(response.luck, 1.3, "A new session must not inherit the previous session's penalty")
client:Cancel(player, legacy)

-- Waiting for a meter position must not expire a paid or free preparation.
for _, baitId in { "NONE", "Bait_Test" } do
	local bait = if baitId == "NONE" then nil else paidBait
	for _, waited in { 59.999, 60, 61, 600 } do
		local balanceBefore, chargesBefore = profile.Data.Wins, charges
		local begin = client:Begin(player)
		assert(begin.ok and client:SelectBait(player, begin.token, baitId).ok)
		now += waited
		local replacement = client:Begin(player)
		assert(not replacement.ok and replacement.message == "Already fishing",
			"Waiting must not allow Begin to replace the preparation")
		assert(not client:SelectBait(player, begin.token, baitId).ok, "Waiting must not allow another bait purchase")
		local cast = client:Cast(player, begin.token, 0.5)
		assert(cast.ok and cast.distance == config.FixedCastDistance, "A valid preparation must not expire after " .. waited)
		near(cast.luck, roll.GetLuck(rod, bait, config.FixedCastDistance, 0, roll.GetCastLuckMultiplier(0.5)),
			"Preparation time must not add waiting luck before landing")
		assert(not client:Cast(player, begin.token, 1).ok, "A delayed cast must still be accepted only once")
		assert(profile.Data.Wins == balanceBefore - (if bait then bait.Price else 0)
			and charges == chargesBefore + (if bait then 1 else 0), "A paid bait must be charged exactly once")
		client:Cancel(player, begin.token)
	end
end

local selecting = client:Begin(player)
assert(selecting.ok and not client:Cast(player, selecting.token, 0.5).ok, "Cast must still require bait selection")
client:Cancel(player, selecting.token)

local guarded = prepare()
now += 600
assert(not client:Cast(player, "wrong-token", 0.5).ok, "Waiting must not bypass token validation")
humanoid.Health = 0
assert(not client:Cast(player, guarded, 0.5).ok, "A dead character must not cast")
humanoid.Health = 100
player.Character = table.clone(character)
assert(not client:Cast(player, guarded, 0.5).ok, "A replacement character must not use an old token")
player.Character = character
for _, invalid in { -0.01, 1.01, 0 / 0, math.huge, -math.huge, "0.5", {} } do
	assert(not client:Cast(player, guarded, invalid).ok, "Waiting must not bypass progress validation")
end
assert(client:Cast(player, guarded, 0.5).ok, "Rejected requests must not consume a valid delayed cast")
client:Cancel(player, guarded)

local cancelled = prepare()
now += 600
client:Cancel(player, cancelled)
assert(not client:Cast(player, cancelled, 0.5).ok, "A cancelled preparation must remain unavailable")
local fresh = prepare()
assert(not client:Cast(player, cancelled, 0.5).ok, "An old token must not affect a new preparation")
assert(client:Cast(player, fresh, 0.5).ok, "Cancellation must allow a fresh preparation")
client:Cancel(player, fresh)

service:KnitStart()
local removedCharacter = prepare()
now += 600
player.CharacterRemoving:Fire(character)
assert(not client:Cast(player, removedCharacter, 0.5).ok, "Character removal must clear a long-open preparation")
local removedPlayer = prepare()
now += 600
services.Players.PlayerRemoving:Fire(player)
assert(not client:Cast(player, removedPlayer, 0.5).ok, "Player removal must clear a long-open preparation")
