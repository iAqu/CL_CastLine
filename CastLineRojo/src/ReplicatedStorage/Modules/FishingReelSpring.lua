local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.FishingConfig)
local spr = require(ReplicatedStorage.Libs.spr)

local FishingReelSpring = {}
FishingReelSpring.__index = FishingReelSpring

function FishingReelSpring.new(initialOffset, baitHeight, startedAt)
	local settings, spring = Config.Reel, Config.Reel.Spring
	local proxy = Instance.new("Vector3Value")
	proxy.Name, proxy.Value = "ReelOffset", initialOffset
	local goal = Vector3.yAxis * Config.Bite.ShowcaseHeight
	local sinkDepth = baitHeight * settings.SinkDepth
	local overshoot = math.exp(-math.pi * spring.LiftDamping / math.sqrt(1 - spring.LiftDamping ^ 2))
	local self = setmetatable({
		proxy = proxy,
		position = initialOffset,
		velocity = Vector3.zero,
		goal = goal,
		switchAt = startedAt + settings.SinkTime,
		lastAt = startedAt,
		settled = false,
		reboundAllowance = math.max(
			settings.ReboundPadding,
			((goal - initialOffset).Magnitude + sinkDepth) * overshoot + 0.25
		),
	}, FishingReelSpring)
	spr.target(proxy, spring.SinkDamping, spring.SinkFrequency, { Value = initialOffset - Vector3.yAxis * sinkDepth })
	return self
end

function FishingReelSpring:Update(now)
	assert(not self.destroyed, "Reel spring is destroyed")
	local settings = Config.Reel.Spring
	if not self.lifting and now >= self.switchAt then
		-- 同一代理改目标，保留 spr 内部的当前位置和速度。
		spr.target(self.proxy, settings.LiftDamping, settings.LiftFrequency, { Value = self.goal })
		self.lifting = true
	end
	local position = self.proxy.Value
	local dt = now - self.lastAt
	if dt > 0 then
		self.velocity = (position - self.position) / dt
		self.lastAt = now
		if self.lifting and not self.settled then
			if
				(position - self.goal).Magnitude <= settings.PositionTolerance
				and self.velocity.Magnitude <= settings.VelocityTolerance
			then
				self.stableAt = self.stableAt or now
				self.settled = now - self.stableAt >= settings.SettleTime
			else
				self.stableAt = nil
			end
		end
	end
	self.position = position
	return position, self.settled
end

function FishingReelSpring:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	spr.stop(self.proxy)
	self.proxy:Destroy()
end

return FishingReelSpring
