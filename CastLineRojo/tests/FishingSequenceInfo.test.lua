local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local prefix = "src/ReplicatedStorage/Modules/"
local harness = require("./helpers/RarityHarness")({
	GuiUtil = read(prefix .. "GuiUtil.lua"),
	RarityConfig = read(prefix .. "RarityConfig.lua"),
	RarityPresentation = read(prefix .. "RarityPresentation.lua"),
	ItemStatUtil = read(prefix .. "ItemStatUtil.lua"),
	TrainingProgress = read(prefix .. "TrainingProgress.lua"),
	WeightFormat = read(prefix .. "WeightFormat.lua"),
})
harness.addRarityTemplates()
local stats = harness.load("ItemStatUtil")
local training = harness.load("TrainingProgress")
local titles = { "Big", "Large", "Huge", "Colossal", "Gigantic", "Titanic", "Monstrous", "Cosmic", "Infinite" }
local minScales = { 3.6, 5.2, 6.6, 7.7, 8.7, 9.5, 10.4, 11.2, 12 }
local item = { DefaultWeight = 10, ModelDefaultScale = 3, DisplayName = "TestFish", Rarity = "Rare", CpsPrice = 100 }
for index, minScale in minScales do
	local fish = { DefaultWeight = 100, ModelDefaultScale = minScale }
	assert(stats.GetSizeTitle(fish, 100) == titles[index], "Include the exact total scale threshold")
	assert(stats.GetSizeTitle(fish, 99.999) == titles[index - 1], "Use the full total scale before rounding")
end
local seahorse = { DefaultWeight = 0.8, ModelDefaultScale = 1 }
local smallCatch = training.CalculateFishWeight(seahorse.DefaultWeight, 120)
assert(stats.GetSizeTitle(seahorse, smallCatch) == "Big", "Multiple growth steps on a small fish must use the total scale")
assert(stats.GetSizeTitle({ DefaultWeight = 80.6, ModelDefaultScale = 4.65 }, 80.6) == "Big",
	"A large species can have a title at its default weight")
local obsidianFang = { DefaultWeight = 56.3, ModelDefaultScale = 4.13 }
assert(stats.GetSizeTitle(obsidianFang, training.CalculateFishWeight(obsidianFang.DefaultWeight, 1500)) == "Infinite")
assert(stats.GetSizeTitle({ DefaultWeight = 1 }, 30 ^ 3) == "Infinite", "Cap the title at the last named tier")
assert(stats.FormatFishWeight({ DefaultWeight = 500, ModelDefaultScale = 3 }, 999) == "Big · 999 kg")
assert(stats.FormatFishWeight({ DefaultWeight = 999 }, 999) == "999 kg")
assert(stats.FormatFishWeight({}, 1200) == "1200 kg")
for _, weight in { 0, -1, math.huge, -math.huge, 0 / 0, "invalid" } do
	assert(stats.GetSizeTitle(item, weight) == nil, "Invalid catch weight must not show a title")
	assert(stats.FormatFishWeight(item, weight) == nil, "Invalid catch weight must not show a placeholder")
end
for _, weight in { 0, -1, math.huge, -math.huge, 0 / 0 } do
	assert(stats.GetSizeTitle({ DefaultWeight = weight }, 100) == nil, "Invalid default weight must not show a title")
end
assert(stats.GetSizeTitle({}, 100) == nil and stats.GetSizeTitle(item, nil) == nil, "Missing weights have no title")

local mutations = assert(loadstring(read("src/ReplicatedFirst/Data/MutationsData.lua")))()
local mutationUtil = assert(load(read(prefix .. "MutationDataUtil.lua"), "MutationDataUtil", "t", setmetatable({
	game = { GetService = function() return { Data = { MutationsData = mutations } } end },
	require = function(value) return value end,
	Color3 = harness.colors,
}, { __index = getfenv() })))()
local income = assert(load(read(prefix .. "PlotFishIncome.lua"), "PlotFishIncome", "t", setmetatable({
	script = { Parent = { FishInventoryData = {}, ItemStatUtil = stats, MutationDataUtil = mutationUtil, PlotPlacementUtil = {} } },
	require = function(value) return value end,
}, { __index = getfenv() })))()
local config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local liftMotion = assert(loadstring(read(prefix .. "FishingLiftMotion.lua")))()
local modules = {
	FishingConfig = config,
	FishingLiftMotion = liftMotion,
	FishInventoryData = {
		{ Rarity = "Common", DisplayChance = 50 },
		{ Rarity = "Uncommon", DisplayChance = 310 },
		{ Rarity = "Legendary", DisplayChance = 73457 },
	},
	GuiUtil = harness.load("GuiUtil"),
	ItemStatUtil = stats,
	MutationDataUtil = mutationUtil,
	NumberUtil = { FormatItemPriceCompact = tostring, FormatNumberWithComma = tostring },
	PlotFishIncome = income,
	RarityConfig = harness.load("RarityConfig"),
	RarityPresentation = harness.load("RarityPresentation"),
}
local dimensions = {}
dimensions.__index = dimensions
local function size(x, y)
	return setmetatable({ X = x, Y = y }, dimensions)
