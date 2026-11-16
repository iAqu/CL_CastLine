--# selene: allow(undefined_variable)
local Motion = dofile("src/ReplicatedStorage/Modules/FishingLiftMotion.lua")
local Config = dofile("src/ReplicatedStorage/Modules/FishingConfig.lua")
local function near(a, b, label)
	assert(math.abs(a - b) < 1e-6, label or "Values differ")
end
local plan = Motion.New(Config.Bite, Config.BaitElastic, -4, 5, 8)
local timing = plan.timing
near(timing.duration, 1.55)
near(timing.riseEnd, 0.4)
near(timing.fallStart, 0.48)
near(timing.landAt, 1.28)
local egg = Motion.Timing(Config.Bite, true)
near(egg.duration, 2)
near(egg.riseEnd, 0.7)
near(egg.landAt, 1.44)
near(Motion.Sample(plan, 0).height, -4)
near(Motion.Sample(plan, plan.exitAt).height, 0, "Exit event is not at the water crossing")
assert(Motion.Sample(plan, 0).velocity > 200, "Lift must launch immediately")
assert(Motion.Sample(plan, 0.1).velocity > Motion.Sample(plan, 0.3).velocity, "Rise must decelerate")
assert(Motion.Sample(plan, 0.6).velocity > Motion.Sample(plan, 1.2).velocity, "Fall must accelerate downward")
near(Motion.Sample(plan, 0.4).height, 49)
near(Motion.Sample(plan, 0.45).velocity, 0)
near(Motion.Sample(plan, 1.55).height, 5)
near(Motion.Sample(plan, 10).velocity, 0)
for _, boundary in ipairs({ timing.riseEnd, timing.fallStart, timing.landAt, timing.duration }) do
	assert(
		math.abs(Motion.Sample(plan, boundary - 1e-8).height - Motion.Sample(plan, boundary + 1e-8).height) < 1e-4,
		"Stage boundary teleported"
	)
end
local previousRise = 0
for _, shape in ipairs({ { 2, 5, -1 }, { 8, 5, -4 }, { 20, 14, -10 }, { 60, 40, -30 } }) do
	local sized = Motion.New(Config.Bite, Config.BaitElastic, shape[3], shape[2], shape[1])
	assert(sized.peakHeight - sized.initialHeight > previousRise, "Larger fish must rise farther")
	near(sized.peakHeight - sized.showcaseHeight, 32 + 1.5 * shape[1])
	previousRise = sized.peakHeight - sized.initialHeight
end
for _, fps in ipairs({ 30, 60, 144 }) do
	local previous, exits, lands = -1, 0, 0
	for frame = 0, math.ceil(timing.duration * fps) + 1 do
		local now = frame / fps
		local exit, land = Motion.Events(plan, previous, now)
		exits += if exit then 1 else 0
		lands += if land then 1 else 0
		local direct = Motion.Sample(plan, now)
		local repeated = Motion.Sample(plan, now)
		near(direct.height, repeated.height, "Sampling depends on history")
		near(direct.velocity, repeated.velocity)
		local duplicateExit, duplicateLand = Motion.Events(plan, now, now)
		assert(not duplicateExit and not duplicateLand, "Repeated frame duplicated feedback")
		previous = now
	end
	assert(exits == 1 and lands == 1, "Normal frame rates lost or repeated feedback")
end
local exit, land = Motion.Events(plan, -1, timing.duration + 1)
assert(not exit and not land, "Long frame replayed expired feedback")
exit, land = Motion.Events(plan, 0, timing.landAt + 0.02)
assert(not exit and land, "A current landing replayed an old water exit")
for step = 1, 100 do
	local t = timing.riseEnd * step / 101
	local derivative = (Motion.Sample(plan, t + 1e-6).height - Motion.Sample(plan, t - 1e-6).height) / 2e-6
	near(derivative, Motion.Sample(plan, t).velocity, "Sample velocity disagrees with position")
end
