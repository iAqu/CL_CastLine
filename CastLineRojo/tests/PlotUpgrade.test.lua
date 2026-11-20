local helper = require("./helpers/PlotUpgrades")
local upgrades = helper.data
local function read(path)
	local f = assert(io.open(path, "r"))
	local text = f:read("*a")
	f:close()
	return text
end
local function loadSource(path, env)
	return assert(load(read(path), path, "t", setmetatable(env or {}, { __index = getfenv() })))()
end
local placements = loadSource("src/ReplicatedStorage/Modules/PlotPlacementUtil.lua", helper.environment)
for level = 0, 5 do
	assert(upgrades.Get(level).Capacity == 10 + level * 2)
	assert(placements.GetCapacity({ PlotUpgradeLevel = level }) == upgrades.Get(level).Capacity)
end
assert(upgrades.Get(0).Width == 60 and upgrades.Get(1).Width == 80 and upgrades.Get(2).Width == 100)
assert(upgrades.Get(5).Width == 100 and upgrades.Get(5).Depth == 56)
assert(upgrades.NormalizeLevel(nil) == 0 and upgrades.NormalizeLevel(0 / 0) == 0)
assert(upgrades.NormalizeLevel(999) == 5 and upgrades.GetNext(5) == nil)
-- Run the actual profile migration with stringified high slots, duplicates and invalid keys.
local source = read("src/ServerScriptService/Services/PlayerDataService.lua")
local first = assert(source:find("local function migratePlotHome", 1, true))
local last = assert(source:find("function PlayerDataService:GetProfile", first, true))
local migrate = assert(load(
	source:sub(first, last - 1) .. "\nreturn migratePlotHome",
	"migration",
	"t",
	setmetatable({
		ReplicatedStorage = { Modules = { PlotUpgradeData = upgrades } },
		PlotPlacementUtil = placements,
		require = function(value)
			return value
		end,
	}, { __index = getfenv() })
))()
local saved =
	{ PlotUpgradeLevel = 5, Items = { a = {}, b = {} }, PlotPlacements = { ["11"] = "a", ["20"] = "b", ["21"] = "a" } }
migrate(saved)
assert(saved.PlotPlacements[11] == "a" and saved.PlotPlacements[20] == "b" and saved.PlotPlacements[21] == nil)
local legacy = { Items = { a = {} }, PlotPlacements = { ["10"] = "a" } }
migrate(legacy)
assert(legacy.PlotUpgradeLevel == 0 and legacy.PlotPlacements[10] == "a")

local function position(x)
	return setmetatable({ X = x }, {
		__sub = function(a, b)
			return { Magnitude = math.abs(a.X - b.X) }
		end,
	})