end
function dimensions:Lerp(other, alpha)
	return size(self.X + (other.X - self.X) * alpha, self.Y + (other.Y - self.Y) * alpha)
end
function dimensions.__add(left, right)
	return size(left.X + right.X, left.Y + right.Y)
end
local Chance = assert(load(read(prefix .. "FishingChanceReveal.lua"), "FishingChanceReveal", "t", setmetatable({
	script = { Parent = modules },
	require = function(value) return value end,
	Color3 = harness.colors,
	UDim = { new = function(scale, offset) return { Scale = scale, Offset = offset } end },
	UDim2 = { new = size, fromScale = size },
}, { __index = getfenv() })))()
modules.FishingChanceReveal = Chance
local Info = assert(load(read(prefix .. "FishingSequenceInfo.lua"), "FishingSequenceInfo", "t", setmetatable({
	game = { GetService = function(_, name)
		assert(name == "Players")
		return { LocalPlayer = { GetAttribute = function(_, attribute)
			assert(attribute == "BestOwnedFishBaseCps")
			return 100
		end } }
	end },
	script = { Parent = modules },
	require = function(value) return value end,
	Color3 = harness.colors,
	ColorSequence = { new = function(first, last) return { first, last } end },
	UDim2 = { fromScale = size },
}, { __index = getfenv() })))()

local function node(name, class, children)
	local object = { Name = name, Visible = true, children = children or {}, Color = "original gradient", Scale = 1 }
	object.Text, object.TextColor3, object.TextTransparency = "original text", "original color", 0
	object.Size, object.BackgroundTransparency = size(0.9, 1.1), 0.9
	function object:IsA(expected)
		return expected == class or expected == "GuiObject" and (class == "Frame" or class == "TextLabel")
	end
	function object:FindFirstChild(key)
		return self.children[key]
	end
	function object:GetFullName()
		return self.Name
	end
	function object:Destroy()
		if self.Parent then
			self.Parent.children[self.Name] = nil
			self.Parent = nil
		end
	end
	for _, child in object.children do
		child.Parent = object
	end
	return object
end
local function cloneLuck()
	local root = node("LuckMeter", "Frame")
	root.Glow, root.Word = node("Glow", "Frame"), node("Word", "Frame")
	local value = node("Value", "TextLabel")
	value.Size = size({ Scale = 1, Offset = 0 }, { Scale = 1, Offset = 0 })
	value.AbsoluteSize, value.TextBounds = size(200, 80), size(160, 60)
	value.ZIndex, value.UIGradient, value.TextStroke = 1, {}, { Transparency = 1 }
	function value:FindFirstChildOfClass(class)
		assert(class == "UIScale")
		return node("UIScale", "UIScale")
	end
	root.Value = value
	return root
end
function Chance:_burst(color, strength, strong)
	self.maxRevealScale = math.huge
	self.bursts = (self.bursts or 0) + 1
	self.burstColor, self.revealStrength, self.strongReveal = color, strength, strong
end
local function row(name)
	return node(name, "Frame", { Label = node("Label", "TextLabel") })
end
local mutationIds = { "Diamond", "Golden", "Mint", "Rainbow" }
local function assertMutation(info, expected)
	assert(info.mutationRow.Visible == (expected ~= nil), "Show the mutation row only for a supported mutation")
	for _, id in mutationIds do
		local label = info.mutationRow.children["MutationLabel_" .. id]
		assert(label.Visible == (id == expected), "Only the matching mutation label may be visible: " .. id)
		assert(label.Text == id and label.TextColor3 == id .. " color"
			and label.children.UIGradient.Color == id .. " gradient"
			and label.children.UIStroke.Color == id .. " stroke"
			and label.Size.X == 0.9 and label.Size.Y == 1.1,
			"Preserve the authored mutation text and style: " .. id)
	end
	local legacy = info.mutationRow.children.Label
	assert(not legacy.Visible and legacy.Text == "original text" and legacy.TextColor3 == "original color",
		"Keep the unused legacy label hidden and unchanged")
