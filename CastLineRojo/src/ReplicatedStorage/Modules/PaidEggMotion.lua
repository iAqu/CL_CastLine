local Motion = {}

Motion.RevealAt = 2.2
Motion.SqueezeAt = 1.87
Motion.ExpansionAt = 2.07
Motion.EggPeakAt = 2.17
Motion.FishPeakAt = 0.16
Motion.FishDipAt = 0.30
Motion.FishSettledAt = 0.42
Motion.TurnDuration = 5

local function progress(time, first, last)
	return math.clamp((time - first) / (last - first), 0, 1)
end

local function smoothstep(t)
	return t * t * (3 - 2 * t)
end

function Motion.GetBurstScale(time)
	if time < Motion.ExpansionAt then
		return 1 - 0.15 * smoothstep(progress(time, Motion.SqueezeAt, Motion.ExpansionAt))
	end
	local t = progress(time, Motion.ExpansionAt, Motion.EggPeakAt)
	return 0.85 + 0.50 * (1 - (1 - t) ^ 3)
end

function Motion.GetFishScale(time)
	if time < Motion.FishPeakAt then
		local t = progress(time, 0, Motion.FishPeakAt)
		return 0.30 + 0.86 * (1 - (1 - t) ^ 3)
	end
	if time < Motion.FishDipAt then
		return 1.16 - 0.22 * smoothstep(progress(time, Motion.FishPeakAt, Motion.FishDipAt))
	end
	return 0.94 + 0.06 * smoothstep(progress(time, Motion.FishDipAt, Motion.FishSettledAt))
end

return Motion
