-- 平面前向路径：Dubins 骨架加局部五次连接，按弧长采样连续曲率。
-- 角度以 X/Z 平面 atan2(z, x) 为准；不依赖 Roblox 实例或逐帧积分。
local FishRepositionPath = {}
FishRepositionPath.__index = FishRepositionPath
local tau = math.pi * 2
local epsilon = 1e-9

local function wrap(angle)
	local value = angle % tau
	return if value < epsilon or tau - value < epsilon then 0 else value
end

local function candidates(first, last, radius)
	local dx, dz = (last.x - first.x) / radius, (last.z - first.z) / radius
	local distance = math.sqrt(dx * dx + dz * dz)
	local bearing = math.atan2(dz, dx)
	local a, b = wrap(first.heading - bearing), wrap(last.heading - bearing)
	local sa, sb, ca, cb = math.sin(a), math.sin(b), math.cos(a), math.cos(b)
	local difference = math.cos(a - b)
	local routes = {}
	local function candidate(kind, t, p, q)
		local lengths = { wrap(t), p, wrap(q) }
		local total = lengths[1] + lengths[2] + lengths[3]
		table.insert(routes, { kind = kind, lengths = lengths, length = total * radius })
	end
	local function straight(kind, squared, phase, firstTurn, lastTurn)
		if squared >= -epsilon then
			local length = math.sqrt(math.max(0, squared))
			local theta = phase(length)
			candidate(kind, firstTurn(theta), length, lastTurn(theta))
		end
	end
	straight("LSL", 2 + distance ^ 2 - 2 * difference + 2 * distance * (sa - sb), function()
		return math.atan2(cb - ca, distance + sa - sb)
	end, function(theta)
		return -a + theta
	end, function(theta)
		return b - theta
	end)
	straight("RSR", 2 + distance ^ 2 - 2 * difference + 2 * distance * (sb - sa), function()
		return math.atan2(ca - cb, distance - sa + sb)
	end, function(theta)
		return a - theta
	end, function(theta)
		return -b + theta
	end)
	straight("LSR", -2 + distance ^ 2 + 2 * difference + 2 * distance * (sa + sb), function(length)
		return math.atan2(-ca - cb, distance + sa + sb) - math.atan2(-2, length)
	end, function(theta)
		return -a + theta
	end, function(theta)
		return -b + theta
	end)
	straight("RSL", -2 + distance ^ 2 + 2 * difference - 2 * distance * (sa + sb), function(length)
		return math.atan2(ca + cb, distance - sa - sb) - math.atan2(2, length)
	end, function(theta)
		return a - theta
	end, function(theta)
		return b - theta
	end)
	local rlr = (6 - distance ^ 2 + 2 * difference + 2 * distance * (sa - sb)) / 8
	if math.abs(rlr) <= 1 + epsilon then
		local middle = wrap(tau - math.acos(math.clamp(rlr, -1, 1)))
		local initial = wrap(a - math.atan2(ca - cb, distance - sa + sb) + middle / 2)
		candidate("RLR", initial, middle, a - b - initial + middle)
	end
	local lrl = (6 - distance ^ 2 + 2 * difference + 2 * distance * (sb - sa)) / 8
	if math.abs(lrl) <= 1 + epsilon then
		local middle = wrap(tau - math.acos(math.clamp(lrl, -1, 1)))
		local initial = wrap(-a - math.atan2(ca - cb, distance + sa - sb) + middle / 2)
		candidate("LRL", initial, middle, b - a - initial + middle)
	end
	return routes
end

local function arcSample(part, distance)
	local x, z, heading, curvature = part.x, part.z, part.heading, part.curvature
	if curvature == 0 then
		return x + distance * math.cos(heading), z + distance * math.sin(heading), heading, 0
	end
	local nextHeading = heading + curvature * distance
	return x + (math.sin(nextHeading) - math.sin(heading)) / curvature,
		z + (math.cos(heading) - math.cos(nextHeading)) / curvature, nextHeading, curvature
