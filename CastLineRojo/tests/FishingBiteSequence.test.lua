local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local water = { GetWaterSurfaceY = function() return 0 end }
local environment = setmetatable({
	Vector3 = { new = function(x, y, z) return { X = x, Y = y, Z = z } end },
	Enum = {
		Material = { Neon = "neon" },
		HighlightDepthMode = { Occluded = "occluded", AlwaysOnTop = "always-on-top" },
	},
	Color3 = {
		new = function(r, g, b) return string.format("%g,%g,%g", r, g, b) end,
		fromRGB = function(r, g, b) return string.format("%g,%g,%g", r / 255, g / 255, b / 255) end,
	},
	script = {
		Parent = {
			FishingConfig = "config",
			FishingLiftMotion = "lift",
			FishAnimationController = "fish-animation",
			FishDripEffect = "fish-drip",
			FishSecondaryMotion = "secondary",
			FishRepositionPath = "reposition",
			FishingReelSpring = "reel",
			ItemStatUtil = "stats",
			MutationVisualUtil = "mutation",
			WaterSurfaceUtil = "water",
		},
	},
	game = {
		GetService = function()
			return {}
		end,
	},
	require = function(name)
		if name == nil then return {} end
		if name == "lift" then return dofile("src/ReplicatedStorage/Modules/FishingLiftMotion.lua") end
		if name == "water" then return water end
		if name == "fish-animation" or name == "fish-drip" or name == "secondary" or name == "reel" or name == "water"
			or name == "mutation"
		then
			return {}
		end
		if name == "reposition" then
			return require("../src/ReplicatedStorage/Modules/FishRepositionPath")
		end
		if name == "stats" then
			return { GetScaleRatio = function(_, weight)
				assert(weight == 64000, "Use the weight returned by the server")
				return 4.2, 4.3
			end }
		end
		assert(name == "config")
		return config
	end,
}, { __index = getfenv() })
environment.script.Parent.BaitElasticMotion = "elastic"
local baseRequire = environment.require
local Elastic = assert(load(read("src/ReplicatedStorage/Modules/BaitElasticMotion.lua"), "Elastic", "t", environment))()
environment.require = function(name)
	return if name == "elastic" then Elastic else baseRequire(name)
end
environment.script.Parent.FishShadowAppearance = "shadow"
local shadowAppearance = assert(load(read("src/ReplicatedStorage/Modules/FishShadowAppearance.lua"), "Shadow", "t", environment))()
local withElastic = environment.require
environment.require = function(name)
	return if name == "shadow" then shadowAppearance else withElastic(name)
end

local Bite = assert(
	load(read("src/ReplicatedStorage/Modules/FishingBiteSequence.lua"), "FishingBiteSequence", "t", environment)
)()
local settings = config.Bite

-- 高游速不能把可读动作压缩到一两帧；同一输入仍使用同一绝对时钟。
do
	local rng = {
		NextInteger = function(_, low) return low end,
		NextNumber = function(_, low, high) return (low + high) / 2 end,
	}
	for _, speed in ipairs({ 8, 25.1, 44.5, 1000 }) do
		local state = Bite.NewTimeline(0, rng, 0, { SwimSpeed = speed, HookWindow = 0.55 })
		assert(state.approachTime >= 0.75, "Fast fish approached before their appearance could be read")
		assert(state.swimSpeed == speed and state.hookWindow == 0.55, "Motion limits changed fish data or hook difficulty")
		local motion = Bite.NewMotion(0, rng, 6, 3, speed)
		for _, entry in ipairs(motion.nibbles) do
			assert(entry.attackTime >= 0.12 and entry.attackTime <= 0.20, "Nibble attack escaped readable timing bounds")
		end
	end
end

-- 验证真实建路入口传入的半径，同时保留鱼蛋的原始规则和路径时序。
do
	local path = environment.require("reposition")
	local originalNew, originalSample = path.new, Elastic.Sample
	local capturedRadius, capturedSpeed, capturedTurnRate
	path.new = function(_, _, radius, speed, _, _, turnRate)
		capturedRadius, capturedSpeed, capturedTurnRate = radius, speed, turnRate
		return { duration = 2.5 }
	end
	Elastic.Sample = function()
		return nil, 1
	end
	local baitSize = setmetatable({ Y = 1 }, { __mul = function(value)
		return value
	end })
	for _, fixture in ipairs({
		{ halfLength = 0.1, scale = 1, multiplier = 1, expected = 0.5 },
		{ halfLength = 5, scale = 2, multiplier = 0.35, expected = 3.5 },
		{ halfLength = 20, scale = 1, multiplier = 0.3, expected = 6 },
		{ halfLength = 20, scale = 2, multiplier = 0.95, expected = 6 },
		{ halfLength = 20, scale = 2, multiplier = 0.95, expected = 38, isEgg = true },
		{ halfLength = 0.1, scale = 1, multiplier = 1, expected = 0.5, isEgg = true },
		{ halfLength = 5, scale = 2, multiplier = 0.35, expected = 3.5, speed = 44.5, returnSpeed = 1.2 },
		{ halfLength = 5, scale = 2, multiplier = 0.35, expected = 3.5, speed = 44.5, returnSpeed = 0.8 },
		{ halfLength = 5, scale = 2, multiplier = 0.35, expected = 3.5, speed = 44.5, returnSpeed = 1.2, isEgg = true },
	}) do
		local round = setmetatable({
			halfLength = fixture.halfLength,
			defaultScale = fixture.scale,
			isEgg = fixture.isEgg,
			owner = { baitBaseSize = baitSize },
			timeline = { swimSpeed = fixture.speed or 8, turnRadiusScale = fixture.multiplier },
			motion = { nibbles = { {
				beforeGap = 1, beforeYaw = 0, gap = 1, yaw = 0,
				returnAt = 0.18, nibbleSpeed = 1, attackTime = 0.12, depth = 0.06, returnSpeed = fixture.returnSpeed or 1,
			} } },
			_restMouth = function()
				return { Y = 0 }
			end,
			_contactOffset = function()
				return { X = 0, Z = 0 }
			end,
			_frameAtMouth = function(_, mouth)
				return { Position = mouth, LookVector = { X = 1, Z = 0 } }
			end,
		}, Bite)
		round:_prepareRepositions()
		assert(capturedRadius == fixture.expected, "Return radius violated fish/egg bounds")
		local rawSpeed = (fixture.speed or 8) * settings.Nibble.ReturnSpeedScale * (fixture.returnSpeed or 1)
		assert(capturedSpeed == (if fixture.isEgg then rawSpeed else math.min(rawSpeed, 10)), "Return speed cap missed per-nibble variation")
		assert(capturedTurnRate == (if fixture.isEgg then nil else math.rad(140)), "Fish turn limit leaked into egg motion")
		assert(round.timeline.repositionDurations[1] == 2.5, "Do not replace the planned path duration")
	end
	path.new, Elastic.Sample = originalNew, originalSample
