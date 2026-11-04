local Harness = require("./helpers/ReelSpringHarness")
local function near(a, b, tolerance)
	assert(math.abs(a - b) <= (tolerance or 1e-5), tostring(a) .. " ~= " .. tostring(b))
end

for _, rate in ipairs({ 15, 30, 60, 144 }) do
	local h = Harness.new()
	local settings = h.config.Reel
	local motion = h.Reel.new(h.vec(0, -0.08, 0), 1.4, 0)
	local now, peak, finishedAt = 0, -math.huge, nil
	while now < 3 do
		local _, settled = motion:Update(now)
		if settled and not finishedAt then
			finishedAt = now
		end
		peak = math.max(peak, motion.position.Y)
		local dt = math.min(1 / rate, 3 - now)
		if now < settings.SinkTime then
			dt = math.min(dt, settings.SinkTime - now)
		end
		h.step(dt)
		now += dt
	end
	assert(finishedAt and finishedAt > 1 and finishedAt < 1.8, "Spring did not settle naturally")
	near(peak - h.config.Bite.ShowcaseHeight, 1.2, 0.12)
	near(motion.position.Y, h.config.Bite.ShowcaseHeight, 0.001)
	near(motion.position.X, 0)
	near(motion.position.Z, 0)
	local proxy = h.instances[1]
	motion:Destroy()
	motion:Destroy()
	h.step(2)
	assert(proxy.destroyed and proxy.writesAfterDestroy == 0, "Destroyed spring still writes its proxy")
end

-- The real analytic spr solver must reach the same positions at common times.
local reference
for _, rate in ipairs({ 15, 30, 60, 144 }) do
	local h = Harness.new()
	local motion = h.Reel.new(h.vec(0, -0.08, 0), 1.4, 0)
	local now, samples = 0, {}
	for _, at in ipairs({ h.config.Reel.SinkTime, 0.25, 0.4, 0.6, 1 }) do
		while now < at do
			motion:Update(now)
			local dt = math.min(1 / rate, at - now)
			h.step(dt)
			now += dt
		end
		local position = motion:Update(at)
		table.insert(samples, position.Y)
	end
	if reference then
		for index, value in ipairs(samples) do near(value, reference[index]) end
	else
		reference = samples
	end
	motion:Destroy()
end

-- Retargeting must preserve the running spring, including its downward velocity.
do
	local h = Harness.new()
	local motion = h.Reel.new(h.vec(0, 0, 0), 1.4, 0)
	local epsilon = 1e-6
	h.step(h.config.Reel.SinkTime - epsilon)
	local before = h.instances[1].Value.Y
	h.step(epsilon)
	local at = h.instances[1].Value.Y
	motion:Update(h.config.Reel.SinkTime)
	near(h.instances[1].Value.Y, at)
	h.step(epsilon)
	local after = h.instances[1].Value.Y
	assert(math.abs((after - at) / epsilon - (at - before) / epsilon) < 0.01, "Retargeting jumped velocity")
	motion:Destroy()
end

-- A long frame must not claim completion from one sample or reset the proxy.
do
	local h = Harness.new()
	local motion = h.Reel.new(h.vec(0, -0.08, 0), 1.4, 0)
	h.step(5)
	assert(not select(2, motion:Update(5)))
	local at = h.instances[1].Value
	assert(not select(2, motion:Update(5)))
	assert(h.instances[1].Value == at)
	motion:Destroy()
	h.step(5)
	assert(h.instances[1].writesAfterDestroy == 0)
end
