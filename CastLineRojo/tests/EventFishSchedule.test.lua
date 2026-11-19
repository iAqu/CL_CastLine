local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end
local config = loadSource("src/ReplicatedStorage/Modules/EventFishConfig.lua")
for _, start in { 0, 3600, 86400, 1794412800 } do
	assert(start % 900 == 0)
	local window = config.GetWindow(start)
	assert(window.StartsAt == start and window.EndsAt == start + 15 and window.NextStartsAt == start + 900)
	assert(config.GetWindow(start + 899.99).SlotId == window.SlotId)
	assert(config.GetWindow(start + 900).SlotId == window.SlotId + 1)
end
assert(config.FormatCountdown(15) == "0:15" and config.FormatCountdown(885) == "14:45")
assert(config.FormatCountdown(0.01) == "0:01" and config.FormatCountdown(-1) == "0:00")

local function instance(class, name)
	local object = { Name = name or class, children = {}, attributes = {} }
	local parent
	setmetatable(object, {
		__index = function(_, key)
			if key == "Parent" then return parent end
		end,
		__newindex = function(self, key, value)
			if key ~= "Parent" then
				rawset(self, key, value)
				return
			end
			if parent then parent.children[self.Name] = nil end
			parent = value
			if parent then parent.children[self.Name] = self end
		end,
	})
	function object:IsA(kind)
		return class == kind or kind == "Light" and class == "PointLight" or kind == "BasePart" and class == "Part"
	end
	function object:IsDescendantOf(ancestor)
		local current = self.Parent
		while current do
			if current == ancestor then return true end
			current = current.Parent
		end
		return false
	end
	function object:Destroy()
		self.Parent = nil
		self.Destroyed = true
	end
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
	function object:GetAttribute(key) return self.attributes[key] end
	return object
end
local workspace, storage = instance("Workspace"), instance("ReplicatedStorage")
local areas = instance("Folder", "Areas")
local pivotMetatable = {
	__add = function(pivot, offset)
		return {
			X = pivot.X + offset.X,
			Y = pivot.Y + offset.Y,
			Z = pivot.Z + offset.Z,
			Rotation = pivot.Rotation,
		}
	end,
}
local function newMarker(pivot)
	local marker = instance("Part", "EventFish")
	setmetatable(pivot, pivotMetatable)
	function marker:GetPivot() return pivot end
	marker.Parent = areas
	return marker
end
local marker = newMarker({ X = 2237.32104, Y = 775.366272, Z = 1065.93396, Rotation = "event rotation" })
local overhead, content = instance("BillboardGui"), instance("Frame")
areas.Parent = workspace
marker.children.Overhead, overhead.children.Content = overhead, content
overhead.Enabled = true
content.children.Header, content.children.Time = instance("TextLabel"), instance("TextLabel")
local beam, disabled, particle = instance("Beam"), instance("Beam"), instance("ParticleEmitter")
beam.Enabled, disabled.Enabled, particle.Enabled = true, false, true
marker.children.Beam, marker.children.Disabled, marker.children.Particle = beam, disabled, particle
local vfx, event = instance("Folder", "VFX"), instance("Folder", "Event")
vfx.Parent, event.Parent = storage, vfx
local function newRainbow()
	local model = instance("Model", "RainbowVFX")
	function model:PivotTo(pivot) self.Pivot = pivot end
	local root = instance("Part", "Root")
	local emitter, disabledEmitter = instance("ParticleEmitter", "Sparkles"), instance("ParticleEmitter", "Disabled")
	local controller = instance("Script", "RainbowFlashController")
	root.CanCollide, root.CanTouch, root.CanQuery = true, true, true
	emitter.Enabled, disabledEmitter.Enabled, controller.Enabled = true, false, true
	root.Parent, controller.Parent = model, model
	emitter.Parent, disabledEmitter.Parent = root, root
	return model
end
local template = newRainbow()
template.Parent = event
local cloneCount = 0
function template:Clone()
	cloneCount += 1
	return newRainbow()
end
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
	Vector3 = { new = function(x, y, z) return { X = x, Y = y, Z = z } end },
	warn = function() warningCount += 1 end,
})
service:KnitInit()
assert(service:GetActiveFish() == fishes.A and picks == 1)
assert(content.children.Header.Text == config.ActiveHeader and content.children.Time.Text == "0:15")
assert(beam.Enabled and particle.Enabled and not disabled.Enabled)
local rainbow = assert(marker:FindFirstChild("RainbowVFX"))
local root = rainbow:FindFirstChild("Root")
local sparkles = root:FindFirstChild("Sparkles")
local markerPivot = marker:GetPivot()
assert(cloneCount == 1 and math.abs(rainbow.Pivot.Y - 760.889) < 0.001,
	"The scheduled event places one clone at the desired world height")
assert(rainbow.Pivot.X == markerPivot.X and rainbow.Pivot.Z == markerPivot.Z
	and rainbow.Pivot.Rotation == markerPivot.Rotation, "The vertical offset preserves X, Z, and rotation")
