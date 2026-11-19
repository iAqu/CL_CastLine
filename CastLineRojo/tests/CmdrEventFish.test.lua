local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end
local root = "src/ServerScriptService/Cmdr/"
local result, calls = { DisplayName = "Hell Shark", FishID = "Fish_003" }, 0
local services = {
	ReplicatedStorage = { Modules = { EventFishConfig = { Duration = 17 } } },
	ServerScriptService = { Services = { EventFishService = { StartEvent = function()
		calls += 1
		return result
	end } } },
}
local globals = {
	game = { GetService = function(_, name) return assert(services[name]) end },
	require = function(value) return value end,
}
local command = loadSource(root .. "Commands/StartEventFish.lua", globals)
assert(command.Name == "startEventFish" and command.Aliases[1] == "sef" and #command.Args == 0)
assert(command.Group == "Admin" and command.Description:find("17 seconds", 1, true))
local run = loadSource(root .. "Commands/StartEventFishServer.lua", globals)
local message = run({})
assert(message:find("Fish_003", 1, true) and message:find("17 seconds", 1, true) and calls == 1)
result = nil
assert(run({}):find("not started", 1, true) and calls == 2)
local beforeRun
loadSource(root .. "Hooks/Permission.lua")({ RegisterHook = function(_, kind, callback)
	assert(kind == "BeforeRun")
	beforeRun = callback
end })
assert(beforeRun({ Name = command.Name, Executor = { UserId = 4556553540 } }) == nil)
assert(beforeRun({ Name = command.Name, Executor = { UserId = 123456789 } }) ~= nil,
	"Adding this command must not bypass the existing owner permission hook")
