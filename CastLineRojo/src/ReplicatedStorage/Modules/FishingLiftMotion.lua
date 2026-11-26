-- 轨迹、镜头和音画事件共享绝对时间，不积累逐帧误差。
local Motion = {}

local function smooth(progress)
	local t = math.clamp(progress, 0, 1)
	return t * t * (3 - 2 * t)
end

function Motion.UprightRotation(forward, displayFacing)
	local up = if displayFacing == "Front" then -forward else forward:Cross(Vector3.yAxis)
	return CFrame.lookAt(Vector3.zero, Vector3.yAxis, up)
end

function Motion.RiseRotation(upright, progress, spinTurns)
	return upright * CFrame.Angles(0, 0, math.pi * 2 * spinTurns * smooth(progress))
end

function Motion.Timing(settings, isEgg)
	if isEgg then
		return {
			duration = settings.LiftTime,
			riseEnd = settings.LiftTime * settings.LiftRiseEnd,
			fallStart = settings.LiftTime * settings.LiftRiseEnd,
			landAt = settings.LiftTime * settings.LiftFallEnd,
			scaleTime = settings.LiftScaleTime,
		}
	end
	local fish = settings.FishLift
	return {
		duration = fish.RiseTime + fish.PeakHold + fish.FallTime + fish.SettleTime,
		riseEnd = fish.RiseTime,
		fallStart = fish.RiseTime + fish.PeakHold,
		landAt = fish.RiseTime + fish.PeakHold + fish.FallTime,
		scaleTime = fish.ScaleTime,
	}
end

function Motion.New(settings, elastic, initialHeight, showcaseHeight, diameter)
	local timing = Motion.Timing(settings, false)
	local peak = showcaseHeight + settings.FishLift.BaseRise + settings.FishLift.SizeRise * diameter
	local fraction = math.clamp(-initialHeight / (peak - initialHeight), 0, 1)
	return {
		timing = timing,
		initialHeight = initialHeight,
		showcaseHeight = showcaseHeight,
		peakHeight = peak,
		diameter = diameter,
		exitAt = timing.riseEnd * (1 - math.sqrt(1 - fraction)),
		bounceHeight = settings.LiftBounceHeight,
		lobeEnds = elastic.LobeEnds,
		lobeAmplitudes = elastic.LobeAmplitudes,
		eventWindow = settings.FishLift.EventWindow,
	}
end

local function rebound(plan, alpha)
	if alpha <= 0 or alpha >= 1 then
		return 0, 0
	end
	local previous = 0
	for index, finish in ipairs(plan.lobeEnds) do
		if alpha < finish then
			local u = (alpha - previous) / (finish - previous)
			local amplitude = plan.lobeAmplitudes[index]
			return amplitude * math.sin(math.pi * u) ^ 2,
				amplitude * math.pi * math.sin(2 * math.pi * u) / (finish - previous)
		end
		previous = finish
	end
	return 0, 0
end

function Motion.Sample(plan, elapsed)
	local timing = plan.timing
	local time = math.clamp(elapsed, 0, timing.duration)
	local height, velocity, rise, bounce = plan.peakHeight, 0, 1, 0
	local stage = "Peak"
	if time < timing.riseEnd then
		local u = time / timing.riseEnd
		rise = 1 - (1 - u) ^ 2
		height = plan.initialHeight + (plan.peakHeight - plan.initialHeight) * rise
		velocity = 2 * (plan.peakHeight - plan.initialHeight) * (1 - u) / timing.riseEnd
		stage = "Rise"
	elseif time >= timing.landAt then
		local duration = timing.duration - timing.landAt
		local rate
		bounce, rate = rebound(plan, (time - timing.landAt) / duration)
		height = plan.showcaseHeight + plan.bounceHeight * bounce
		velocity = plan.bounceHeight * rate / duration
		stage = if elapsed >= timing.duration then "Settled" else "Settle"
	elseif time >= timing.fallStart then
		local duration = timing.landAt - timing.fallStart
		local u = (time - timing.fallStart) / duration
		height = plan.peakHeight + (plan.showcaseHeight - plan.peakHeight) * u ^ 2
		velocity = 2 * (plan.showcaseHeight - plan.peakHeight) * u / duration
		stage = "Fall"
	end
	return { height = height, velocity = velocity, rise = rise, bounce = bounce, stage = stage }
end

-- 消费越过的边界；长帧只允许播放仍在短窗口内的反馈。
function Motion.Events(plan, previous, elapsed)
	local function crossed(at)
		return previous < at and elapsed >= at and elapsed - at <= plan.eventWindow
	end
	return crossed(plan.exitAt), crossed(plan.timing.landAt)
end

function Motion.NewObserver(settings, startY, goalY, distance, diameter, previousPeak)
	local rise = math.max(settings.DistanceRise * distance, settings.MinHeightGain + settings.SizeRise * diameter)
	local peakY = math.max(math.max(startY, goalY) + rise, previousPeak + settings.MinHeightGain)
	local fromStart, fromGoal = math.sqrt(peakY - startY), math.sqrt(peakY - goalY)
	local apex = fromStart / (fromStart + fromGoal)
	local ascentSpeed = apex / settings.RiseTime
	local descentSpeed = (1 - apex) / (settings.Duration - settings.RiseTime)
	return {
		settings = settings,
		startY = startY,
		goalY = goalY,
		controlY = peakY + fromStart * fromGoal,
		apex = apex,
		startSpeed = settings.StartSpeedScale * ascentSpeed,
		apexSpeed = math.min(ascentSpeed, descentSpeed),
	}
end

-- 两段时间映射在顶点共享同一个速度。贝塞尔参数持续增加，到手时速度归零。
local function remapTime(t, from, to, startTangent, endTangent)
	local blend = smooth(t)
	return from + (to - from) * blend + t * (1 - t) * ((1 - t) * startTangent - t * endTangent)
end

function Motion.SampleObserver(plan, elapsed)
	local settings = plan.settings
	local time = math.clamp(elapsed, 0, settings.Duration)
	local u
	if time < settings.RiseTime then
		local duration = settings.RiseTime
		u = remapTime(time / duration, 0, plan.apex, plan.startSpeed * duration, plan.apexSpeed * duration)
	else
		local duration = settings.Duration - settings.RiseTime
		u = remapTime((time - settings.RiseTime) / duration, plan.apex, 1, plan.apexSpeed * duration, 0)
	end
	-- 控制点位于出水点垂直上方，所以水平距离的系数是 u²。
	local height = (1 - u) ^ 2 * plan.startY + 2 * (1 - u) * u * plan.controlY + u ^ 2 * plan.goalY
	local turn = smooth((time - settings.RiseTime) / (settings.TurnEnd - settings.RiseTime))
	return height, u ^ 2, turn
end

return Motion
