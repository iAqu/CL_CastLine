local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end

local modules = "src/ReplicatedStorage/Modules/"
local config = loadSource(modules .. "EventFishConfig.lua")
local gate = loadSource(modules .. "EventPresentationGate.lua", {
	script = { Parent = { FishingOnboarding = loadSource(modules .. "FishingOnboarding.lua") } },
	require = function(value) return value end,
})

local all = {}
local function object(class, name, parent, properties)
	local instance = properties or {}
	instance.Name, instance.Parent = name, parent
	instance.attributes = {}
	function instance:IsA(kind)
		return kind == class or kind == "BaseScript" and class == "Script"
	end
	function instance:IsDescendantOf(ancestor)
		local current = self.Parent
		while current do
			if current == ancestor then return true end
			current = current.Parent
		end
		return false
	end
	function instance:FindFirstChild(key)
		for _, child in all do
			if child.Parent == self and child.Name == key then return child end
		end
	end
	function instance:GetDescendants()
		local result = {}
		for _, child in all do
			if child:IsDescendantOf(self) then table.insert(result, child) end
		end
		return result
	end
	function instance:Destroy()
		for _, child in self:GetDescendants() do child.Parent = nil end
		self.Parent = nil
		self.destroyed = true
	end
	function instance:GetAttribute(key) return self.attributes[key] end
	table.insert(all, instance)
	return instance
end
local workspace, storage = object("Workspace"), object("ReplicatedStorage")
local areas = object("Folder", "Areas", workspace)
local marker = object("BasePart", "EventFish", areas, { Position = { X = 10, Z = 20 } })
local countdown = object("BillboardGui", "Overhead", marker, { Enabled = true })
local content = object("Frame", "Content", countdown)
local header = object("TextLabel", "Header", content)
local time = object("TextLabel", "Time", content)
local markerParticles = object("ParticleEmitter", "Particles", marker, { Enabled = true, cleared = 0 })
function markerParticles:Clear() self.cleared += 1 end
local disabledLight = object("Light", "Disabled", marker, { Enabled = false })
local water = object("Model", "Water", areas)
local waterPart = object("BasePart", "Surface", water, { Color = "water" })
local texture = object("Decal", "Texture", waterPart, { Color3 = "texture" })
local state = object("Folder", config.StateFolderName, storage)
state.attributes = { Phase = "Active", StartsAt = 900, EndsAt = 915, SlotId = 1, FishId = "A", NextStartsAt = 1800 }
local vfx = object("Folder", "VFX", storage)
local eventVfx = object("Folder", "Event", vfx)
local template = object("Model", "RainbowVFX", eventVfx)