end

local caught = setmetatable({}, Bite)
caught:SetCaughtWeight(64000)
assert(caught:_scaleAt("Bite", 0) == 1, "Keep the pre-catch size for bite timing")
assert(caught:_scaleAt("Lifting", 0) == 1, "Start the lift at the pre-catch size")
for index = 1, 100 do
	assert(caught:_scaleAt("Lifting", caught:GetLiftTiming().duration * index / 100) <= 4.3, "Limit the lift animation peak")
end
assert(caught:_scaleAt("Caught", 0) == 4.2, "Hold the final fish size at the shared weight scale")

local scaled = setmetatable({ defaultScale = 1.5 }, Bite)
scaled:SetCaughtWeight(64000)
for _, phase in { "Settling", "Waiting", "Approaching", "Holding", "Nibbling", "Bite", "Struggling", "Escaped", "Reeling" } do
	assert(scaled:_scaleAt(phase, 0) == 1.5, "Apply the base size throughout underwater fishing: " .. phase)
end
assert(scaled:_scaleAt("Lifting", 0) == 1.5, "Start the lift at the base size without a jump")
for index = 1, 100 do
	assert(scaled:_scaleAt("Lifting", caught:GetLiftTiming().duration * index / 100) <= 4.3, "Cap the combined animated size")
end
assert(math.abs(scaled:_scaleAt("Lifting", scaled:GetLiftTiming().duration) - 4.2) < 1e-5, "Finish the lift at the final size")
assert(scaled:_scaleAt("Caught", 0) == 4.2, "Do not multiply the base size twice after catching")
local unweighed = setmetatable({ defaultScale = 1.5 }, Bite)
assert(unweighed:_scaleAt("Caught", 0) == 1.5, "Preview rounds without a caught weight must keep their base size")

local small = setmetatable({ presentationRadius = 1, mouthOffset = { Magnitude = 0.5 } }, Bite)
assert(small:GetShowcaseHeight() == settings.ShowcaseHeight, "Keep the original height for small fish")
for _, shape in { { radius = 1, mouth = 0 }, { radius = 5, mouth = 4 } } do
	caught.presentationRadius, caught.mouthOffset = shape.radius, { Magnitude = shape.mouth }
	local height = caught:GetShowcaseHeight()
	assert(height > settings.ShowcaseHeight, "Raise the showcase for larger fish")
	assert(height - caught:GetShowcaseRadius() >= settings.WaterClearance - 0.00001, "Keep the animated fish above water")
	for index = 0, 100 do
		local bounce = index / 100
		local timing = caught:GetLiftTiming()
		local elapsed = timing.landAt + (timing.duration - timing.landAt) * bounce
		local lowest = height + settings.LiftBounceHeight * Elastic.Rebound(bounce)
			- caught.presentationRadius * caught:_scaleAt("Lifting", elapsed)
		assert(lowest >= settings.WaterClearance - 0.00001, "Keep the whole fish above water during rebound")
	end
end

-- 确定性验证每个有效鱼种均可被抽到，不依赖概率容差或抽样运气。
assert(settings.FishName == nil, "Default fish selection must be random")
local function fishTemplate(name, className, primaryPart)
	return {
		Name = name,
		PrimaryPart = primaryPart,
		IsA = function(_, expected)
			return className == expected
		end,
	}
end
local first = fishTemplate("First", "Model", {})
local second = fishTemplate("Second", "Model", {})
local invalid = fishTemplate("NoPrimaryPart", "Model", nil)
local nested = fishTemplate("Nested", "Folder", nil)
nested.children = { fishTemplate("NestedFish", "Model", {}) }
local children = { nested, first, invalid, fishTemplate("Decoration", "Part", {}), second }
local fishFolder = {
	GetChildren = function() return children end,
	FindFirstChild = function(_, name)
		for _, child in ipairs(children) do
			if child.Name == name then return child end
		end
		return nil
	end,
}
local picks, pick = 0, 1
local selectionRandom = {
	NextInteger = function(_, low, high)
		assert(low == 1 and high == 2, "Invalid instances entered the random fish pool")
		picks += 1
		return pick
	end,
}
assert(Bite.SelectFishTemplate(fishFolder, selectionRandom) == first)
pick = 2
assert(Bite.SelectFishTemplate(fishFolder, selectionRandom) == second)
assert(Bite.SelectFishTemplate(fishFolder, selectionRandom) == second, "Consecutive repeats must be allowed")
assert(picks == 3, "Each selection must use exactly one random draw")

-- 默认入口自行创建随机源，既不复用也不推进玩法/表现的随机流。
local randomCreations = 0
environment.Random = { new = function()
	randomCreations += 1
	return selectionRandom
end }
assert(Bite.SelectFishTemplate(fishFolder) == second)
assert(randomCreations == 1 and picks == 4, "Default fish selection did not use an independent random source")
environment.Random = nil

children = { first }
assert(Bite.SelectFishTemplate(fishFolder, {
	NextInteger = function(_, low, high)
		assert(low == 1 and high == 1, "Single-fish pool has the wrong bounds")
		return 1
	end,
}) == first)

