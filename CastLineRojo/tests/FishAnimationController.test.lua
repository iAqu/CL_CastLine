--# selene: allow(incorrect_standard_library_use)
local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local settings = config.Bite.Motion.Animation
local services = {}
local warnings, tasks = {}, {}
local environment = setmetatable({
	script = { Parent = { FishingConfig = "config" } },
	game = {
		GetService = function(_, name)
			return services[name]
		end,
	},
	require = function(name)
		assert(name == "config")
		return config
	end,
	warn = function(message)
		table.insert(warnings, message)
	end,
	task = {
		spawn = function(callback)
			table.insert(tasks, callback)
		end,
	},
}, { __index = getfenv() })
services.ReplicatedStorage, services.ContentProvider = {}, {}
-- selene: allow(undefined_variable)
local Animation =
	assert(load(read("src/ReplicatedStorage/Modules/FishAnimationController.lua"), "FishAnimation", "t", environment))()
local function state()
	return Animation.NewState(0, {
		NextNumber = function(_, low, high)
			return (low + high) / 2
		end,
	})
end
local sampler = state()
local sampleCalls, sharedRequest = 0, { name = "ShowcaseFlop", position = 0.3 }
local loading = setmetatable({
	loading = true,
	state = {
		Sample = function()
			sampleCalls += 1
			return sharedRequest
		end,
	},
}, Animation)
assert(loading:Update("Caught", 0, 4.3) == sharedRequest and sampleCalls == 1, "Animation request was not shared once")
assert(not sampler:Sample("Waiting", 0, 5))
assert(not sampler:Sample("Approaching", 10, 10))
local swim = sampler:Sample("Approaching", 10, 10.5)
local hold = sampler:Sample("Holding", 11, 11.5)
assert(swim.name == "SwimLoop" and swim.speed == 1 and swim.weight == 1)
assert(hold.name == "SwimLoop" and hold.weight == settings.HoldWeight)
assert(swim.token == hold.token, "Phase change unnecessarily restarts swimming")
assert(not sampler:Sample("Nibbling", 10, 10 + config.Bite.Nibble.AttackTime + 0.01))
assert(not sampler:Sample("Bite", 10, 10 + config.Bite.BiteSinkTime + 0.001))
for _, speed in ipairs({ 0.8, 1, 1.3 }) do
	local at = 0.04 / speed
	local request = sampler:Sample("Nibbling", 0, at, 1, nil, speed)
	local expected = sampler:Sample("Nibbling", 0, 0.04)
	assert(math.abs(request.weight - expected.weight) < 1e-9, "Nibble weight used the wrong clock")
	assert(request.token == expected.token and request.speed == 1, "Rhythm restarted or sped up the swim clip")
	assert(math.abs(request.position - at % settings.Clips.SwimLoop.Duration) < 1e-9, "Swim phase was time-scaled")
	assert(not sampler:Sample("Nibbling", 0, 0.15 / speed, 1, nil, speed), "Contact weight missed scaled timing")
end
local cycle = config.Bite.Struggle.AnimationCycle
local struggleSpeed = settings.Clips.StruggleLeft.Duration / cycle
assert(cycle == 0.45)
for _, mirror in ipairs({ -1, 1 }) do
	for index = 0, math.floor(config.Bite.StruggleTime / cycle) - 1 do
		local at = (index + 0.5) * config.Bite.Struggle.AnimationCycle
		local request = sampler:Sample("Struggling", 0, at, mirror)
		assert(request.name == (if mirror > 0 then "StruggleLeft" else "StruggleRight"))
		assert(math.abs(request.position - 0.3) < 1e-6 and request.speed == struggleSpeed)
		assert(request.token == 0, "Loop unnecessarily changed track token")
		assert(settings.Clips[request.name].Looped, "Struggle must loop without restarts")
		for _, rate in ipairs({ 15, 30, 60, 144 }) do
			local sampled = state()
			for frame = 0, math.floor(at * rate) do
				sampled:Sample("Struggling", 0, frame / rate, mirror)
			end
			local actual = sampled:Sample("Struggling", 0, at, mirror)
			assert(actual.token == request.token and actual.position == request.position)
		end
	end
	for _, time in ipairs({ 0, 0.6, 1.05, 1.65, 1.9, 2.65, 2.999 }) do
		assert(sampler:Sample("Struggling", 0, time, mirror), "Orbit animation paused")
	end
	local lateAt = 2.85
	local late = state():Sample("Struggling", 0, lateAt, mirror)
	assert(
		late.token == 0 and math.abs(late.position - lateAt % cycle * struggleSpeed) < 1e-6,
		"Late entry replayed old cycles"
	)
	assert(not sampler:Sample("Struggling", 0, 3, mirror), "Expired struggle replayed")
