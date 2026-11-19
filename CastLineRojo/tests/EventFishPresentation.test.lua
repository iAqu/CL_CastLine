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
local flags, signals = {}, {}
local function ui(children)
	return setmetatable({ Parent = true }, { __index = {
		IsA = function() return true end,
		FindFirstChild = function(_, key) return children[key] end,
	} })
end
local eventName, eventTime = ui({}), ui({})
local eventFrame = ui({ EventName = eventName, EventTime = eventTime })
local playerGui = ui({ HomeGui = ui({ LeftFrame = ui({ EventFrame = eventFrame }) }) })
local player = {
	FindFirstChildOfClass = function() return playerGui end,
	GetAttribute = function(_, flag) return flags[flag] end,
	GetAttributeChangedSignal = function(_, flag)
		return { Connect = function(_, callback) signals[flag] = callback end }
	end,
}
local function change(flag, value)
	flags[flag] = value
	if signals[flag] then signals[flag]() end
end
local gate = loadSource("src/ReplicatedStorage/Modules/EventPresentationGate.lua", {
	script = { Parent = { FishingOnboarding = loadSource("src/ReplicatedStorage/Modules/FishingOnboarding.lua", {}) } },
	require = function(value) return value end,
})
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
		EventPresentationGate = gate,
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

oldEvent = { EventType = "mutation", MutationId = "Golden", DisplayName = "Golden Water" }
render(0.1)
assert(eventFrame.Visible and eventName.Text == "Golden Water" and waterPart.Color == "golden")
change("FishingIntroActive", true)
assert(not eventFrame.Visible and waterPart.Color == "water" and texture.Color3 == "texture")
waterController:SetEventFishActive(true)
render(0.1)
assert(not eventFrame.Visible and waterPart.Color == "water", "Starting an activity inside the intro must not tint the water")
change("FishingOnboardingStage", "FirstCatch")
change("FishingIntroActive", false)
assert(not eventFrame.Visible and waterPart.Color == "water", "Keep activities hidden during the intro-to-onboarding handoff")
change("FishingOnboardingLessonActive", true)
change("FishingOnboardingStage", "Complete")
assert(not eventFrame.Visible and waterPart.Color == "water", "Caught the final fish but the gameplay camera has not returned")
waterController:SetEventFishActive(false)
oldEvent = { EventType = "mutation", MutationId = "Rainbow", DisplayName = "Rainbow Water" }
change("FishingOnboardingLessonActive", false)
assert(eventFrame.Visible and eventName.Text == "Rainbow Water" and waterPart.Color == "rainbow",
	"Return to the event that is live at the end, not the one active before the intro")
change("FishingIntroActive", true)
oldEvent = nil
change("FishingIntroActive", false)
assert(not eventFrame.Visible and waterPart.Color == "water", "Do not restore a finished event")

-- Exercise the actual local visibility lifecycle with lightweight visual fixtures.
local attributes = { Phase = "Active", StartsAt = 600, EndsAt = 630, SlotId = 1, FishId = "A" }
folder = { GetAttribute = function(_, key) return attributes[key] end }
storage.FindFirstChild = function(_, key) return if key == "EventFishState" then folder else nil end
local marker = object("BasePart", { Position = { X = 0, Z = 0 } })
local countdown = object("BillboardGui", { Parent = marker, Enabled = true, desired = true })
local markerParticles = object("ParticleEmitter", { Parent = marker, Enabled = true, desired = true, cleared = 0 })
function countdown:GetAttribute() return self.desired end
function markerParticles:GetAttribute() return self.desired end
function markerParticles:Clear() self.cleared += 1 end
function marker:GetDescendants() return { countdown, markerParticles } end
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
	EventPresentationGate = gate,
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

humanoid.Health = 100
shadowController:_update(1203)
local resumed = shadowController._Shadow
change("FishingOnboardingStage", "Train")
shadowController:_update(1204)
assert(not countdown.Enabled and not markerParticles.Enabled and markerParticles.cleared == 1)
assert(tint and not shadowController._Shadow and resumed.model.destroyed, "Keep the server activity live but remove its local fish")
local creationsWhileHidden = created
shadowController:_update(1205)
assert(created == creationsWhileHidden and not shadowController._Shadow)
change("FishingOnboardingStage", "Complete")
shadowController:_update(1206)
assert(shadowController._Shadow and created == creationsWhileHidden + 1)
change("FishingIntroActive", true)
shadowController:_update(1207)
markerParticles.desired = false
shadowController:_update(1230)
assert(not countdown.Enabled and not markerParticles.Enabled)
change("FishingIntroActive", false)
shadowController:_update(1231)
assert(countdown.Enabled and not markerParticles.Enabled,
	"Resume the marker countdown but leave an ended event's particles off")