local vectors = {}
local function vector(x, y, z) return setmetatable({ X = x, Y = y, Z = z }, vectors) end
vectors.__add = function(a, b) return vector(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
vectors.__mul = function(a, b) return vector(a.X * b, a.Y * b, a.Z * b) end
function marker:GetPivot() return vector(10, 775.366272, 20) end
function template:Clone()
	local model = object("Model", self.Name)
	object("Script", "RainbowFlashController", model)
	local part = object("BasePart", "Root", model, { CanCollide = true, CanTouch = true, CanQuery = true })
	object("Beam", "Beam", part, { Enabled = true, Brightness = 2, Color = "beam" })
	object("ParticleEmitter", "Sparkles", part, { Enabled = false, Color = "sparkles" })
	function model:PivotTo(pivot) self.pivot = pivot end
	return model
end
local humanoid = { Health = 100 }
local player = object("Player", "Player")
player.Character = { FindFirstChildOfClass = function() return humanoid end }
local fishing, locked, animated, disposed = false, nil, 0, 0
local fishingController = {
	IsPreparing = function() return fishing end,
	GetEventFishSnapshot = function() return locked end,
}
local services = {
	Players = { LocalPlayer = player }, Workspace = workspace, ReplicatedStorage = storage,
	ReplicatedFirst = { Data = { FishesData = { A = { FishID = "A" }, B = { FishID = "B" } } } },
}
local function animation()
	return { Update = function() animated += 1 end, Destroy = function() disposed += 1 end }
end
local globals = {
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	Vector3 = { new = vector },
	CFrame = { lookAt = function() return setmetatable({}, { __mul = function() return {} end }) end },
	Color3 = { fromHSV = function(hue) return hue end },
	ColorSequence = { new = function(keypoints) return keypoints end },
	ColorSequenceKeypoint = { new = function(at, hue) return { at, hue } end },
}
storage.Modules = {
	EventPresentationGate = gate, EventFishConfig = config,
	EventFishRainbow = loadSource(modules .. "EventFishRainbow.lua", globals),
	FishingAssets = {}, ItemStatUtil = {},
	FishAnimationController = { new = animation },
	FishShadowAppearance = { Destroy = function() end },
	WaterSurfaceUtil = { GetWaterSurfaceY = function() return 770 end },
}
storage.Packages = { Knit = {
	CreateController = function(controller) return controller end,
	GetController = function(name) assert(name == "FishingController") return fishingController end,
} }
local controller = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/EventFishController.lua", globals)
local shadowsCreated = 0
function controller:_makeShadow(fish, slotId, startsAt)
	shadowsCreated += 1
	return {
		model = { PrimaryPart = {}, PivotTo = function() end, Destroy = function(self) self.destroyed = true end },
		fishId = fish.FishID, slotId = slotId, startsAt = startsAt,
		bodyToPivot = {}, topOffset = 10,
	}
end

controller:_update(900)
local shadow = assert(controller._Shadow)
assert(shadow.model.Parent == workspace and animated == 1)
local rainbow = assert(controller._Rainbow.model)
local part = rainbow:FindFirstChild("Root")
local beam = part:FindFirstChild("Beam")
assert(rainbow.Parent == marker and not rainbow:FindFirstChild("RainbowFlashController"))
assert(math.abs(rainbow.pivot.Y - 760.889) < 0.001 and rainbow.pivot.X == 10 and rainbow.pivot.Z == 20)
assert(not part.CanCollide and not part.CanTouch and not part.CanQuery)
assert(beam.Enabled and #beam.Color == 7 and not part:FindFirstChild("Sparkles").Enabled)
assert(waterPart.Color == 0 and texture.Color3 == 0 and not disabledLight.Enabled)
assert(countdown.Enabled and header.Text == config.ActiveHeader and time.Text == "0:15")

fishing, locked = true, { FishId = "A", SlotId = 1, StartsAt = 900, EndsAt = 915 }
controller:_update(901)
assert(shadow.model.Parent == nil and disposed == 1, "Hide the ambient fish silhouette during the cast")
assert(not countdown.Enabled and controller._Rainbow.model == rainbow and markerParticles.Enabled,
	"Hide the activity countdown as soon as fishing starts while preserving the active effects")
fishing, locked = false, nil
controller:_update(902)
assert(shadow.model.Parent == workspace and animated == 2 and shadowsCreated == 1)
assert(countdown.Enabled and header.Text == config.ActiveHeader and time.Text == "0:13",
	"Restore the live active countdown when leaving fishing")
fishing, locked = true, { FishId = "A", SlotId = 1, StartsAt = 900, EndsAt = 915 }
state.attributes.Phase = "Waiting"
controller:_update(915.5)
assert(not countdown.Enabled and header.Text == config.ActiveHeader and time.Text == "0:00")
assert(controller._Rainbow.model == rainbow and markerParticles.Enabled and waterPart.Color == 0.75)
assert(not controller._Shadow and shadow.model.destroyed)

-- A second client reads the same expired server state with its own world and no fishing session.
local viewerWorld = object("Workspace")
local viewerAreas = object("Folder", "Areas", viewerWorld)
local viewerMarker = object("BasePart", "EventFish", viewerAreas)
local viewerBoard = object("BillboardGui", "Overhead", viewerMarker)
local viewerContent = object("Frame", "Content", viewerBoard)
local viewerHeader = object("TextLabel", "Header", viewerContent)
local viewerTime = object("TextLabel", "Time", viewerContent)
local viewerWater = object("Model", "Water", viewerAreas)
local viewerSurface = object("BasePart", "Surface", viewerWater, { Color = "blue" })
local viewerServices = table.clone(services)
viewerServices.Players = { LocalPlayer = object("Player", "Viewer") }
viewerServices.Workspace = viewerWorld
viewerServices.ReplicatedStorage = {
	Modules = storage.Modules,
	Packages = { Knit = {
		CreateController = storage.Packages.Knit.CreateController,
		GetController = function() return { IsPreparing = function() return false end } end,
	} },
	FindFirstChild = function(_, name) return storage:FindFirstChild(name) end,
}
local viewerGlobals = table.clone(globals)
viewerGlobals.game = { GetService = function(_, name) return viewerServices[name] end }
local viewer = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/EventFishController.lua", viewerGlobals)
viewer:_update(915.5)
assert(viewerBoard.Enabled and viewerHeader.Text == config.WaitingHeader and viewerTime.Text == "14:45")
assert(not viewer._Rainbow and viewerSurface.Color == "blue" and controller._Rainbow.model == rainbow)

state.attributes = { Phase = "Active", StartsAt = 916, EndsAt = 931, SlotId = -2, FishId = "B", NextStartsAt = 1800 }
controller:_update(917)
assert(not countdown.Enabled and controller._Rainbow.model == rainbow and time.Text == "0:00",
	"An event replacement during a cast must keep the countdown hidden and preserve the locked effects")
fishing, locked = false, nil
controller:_update(918)
local nextRainbow = assert(controller._Rainbow.model)
assert(countdown.Enabled and rainbow.destroyed and nextRainbow.Parent == marker and time.Text == "0:13")
assert(controller._Shadow.fishId == "B")

fishing = true
controller:_update(919)
assert(not countdown.Enabled and not markerParticles.Enabled and markerParticles.cleared == 1)
assert(not controller._Rainbow and nextRainbow.destroyed and waterPart.Color == "water" and texture.Color3 == "texture",
	"A player who entered outside an event must not see late event effects during this cast")
fishing = false
controller:_update(920)
assert(countdown.Enabled and controller._Rainbow and markerParticles.Enabled)
player.attributes.FishingOnboardingStage = "Train"
controller:_update(921)
assert(not countdown.Enabled and not controller._Rainbow and not controller._Shadow)
assert(waterPart.Color == "water" and texture.Color3 == "texture")

player.attributes.FishingOnboardingStage = "Complete"
controller:_update(922)
local finalRainbow = assert(controller._Rainbow.model)
controller:_update(931)
assert(countdown.Enabled and header.Text == config.WaitingHeader and time.Text == "14:29")
assert(not markerParticles.Enabled and finalRainbow.destroyed and not controller._Shadow and not controller._Rainbow)
assert(waterPart.Color == "water" and texture.Color3 == "texture")
