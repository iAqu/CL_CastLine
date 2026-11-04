local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local vector = {}
local function vec(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, vector)
end
vector.__mul = function(a, b)
	return vec(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
vector.__sub = function(a, b)
	return vec(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
vector.__add = function(a, b)
	return vec(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
vector.__index = {
	Lerp = function(a, b, alpha)
		return vec(a.X + (b.X - a.X) * alpha, a.Y + (b.Y - a.Y) * alpha, a.Z + (b.Z - a.Z) * alpha)
	end,
}
local environment = setmetatable({
	script = { Parent = { FishingConfig = "config" } },
	require = function(name)
		assert(name == "config")
		return config
	end,
	Vector3 = { new = vec },
}, { __index = getfenv() })
local Motion = assert(load(read("src/ReplicatedStorage/Modules/BaitElasticMotion.lua"), "Elastic", "t", environment))()
local function near(a, b)
	assert(math.abs(a - b) < 1e-8, tostring(a) .. " ~= " .. tostring(b))
end

-- 一次主回弹和两次幅度递减、方向交替的余弹，完整结束后不再运动。
near(Motion.Rebound(0), 0)
near(Motion.Rebound(0.25), 1)
near(Motion.Rebound(0.65), -0.4)
near(Motion.Rebound(0.9), 0.16)
near(Motion.Rebound(1), 0)
near(Motion.Rebound(100), 0)
for _, boundary in ipairs({ 0, 0.5, 0.8, 1 }) do
	local before, after = Motion.Rebound(boundary - 1e-8), Motion.Rebound(boundary + 1e-8)
	near(before, after)
end

local durations = {
	Preparing = 2,
	Casting = config.CastLeadTime + config.ReleaseTime,
	Flying = 2,
	Settling = config.Landing.SinkTime + config.Landing.ReboundTime + config.Landing.SettleTime,
	Waiting = 2,
	Holding = 1,
	Approaching = config.Bite.ApproachTime,
	Nibbling = config.Bite.NibbleTime,
	Bite = config.Bite.HookWindow,
	Struggling = config.Bite.StruggleTime,
	Escaped = config.Bite.EscapeTime,
	Reeling = config.Reel.SinkTime + config.BaitElastic.ReelRiseTime + config.BaitElastic.ReelBounceTime,
}

-- 所有阶段的变形保持体积，任意采样顺序和帧率得到同一个结果。
for phase, duration in pairs(durations) do
	local expectedOffset, expectedScale = Motion.Sample(phase, duration * 0.37, duration)
	for _, rate in ipairs({ 30, 60, 144 }) do
		for frame = 0, math.ceil(duration * rate) do
			local elapsed = math.min(duration, frame / rate)
			local offset, scale = Motion.Sample(phase, elapsed, duration)
			assert(offset == offset and scale.Y == scale.Y, "Invalid sample in " .. phase)
			assert(scale.Y >= 0.65 and scale.Y <= 1.4, "Stretch outside the agreed range")
			near(scale.X * scale.Y * scale.Z, 1)
		end
		local offset, scale = Motion.Sample(phase, duration * 0.37, duration)
		near(offset, expectedOffset)
		near(scale.Y, expectedScale.Y)
	end
	local offset, scale = Motion.Sample(phase, duration, duration)
	if phase ~= "Preparing" then
		near(offset, 0)
		near(scale.Y, 1)
	end
end

-- 假咬恢复后向上弹过水面；真咬全程保持下沉信号并收稳在原有深度。
local nibble = config.Bite.Nibble
for _, speed in ipairs({ nibble.SpeedMin, 1, nibble.SpeedMax }) do
	for index = 0, 100 do
		local canonical = config.Bite.NibbleTime * index / 100
		local expectedOffset, expectedScale = Motion.Sample("Nibbling", canonical)
		local offset, scale = Motion.Sample("Nibbling", canonical / speed, nil, speed)
		near(offset, expectedOffset)
		near(scale.X, expectedScale.X)
		near(scale.Y, expectedScale.Y)
		near(scale.Z, expectedScale.Z)
	end
	-- 变速只影响假咬，真咬的信号和窗口保持原样。
	local expectedOffset, expectedScale = Motion.Sample("Bite", 0.2)
	local offset, scale = Motion.Sample("Bite", 0.2, nil, speed)
	near(offset, expectedOffset)
	near(scale.Y, expectedScale.Y)
end
local bounceAt = nibble.AttackTime + nibble.ContactTime + nibble.ReboundTime
local offset, scale = Motion.Sample("Nibbling", bounceAt + (config.Bite.NibbleTime - bounceAt) * 0.25)
near(offset, 0.15)
near(scale.Y, 1.4)
local sinkTime = config.Bite.BiteSinkTime
offset, scale = Motion.Sample("Bite", sinkTime)
near(offset - config.Bite.BiteDepthFraction, -0.85)
near(scale.Y, 0.65)
for index = 0, 100 do
	local elapsed = config.Bite.HookWindow * index / 100
	local extra = Motion.Sample("Bite", elapsed)
	local alpha = math.clamp(elapsed / sinkTime, 0, 1)
	local position = -config.Bite.BiteDepthFraction * alpha * alpha * (3 - 2 * alpha) + extra
	assert(position <= 0, "True bite popped out of the water")
end
near(Motion.Sample("Bite", config.Bite.HookWindow) - config.Bite.BiteDepthFraction, -0.65)

-- 重复呈现、尺寸恢复均从原尺寸计算，不会累乘或污染后续逻辑尺寸。
local original = vec(0.6, 1.4, 2)
local owner = { bait = { Size = original } }
local pose = {}
local stretch = Motion.Scale(0.65)
for _ = 1, 100 do
	Motion.Apply(owner, pose, stretch)
	assert(Motion.BaseSize(owner) == original and owner.bait.CFrame == pose)
	near(owner.bait.Size.Y, 1.4 * 0.65)
end
Motion.Apply(owner, pose, Motion.Scale(1))
near(owner.bait.Size.Y, original.Y)
near(owner.bait.Size.X, original.X)