local function selectionError(folder, expected)
	local ok, err = pcall(Bite.SelectFishTemplate, folder, selectionRandom)
	assert(not ok and string.find(tostring(err), expected, 1, true), "Missing explicit fish selection error")
end
children = { invalid, nested }
selectionError(fishFolder, "no valid fish models with a PrimaryPart")
children = {}
selectionError(fishFolder, "no valid fish models with a PrimaryPart")
selectionError(nil, "no valid fish models with a PrimaryPart")
children = { first, second, invalid }
settings.FishName = "First"
assert(Bite.SelectFishTemplate(fishFolder, selectionRandom) == first and picks == 4,
	"Explicit fish override must bypass random selection")
settings.FishName = "NoPrimaryPart"
selectionError(fishFolder, "Models.Fish.NoPrimaryPart is missing or invalid")
settings.FishName = "Missing"
selectionError(fishFolder, "Models.Fish.Missing is missing or invalid")
settings.FishName = nil

-- 通过正式外观入口采样，防止鱼身、填充与描边的端点和缓动脱节。
local function appearanceProbe()
	local part = { Transparency = 1, Color = "shadow", TextureID = "" }
	local surface, parent = {}, {}
	local highlightValues = { Enabled = false }
	local highlight = setmetatable({}, {
		__index = highlightValues,
		__newindex = function(_, key, value)
			if key == "Enabled" and value then
				assert(part.Transparency < 1, "Highlight enabled before the fish appearance was applied")
				assert(
					highlightValues.FillTransparency < 1 or highlightValues.OutlineTransparency < 1,
					"Highlight enabled with stale transparency"
				)
			end
			highlightValues[key] = value
		end,
	})
	local instance = setmetatable({
		highlight = highlight,
		originals = {
			[part] = {
				transparency = 0.2,
				color = "original",
				texture = "fish-texture",
				material = "plastic",
				materialVariant = "fish-variant",
				reflectance = 0.3,
			},
		},
		surfaces = { { instance = surface, parent = parent } },
	}, Bite)
	return instance, part, surface, parent
end

for _, rate in ipairs({ 30, 60, 144 }) do
	local instance, part = appearanceProbe()
	local previous = 0
	for frame = 0, rate do
		local fade = frame / rate
		instance:_appearance(true, false, fade)
		local eased = fade * fade * (3 - 2 * fade)
		assert(math.abs(part.Transparency - (0.2 + 0.8 * eased)) < 1e-9, "Fish fade lost shared easing")
		assert(
			math.abs(
				instance.highlight.FillTransparency
					- (settings.ShadowTransparency + (1 - settings.ShadowTransparency) * eased)
			) < 1e-9,
			"Shadow fade lost shared easing"
		)
		assert(
			math.abs(instance.highlight.OutlineTransparency - (0.2 + 0.8 * eased ^ 3)) < 1e-9,
			"Shadow outline did not retain contrast through the fade"
		)
		assert(instance.highlight.OutlineColor == environment.Color3.fromRGB(254, 254, 254), "Shadow outline changed")
		assert(instance.highlight.DepthMode == "occluded", "Shadow highlight must respect scene occlusion")
		assert(part.Transparency >= previous, "Fade reversed")
		assert(instance.highlight.Enabled == (fade < 1), "Fully transparent shadow is still enabled")
		assert(part.Material == (if fade < 1 then "neon" else "plastic"), "Shadow rendering material is wrong")
		assert(part.MaterialVariant == (if fade < 1 then "" else "fish-variant"), "Shadow retained a material override")
		assert(part.Reflectance == (if fade < 1 then 0 else 0.3), "Shadow reflectance was not set or restored")
		previous = part.Transparency
		instance:_appearance(true, false, fade)
		assert(part.Transparency == previous, "Repeated sampling changed appearance")
	end
	for frame = rate, 0, -1 do
		instance:_appearance(true, false, frame / rate)
		assert(part.Transparency <= previous, "Fade-in reversed")
		previous = part.Transparency
	end
	instance:_appearance(false, false, 0)
	assert(part.Transparency == 1 and not instance.highlight.Enabled, "Hidden fish retained geometry")
	assert(
		part.Material == "plastic" and part.MaterialVariant == "fish-variant",
		"Hidden fish retained the shadow material"
	)
	assert(
		instance.highlight.FillTransparency == 1 and instance.highlight.OutlineTransparency == 1,
		"Hidden fish retained shadow"
	)
	instance:_appearance(true, false, 2)
	assert(part.Transparency == 1 and not instance.highlight.Enabled, "Fade overflow exposed fish")
	instance:_appearance(true, false, -1)
	assert(
		part.Transparency == 0.2 and instance.highlight.FillTransparency == settings.ShadowTransparency,
		"Fade underflow changed resting appearance"
	)
end
do
	local instance, part = appearanceProbe()
	assert(settings.Struggle.HighlightFadeTime == 0.5, "Struggle highlight fade duration changed")
	local previous = settings.ShadowTransparency
	for _, elapsed in ipairs({ 0, 0.125, 0.25, 0.375, 0.5, 1, settings.StruggleTime }) do
		instance:_appearance(true, false, 0, "Struggling", elapsed)
		local progress = math.clamp(elapsed / settings.Struggle.HighlightFadeTime, 0, 1)
		local eased = progress * progress * (3 - 2 * progress)
		local transparency = instance.highlight.FillTransparency
		assert(
			math.abs(transparency - (settings.ShadowTransparency + (1 - settings.ShadowTransparency) * eased)) < 1e-9,
			"Struggle highlight did not follow fade timing"
		)
		assert(transparency >= previous, "Struggle highlight fade reversed")
		assert(
			math.abs(instance.highlight.OutlineTransparency - (0.2 + 0.8 * eased ^ 3)) < 1e-9,
			"Struggle outline did not follow its fade curve"
		)
		assert(instance.highlight.Enabled == (progress < 1), "Struggle highlight remained enabled after fade")
		assert(part.Transparency == 0.2 and instance.appearanceFade == 0, "Struggle highlight fade hid fish geometry")
		assert(part.Material == "neon" and part.MaterialVariant == "", "Highlight fade changed fish shadow material")
		previous = transparency
	end
	-- 跨帧直接进入出水，尚未恢复原外观时也不能重新启用高亮。
	instance = appearanceProbe()
	instance:_appearance(true, false, 0, "Struggling", 0.1)
	for _, phase in ipairs({ "Lifting", "Caught" }) do
		instance:_appearance(true, false, 0, phase, 0)
		assert(
			not instance.highlight.Enabled
				and instance.highlight.FillTransparency == 1
				and instance.highlight.OutlineTransparency == 1,
			"Highlight flashed back during lift or showcase"
		)
	end