end
assert(sampler:Sample("Lifting", 10, 11).name == "LiftFlop")
assert(not sampler:Sample("Lifting", 10, 13), "Late entry played an expired lift")
local idle = state()
local first = idle:Sample("Caught", 100, 100)
assert(first.name == "ShowcaseFlop" and first.token == 100 and first.position == 0, "First showcase was delayed")
local continuing = idle:Sample("Caught", 100, 100.3)
assert(continuing.token == first.token and math.abs(continuing.position - 0.3) < 1e-6, "First showcase lost its timing")
local firstEnd = 100 + settings.Clips.ShowcaseFlop.Duration
local function showcaseIdle(clock, now)
	local request = clock:Sample("Caught", 100, now)
	assert(request.name == "SwimLoop" and request.token == "ShowcaseIdle", "Showcase idle did not swim")
	assert(request.speed == 0.35 and request.weight == 0.25, "Showcase idle strength changed")
	assert(
		math.abs(request.position - ((now - 100) * request.speed % settings.Clips.SwimLoop.Duration)) < 1e-9,
		"Showcase idle lost its continuous clock"
	)
	return request
end
showcaseIdle(idle, firstEnd)
assert(idle.nextBurst == firstEnd + 4, "Random pause did not start")
local nextBurst = idle.nextBurst
showcaseIdle(idle, nextBurst - 0.001)
local later = idle:Sample("Caught", 100, nextBurst)
assert(later.name == "ShowcaseFlop" and later.token == nextBurst and later.position == 0, "Random showcase was delayed")
showcaseIdle(idle, nextBurst + settings.Clips.ShowcaseFlop.Duration)
showcaseIdle(idle, 1000)
assert(idle.nextBurst == 1004)
showcaseIdle(idle, 1000)
assert(idle.nextBurst == 1004)
local skipped = state()
showcaseIdle(skipped, 1000)
assert(skipped.nextBurst == 1004)
assert(idle:Sample("Caught", 2000, 2000).position == 0, "Next catch did not play its first showcase")
assert(not sampler:Sample("Reeling", 10, 10.5))
assert(not sampler:Sample("Reeled", 10, 10.5))

