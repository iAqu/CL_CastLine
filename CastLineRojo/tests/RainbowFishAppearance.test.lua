local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local harness = require("./helpers/RarityHarness")({})
local instance = harness.newInstance
local white = harness.colors.new(1, 1, 1)
local golden = harness.colors.new(1, 0.7, 0)
local warnings = {}
local storage = harness.storage
storage.Modules = { MutationDataUtil = {} }
local mutationData = storage.Modules.MutationDataUtil
function mutationData.NormalizeMutationId(value)
	return if value == "Rainbow" or value == "Golden" or value == "Diamond" then value else nil
end
function mutationData.GetLabelColor()
	return golden
end

local chunk = assert(loadstring(read("src/ReplicatedStorage/Modules/MutationVisualUtil.lua")))
setfenv(chunk, setmetatable({
	game = { GetService = function(_, name)
		return if name == "ReplicatedStorage" then storage else {}
	end },
	require = function(value) return value end,
	warn = function(message) table.insert(warnings, message) end,
}, { __index = getfenv() }))
local visual = chunk()

local function child(parent, class, name)
	local value = instance(class)
	value.Name = name
	value.Parent = parent
	return value
end
local effects = child(storage, "Folder", "VFX")
local surfaces = child(effects, "Folder", "FishSurface")
local function template(folderName, mutation, map)
	local folder = surfaces:FindFirstChild(folderName) or child(surfaces, "Folder", folderName)
	local mesh = folder:FindFirstChild("Body") or child(folder, "Folder", "Body")
	local surface = child(mesh, "SurfaceAppearance", "SurfaceAppearance_" .. mutation)
	surface.ColorMap = map
	surface.Color = white
	return surface
end
local function fish()
	local model = instance("Model")
	local mesh = child(model, "MeshPart", "Body")
	mesh.Transparency = 0
	mesh.Color = white
	mesh.TextureID = "original-texture"
	function mesh:FindFirstChildOfClass(class)
		for _, value in self:GetChildren() do
			if value:IsA(class) then return value end
		end
		return nil
	end
	function model:GetDescendants()
		return { mesh }
	end
	return model, mesh
end
local function apply(modelName, mutation)
	local model, mesh = fish()
	visual.ApplyAppearance(model, mutation or "Rainbow", modelName)
	return mesh, mesh:FindFirstChildOfClass("SurfaceAppearance")
end

-- The real call site passes the compact model name, while Studio has a spaced directory.
local spaced = template("Moby Whale", "Rainbow", "moby-original-map")
local mesh, surface = apply("MobyWhale")
assert(surface, "A textured Rainbow fish must receive its authored surface despite spaces in the directory name")
assert(surface ~= spaced and surface.Parent == mesh, "Apply a clone to the display, never the stored template")
assert(surface.ColorMap == "moby-original-map", "Keep the original fish texture for tinting")
assert(mesh.TextureID == "original-texture", "Do not strip the original texture")
assert(spaced.Parent and spaced.Color == white, "Leave the shared template unchanged")

local exact = template("MobyWhale", "Rainbow", "exact-map")
local _, exactSurface = apply("MobyWhale")
assert(exactSurface and exactSurface.ColorMap == exact.ColorMap, "Exact directories must win over normalized aliases")

template("Twin Head Fish", "Rainbow", "map-one")
template("TwinHead Fish", "Rainbow", "map-two")
local _, ambiguous = apply("TwinHeadFish")
assert(not ambiguous, "Do not choose an arbitrary surface when normalized directory names collide")
assert(#warnings == 1, "Report an ambiguous directory with a warning")
apply("TwinHeadFish")
assert(#warnings == 1, "Repeated applications must not spam the same warning")

local untouched, missing = apply("MissingFish")
assert(not missing and untouched.Color == white, "Missing Rainbow assets must preserve the fish appearance")
local normal, normalSurface = apply("MobyWhale", "Normal")
assert(not normalSurface and normal.Color == white, "Normal fish must keep their authored appearance")

template("Golden Whale", "Golden", "gold-map")
template("Golden Whale", "Diamond", "diamond-map")
for _, mutation in { "Golden", "Diamond" } do
	local _, other = apply("GoldenWhale", mutation)
	assert(other and other.ColorMap == (if mutation == "Golden" then "gold-map" else "diamond-map"),
		"Other mutations must keep using their own surface templates")
end
local plain = apply("UntexturedFish", "Golden")
assert(plain.Color == golden, "Keep the existing color fallback for fish without surface templates")

local model, replacedMesh = fish()
local old = child(replacedMesh, "SurfaceAppearance", "PreviousSurface")
visual.ApplyAppearance(model, "Rainbow", "MobyWhale")
visual.ApplyAppearance(model, "Rainbow", "MobyWhale")
assert(old.Parent == nil and #replacedMesh:GetChildren() == 1, "Reapplying must replace the surface without duplicates")