end
do
	local instance, part, surface, parent = appearanceProbe()
	instance:_appearance(true, true, 0, "Lifting", 0.5)
	assert(part.Color == "original" and part.TextureID == "fish-texture", "Original fish appearance was not restored")
	assert(
		part.Material == "plastic" and part.MaterialVariant == "fish-variant" and part.Reflectance == 0.3,
		"Original fish material was not restored"
	)
	assert(surface.Parent == parent and instance.originalShown, "Original surface was not restored")
	assert(
		instance.highlight.Enabled and instance.highlight.FillTransparency == 1
			and instance.highlight.OutlineTransparency == 0 and instance.highlight.OutlineColor == "0,0,0"
			and instance.highlight.DepthMode == "occluded",
		"Surfaced fish did not switch to an occluded black outline"
	)
	instance:_appearance(true, true, 0, "Caught", 5)
	assert(part.Transparency == 0.2 and surface.Parent == parent, "Original appearance was not stable")
	assert(instance.highlight.Enabled and instance.highlight.OutlineTransparency == 0, "Showcase lost its outline")
	for _, fade in ipairs({ 0.25, 0.5, 0.75, 1, 2, -1 }) do
		instance:_appearance(true, true, fade, "Caught", 5)
		local progress = math.clamp(fade, 0, 1)
		local eased = progress * progress * (3 - 2 * progress)
		assert(instance.highlight.OutlineTransparency == eased, "Caught outline did not follow fish fade")
		assert(instance.highlight.Enabled == (progress < 1), "Invisible caught fish retained an outline")
		assert(instance.highlight.FillTransparency == 1, "Caught outline filled the fish")
		assert(part.Color == "original" and part.TextureID == "fish-texture", "Caught outline changed fish appearance")
	end
	instance:_appearance(false, true, 0, "Caught", 5)
	assert(
		part.Transparency == 1 and not instance.highlight.Enabled and instance.highlight.OutlineTransparency == 1,
		"Hidden caught fish retained an outline"
	)
end

local function timeline(count, delay, startedAt, readyAt)
	startedAt = startedAt or 10
	return Bite.NewTimeline(startedAt, {
		NextInteger = function(_, minimum, maximum)
			assert(minimum == 0 and maximum == settings.MaxNibbles)
			return count
		end,
		NextNumber = function(_, minimum, maximum)
			if minimum == 1 and maximum == 3 then
				return delay or 2
			end
			assert(minimum == 0.8 and maximum == 1.4)
			return 1
		end,
	}, readyAt or startedAt + 0.5)
end

local function biteAt(count)
	return 10 + 2 + settings.ApproachTime + 1 + count * (settings.NibbleTime + 1)
end

for _, delay in ipairs({ 1, 2, 3 }) do
	local state = timeline(0, delay)
	assert(state:Advance(10.49) == "Settling")
	assert(state:Advance(10.5) == "Waiting")
	assert(state:Advance(10 + delay - 0.001) == "Waiting")
	assert(state:Advance(10 + delay) == "Approaching", "Appearance delay must start at impact, not after rebound")
	local retry = timeline(0, delay, 100, 100)
	assert(retry:Advance(100) == "Waiting")
	assert(retry:Advance(100 + delay) == "Approaching", "Retry delay must start at rebaiting")
end

for _, count in ipairs({ 0, settings.MaxNibbles }) do
	local state, nibbleCount = timeline(count), 0
	assert(not state:TryHook(9.99) and state.phase == "Settling", "Ignore input during landing rebound")
	state:Advance(10.5)
	assert(state.phase == "Waiting")
	while state.phase ~= "Bite" do
		state:Advance(state.endsAt)
		if state.phase == "Nibbling" then
			nibbleCount += 1
		end
	end
	assert(nibbleCount == count, "The sampled nibble count must play exactly once")
	assert(math.abs(state.startedAt - biteAt(count)) < 0.000001)
end

for _, time in ipairs({ 10.5, 11, 12.1, 13.3, 14.3 }) do
	local early = timeline(3)
	assert(not early:TryHook(time) and early.phase == "Reeling", "A pre-bite tap must reel in and end this cast")
	local duration = 1.5 -- Physical settling is supplied by the spring, not Advance.
	assert(not early:CanReturn(time), "The initiating tap must not return before the reel animation")
	assert(not early:TryHook(time + 0.1) and early.startedAt == time, "Repeated taps restarted reeling")
	assert(early:Advance(time + duration) == "Reeling", "Clock alone must not finish the spring")
	early:FinishReel(time + duration)
	assert(early.phase == "Reeled")
	assert(not early:CanReturn(time + duration + config.Reel.HoldTime - 0.001), "Reeled bait must settle before return")
	assert(early:CanReturn(time + duration + config.Reel.HoldTime), "Reeled bait did not enable return")
	assert(not early:CanRetry(time + 100), "Manual reeling must not restart fishing")
	assert(not early:TryHook(time + 100) and early.phase == "Reeled", "Showcase input restarted reeling")
end

