local function read(path)
	local f = io.open(path, "r")
	if not f then return nil end
	local source = f:read("*a")
	f:close()
	return source
end
local prefix = "src/ReplicatedStorage/Modules/"
local config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local function instance(class, name)
	local object = { Name = name or class, children = {}, Transparency = 0.2, Color = "authored",
		Material = "plastic", MaterialVariant = "authored", Reflectance = 0.3, TextureID = "texture" }
	function object:IsA(kind)
		return kind == class or kind == "BasePart" and class == "MeshPart"
	end
	function object:GetChildren() return table.clone(self.children) end
	function object:GetDescendants()
		local list = {}
		for _, child in self.children do
			table.insert(list, child)
			for _, nested in child:GetDescendants() do table.insert(list, nested) end
		end
		return list
	end
	function object:FindFirstChild(key)
		for _, child in self.children do if child.Name == key then return child end end
	end
	function object:FindFirstChildOfClass(kind)
		for _, child in self.children do if child:IsA(kind) then return child end end
	end
	function object:Destroy() self.destroyed = true; self.Parent = nil end
	return setmetatable(object, {
		__index = function(self, key) if key == "Parent" then return rawget(self, "_parent") end end,
		__newindex = function(self, key, value)
			if key ~= "Parent" then rawset(self, key, value); return end
			local parent = rawget(self, "_parent")
			if parent then table.remove(parent.children, assert(table.find(parent.children, self))) end
			rawset(self, "_parent", value)
			if value then table.insert(value.children, self) end
		end,
	})
end
local body, surface, effect
local function clone()
	local model = instance("Model")
	body = instance("MeshPart")
	body.Parent = model
	body.CFrame = { ToObjectSpace = function() return {} end }
	model.PrimaryPart = body
	surface, effect = instance("SurfaceAppearance"), instance("ParticleEmitter")
	surface.Parent, effect.Parent, effect.Enabled = body, body, true
	function model:GetBoundingBox() return {}, { X = 5, Y = 3, Z = 10 } end
	function model:GetPivot() return {} end
	function model:GetScale() return 1 end
	function model:ScaleTo(value) self.scale = value end
	return model
end
local modules = {
	FishingConfig = config,
	EventFishConfig = { Shadow = { Length = 100, Transparency = 0.15 } },
	FishingAssets = { GetFish = function() return { Clone = clone } end },
	FishAnimationController = {}, WaterSurfaceUtil = {},
	ItemStatUtil = { GetModelBounds = function() return { maximum = { Y = 3 } } end },
}
local environment = setmetatable({
	script = { Parent = modules },
	game = { GetService = function(_, name)
		if name == "ReplicatedStorage" then return { Modules = modules, Packages = {
			Knit = { CreateController = function(controller) return controller end },
		} } end
		if name == "ReplicatedFirst" then return { Data = { FishesData = {} } } end
		return {}
	end },
	require = function(value) return value or {} end,
	Color3 = { new = function(r,g,b) return string.format("%g,%g,%g",r,g,b) end,
		fromRGB = function(r,g,b) return string.format("%g,%g,%g",r/255,g/255,b/255) end },
	Enum = { Material = { Neon = "neon", SmoothPlastic = "plastic" },
		HighlightDepthMode = { Occluded = "occluded" }, HumanoidDisplayDistanceType = { None = "none" } },
	Instance = { new = instance },
}, { __index = getfenv() })
local sharedSource = read(prefix .. "FishShadowAppearance.lua")
if sharedSource then modules.FishShadowAppearance = assert(load(sharedSource, "Shadow", "t", environment))() end
local bite = assert(load(read(prefix .. "FishingBiteSequence.lua"), "Bite", "t", environment))()
local fishingBody = {}
local reference = setmetatable({ highlight = {}, originals = {
	[fishingBody] = { transparency = 0.2, material = "plastic", color = "authored", reflectance = 0.3 },
}, surfaces = {} }, bite)
reference:_appearance(true, false, 0, "Holding", 0)
local controller = assert(load(read("src/StarterPlayer/StarterPlayerScripts/Controllers/EventFishController.lua"),
	"EventFishController", "t", environment))()
local shadow = controller:_makeShadow({ FishID = "Event", Model = "Event" }, 1, 600)
controller._Shadow = shadow
local highlight = assert(shadow.model:FindFirstChild("FishShadow"), "Event silhouette is missing the fishing Highlight")
for _, key in { "FillTransparency", "OutlineTransparency", "OutlineColor", "DepthMode", "Enabled" } do
	assert(highlight[key] == reference.highlight[key], "Event and fishing shadow differ in " .. key)
end
assert(highlight.FillColor == environment.Color3.new(0, 0, 0))
assert(body.Color == environment.Color3.new(0, 0, 0) and body.Material == fishingBody.Material)
assert(body.Transparency == fishingBody.Transparency and body.TextureID == "" and body.MaterialVariant == "")
assert(shadow.model:FindFirstChildOfClass("Humanoid"), "Transparent Highlight must use the same Humanoid rendering path")
assert(effect.Parent == body and effect.Enabled and not effect.destroyed, "Authored visual effects must survive")
assert(surface.Parent == nil and not surface.destroyed, "Texture surfaces are detached from the cloned silhouette")
controller:_clearShadow()
assert(surface.destroyed and shadow.model.destroyed, "Detached surfaces must be released with the silhouette")
