local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local prefix = "src/ReplicatedStorage/Modules/"
local harness = require("./helpers/RarityHarness")({
	RarityConfig = read(prefix .. "RarityConfig.lua"),
	RarityPresentation = read(prefix .. "RarityPresentation.lua"),
})
harness.addRarityTemplates()
local presentation = harness.load("RarityPresentation")
local config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local chunk = assert(loadstring(read(prefix .. "FishingVignette.lua")))
setfenv(chunk, setmetatable({
	script = { Parent = { FishingConfig = config, RarityPresentation = presentation } },
	require = function(module) return module end,
	UDim2 = { fromOffset = function(x, y) return { X = x, Y = y } end },
}, { __index = getfenv() }))
local Vignette = chunk()

local function node(className, name, children)
	local object = { Name = name, Parent = true, children = children or {} }
	function object:IsA(class)
		return class == className
	end
	function object:FindFirstChild(key)
		return self.children[key]
	end
	function object:GetFullName()
		return name
	end
	return object
end

local function fixture()
	local holder = node("Frame", "Vignette")
	for index = 1, 26 do
		local stroke = node("UIStroke", "UIStroke")
		stroke.Color, stroke.Transparency, stroke.Thickness = "authored color", 1, 10
		local frame = node("Frame", "Ring" .. index, { UIStroke = stroke })
		frame.Size = "authored size"
		holder.children[frame.Name] = frame
	end
	local gui = node("ScreenGui", "FishingVignetteGui", { Vignette = holder })
	gui.Enabled, gui.AbsoluteSize = false, { X = 1920, Y = 1080 }
	local playerGui = node("PlayerGui", "PlayerGui", { FishingVignetteGui = gui })
	local owner = { originals = {} }
	function owner:_save(instance, properties)
		for _, property in ipairs(properties) do
			table.insert(self.originals, { instance = instance, property = property, value = instance[property] })
		end
	end
	return Vignette.new(playerGui, owner), gui, owner, playerGui
end

local function fish(name, phase)
	return { fishConfig = { Rarity = name }, timeline = { phase = phase or "Waiting" } }
end

local function near(actual, expected)
	assert(math.abs(actual - expected) < 1e-6, tostring(actual) .. " differs from " .. tostring(expected))
end

local view, gui, owner = fixture()
local bite = fish("Rare")
view:Update(0, bite)
assert(not gui.Enabled and view.rings[26].stroke.Transparency == 1, "Waiting must not reveal the rarity")
bite.timeline.phase = "Approaching"
view:Update(1, bite)
near(view.rings[26].stroke.Transparency, 1)
view:Update(1.15, bite)
assert(view.rings[26].stroke.Transparency > 0.46 and view.rings[26].stroke.Transparency < 1, "Fade in gradually")
view:Update(1.31, bite)
near(view.rings[26].stroke.Transparency, 0.46)
assert(gui.Enabled and view.rings[1].stroke.Transparency > view.rings[26].stroke.Transparency, "Keep the inner rings lighter")
for _, ring in ipairs(view.rings) do
	assert(ring.stroke.Color == presentation.GetColor("Rare"), "Use the fish's configured rarity color")
end
for index, phase in ipairs({ "Holding", "Nibbling", "Holding", "Bite", "Struggling", "Lifting", "Caught" }) do
	bite.timeline.phase = phase
	view:Update(2 + index, bite)
	near(view.rings[26].stroke.Transparency, 0.46)
	assert(view.startedAt == nil, "Phase changes must not restart the fade")
end
bite.timeline.phase = "Escaped"
view:Update(10, bite)
view:Update(10.15, bite)
assert(gui.Enabled and view.rings[26].stroke.Transparency > 0.46 and view.rings[26].stroke.Transparency < 1, "Fade out gradually")
view:Update(10.31, bite)
assert(not gui.Enabled and view.rings[26].stroke.Transparency == 1, "Escaping must finish the fade and disable the GUI")

-- 换轮立即清除旧强度，并只使用新一轮的稀有度。
local nextBite = fish("Legendary", "Approaching")
view:Update(11, nextBite)
view:Update(11.31, nextBite)
assert(view.rings[26].stroke.Color == presentation.GetColor("Legendary"), "Replace the color for the new round")
nextBite.timeline.phase = "Reeling"
view:Update(12, nextBite)
near(view.rings[26].stroke.Transparency, 0.46)
nextBite.timeline.phase = "Reeled"
view:Update(13, nextBite)
view:Update(13.1, nextBite)
local retry = fish("Unknown")
view:Update(13.11, retry)
assert(not gui.Enabled and view.rings[26].stroke.Transparency == 1, "Do not carry the previous fade into a retry")
assert(view.rings[26].stroke.Color == presentation.GetColor("Common"), "Unknown rarity falls back to Common")
retry.timeline.phase = "Reeling"
view:Update(14, retry)
assert(not gui.Enabled, "Reeling before a fish appears must not create a vignette")

-- 低帧率跨过 Approaching 时，后续可见阶段仍能触发；出画后不再重播。
local skippedApproach = fish("Epic", "Holding")
view:Update(15, skippedApproach)
view:Update(16, skippedApproach)
assert(gui.Enabled, "Reveal the vignette even if Approaching was skipped")
view:Update(17, nil)
assert(not gui.Enabled and view.rings[26].stroke.Transparency == 1, "Clear a removed round")

for _, size in ipairs({ { X = 390, Y = 844 }, { X = 844, Y = 390 }, { X = 1920, Y = 1080 } }) do
	gui.AbsoluteSize = size
	view:Update(18, nil)
	for index, ring in ipairs(view.rings) do
		assert(ring.frame.Size.X == ring.frame.Size.Y and ring.frame.Size.X > 0, "Keep circular rings at every aspect ratio")
		if index > 1 then
			local gap = ring.frame.Size.X - view.rings[index - 1].frame.Size.X
			assert(gap > 0 and ring.stroke.Thickness > gap, "Overlap neighboring rings without gaps")
		end
	end
	local outer = view.rings[26]
	assert(outer.frame.Size.X + outer.stroke.Thickness >= math.sqrt(size.X ^ 2 + size.Y ^ 2), "Cover viewport corners")
end

local caught = fish("Cosmic", "Caught")
view:Update(20, caught)
view:Update(21, caught)
assert(gui.Enabled, "Keep the vignette during the caught showcase")
view:Destroy()
view:Destroy()
view:Update(22, caught)
assert(not gui.Enabled and view.rings[26].stroke.Transparency == 1, "Destroyed sessions must never re-enable the overlay")
for _, original in ipairs(owner.originals) do
	original.instance[original.property] = original.value
end
assert(view.rings[1].frame.Size == "authored size" and view.rings[1].stroke.Color == "authored color", "Restore Studio-authored values on cleanup")

local partial, _, partialOwner, playerGui = fixture()
partial:Destroy()
table.clear(partialOwner.originals)
playerGui.children.FishingVignetteGui.children.Vignette.children.Ring26 = nil
local ok = pcall(Vignette.new, playerGui, partialOwner)
assert(not ok and #partialOwner.originals == 0, "Reject incomplete presets before changing any UI properties")
