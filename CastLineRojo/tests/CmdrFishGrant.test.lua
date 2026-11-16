local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	local chunk = assert(loadstring(source, path))
	if environment then
		setfenv(chunk, setmetatable(environment, { __index = getfenv() }))
	end
	return chunk()
end

local root = "src/ServerScriptService/Cmdr/"
local util = {
	MakeDictionary = function(values)
		local result = {}
		for _, value in ipairs(values) do result[value] = true end
		return result
	end,
}
local registry = loadSource("src/ServerScriptService/Libs/Cmdr/Shared/Registry.lua", {
	game = { GetService = function() return {} end },
	script = { Parent = { Util = util } },
	require = function(value) return value end,
})({})
registry:RegisterCommandObject(loadSource(root .. "Commands/GiveItem.lua"))
local fishFile = io.open(root .. "Commands/GiveFish.lua", "r")
if fishFile then
	fishFile:close()
	registry:RegisterCommandObject(loadSource(root .. "Commands/GiveFish.lua"))
end

assert(table.find(registry:GetCommandNames(), "giveFish"),
	"giveFish must appear in Cmdr help and command autocomplete, which omit aliases")
assert(table.find(registry:GetCommandNames(), "giveItem"), "Keep giveItem discoverable")
local fish = assert(registry:GetCommand("giveFish"))
assert(fish.Name == "giveFish" and fish.Group == "Admin")
assert(fish.Args[1].Type == "player" and fish.Args[2].Type == "item")
assert(fish.Args[3].Default == 1)

local calls, player = 0, { Name = "Receiver" }
local grant = { Grant = function(target, id, options)
	assert(target == player and id == "Fish_101" and options.CountTowardTotalWeight == true)
	calls += 1
	return {}
end }
local itemRun = loadSource(root .. "Commands/GiveItemServer.lua", {
	game = { GetService = function() return { Services = { ItemGrantUtil = grant } } end },
	require = function(value) return value end,
})
local fishRun = loadSource(root .. "Commands/GiveFishServer.lua", {
	game = { GetService = function()
		return { Cmdr = {} }
	end },
	script = { Parent = { GiveItemServer = itemRun } },
	require = function(value) return value end,
})
assert(fishRun == itemRun, "Both commands must use the same server grant handler")
assert(fishRun({}, player, "Fish_101") == "Gave 1 Fish_101 to Receiver" and calls == 1)
calls = 0
assert(fishRun({}, player, "Fish_101", 3) == "Gave 3 Fish_101 to Receiver" and calls == 3)

local beforeRun
loadSource(root .. "Hooks/Permission.lua")({ RegisterHook = function(_, _, callback)
	beforeRun = callback
end })
assert(beforeRun({ Name = fish.Name, Executor = { UserId = 4556553540 } }) == nil)
assert(beforeRun({ Name = fish.Name, Executor = { UserId = 123456789 } }) ~= nil,
	"Ordinary players must not be allowed to grant fish")