for _, offset in ipairs({ 0, 0.5, 0.599999 }) do
	local state = timeline(0)
	local now = biteAt(0) + offset
	assert(state:TryHook(now), "Input must advance the timeline even without a rendered bite frame")
	assert(state.phase == "Struggling")
	assert(state.baitConsumed, "Hook input must consume bait even if it advances past the first bite frame")
	assert(not state:TryHook(now + 0.1), "Repeated hook input must not restart the struggle")
	assert(state.startedAt == now)
	assert(not state:CanReturn(now + settings.StruggleTime - 0.001))
	state:Advance(now + settings.StruggleTime)
	assert(state.phase == "Lifting")
	local caught = state.endsAt
	state:Advance(caught)
	assert(state.phase == "Caught")
	assert(not state:CanReturn(caught + settings.ShowcaseHold - 0.001))
	assert(state:CanReturn(caught + settings.ShowcaseHold))
	assert(not state:CanRetry(caught + 100), "Caught fish must not automatically restart")
	assert(not state:TryHook(caught + 10) and state.phase == "Caught")
end

for _, offset in ipairs({ 0.6, 0.600001, 20 }) do
	local state = timeline(0)
	assert(
		not state:TryHook(biteAt(0) + offset) and state.phase == "Reeling",
		"Late input must reel in without catching"
	)
	assert(state.baitConsumed, "A skipped bite must still consume bait")
	local duration = 1.5 -- Physical settling is supplied by the spring, not Advance.
	assert(not state:TryHook(biteAt(0) + offset + duration * 0.5) and state.phase == "Reeling")
	assert(state:Advance(biteAt(0) + offset + 100) == "Reeling")
	state:FinishReel(biteAt(0) + offset + 100)
	assert(state.phase == "Reeled")
end

local stalled = timeline(3)
stalled:Advance(1000)
assert(stalled.phase == "Escaped" and stalled:CanRetry(1000), "A long frame must cross every expired phase")
assert(not stalled:CanReturn(1000))
assert(not stalled:TryHook(1000) and not stalled:CanReturn(1000), "Late input must wait for the reel showcase")
assert(not stalled:CanReturn(1100), "A long frame alone cannot finish the spring")
stalled:FinishReel(1100)
assert(stalled:CanReturn(1100 + config.Reel.HoldTime) and stalled.phase == "Reeled")
local retry = timeline(0, 2, 1000, 1000)
assert(retry:Advance(1000) == "Waiting" and not retry.baitConsumed, "Retry must start from now with fresh bait")
assert(not retry:CanRetry(1000), "Stale time must not immediately expire a new round")
local stalledSuccess = timeline(3)
assert(stalledSuccess:TryHook(biteAt(3) + 0.1))
stalledSuccess:Advance(1000)
assert(stalledSuccess.phase == "Caught" and stalledSuccess:CanReturn(1000))

local fishDestroyed, surfaceDestroyed = 0, 0
local instance = setmetatable({
	surfaces = { { instance = {
		Destroy = function()
			surfaceDestroyed += 1
		end,
	} } },
	fish = {
		Destroy = function()
			fishDestroyed += 1
		end,
	},
}, Bite)
instance:Destroy()
instance:Destroy()
assert(fishDestroyed == 1 and surfaceDestroyed == 1, "Destroy must release fish and detached appearance exactly once")
assert(
	not instance:TryHook(1000) and not instance:CanReturn(1000) and not instance:CanRetry(1000),
	"Destroyed sessions cannot accept input"
)

