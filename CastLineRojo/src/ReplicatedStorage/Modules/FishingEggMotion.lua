local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite
local Egg = Config.EggMotion
local Motion = {}

function Motion.Animator()
	return {
		Update = function()
			return nil
		end,
		Destroy = function() end,
	}
end

local function strugglePose(self, elapsed, target, yaw)
	local position = target
		+ Vector3.new(math.sin(elapsed * 8), -self.depth, math.sin(elapsed * 6))
			* Vector3.new(Egg.StruggleRadius, 1, Egg.StruggleRadius)
	local rock = math.sin(elapsed * 5) * math.rad(Egg.RockDegrees)
	return position, CFrame.Angles(0, yaw + math.sin(elapsed * 7) * 0.2, rock)
end

function Motion.Pose(self, phase, elapsed, target)
	self.showcasePosition = nil
	local duration = self.timeline.endsAt - self.timeline.startedAt
	local alpha = math.clamp(elapsed / math.max(duration, 0.001), 0, 1)
	local rock = math.sin(elapsed * 5) * math.rad(Egg.RockDegrees)
	local rest = target + self.spawnDirection * (self.halfLength + 1) - Vector3.yAxis * self.depth
	local position, baitPosition, fade = rest, target, 0
	local yaw = math.atan2(self.spawnDirection.X, self.spawnDirection.Z)
	local rotation = CFrame.Angles(0, yaw, rock)
	if phase == "Approaching" then
		position = (rest + self.spawnDirection * Settings.ApproachDistance - Vector3.yAxis * 2):Lerp(
			rest,
			alpha * alpha * (3 - 2 * alpha)
		)
		fade = 1 - math.clamp(elapsed / Settings.AppearTime, 0, 1)
	elseif phase == "Nibbling" or phase == "Bite" then
		local contact = target - rotation:VectorToWorldSpace(self.mouthOffset * self.scale)
		local progress = if phase == "Bite"
			then math.clamp(elapsed / Settings.BiteSinkTime, 0, 1)
			else math.sin(math.pi * alpha)
		baitPosition = target - Vector3.yAxis * self.biteDepth * progress
		position = rest:Lerp(contact, progress) - Vector3.yAxis * self.biteDepth * progress
	elseif phase == "Struggling" then
		position, rotation = strugglePose(self, elapsed, target, yaw)
		baitPosition = position + rotation:VectorToWorldSpace(self.mouthOffset * self.scale)
	elseif phase == "Lifting" or phase == "Caught" then
		local lift = if phase == "Caught" then 1 else alpha
		local height = self:GetShowcaseHeight()
		position = target
			+ Vector3.yAxis
				* (-self.depth + (height + self.depth) * lift + math.sin(math.pi * lift) * Settings.LiftBounceHeight)
		rotation = CFrame.Angles(0, yaw + 2 * math.pi * lift, rock * (1 - lift))
		local struggleElapsed = self.timeline.liftStruggleElapsed
		if phase == "Lifting" and struggleElapsed and struggleElapsed > self.timeline.struggleTime then
			local initialPosition, initialRotation = strugglePose(self, struggleElapsed, target, yaw)
			position += (initialPosition - target + Vector3.yAxis * self.depth) * (1 - lift)
			rotation = initialRotation:Lerp(rotation, math.min(1, lift * 5))
		end
		self.showcasePosition = position
		baitPosition = position + rotation:VectorToWorldSpace(self.mouthOffset * self.scale)
	elseif phase == "Escaped" then
		local escape = math.clamp(elapsed / Settings.EscapeTime, 0, 1)
		position = target + (self.escapeOffset or rest - target) - Vector3.yAxis * Egg.SinkDistance * escape
		if self.escapeFrame then
			rotation = self.escapeFrame.Rotation:Lerp(rotation, math.min(1, escape * 5))
		end
		fade = escape
	elseif phase == "Reeling" or phase == "Reeled" then
		local fish = self.reelFish
		if fish then
			local escape = math.clamp((fish.elapsed or 0) / Settings.EscapeTime, 0, 1)
			position = target + fish.frame.Position - Vector3.yAxis * Egg.SinkDistance * escape
			fade = fish.fade + (1 - fish.fade) * escape
		else
			fade = 1
		end
		baitPosition = target + self.reelMotion.position
	else
		position += Vector3.yAxis * math.sin(elapsed * 3) * Egg.BobHeight
	end
	return CFrame.new(position) * rotation, baitPosition, fade, self.baitRotation
end

return Motion