end
local function fixture(reuseScale, rarityVisible, tutorial)
	local name = row("Name")
	local nameLabel = harness.newInstance("TextLabel")
	nameLabel.Name, nameLabel.Text = "Label", "original text"
	nameLabel.TextColor3 = harness.colors.new(0.2, 0.3, 0.4)
	nameLabel.BackgroundColor3 = harness.colors.new(0.4, 0.3, 0.2)
	name._children = {}
	nameLabel.Parent, name.children.Label = name, nameLabel
	local authoredGradient = harness.newInstance("UIGradient")
	authoredGradient.Name, authoredGradient.Parent = "AuthoredGradient", nameLabel
	name.children.New = node("New", "Frame")
	name.children.New.Position = size(0.9, 0.02)
	local mutation = row("Mutation")
	mutation.children.Label.Visible = false
	for _, id in mutationIds do
		local label = node("MutationLabel_" .. id, "TextLabel", {
			UIGradient = node("UIGradient", "UIGradient"), UIStroke = node("UIStroke", "UIStroke"),
		})
		label.Parent, mutation.children[label.Name] = mutation, label
		label.Text, label.TextColor3, label.Visible = id, id .. " color", id == "Golden"
		label.children.UIGradient.Color, label.children.UIStroke.Color = id .. " gradient", id .. " stroke"
	end
	local gui = node("FishingSequenceGui", "ScreenGui", {
		LuckMeter = node("LuckMeter", "Frame", {
			Value = node("Value", "TextLabel", { UIGradient = node("UIGradient", "UIGradient") }),
			Glow = node("Glow", "Frame", { UIGradient = node("UIGradient", "UIGradient") }),
			UIScale = node("UIScale", "UIScale"),
		}),
		RevealInfo = node("RevealInfo", "Frame", {
			Name = name, Rarity = row("Rarity"), Mutation = mutation, Income = row("Income"), Weight = row("Weight"),
		}),
	})
	gui.AbsoluteSize = size(1920, 1080)
	gui.children.LuckMeter.Position = size(0, 0)
	gui.children.LuckMeter.Clone = cloneLuck
	local owner = { originals = {}, createdScales = {}, sounds = {}, attempts = {}, enabled = true, phase = "Preparing" }
	owner.options = { tutorial = tutorial }
	owner.celebrations = {}
	function owner:_celebrateCatch(bite)
		assert(not gui.children.LuckMeter.Visible and gui.children.RevealInfo.Visible,
			"Celebrate only after the catch information becomes visible")
		table.insert(self.celebrations, bite)
	end
	if reuseScale then
		local value = gui.children.LuckMeter.children.Value
		local scale = node("UIScale", "UIScale")
		scale.Parent, scale.Scale = value, 1.2
		value.children.UIScale = scale
	end
	gui.children.RevealInfo.children.Rarity.Visible = rarityVisible == true
	gui.children.RevealInfo.children.Weight.Visible = false
	function owner:_save(instance, properties)
		for _, property in properties do
			table.insert(self.originals, { instance = instance, property = property, value = instance[property] })
		end
	end
	function owner:_scale(value)
		local scale = value:FindFirstChild("UIScale")
		if scale then
			self:_save(scale, { "Scale" })
		else
			scale = node("UIScale", "UIScale")
			scale.Parent, value.children.UIScale = value, scale
			table.insert(self.createdScales, scale)
		end
		return scale
	end
	function owner:_sound(name, _, pitch)
		table.insert(self.attempts, { name = name, pitch = pitch })
		if self.enabled then
			table.insert(self.sounds, { name = name, pitch = pitch })
		end
	end
	return Info.new(gui, owner, 3.25, 10), owner
end

