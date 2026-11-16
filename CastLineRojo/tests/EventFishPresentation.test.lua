local function loadSource(path, globals)
	local f = assert(io.open(path, "r"))
	local source = f:read("*a")
	f:close()
	return assert(load(source, path, "t", setmetatable(globals, { __index = getfenv() })))()
end
local function object(class, properties)
	local value = properties or {}
	function value:IsA(kind) return class == kind end
	return value
end
local function quietSignal() return { Connect = function() end } end
local player = { FindFirstChildOfClass = function() return nil end }
local waterPart = object("BasePart", { Color = "water", Parent = true })
local texture = object("Decal", { Color3 = "texture", Parent = true })
local water = object("Model", { GetDescendants = function() return { waterPart, texture } end })
local oldEvent, render
local workspace = {
	GetServerTimeNow = function() return 100 end,
	FindFirstChild = function() return { FindFirstChild = function() return water end } end,
}
local folder = object("Folder", { GetAttributeChangedSignal = quietSignal, GetAttribute = function() return 0 end })
local storage = {
	FindFirstChild = function() return folder end,
	Modules = {
		EventConfig = { AUTO_SCHEDULE_ENABLED = false, STATE_FOLDER_NAME = "EventState", STATE_ATTRIBUTE = {
			REVISION = "Revision", ENDS_AT = "EndsAt", NEXT_STARTS_AT = "NextStartsAt",
		} },
		EventStateUtil = { GetActiveEvent = function() return oldEvent end, NormalizeEventType = function(name) return name end },
		MutationDataUtil = { NormalizeMutationId = function(id) return id end, GetLabelColor = function() return "golden" end },
	},
	Packages = { Knit = { CreateController = function(controller) return controller end } },
}
local services = {
	Players = { LocalPlayer = player }, ReplicatedStorage = storage, Workspace = workspace,
	RunService = { RenderStepped = { Connect = function(_, callback) render = callback end } },
}
local waterController = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/EventController.lua", {
	game = { GetService = function(_, name) return services[name] end }, require = function(value) return value end,
	Color3 = { fromHSV = function() return "rainbow" end },
	task = { spawn = function(callback) callback() end },
})
waterController:BeginEarlyState()
waterController:SetEventFishActive(true)
assert(waterPart.Color == "rainbow" and texture.Color3 == "rainbow")
oldEvent = { EventType = "mutation", MutationId = "Golden" }
render(0.1)
assert(waterPart.Color == "rainbow", "Event fish water takes priority over a simultaneous mutation event")
waterController:SetEventFishActive(false)
assert(waterPart.Color == "golden", "Ending Event fish restores the still-active mutation color")
oldEvent = nil
render(0.1)
assert(waterPart.Color == "water" and texture.Color3 == "texture", "All layers restore their distinct original colors")
oldEvent = { EventType = "mutation", MutationId = "Rainbow" }
render(0.1)
render(0.1)
waterController:SetEventFishActive(true)
waterController:SetEventFishActive(false)
render(0.1)
assert(waterPart.Color == "rainbow", "The old rainbow event continues after Event fish ends")
oldEvent = nil
render(0.1)
assert(waterPart.Color == "water" and texture.Color3 == "texture", "Repeated overrides must not capture a tinted baseline")

-- Exercise the actual local visibility lifecycle with lightweight visual fixtures.
local attributes = { Phase = "Active", StartsAt = 600, EndsAt = 630, SlotId = 1, FishId = "A" }
folder = { GetAttribute = function(_, key) return attributes[key] end }
storage.FindFirstChild = function(_, key) return if key == "EventFishState" then folder else nil end
local marker = object("BasePart", { Position = { X = 0, Z = 0 } })
workspace.FindFirstChild = function() return { FindFirstChild = function() return marker end } end
local humanoid = { Health = 100 }
player.Character = { FindFirstChildOfClass = function() return humanoid end }
local fishing, tint, animated, disposed = false, false, 0, 0
local function animation()
	return { Update = function() animated += 1 end, Destroy = function() disposed += 1 end }
end
local fish = { FishID = "A", Model = "A" }
local config = { StateFolderName = "EventFishState", Shadow = { Period = 24, Radius = 15, Clearance = 1.5 } }
storage.Modules = {
	EventFishConfig = config, FishingAssets = {}, ItemStatUtil = {},
	FishAnimationController = { new = animation },
	FishShadowAppearance = { Destroy = function() end },
	WaterSurfaceUtil = { GetWaterSurfaceY = function() return 770 end },
}
storage.Packages.Knit.GetController = function(name)
	if name == "FishingController" then return { IsPreparing = function() return fishing end } end
	return { SetEventFishActive = function(_, active) tint = active end }
end
services.ReplicatedFirst = { Data = { FishesData = { A = fish } } }
local vectors = {}
local function vec() return setmetatable({}, vectors) end
vectors.__add, vectors.__mul = vec, vec
local shadowController = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/EventFishController.lua", {
	game = { GetService = function(_, name) return services[name] end }, require = function(value) return value end,
	Vector3 = { new = vec }, CFrame = { lookAt = function() return setmetatable({}, { __mul = function() return {} end }) end },
})
local created = 0
function shadowController:_makeShadow(selectedFish, slotId, startsAt)
	created += 1
	local model = { PrimaryPart = {}, effect = { Enabled = true }, PivotTo = function() end,
		Destroy = function(self) self.destroyed = true end }
	return { model = model, fishId = selectedFish.FishID, slotId = slotId, startsAt = startsAt,
		bodyToPivot = {}, topOffset = 10 }
end
shadowController:_update(600)
local first = shadowController._Shadow
assert(tint and first.model.Parent == workspace and animated == 1)
fishing = true
shadowController:_update(601)
assert(first.model.Parent == nil and first.model.effect.Enabled and disposed == 1,
	"Fishing locally hides the entire clone while retaining the authored effects")
fishing = false
shadowController:_update(602)
assert(first.model.Parent == workspace and animated == 2 and created == 1,
	"Leaving fishing within the window restores the same local silhouette")
shadowController:_update(630)
assert(not tint and not shadowController._Shadow and first.model.destroyed and disposed == 2)
attributes.StartsAt, attributes.EndsAt, attributes.SlotId = 1200, 1230, 2
fishing = true
shadowController:_update(1200)
assert(tint and not shadowController._Shadow and created == 1, "Players already fishing never flash the world silhouette")
fishing = false
shadowController:_update(1201)
local second = shadowController._Shadow
humanoid.Health = 0
shadowController:_update(1202)
assert(not shadowController._Shadow and second.model.destroyed, "Death releases the old visual and animation")