end

local function rawParts(first, route, radius)
	local parts, length = {}, 0
	local x, z, heading = first.x, first.z, first.heading
	for index, normalized in ipairs(route.lengths) do
		local distance = normalized * radius
		if distance > epsilon then
			local kind = string.sub(route.kind, index, index)
			local curvature = if kind == "S" then 0 else (if kind == "L" then 1 else -1) / radius
			local previous = parts[#parts]
			if previous and previous.curvature == curvature then
				previous.length += distance
				previous.finish += distance
			else
				table.insert(parts, {
					x = x, z = z, heading = heading, curvature = curvature,
					start = length, length = distance, finish = length + distance,
				})
			end
			x, z, heading = arcSample({ x = x, z = z, heading = heading, curvature = curvature }, distance)
			length += distance
		end
	end
	return parts, length
end

local function rawSample(parts, distance)
	for index, part in ipairs(parts) do
		if distance <= part.finish or index == #parts then
			return arcSample(part, math.clamp(distance - part.start, 0, part.length))
		end
	end
	error("Cannot sample an empty route")
end

local function polynomial(first, last, d0, d1, a0, a1)
	local c2 = a0 / 2
	local a, b, c = last - first - d0 - c2, d1 - d0 - 2 * c2, a1 - 2 * c2
	return { first, d0, c2, 10 * a - 4 * b + c / 2, -15 * a + 7 * b - c, 6 * a - 3 * b + c / 2 }
end

local function evaluate(c, u)
	local position = ((((c[6] * u + c[5]) * u + c[4]) * u + c[3]) * u + c[2]) * u + c[1]
	local velocity = (((5 * c[6] * u + 4 * c[5]) * u + 3 * c[4]) * u + 2 * c[3]) * u + c[2]
	local acceleration = ((20 * c[6] * u + 12 * c[5]) * u + 6 * c[4]) * u + 2 * c[3]
	return position, velocity, acceleration
end

local function curveSample(curve, u)
	local x, vx, ax = evaluate(curve.xCoefficients, u)
	local z, vz, az = evaluate(curve.zCoefficients, u)
	local squared = vx * vx + vz * vz
	return x, z, math.atan2(vz, vx), (vx * az - vz * ax) / squared ^ 1.5, math.sqrt(squared)
end

local function curve(first, last, scale)
	local x0, z0, h0, k0 = unpack(first)
	local x1, z1, h1, k1 = unpack(last)
	local dx0, dz0, dx1, dz1 = math.cos(h0) * scale, math.sin(h0) * scale,
		math.cos(h1) * scale, math.sin(h1) * scale
	local ax0, az0 = -math.sin(h0) * k0 * scale ^ 2, math.cos(h0) * k0 * scale ^ 2
	local ax1, az1 = -math.sin(h1) * k1 * scale ^ 2, math.cos(h1) * k1 * scale ^ 2
	return {
		xCoefficients = polynomial(x0, x1, dx0, dx1, ax0, ax1),
		zCoefficients = polynomial(z0, z1, dz0, dz1, az0, az1),
		scale = scale,
		controls = {
			{ x0, z0 }, { x0 + dx0 / 5, z0 + dz0 / 5 },
			{ x0 + 2 * dx0 / 5 + ax0 / 20, z0 + 2 * dz0 / 5 + az0 / 20 },
			{ x1 - 2 * dx1 / 5 + ax1 / 20, z1 - 2 * dz1 / 5 + az1 / 20 },
			{ x1 - dx1 / 5, z1 - dz1 / 5 }, { x1, z1 },
		},
	}
end

local function splitControls(points)
	local left, right, row = { points[1] }, { points[#points] }, points
	for _ = 1, #points - 1 do
		local nextRow = {}
		for i = 1, #row - 1 do
			nextRow[i] = { (row[i][1] + row[i + 1][1]) / 2, (row[i][2] + row[i + 1][2]) / 2 }
		end
		table.insert(left, nextRow[1])
		table.insert(right, 1, nextRow[#nextRow])
		row = nextRow
	end
	return left, right
end

-- 用导数 Bézier 控制凸包保守约束整段曲率，而不只检查几个采样点。
local function certifyControls(points, limit, depth)
	local vx, vz, ax, az = {}, {}, {}, {}
	for i = 1, 5 do
		vx[i], vz[i] = 5 * (points[i + 1][1] - points[i][1]), 5 * (points[i + 1][2] - points[i][2])
	end
	for i = 1, 4 do
		ax[i], az[i] = 4 * (vx[i + 1] - vx[i]), 4 * (vz[i + 1] - vz[i])
	end
	local dx, dz = points[6][1] - points[1][1], points[6][2] - points[1][2]
	local norm = math.sqrt(dx * dx + dz * dz)
	local minimum, numerator = math.huge, 0
	if norm > 0 then
		for i = 1, 5 do
			minimum = math.min(minimum, (vx[i] * dx + vz[i] * dz) / norm)
			for j = 1, 4 do
				numerator = math.max(numerator, math.abs(vx[i] * az[j] - vz[i] * ax[j]))
			end
		end
		if minimum > 1e-12 and numerator <= limit * minimum ^ 3 then
			return true
		end
	end
	if depth == 0 then
		return false
	end
	local left, right = splitControls(points)
	return certifyControls(left, limit, depth - 1) and certifyControls(right, limit, depth - 1)
end

local function validCurve(value, radius)
	local limit = (1 + 1e-9) / radius
	for sample = 0, 8 do
		local _, _, _, curvature, speed = curveSample(value, sample / 8)
		if speed < value.scale * 1e-7 or curvature ~= curvature or math.abs(curvature) > limit then
			return false
		end
	end
	return certifyControls(value.controls, limit, 12)
end

local function curveSpeed(value, u)
	local _, vx = evaluate(value.xCoefficients, u)
	local _, vz = evaluate(value.zCoefficients, u)
	return math.sqrt(vx * vx + vz * vz)
end

-- 五点 Gauss 积分；表和区间内反算共用同一解析速度。
local function integrate(value, first, last)
	local middle, half = (first + last) / 2, (last - first) / 2
	return half * (0.5688888888888889 * curveSpeed(value, middle)
		+ 0.4786286704993665 * (curveSpeed(value, middle - half * 0.5384693101056831)
			+ curveSpeed(value, middle + half * 0.5384693101056831))
		+ 0.2369268850561891 * (curveSpeed(value, middle - half * 0.9061798459386640)
			+ curveSpeed(value, middle + half * 0.9061798459386640)))
end

local function adaptiveLength(value, first, last, whole, tolerance, depth, nodes)
	local middle = (first + last) / 2
	local left, right = integrate(value, first, middle), integrate(value, middle, last)
	if depth == 0 or math.abs(left + right - whole) <= tolerance then
		if nodes then
			table.insert(nodes, { u = last, length = left + right })
		end
		return left + right
	end
	return adaptiveLength(value, first, middle, left, tolerance / 2, depth - 1, nodes)
		+ adaptiveLength(value, middle, last, right, tolerance / 2, depth - 1, nodes)
end

local function appendRaw(parts, raw, first, last)
	for _, segment in ipairs(raw) do
		local from, to = math.max(first, segment.start), math.min(last, segment.finish)
		if to - from > epsilon then
			local x, z, heading, curvature = arcSample(segment, from - segment.start)
			table.insert(parts, { x = x, z = z, heading = heading, curvature = curvature, length = to - from })
		end
	end
end

local function smoothRoute(first, route, planningRadius, minimumRadius, halfWindow)
	local raw, total = rawParts(first, route, planningRadius)
	local windows, merged = {}, 0
	for i = 1, #raw - 1 do
		local boundary = raw[i].finish
		local from, to = math.max(0, boundary - halfWindow), math.min(total, boundary + halfWindow)
		local previous = windows[#windows]
		if previous and from <= previous.last then
			previous.last = math.max(previous.last, to)
			merged += 1
		else
			table.insert(windows, { first = from, last = to })
		end
	end
	local parts, cursor, length = {}, 0, 0
	for _, window in ipairs(windows) do
		appendRaw(parts, raw, cursor, window.first)
		local value = curve({ rawSample(raw, window.first) }, { rawSample(raw, window.last) }, window.last - window.first)
		if not validCurve(value, minimumRadius) then
			return nil
		end
		value.length = adaptiveLength(value, 0, 1, integrate(value, 0, 1), 1e-8, 12)
		table.insert(parts, value)
		cursor = window.last
	end
	appendRaw(parts, raw, cursor, total)
	for _, part in ipairs(parts) do
		length += part.length
	end
	return { kind = route.kind, segments = route.lengths, parts = parts, length = length, mergedWindows = merged }
end

local function buildTable(value)
	local nodes = { { u = 0, distance = 0 } }
	for i = 0, 7 do
		local from, to = i / 8, (i + 1) / 8
		adaptiveLength(value, from, to, integrate(value, from, to), 1e-9, 12, nodes)
	end
	local distance = 0
	for i = 2, #nodes do
		distance += nodes[i].length
		nodes[i].distance = distance
	end
	value.nodes, value.length = nodes, distance
end

local function parameterAt(value, distance)
	if distance <= 0 then
		return 0
	elseif distance >= value.length then
		return 1
	end
	local nodes = value.nodes
	local low, high = 1, #nodes
	while high - low > 1 do
		local middle = math.floor((low + high) / 2)
		if nodes[middle].distance <= distance then
			low = middle
		else
			high = middle
		end
	end
	local first, last = nodes[low], nodes[high]
	local a, b = first.u, last.u
	local u = a + (b - a) * (distance - first.distance) / (last.distance - first.distance)
	for _ = 1, 12 do
		local error = first.distance + integrate(value, first.u, u) - distance
		if math.abs(error) < 1e-10 then
			return u
		end
		if error > 0 then
			b = u
		else
			a = u
		end
		local nextU = u - error / curveSpeed(value, u)
		u = if nextU > a and nextU < b then nextU else (a + b) / 2
	end
	return u
end

-- 把弧长转换为带弯道成本的行程。积分后仍可按绝对时间随机访问，不逐帧累计。
local function buildTravelProfile(path, maxTurnRate)
	local count = math.clamp(math.ceil(path.length / math.min(0.25, path.radius * 0.1)), 1, 4096)
	local nodes, stretches = {}, {}
	for index = 0, count do
		local distance = path.length * index / count
		local _, _, _, curvature = path:Sample(distance)
		stretches[index + 1] = math.sqrt(1 + (path.speed * curvature / maxTurnRate) ^ 2)
	end
	local travel = 0
	for index = 1, count + 1 do
		-- 保守取邻域成本，提前减速，并让线性插值的速度在节点处连续。
		local stretch = math.max(stretches[math.max(1, index - 1)], stretches[index], stretches[math.min(count + 1, index + 1)])
		local distance = path.length * (index - 1) / count
		local previous = nodes[index - 1]
		if previous then
			travel += (distance - previous.distance) * (previous.stretch + stretch) * 0.5
		end
		nodes[index] = { distance = distance, travel = travel, stretch = stretch }
	end
	path.travelProfile, path.travelLength = nodes, travel
end

function FishRepositionPath.new(first, last, radius, speed, ramp, blendTime, maxTurnRate)
	assert(radius > 0 and speed > 0 and ramp > 0 and blendTime > 0, "Forward path requires positive settings")
	local chosen, planningRadius
	local candidateKinds = {}
	local samePosition = math.abs(first.x - last.x) + math.abs(first.z - last.z) < epsilon
	if samePosition and wrap(first.heading - last.heading) == 0 then
		chosen, planningRadius = { kind = "LSL", segments = { 0, 0, 0 }, parts = {}, length = 0, mergedWindows = 0 }, radius
	else
		for _, factor in ipairs({ 1, 1.15, 1.25, 1.5, 2 }) do
			planningRadius = radius * factor
			for _, route in ipairs(candidates(first, last, planningRadius)) do
				candidateKinds[route.kind] = true
				local value = smoothRoute(first, route, planningRadius, radius, speed * blendTime / 2)
				if value and (not chosen or value.length < chosen.length) then
					chosen = value
				end
			end
			if chosen then
				break
			end
		end
	end
	assert(chosen, "No curvature-safe forward path found")
	local length, joins = 0, {}
	for index, part in ipairs(chosen.parts) do
		if part.xCoefficients then
			buildTable(part)
		end
		part.start, part.finish = length, length + part.length
		length = part.finish
		if index < #chosen.parts then
			table.insert(joins, length)
		end
	end
	chosen.first, chosen.last = first, last
	chosen.radius, chosen.planningRadius, chosen.length = radius, planningRadius, length
	chosen.speed, chosen.travelLength = speed, length
	chosen.joins = joins
	chosen.candidateKinds = candidateKinds
	local path = setmetatable(chosen, FishRepositionPath)
	if maxTurnRate and length > 0 then
		assert(maxTurnRate > 0, "Turn rate must be positive")
		buildTravelProfile(path, maxTurnRate)
	end
	path.ramp = math.min(ramp, path.travelLength / speed)
	path.duration = path.travelLength / speed + path.ramp
	return path
end

function FishRepositionPath:Sample(distance)
	if self.length == 0 then
		return self.first.x, self.first.z, self.first.heading, 0
	end
	distance = math.clamp(distance, 0, self.length)
	local low, high = 1, #self.parts
	while low < high do
		local middle = math.floor((low + high) / 2)
		if distance > self.parts[middle].finish then
			low = middle + 1
		else
			high = middle
		end
	end
	local part = self.parts[low]
	local localDistance = math.clamp(distance - part.start, 0, part.length)
	if part.xCoefficients then
		local x, z, heading, curvature = curveSample(part, parameterAt(part, localDistance))
		return x, z, heading, curvature
	end
	return arcSample(part, localDistance)
end

-- 首尾平滑加减速，速度非负；积分行程恰好覆盖整条路径。
local function travelAt(self, elapsed)
	if elapsed <= 0 or self.length == 0 then
		return 0, 0
	end
	if elapsed >= self.duration then
		return self.travelLength, 0
	end
	local reverse = elapsed > self.duration - self.ramp
	local time = if reverse then self.duration - elapsed else elapsed
	if time < self.ramp then
		local u = time / self.ramp
		local distance = self.speed * self.ramp * (u ^ 3 - u ^ 4 / 2)
		return if reverse then self.travelLength - distance else distance, self.speed * u * u * (3 - 2 * u)
	end
	return self.speed * (time - self.ramp / 2), self.speed
end

function FishRepositionPath:DistanceAt(elapsed)
	if elapsed <= 0 or self.length == 0 then
		return 0, 0
	elseif elapsed >= self.duration then
		return self.length, 0
	end
	local travel, speed = travelAt(self, elapsed)
	local nodes = self.travelProfile
	if not nodes then
		return travel, speed
	end
	local low, high = 1, #nodes - 1
	while low < high do
		local middle = math.floor((low + high) / 2)
		if travel > nodes[middle + 1].travel then
			low = middle + 1
		else
			high = middle
		end
	end
	local first, last = nodes[low], nodes[low + 1]
	local slope = (last.stretch - first.stretch) / (last.distance - first.distance)
	local cost = math.max(0, travel - first.travel)
	-- 稳定求解线性成本的二次积分，避免近直线段相减丢失精度。
	local offset = 2 * cost / (first.stretch + math.sqrt(math.max(0, first.stretch ^ 2 + 2 * slope * cost)))
	offset = math.clamp(offset, 0, last.distance - first.distance)
	return first.distance + offset, speed / (first.stretch + slope * offset)
end

return FishRepositionPath
