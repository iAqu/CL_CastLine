local Path = require("../src/ReplicatedStorage/Modules/FishRepositionPath")
local function angleError(a, b)
	return math.abs(math.atan2(math.sin(a - b), math.cos(a - b)))
end

-- 原路径在这些段交接处的转向速度会瞬间跳变；平滑后左右极限必须一致。
do
	local path = Path.new({ x = 0, z = 0, heading = 0 }, { x = 8, z = 4, heading = math.pi / 2 }, 1.5, 7.5, 0.15, 0.3)
	local joins = path.joins or { path.segments[1] * path.radius, (path.segments[1] + path.segments[2]) * path.radius }
	assert(#joins > 0, "Fixture has no curvature joins")
	for _, distance in ipairs(joins) do
		local _, _, _, before = path:Sample(distance - path.speed * 0.00001)
		local _, _, _, after = path:Sample(distance + path.speed * 0.00001)
		assert(math.deg(math.abs(after - before) * path.speed) <= 1, "Turn rate jumped at a path join")
	end
end
local seed = 43
local function random(low, high)
	seed = seed * 48271 % 2147483647
	return low + (high - low) * seed / 2147483647
end
local families = {}
local merged, retried, oppositeCurvature = false, false, false
for index = 1, 1200 do
	local first = { x = random(-10, 10), z = random(-10, 10), heading = random(-math.pi, math.pi) }
	local last = { x = random(-10, 10), z = random(-10, 10), heading = random(-math.pi, math.pi) }
	if index == 1 then
		last = first
	end
	local radius = random(0.5, 5)
	local path = Path.new(first, last, radius, 7.5, 0.15, 0.3)
	merged = merged or path.mergedWindows > 0
	retried = retried or path.planningRadius > radius
	assert(path.planningRadius <= radius * 2 + 1e-9, "Planning retries escaped the radius bound")
	if index == 1 then
		assert(path.length == 0, "Identical poses must not add a full circle")
	end
	for _, part in ipairs(path.parts) do
		if part.xCoefficients then
			local _, _, _, firstCurvature = path:Sample(part.start)
			local _, _, _, lastCurvature = path:Sample(part.finish)
			oppositeCurvature = oppositeCurvature or firstCurvature * lastCurvature < -1e-6
			if index <= 100 then
				-- 独立复合 Simpson 积分，验证 Gauss 弧长表的真实长度。
				local total, count = 0, 1000
				for sample = 0, count do
					local u = sample / count
					local x, z = part.xCoefficients, part.zCoefficients
					local vx = x[2] + 2 * x[3] * u + 3 * x[4] * u ^ 2 + 4 * x[5] * u ^ 3 + 5 * x[6] * u ^ 4
					local vz = z[2] + 2 * z[3] * u + 3 * z[4] * u ^ 2 + 4 * z[5] * u ^ 3 + 5 * z[6] * u ^ 4
					local weight = if sample == 0 or sample == count then 1 elseif sample % 2 == 0 then 2 else 4
					total += weight * math.sqrt(vx * vx + vz * vz)
				end
				assert(math.abs(total / (3 * count) - part.length) < 0.001, "Arc-length integration exceeded tolerance")
			end
		end
	end
	for _, distance in ipairs(path.joins) do
		local _, _, _, before = path:Sample(distance - path.speed * 0.00001)
		local _, _, _, after = path:Sample(distance + path.speed * 0.00001)
		assert(math.deg(math.abs(after - before) * path.speed) <= 1, "Turn rate jumped in seeded paths")
	end
	for kind in pairs(path.candidateKinds) do
		families[kind] = true
	end
	local x, z, heading = path:Sample(path.length)
	assert(math.sqrt((x - last.x) ^ 2 + (z - last.z) ^ 2) < 1e-6, "Path did not reach goal")
	assert(angleError(heading, last.heading) < 1e-6, "Path did not reach goal heading")
	assert(path:DistanceAt(-1) == 0 and path:DistanceAt(path.duration + 1) == path.length)
	local previous = 0
	for frame = 0, 60 do
		local time = path.duration * frame / 60
		local distance, speed = path:DistanceAt(time)
		assert(
			distance >= previous - 1e-9 and speed >= 0 and speed <= path.speed + 1e-9,
			"Path reversed or exceeded speed"
		)
		previous = distance
	end
	for sample = 1, 9 do
		local distance = path.length * sample / 10
		if path.length > 0.001 then
			local step = math.min(1e-5, path.length / 1000)
			local ax, az = path:Sample(distance - step)
			local bx, bz = path:Sample(distance + step)
			local _, _, direction, curvature = path:Sample(distance)
			local vx, vz = bx - ax, bz - az
			local length = math.sqrt(vx * vx + vz * vz)
			assert(math.abs(length / (2 * step) - 1) < 1e-4, "Arc-length inversion introduced a speed jump")
			assert(
				(vx * math.cos(direction) + vz * math.sin(direction)) / length > 0.9999,
				"Heading missed forward velocity"
			)
			assert(math.abs(curvature) <= 1 / radius + 1e-9, "Turn radius too small")
		end
	end
end
assert(merged and retried and oppositeCurvature, "Missing merged windows, radius retries or opposite-curvature blends")

local straight = Path.new({ x = 0, z = 0, heading = 0 }, { x = 10, z = 0, heading = 0 }, 1, 7.5, 0.15, 0.3)
assert(straight.length == 10 and #straight.joins == 0 and straight.planningRadius == 1, "Straight path was changed")
for _, heading in ipairs({ math.pi - 1e-8, -math.pi + 1e-8 }) do
	local path = Path.new({ x = 2, z = 3, heading = heading }, { x = -6, z = 3.001, heading = -heading }, 1, 7.5, 0.15, 0.3)
	local x, z, finalHeading = path:Sample(path.length)
	assert(math.sqrt((x + 6) ^ 2 + (z - 3.001) ^ 2) < 0.001 and angleError(finalHeading, -heading) < math.rad(0.05))
	local expected = { path:Sample(path:DistanceAt(path.duration * 0.37)) }
	for _, rate in ipairs({ 15, 30, 60, 144 }) do
		for frame = 0, math.ceil(path.duration * rate) do
			path:Sample(path:DistanceAt(frame / rate))
		end
		local actual = { path:Sample(path:DistanceAt(path.duration * 0.37)) }
		for index, value in ipairs(expected) do
			assert(value == actual[index], "Frame rate changed path sampling")
		end
	end
end
for _, family in ipairs({ "LSL", "RSR", "LSR", "RSL", "RLR", "LRL" }) do
	assert(families[family], "Missing path family: " .. family)
end
