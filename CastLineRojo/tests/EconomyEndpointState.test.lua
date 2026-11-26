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

local profiles = {}
local data = {
	GetProfile = function(_, player) return profiles[player] end,
	AdjustWins = function(_, player, amount) profiles[player].Data.Wins += amount return true end,
}
local constants = {
	SETTINGS_ID = { TRADE = "Trade", SOUND = "Sound", PERFORMANCE_MODE = "PerformanceMode" },
}
local apis = {
	ReplicatedStorage = { Packages = { Knit = {
		CreateService = function(s) return s end,
		CreateSignal = signal,
	} }, Modules = { Constants = constants, LogHelper = {Print = function() end} } },
	ServerScriptService = { Services = { PlayerDataService = data } },
}
local function loadService(name)
	return assert(load(read(name), name, "t", setmetatable({
		game = {CreatorId = 76, GetService = function(_, service) return assert(apis[service]) end},
		require = function(module) return assert(module) end,
		warn = function() end,
	}, {__index = getfenv()})))()
end
local function player(id)
	local user = {UserId = id, IsInGroupAsync = function()
		coroutine.yield()
		return true
	end}
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
local chest = loadService("ChestService")
local group = coroutine.create(function() return chest:ClaimGroupChest(first) end)
step(group)
assert(not chest:ClaimGroupChest(first).isSuccess)
assert(step(group).isSuccess and firstProfile.Data.Wins == 5000)
assert(not chest:ClaimGroupChest(first).isSuccess and firstProfile.Data.Wins == 5000)

assert(chest.Client.ClaimDailyChest == nil, "The retired daily chest endpoint must be absent")
assert(chest.Client.ClaimGroupChest and chest.Client.MarkGroupJoined, "Group chest entry points must remain available")

local settings = loadService("SettingsService")
settings:ChangeSetting(first, "unknown", true)
settings:ChangeSetting(first, "Sound", "false")
settings:ChangeSetting(first, "PerformanceMode", "unknown")
assert(firstProfile.Data.Settings.unknown == nil and firstProfile.Data.Settings.Sound == true)
assert(firstProfile.Data.Settings.PerformanceMode == "Auto")
settings:ChangeSetting(first, "PerformanceMode", "Quality")
assert(firstProfile.Data.Settings.PerformanceMode == "Quality")
settings:ChangeSetting(first, "Trade", false)
assert(firstProfile.Data.Settings.Trade == true, "Retired trade setting must retain its saved value without accepting new writes")
assert(not settings.Client.GetAllPlayersTradeSetting and not settings.EnableTrade, "Trade settings endpoints must be gone")
print("Group chest concurrency and settings allowlist passed")