do
	local info, owner = fixture(false, false, true)
	assert(not info.luck.Visible and not info.reveal.Visible, "Keep luck hidden on the first tutorial frame")
	info:Update(10)
	owner.phase = "Waiting"
	info:SetLuck(5.5, 11, true)
	local bite = { fishConfig = item, catchWeight = 10, timeline = { phase = "Nibbling", startedAt = 11 } }
	for index, phase in { "Nibbling", "Escaped", "Bite", "Lifting", "Caught" } do
		bite.timeline.phase = phase
		bite.timeline.startedAt = 11 + index
		info:Update(11 + index, bite)
		assert(not info.luck.Visible, "Tutorial luck must stay hidden during " .. phase)
	end
	assert(info.reveal.Visible, "The tutorial must still show the catch")
	assert(#owner.attempts == 0, "Hidden tutorial luck must not trigger sounds")
	info:Destroy()
	for _, original in owner.originals do
		original.instance[original.property] = original.value
	end
	assert(info.luck.Visible, "Restore the authored luck visibility when leaving the tutorial")
	assert(info.newBadge.Position.X == 0.9, "Restore the placement of the catch badge")
end

do
	local info = fixture()
	local colors = {
		{ "FFFFFF", "CDD2E1" },
		{ "8CB4FF", "325AEB" },
		{ "AAFF96", "32DC50" },
		{ "D296FF", "8C32EB" },
		{ "FFC86E", "FF821E" },
		{ "FFFFFF", "FFD73C" },
	}
	local function checkColors(expected)
		local gradient = info.valueGradient.Color
		assert(info.glowGradient.Color == gradient, "Luck digits and glow must share their gradient")
		assert(gradient[1] == harness.colors.fromHex(colors[expected][1])
			and gradient[2] == harness.colors.fromHex(colors[expected][2]), "Unexpected cast progress gradient")
	end

	checkColors(1)
	for tier = 2, #colors do
		local threshold = (tier - 1) / #colors
		info:SetCastProgress(threshold - 1e-6)
		checkColors(tier - 1)
		info:SetCastProgress(threshold)
		checkColors(tier)
	end
	info:SetCastProgress(1)
	checkColors(6)
	info:SetCastProgress(0.4)
	checkColors(3)
	info:SetLuck(5000.25, 11, true)
	assert(info.shown == 5000.25 and info.value.Text == "5001X", "Round high luck up for display")
	checkColors(3)
	info:SetLuck(12000.5, 11)
	info:Update(12)
	assert(info.shown == 12000.5 and info.value.Text == "12001X", "Round the settled multiplier up for display")
	checkColors(3)
end

for _, reuseScale in { false, true } do
	local info, owner = fixture(reuseScale, reuseScale)
	local authoredGradient = info.name:FindFirstChild("AuthoredGradient")
	local authoredBackground, authoredTextColor = info.name.BackgroundColor3, info.name.TextColor3
	local holderScale, glowSize = info.luck.children.UIScale.Scale, info.glow.Size
	assert(info.luck.Visible and not info.reveal.Visible and info.value.Text == "1X", "Start with luck and hide result placeholders")
	assert(not info.name.Parent.children.New.Visible, "Do not display the NEW sample badge")
	assert(not info.rarityRow.Visible, "Hide rarity even when the authored row is visible")
	assertMutation(info, nil)
	info:Update(10.3)
	assert(info.shown > 1 and info.shown < 3.25 and info.scale.Scale > 1, "Roll the luck and punch at integer changes")
	assert(info.scale.Parent == info.value and info.luck.children.UIScale.Scale == holderScale and info.glow.Size == glowSize,
		"Only the value may change scale; the holder and glow dimensions must stay fixed")
	assert(#owner.sounds == 0, "The initial value must not play a sound")
	local previous = info.shown
	info:SetLuck(5, 10.3)
	assert(info.from == previous, "Retarget from the displayed luck")
	info:Update(11)
	assert(info.shown == 5 and info.value.Text == "5X" and info.lastWhole == 5, "Reach the exact server luck after a frame gap")
	assert(info.pulseAt == 11 and info.valueGradient.Color == info.glowGradient.Color, "Pulse at the new integer and keep the digit and glow gradients in sync")
	info:Update(11.6)
	assert(info.scale.Scale == info.baseScale and info.glow.BackgroundTransparency == info.glowTransparency, "Finish the punch without leaving scale changes")
	info:SetLuck(1000, 12)
	info:Update(13)
	assert(info.value.Text == "1000X", "High luck values must reach the target")
	info:SetLuck(1, 13)
	info:Update(14)
	assert(info.value.Text == "1X" and info.lastWhole == 1, "Retarget downward without stale styling")
	info:SetLuck(0.13, 14, true)
	assert(info.shown == 0.13 and info.value.Text == "1X", "Round positive luck below one up to one")
	info:SetLuck(5.01, 14.005, true)
	assert(info.shown == 5.01 and info.value.Text == "6X", "Round up immediately above an integer")
	info:SetLuck(5.5, 14.01, true)
	assert(info.shown == 5.5 and info.value.Text == "6X", "Immediate meter updates must not lag behind the bar")
	info:Update(14.5)
	assert(info.shown == 5.5, "An older rolling animation must not overwrite an immediate value")
	info:SetLuck(8, 15)
	info:Update(15.3)
	assert(info.shown > 5.5 and info.shown < 8, "Round luck must still roll after the cast is locked")
	info:SetLuck(8, 15.3, true)
	assert(info.shown == 8, "Immediate updates must settle even when the animated target is unchanged")

	local timing = liftMotion.Timing(config.Bite, false)
	local bite = { fishConfig = item, catchWeight = 33.75, mutationId = "Golden",
		isNewDiscovery = true,
		timeline = { phase = "Lifting", startedAt = 20 } }
	for _, elapsed in { timing.riseEnd, timing.fallStart, timing.landAt - 0.01 } do
		info:Update(20 + elapsed, bite)
		assert(info.luck.Visible and not info.reveal.Visible, "Keep the catch card hidden while the fish is airborne")
		assert(#owner.celebrations == 0, "Do not celebrate before the fish lands")
	end
	info:Update(20 + timing.landAt + 0.001, bite)
	assert(#owner.celebrations == 1 and owner.celebrations[1] == bite, "Celebrate on the landing frame")
	info:Update(20 + timing.landAt + 0.02, bite)
	assert(#owner.celebrations == 1, "Repeated reveal frames must not repeat the celebration")
	assert(not info.luck.Visible and info.reveal.Visible, "Switch the card on landing")
	assert(info.newBadge.Visible, "Show NEW for a server-confirmed first index discovery")
	local weightRow = info.reveal.children.Weight
	assert(info.name.Text == "TestFish", "Put the size title on the weight row")
	assert(weightRow.Visible and weightRow.children.Label.Text == "Big · 34 kg", "Display size and actual weight")
	assert(not info.rarityRow.Visible, "Keep rarity hidden when revealing a fish")
	assert(info.rarityRow.children.Label.Text == "original text"
		and info.rarityRow.children.Label.TextColor3 == "original color", "Leave the unused rarity label untouched")
	local rareGradient = assert(info.name:FindFirstChild("UIGradient_Rare"))
	assert(info.name.TextColor3 == harness.colors.new(1, 1, 1) and rareGradient.Enabled)
	assert(rareGradient.Color == modules.RarityPresentation.GetTemplate("Rare").Color and authoredGradient.Parent == nil)
	assertMutation(info, "Golden")
	assert(info.income.Text == "$414/s", "Use both actual weight and mutation for passive income")
	bite.timeline.phase = "Caught"
	info:Update(23, bite)
	assert(#owner.celebrations == 1, "Caught must not repeat the reveal celebration")
	assert(info.newBadge.Visible, "Keep NEW visible throughout the first catch showcase")
	assert(info.reveal.Visible and not info.rarityRow.Visible, "Keep catch information visible and rarity hidden while holding the fish")
	bite.timeline.phase = "Escaped"
	info:Update(24, bite)
	assert(not info.newBadge.Visible, "Clear NEW when leaving the previous reveal")
	assert(info.luck.Visible and not info.reveal.Visible, "Hide previous results when waiting for another fish")
	local nextFish = table.clone(item)
	nextFish.Rarity = "Uncommon"
	local normal = { fishConfig = nextFish, catchWeight = 10, isNewDiscovery = false,
		timeline = { phase = "Caught", startedAt = 25 } }
	info:Update(25, normal)
	assert(rareGradient.Parent == nil and #info.name:GetChildren() == 1 and info.name:FindFirstChild("UIGradient_Uncommon"),
		"A different rarity must replace the previous name gradient")
	assert(not info.newBadge.Visible, "A repeat catch of the same fish must hide NEW")
	assert(info.name.Text == "TestFish" and not info.mutationRow.Visible and not info.rarityRow.Visible and info.income.Text == "$100/s",
		"The next ordinary fish must clear the previous title and mutation")
	assert(weightRow.Visible and weightRow.children.Label.Text == "10 kg", "Below the first tier, display only the new weight")
	assertMutation(info, nil)
	normal.timeline.phase = "Reeling"
	info:Update(26, normal)
	assert(info.luck.Visible and not info.reveal.Visible, "Keep luck during an empty reel")
	info:Update(27, { fishConfig = item, catchWeight = 10, isNewDiscovery = true,
		timeline = { phase = "Caught", startedAt = 27 } })
	assert(info.newBadge.Visible, "Show NEW again for a later first discovery")
	info:Update(28, { fishConfig = item, catchWeight = 10, timeline = { phase = "Caught", startedAt = 28 } })
	assert(not info.newBadge.Visible, "Missing discovery confirmation must not retain the previous NEW badge")
	info:Destroy()
	info:Destroy()
	local stopped = info.value.Text
	info:SetLuck(9, 30)
	info:Update(31, normal)
	assert(info.value.Text == stopped, "Destroyed presentation must not continue updating")
	for _, original in owner.originals do
		original.instance[original.property] = original.value
	end
	for _, original in owner.originals do
		assert(original.instance[original.property] == original.value, "Restore all authored GUI properties between sessions")
	end
	for _, scale in owner.createdScales do
		scale:Destroy()
	end
	assert((info.value.children.UIScale ~= nil) == reuseScale, "Remove temporary value scales and preserve authored ones")
	assert(not weightRow.Visible and weightRow.children.Label.Text == "original text", "Restore the authored weight row")
	assert(#info.name:GetChildren() == 1 and info.name:FindFirstChild("AuthoredGradient") == authoredGradient)
	assert(info.name.BackgroundColor3 == authoredBackground and info.name.TextColor3 == authoredTextColor)
end

do
	local info, owner = fixture()
	for index, case in {
		{ id = "Golden", expected = "Golden", income = "$200/s" },
		{ id = "Diamond", expected = "Diamond", income = "$500/s" },
		{ id = "Rainbow", expected = "Rainbow", income = "$1000/s" },
		{ id = "Golden", expected = "Golden", income = "$200/s" },
		{ income = "$100/s" },
		{ id = "Unknown", income = "$100/s" },
		{ id = "Mint", income = "$100/s" },
		{ id = "", income = "$100/s" },
	} do
		info:Update(20 + index, { fishConfig = item, mutationId = case.id,
			timeline = { phase = "Caught", startedAt = 20 } })
		assertMutation(info, case.expected)
		assert(info.income.Text == case.income, "Keep existing mutation income calculation")
	end
	info:Destroy()
	for _, original in owner.originals do
		original.instance[original.property] = original.value
	end
	assert(info.mutationRow.children.MutationLabel_Golden.Visible,
		"Restore the authored visible Golden label after the presentation")
	for _, id in { "Diamond", "Mint", "Rainbow" } do
		assert(not info.mutationRow.children["MutationLabel_" .. id].Visible,
			"Restore authored hidden mutation labels")
	end
	for _, scale in owner.createdScales do scale:Destroy() end
end

-- 回放正式调用顺序：每帧先根据进度即时赋值，再更新信息面板。
do
	local info = fixture()
	info:Update(30, { fishConfig = { DisplayName = "Event", Rarity = "Event", CpsPrice = 1.2, DefaultWeight = 10 },
		catchWeight = 10, timeline = { phase = "Caught", startedAt = 30 } })
	assert(info.income.Text == "$120/s", "Event reveal uses the player's baseline, not the starter fallback")
	Info.FillReveal(info.reveal, { DisplayName = "Exclusive", Rarity = "Exclusive", CpsPrice = 0.8, DefaultWeight = 10 },
		10, "Golden", false)
	assert(info.income.Text == "$160/s", "Paid egg reveal uses the player's baseline and the mutation multiplier")
	assert(info.reveal.children.Weight.children.Label.Text == "10 kg", "Paid egg reveal shares the weight format")
	Info.FillReveal(info.reveal, item, nil, nil, false)
	assert(not info.reveal.children.Weight.Visible and info.reveal.children.Weight.children.Label.Text == "",
		"Clear the previous weight when there is no valid catch weight")
	info:Destroy()
end

for _, ceiling in { 1.3, 10, 100 } do
	for _, fps in { 30, 60, 144 } do
		local info, owner = fixture()
		owner.phase = "Waiting"
		info:SetLuck(ceiling * 0.1, 10, true)
		info:Update(10)
		for frame = 1, fps * 3 do
			local elapsed = frame / fps
			local progress = 1 - math.abs((elapsed / 1.5) % 2 - 1)
			local value = ceiling * (0.1 + 0.9 * progress)
			local whole, step = math.floor(value + 1e-6), math.floor(value * 10 + 1e-6)
			local expected = if whole ~= info.lastWhole then "LuckWhole"
				elseif step ~= info.lastStep then "LuckTick" else nil
			local before = #owner.sounds
			info:SetLuck(value, 10 + elapsed, true)
			info:Update(10 + elapsed)
			assert(#owner.sounds == before + (if expected then 1 else 0),
				"Lose or duplicate a crossing at " .. ceiling .. "X / " .. fps .. "fps / frame " .. frame)
			if expected then
				assert(owner.sounds[#owner.sounds].name == expected, "Integer crossings must win within a frame")
			end
		end
		info:Destroy()
		for _, scale in owner.createdScales do scale:Destroy() end
	end
end

do
	assert(config.Sounds.LuckTick.Id == "rbxassetid://137872392480008" and config.Sounds.LuckTick.Volume == 0.3,
		"Use Throw Food's light luck sound")
	assert(config.Sounds.LuckWhole.Id == "rbxassetid://113397864512278" and config.Sounds.LuckWhole.Volume == 0.85,
		"Use Throw Food's prominent integer sound")
	local info, owner = fixture()
	owner.phase = "Waiting"
	info:SetLuck(1, 10, true)
	info:Update(10)
	info:SetLuck(1.09, 10.1, true)
	assert(#owner.sounds == 0, "Changes within one tenth must stay quiet")
	info:SetLuck(1.1, 10.2, true)
	info:Update(10.2)
	assert(#owner.sounds == 1 and owner.sounds[1].name == "LuckTick", "A tenth-step change must play once")
	info:SetLuck(1.29, 10.23, true)
	info:Update(10.5)
	assert(#owner.sounds == 2 and owner.sounds[2].name == "LuckTick",
		"Fast consecutive crossings must play immediately without a cooldown")
	info:SetLuck(2.01, 10.6, true)
	assert(#owner.sounds == 3 and owner.sounds[3].name == "LuckWhole", "An integer crossing must take priority")
	info:SetLuck(1.99, 10.7, true)
	assert(#owner.sounds == 4 and owner.sounds[4].name == "LuckWhole", "Descending integer crossings must sound too")
	info:SetLuck(1.89, 10.8, true)
	assert(#owner.sounds == 5 and owner.sounds[5].name == "LuckTick", "Descending tenths must use the light sound")
	info:SetLuck(15.77, 11, true)
	assert(#owner.sounds == 6 and owner.sounds[6].name == "LuckWhole" and owner.sounds[6].pitch == 1.8,
		"A large frame jump must play one prominent sound with capped pitch")
	info:SetLuck(0.13, 11.1, true)
	assert(#owner.sounds == 7 and owner.sounds[7].pitch == 1, "Values below one must use the lowest integer pitch")
	info:SetLuck(0.24, 11.2, true)
	assert(#owner.sounds == 8 and owner.sounds[8].name == "LuckTick", "Tenths below one still play light sounds")
	info:SetLuck(0.24, 11.5, true)
	assert(#owner.sounds == 8, "An unchanged locked value must not repeat sounds")

	owner.enabled = false
	info:SetLuck(1.05, 11.7, true)
	local attempts = #owner.attempts
	assert(#owner.sounds == 8, "The game sound switch must mute new sounds")
	owner.enabled = true
	info:Update(12)
	assert(#owner.attempts == attempts, "Turning sound on must not replay muted changes")
	info:SetLuck(1.16, 12.1, true)
	assert(#owner.sounds == 9, "A fresh change after unmuting must play normally")
	owner.lockedMeterProgress = 0.5
	owner.phase = "Preparing"
	attempts = #owner.attempts
	info:SetLuck(3.2, 12.3, true)
	info:Update(12.5)
	assert(#owner.attempts == attempts, "Server confirmation while the meter is locked must stay quiet")
	owner.phase = "Waiting"
	info:SetLuck(3.31, 12.6, true)
	assert(#owner.sounds == 10, "New round luck may sound after the cast confirmation")
	info:SetLuck(8, 13)
	attempts = #owner.attempts
	info:Update(13.6, { fishConfig = item, catchWeight = 10, timeline = { phase = "Caught", startedAt = 13.6 } })
	info:Update(14.2)
	assert(#owner.attempts == attempts, "Hidden value changes must be consumed without delayed sounds")
	info:SetLuck(8.11, 14.3, true)
	assert(#owner.sounds == 11 and owner.sounds[11].name == "LuckTick", "Visible changes must resume normally")
	info:Destroy()
	info:SetLuck(10, 15, true)
	info:Update(16)
	assert(#owner.sounds == 11, "A destroyed value must not emit sounds")
end

do
	local info, owner = fixture()
	info:Update(10)
	info:SetLuck(100.25, 10.1, true)
	info:Update(10.1)
	assert(#owner.sounds == 0 and info.value.Text == "101X" and info.scale.Scale > info.baseScale,
		"Preparing must keep number feedback while progress owns the audio")
	owner.phase = "Casting"
	info:Update(10.2)
	assert(#owner.sounds == 0, "Leaving preparing must not replay consumed luck changes")
	owner.phase = "Waiting"
	info:SetLuck(101, 10.3, true)
	assert(#owner.sounds == 1 and owner.sounds[1].name == "LuckWhole", "Resume luck-value cues after the throw")
	info:Destroy()
	for _, scale in owner.createdScales do scale:Destroy() end
end

do
	local info, owner = fixture()
	owner.phase = "Approaching"
	local timing = { riseEnd = 0.4, fallStart = 0.5, landAt = 1.5, duration = 1.8 }
	local bite = { wasVisible = true, appearanceFade = 1, fishConfig = item, catchWeight = 10,
		timeline = { phase = "Approaching", startedAt = 11, struggleTime = 3, liftTiming = timing } }
	info:Update(11, bite)
	assert(info.luck.Visible and not info.chance, "Keep luck until the shadow becomes visible")
	bite.appearanceFade = 0.99
	info:Update(11.1, bite)
	assert(not info.luck.Visible and info.chance and info.chance.root.Visible and info.chance.value.Text == "1 in 1",
		"Show 1 in 1 in the first visible shadow frame")
	assert(info.chance.value.TextTransparency == 0 and info.chance.value.TextStroke.Transparency == 0,
		"Render the chance text and its outline while the chance frame is visible")
	for index, phase in { "Holding", "Nibbling", "Bite" } do
		bite.timeline.phase, bite.timeline.startedAt = phase, 11 + index
		info:Update(11 + index, bite)
		assert(info.chance.root.Visible and info.chance.value.Text == "1 in 1", "Hold at 1 in 1 while waiting for the hook")
	end
	local priorSounds = #owner.sounds
	bite.catchChanceDenominator = 999
	bite.timeline.phase, bite.timeline.startedAt = "Struggling", 14.5
	info:Update(14.5, bite)
	assert(info.chance.value.Text == "1 in 1", "Begin the confirmed roll at 1 in 1")
	info:Update(15.5, bite)
	local rolling = tonumber(info.chance.value.Text:match("^1 in (%d+)$"))
	assert(rolling and rolling > 1 and rolling < 999 and #owner.sounds == priorSounds + 1
		and owner.sounds[#owner.sounds].name == "LuckTick", "Roll and tick after the confirmed hook")
	bite.timeline.phase, bite.timeline.startedAt = "Lifting", 17.5
	info:Update(19, bite)
	assert(info.reveal.Visible and info.chance.root.Visible and info.chance.value.Text == "1 in 999",
		"Show the confirmed chance when the fish lands")
	info:Update(20, { timeline = { phase = "Waiting", startedAt = 20 } })
	assert(info.luck.Visible and not info.chance.root.Visible, "Start the next bite with luck restored")
	info:Update(21, { wasVisible = true, appearanceFade = 0.99,
		timeline = { phase = "Approaching", startedAt = 21 } })
	assert(info.chance.value.Text == "1 in 1", "Start a new shadow at 1 in 1")
	info:Destroy()
end

for _, case in {
	{ value = 309, rolling = "Common", final = "Common" },
	{ value = 310, rolling = "Common", final = "Uncommon" },
	{ value = 620, rolling = "Uncommon", final = "Uncommon" },
	{ value = 73457, rolling = "Uncommon", final = "Legendary" },
} do
	local info, owner = fixture()
	local presentation = modules.RarityPresentation
	local bite = {
		catchChanceDenominator = case.value,
		fishConfig = { DisplayName = "Common Fish", Rarity = "Common", DefaultWeight = 10, CpsPrice = 100 },
		catchWeight = 10,
		timeline = {
			phase = "Lifting", startedAt = 20, struggleTime = 3,
			liftTiming = { riseEnd = 0.4, fallStart = 0.5, landAt = 1.5, duration = 1.8 },
		},
	}
	info:Update(21.499, bite)
	local chance = info.chance
	assert(chance.value.Text == "1 in " .. tostring(case.value - 1)
		and chance.value.UIGradient.Color == presentation.GetTemplate(case.rolling).Color,
		"Use the rolling value's tier just before the reveal")
	local soundsBeforeReveal = #owner.sounds
	info:Update(21.5, bite)
	info:Update(21.6, bite)
	assert(chance.value.Text == "1 in " .. tostring(case.value)
		and chance.value.UIGradient.Color == presentation.GetTemplate(case.final).Color,
		"Use the final denominator's gradient at the reveal")
	assert(chance.burstColor == presentation.GetColor(case.final), "Use the same tier for the ring and stars")
	assert(chance.bursts == 1 and chance.revealStrength == 0 and chance.strongReveal == false,
		"Use the fish rarity for effect intensity and the single-ring reveal")
	local impact = owner.sounds[#owner.sounds]
	assert(#owner.sounds == soundsBeforeReveal + 1 and impact.name == "CatchRevealImpact"
		and impact.pitch == config.Sounds.CatchRevealImpact.Pitch, "Use the fish rarity for the reveal sound")
	info:Destroy()
end

do
	local info, owner = fixture(nil, nil, true)
	local timing = { riseEnd = 0.4, fallStart = 0.5, landAt = 1.5, duration = 1.8 }
	local bite = { wasVisible = true, appearanceFade = 0, fishConfig = item, catchWeight = 10,
		timeline = { phase = "Approaching", startedAt = 11, struggleTime = 3, liftTiming = timing } }
	local timeline = bite.timeline
	info:Update(11, bite, true)
	assert(not info.luck.Visible and (not info.chance or not info.chance.root.Visible),
		"The instruction image and chance preview must never be visible together")
	timeline.phase, timeline.startedAt, timeline.awaitingHook = "Struggling", 12, true
	info:Update(12, bite, false)
	assert(info.chance.root.Visible and info.chance.value.Text == "1 in 1" and #owner.sounds == 0,
		"Reveal a quiet starting value on the first frame without the guide")
	info:Update(12.5, bite, false)
	assert(info.chance.value.Text == "1 in 1" and #owner.sounds == 0, "Wait for the authoritative catch before rolling")
	timeline.phase, timeline.awaitingHook = "Escaped", nil
	info:Update(12.6, bite, false)
	assert(not info.chance.root.Visible, "A rejected hook must clear the preview")
	local retry = { wasVisible = true, appearanceFade = 0, fishConfig = item, catchWeight = 10,
		timeline = { phase = "Bite", startedAt = 15, struggleTime = 3, liftTiming = timing } }
	info:Update(15, retry, true)
	assert(not info.chance.root.Visible, "A new round with a guide must also hide the preview")
	retry.catchChanceDenominator = 60
	retry.timeline.phase, retry.timeline.startedAt = "Struggling", 15.1
	info:Update(16.1, retry, false)
	local rolling = tonumber(info.chance.value.Text:match("^1 in (%d+)$"))
	assert(info.chance.root.Visible and rolling and rolling > 1 and rolling < 60 and owner.sounds[1].name == "LuckTick")
	retry.timeline.phase, retry.timeline.startedAt = "Lifting", 18.1
	info:Update(19.61, retry, false)
	info:Update(19.62, retry, false)
	assert(info.chance.value.Text == "1 in 60" and info.chance.bursts == 1 and #owner.celebrations == 1)
	assert(#owner.sounds == 2 and owner.sounds[2].name == "CatchRevealImpact", "Play the reveal once")
	local root = info.chance.root
	info:Destroy()
	assert(not info.chance and not root.Parent, "Destroy the chance UI when the sequence ends")
end

for _, phase in { "Escaped", "Reeling", "Struggling" } do
	local info = fixture()
	local bite = { wasVisible = true, appearanceFade = 0, timeline = { phase = "Approaching", startedAt = 11 } }
	info:Update(11, bite)
	bite.timeline.phase, bite.timeline.startedAt = phase, 11.05
	info:Update(11.05, bite)
	assert(not info.chance.root.Visible and not info.luck.Visible, "Hide chance on " .. phase .. " without a confirmed catch")
	info:Destroy()
end

do
	local info = fixture()
	local bite = { isEgg = true, wasVisible = true, appearanceFade = 0,
		timeline = { phase = "Approaching", startedAt = 11 } }
	info:Update(11, bite)
	assert(info.luck.Visible and not info.chance, "Eggs keep their original display while approaching")
	info:Destroy()
end

do
	local info, owner = fixture()
	local timing = { riseEnd = 0.4, fallStart = 0.5, landAt = 1.5, duration = 1.8 }
	local bite = { fishConfig = item, catchWeight = 10,
		timeline = { phase = "Lifting", startedAt = 20, liftTiming = timing } }
	info:Update(20 + timing.landAt - 0.01, bite)
	assert(not info.reveal.Visible and #owner.celebrations == 0, "Respect the bite's own landing time")
	bite.timeline.phase, bite.timeline.startedAt = "Caught", 20 + timing.duration
	info:Update(22, bite)
	assert(info.reveal.Visible and #owner.celebrations == 1, "A skipped landing frame must still reveal")
	info:Update(22.1, bite)
	assert(#owner.celebrations == 1, "The Caught fallback must not repeat")
	info:Destroy()
end

do
	local info = fixture()
	local timing = liftMotion.Timing(config.Bite, true)
	local egg = { isEgg = true, fishConfig = item, catchWeight = 10,
		timeline = { phase = "Lifting", startedAt = 20, liftTiming = timing } }
	info:Update(20 + timing.riseEnd - 0.01, egg)
	assert(not info.reveal.Visible, "Keep the egg card hidden before its reveal")
	info:Update(20 + timing.riseEnd + 0.001, egg)
	assert(info.reveal.Visible, "The egg keeps its rise-end reveal")
	info:Destroy()
end
