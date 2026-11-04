local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local environment = setmetatable({
	script = { Parent = { FishingConfig = "config" } },
	require = function(name)
		assert(name == "config")
		return config
	end,
}, { __index = getfenv() })
local Motion = assert(load(read("src/ReplicatedStorage/Modules/FishSecondaryMotion.lua"), "Secondary", "t", environment))()
local settings = config.Bite.Motion.Secondary
local function near(a, b)
	assert(math.abs(a - b) < 1e-8, tostring(a) .. " ~= " .. tostring(b))
end
for _, phase in ipairs({ "Waiting", "Holding", "Nibbling", "Bite", "Lifting", "Reeling", "Reeled" }) do
	local x, y, z = Motion.Sample(phase, 0.3, 100, nil, 1)
	assert(x == 0 and y == 0 and z == 0, "Secondary motion leaked into " .. phase)
end
for _, sign in ipairs({ -1, 1 }) do
	local x, y, z = Motion.Sample("Struggling", 0.55, sign * 100, nil, sign)
	assert(x == 0 and y == 0)
	near(z, sign * math.rad(settings.Bank.MaxAngle))
	for index = 15, 285 do
		local pitch, yaw, roll = Motion.Sample("Struggling", index / 100, sign * 100, nil, sign)
		near(pitch, 0)
		near(yaw, 0)
		near(roll, sign * math.rad(settings.Bank.MaxAngle))
	end
end
for _, time in ipairs({ 0, 0.299, 0.3, 0.301, 0.35, 0.5, 0.599, 0.6, 0.601, 0.65, 0.8, 0.9, 1.8, 3, 30 }) do
	local x, y, z = Motion.Sample("Struggling", time, 0, nil, 1)
	near(x, 0); near(y, 0); near(z, 0)
end
local duration = config.Bite.Motion.Animation.Clips.ShowcaseFlop.Duration
local idleMax, burstMax = 0, 0
for index = 0, 100 do
	local at = 4 + duration * index / 100
	local idle = { Motion.Sample("Caught", at, 0) }
	local burst = { Motion.Sample("Caught", at, 0, { name = "ShowcaseFlop", position = at - 4 }) }
	for axis = 1, 3 do
		assert(math.abs(idle[axis]) <= math.rad(settings.Showcase.IdleAngles[axis]))
		assert(math.abs(burst[axis]) <= math.rad(settings.Showcase.BurstAngles[axis]))
		idleMax = math.max(idleMax, math.abs(idle[axis]))
		burstMax = math.max(burstMax, math.abs(burst[axis]))
		if index == 0 or index == 100 then near(idle[axis], burst[axis]) end
	end
end
assert(idleMax > math.rad(0.5) and burstMax > idleMax * 2, "Showcase accent did not strengthen idle sway")
-- 不同帧率和长帧访问顺序不改变同一个绝对时间点的结果。
for _, phase in ipairs({ "Struggling", "Caught" }) do
	local expected = { Motion.Sample(phase, 1.25, 2, nil, 1) }
	for _, rate in ipairs({ 15, 30, 60, 144 }) do
		for index = 0, math.floor(1.25 * rate) do Motion.Sample(phase, index / rate, 2, nil, 1) end
		local actual = { Motion.Sample(phase, 1.25, 2, nil, 1) }
		for axis = 1, 3 do near(actual[axis], expected[axis]) end
	end
end
