local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", environment or getfenv()))()
end

local modules = "src/ReplicatedStorage/Modules/"
local config = loadSource(modules .. "FishingConfig.lua")
local rarityNames = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Divine", "Celestial", "Eternal", "Cosmic", "Exclusive" }
local rarities = {}
for index, name in ipairs(rarityNames) do
	rarities[name] = { Index = index }
end
local roll = loadSource(modules .. "FishingRoll.lua", setmetatable({
	script = { Parent = { FishingConfig = config, RarityConfig = { ByName = rarities, Normalize = function(name) return name end } } },
	require = function(value) return value end,
}, { __index = getfenv() }))
local function data(name)
	return loadSource("src/ReplicatedFirst/Data/" .. name .. ".lua")
end
local fishes, baits, rods = data("FishesData"), data("BaitsData"), data("RodsData")
local function hasModel() return true end
local none = roll.GetPool(fishes, "Area_1", nil, hasModel)
local uncommon = roll.GetPool(fishes, "Area_1", baits.Bait_103, hasModel)
assert(#none == 20 and #uncommon == 15)
assert(uncommon[1].fish.FishID == "Fish_106" and uncommon[1].weight == 250)
assert(uncommon[#uncommon].fish.FishID == "Fish_120" and uncommon[#uncommon].weight == 1)
assert(#roll.GetPool(fishes, "Area_1", { FilterRarity = "Exclusive", FilterRatio = 1 }, hasModel) == 0)
assert(roll.GetLuck(rods.Rod_101, baits.Bait_102, 100, 0) == 24)
assert(roll.GetLuck(rods.Rod_101, baits.Bait_102, 100, 120) == 96)
local sample = { NextNumber = function() return 0.5 end }
assert(roll.Choose(none, 1, sample).Rarity == "Common")
assert(rarities[roll.Choose(none, 96, sample).Rarity].Index >= rarities.Legendary.Index)

local now, cash, charges, grants = 1000, 100, 0, 0
local grantedId, grantedWeight
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
start.CFrame = { PointToObjectSpace = function() return { X = 0, Y = 0.5, Z = 0 } end }
local root = instance("BasePart")
root.Position, root.Size = vector(), { Y = 2 }
local player = { Character = instance("Model", {
	HumanoidRootPart = root,
	Humanoid = { Health = 100, HipHeight = 2, RigType = "R15" },
}) }
local workspace = instance("Workspace", { Areas = instance("Folder", { CastStartPart = start }) })
workspace.GetServerTimeNow = function() return now end

local profile = { Data = { Wins = cash } }
local client
local token, catchRound, clickAt
local services = {
	HttpService = { GenerateGUID = function() return "cast" end },
	Players = {},
	Workspace = workspace,
	ReplicatedFirst = { WaitForChild = function()
		return { WaitForChild = function(_, name) return ({ FishesData = fishes, BaitsData = baits, RodsData = rods })[name] end }
	end },
	ReplicatedStorage = {
		Packages = { Knit = { CreateService = function(value) return value end } },
		Modules = {
			FishingConfig = config,
			FishingAssets = { GetFish = hasModel, GetBait = function() return { Size = vector() } end },
			FishingBiteSequence = { GetBiteWindow = function(_, _, _, readyAt)
				return readyAt + 1, readyAt + 2
			end },
			FishingProjectileMath = { Distance = function() return 100 end, FlightTime = function() return 1 end },
			FishingRoll = roll,
		},
	},
}
local fishing = loadSource("src/ServerScriptService/Services/FishingService.lua", setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	Random = { new = function()
		return { NextNumber = function() return 0.5 end, NextInteger = function() return 1 end }
	end },
	Enum = { HumanoidRigType = { R6 = "R6" } },
	Vector3 = { yAxis = vector() },
	script = { Parent = {
		ItemGrantUtil = { Grant = function(_, id, options)
			grants += 1
			grantedId, grantedWeight = id, options.Weight
			assert(not client:Hook(player, token, catchRound, clickAt).ok, "Concurrent claim entered the grant path")
			return { ItemId = id }
		end },
		PlayerDataService = {
			GetProfile = function() return profile end,
			AdjustWins = function(_, _, amount)
				charges += 1
				profile.Data.Wins += amount
				return true
			end,
		},
	} },
}, { __index = getfenv() }))
client = fishing.Client

token = client:Begin(player).token
assert(not client:SelectBait(player, token, "Bait_106").ok, "Reject an unavailable bait")
assert(not client:SelectBait(player, token, "Bait_103").ok, "Reject an unaffordable bait")
assert(charges == 0 and profile.Data.Wins == 100)
assert(client:SelectBait(player, token, "Bait_102").ok)
assert(not client:SelectBait(player, token, "Bait_102").ok)
assert(charges == 1 and profile.Data.Wins == 0)
assert(client:Cast(player, token, 1).ok)
assert(not client:NextRound(player, token, 0).ok, "No fish before landing")
now += 5
local first = client:NextRound(player, token, 0)
assert(first.ok and first.round == 1 and first.luck == 24)
assert(fishes[first.fishId].Rarity ~= "Common")
assert(not client:Hook(player, token, first.round, now).ok and grants == 0)
assert(not client:NextRound(player, token, first.round).ok, "No reroll during the current round")
now = first.retryAt + 0.1
local second = client:NextRound(player, token, first.round)
assert(second.ok and second.luck > first.luck and charges == 1)
now = second.readyAt + 1.25
catchRound, clickAt = second.round, now
assert(not client:Hook(player, token, first.round, now).ok, "Old round cannot claim")
assert(client:Hook(player, token, catchRound, clickAt).ok)
assert(grants == 1 and grantedId == second.fishId and grantedWeight == fishes[second.fishId].DefaultWeight)
assert(not client:Hook(player, token, catchRound, clickAt).ok and grants == 1)

client:Cancel(player, token)
token = client:Begin(player).token
assert(client:SelectBait(player, token, "NONE").ok and charges == 1)
