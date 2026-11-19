local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local feedbackHarness = require("./helpers/FishingCastFeedbackHarness")
local modules = {
	petFeature = { Enabled = true },
	config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))(),
	rig = {},
	water = {},
	bite = {},
	info = { new = function()
		return { Destroy = function() end }
	end },
	vignette = { new = function()
		return { Update = function() end, Destroy = function() end }
	end },
	characterVFX = {},
	confetti = { play = function() end, clear = function() end },
}
local workspace = {}
modules.feedback = feedbackHarness.feedback
local tweenService = {}
local function vector(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, {
		__add = function(a, b) return vector(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end,
		__mul = function(a, scale) return vector(a.X * scale, a.Y * scale, a.Z * scale) end,
	})
end
local environment = setmetatable({
	Vector3 = { new = vector },
	script = {
		Parent = {
			PetFeatureConfig = "petFeature",
			FishingConfig = "config",
			FishingCastPresentation = "presentation",
			FishingCastFeedback = "feedback",
			FishingProjectileMath = "math",
			FishingRigUtil = "rig",
			WaterSurfaceUtil = "water",
			FishingBiteSequence = "bite",
			FishingSequenceInfo = "info",
			FishingRoll = "roll",
			RarityConfig = "rarity",
			FishingVignette = "vignette",
			FishingCharacterVFX = "characterVFX",
			UiConfettiUtil = "confetti",
		},
	},
	game = {
		GetService = function(_, name)
			if name == "TweenService" then return tweenService end
			return if name == "Workspace" then workspace else {}
		end,
	},
	require = function(name)
		return assert(modules[name])
	end,
	Color3 = {
		fromRGB = function(r, g, b)
			return { r, g, b }
		end,
	},
	UDim2 = {
		fromScale = function(x, y)
			return { X = x, Y = y }
		end,
		fromOffset = function(x, y)
			return { X = x, Y = y }
		end,
	},
}, { __index = getfenv() })
environment.script.Parent.BaitElasticMotion = "elastic"
local baseRequire = environment.require
local Elastic = assert(load(read("src/ReplicatedStorage/Modules/BaitElasticMotion.lua"), "Elastic", "t", environment))()
environment.require = function(name)
	return if name == "elastic" then Elastic else baseRequire(name)
end
modules.math = assert(
	load(read("src/ReplicatedStorage/Modules/FishingProjectileMath.lua"), "FishingProjectileMath", "t", environment)
)()
modules.water = assert(
	load(read("src/ReplicatedStorage/Modules/WaterSurfaceUtil.lua"), "WaterSurfaceUtil", "t", environment)
)()
modules.rarity = {}
modules.roll = assert(
	load(read("src/ReplicatedStorage/Modules/FishingRoll.lua"), "FishingRoll", "t", environment)
)()
environment.script.Parent.FishingWaterEffects = "waterEffects"
modules.waterEffects = assert(load(read("src/ReplicatedStorage/Modules/FishingWaterEffects.lua"), "FishingWaterEffects", "t", environment))()
modules.presentation = assert(load(read("src/ReplicatedStorage/Modules/FishingCastPresentation.lua"), "FishingCastPresentation", "t", environment))()
local Sequence = assert(
	load(read("src/ReplicatedStorage/Modules/FishingCastSequence.lua"), "FishingCastSequence", "t", environment)
)()

do
	local bursts, showcases, eggSuccess, drops, clears = 0, 0, 0, 0, 0
	local gui = { Parent = {}, Enabled = true }
	local fish = { Destroy = function() end }
	local egg = { isEgg = true }
	modules.confetti.play = function(parent, preset)
		assert(parent == gui and preset == "sideCannons", "Use the fishing GUI and side cannons preset")
		bursts += 1
	end
	modules.confetti.clear = function(parent)
		assert(parent == gui)
		clears += 1
	end
	local audio = {
		PlayShowcase = function() showcases += 1 end,
		Play = function(_, name)
			assert(name == "FishSuccess", "Preserve the egg's original success cue")
			eggSuccess += 1
		end,
		SetPhase = function(_, phase) if phase == "Caught" then drops += 1 end end,
		Destroy = function() end,
	}
	local sequence = setmetatable({ gui = gui, bite = fish, fishAudio = audio,
		folder = { SetAttribute = function() end, Destroy = function() end } }, Sequence)
	sequence:_celebrateCatch(egg)
	assert(bursts == 0 and showcases == 0, "Eggs must not receive fish celebrations")
	sequence:_celebrateCatch(fish)
	sequence:_celebrateCatch(fish)
	sequence:_setPhase("Caught")
	assert(bursts == 1 and showcases == 1 and eggSuccess == 0 and drops == 1,
		"Celebrate once per fish, without replaying success on Caught")
	sequence.bite = egg
	sequence:_setPhase("Lifting")
	sequence:_setPhase("Caught")
	sequence:_setPhase("Caught")
	assert(eggSuccess == 1 and showcases == 1, "Egg success must remain at Caught, once")
	sequence.bite = fish
	sequence:_celebrateCatch({})
	assert(bursts == 2 and showcases == 2, "The next fish must have its own celebration")
	sequence:Destroy()
	sequence:Destroy()
	sequence:_celebrateCatch({})
	assert(clears == 1 and bursts == 2 and not gui.Enabled and not sequence.celebratedBite,
		"Abort must clear the layer once and prevent further celebrations")
	modules.confetti.play, modules.confetti.clear = function() end, function() end
end

do
	local settings = modules.config.Bite
	local startedAt = 100
	local timeline = { phase = "Lifting", startedAt = startedAt }
	local sequence = setmetatable({ bite = { isEgg = true, timeline = timeline } }, Sequence)
	local pullbackAt = settings.LiftTime * settings.LiftRiseEnd
	local entry, pullback = sequence:_showcaseProgress(startedAt)
	assert(entry == 0 and pullback == 0, "Start the closeup from the incoming camera")
	local _, rising = sequence:_showcaseProgress(startedAt + pullbackAt - 1 / 60)
	assert(rising == 0, "Keep the closeup while the fish rises")
	entry, pullback = sequence:_showcaseProgress(startedAt + pullbackAt)
	assert(entry == 1 and math.abs(pullback) < 0.00001, "Join the pullback at the fish's peak")
	local previous = pullback
	local frames = math.ceil(settings.ShowcasePullbackTime * 60)
	for frame = 1, frames do
		local elapsed = settings.ShowcasePullbackTime * frame / frames
		local _, progress = sequence:_showcaseProgress(startedAt + pullbackAt + elapsed)
		assert(progress > previous, "Pullback must advance every frame immediately after the peak")
		previous = progress
	end
	assert(math.abs(previous - 1) < 0.00001, "Finish pulling back within the existing duration")
	for _, delay in ipairs({ 1 / 60, 0.2 }) do
		local _, settled = sequence:_showcaseProgress(startedAt + pullbackAt + settings.ShowcasePullbackTime + delay)
		assert(settled == 1, "Keep the completed pullback stable")
	end
	local _, halfway = sequence:_showcaseProgress(startedAt + pullbackAt + settings.ShowcasePullbackTime * 0.5)
	assert(math.abs(halfway - 0.5) < 0.00001, "Pull back continuously from the closeup")
	local _, beforeCaught = sequence:_showcaseProgress(startedAt + settings.LiftTime)
	timeline.phase, timeline.startedAt = "Caught", startedAt + settings.LiftTime
	local _, afterCaught = sequence:_showcaseProgress(timeline.startedAt)
	assert(math.abs(beforeCaught - afterCaught) < 0.00001, "Caught must continue the pullback without a jump")
	local _, finished = sequence:_showcaseProgress(timeline.startedAt + settings.ShowcaseHold)
	assert(finished == 1, "Finish the full showcase before the return prompt")
end

do
	local top = {
		Size = vector(100, 4, 100),
		CFrame = { PointToWorldSpace = function(_, point) return point + vector(0, 100, 0) end },
		IsA = function(_, className) return className == "BasePart" end,
	}
	local function container(name, child)
		return function(_, requested) return if requested == name then child else nil end
	end
	local water = { FindFirstChild = container("Top", top) }
	local areas = { FindFirstChild = container("Water", water) }
	workspace.FindFirstChild = container("Areas", areas)
	for _, baitHeight in ipairs({ 1, 5 }) do
		local feedback = 0
		local function checkSurface(_, _, position)
			assert(position.X == 3 and position.Y == 102 and position.Z == 4, "Water feedback must use the Top surface")
			feedback += 1
		end
		local cast = setmetatable({
			launch = vector(3, 120, 0),
			forward = vector(0, 0, 1),
			distance = 4,
			baitBaseSize = vector(1, baitHeight, 1),
			_ripple = checkSurface,
			_splash = checkSurface,
		}, Sequence)
		local target = cast:_waterTarget()
		assert(target.X == 3 and target.Y == 102 and target.Z == 4, "Bait center must land on the Top surface")
		cast:_waterFeedback(0, vector(3, 95, 4), 1, true, true)
		assert(feedback == 2, "Splash and ripple must both use the water surface")
	end
end

for _, discoveryFlag in { true, false, "missing" } do
	local weight
	local bite
	bite = {
		timeline = { Advance = function() return "Bite" end },
		SetCaughtWeight = function(_, grantedWeight)
			weight = grantedWeight
		end,
		TryHook = function()
			assert(weight == 3.375, "Set the server-granted weight before starting the catch")
			assert(bite.isNewDiscovery == (discoveryFlag == true), "Set the server discovery flag before starting the catch")
		end,
	}
	local probe = setmetatable({
		bite = bite,
		round = 1,
		serverRoundStart = 100,
		localRoundStart = 10,
		options = {
			hook = function()
				return {
					andThen = function(promise, callback)
						callback({ ok = true, weight = 3.375,
							isNewDiscovery = if discoveryFlag == "missing" then nil else discoveryFlag })
						return promise
					end,
					catch = function() end,
				}
			end,
		},
	}, Sequence)
	probe:TryHook(11)
	assert(weight == 3.375 and probe.hookPendingAt == nil, "Apply the weight from the successful catch response")
end

-- 声音与角色特效跟随实际动画起播，前挥触发不能提前或重复。
do
	local starts, cues, phases, effects, swings, releases = 0, {}, {}, 0, 0, 0
	modules.rig.RestoreReadyPose = function() end
	local probe = setmetatable({
		phase = "Casting", castClickedAt = 0, rig = {},
		track = { Length = 0, Play = function() starts += 1 end },
		folder = { SetAttribute = function() end },
		characterVFX = {
			Start = function(_, now)
				assert(starts == 1 and now == modules.config.CastLeadTime, "Start VFX with the actual animation")
				effects += 1
			end,
			BeginSwing = function() swings += 1 end,
		},
		_shot = function() end,
		_impulse = function() end,
		_sound = function() end,
		_release = function() releases += 1 end,
		fishAudio = {
			Play = function(_, name)
				assert(starts == 1 and effects == 1, "Play cast sounds with the actual animation and VFX")
				if name == "FishingCastImpact" then
					assert(swings == 1, "Play impact with the swing VFX")
				else
					assert(swings == 0, "Play cast and wind sounds before the swing")
				end
				cues[name] = (cues[name] or 0) + 1
			end,
			SetPhase = function(_, phase) table.insert(phases, phase) end,
		},
	}, Sequence)
	probe:_updateAction(0.1)
	probe.track.Length = 3
	probe:_updateAction(0.2)
	assert(starts == 0 and not next(cues) and effects == 0 and swings == 0,
		"Do not start animation, VFX or sounds while waiting for animation load and lead time")
	probe:_updateAction(modules.config.CastLeadTime)
	probe:_updateAction(modules.config.CastLeadTime + 0.01)
	assert(starts == 1 and cues.FishingRodCast == 1 and cues.FishingCastWind == 1 and effects == 1,
		"Start animation, VFX and both cast sounds once")
	assert(not cues.FishingCastImpact, "Do not play impact at animation start")
	local swingAt = modules.config.CastLeadTime + 1.925
	probe:_updateAction(modules.config.CastLeadTime + 1.8)
	assert(swings == 0 and not cues.FishingCastImpact, "Do not play impact at the start of the forward swing")
	probe:_updateAction(swingAt - 0.001)
	assert(swings == 0 and releases == 0, "Wait until the midpoint of the forward swing")
	assert(not cues.FishingCastImpact, "Do not play impact before the swing midpoint")
	probe:_updateAction(swingAt + 0.001)
	probe:_updateAction(swingAt + 0.002)
	assert(swings == 1 and releases == 0, "Crossing the swing time must trigger once before release")
	assert(cues.FishingCastImpact == 1, "Crossing the swing time must play impact once")
	probe:_updateAction(modules.config.CastLeadTime + 2.05 - 0.001)
	assert(releases == 0, "Do not release the bait before 2.05 seconds")
	probe:_updateAction(modules.config.CastLeadTime + 2.05 + 0.001)
	assert(swings == 1 and releases == 1 and effects == 1, "Keep release timing and VFX deduplication")
	assert(cues.FishingRodCast == 1 and cues.FishingCastWind == 1 and cues.FishingCastImpact == 1,
		"Repeated updates must not replay cast sounds")
	probe:_setPhase("Struggling")
	probe:_setPhase("Struggling")
	probe:_setPhase("Lifting")
	assert(#phases == 2 and phases[1] == "Struggling" and phases[2] == "Lifting")
end

local attributes = {}
local feedbackCount = 0
local sequence = setmetatable({
	phase = "Preparing",
	folder = {
		SetAttribute = function(_, name, value)
			attributes[name] = value
		end,
	},
	meter = { prompt = {}, marker = {}, scale = {} },
	_castFeedback = function()
		feedbackCount += 1
	end,
}, Sequence)
sequence:Cast(0)
assert(sequence.phase == "Casting" and sequence.distance == 55)
local clickedAt = sequence.castClickedAt
sequence:Cast(1)
assert(
	sequence.distance == 55 and sequence.castClickedAt == clickedAt,
	"Repeated taps must not restart casting or change its locked power"
)
sequence.phase = "Flying"
sequence:Cast(1)
assert(sequence.distance == 55, "Flight input must not queue another cast")
sequence.phase = "Waiting"
sequence:Cast(1)
assert(sequence.distance == 55, "Waiting input must not start another cast")
assert(feedbackCount == 1, "Repeated taps must not replay feedback")

local fixedClicks, fixedTicks = {}, {}
local fixed = setmetatable({
	phase = "Preparing",
	fixedCast = true,
	fullLuck = 10,
	info = {
		SetLuck = function(self, value, _, immediate)
			assert(immediate, "Preparing luck must follow the meter without tween lag")
			self.shown = value
		end,
		Update = function() end,
		Destroy = function() end,
	},
	folder = sequence.folder,
	originals = {},
	meter = {
		gui = { Enabled = false },
		holder = { Parent = true, Visible = false },
		bar = { Parent = true, Visible = false },
		marker = { Parent = true, Visible = false, Position = { X = 0.5, Y = 0.5 } },
		label = { Parent = true, Visible = true },
		prompt = { Parent = true, Visible = false },
	},
	_sound = function(_, name, volume, pitch)
		if name == "MeterTick" then
			assert(volume == 0.25, "Use Throw Food's meter tick volume")
			table.insert(fixedTicks, pitch)
		else
			assert(name == "ButtonClick")
			table.insert(fixedClicks, { volume = volume, pitch = pitch })
		end
	end,
	_impulse = function() end,

}, Sequence)
feedbackHarness.attach(fixed)
fixed:_bindCastMeter(fixed.meter)
assert(fixed.meter.gui.Enabled and fixed.meter.holder.Visible and fixed.meter.bar.Visible)
assert(fixed.meter.marker.Visible and fixed.meter.prompt.Visible and not fixed.meter.label.Visible)
local startY = fixed.meter.marker.Position.Y
fixed:_updatePresentation(fixed.meterStarted + 0.5, 0.5)
local movingY = fixed.meter.marker.Position.Y
assert(movingY < startY and movingY > 0, "The fixed-distance meter must animate before casting")
fixed.meterProgress, fixed.meterDirection = 0, 1
for _, sample in { { 0, 0, 1 }, { 0.5 / 0.55, 0.5, 5.5 }, { 1, 1, 10 }, { 0.5 / 1.43, 0.5, 5.5 }, { 1, 0, 1 } } do
	fixed:_updatePresentation(fixed.meterStarted + 10, sample[1])
	assert(math.abs(fixed.meterProgress - sample[2]) < 1e-6, "Incorrect meter progress on the up/down sweep")
	assert(math.abs(fixed.info.shown - sample[3]) < 1e-6, "Luck must match the visible meter progress")
	assert(math.abs(fixed.meter.marker.Position.Y - (1 - fixed.meterProgress)) < 1e-6, "Marker and luck are out of sync")
end
fixed:_updatePresentation(fixed.meterStarted + 11, 0.5 / 0.55)
local locked = fixed:LockCastMeter()
assert(math.abs(locked - 0.5) < 1e-6, "Lock the visible click position")
assert(#fixedClicks == 1 and fixedClicks[1].volume == 0.8
	and math.abs(fixedClicks[1].pitch - 1.15) < 1e-6, "Play the click immediately when locking the meter")
fixed:_updatePresentation(fixed.meterStarted + 12, 1)
assert(fixed:LockCastMeter() == locked and fixed.meter.marker.Position.Y == 0.5
	and fixed.info.shown == 5.5, "Keep the indicator and luck locked while the request is pending")
fixed:Cast(locked, 30, 5.5)
assert(#fixedClicks == 1, "Server confirmation must not play a second click")
assert(fixed.phase == "Casting" and fixed.distance == 30 and not fixed.meter.gui.Enabled)
fixed:_updatePresentation(fixed.meterStarted + 13, 1)
assert(fixed.meter.marker.Position.Y == 0.5, "The indicator must stop once the cast starts")
fixed.folder = nil
fixed:Destroy()
assert(not fixed.meter.bar.Visible and not fixed.meter.marker.Visible and fixed.meter.label.Visible)
assert(fixed.meter.marker.Position.Y == 1, "Cleanup must restore the authored marker position")

for _, ceiling in { 1.3, 10, 100 } do
	for _, fps in { 30, 60, 144 } do
		local cues = {}
		local probe = setmetatable({
			phase = "Preparing", fixedCast = true, fullLuck = ceiling,
			impulses = {},
			meterStarted = 100, lastMeterStep = 0, enabled = true,
			meterProgress = 0, meterDirection = 1,
			meter = { marker = {} },
			info = {
				SetLuck = function(self, value) self.shown = value end,
				Update = function() end,
			},
			_sound = function(self, name, volume, pitch)
				if self.enabled then table.insert(cues, { name = name, volume = volume, pitch = pitch }) end
			end,
		}, Sequence)
		probe:_updatePresentation(100, 0)
		assert(#cues == 0, "Initialize the bottom meter step quietly")
		local expected, direction, previousStep = 0, 1, 0
		local reachedTop, returned = false, false
		for frame = 1, fps * 4 do
			-- 与参考逐帧积分比对，使用偏移时钟避免依赖绝对时间对齐。
			expected += direction * 0.55 * (1 + 1.6 * expected) / fps
			if expected >= 1 then
				expected, direction, reachedTop = 1, -1, true
			elseif expected <= 0 then
				expected, direction = 0, 1
				returned = reachedTop
			end
			local before = #cues
			probe:_updatePresentation(100.007 + frame / fps, 1 / fps)
			assert(math.abs(probe.meterProgress - expected) < 1e-10 and probe.meterDirection == direction,
				"Match Throw Food's acceleration, endpoint clamp and discarded overshoot")
			assert(math.abs(probe.meter.marker.Position.Y - (1 - expected)) < 1e-10,
				"Marker and sound must sample the same progress")
			local step = math.floor(expected * 6)
			assert(#cues == before + (if step ~= previousStep then 1 else 0),
				"Play exactly one cue on each sampled reference step, including the top reversal")
			previousStep = step
			if #cues > before then
				local cue = cues[#cues]
				assert(cue.name == "MeterTick" and cue.volume == 0.25
					and math.abs(cue.pitch - (0.9 + probe.meterProgress * 0.5)) < 1e-6,
					"Meter sound must follow progress instead of the luck ceiling")
			end
			assert(math.abs(probe.info.shown - ceiling * (0.1 + 0.9 * probe.meterProgress)) < 1e-6,
				"The new sound rule must preserve live luck values")
			if returned then break end
		end
		assert(returned and #cues == 12, "A full sweep must play 12 ticks at " .. ceiling .. "X / " .. fps .. "fps")
		probe.enabled = false
		probe:_updatePresentation(105, 0.5)
		probe.enabled = true
		probe:_updatePresentation(105, 0)
		assert(#cues == 12 and probe.lastMeterStep == 1, "Muted steps must be consumed without replay")
		probe:_updatePresentation(105.5, 0.5)
		assert(#cues == 13 and cues[13].name == "MeterTick", "A multi-step jump must play a single fresh tick")
		feedbackHarness.attach(probe)
		probe:LockCastMeter()
		assert(#cues == 14 and cues[14].name == "ButtonClick", "Locking must play the separate click sound")
		probe:_updatePresentation(106.5, 1)
		feedbackHarness.attach(probe)
		probe:LockCastMeter()
		assert(#cues == 14, "A locked meter must stop ticks and ignore repeated clicks")
	end
end

-- 极低帧率越过多档时只提示一次，并在端点丢弃剩余位移。
do
	local ticks = 0
	local probe = setmetatable({
		phase = "Preparing", fixedCast = true, meterStarted = 100, lastMeterStep = 0,
		meterProgress = 0, meterDirection = 1,
		meter = { marker = {} },
		_sound = function(_, name)
			assert(name == "MeterTick", "Only meter ticks may play during the sweep")
			ticks += 1
		end,
	}, Sequence)
	probe:_updatePresentation(110, 10)
	assert(ticks == 1 and probe.meterProgress == 1 and probe.meterDirection == -1,
		"A long frame must clamp at the top and emit only one cue")
	probe:_updatePresentation(120, 10)
	assert(ticks == 2 and probe.meterProgress == 0 and probe.meterDirection == 1,
		"Discard overshoot and reverse at the bottom on the next long frame")
end

for _, progress in { 0, 0.5, 0.799999, 0.8, 0.95, 0.950001, 1 } do
	local cues = {}
	local probe = setmetatable({
		phase = "Preparing", fixedCast = true, meterProgress = progress,
		folder = sequence.folder, meter = { gui = {}, marker = {} },
		impulses = {}, flash = { Visible = false, BackgroundTransparency = 1 },
		_sound = function(_, name, volume, pitch)
			table.insert(cues, { name = name, volume = volume, pitch = pitch })
		end,
	}, Sequence)
	feedbackHarness.attach(probe)
	assert(probe:LockCastMeter() == progress, "Lock the visible progress before confirmation audio")
	local expected = if progress >= 0.8 then 2 else 1
	assert(#probe.impulses == expected and probe.phase == "Preparing",
		"Camera feedback must begin while server confirmation is still pending")
	local tap = probe.impulses[1]
	assert(math.abs(tap.shake - (0.3 + progress * 0.4)) < 1e-10
		and tap.settings.Duration == 0.25 and tap.settings.Frequency == 22,
		"Click shake must match Throw Food's strength, duration and frequency")
	assert(#cues == expected and cues[1].name == "ButtonClick" and cues[1].volume == 0.8
		and math.abs(cues[1].pitch - (0.9 + progress * 0.5)) < 1e-10,
		"Confirm immediately with the locked progress pitch")
	if progress >= 0.8 then
		assert(cues[2].name == "Perfect" and cues[2].volume == 0.5 and cues[2].pitch == 1.3,
			"At 80% and above, layer Throw Food's perfect confirmation")
		assert(probe.flash.Visible and probe.flash.BackgroundTransparency == 0.65
			and probe.flash.BackgroundColor3[2] == 255, "Perfect must immediately show the green flash")
		assert(math.abs(select(6, probe:_sampleImpulses(tap.started + 0.05)) - 6) < 1e-6,
			"Perfect must reach +6 FOV after 50ms before server confirmation")
		probe:_updatePresentation(probe.perfectAt + 0.175, 0)
		assert(math.abs(probe.flash.BackgroundTransparency - 0.9125) < 1e-6,
			"Fixed casts must fade the perfect flash while waiting for the server")
		probe:_updatePresentation(probe.perfectAt + 0.35, 0)
		assert(math.abs(probe.flash.BackgroundTransparency - 1) < 1e-6,
			"Perfect flash must fully recover after 350ms")
		assert(select(6, probe:_sampleImpulses(tap.started + 0.36)) == 0,
			"Perfect FOV must recover without server confirmation")
	else
		assert(not probe.flash.Visible and probe.perfectAt == nil,
			"Below 80%, clicks must not flash or punch the FOV")
	end
	local pendingImpulses = #probe.impulses
	feedbackHarness.attach(probe)
		probe:LockCastMeter()
	probe:Cast(progress, 30)
	probe:Cast(progress, 30)
	assert(#cues == expected, "Repeated locks and server confirmation must not replay either confirmation cue")
	assert(#probe.impulses == pendingImpulses,
		"Repeated locks and server confirmation must not add another camera impulse")
	local clickTime=probe.meterLockedAt
	probe:_updatePresentation(clickTime+.5,0)
	assert(probe.meter.gui.Enabled and probe.popup.Visible,"Server confirmation must not hide or restart immediate feedback")
	probe:_updatePresentation(clickTime+1.21,0)
	assert(not probe.meter.gui.Enabled and probe.popup.Visible,"The popup must outlive the meter")
	probe:_updatePresentation(clickTime+1.51,0)
	assert(not probe.popup.Visible and probe.meterLockedAt==clickTime,"Feedback finishes on the original click time")
end

do
	local clicks = 0
	local direct = setmetatable({
		phase = "Preparing", fixedCast = true, meterProgress = 0.8, flash = {},
		folder = sequence.folder, meter = { gui = {} },
		_sound = function(_, name, volume, pitch)
			if name == "Perfect" then return end
			assert(name == "ButtonClick" and volume == 0.8 and math.abs(pitch - 1.3) < 1e-6,
				"Direct casts must use the same click sound and meter pitch")
			clicks += 1
		end,
		_impulse = function() end,
	}, Sequence)
	feedbackHarness.attach(direct)
	direct:Cast(0.8, 30)
	feedbackHarness.attach(direct)
	direct:Cast(0.8, 30)
	assert(clicks == 1 and direct.lockedMeterProgress == 0.8, "Direct callers must lock and click exactly once")
end

for _, case in ipairs({{0,"BAD"},{0.499999,"BAD"},{0.5,"GOOD"},{0.799999,"GOOD"},{0.8,"PERFECT"},{0.95,"PERFECT"},{0.950001,"GODLIKE!"},{1,"GODLIKE!"}}) do
 assert(Sequence.GetRating(case[1]).Text==case[2],"Shared rating boundary")
end
-- Validate actual feedback placement in portrait, landscape and desktop viewports.
for _, size in ipairs({{390,844},{844,390},{1877,1240}}) do
 for _,markerY in ipairs({0,size[2]/2,size[2]}) do
  local owner=setmetatable({flash={},_sound=function()end,_impulse=function()end},Sequence)
  feedbackHarness.attach(owner,size[1],size[2],markerY)
  owner:_castFeedback(.8,0)
  owner.castFeedback.Update(owner,.3)
  assert(owner.popup.Text=="PERFECT" and not owner.meter.prompt.Visible)
  assert(owner.popup.Position.X-size[1]*.1>=0 and owner.popup.Position.X+size[1]*.1<=size[1])
  assert(owner.popup.Position.Y-size[2]*.035>=0)
 end
end

local impulses = setmetatable({ impulses = {} }, Sequence)
local cameraConfig = modules.config.Camera
impulses:_impulse(cameraConfig.Release, 0)
local function fovAt(time)
	return select(6, impulses:_sampleImpulses(time))
end
assert(fovAt(0) == 0, "FOV attack must start from the existing shot")
assert(math.abs(fovAt(0.05) - 10) < 0.00001, "Release must reach +10 degrees after 50ms")
assert(fovAt(0.3) > 0 and fovAt(0.3) < 10, "FOV must recover after its peak")
assert(fovAt(0.56) == 0 and #impulses.impulses == 0, "Expired impulses must leave no FOV offset")
impulses:_impulse(cameraConfig.Landing, 1, 1)
assert(math.abs(impulses.impulses[1].shake - 3.0) < 0.00001, "Long casts must strengthen landing shake")
assert(math.abs(fovAt(1.05) + 8) < 0.00001, "Landing must punch inward")
impulses:_impulse(cameraConfig.Perfect, 1.05)
assert(fovAt(1.1) > -8, "Independent FOV effects must combine")
assert(fovAt(2) == 0 and #impulses.impulses == 0)

-- 落水位移按鱼饵尺寸缩放，三段之间连续，结束后只保留轻微漂浮。
for _, height in ipairs({ 0.8, 2 }) do
	local bounce = setmetatable({ bait = { Size = { Y = height } } }, Sequence)
	local function near(actual, expected)
		assert(math.abs(actual - expected) < 0.00001, string.format("Expected %.6f, got %.6f", expected, actual))
	end
	near(bounce:_landingOffset(0), 0)
	near(bounce:_landingOffset(0.12), -height * 0.65)
	near(bounce:_landingOffset(0.3), height * modules.config.Landing.ReboundHeight)
	near(bounce:_landingOffset(0.5), 0)
	assert(bounce:_landingOffset(0.06) < 0, "Bait must sink before rebounding")
	assert(bounce:_landingOffset(0.25) > 0, "Rebound must carry bait above its floating position")
	assert(bounce:_landingOffset(0.4) < 0, "Landing must cross below rest during its smaller rebound")
	for _, boundary in ipairs({ 0.12, 0.3, 0.5 }) do
		assert(
			math.abs(bounce:_landingOffset(boundary - 0.0000001) - bounce:_landingOffset(boundary + 0.0000001))
				< 0.00001,
			"Landing phase changes must not jump"
		)
	end
	for index = 1, 100 do
		assert(math.abs(bounce:_landingOffset(0.5 + index * 0.1)) <= 0.1, "Rebound must not restart after settling")
	end
end

local ticks = {}
local meterSequence = setmetatable({
	lastMeterStep = 0,
	_sound = function(_, name, _, pitch)
		table.insert(ticks, { name, pitch })
	end,
}, Sequence)
meterSequence:UpdateMeter(0.1)
assert(#ticks == 0)
meterSequence:UpdateMeter(0.9)
assert(#ticks == 1 and ticks[1][1] == "MeterTick", "A skipped frame must play one tick, not a burst")
meterSequence:UpdateMeter(0.89)
assert(#ticks == 1, "Moving within a segment must not repeat ticks")
meterSequence:UpdateMeter(0.2)
assert(#ticks == 2 and ticks[2][2] < ticks[1][2], "Downward ticks must lower the pitch")

local enabled = false
local stopped, resumed, destroyed = 0, 0, 0
local wind = {
	Looped = true,
	IsPlaying = true,
	Stop = function(self)
		stopped += 1
		self.IsPlaying = false
	end,
	Play = function(self)
		resumed += 1
		self.IsPlaying = true
	end,
}
local oneShot = {
	Stop = function()
		stopped += 1
	end,
	Destroy = function()
		destroyed += 1
	end,
}
local audio = setmetatable({
	options = {
		isSoundEnabled = function()
			return enabled
		end,
	},
	sounds = { [wind] = true, [oneShot] = true },
	wind = wind,
	phase = "Flying",
}, Sequence)
audio:RefreshSoundSetting()
assert(stopped == 2 and destroyed == 1 and not wind.IsPlaying, "Muting must stop active audio immediately")
enabled = true
audio:RefreshSoundSetting()
audio:RefreshSoundSetting()
assert(resumed == 1, "Only the active flight wind may resume, without replaying old one-shots")

local function cleanupProbe(failStop)
	local stopped, trackDestroyed, folderDestroyed, guiDestroyed, effectsDestroyed = 0, 0, 0, 0, 0
	local instance = setmetatable({
		characterVFX = { Destroy = function() effectsDestroyed += 1 end },
		track = {
			Stop = function()
				stopped += 1
				if failStop then
					error("Animator already destroyed")
				end
			end,
			Destroy = function()
				trackDestroyed += 1
			end,
		},
		folder = {
			Destroy = function()
				folderDestroyed += 1
			end,
		},
		gui = {
			Parent = true,
			Enabled = true,
			Destroy = function()
				guiDestroyed += 1
			end,
		},
	}, Sequence)
	instance:Destroy()
	instance:Destroy()
	assert(
		stopped == 1 and folderDestroyed == 1 and guiDestroyed == 0 and effectsDestroyed == 1 and not instance.gui.Enabled,
		"Cleanup must be idempotent and survive an unavailable Animator"
	)
	if not failStop then
		assert(trackDestroyed == 1)
	end
end
cleanupProbe(false)
cleanupProbe(true)

-- 复用同一预置 UI；每轮的状态变化与初始化失败均不能销毁它或污染下一轮。
do
	local function node(name, class, children)
		local item = { Name = name, Parent = true, children = children or {} }
		function item:IsA(kind)
			return kind == class
		end
		function item:FindFirstChild(key)
			return self.children[key]
		end
		function item:GetFullName()
			return self.Name
		end
		return item
	end
	local function text(name)
		local item = node(name, "TextLabel")
		item.Text, item.Visible, item.TextTransparency, item.TextColor3 = name, false, 0.2, "studioColor"
		item.Position, item.FontFace = "studioPosition", "studioFont"
		return item
	end
	local gui = node("FishingSequenceGui", "ScreenGui", {
		PerfectFlash = node("PerfectFlash", "Frame"),
		TopBar = node("TopBar", "Frame"), BottomBar = node("BottomBar", "Frame"),
		ContinuePrompt = text("tap to continue"),
		PowerPopup = text("PowerPopup"),
	})
	gui.children.PerfectFlash.BackgroundColor3, gui.children.PerfectFlash.BackgroundTransparency = "studioFlash", 1
	gui.children.TopBar.Size, gui.children.BottomBar.Size = "studioTopSize", "studioBottomSize"
	local popup = gui.children.PowerPopup
	popup.children.UIStroke, popup.children.UIScale = node("UIStroke", "UIStroke"), node("UIScale", "UIScale")
	popup.children.UIStroke.Transparency, popup.children.UIScale.Scale = 0.1, 1.1
	local playerGui = node("PlayerGui", "PlayerGui", { FishingSequenceGui = gui })
	do
		local template = node("BitePromptTemplate", "BillboardGui")
		template.Enabled = false
		gui.children.BitePromptTemplate = template
		local clones, destroyed = 0, 0
		function template:Clone()
			clones += 1
			local scale = node("UIScale", "UIScale")
			local icon = node("Icon", "ImageLabel", { UIScale = scale })
			local prompt = node("BitePromptTemplate", "BillboardGui", { Icon = icon })
			function prompt:SetAttribute(name, value)
				assert(self.Parent == true, "Exempt the bite prompt before parenting it into the scene")
				self[name] = value
			end
			function prompt:Destroy() destroyed += 1; self.Parent = nil end
			return prompt
		end
		environment.Enum = { EasingStyle = { Back = "Back" }, EasingDirection = { Out = "Out" } }
		function tweenService:GetValue(alpha, style, direction)
			assert(style == "Back" and direction == "Out")
			return 1 + 2.70158 * (alpha - 1) ^ 3 + 1.70158 * (alpha - 1) ^ 2
		end
		local owner = setmetatable({
			gui = gui, folder = {}, bait = {}, baitBaseSize = vector(1, 4, 1),
			baitHighlight = {}, baitAppearance = {},
		}, Sequence)
		owner:_initBitePrompt()
		local prompt, scale = owner.bitePrompt, owner.bitePromptScale
		local settings = modules.config.Bite.Prompt
		assert(prompt ~= template and prompt.Parent == owner.folder and prompt.Adornee == owner.bait)
		assert(prompt.FishingBillboardExempt == true and template.FishingBillboardExempt == nil,
			"Exempt only the runtime bite prompt from fishing billboard suppression")
		assert(not prompt.Enabled and scale.Scale == settings.StartScale)
		assert(prompt.StudsOffsetWorldSpace.Y == 2 + settings.HeightOffset, "Place the icon above this bait's top")
		for _, phase in ipairs({ "Waiting", "Approaching", "Holding", "Nibbling" }) do
			owner:_presentBait(phase, 0.1)
			assert(not prompt.Enabled, "Only a true bite may display the prompt")
		end
		owner:_presentBait("Bite", 0)
		assert(prompt.Enabled and math.abs(scale.Scale - settings.StartScale) < 1e-6)
		owner:_presentBait("Bite", settings.PopTime * 0.6)
		assert(scale.Scale > 1, "The popup must briefly overshoot")
		for _, elapsed in ipairs({ settings.PopTime, settings.PopTime + 0.1, 2 }) do
			owner:_presentBait("Bite", elapsed)
			assert(prompt.Enabled and scale.Scale == 1, "Keep the icon settled throughout the bite window")
		end
		for _, phase in ipairs({ "Struggling", "Escaped", "Reeling", "Waiting", "Caught" }) do
			owner:_presentBait(phase, 0)
			assert(not prompt.Enabled and math.abs(scale.Scale - settings.StartScale) < 1e-6,
				"Hooking, timeout and retry must immediately hide and reset the icon")
		end
		owner:_presentBait("Bite", 0)
		assert(prompt.Enabled and clones == 1, "A new round must reuse the clone and replay the popup")
		owner.folder = nil
		owner:Destroy()
		owner:Destroy()
		assert(destroyed == 1 and prompt.Parent == nil and not owner.bitePrompt and not owner.bitePromptScale,
			"Cleanup must release the prompt once, even after partial initialization")
		assert(template.Parent and not template.Enabled, "Never modify or destroy the Studio template")
	end
	local function create()
		return setmetatable({ originals = {}, createdScales = {} }, Sequence)
	end
	for _ = 1, 2 do
		local owner = create()
		owner:_bindGui(playerGui)
		assert(owner.gui == gui and not gui.Enabled and not owner.popup.Visible)
		assert(owner.continueText == "tap to continue" and owner.popupScale.Scale == 1)
		assert(owner.popup.FontFace == "studioFont" and owner.continueLabel.Position == "studioPosition")
		gui.Enabled = true
		for _, original in ipairs(owner.originals) do
			original.instance[original.property] = "changedDuringRound"
		end
		owner:Destroy()
		owner:Destroy()
		assert(not gui.Enabled and gui.Parent, "Preset UI must stay available after cleanup")
		for _, original in ipairs(owner.originals) do
			assert(original.instance[original.property] == original.value, "Presentation state leaked into the next round")
		end
	end
	for _, replacement in ipairs({ false, node("UIScale", "Frame") }) do
		local scale = popup.children.UIScale
		popup.children.UIScale = replacement or nil
		local owner = create()
		local ok, err = pcall(owner._bindGui, owner, playerGui)
		assert(not ok and string.find(err, "PowerPopup.UIScale", 1, true), "Invalid preset must fail with its path")
		owner:Destroy()
		assert(gui.Parent and not gui.Enabled, "Partial binding must leave the preset hidden and intact")
		popup.children.UIScale = scale
	end
	local owner = create()
	playerGui.children.FishingSequenceGui = nil
	assert(not pcall(owner._bindGui, owner, playerGui), "Missing preset must fail without a runtime fallback")
	owner:Destroy()
end

-- 保留的水花音沿用声音开关，静音时不创建或延迟补播。
local plays, created = 0, 0
environment.Instance = {
	new = function(class)
		assert(class == "Sound")
		created += 1
		return {
			Ended = { Once = function() end },
			Play = function()
				plays += 1
			end,
		}
	end,
}
enabled = false
assert(audio:_sound("Splash") == nil and created == 0)
enabled = true
local cue = audio:_sound("Splash")
assert(created == 1 and plays == 1 and cue.Volume == 0.8 and cue.PlaybackSpeed == 1)
assert(cue.SoundId == modules.config.Sounds.Splash.Id)

-- 同帧先计算基础姿态和镜头，再显示透视补偿并连接鱼线。
do
	local order = {}
	local position = {}
	local resource = { Parent = true }
	local session = setmetatable({
		phase = "Holding",
		bait = resource,
		line = resource,
		lineEnd = resource,
		lineEndAttachment = resource,
		lineTop = resource,
		lineTopAttachment = resource,
		tip = {
			IsDescendantOf = function()
				return true
			end,
		},
		gui = resource,
		bars = {},
		barAmount = 0,
		bite = {
			Present = function(_, actualCamera)
				assert(actualCamera == position, "Presentation used a stale camera")
				table.insert(order, "present")
			end,
		},
		_updateBait = function()
			table.insert(order, "base")
		end,
		_updateCamera = function()
			workspace.CurrentCamera = { CFrame = { Position = position } }
			table.insert(order, "camera")
		end,
		_updateLine = function()
			table.insert(order, "line")
		end,
		_updateIdleWaterVFX = function() end,
		_updateWaterEffects = function() end,
		RefreshSoundSetting = function() end,
		_updatePresentation = function(_, _, dt)
			assert(dt == 1 / 60, "Forward the render delta to the meter's reference integration")
		end,
		vignette = { Update = function() end },
		characterVFX = { Update = function() table.insert(order, "characterVFX") end },
	}, Sequence)
	session:Update(10, 1 / 60)
	assert(table.concat(order, ",") == "base,characterVFX,camera,present,line", "Camera/presentation/line order changed")
	table.clear(order)
	session.bite = nil
	session:Update(11, 1 / 60)
	assert(table.concat(order, ",") == "base,characterVFX,camera,line", "Update character VFX before the bite sequence exists")

	table.clear(order)
	local heldFishBody = {}
	local heldCameraPosition = {}
	session.phase = "Caught"
	session.bite = {
		Present = function(_, actualCamera, actualBody)
			assert(actualCamera == heldCameraPosition and actualBody == heldFishBody,
				"The fish and its effects must use the current hold pose and camera")
			table.insert(order, "held fish")
		end,
	}
	session.options = {
		presentCaught = function(bite, _, camera)
			assert(bite == session.bite, "The custom shot receives the existing fish")
			camera.CFrame = { Position = heldCameraPosition }
			table.insert(order, "held pose")
			return heldFishBody
		end,
	}
	session.line = { Parent = true, Enabled = true }
	session:Update(12, 1 / 60)
	assert(table.concat(order, ",") == "base,characterVFX,held pose,held fish" and not session.line.Enabled,
		"The first held-fish frame applies the custom shot and hides the fishing line")
end

-- 鱼的拉远在上升期间完成，追随从破水后的滞后窗口开始。
do
	local settings = modules.config.Bite
	local Motion = dofile("src/ReplicatedStorage/Modules/FishingLiftMotion.lua")
	local plan = Motion.New(settings, modules.config.BaitElastic, -4, 5, 8)
	local timeline = { phase = "Lifting", startedAt = 100 }
	local sequence = setmetatable({
		bite = { timeline = timeline, liftPlan = plan, _prepareLift = function() end },
		_waterTarget = function() return {} end,
	}, Sequence)
	local hold = 100 + plan.exitAt + settings.FishLift.CameraHold
	local entry, pullback = sequence:_showcaseProgress(hold)
	assert(math.abs(entry) < 1e-9 and pullback > 0, "Hold the water focus while beginning the pullback")
	entry, pullback = sequence:_showcaseProgress(100 + plan.timing.riseEnd)
	assert(entry == 1 and pullback == 1, "Finish camera entry and pullback by the apex")
	local before, beforePull = sequence:_showcaseProgress(100 + plan.timing.duration)
	timeline.phase, timeline.startedAt = "Caught", 100 + plan.timing.duration
	local after, afterPull = sequence:_showcaseProgress(timeline.startedAt)
	assert(before == after and beforePull == afterPull, "Caught reset the camera clock")
end

-- A stalled frame can cross every special-cast node; each event still fires exactly once.
do
 local calls = {}
 local function hit(name) calls[name] = (calls[name] or 0) + 1 end
 local probe = setmetatable({phase="Casting",castClickedAt=0,rig={},castProfile=modules.config.CastProfiles.Godlike,
  track={Length=2.5166667,Play=function(_,_,_,speed) assert(speed==1); hit("Play") end},
  characterVFX={Start=function()hit("Start")end,BeginTrail=function()hit("Trail")end,
   Land=function()hit("Land")end,Charge=function()hit("Charge")end,BeginSwing=function()hit("Impact")end},
  _shot=function(_,name)assert(name=="Special");hit("Shot")end,
  _impulse=function(_,settings)hit(settings==modules.config.CastProfiles.Godlike.ImpactImpulse and "Shake" or "LandingShake")end,
  _sound=function(_,name)assert(name=="SpinWhoosh");hit("Whoosh")end,
  fishAudio={Play=function(_,name)hit(name)end},
  _release=function(self)if not self.flightStarted then self.flightStarted=true;hit("Release")end end,
 },Sequence)
 probe:_updateAction(.35)
 probe:_updateAction(.35+.199)
 assert(not calls.Trail and not calls.Impact and not calls.Release)
 probe:_updateAction(.35+2.40)
 assert(calls.Trail==1 and calls.Land==1 and calls.Charge==1 and not calls.Impact and not calls.Release)
 probe:_updateAction(.35+2.431)
 assert(calls.Impact==1 and calls.FishingCastImpact==1 and not calls.Release)
 probe:_updateAction(.35+2.491)
 probe:_updateAction(.35+3)
 for _,count in pairs(calls) do assert(count==1,"Special event replayed") end
 assert(calls.Play==1 and calls.Shake==1 and calls.Release==1 and calls.Whoosh==1)
end
