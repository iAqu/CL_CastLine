-- Studio Client：真实模型、随机与极值路线、屏幕修正后的转弯连续性及六条路线预计算耗时。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingCurvatureValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local owner = { folder = folder, bait = bait, forward = Vector3.zAxis }
	local target = Vector3.new(10, 20, 30)
	local eye = target + Vector3.new(14, 18, -22)
	local timings, joins, maxJump, maxDisplayJump, maxRadius = {}, 0, 0, 0, 1
	local function angleDifference(a, b)
		return math.atan2(math.sin(b - a), math.cos(b - a))
	end
	local function timeAt(path, distance)
		local low, high = 0, path.duration
		for _ = 1, 40 do
			local middle = (low + high) / 2
			if path:DistanceAt(middle) < distance then
				low = middle
			else
				high = middle
			end
		end
		return (low + high) / 2
	end
	for case = 1, 28 do
		owner.spin = if case % 2 == 0 then math.pi / 4 else 0
		local visual = Random.new(case + 100)
		if case > 20 then
			local spec = case - 21
			visual = {
				NextInteger = function() return spec % 2 end,
				NextNumber = function(_, low, high)
					if low == settings.Nibble.TurnMin and high == settings.Nibble.TurnMax then
						return if math.floor(spec / 2) % 2 == 0 then low else high
					elseif low == settings.Nibble.SpeedMin and high == settings.Nibble.SpeedMax then
						return if spec < 4 then low else high
					elseif low == settings.Nibble.ReturnSpeedMin and high == settings.Nibble.ReturnSpeedMax then
						return if spec < 4 then high else low
					end
					return (low + high) / 2
				end,
			}
		end
		active = Bite.new(owner, 0, 0, Random.new(case), visual)
		local before = os.clock()
		active:_prepareRepositions()
		table.insert(timings, (os.clock() - before) * 1000)
		for index, route in ipairs(active.repositions) do
			local path = route.path
			maxRadius = math.max(maxRadius, path.planningRadius / path.radius)
			local function displayedHeading(time)
				local frame = active:_repositionPose(index, time, target, eye)
				return math.atan2(frame.LookVector.Z, frame.LookVector.X)
			end
			for _, distance in ipairs(path.joins) do
				local time = timeAt(path, distance)
				local a, speedA = path:DistanceAt(time - 0.00001)
				local b, speedB = path:DistanceAt(time + 0.00001)
				local _, _, _, kA = path:Sample(a)
				local _, _, _, kB = path:Sample(b)
				local jump = math.deg(math.abs(kA * speedA - kB * speedB))
				assert(jump <= 1, "Base turn rate jumped at a curve join")
				maxJump = math.max(maxJump, jump)
				-- CFrame 的单精度输出使用较宽差分间隔；原硬拐会产生上百度/秒的差值。
				local step = 0.0005
				local heading = displayedHeading(time)
				local left = angleDifference(displayedHeading(time - step), heading) / step
				local right = angleDifference(heading, displayedHeading(time + step)) / step
				local displayJump = math.deg(math.abs(left - right))
				assert(displayJump <= 2, "Projected turn rate jumped at a curve join")
				maxDisplayJump = math.max(maxDisplayJump, displayJump)
				joins += 1
			end
			for sample = 1, 19 do
				local time = path.duration * sample / 20
				local first = active:_repositionPose(index, time - 0.0001, target, eye)
				local last = active:_repositionPose(index, time + 0.0001, target, eye)
				local frame = active:_repositionPose(index, time, target, eye)
				assert(frame.LookVector:Dot((last.Position - first.Position).Unit) > 0.999,
					"Projected fish missed the actual forward tangent")
			end
			local x, z, heading = path:Sample(path.length)
			assert(Vector2.new(x - route.last.Position.X, z - route.last.Position.Z).Magnitude < 0.001,
				"Smoothing moved the final feeding position")
			local expected = math.atan2(route.last.LookVector.Z, route.last.LookVector.X)
			assert(math.abs(angleDifference(heading, expected)) < math.rad(0.05), "Smoothing changed final heading")
		end
		active:Destroy()
		active = nil
		task.wait()
	end
	table.sort(timings)
	assert(timings[#timings] < 16, "Six-route precomputation exceeded 16ms")
	return {
		passed = true, cases = #timings, joins = joins,
		maxTurnRateDifference = maxJump, maxProjectedTurnRateDifference = maxDisplayJump,
		sixRoutesP50ms = timings[14], sixRoutesP95ms = timings[27], sixRoutesMaxMs = timings[28],
		maxPlanningRadiusScale = maxRadius,
	}
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