end
local data = { Wins = 2e11, PlotUpgradeLevel = 0 }
local profile = { Data = data }
local players = {}
local transitionEvents = {}
local transitionConfig = loadSource("src/ReplicatedStorage/Modules/PlotUpgradeTransitionConfig.lua")
local waitHook
local nextId = 0
local owner, currentLevel, refreshes = 42, 0, 0
local root = { Position = position(0) }
local humanoid = { Health = 100 }
local sign = {
	FindFirstChild = function()
		return { Position = position(0) }
	end,
}
local plot = {
	GetAttribute = function()
		return owner
	end,
	FindFirstChild = function()
		return sign
	end,
}
local attributes = {}
local cash = {}
local player = {
	UserId = 42,
	Parent = players,
	Character = {
		FindFirstChild = function()
			return root
		end,
		FindFirstChildOfClass = function()
			return humanoid
		end,
	},
	SetAttribute = function(_, key, value)
		attributes[key] = value
	end,
	FindFirstChild = function()
		return {
			FindFirstChild = function()
				return cash
			end,
		}
	end,
}
local canCharge, throwCharge, failApply, preflight, nested = true, false, false, true, nil
local service
local appearance = {
	Preflight = function()
		return preflight, "Missing fence"
	end,
	Apply = function(_, config)
		if failApply and config.Level > currentLevel then
			error("Injected layout error")
		end
		currentLevel = config.Level
		if nested then
			local fn = nested
			nested = nil
			fn()
		end
	end,
}
local profileAvailable = true
local dataService = {
	GetProfile = function()
		return if profileAvailable then profile else nil
	end,
	AdjustWins = function(_, _, amount)
		if not canCharge then
			return false
		end
		data.Wins += amount
		if throwCharge then
			error("Injected charge error")
		end
		return true
	end,
	Client = { WinsChanged = { Fire = function() end } },
}
local services = {
	PlotSlotService = {
		GetPlayerPlot = function()
			return plot
		end,
	},
	PlotFishService = {
		RefreshInventoryIncome = function()
			refreshes += 1
		end,
	},
}
service = loadSource("src/ServerScriptService/Services/PlotUpgradeService.lua", {
	game = {
		GetService = function(_, name)
			if name == "ReplicatedStorage" then
				return {
					Packages = {
						Knit = {
							CreateSignal = function()
								return {
									FireAll = function(_, phase, plot, id, level)
										table.insert(
											transitionEvents,
											{ phase = phase, plot = plot, id = id, level = level }
										)
									end,
								}
							end,
							CreateService = function(value)
								return value
							end,
							GetService = function(key)
								return services[key]
							end,
						},
					},
					Modules = {
						PlotUpgradeData = upgrades,
						PlotAppearance = appearance,
						PlotUpgradeTransitionConfig = transitionConfig,
					},
				}
			end
			if name == "Players" then
				return players
			end
			if name == "HttpService" then
				return {
					GenerateGUID = function()
						nextId += 1
						return tostring(nextId)
					end,
				}
			end
			return {}
		end,
	},
	task = {
		wait = function(duration)
			assert(duration == transitionConfig.CoverDelay)
			if waitHook then
				local fn = waitHook
				waitHook = nil
				fn()
			end
		end,
	},
	script = { Parent = {
		PlayerDataService = dataService,
		OnboardingAnalyticsService = { Growth = function() end },
	} },
	require = function(value)
		return value
	end,
	warn = function() end,
})
local balance = data.Wins
profileAvailable = false
assert(not service:RequestUpgrade(player, 0).ok)
profileAvailable = true
owner = 99
assert(not service:RequestUpgrade(player, 0).ok)
owner = 42
root.Position = position(23)
assert(not service:RequestUpgrade(player, 0).ok)
root.Position = position(0)
humanoid.Health = 0
assert(not service:RequestUpgrade(player, 0).ok)
humanoid.Health = 100
assert(not service:RequestUpgrade(player, "0").ok and not service:RequestUpgrade(player, -1).ok)
data.Wins = 9999
assert(not service:RequestUpgrade(player, 0).ok and data.Wins == 9999)
data.Wins = balance
preflight = false
assert(not service:RequestUpgrade(player, 0).ok and data.Wins == balance)
preflight = true
failApply = true
assert(not service:RequestUpgrade(player, 0).ok and data.Wins == balance and data.PlotUpgradeLevel == 0)
failApply = false
canCharge = false
assert(not service:RequestUpgrade(player, 0).ok and currentLevel == 0 and data.Wins == balance)
canCharge = true
throwCharge = true
assert(not service:RequestUpgrade(player, 0).ok and currentLevel == 0 and data.Wins == balance)
throwCharge = false
-- Every condition is rechecked after the white cover delay; failed attempts publish Cancel.
local function cancelledDuringWait(change, undo)
	local oldBalance = data.Wins
	local eventCount = #transitionEvents
	waitHook = change
	local response = service:RequestUpgrade(player, 0)
	assert(not response.ok)
	assert(#transitionEvents == eventCount + 2)
	assert(transitionEvents[eventCount + 1].phase == "Begin" and transitionEvents[eventCount + 2].phase == "Cancel")
	assert(transitionEvents[eventCount + 1].id == transitionEvents[eventCount + 2].id)
	undo()
	data.Wins = oldBalance
end
cancelledDuringWait(function()
	data.Wins = 0
end, function() end)
cancelledDuringWait(function()
	profileAvailable = false
end, function()
	profileAvailable = true
end)
cancelledDuringWait(function()
	owner = 99
end, function()
	owner = 42
end)
cancelledDuringWait(function()
	root.Position = position(23)
end, function()
	root.Position = position(0)
end)
cancelledDuringWait(function()
	humanoid.Health = 0
end, function()
	humanoid.Health = 100
end)
cancelledDuringWait(function()
	player.Parent = nil
end, function()
	player.Parent = players
end)
cancelledDuringWait(function()
	data.PlotUpgradeLevel = 1
end, function()
	data.PlotUpgradeLevel = 0
end)
local previousProfile = profile
cancelledDuringWait(function()
	profile = { Data = data }
end, function()
	profile = previousProfile
end)
waitHook = function()
	assert(not service:RequestUpgrade(player, 0).ok, "The cover delay must keep the purchase locked")
end
throwCharge = true
local beforeIncome = data.Wins
waitHook = function()
	data.Wins += 100
end
assert(
	not service:RequestUpgrade(player, 0).ok and data.Wins == beforeIncome + 100,
	"Rollback must retain money earned during the delay"
)
throwCharge = false
data.Wins = beforeIncome
waitHook = function()
	assert(not service:RequestUpgrade(player, 0).ok, "Concurrent requests cannot enter the delayed commit")
end
nested = function()
	assert(not service:RequestUpgrade(player, 0).ok, "Reentrant upgrade must be locked")
end
for level = 1, 5 do
	local old = data.Wins
	assert(service:RequestUpgrade(player, level - 1).ok)
	assert(data.Wins == old - upgrades.Get(level).Price and data.PlotUpgradeLevel == level)
	assert(attributes.PlotCapacity == upgrades.Get(level).Capacity and currentLevel == level)
	assert(not service:RequestUpgrade(player, level - 1).ok, "A duplicate expected level cannot buy twice")
end
assert(refreshes == 5 and not service:RequestUpgrade(player, 5).ok)
local appliedCount = 0
for index, event in transitionEvents do
	if event.phase == "Applied" then
		appliedCount += 1
		local begin = transitionEvents[index - 1]
		assert(begin.phase == "Begin" and begin.id == event.id and begin.plot == event.plot)
	end
end
assert(appliedCount == 5, "Only successful purchases publish Applied")
service:ResetPlot(plot)
assert(currentLevel == 0)
-- A queued release callback must not reset a plot already claimed by a new owner.
local fishSource = read("src/ServerScriptService/Services/PlotFishService.lua")
local releaseStart = assert(fishSource:find("slotService.SlotReleased:Connect(function(plot)", 1, true))
local bodyStart = assert(fishSource:find("\n", releaseStart, true))
local bodyEnd = assert(fishSource:find("\n\tend)\n\n\tlocal function initialize", bodyStart, true))
local resets = 0
local releasedOwner = 42
local onRelease = assert(
	load(
		"return function(plot)" .. fishSource:sub(bodyStart, bodyEnd - 1) .. "\nend",
		"release",
		"t",
		setmetatable({
			activeFish = {},
			PlotFishMotion = { FOLDER_NAME = "PlacedFish" },
			Knit = {
				GetService = function()
					return {
						ResetPlot = function()
							resets += 1
						end,
					}
				end,
			},
		}, { __index = getfenv() })
	)
)()
local reused = {
	GetAttribute = function()
		return releasedOwner
	end,
	FindFirstChild = function()
		return nil
	end,
}
onRelease(reused)
assert(resets == 0, "A newly owned plot must retain its upgraded appearance")
releasedOwner = 0
onRelease(reused)
assert(resets == 1, "An empty plot must reset after fish cleanup")
print("PlotUpgrade.test.lua passed")
