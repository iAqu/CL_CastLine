local Harness = require("./helpers/ReelSpringHarness")

-- 此处验证平移和保留朝向；真实旋转、取景、鱼线在 Studio 中验证。
local transform = {}
local function rotation(yaw)
	return { isRotation = true, Yaw = yaw }
end
local function frame(position, orientation)
	return setmetatable({ Position = position, Rotation = orientation or rotation(0) }, transform)
end
transform.__mul = function(a, b)
	if b.isRotation then
		return frame(a.Position, b)
	end
	return frame(a.Position + b.Position, b.Rotation)
end

local function near(a, b)
	assert(math.abs(a - b) < 1e-5, tostring(a) .. " ~= " .. tostring(b))
end

for _, rate in ipairs({ 15, 30, 60, 144 }) do
	for _, time in ipairs({ 10, 12.1, 13.3, 14.3, 1000 }) do
		local h = Harness.new()
		local env, config, vec = h.env, h.config, h.vec
		local baseRequire = env.require
		env.script.Parent.BaitElasticMotion = "elastic"
		env.script.Parent.FishingReelSpring = "reel"
		local elastic =
			assert(load(h.read("src/ReplicatedStorage/Modules/BaitElasticMotion.lua"), "Elastic", "t", env))()
		env.require = function(name)
			if name == "config" then
				return config
			end
			if name == "elastic" then
				return elastic
			end
			if name == "reel" then
				return h.Reel
			end
			if name == "spr" then
				return baseRequire(name)
			end
			return {}
		end
		env.CFrame = { new = frame, identity = frame(vec(0, 0, 0)) }
		local Bite = assert(load(h.read("src/ReplicatedStorage/Modules/FishingBiteSequence.lua"), "Bite", "t", env))()
		local random = {
			NextInteger = function()
				return 3
			end,
			NextNumber = function(_, a, b)
				return (a + b) * 0.5
			end,
		}
		local timeline = Bite.NewTimeline(10, random)
		local target = vec(100, 700, 200)
		local baitFrame = frame(target + vec(0, -0.08, 0), rotation(math.rad(137)))
		local shots, splashes = 0, 0
		local owner = {
			bait = { CFrame = baitFrame, Size = vec(0.6, 1.4, 2) },
			impulses = { {} },
			_waterTarget = function()
				return target
			end,
			_shot = function(_, mode, seconds, at)
				assert(mode == "Reel" and seconds == config.Reel.CameraTime and at == time)
				shots += 1
			end,
			_setPhase = function(self, phase)
				self.phase = phase
			end,
			_presentBait = function() end,
			_waterFeedback = function(_, _, _, strength, splash)
				assert(strength == 0.35 and splash)
				splashes += 1
			end,
		}
		local sequence = setmetatable({ timeline = timeline, owner = owner }, Bite)
		assert(not sequence:TryHook(time) and timeline.phase == "Reeling")
		local motion = sequence.reelMotion
		assert(not sequence:CanReturn(time))
		near(sequence:_reelFrame(target).Position.Y, baitFrame.Position.Y)
		local now, completed = time, nil
		while now < time + 4 do
			local _, settled = motion:Update(now)
			assert(not sequence:TryHook(now) and sequence.reelMotion == motion, "Repeated taps restarted the spring")
			local pose = sequence:_reelFrame(target)
			assert(pose.Rotation == baitFrame.Rotation, "Reeling changed bait orientation")
			near(pose.Position.X, target.X)
			near(pose.Position.Z, target.Z)
			local movedWater = sequence:_reelFrame(target + vec(0, 2, 0))
			near(movedWater.Position.Y - pose.Position.Y, 2)
			if settled then
				timeline:FinishReel(now)
				completed = now
				break
			end
			assert(not sequence:CanReturn(now), "Return enabled before physical settling")
			local dt = 1 / rate
			if now < time + config.Reel.SinkTime then
				dt = math.min(dt, time + config.Reel.SinkTime - now)
			end
			h.step(dt)
			now += dt
		end
		assert(completed and timeline.phase == "Reeled", "Spring never entered showcase")
		assert(not sequence:CanReturn(completed + config.Reel.HoldTime - 0.001))
		assert(sequence:CanReturn(completed + config.Reel.HoldTime))
		timeline:FinishReel(completed + 100)
		assert(timeline.startedAt == completed, "Repeated completion restarted the hold")
		assert(not sequence:CanRetry(completed + 100))
		assert(shots == 1 and splashes == 1 and #owner.impulses == 0)
		motion:Destroy()
		h.step(5)
		assert(h.instances[1].writesAfterDestroy == 0)
	end
end
