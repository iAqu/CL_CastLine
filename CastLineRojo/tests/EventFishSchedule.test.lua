local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end
local config = loadSource("src/ReplicatedStorage/Modules/EventFishConfig.lua")
for _, start in { 0, 3600, 86400, 1794412800 } do
	assert(start % 600 == 0)
	local window = config.GetWindow(start)
	assert(window.StartsAt == start and window.EndsAt == start + 30 and window.NextStartsAt == start + 600)
	assert(config.GetWindow(start + 599.99).SlotId == window.SlotId)
	assert(config.GetWindow(start + 600).SlotId == window.SlotId + 1)
end
assert(config.FormatCountdown(30) == "0:30" and config.FormatCountdown(570) == "9:30")
assert(config.FormatCountdown(0.01) == "0:01" and config.FormatCountdown(-1) == "0:00")

local function instance(class, name)
	local object = { Name = name or class, children = {}, attributes = {} }
	function object:IsA(kind) return class == kind or kind == "Light" and class == "PointLight" end
	function object:GetDescendants()
		local all = {}
		for _, child in self.children do
			table.insert(all, child)
			for _, nested in child:GetDescendants() do table.insert(all, nested) end
		end
		return all
	end
	function object:FindFirstChild(key) return self.children[key] end
	function object:SetAttribute(key, value) self.attributes[key] = value end
	return object
end
local workspace, storage = instance("Workspace"), instance("ReplicatedStorage")
local areas, marker, overhead, content = instance("Folder"), instance("Part"), instance("BillboardGui"), instance("Frame")
workspace.children.Areas, areas.children.EventFish = areas, marker
marker.children.Overhead, overhead.children.Content = overhead, content
content.children.Header, content.children.Time = instance("TextLabel"), instance("TextLabel")
local beam, disabled, particle = instance("Beam"), instance("Beam"), instance("ParticleEmitter")
beam.Enabled, disabled.Enabled, particle.Enabled = true, false, true
marker.children.Beam, marker.children.Disabled, marker.children.Particle = beam, disabled, particle
local now, picks, warningCount, studio = 0, 0, 0, true
workspace.GetServerTimeNow = function() return now end
local fishes = {
	A = { FishID = "A", Model = "A", Rarity = "Event" },
	B = { FishID = "B", Model = "B", Rarity = "Event" },
	Missing = { FishID = "Missing", Model = "Missing", Rarity = "Event" },
	Normal = { FishID = "Normal", Model = "Normal", Rarity = "Secret" },
}
local unavailable = false
local services = {
	Workspace = workspace,
	RunService = { IsStudio = function() return studio end },
	ReplicatedFirst = { Data = { FishesData = fishes } },
	ReplicatedStorage = storage,
}
storage.Modules = { EventFishConfig = config, FishingAssets = { GetFish = function(name)
	return not unavailable and name ~= "Missing"
end } }
storage.Packages = { Knit = { CreateService = function(value) return value end } }
local service = loadSource("src/ServerScriptService/Services/EventFishService.lua", {
	game = { GetService = function(_, name) return services[name] end },
	require = function(module) return module end,
	Random = { new = function() return { NextInteger = function(_, low, high)
		assert(low == 1 and high == 2, "Only valid Event models enter the uniform pool")
		picks += 1
		return if picks % 2 == 1 then 1 else 2
	end } end },
	Instance = { new = instance },
	warn = function() warningCount += 1 end,
})
service:KnitInit()
assert(service:GetActiveFish() == fishes.A and picks == 1)
assert(content.children.Header.Text == config.ActiveHeader and content.children.Time.Text == "0:30")
assert(beam.Enabled and particle.Enabled and not disabled.Enabled)
local revision = service._StateFolder.attributes.Revision
now = 29.999
assert(service:GetActiveFish() == fishes.A and picks == 1)
assert(service._StateFolder.attributes.Revision == revision, "Countdown ticks do not republish an identical snapshot")
now = 30
assert(service:GetActiveFish() == nil)
assert(content.children.Header.Text == config.WaitingHeader and content.children.Time.Text == "9:30")
assert(not beam.Enabled and not particle.Enabled and not disabled.Enabled)
now = 600
assert(service:GetActiveFish() == fishes.B and picks == 2)
now = 1805
assert(service:GetActiveFish() == fishes.A and picks == 3, "Delayed wake-up skips obsolete windows")
service._SlotId = nil
now = 2401
assert(service:GetActiveFish() == fishes.B and picks == 4, "Booting mid-window immediately selects one species")
service._SlotId = nil
now = 3100
assert(not service:GetActiveFish() and picks == 4, "Booting between windows must wait for the UTC boundary")
unavailable, now = true, 3600
assert(not service:GetActiveFish() and warningCount == 1)
now = 3601
assert(not service:GetActiveFish() and warningCount == 1, "Empty pools warn once per window")
unavailable = false
assert(service:StartDebugEvent("A"))
local debugEnd = service._OverrideWindow.EndsAt
assert(service:GetActiveFish() == fishes.A and service._Snapshot.SlotId < 0)
now = debugEnd
assert(service._OverrideWindow and not service:GetActiveFish(), "Debug expiry resumes the absolute schedule")
studio = false
assert(not service:StartDebugEvent("A") and service.Client.StartDebugEvent == nil)
assert(service:StartEvent("B") == fishes.B, "Authorized server commands must also work outside Studio")
assert(service:GetActiveFish() == fishes.B and service.Client.StartEvent == nil)
local firstEnd, firstSlot = service._OverrideWindow.EndsAt, service._OverrideWindow.SlotId
now += 5
assert(service:StartEvent("A") == fishes.A)
assert(service._OverrideWindow.EndsAt == firstEnd + 5 and service._OverrideWindow.SlotId ~= firstSlot,
	"Starting again replaces the override with a fresh 30-second window")
now = service._OverrideWindow.EndsAt
assert(not service:GetActiveFish() and service._Snapshot.NextStartsAt % 600 == 0,
	"A manual event must return to the UTC schedule")