-- 预抽样的试探参数不随帧率、重复采样或乱序采样变化。
for _, bound in ipairs({ "low", "high" }) do
	local calls = 0
	local sampled = Bite.NewMotion(10, {
		NextNumber = function(_, low, high)
			calls += 1
			return if bound == "low" then low else high
		end,
		NextInteger = function(_, low, high)
			return if bound == "low" then low else high
		end,
	})
	local initializedCalls = calls
	assert(settings.Struggle.Speed == 2)
	for index = 1, settings.MaxNibbles do
		local entry = sampled.nibbles[index]
		assert(entry.depth >= 0.06 and entry.depth <= 0.09)
		assert(entry.gap >= 0.9 and entry.gap <= 1.1)
		assert(math.abs(entry.yaw) <= math.rad(60))
		local turn = entry.yaw - entry.beforeYaw
		assert(math.abs(turn) >= math.rad(15) - 1e-6 and math.abs(turn) <= math.rad(45) + 1e-6)
		assert(entry.nibbleSpeed == (if bound == "low" then 0.8 else 1.3))
		assert(entry.returnSpeed == (if bound == "low" then 0.8 else 1.2))
		assert(math.abs(entry.duration - entry.attackTime - (settings.NibbleTime - settings.Nibble.AttackTime) / entry.nibbleSpeed) < 1e-9)
		assert(math.abs(entry.returnAt - entry.attackTime - settings.Nibble.ContactTime / entry.nibbleSpeed) < 1e-9)
		for _, rate in ipairs({ 15, 30, 60, 144 }) do
			for frame = 0, math.ceil(settings.NibbleTime * rate) do
				sampled:SampleNibble(index, frame / rate)
			end
			local progress, pressure = sampled:SampleNibble(index, entry.attackTime + settings.Nibble.ContactTime * 0.5 / entry.nibbleSpeed)
			assert(progress == 1 and pressure == entry.depth, "Contact is not settled")
			local _, rebounded = sampled:SampleNibble(index, entry.reboundEnd + 1e-6)
			assert(rebounded == 0, "Bait did not rebound immediately")
			local finished, finalPressure = sampled:SampleNibble(index, entry.duration)
			assert(finished == 1 and finalPressure == 0, "Contact sampling tried to retreat")
		end
	end
	-- 连续同向绕圈：先展开再收小；起步后所有鱼统一为 2 圈/秒。
	local previousAngle, previousRadius = 0, 1
	local previousSpeed = 0
	for frame = 0, 432 do
		local time = frame / 144
		local angle, speed, radius, radialVelocity, strength = sampled:SampleOrbit(time)
		assert((angle - previousAngle) * sampled.mirror >= -1e-9, "Orbit reversed")
		if time <= settings.Struggle.BlendTime then
			assert(radius >= previousRadius - 1e-9 and radialVelocity >= 0, "Initial orbit failed to expand")
		elseif time - 1 / 144 >= settings.Struggle.BlendTime then
			assert(radius <= previousRadius + 1e-9 and radialVelocity <= 0, "Orbit grew after expansion")
		end
		assert(strength >= 0 and strength <= 1)
		if time >= settings.Struggle.BlendTime then
			assert(math.abs(speed - sampled.mirror * math.pi * 4) < 1e-9, "Orbit is not a constant 2 turns/second")
			local expectedAngle = sampled.mirror * math.pi * 4 * (time - settings.Struggle.BlendTime * 0.5)
			assert(math.abs(angle - expectedAngle) < 1e-9, "Steady orbit angle is not linear in time")
		else
			assert(
				math.abs(speed) >= previousSpeed - 1e-9 and math.abs(speed) <= math.pi * 4,
				"Startup did not accelerate smoothly to the fixed speed"
			)
		end
		previousSpeed = math.abs(speed)
		previousAngle, previousRadius = angle, radius
	end
	assert(math.abs(previousRadius - sampled.orbit.endRadius) < 1e-9)
	assert(math.abs(previousRadius - 0.8) < 1e-9)
	for _, entry in ipairs({ { 0, 1 }, { 0.2, 1.2 }, { 3, 0.8 } }) do
		local _, _, radius, radialVelocity = sampled:SampleOrbit(entry[1])
		assert(
			math.abs(radius - entry[2]) < 1e-9 and math.abs(radialVelocity) < 1e-9,
			"Orbit radius endpoint or tangent changed"
		)
	end
	for _, time in ipairs({ 0.1, 0.2, 0.7, 1.8, 2.8 }) do
		local left = sampled:SampleOrbit(time - 1e-6)
		local right = sampled:SampleOrbit(time + 1e-6)
		local _, velocity = sampled:SampleOrbit(time)
		assert(math.abs((right - left) / 2e-6 - velocity) < 1e-5, "Speed does not match integrated angle")
		local _, _, beforeRadius = sampled:SampleOrbit(time - 1e-6)
		local _, _, afterRadius = sampled:SampleOrbit(time + 1e-6)
		local _, _, _, radialVelocity = sampled:SampleOrbit(time)
		assert(
			math.abs((afterRadius - beforeRadius) / 2e-6 - radialVelocity) < 1e-4,
			"Radial velocity does not match radius derivative"
		)
	end
	local expected = { sampled:SampleOrbit(1.37) }
	for _, rate in ipairs({ 15, 30, 60, 144 }) do
		for frame = 0, rate * 3 do
			sampled:SampleOrbit(frame / rate)
		end
		local actual = { sampled:SampleOrbit(1.37) }
		for index, value in ipairs(expected) do
			assert(actual[index] == value, "Render rate changed orbit angle/radius/velocity")
		end
	end
	assert(calls == initializedCalls, "Rendering sampled new random values")
	-- 水花参数变化不能影响路径的四个采样值。
	local feedbackOrbit = table.clone(sampled.orbit)
	feedbackOrbit.feedbackFrequency, feedbackOrbit.feedbackPhase = 2.7, 0.7
	local feedbackMotion = setmetatable(table.clone(sampled), getmetatable(sampled))
	feedbackMotion.orbit = feedbackOrbit
	local original = { sampled:SampleOrbit(0.85) }
	local changed = { feedbackMotion:SampleOrbit(0.85) }
	for index = 1, 4 do
		assert(original[index] == changed[index], "Water feedback changed orbit motion")
	end
	assert(math.abs(original[5] - changed[5]) > 0.001, "Water feedback fixture did not change effect strength")
end
local sounds = 0
local soundProbe = setmetatable(
	{ owner = {
		fishAudio = { SetPhase = function(_, phase)
			assert(phase == "Bite")
			sounds += 1
		end },
	} },
	Bite
)
soundProbe:_biteSound()
soundProbe:_biteSound()
assert(sounds == 1, "Bite cue played twice")

-- 相同种子完全复现，另一种子改变绕圈；帧采样不能推进随机序列。
local function seeded(seed)
	local function nextUnit()
		seed = seed * 48271 % 2147483647
		return seed / 2147483647
	end
	return {
		NextNumber = function(_, low, high)
			return low + (high - low) * nextUnit()
		end,
		NextInteger = function(_, low, high)
			return low + math.floor(nextUnit() * (high - low + 1))
		end,
	}
end
local first, repeated, different =
	Bite.NewMotion(0, seeded(12)), Bite.NewMotion(0, seeded(12)), Bite.NewMotion(0, seeded(13))
for key, value in pairs(first.orbit) do
	assert(value == repeated.orbit[key], "Seed did not reproduce orbit")
end
for index, entry in ipairs(first.nibbles) do
	for key, value in pairs(entry) do
		assert(value == repeated.nibbles[index][key], "Seed did not reproduce feeding")
	end
end
assert(first.mirror == repeated.mirror and first.orbit.feedbackPhase ~= different.orbit.feedbackPhase)
assert(first.nibbles[1].nibbleSpeed ~= different.nibbles[1].nibbleSpeed, "Seed did not change nibble rhythm")

