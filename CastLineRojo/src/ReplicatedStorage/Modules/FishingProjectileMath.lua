local Config = require(script.Parent.FishingConfig)

local FishingProjectileMath = {}

function FishingProjectileMath.Distance(meterValue: number): number
	return Config.BaseDistance + math.floor(Config.MeterBonus * math.clamp(meterValue, 0, 1) + 0.5)
end

function FishingProjectileMath.FlightTime(distance: number): number
	return math.min(
		Config.BaseFlightTime * (math.max(distance, 1) / Config.BaseDistance) ^ Config.FlightTimeExponent,
		Config.MaxFlightTime
	)
end

function FishingProjectileMath.CreateArc(start: Vector3, target: Vector3, duration: number)
	local delta = target - start
	local distance = math.sqrt(delta.X * delta.X + delta.Z * delta.Z)
	local height = math.clamp(distance * Config.ApexHeightFactor, Config.ApexHeightMin, Config.ApexHeightMax)
	local time = math.max(duration, 0.05)
	local gravity = Vector3.new(0, -height * 8 / (time * time), 0)
	local velocity = (delta - gravity * 0.5 * time * time) / time
	return {
		Duration = time,
		PositionAt = function(_, elapsed: number): Vector3
			local t = math.clamp(elapsed, 0, time)
			return start + velocity * t + gravity * 0.5 * t * t
		end,
		VelocityAt = function(_, elapsed: number): Vector3
			return velocity + gravity * math.clamp(elapsed, 0, time)
		end,
	}
end

return FishingProjectileMath