assert(not root.CanCollide and not root.CanTouch and not root.CanQuery, "Visual parts cannot affect gameplay")
assert(sparkles.Enabled and not root:FindFirstChild("Disabled").Enabled)
assert(rainbow:FindFirstChild("RainbowFlashController").Enabled and template:FindFirstChild("Root").CanCollide)
assert(sparkles:GetAttribute(config.MarkerEnabledAttribute) == nil, "The original marker update leaves the RGB effects alone")
local revision = service._StateFolder.attributes.Revision
now = 14.999
assert(service:GetActiveFish() == fishes.A and picks == 1)
assert(service._StateFolder.attributes.Revision == revision, "Countdown ticks do not republish an identical snapshot")
now = 15
assert(service:GetActiveFish() == nil)
assert(rainbow.Destroyed and not marker:FindFirstChild("RainbowVFX"), "Entering Waiting removes the active clone")
assert(content.children.Header.Text == config.WaitingHeader and content.children.Time.Text == "14:45")
assert(not beam.Enabled and not particle.Enabled and not disabled.Enabled)
assert(beam:GetAttribute(config.MarkerEnabledAttribute) == false and overhead:GetAttribute(config.MarkerEnabledAttribute) == true,
	"The intended visual state distinguishes the idle countdown from active effects")
now = 900
assert(service:GetActiveFish() == fishes.B and picks == 2)
now = 2705
assert(service:GetActiveFish() == fishes.A and picks == 3, "Delayed wake-up skips obsolete windows")
service._SlotId = nil
now = 3601
assert(service:GetActiveFish() == fishes.B and picks == 4, "Booting mid-window immediately selects one species")
service._SlotId = nil
now = 4600
assert(not service:GetActiveFish() and picks == 4, "Booting between windows must wait for the UTC boundary")
unavailable, now = true, 5400
assert(not service:GetActiveFish() and warningCount == 1)
now = 5401
assert(not service:GetActiveFish() and warningCount == 1, "Empty pools warn once per window")
unavailable = false
assert(service:StartDebugEvent("A"))
local debugEnd = service._OverrideWindow.EndsAt
assert(debugEnd == now + 15)
assert(service:GetActiveFish() == fishes.A and service._Snapshot.SlotId < 0)
now = debugEnd
assert(service._OverrideWindow and not service:GetActiveFish(), "Debug expiry resumes the absolute schedule")
studio = false
assert(not service:StartDebugEvent("A") and service.Client.StartDebugEvent == nil)
assert(service:StartEvent("B") == fishes.B, "Authorized server commands must also work outside Studio")
assert(service:GetActiveFish() == fishes.B and service.Client.StartEvent == nil)
local manualRainbow = assert(marker:FindFirstChild("RainbowVFX"))
local manualCloneCount = cloneCount
local firstEnd, firstSlot = service._OverrideWindow.EndsAt, service._OverrideWindow.SlotId
now += 5
assert(service:StartEvent("A") == fishes.A)
assert(service._OverrideWindow.EndsAt == now + 15 and service._OverrideWindow.EndsAt == firstEnd + 5
	and service._OverrideWindow.SlotId ~= firstSlot, "Starting again replaces the override with a fresh 15-second window")
assert(marker:FindFirstChild("RainbowVFX") == manualRainbow and cloneCount == manualCloneCount,
	"Restarting an active event reuses its only visual")
marker.Parent = nil
local replacement = newMarker({ X = 300, Y = 810, Z = -20, Rotation = "replacement rotation" })
assert(service:GetActiveFish() == fishes.A)
local replacementRainbow = assert(replacement:FindFirstChild("RainbowVFX"))
local replacementPivot = replacement:GetPivot()
assert(manualRainbow.Destroyed and math.abs(replacementRainbow.Pivot.Y - replacementPivot.Y + 14.477272) < 0.001,
	"Moving to a replacement marker disposes of the old clone and applies the same world Y offset")
assert(replacementRainbow.Pivot.X == replacementPivot.X and replacementRainbow.Pivot.Z == replacementPivot.Z
	and replacementRainbow.Pivot.Rotation == replacementPivot.Rotation)
now = service._OverrideWindow.EndsAt
assert(not service:GetActiveFish() and service._Snapshot.NextStartsAt == 6300,
	"A manual event must return to the UTC schedule")
assert(replacementRainbow.Destroyed and not replacement:FindFirstChild("RainbowVFX"))

template.Parent = nil
assert(service:StartEvent("A") == fishes.A and not replacement:FindFirstChild("RainbowVFX"))
assert(service:GetActiveFish() == fishes.A and warningCount == 2, "A missing template warns only once and the event continues")
template.Parent = event
assert(service:GetActiveFish() == fishes.A and replacement:FindFirstChild("RainbowVFX"),
	"A template restored during the active window can be used immediately")