-- 慢假咬/快回游及相反组合共用实际时间；长帧与正常帧必须得到相同的提竿窗口。
for _, invert in ipairs({ false, true }) do
	local motion = Bite.NewMotion(0, {
		NextInteger = function(_, low) return low end,
		NextNumber = function(_, low, high)
			if low == settings.Nibble.SpeedMin and high == settings.Nibble.SpeedMax then
				return if invert then high else low
			elseif low == settings.Nibble.ReturnSpeedMin and high == settings.Nibble.ReturnSpeedMax then
				return if invert then low else high
			end
			return (low + high) / 2
		end,
	})
	for _, count in ipairs({ 0, 3, settings.MaxNibbles }) do
		local function create()
			local state = timeline(count)
			state.nibbleTimings = motion.nibbles
			state.repositionDurations = {}
			for index, entry in ipairs(motion.nibbles) do
				state.repositionDurations[index] = 3 / entry.returnSpeed
			end
			return state
		end
		local reference = create()
		while reference.phase ~= "Bite" do
			if reference.phase == "Nibbling" then
				local timing = reference:GetNibbleTiming()
				local startedAt = reference.startedAt
				assert(math.abs(reference.endsAt - startedAt - timing.duration) < 1e-9)
				reference:Advance(reference.endsAt)
				assert(reference.phase == "Holding")
				local expected = startedAt + timing.returnAt
					+ reference.repositionDurations[reference.completedNibbles] + settings.Nibble.SettleTime
				assert(math.abs(reference.endsAt - expected) < 1e-9, "Variable return lost settling time")
			else
				reference:Advance(reference.endsAt)
			end
		end
		local at = reference.startedAt
		for _, step in ipairs({ 1 / 15, 1 / 30, 1 / 60, 1 / 144, at - 10 }) do
			local state, now = create(), 10
			while now < at do
				state:Advance(now)
				now = math.min(at, now + step)
			end
			state:Advance(at)
			assert(state.phase == "Bite" and state.completedNibbles == count)
			assert(state.startedAt == at and math.abs(state.endsAt - at - settings.HookWindow) < 1e-9)
			assert(state:TryHook(at + settings.HookWindow - 0.001), "Random rhythm shrank the hook window")
			local late = create()
			assert(late:Advance(at + settings.HookWindow + 0.01) == "Escaped", "Long frame lost timeout")
		end
		if count > 0 then
			local early = create()
			while early.phase ~= "Nibbling" do early:Advance(early.endsAt) end
			assert(not early:TryHook(early.startedAt + early:GetNibbleTiming().attackTime), "Fake bite became hookable")
		end
	end
end

-- 长路径延长停顿；路径从轻啄接触之后开始，已有 Nibbling 后段不能重复计时。
local extended = timeline(3)
extended.repositionDurations = { 4, 2, 3 }
while extended.phase ~= "Nibbling" do
	extended:Advance(extended.endsAt)
end
local contactEnd = settings.Nibble.AttackTime + settings.Nibble.ContactTime
for index, duration in ipairs(extended.repositionDurations) do
	local startedAt = extended.startedAt
	extended:Advance(extended.endsAt)
	assert(extended.phase == "Holding" and extended.completedNibbles == index)
	local settledAt = startedAt + contactEnd + duration + settings.Nibble.SettleTime
	assert(math.abs(extended.endsAt - settledAt) < 1e-6, "Pause cut off forward return")
	assert(extended:Advance(settledAt - 0.001) == "Holding")
	extended:Advance(settledAt)
end
assert(extended.phase == "Bite", "Final return did not lead to bite")

-- 渲染帧率和跳过整个回游的长帧都不能改变最终咬钩时刻。
local biteStartedAt = extended.startedAt
for _, step in ipairs({ 1 / 15, 1 / 30, 1 / 60, 1 / 144, biteStartedAt - 10 }) do
	local sampled = timeline(3)
	sampled.repositionDurations = { 4, 2, 3 }
	local now = 10
	while now < biteStartedAt do
		sampled:Advance(now)
		now = math.min(biteStartedAt, now + step)
	end
	sampled:Advance(biteStartedAt)
	assert(sampled.phase == "Bite" and sampled.completedNibbles == 3, "Frame step lost a return or bite")
	assert(math.abs(sampled.startedAt - biteStartedAt) < 1e-6, "Frame step changed return duration")
	assert(sampled:Advance(biteStartedAt + settings.HookWindow + 0.01) == "Escaped", "Long frame missed timeout")
end

do
	local function run(speed)
		local fish = {
			SwimSpeed = speed, TurnRadiusScale = 0.85, AppearTime = 1.3, NibbleCountMin = 2, NibbleCountMax = 4,
			HookWindow = 0.73, StruggleTime = 0.05,
		}
		local state = Bite.NewTimeline(10, seeded(432), 12, fish)
		local motion = Bite.NewMotion(10, seeded(12), state.nibbles, state.struggleTime, state.swimSpeed)
		state.nibbleTimings = motion.nibbles
		state.repositionDurations = { 2, 3, 4, 2 }
		assert(state:Advance(11.99) == "Settling" and state:Advance(13.29) == "Waiting")
		assert(state:Advance(13.3) == "Approaching")
		assert(math.abs(state.endsAt - state.startedAt - math.max(settings.ApproachTimeMin, settings.ApproachDistance / speed)) < 1e-9)
		assert(state.turnRadiusScale == 0.85)
		while state.phase ~= "Bite" do
			state:Advance(state.endsAt)
		end
		assert(state.completedNibbles >= 2 and state.completedNibbles <= 4)
		assert(math.abs(state.endsAt - state.startedAt - fish.HookWindow) < 1e-9)
		return state, motion
	end

	local slow, slowMotion = run(8)
	local fast, fastMotion = run(16)
	assert(fast.startedAt < slow.startedAt and fast.completedNibbles == slow.completedNibbles)
	local a, b = slowMotion.nibbles[1], fastMotion.nibbles[1]
	assert(a.attackTime >= b.attackTime and b.attackTime >= settings.Nibble.AttackTimeMin)
	assert(math.abs((a.returnAt - a.attackTime) - (b.returnAt - b.attackTime)) < 1e-9)
	assert(math.abs((a.reboundEnd - a.returnAt) - (b.reboundEnd - b.returnAt)) < 1e-9)
	local _, slowScale = Elastic.Sample("Nibbling", a.returnAt, nil, a.nibbleSpeed, a.attackTime)
	local _, fastScale = Elastic.Sample("Nibbling", b.returnAt, nil, b.nibbleSpeed, b.attackTime)
	assert(math.abs(slowScale.Y - fastScale.Y) < 1e-9, "Fish speed changed contact pose")
	local biteStart = fast.startedAt
	assert(fast:TryHook(biteStart))
	assert(fast:Advance(biteStart + 0.049) == "Struggling")
	assert(fast:Advance(biteStart + 0.05) == "Lifting")
	assert(not slow:TryHook(slow.endsAt), "Hook window must exclude its end")
	for _, value in ipairs({ fastMotion:SampleOrbit(0.05) }) do
		assert(math.abs(value) < math.huge, "Short struggle produced invalid motion")
	end

	local zero = Bite.NewTimeline(0, seeded(12), 0.5, {
		AppearTime = 0, NibbleCountMin = 0, NibbleCountMax = 0,
	})
	assert(zero:Advance(0.5) == "Approaching")
	while zero.phase ~= "Bite" do
		assert(zero.phase ~= "Nibbling")
		zero:Advance(zero.endsAt)
	end
	local invalid = Bite.NewTimeline(0, seeded(12), 0.5, {
		SwimSpeed = -1, TurnRadiusScale = math.huge, AppearTime = -1, NibbleCountMin = 7, NibbleCountMax = 3, HookWindow = 0, StruggleTime = math.huge,
	})
	local legacy = Bite.NewTimeline(0, seeded(12), 0.5)
	assert(invalid.appearAt == legacy.appearAt and invalid.nibbles == legacy.nibbles)
	assert(invalid.hookWindow == settings.HookWindow and invalid.struggleTime == settings.StruggleTime)
	assert(invalid.swimSpeed == legacy.swimSpeed and invalid.turnRadiusScale == legacy.turnRadiusScale)
