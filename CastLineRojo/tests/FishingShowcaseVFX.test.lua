local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local prefix = "src/ReplicatedStorage/Modules/"
local harness = require("./helpers/RarityHarness")({ RarityConfig = read(prefix .. "RarityConfig.lua") })
local config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local mutations = assert(loadstring(read("src/ReplicatedFirst/Data/MutationsData.lua")))()
local function loadModule(name, globals)
	local chunk = assert(loadstring(read(prefix .. name .. ".lua"), name))
	setfenv(chunk, setmetatable(globals, { __index = getfenv() }))
	return chunk()
end
local mutationUtil = loadModule("MutationDataUtil", {
	game = { GetService = function() return { Data = { MutationsData = mutations } } end },
	require = function(value) return value end,
})
local modules = { FishingConfig = config, RarityConfig = harness.load("RarityConfig"), MutationDataUtil = mutationUtil }
local created = {}
local sequence = { new = function(value)
	return value
end }
local vfx = loadModule("FishingShowcaseVFX", {
	script = { Parent = modules }, require = function(value) return value end,
	Color3 = harness.colors, ColorSequence = sequence, NumberSequence = sequence,
	NumberSequenceKeypoint = { new = function(time, value) return { Time = time, Value = value } end },
	NumberRange = { new = function(min, max) return { Min = min, Max = max } end },
	Vector2 = { new = function(x, y) return { X = x, Y = y } end },
	Vector3 = { one = {} }, CFrame = { new = function(value) return value end },
	Instance = { new = function(class)
		local instance = {}
		function instance:Destroy()
			self.Parent = nil
			self.destroyed = true
		end
		function instance:Emit(count)
			self.count = count
			self.emissions = (self.emissions or 0) + 1
		end
		created[class] = instance
		return instance
	end },
})
modules.FishingShowcaseVFX = vfx
local function bite(rarity, new, mutation, egg)
	return { fishConfig = { Rarity = rarity }, isNewDiscovery = new, mutationId = mutation, isEgg = egg }
end
for _, entry in modules.RarityConfig.List do
	assert(vfx.ShouldBurst(bite(entry.Name)) == (entry.Index >= modules.RarityConfig.Get("Legendary").Index),
		"Unexpected repeat-catch burst for " .. entry.Name)
end
assert(vfx.ShouldBurst(bite("Common", true)), "First discovery must burst")
for id in mutations do
	assert(vfx.ShouldBurst(bite("Common", false, id)), "Valid mutation must burst: " .. id)
end
for _, invalid in { "", "nil", "Unknown", 1, false } do
	assert(not vfx.ShouldBurst(bite("Common", false, invalid)), "Invalid mutation triggered stars")
end
assert(not vfx.ShouldBurst(bite(nil)) and not vfx.ShouldBurst(bite("Unknown")), "Unknown rarity must use Common")
local egg = bite("Legendary", true, "Rainbow", true)
assert(not vfx.ShouldBurst(egg) and not vfx.new(egg, 0), "Egg must not create either effect")

local function round(rarity, new)
	local fish = bite(rarity, new)
	fish.owner = { folder = {} }
	fish.fish = { Parent = {}, GetBoundingBox = function()
		return { Position = "center" }, { Magnitude = 10 }
	end }
	function fish.fish:Destroy()
		self.Parent = nil
	end
	fish.highlight = { Parent = {}, FillTransparency = 1, OutlineTransparency = 0, DepthMode = "occluded" }
	return fish
end
local function black(color)
	return color.R == 0 and color.G == 0 and color.B == 0
end
local common = round("Common")
local effect = vfx.new(common, 10)
assert(not effect.part and effect:Update(11.199), "Repeat Common needs only a 1.2-second outline")
common.highlight.OutlineColor = harness.colors.new(0, 0, 0)
effect:Update(11)
assert(common.highlight.OutlineColor == modules.RarityConfig.Get("Common").Color, "Frame update lost colored outline")
assert(not effect:Update(11.2) and black(common.highlight.OutlineColor), "Outline must return to black at 1.2 seconds")
assert(common.highlight.FillTransparency == 1 and common.highlight.DepthMode == "occluded", "Outline altered shadow rendering")
local rare = round("Rare", true)
effect = vfx.new(rare, 10)
local part, emitter = effect.part, created.ParticleEmitter
assert(part.Parent == rare.owner.folder and part.CFrame == "center" and not part.CanQuery and part.Anchored,
	"Stars must use an anchored, non-interactive part at the fish center")
assert(emitter.count == 70 and emitter.Parent == part and not emitter.Enabled and not emitter.LockedToPart,
	"Stars must emit once in world space")
assert(emitter.Lifetime.Min == 0.6 and emitter.Lifetime.Max == 1.3 and emitter.Speed.Max == 18,
	"Star lifetime and speed must match ThrowFood")
assert(emitter.Size[2].Value == 1.2 and emitter.Color == modules.RarityConfig.Get("Rare").Color,
	"Stars must use fish bounds and rarity color")
effect:Update(11.2)
assert(black(rare.highlight.OutlineColor) and part.Parent, "Star tail must survive the colored outline")
assert(effect:Update(12.499) and emitter.emissions == 1, "Stars must burst once")
assert(not effect:Update(12.5) and part.destroyed, "Star anchor must expire after 2.5 seconds")
effect:Destroy()
assert(not effect:Update(13), "Expired effect resumed")
effect = vfx.new(rare, 20)
part = effect.part
rare.fish.Parent = nil
assert(not effect:Update(20.1) and part.destroyed, "Destroyed fish leaked the star anchor")

-- 验证揭晓排队、逐帧去重及销毁后不会重建。
local confetti = 0
modules.UiConfettiUtil = { play = function()
	confetti += 1
end }
modules.FishShadowAppearance = { Destroy = function() end }
local env = { script = { Parent = modules }, require = function(value) return value or {} end,
	game = { GetService = function()
		return {}
	end } }
local Cast = loadModule("FishingCastSequence", env)
local Bite = loadModule("FishingBiteSequence", env)
local fish = setmetatable(round("Rare", true), Bite)
local owner = setmetatable({}, Cast)
owner:_celebrateCatch(fish)
owner:_celebrateCatch(fish)
assert(fish.showcasePending and not fish.showcaseVFX and confetti == 1, "Reveal must queue without early emission")
fish:_updateShowcaseVFX(0)
local first = fish.showcaseVFX
fish:_updateShowcaseVFX(0.1)
assert(fish.showcaseVFX == first and fish.showcasePlayed and not fish.showcasePending, "Repeated Present rebuilt VFX")
fish:_updateShowcaseVFX(2.5)
owner.celebratedBite = nil
owner:_celebrateCatch(fish)
fish:_updateShowcaseVFX(3)
assert(not fish.showcasePending and not fish.showcaseVFX, "Consumed showcase was replayed")
fish = setmetatable(round("Legendary"), Bite)
fish.surfaces = {}
fish.showcasePending = true
fish:_updateShowcaseVFX(0)
part = fish.showcaseVFX.part
fish:Destroy()
fish:Destroy()
fish:Present()
assert(part.destroyed and not fish.showcaseVFX and not fish.showcasePending, "Round exit leaked or resumed stars")