-- 首次甩尾连续采样只播放一次；随机间隔结束才播放下一次。
do
	local plays, stops = 0, 0
	local track = { Length = settings.Clips.ShowcaseFlop.Duration, Looped = false, TimePosition = 0 }
	track.Play = function(self, fade, weight, speed)
		assert(fade == settings.FadeTime and weight == 1 and speed == 1, "Showcase playback settings changed")
		plays += 1
		self.IsPlaying = true
	end
	track.Stop = function(self)
		stops += 1
		self.IsPlaying = false
	end
	local idlePlays, idleStops = 0, 0
	local swimTrack = { Length = settings.Clips.SwimLoop.Duration, Looped = true, TimePosition = 0 }
	swimTrack.Play = function(self, fade, weight, speed)
		assert(fade == settings.FadeTime and weight == 0.25 and speed == 0.35)
		idlePlays += 1
		self.IsPlaying = true
	end
	swimTrack.Stop = function(self, fade)
		assert(fade == settings.FadeTime, "Idle did not crossfade into the next burst")
		idleStops += 1
		self.IsPlaying = false
	end
	local controller =
		setmetatable({ state = state(), tracks = { ShowcaseFlop = track, SwimLoop = swimTrack } }, Animation)
	for _, at in ipairs({ 100, 100.1, 100.3, 100.6, 100.899 }) do
		controller:Update("Caught", 100, at)
		assert(plays == 1 and stops == 0, "First showcase track restarted")
	end
	controller:Update("Caught", 100, firstEnd)
	assert(plays == 1 and stops == 1, "First showcase did not finish")
	controller:Update("Caught", 100, firstEnd + 3.9)
	assert(plays == 1 and stops == 1 and idlePlays == 1 and idleStops == 0, "Idle restarted during the interval")
	controller:Update("Caught", 100, firstEnd + 4)
	assert(plays == 2 and stops == 1 and idleStops == 1, "Random showcase did not resume")
end

-- 周期边界和长帧只调整绝对播放位置，不停止/重播同一挣扎轨道。
for _, mirror in ipairs({ -1, 1 }) do
	local plays, stops = 0, 0
	local track = { Length = 0.6, Looped = true, TimePosition = 0, IsPlaying = false }
	track.Play = function(self, fade, weight, speed)
		assert(fade == settings.FadeTime and weight == 1 and speed == struggleSpeed)
		plays += 1
		self.IsPlaying = true
	end
	track.Stop = function(self)
		stops += 1
		self.IsPlaying = false
	end
	local controller =
		setmetatable({ state = state(), tracks = {
			StruggleLeft = track,
			StruggleRight = track,
		} }, Animation)
	for _, at in ipairs({
		0,
		cycle - 0.001,
		cycle,
		cycle + 0.001,
		cycle * 2 - 0.001,
		cycle * 2,
		cycle * 2 + 0.001,
		1.2,
		2.85,
		2.999,
	}) do
		controller:Update("Struggling", 0, at, mirror)
		assert(plays == 1 and stops == 0, "Continuous struggle track restarted at cycle boundary")
	end
	assert(
		math.abs(track.TimePosition - 2.999 % cycle * struggleSpeed) < 1e-6,
		"Long frame did not seek to current loop position"
	)
	controller:Update("Lifting", 3, 3, mirror)
	assert(stops == 1, "Leaving struggle failed to fade the loop out")
end

-- Failed preload remains neutral and emits a single warning; canceled loads create no tracks.
local function node(children, class)
	return {
		FindFirstChild = function(_, name)
			return children[name]
		end,
		IsA = function(_, name)
			return name == class
		end,
	}
end
local root = node({}, "MeshPart")
local chain = root
for _, name in ipairs(settings.Bones) do
	local child = node({}, "Bone")
	chain.FindFirstChild = function(_, key)
		return if key == name then child else nil
	end
	chain = child
end
local loaded = 0
local animator = {
	LoadAnimation = function()
		loaded += 1
		error("Canceled load reached Animator")
	end,
}
local controller = {
	FindFirstChildOfClass = function()
		return animator
	end,
}
local fish = {
	PrimaryPart = root,
	FindFirstChild = function()
		return nil
	end,
	FindFirstChildOfClass = function()
		return controller
	end,
}
local assets = {}
for name in pairs(settings.Clips) do
	assets[name] = {
		Name = name,
		AnimationId = "rbxassetid://1",
		IsA = function(_, class)
			return class == "Animation"
		end,
	}
end
services.ReplicatedStorage.FindFirstChild = function()
	return node({ Fishing = node({ Fish = node(assets) }) })
end
services.ContentProvider.PreloadAsync = function()
	error("test preload failure")
