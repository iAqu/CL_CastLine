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
local player = { Name = "Receiver" }
local configs = {
	PetsData = { Pet002 = {}, Pet001 = {} },
	EggsData = { Draw002 = {}, Draw001 = {} },
}
local services = {
	ReplicatedFirst = { Data = configs },
	ServerScriptService = { Services = {} },
	TextService = {},
}
local environment = {
	game = {
		GetService = function(_, name)
			return assert(services[name], name)
		end,
	},
	require = function(value)
		return value
	end,
}
local util = loadSource("src/ServerScriptService/Libs/Cmdr/Shared/Util.lua", environment)

for _, spec in ipairs({
	{ command = "GivePet", name = "givePet", kind = "pet", service = "PetService", method = "GivePet", id = "Pet001", otherId = "Pet002" },
	{ command = "GiveEgg", name = "giveEgg", kind = "egg", service = "EggService", method = "GiveEgg", id = "Draw001", otherId = "Draw002" },
}) do
	local definition = loadSource(root .. "Commands/" .. spec.command .. ".lua")
	assert(definition.Name == spec.name and definition.Group == "Admin")
	assert(definition.Args[1].Type == "player" and definition.Args[2].Type == spec.kind)
	assert(definition.Args[3].Type == "integer" and definition.Args[3].Default == 1)

	local registered
	loadSource(root .. "Types/" .. spec.kind .. ".lua", environment)({
		Cmdr = { Util = util },
		RegisterType = function(_, name, value)
			assert(name == spec.kind)
			registered = value
		end,
	})
	assert(registered.Validate(spec.id), "Configured ID must validate")
	assert(not registered.Validate("Missing"), "Unknown ID must be rejected")
	assert(registered.Parse(string.lower(spec.id)) == spec.id, "Cmdr must resolve canonical ID")
	local completions = registered.Autocomplete("")
	assert(#completions == 2 and completions[1] == spec.id and completions[2] == spec.otherId, "IDs must autocomplete in sorted order")

	local calls, granted, failAt, failure = 0, {}, nil, nil
	local service = {}
	service[spec.method] = function(self, target, id, ...)
		assert(self == service and target == player and id == spec.id, "Grant must target the requested player and ID")
		assert(select("#", ...) == 0, "Use the existing grant interface without extra overrides")
		calls += 1
		if calls == failAt then
			return nil, failure
		end
		local record = { UUID = tostring(calls) }
		table.insert(granted, record)
		return if spec.kind == "pet" then record else record.UUID
	end
	services.ServerScriptService.Services[spec.service] = service
	local command = loadSource(root .. "Commands/" .. spec.command .. "Server.lua", environment)
	local function reset(at, message)
		calls, granted, failAt, failure = 0, {}, at, message
	end

	assert(command({}, player, spec.id) == "Gave 1 " .. spec.id .. " to Receiver")
	assert(calls == 1 and #granted == 1, "Omitted amount must grant once")
	reset()
	assert(command({}, player, spec.id, 3) == "Gave 3 " .. spec.id .. " to Receiver")
	assert(calls == 3 and #granted == 3, "Batch must grant the requested quantity")
	for _, amount in ipairs({ 0, -1, 1.5, math.huge, -math.huge, 0 / 0, "3", false }) do
		reset()
		assert(command({}, player, spec.id, amount) == "Amount must be a finite positive whole number")
		assert(calls == 0, "Invalid amount must never grant")
	end
	for _, message in ipairs({ "Pet storage is full", "Your data is still loading", "Egg is unavailable" }) do
		reset(1, message)
		assert(command({}, player, spec.id, 3) == "Gave 0/3 " .. spec.id .. " to Receiver: " .. message)
		assert(calls == 1 and #granted == 0, "Stop on the first service failure")
	end
	reset(3, "Unavailable")
	assert(command({}, player, spec.id, 5) == "Gave 2/5 " .. spec.id .. " to Receiver: Unavailable")
	assert(calls == 3 and #granted == 2, "Partial success must retain grants and stop immediately")
	reset(1)
	assert(command({}, player, spec.id):find("grant failed", 1, true), "Missing error message must have a readable fallback")
end

-- Exercise the permission hook with a GM fixture without changing the project's GM roster.
local file = assert(io.open(root .. "Hooks/Permission.lua", "r"))
local permissionSource = file:read("*a")
file:close()
permissionSource = permissionSource:gsub("local GM_USER_IDS = {", "local GM_USER_IDS = { 123456789,", 1)
local hook
assert(loadstring(permissionSource))()({
	RegisterHook = function(_, name, callback)
		assert(name == "BeforeRun")
		hook = callback
	end,
})
for _, name in ipairs({ "givePet", "giveEgg" }) do
	assert(hook({ Executor = { UserId = -1 }, Name = name }) == nil, "Owner must be allowed")
	assert(hook({ Executor = { UserId = 123456789 }, Name = name }) == nil, "GM must be allowed")
	assert(hook({ Executor = { UserId = 987654321 }, Name = name }) ~= nil, "Ordinary players must be denied")
end
