local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local environment = setmetatable({
	script = { Parent = { FishingConfig = "config" } },
	game = {
		GetService = function()
			return {}
		end,
	},
	require = function(name)
		assert(name == "config")
		return config
	end,
}, { __index = getfenv() })
local Bite = assert(
	load(read("src/ReplicatedStorage/Modules/FishingBiteSequence.lua"), "FishingBiteSequence", "t", environment)
)()
local settings = config.Bite

local function timeline(count, delay, startedAt, readyAt)
	startedAt = startedAt or 10
	return Bite.NewTimeline(startedAt, {
		NextInteger = function(_, minimum, maximum)
			assert(minimum == 0 and maximum == 3)
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

for _, count in ipairs({ 0, 3 }) do
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
	assert(early:CanReturn(time) and not early:CanRetry(time + 100), "Manual reeling must not restart fishing")
end

for _, offset in ipairs({ 0, 0.5, 0.999999 }) do
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

for _, offset in ipairs({ 1, 1.000001, 20 }) do
	local state = timeline(0)
	assert(
		not state:TryHook(biteAt(0) + offset) and state.phase == "Reeling",
		"Late input must reel in without catching"
	)
	assert(state.baitConsumed, "A skipped bite must still consume bait")
	assert(not state:TryHook(biteAt(0) + offset + 1) and state.phase == "Reeling")
end

local stalled = timeline(3)
stalled:Advance(1000)
assert(stalled.phase == "Escaped" and stalled:CanRetry(1000), "A long frame must cross every expired phase")
assert(not stalled:CanReturn(1000))
assert(not stalled:TryHook(1000) and stalled:CanReturn(1000), "Reeling after a timeout must end the cast")
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

-- 摆动用绝对时间采样：停留减弱、接触时收敛、隐藏/出水阶段无额外摇摆。
local motionSettings = settings.Motion
local function motion()
	return Bite.NewMotion(10, {
		NextNumber = function(_, low, high)
			return (low + high) * 0.5
		end,
		NextInteger = function(_, low)
			return low
		end,
	})
end
local moving = motion()
local function magnitude(phase, elapsed, now)
	local pitch, yaw, roll = moving:Sample(phase, elapsed, now)
	return math.abs(pitch) + math.abs(yaw) + math.abs(roll)
end
local swimming = magnitude("Approaching", 0.5, 12.5)
assert(swimming > 0.01, "Swimming fish has no body motion")
assert(
	math.abs(magnitude("Holding", 0.5, 12.5) / swimming - motionSettings.Swim.HoldStrength) < 0.000001,
	"Waiting fish did not reduce its motion"
)
assert(magnitude("Approaching", 0, 12) == 0, "Appearance starts with a motion jump")
assert(magnitude("Nibbling", settings.NibbleTime * 0.5, 12.5) < 0.000001, "Nibble contact must settle")
assert(magnitude("Bite", settings.BiteSinkTime, 12.5) == 0, "Hooked mouth must settle")
for _, phase in ipairs({ "Settling", "Waiting", "Reeling", "Struggling", "Lifting" }) do
	assert(magnitude(phase, 0.5, 12.5) == 0, "Unexpected extra motion in " .. phase)
end
local atBoundary = magnitude("Approaching", settings.ApproachTime, 20)
assert(math.abs(atBoundary - magnitude("Holding", 0, 20)) < 0.000001, "Approach/holding motion jumped")
assert(
	math.abs(magnitude("Nibbling", settings.NibbleTime, 20) - magnitude("Holding", 0, 20)) < 0.000001,
	"Nibble/holding motion jumped"
)
local p1, y1, r1 = moving:Sample("Approaching", 0.5, 12.5)
moving:Sample("Holding", 0.3, 12.2)
local p2, y2, r2 = moving:Sample("Approaching", 0.5, 12.5)
assert(p1 == p2 and y1 == y2 and r1 == r2, "Render sampling accumulated motion")

-- 展示先静止，短促摆动后恢复；长帧跳过过期动作，不积累待播放次数。
local idle = motion()
local function idleAt(elapsed)
	return idle:Sample("Caught", elapsed, 100 + elapsed)
end
local function still(elapsed)
	local pitch, yaw, roll = idleAt(elapsed)
	return pitch == 0 and yaw == 0 and roll == 0
end
assert(still(0) and still(3.99) and still(4), "Showcase must wait before struggling")
local maximum = 0
for index = 1, 89 do
	local pitch, yaw, roll = idleAt(4 + index * 0.01)
	maximum = math.max(maximum, math.abs(yaw))
	assert(math.abs(pitch) <= math.rad(motionSettings.Showcase.Pitch), "Pitch exceeded its limit")
	assert(math.abs(yaw) <= math.rad(motionSettings.Showcase.Yaw), "Yaw exceeded its limit")
	assert(math.abs(roll) <= math.rad(motionSettings.Showcase.Roll), "Roll exceeded its limit")
end
assert(maximum > math.rad(4), "Showcase struggle is missing")
assert(still(4.9) and still(5.5), "Showcase did not return to rest")
assert(idle.nextBurst >= 104.9 + 3 and idle.nextBurst <= 104.9 + 5, "Next pause is outside 3-5 seconds")
assert(still(1000) and idle.nextBurst == 1104, "A long frame must skip expired showcase bursts")
assert(still(1000), "Repeated sampling restarted the showcase schedule")
local skipped = motion()
assert(select(2, skipped:Sample("Caught", 1000, 1100)) == 0, "Late entry replayed expired motion")
assert(skipped.nextBurst == 1104, "Late entry must schedule from the current time")

-- 摆尾固定头部，切换阶段保持连续，并与展示挣动使用同一轮随机时序。
local tailSettings = settings.Motion.Tail
local tail = motion()
local function tailAt(phase, elapsed, now)
	return tail:SampleTail(phase, elapsed, now or (20 + elapsed))
end
assert(tailAt("Approaching", 0) == 0)
local swimAngle = tailAt("Approaching", 0.5, 20.5)
assert(math.abs(swimAngle) > 0.01)
assert(math.abs(tailAt("Holding", 0.5, 20.5) / swimAngle - motionSettings.Swim.HoldStrength) < 1e-6)
assert(math.abs(tailAt("Nibbling", settings.NibbleTime * 0.5)) < 1e-6)
assert(tailAt("Bite", settings.BiteSinkTime) == 0)
for _, phase in ipairs({ "Settling", "Waiting", "Reeling" }) do
	assert(tailAt(phase, 0.5) == 0, "Hidden fish should not swim")
end
local boundary = tailAt("Approaching", settings.ApproachTime, 30)
assert(math.abs(boundary - tailAt("Holding", 0, 30)) < 1e-6)
assert(math.abs(tailAt("Nibbling", settings.NibbleTime, 30) - tailAt("Holding", 0, 30)) < 1e-6)
tail.hookTailAngle = tailAt("Bite", 0.04, 30)
assert(math.abs(tailAt("Struggling", 0, 30) - tail.hookTailAngle) < 1e-6, "Hook input snapped the tail")
assert(
	math.abs(tailAt("Struggling", settings.StruggleTime, 33) - tailAt("Lifting", 0, 33)) < 1e-6,
	"Leaving water snapped the tail"
)
assert(tailAt("Lifting", settings.LiftTime, 35) == 0, "Showcase must start at rest")
for _, rate in ipairs({ 15, 30, 60, 144 }) do
	local sampled = motion()
	for frame = 0, rate do
		sampled:SampleTail("Struggling", frame / rate, 30 + frame / rate)
	end
	assert(sampled:SampleTail("Struggling", 1, 31) == motion():SampleTail("Struggling", 1, 31))
end
for _, phase in ipairs({ "Approaching", "Holding", "Escaped", "Struggling", "Lifting" }) do
	local limit =
		math.rad(if phase == "Struggling" or phase == "Lifting" then tailSettings.StruggleYaw else tailSettings.Yaw)
	for index = 0, 200 do
		assert(math.abs(tailAt(phase, index * 0.01)) <= limit + 1e-6, "Tail exceeded configured amplitude")
	end
end
local showcase = motion()
assert(showcase:SampleTail("Caught", 0, 100) == 0)
for index = 0, 89 do
	local elapsed = 4 + index * 0.01
	local angle = showcase:SampleTail("Caught", elapsed, 100 + elapsed)
	local _, yaw = showcase:Sample("Caught", elapsed, 100 + elapsed)
	assert(math.abs(angle - yaw * tailSettings.ShowcaseYaw / motionSettings.Showcase.Yaw) < 1e-6)
end
assert(showcase:SampleTail("Caught", 1000, 1100) == 0 and showcase.nextBurst == 1104)