end
local failed = Animation.new(fish, 0, {})
table.remove(tasks, 1)()
assert(failed.failed and not next(failed.tracks) and #warnings == 1)
failed:Update("Approaching", 0, 0.5)
failed:Destroy()
local canceled = Animation.new(fish, 0, {})
services.ContentProvider.PreloadAsync = function()
	canceled:Destroy()
end
table.remove(tasks, 1)()
assert(canceled.destroyed and loaded == 0 and not next(canceled.tracks))

-- Per-fish clips override shared clips; absent entries keep the legacy fallback.
local custom = { Name = "SwimLoop", AnimationId = "rbxassetid://2", IsA = assets.SwimLoop.IsA }
fish.FindFirstChild = function(_, name)
	return if name == "Animations" then node({ SwimLoop = custom }) else nil
end
local selected
services.ContentProvider.PreloadAsync = function(_, list)
	selected = list
	error("stop after selection")
end
local mixed = Animation.new(fish, 0, {})
table.remove(tasks, 1)()
local count = 0
for _, asset in ipairs(selected) do
	assert(asset == (if asset.Name == "SwimLoop" then custom else assets[asset.Name]))
	count += 1
end
assert(count == 5, "Per-fish override lost a required clip")
mixed:Destroy()

-- A complete local set does not require the global folder.
fish.FindFirstChild = function(_, name)
	return if name == "Animations" then node(assets) else nil
end
services.ReplicatedStorage.FindFirstChild = function()
	return nil
end
selected = nil
local localOnly = Animation.new(fish, 0, {})
table.remove(tasks, 1)()
assert(selected and #selected == 5, "Local clips still depend on the shared folder")
localOnly:Destroy()

-- V2 inserts real joints between the legacy anchors. It must still load all five clips.
local tailBase = node({ FishTail = node({}, "Bone") }, "Bone")
local mid = node({ TailBase = tailBase }, "Bone")
local intermediate = node({ SpineMid = mid }, "Bone")
local front = node({}, "Bone")
front.FindFirstChild = function(_, name, recursive)
	if name == "SpineMid" and recursive then
		return intermediate:FindFirstChild(name)
	end
	return nil
end
fish.PrimaryPart = node({ FishBody = node({ SpineFront = front }, "Bone") }, "MeshPart")
selected = nil
local expanded = Animation.new(fish, 0, {})
table.remove(tasks, 1)()
assert(selected and #selected == 5, "Expanded spine could not load the five clips")
expanded:Destroy()

local stopped, destroyed = 0, 0
local active = setmetatable({
	tracks = {
		test = {
			Stop = function()
				stopped += 1
			end,
			Destroy = function()
				destroyed += 1
			end,
		},
	},
}, Animation)
active:Destroy()
active:Destroy()
assert(stopped == 1 and destroyed == 1 and not next(active.tracks))

-- 回游权重由实际速度驱动，跨状态继续同一条游动动画，不在接触结束后倒退摆尾。
local returning = state()
local duringNibble = returning:Sample("Nibbling", 0, 0.4, 1, 1)
local duringHold = returning:Sample("Holding", 0.55, 0.7, 1, 1)
assert(duringNibble.name == "SwimLoop" and duringNibble.weight == 1)
assert(duringHold.token == duringNibble.token and duringHold.weight == 1)
assert(not returning:Sample("Holding", 0.55, 2.5, 1, 0), "Stopped fish did not settle")
assert(returning:Sample("Holding", 0.55, 2.7, 1, settings.HoldWeight).weight == settings.HoldWeight)

do
	local duration = 1.55
	local request = sampler:Sample("Lifting", 10, 10.5, nil, nil, nil, nil, duration)
	assert(math.abs(request.speed - settings.Clips.LiftFlop.Duration / duration) < 1e-9)
	assert(math.abs(request.position - 0.5 * request.speed) < 1e-9)
	assert(not sampler:Sample("Lifting", 10, 11.56, nil, nil, nil, nil, duration))
end
