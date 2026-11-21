local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local function loadModule(path, env)
	return assert(load(read(path), path, "t", setmetatable(env or {}, { __index = getfenv() })))()
end
local function signal()
	local listeners = {}
	return {
		Connect = function(_, fn)
			table.insert(listeners, fn)
			return { Disconnect = function() end }
		end,
		Fire = function(_, ...)
			for _, fn in ipairs(listeners) do
				fn(...)
			end
		end,
	}
end
local active, locked, locking = {}, {}, {}
local nextId = 0
local activeSignal, lockedSignal = signal(), signal()
local globals = {}
function globals:GetActiveUpdates()
	return table.clone(active)
end
function globals:GetLockedUpdates()
	return table.clone(locked)
end
function globals:AddActiveUpdate(value)
	nextId += 1
	table.insert(active, { nextId, value })
end
function globals:LockActiveUpdate(id)
	locking[id] = true
end
function globals:ClearLockedUpdate(id)
	for i = #locked, 1, -1 do
		if locked[i][1] == id then
			table.remove(locked, i)
		end
	end
end
function globals:ListenToNewActiveUpdate(fn)
	return activeSignal:Connect(fn)
end
function globals:ListenToNewLockedUpdate(fn)
	return lockedSignal:Connect(fn)
end
local loadCalls, lastKey = 0, nil
local store = {
	GlobalUpdateProfileAsync = function(_, key, callback)
		lastKey = key
		callback(globals)
		return globals
	end,
	LoadProfileAsync = function()
		loadCalls += 1
		error("Offline delivery must not load a profile")
	end,
}
local Delivery = loadModule("src/ReplicatedStorage/Modules/PaidEggDelivery.lua")
local knit = {
	CreateService = function(value)
		return value
	end,
	CreateSignal = signal,
}
local modules = { PaidEggDelivery = Delivery }
for _, name in ipairs({ "LogHelper", "PlotFishIncome", "PlotPlacementUtil", "RodInventory", "TimeUtil" }) do
	modules[name] = {}
end
local services = {
	RunService = {
		IsStudio = function()
			return false
		end,
	},
	Players = {},
	ReplicatedFirst = {},
	ReplicatedStorage = {
		Packages = { Knit = knit, Signal = { new = signal } },
		PlayerData = { Template = {} },
		Modules = modules,
	},
	ServerScriptService = { Libs = { ProfileService = {
		GetProfileStore = function()
			return store
		end,
	} } },
}
local now = 0
local function wait(seconds)
	now += seconds
end
local persistence = require("./helpers/PurchasePersistenceMock")(function() return now end, wait)
local service = loadModule("src/ServerScriptService/Services/PlayerDataService.lua", {
	game = {
		GetService = function(_, name)
			return assert(services[name], name)
		end,
	},
	require = function(value)
		return value
	end,
	script = { Parent = { PurchasePersistence = persistence } },
	os = {
		clock = function()
			return now
		end,
	},
	task = {
		spawn = function(fn, ...)
			fn(...)
		end,
		wait = wait,
	},
})
globals:AddActiveUpdate({ Kind = "OtherFeature" })
local order = { OrderId = "buyer:receipt", RecipientUserId = 20, Rewards = { { ItemId = "Fish_001" } } }
assert(service:QueuePaidEggDelivery(20, order))
assert(service:QueuePaidEggDelivery(20, order))
assert(lastKey == "Player_20" and #active == 2 and loadCalls == 0)
local player = {}
local profile = {
	Data = {},
	GlobalUpdates = globals,
	MetaData = { MetaTagsLatest = {} },
	Tags = {},
	Active = true,
	Persist = true,
}
function profile:IsActive()
	return self.Active
end
function profile:SetMetaTag(key, value)
	self.Tags[key] = value
end
function profile:Save()
	if not self.Persist then
		return
	end
	self.MetaData.MetaTagsLatest = table.clone(self.Tags)
	for i = #active, 1, -1 do
		local update = active[i]
		if locking[update[1]] then
			table.remove(active, i)
			locking[update[1]] = nil
			table.insert(locked, update)
			lockedSignal:Fire(update[1], update[2])
		end
	end
end
service._Profiles[player] = profile
local delivered = {}
local connections = service:WatchPaidEggDeliveries(player, function(id, value)
	delivered[id] = value
end)
assert(#connections == 2 and #active == 1 and #locked == 1)
assert(delivered[locked[1][1]].OrderId == order.OrderId, "Only paid updates reach the consumer")
assert(
	service:QueuePaidEggDelivery(20, order) and #active == 1 and #locked == 1,
	"A locked delivery is still a duplicate, not a new mailbox entry"
)
assert(service:SavePaidEggProfile(player) and profile.MetaData.MetaTagsLatest.PaidEggRevision == 1)
local updateId = locked[1][1]
service:ClearPaidEggDelivery(player, active[1][1])
assert(#active == 1 and active[1][2].Kind == "OtherFeature")
service:ClearPaidEggDelivery(player, updateId)
assert(#locked == 0 and #active == 1)
profile.Persist = false
assert(not service:SavePaidEggProfile(player), "An unsaved meta revision is not durable confirmation")
profile.Active = false
assert(not service:SavePaidEggProfile(player))
assert(loadCalls == 0)
print("Paid egg mailbox deduplication, profile-owner consumption, isolation and durable-save confirmation passed")
