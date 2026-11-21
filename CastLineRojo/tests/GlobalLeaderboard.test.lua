local file = assert(io.open("src/ReplicatedStorage/Modules/GlobalLeaderboardConfig.lua"))
local source = file:read("*a")
file:close()

local modules = {
	NumberUtil = {},
	WeightFormat = require("../src/ReplicatedStorage/Modules/WeightFormat"),
}
local config = assert(load(source, "GlobalLeaderboardConfig", "t", setmetatable({
	game = { GetService = function() return { Modules = modules } end },
	require = function(module) return module end,
}, { __index = getfenv() })))()

local legacy = { TotalItemWeightTenths = 9000, TotalCashEarned = 150, PlayTime = 450 }
assert(legacy[config.Boards.Weight.Field] == nil and legacy[config.Boards.Fish.Field] == nil)
assert(config.NormalizeScore(legacy[config.Boards.Weight.Field]) == 0)
assert(legacy[config.Boards.Wins.Field] == 150 and legacy[config.Boards.Playtime.Field] == 450)
assert(config.Boards.Weight.Store ~= "GlobalLeaderboard_ItemWeightTenths_V1")
assert(config.Boards.Wins.Store == "GlobalLeaderboard_CashEarned_V2")

config.RecordCatch(legacy, 4.34)
config.RecordCatch(legacy, 22.16)
config.RecordCatch(legacy, 7.86)
assert(legacy.TotalFishCaught == 3 and legacy.MaxCaughtFishWeightTenths == 222)
assert(legacy.TotalItemWeightTenths == 9000)

assert(config.FormatValue("Weight", 98) == "9.8 kg")
assert(config.FormatValue("Weight", 100) == "10 kg")
assert(config.FormatValue("Weight", 115) == "12 kg")
assert(config.FormatValue("Weight", 12345670) == "1234567 kg")

for slot = 1, 6 do
	local left, right = config.GetNeighborGaps(slot)
	local leftNeighbor = (slot - 2) % 6 + 1
	assert(left == ("Gap_%d_%d"):format(leftNeighbor, slot))
	assert(right == ("Gap_%d_%d"):format(slot, slot % 6 + 1))
end
for _, invalid in { 0, 7, 2.5, "3", 0/0 } do
	assert(config.GetNeighborGaps(invalid) == nil)
end
assert(config.GetNeighborGaps(nil) == nil)

local file = assert(io.open("src/ServerScriptService/Services/GlobalLeaderboardService.lua"))
local leaderboardSource = file:read("*a")
file:close()
local broadcasts = 0
local players = {
	GetPlayerByUserId = function(_, id) return {DisplayName = tostring(id)} end,
	GetPlayers = function() return {} end,
}
local storage = {Modules = {GlobalLeaderboardConfig = config, Constants = {}}, Packages = {Knit = {
	CreateService = function(spec) return spec end,
	CreateSignal = function()
		return {FireAll = function() broadcasts += 1 end}
	end,
}}}
local service = assert(load(leaderboardSource, "GlobalLeaderboardService", "t", setmetatable({
	game = {GetService = function(_, name)
		if name == "Players" then return players end
		if name == "ReplicatedStorage" then return storage end
		if name == "ServerScriptService" then return {Services = {PlayerDataService = {}}} end
		return {}
	end},
	require = function(module) return assert(module) end,
	warn = function() end,
}, {__index = getfenv()})))()
local score, readFailed = 100, false
for _, boardType in config.Types do
	service._Stores[boardType] = {GetSortedAsync = function()
		assert(not readFailed)
		return {GetCurrentPage = function()
			return {{key = "10", value = score}}
		end}
	end}
end
function service:UpdateDancingPlayers() end
service:UpdateLeaderboards()
assert(service._Rankings.Revision == 1 and broadcasts == 2)
service:UpdateLeaderboards()
assert(service._Rankings.Revision == 1 and broadcasts == 2, "An unchanged leaderboard must not be resent")
readFailed = true
service:UpdateLeaderboards()
assert(service._Rankings.Revision == 1 and service._Rankings.Boards.Wins[1].Value == 100)
readFailed, score = false, 101
service:UpdateLeaderboards()
assert(service._Rankings.Revision == 2 and broadcasts == 4)
