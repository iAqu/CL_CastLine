-- 纯标量采样：轨迹、镜头和音画事件共享绝对时间，不积累逐帧误差。
local Motion = {}

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

return Motion
