local vectorMetatable = {}
local function vec(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, vectorMetatable)
end
vectorMetatable.__add = function(a, b)
	return vec(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
vectorMetatable.__sub = function(a, b)
	return vec(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
vectorMetatable.__mul = function(a, b)
	return vec(a.X * b, a.Y * b, a.Z * b)
end
vectorMetatable.__div = function(a, b)
	return vec(a.X / b, a.Y / b, a.Z / b)
end

local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local environment = setmetatable({
	script = { Parent = { FishingConfig = "config" } },
	require = function()
		return config
	end,
	Vector3 = { new = vec },
}, { __index = getfenv() })
local mathUtil = assert(
	load(read("src/ReplicatedStorage/Modules/FishingProjectileMath.lua"), "FishingProjectileMath", "t", environment)
)()
local function near(a, b)
	assert(math.abs(a - b) < 0.00001, string.format("Expected %.8f, got %.8f", b, a))
end
local function same(a, b)
	near(a.X, b.X)
	near(a.Y, b.Y)
	near(a.Z, b.Z)
end

assert(mathUtil.Distance(0) == 55 and mathUtil.Distance(1) == 75)
assert(mathUtil.Distance(0.5) == 65 and mathUtil.Distance(0.025) == 56)
assert(mathUtil.Distance(-1) == 55 and mathUtil.Distance(2) == 75)
near(mathUtil.FlightTime(55), 1.6)
assert(mathUtil.FlightTime(75) > 1.6 and mathUtil.FlightTime(75) < 2)
near(mathUtil.FlightTime(100000), 6)
assert(mathUtil.FlightTime(0) > 0)

local start, target = vec(0, 0, 0), vec(0, 0, 55)
local arc = mathUtil.CreateArc(start, target, 1.6)
same(arc:PositionAt(0), start)
same(arc:PositionAt(1.6), target)
same(arc:PositionAt(-10), start)
same(arc:PositionAt(100), target)
same(arc:PositionAt(0.8), vec(0, 13.75, 27.5))
near(arc:VelocityAt(0.8).Y, 0)

-- 不同起止高度、侧向飞行，以及飞行途中重采样终点高度。
start, target = vec(10, 100, 25), vec(85, 65, 25)
arc = mathUtil.CreateArc(start, target, 1.9)
same(arc:PositionAt(0), start)
same(arc:PositionAt(1.9), target)
same(arc:PositionAt(0.95), vec(47.5, 101.25, 25))
local changed = mathUtil.CreateArc(start, vec(85, 70, 25), 1.9)
same(changed:PositionAt(0), start)
same(changed:PositionAt(1.9), vec(85, 70, 25))
local short = mathUtil.CreateArc(vec(0, 0, 0), vec(0, 0, 2), 0)
near(short.Duration, 0.05)
near(short:PositionAt(0.025).Y, 12)
