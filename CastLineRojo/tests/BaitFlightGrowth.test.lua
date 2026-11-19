local h = require("./helpers/ReelSpringHarness").new()
local env, config, vec = h.env, h.config, h.vec
local transform = {}
local orientation = { isRotation = true }
local function frame(position)
	return setmetatable({ Position = position, Rotation = orientation }, transform)
end
transform.__mul = function(a, b)
	return if b.isRotation then frame(a.Position) else frame(a.Position + b.Position)
end
env.CFrame = { new = frame, Angles = function()
	return orientation
end }
env.script.Parent = setmetatable({}, { __index = function(_, key)
	return key
end })
local function loadModule(name)
	local chunk = assert(loadstring(h.read("src/ReplicatedStorage/Modules/" .. name .. ".lua"), name), "Module did not compile")
	setfenv(chunk, env)
	return chunk()
end
local modules = { FishingConfig = config, FishingRigUtil = { ApplyReadyPose = function() end } }
env.require = function(name)
	return modules[name] or {}
end
local Motion = loadModule("BaitElasticMotion")
modules.BaitElasticMotion = Motion
modules.FishingProjectileMath = loadModule("FishingProjectileMath")
local Sequence = loadModule("FishingCastSequence")
local function near(a, b)
	assert(math.abs(a - b) < 1e-7, tostring(a) .. " ~= " .. tostring(b))
end
local function same(a, b)
	near(a.X, b.X)
	near(a.Y, b.Y)
	near(a.Z, b.Z)
end
local base, detailSize, offset, topOffset = vec(0.6, 1.4, 2), vec(0.2, 0.3, 0.4), vec(0.5, 0.7, -0.2), vec(0, 1, 0)
local function owner()
	local detail = {}
	return {
		bait = { Size = base, CFrame = frame(vec(0, 0, 0)) }, baitBaseSize = base,
		baitVisualScale = vec(1, 1, 1), baitParts = { [detail] = { size = detailSize, offset = frame(offset) } },
		baitTop = {}, baitTopOffset = topOffset, trailA = {}, trailB = {},
	}, detail
end
near(Motion.SampleFlightGrowth(-1), 1)
near(Motion.SampleFlightGrowth(0), 1)
near(Motion.SampleFlightGrowth(0.5), 1.25)
near(Motion.SampleFlightGrowth(1), 1.5)
near(Motion.SampleFlightGrowth(2), 1.5)

-- 真实飞行与落水入口：多帧率、近远距离均连续衔接到新的基础尺寸。
for _, distance in ipairs({ 30, 1000 }) do
	local duration = modules.FishingProjectileMath.FlightTime(distance)
	for _, rate in ipairs({ 30, 60, 144 }) do
		local state, detail = owner()
		setmetatable(state, Sequence)
		local target = vec(0, 0, distance)
		state.phase, state.flightStarted, state.flightDuration = "Flying", 10, duration
		state.distance, state.releasePosition = distance, vec(0, 20, 0)
		state.flightFromScale = vec(1, 1, 1)
		state.wind, state.trail, state.track = {}, {}, { Stop = function() end }
		state.cameraFrame, state.bitePrompt, state.continueLabel = frame(vec(0, 10, 0)), {}, {}
		state._waterTarget = function()
			return target
		end
		state._setPhase = function(self, phase)
			self.phase = phase
		end
		state._shot, state._impulse, state._sound = function() end, function() end, function() end
		state._playWaterVFX, state._ripple = function() end, function() end
		state.options = { requestRound = true }
		state._requestBiteRound = function(self)
			same(Motion.BaseSize(self), base * 1.5)
			near(self.bitePrompt.StudsOffsetWorldSpace.Y, base.Y * 0.75 + config.Bite.Prompt.HeightOffset)
		end
		local previous = 1
		for index = 0, math.ceil(duration * rate) do
			local elapsed = math.min(duration, index / rate)
			local growth = Motion.SampleFlightGrowth(elapsed / duration)
			assert(growth >= previous and growth <= 1.5, "Growth must be monotonic and bounded")
			previous = growth
			state:_updateBait(10 + elapsed, 1 / rate)
			if state.phase == "Flying" then
				local _, elastic = Motion.Sample("Flying", elapsed, duration)
				local alpha = math.clamp(elapsed / config.BaitElastic.BlendTime, 0, 1)
				alpha = alpha * alpha * (3 - 2 * alpha)
				local scale = vec(1, 1, 1):Lerp(elastic, alpha) * growth
				same(state.bait.Size, base * scale)
				same(detail.Size, detailSize * scale)
				same(detail.CFrame.Position - state.bait.CFrame.Position, offset * scale)
				same(state.baitTop.Position, topOffset * scale)
			end
		end
		-- 浮点时钟可能略早于终点；长帧也必须准确落水。
		if state.phase == "Flying" then
			state:_updateBait(11 + duration, 1 / rate)
		end
		assert(state.phase == "Waiting" and state.baitGrowthCommitted, "Landing did not commit the enlarged size")
		same(state.bait.Size, base * 1.5)
		same(detail.Size, detailSize * 1.5)
		same(state.baitTop.Position, topOffset * 1.5)
		for _ = 1, 100 do
			Motion.CommitFlightGrowth(state)
			Motion.Apply(state, state.bait.CFrame, vec(1, 1, 1))
		end
		same(Motion.BaseSize(state), base * 1.5)
		same(detail.CFrame.Position - state.bait.CFrame.Position, offset * 1.5)
		for _, phase in ipairs({ "Settling", "Waiting", "Holding", "Approaching", "Nibbling", "Bite", "Struggling", "Escaped", "Reeling" }) do
			local _, scale = Motion.Sample(phase, 0.1, 1)
			Motion.Apply(state, state.bait.CFrame, scale)
			same(state.bait.Size, base * 1.5 * scale)
		end
		local nextCast = owner()
		Motion.Apply(nextCast, frame(vec(0, 0, 0)), vec(1, 1, 1))
		same(nextCast.bait.Size, base)
		same(base, vec(0.6, 1.4, 2))
	end
end

-- 单部件付费鱼饵没有附件或子部件，仍可提交尺寸且不重复放大。
do
	local single = { bait = { Size = base, CFrame = frame(vec(0, 0, 0)) } }
	Motion.Apply(single, single.bait.CFrame, vec(1.5, 1.5, 1.5))
	Motion.CommitFlightGrowth(single)
	Motion.CommitFlightGrowth(single)
	same(single.bait.Size, base * 1.5)
	same(single.baitVisualScale, vec(1, 1, 1))
end
