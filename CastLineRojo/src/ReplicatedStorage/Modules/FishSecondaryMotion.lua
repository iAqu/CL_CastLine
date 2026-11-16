local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite
local Motion = Settings.Motion.Secondary
local FishSecondaryMotion = {}

local function smooth(alpha)
	alpha = math.clamp(alpha, 0, 1)
	return alpha * alpha * (3 - 2 * alpha)
end

-- 绝对时间采样整鱼角度；不修改 Animator 驱动的骨骼。
function FishSecondaryMotion.Sample(phase, elapsed, turnRate, request, _mirror, struggleTime, approachTime)
	local pitch, yaw, roll = 0, 0, 0
	if phase == "Approaching" or phase == "Struggling" or phase == "Escaped" then
		local duration = if phase == "Approaching"
			then approachTime or Settings.ApproachTime
			elseif phase == "Struggling" then struggleTime or Settings.StruggleTime
			else Settings.EscapeTime
		local fade = smooth(elapsed / Motion.FadeTime) * smooth((duration - elapsed) / Motion.FadeTime)
		roll = Motion.Bank.MaxAngle * math.clamp(turnRate / math.rad(Motion.Bank.FullTurnRate), -1, 1)
		return math.rad(pitch * fade), 0, math.rad(roll * fade)
	elseif phase == "Caught" then
		local showcase = Motion.Showcase
		local envelope, progress = 0, 0
		if request and request.name == "ShowcaseFlop" then
			progress = request.position / Settings.Motion.Animation.Clips.ShowcaseFlop.Duration
			if progress >= 0 and progress <= 1 then
				envelope = math.sin(math.pi * progress) ^ 2
			end
		end
		local angles = {}
		for axis = 1, 3 do
			local idle = showcase.IdleAngles[axis] * math.sin(elapsed * math.pi * 2 * showcase.Frequency[axis])
			local burst = showcase.BurstAngles[axis] * math.sin(progress * math.pi * 4)
			angles[axis] = math.rad((idle * (1 - envelope) + burst * envelope) * smooth(elapsed / Motion.FadeTime))
		end
		return angles[1], angles[2], angles[3]
	end
	return pitch, yaw, roll
end

return FishSecondaryMotion
