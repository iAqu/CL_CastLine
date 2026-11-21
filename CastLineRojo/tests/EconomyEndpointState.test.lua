local function read(path)
	local f = assert(io.open("src/ServerScriptService/Services/" .. path .. ".lua", "r"))
	local s = f:read("*a")
	f:close()
	return s
end

local function signal()
	return {
		calls = {},
		Connect = function(self, handler) self.handler = handler end,
		Fire = function(self, ...) table.insert(self.calls, {...}) end,
		FireAll = function(self, ...) table.insert(self.calls, {...}) end,
	}
end

local now, potionGrants = 100, 0
local profiles, delayed, services = {}, {}, {}
local players = {}
local data = {
	ProfileLoaded = signal(),
	GetProfile = function(_, player) return profiles[player] end,
	AdjustWins = function(_, player, amount) profiles[player].Data.Wins += amount return true end,
	AdjustDiamonds = function(_, player, amount) profiles[player].Data.Diamonds += amount return true end,
}
local constants = {
	SETTINGS_ID = { TRADE = "Trade", SOUND = "Sound", PERFORMANCE_MODE = "PerformanceMode" },
	TRADE_TIME = { LOGIN_WAIT_TIME = 1, REQUEST_COOLDOWN = 5, CONFIRM_COOLDOWN = 2 },
	NOTIFICATION = { GOT_POTION = "Got #POTION", TRADE_REQUEST_SEND = "Sent"},
	POTION_ID = { DOUBLE_WINS = "Cash", DOUBLE_EXP = "XP", DOUBLE_WINS_SPEED = "Speed", MUTATION = "Mutation" },
	CHEST_DAILY_CHANCE = { 1, 1, 1, 1, 1 }, CHEST_OPEN_COOLDOWN = 30,
}
local potionEnabled = true
services.PotionService = { AdjustPotionCount = function()
	potionGrants += 1
	coroutine.yield()
	return true
end }
local apis = {
	Players = {
		PlayerAdded = signal(), PlayerRemoving = signal(),
		GetPlayerByUserId = function(_, id) return players[id] end,
		GetPlayers = function() return players end,
	},
	ReplicatedStorage = { Packages = { Knit = {
		CreateService = function(s) return s end,
		CreateSignal = signal,
		GetService = function(name) return assert(services[name]) end,
	} }, Modules = {
		Constants = constants, LogHelper = {Print = function() end},
		PotionFeatureHelper = {IsAcquisitionEnabled = function() return potionEnabled end},
	} },
	ServerScriptService = { Services = { PlayerDataService = data } },
	ReplicatedFirst = { DataHelpers = { PurchaseDataHelper = {GetName = function(id) return id end} } },
}
local function loadService(name)
	return assert(load(read(name), name, "t", setmetatable({
		game = {CreatorId = 76, GetService = function(_, service) return assert(apis[service]) end},
		require = function(module) return assert(module) end,
		warn = function() end,
		os = {time = function() return now end, clock = function() return now end},
		task = {
			delay = function(seconds, handler, ...)
				local entry = { at = now + seconds, thread = coroutine.create(handler), args = {...} }
				table.insert(delayed, entry)
				return entry
			end,
			wait = function() return coroutine.yield() end,
			cancel = function(entry) entry.cancelled = true end,
		},
	}, {__index = getfenv()})))()
end
local function player(id)
	local user = {UserId = id, IsInGroupAsync = function()
		coroutine.yield()
		return true
	end}
	players[id] = user
	local profile = {
		alive = true,
		IsActive = function(self) return self.alive end,
		Data = {Wins = 0, Diamonds = 10, Settings = {Trade = true, Sound = true, PerformanceMode = "Auto"}},
	}
	profiles[user] = profile
	return user, profile
end
local function step(thread, ...)
	local ok, result = coroutine.resume(thread, ...)
	assert(ok, result)
	return result
end
local first, firstProfile = player(1)
local second, secondProfile = player(2)
local chest = loadService("ChestService")
local group = coroutine.create(function() return chest:ClaimGroupChest(first) end)
step(group)
assert(not chest:ClaimGroupChest(first).isSuccess)
assert(step(group).isSuccess and firstProfile.Data.Wins == 5000)
assert(not chest:ClaimGroupChest(first).isSuccess and firstProfile.Data.Wins == 5000)

local daily = coroutine.create(function() return chest:ClaimDailyChest(first) end)
step(daily)
assert(potionGrants == 1)
assert(chest:ClaimDailyChest(first)[1] == "Daily chest cooldown not reached." and potionGrants == 1)
assert(step(daily)[1]:match("^Got "))
now += 60
potionEnabled = false
chest:ClaimDailyChest(first)
assert(potionGrants == 1)

local settings = loadService("SettingsService")
settings:ChangeSetting(first, "unknown", true)
settings:ChangeSetting(first, "Sound", "false")
settings:ChangeSetting(first, "PerformanceMode", "unknown")
assert(firstProfile.Data.Settings.unknown == nil and firstProfile.Data.Settings.Sound == true)
assert(firstProfile.Data.Settings.PerformanceMode == "Auto")
settings:ChangeSetting(first, "PerformanceMode", "Quality")
settings:ChangeSetting(second, "Trade", false)
assert(firstProfile.Data.Settings.PerformanceMode == "Quality")

local trade = loadService("TradeService")
trade:KnitInit()
trade:KnitStart()
now += 10
assert(not trade:SendTradeRequest(first, 2).Success)
settings:ChangeSetting(second, "Trade", true)
assert(trade:SendTradeRequest(first, 2).Success)
trade.Client.AcceptTradeRequest.handler(second, 1)
trade.Client.TradeInputDiamond.handler(first, 3)
trade.Client.TradeAccept.handler(first, 1)
trade.Client.TradeAccept.handler(second, 1)
local countdown = delayed[#delayed]
trade.Client.TradeAccept.handler(second, 1)
assert(delayed[#delayed] == countdown, "Only one countdown per accepted offer")
trade.Client.TradeInputDiamond.handler(first, 4)
assert(countdown.cancelled and #trade.Client.TradeUnaccept.calls == 2)
trade.Client.TradeAccept.handler(first, 1)
trade.Client.TradeAccept.handler(second, 2)
assert(delayed[#delayed] == countdown, "A stale approval cannot confirm the new quote")
trade.Client.TradeAccept.handler(first, 2)
local final = delayed[#delayed]
assert(final ~= countdown)
step(final.thread, table.unpack(final.args))
step(final.thread)
assert(firstProfile.Data.Diamonds == 6 and secondProfile.Data.Diamonds == 14)
print("Reward concurrency, settings allowlist and trade revisions passed")