end

-- 两个阶段各自去重、按当帧体形传递尺寸，跨过出水时不补播。
do
	local events, updates = {}, {}
	local position = { Y = -1 }
	local sequence = setmetatable({
		fish = {
			PrimaryPart = { Position = position },
			GetBoundingBox = function() return { Position = position } end,
		},
		presentationRadius = 6, scale = 2, fishConfig = { Rarity = "Mythic" },
		owner = { _playRarityVFX = function(_, now, center, rarity, diameter, stage)
			table.insert(events, { now, center, rarity, diameter, stage })
			return { Update = function(_, at, point, size)
				table.insert(updates, { at, point, size })
				return at < 10
			end }
		end },
	}, Bite)
	sequence:_updateRarityVFX("Lifting", 0)
	assert(#events == 0, "Do not emit before surfacing")
	position.Y = 0
	sequence:_updateRarityVFX("Lifting", 0.1)
	sequence:_updateRarityVFX("Lifting", 0.1)
	assert(#events == 1 and events[1][5] == "Exit", "Surface burst must happen once")
	assert(events[1][3] == "Mythic" and events[1][4] == 24, "Use fish rarity and actual diameter")
	sequence.scale = 3
	sequence:_updateRarityVFX("Caught", 2)
	sequence:_updateRarityVFX("Caught", 2)
	assert(#events == 2 and events[2][5] == "Showcase" and events[2][4] == 36)
	assert(updates[#updates][3] == 36, "Update active VFX during fish scaling")
	sequence:_updateRarityVFX("Caught", 11)
	assert(#sequence.rarityEffects == 0 and #events == 2, "Expired effects must not replay")
	sequence.rarityExitPlayed, sequence.rarityShowcasePlayed = nil, nil
	sequence.rarityEffects = nil
	sequence:_updateRarityVFX("Caught", 12)
	assert(#events == 3 and events[3][5] == "Showcase", "Do not catch up a skipped Exit")
	sequence.rarityExitPlayed, sequence.rarityShowcasePlayed = nil, nil
	sequence.rarityEffects = nil
	sequence:_updateRarityVFX("Escaped", 13)
	assert(#events == 3, "Escaped fish must not play rarity VFX")
	sequence.owner._playRarityVFX = function() return nil end
	sequence:_updateRarityVFX("Caught", 14)
	sequence:_updateRarityVFX("Caught", 14)
	assert(sequence.rarityShowcasePlayed and not sequence.rarityEffects, "Missing resources must consume the stage")
end

-- 每轮按捕获类型选择时序；鱼蛋继续保持旧的两秒演出。
do
	local random = { NextInteger = function(_, low) return low end, NextNumber = function(_, low) return low end }
	local fish = Bite.NewTimeline(0, random)
	local egg = Bite.NewTimeline(0, random, nil, nil, "Egg")
	assert(math.abs(fish.liftTiming.duration - 1.55) < 1e-9 and egg.liftTiming.duration == 2)
	fish:_enter("Struggling", 0, 1)
	egg:_enter("Struggling", 0, 1)
	fish:Advance(1)
	egg:Advance(1)
	assert(math.abs(fish.endsAt - 2.55) < 1e-9 and egg.endsAt == 3)
end

-- 音画反馈共用破水/落位边界；静音或重复更新不能导致补播。
do
	local motion = dofile("src/ReplicatedStorage/Modules/FishingLiftMotion.lua")
	local plan = motion.New(settings, config.BaitElastic, -4, 5, 8)
	local played, effects, impulses, whooshes = {}, 0, {}, 0
	local sequence = setmetatable({ liftPlan = plan, owner = {
		_waterFeedback = function() end,
		_playWaterVFX = function(_, _, _, _, _, scale) effects += 1; assert(scale == 1) end,
		_impulse = function(_, setting) table.insert(impulses, setting) end,
		_sound = function(_, name) assert(name == "CameraWhoosh"); whooshes += 1 end,
		fishAudio = { Play = function(_, name) table.insert(played, name) end },
	} }, Bite)
	sequence:_updateLiftFeedback("Lifting", plan.exitAt + 0.01, 10, {})
	sequence:_updateLiftFeedback("Lifting", plan.exitAt + 0.01, 10, {})
	assert(effects == 1 and whooshes == 1 and played[1] == "FishWaterOut" and #impulses == 1)
	sequence:_updateLiftFeedback("Lifting", plan.timing.landAt + 0.01, 11, {})
	sequence:_updateLiftFeedback("Caught", 0.01, 12, {})
	assert(#played == 2 and played[2] == "FishDrop" and impulses[2] == settings.FishLift.Land)
	sequence.liftFeedbackAt = nil
	sequence:_updateLiftFeedback("Caught", 5, 20, {})
	assert(#played == 2 and effects == 1, "Expired boundaries replayed")
end
