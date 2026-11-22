local function signal()
	local listeners = {}
	local event = {}
	function event:Connect(callback)
		local connection = { Connected = true }
		function connection:Disconnect()
			self.Connected = false
		end
		table.insert(listeners, { callback = callback, connection = connection })
		return connection
	end
	function event:Fire(...)
		for _, listener in ipairs(listeners) do
			if listener.connection.Connected then
				listener.callback(...)
			end
		end
	end
	return event
end

local file = assert(io.open("src/ServerScriptService/Services/FarmSlotService.lua", "r"))
local source = file:read("*a")
file:close()

local pending, warnings = {}, {}
local function step()
	local batch = pending
	pending = {}
	for _, thread in ipairs(batch) do
		local ok, message = coroutine.resume(thread)
		assert(ok, message)
		if coroutine.status(thread) ~= "dead" then
			table.insert(pending, thread)
		end
	end
end

local players = { PlayerAdded = signal(), PlayerRemoving = signal(), list = {} }
function players:GetPlayers()
	return self.list
end
local workspace = {}
local plots = {}
for slot = 1, 2 do
	local spawn = { CFrame = { slot = slot }, valid = true }
	function spawn:IsA(kind) return kind == "BasePart" and self.valid end
	local plot = { slot = slot, spawn = spawn }
	function plot:SetAttribute() end
	function plot:GetAttribute() return nil end
	function plot:FindFirstChild() return self.spawn end
	function plot:IsDescendantOf(parent) return parent == workspace end
	function spawn:IsDescendantOf(parent) return parent == plot end
	plots[slot] = plot
end

local resumeFrame
local profile = { Data = {} }
local profileReady = true
local knit = { CreateService = function(spec) return spec end, CreateSignal = signal, GetService = function()
	return { ApplyForPlayer = function() end, ConsumeResumeSpawn = function()
		return if profileReady then resumeFrame else nil
	end }
end }
local storage = { Packages = { Knit = knit, Signal = { new = signal } }, Modules = {
	PlotWorkspaceUtil = {
		getSortedPlots = function() return plots end,
		getSlotId = function(plot) return plot.slot end,
	},
} }
local services = { Players = players, ReplicatedStorage = storage, ServerScriptService = {
	Services = { PlayerDataService = { GetProfile = function() return if profileReady then profile else nil end } },
} }
local zero = {}
local env = setmetatable({
	game = { GetService = function(_, name) return assert(services[name]) end },
	require = function(module) return module end,
	workspace = workspace,
	Vector3 = { zero = zero },
	warn = function(...) table.insert(warnings, { ... }) end,
	task = {
		defer = function(callback, ...)
			local args = { ... }
			table.insert(pending, coroutine.create(function() callback(unpack(args)) end))
		end,
		wait = coroutine.yield,
	},
}, { __index = getfenv() })
local chunk = assert(loadstring(source))
setfenv(chunk, env)
local service = chunk()

local function character(ready)
	local root = { IsA = function(_, kind) return kind == "BasePart" end }
	local model = { ready = ready, inWorkspace = true, moves = 0, root = root, humanoid = { Health = 100 } }
	function model:FindFirstChild() return self.ready and root or nil end
	function model:FindFirstChildOfClass() return self.humanoid end
	function model:IsDescendantOf(parent) return parent == workspace and self.inWorkspace end
	function model:PivotTo(cframe)
		self.moves += 1
		self.destination = cframe
	end
	return model
end
local function player(model)
	return {
		Parent = players, Character = model, CharacterAdded = signal(), UserId = #players.list + 1,
		SetAttribute = function() end,
	}
end
local function respawn(owner, model)
	owner.Character = model
	owner.CharacterAdded:Fire(model)
end
local function atHome(owner, model)
	assert(model.moves == 1, "Each character must teleport exactly once")
	assert(model.destination == plots[service:GetPlayerPlotSlotId(owner)].spawn.CFrame, "Must use owner's spawn and orientation")
	assert(model.root.AssemblyLinearVelocity == zero and model.root.AssemblyAngularVelocity == zero, "Must clear velocities")
end

local first = player(character(true))
players.list = { first }
service:KnitInit()
service:KnitStart()
service:_bindPlayer(first)
first.CharacterAdded:Fire(first.Character)
step()
atHome(first, first.Character)

local second = player(nil)
table.insert(players.list, second)
players.PlayerAdded:Fire(second)
respawn(second, character(true))
step()
atHome(second, second.Character)
assert(service:GetPlayerPlotSlotId(first) ~= service:GetPlayerPlotSlotId(second), "Players need separate plots")

local delayed = character(false)
delayed.inWorkspace = false
respawn(first, delayed)
step()
assert(delayed.moves == 0)
delayed.ready = true
step()
assert(delayed.moves == 0, "Root readiness alone is insufficient before Workspace parenting")
delayed.inWorkspace = true
step()
atHome(first, delayed)

for _ = 1, 2 do
	respawn(first, character(true))
	step()
	atHome(first, first.Character)
end

local stale = character(false)
respawn(first, stale)
step()
respawn(first, character(true))
stale.ready = true
step()
assert(stale.moves == 0, "Replaced characters must never be teleported")
atHome(first, first.Character)

local released = character(false)
respawn(first, released)
step()
service:ReleasePlayerSlot(first)
service:EnsurePlayerSlot(first)
released.ready = true
step()
atHome(first, released)
assert(#pending == 0, "Release and reassign of the same slot must cancel the old task")

local dead = character(true)
dead.humanoid.Health = 0
respawn(first, dead)
step()
assert(dead.moves == 0, "Dead characters must not be moved")

local ownPlot = plots[service:GetPlayerPlotSlotId(first)]
local savedSpawn = ownPlot.spawn
for _, invalid in ipairs({ false, { IsA = function() return false end } }) do
	ownPlot.spawn = invalid or nil
	respawn(first, character(true))
	step()
	assert(first.Character.moves == 0, "Invalid spawn must never fall back to another home")
end
assert(#warnings == 2, "Missing and invalid spawns must warn")
ownPlot.spawn = savedSpawn

resumeFrame = { training = true }
local earlyCharacter = character(true)
profileReady = false
respawn(first, earlyCharacter)
step()
assert(earlyCharacter.moves == 0, "A ready character must wait to choose its spawn until training progress is loaded")
profileReady = true
step()
assert(earlyCharacter.destination == resumeFrame and earlyCharacter.moves == 1, "Late profile load must restore the training spawn once")

respawn(first, character(true))
step()
assert(first.Character.destination == resumeFrame and first.Character.moves == 1, "Resume must replace normal home teleport, not add a second teleport")
resumeFrame = nil

local leaving = character(false)
respawn(first, leaving)
step()
local connection = service._CharacterConnections[first]
players.PlayerRemoving:Fire(first)
first.Parent = nil
leaving.ready = true
step()
assert(leaving.moves == 0 and #pending == 0, "Leaving must cancel pending waits")
assert(not connection.Connected and service._CharacterConnections[first] == nil, "Leaving must disconnect CharacterAdded")
assert(service._SpawnRequests[first] == nil and service:GetPlayerPlotSlotId(first) == nil, "Leaving must release player state")

return true
