local function read(path)
	local file = assert(io.open(path, "r"))
	return file:read("*a")
end

local vector = {}
local vectorMeta = {}
function vector.new(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, vectorMeta)
end
function vectorMeta.__index(value, field)
	local length = math.sqrt(value.X ^ 2 + value.Y ^ 2 + value.Z ^ 2)
	return if field == "Magnitude" then length elseif field == "Unit" then value * (1 / length) else nil
end
function vectorMeta.__mul(a, b)
	if type(b) == "number" then
		return vector.new(a.X * b, a.Y * b, a.Z * b)
	end
	return vector.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
function vectorMeta.__add(a, b)
	return vector.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
function vectorMeta.__sub(a, b)
	return vector.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
vector.zero = vector.new(0, 0, 0)

local function frame(position, yaw)
	local cosine, sine = math.cos(yaw), math.sin(yaw)
	local result = { Position = position, LookVector = vector.new(-sine, 0, -cosine) }
	function result:VectorToObjectSpace(v)
		return vector.new(v.X * cosine - v.Z * sine, v.Y, v.X * sine + v.Z * cosine)
	end
	function result:VectorToWorldSpace(v)
		return vector.new(v.X * cosine + v.Z * sine, v.Y, -v.X * sine + v.Z * cosine)
	end
	function result:PointToObjectSpace(p)
		return self:VectorToObjectSpace(p - position)
	end
	function result:PointToWorldSpace(p)
		return position + self:VectorToWorldSpace(p)
	end
	return setmetatable(result, {
		__mul = function(a, b)
			return { Position = a:PointToWorldSpace(b.Position), LookVector = a:VectorToWorldSpace(b.LookVector) }
		end,
	})
end

local encodedFields
local httpService = {
	JSONEncode = function(_, fields)
		encodedFields = fields
		return "snapshot"
	end,
	JSONDecode = function(_, encoded)
		assert(encoded == "snapshot", "Decode must use the replicated snapshot")
		return encodedFields
	end,
}

local vector2 = { new = function(x, y)
	return vector.new(x, y, 0)
end }
local statsPath = "src/ReplicatedStorage/Modules/ItemStatUtil.lua"
local stats = assert(load(read(statsPath), statsPath, "t", setmetatable({
	script = { Parent = { RarityConfig = { List = {} } } },
	require = function(module) return module end,
	Vector3 = vector,
	Vector2 = vector2,
}, { __index = getfenv() })))()
local templates = {}

local motionPath = "src/ReplicatedStorage/Modules/PlotFishMotion.lua"
local motion = assert(load(
	read(motionPath),
	motionPath,
	"t",
	setmetatable({
		game = { GetService = function()
			return httpService
		end },
		require = function(module)
			return module
		end,
		script = { Parent = {
			PlotPlacementUtil = { CAPACITY = 10 },
			FishingAssets = { GetFish = function(name) return templates[name] end },
			ItemStatUtil = stats,
			FishSwimBounds = { ["mesh/Slender"] = { -0.5, 0.5, -5, 5, math.sqrt(25.25) } },
		} },
		Vector3 = vector,
		Vector2 = vector2,
		CFrame = {
			lookAt = function(at, target)
				return { Position = at, LookVector = (target - at).Unit }
			end,
		},
	}, { __index = getfenv() })
))()

local function boundaryPart(size, cframe)
	return {
		Size = size,
		CFrame = cframe,
		IsA = function(_, className)
			return className == "BasePart"
		end,
	}
end

local children = {}
local plot = {}
function plot:FindFirstChild(name, recursive)
	assert(not recursive, "Plot boundaries must be direct children")
	return children[name]
end

local groundFrame = frame(vector.new(2238, 776, 911), 0.37)
local ground = boundaryPart(vector.new(60, 1, 56.5), groundFrame)
local legacyFrame = frame(groundFrame:PointToWorldSpace(vector.new(0, 0, -17)), 0.37 + math.pi / 2)
local legacy = boundaryPart(vector.new(45, 1, 45), legacyFrame)
children["3"] = legacy
assert(motion.GetBoundary(plot) == legacy, "Plots without Ground must use their existing boundary")
children.Ground = { IsA = function()
	return false
end }
assert(motion.GetBoundary(plot) == legacy, "A non-part Ground cannot be used as a boundary")
children.Ground = ground
local selected = motion.GetBoundary(plot)
assert(selected == ground, "A direct Ground part must take precedence over the old boundary")

local groundOnly = groundFrame:PointToWorldSpace(vector.new(0, 3, 25))
local entryRoot = { Position = groundOnly, CFrame = frame(groundOnly, 0.37) }
assert(motion.GetEntry(selected, entryRoot) and not motion.GetEntry(legacy, entryRoot), "Accept the new Ground area")
entryRoot.Position = groundFrame:PointToWorldSpace(vector.new(0, 3, -35))
assert(not motion.GetEntry(selected, entryRoot) and motion.GetEntry(legacy, entryRoot), "Reject the old area outside Ground")

local function expectVector(actual, expected, message)
	assert((actual - expected).Magnitude < 1e-5, message)
end

local function fishTemplate(size, animatedRadius, animationId)
	return {
		FindFirstChild = function(_, name)
			if name == "Animations" and animationId then
				return { FindFirstChild = function() return { AnimationId = animationId } end }
			end
			return nil
		end,
		PrimaryPart = { MeshId = "mesh", CFrame = {
			ToObjectSpace = function(_, bounds) return bounds end,
		} },
		GetBoundingBox = function() return frame(vector.zero, 0), size end,
		GetAttribute = function(_, name)
			return if name == "PresentationRadius" then animatedRadius else nil
		end,
		GetScale = function() return 2 end,
	}
end

templates.Axolotl = fishTemplate(vector.new(3.216, 2.034, 6.036), 4.056)
local axolotl = { Model = "Axolotl", DefaultWeight = 840 }
assert(stats.GetScaleRatio(axolotl, 840, templates.Axolotl) == 1, "Keep default-weight fish at template size")
assert(stats.GetScaleRatio(axolotl, 840 * 3.375, templates.Axolotl) == 1.5, "A growth roll increases length by 1.5")
local heldScale
local toolModel = { ScaleTo = function(_, scale) heldScale = scale end }
for _, base in { 1, 1.5 } do
	local item = { Model = "Axolotl", DefaultWeight = 840, ModelDefaultScale = base }
	for _, weightMultiple in { 1, 8 } do
		local weight = 840 * weightMultiple
		local expected = base * weightMultiple ^ (1 / 3)
		assert(stats.GetScaleRatio(item, weight, templates.Axolotl) == expected, "Multiply base size by cube-root weight")
		stats.ScaleModel(toolModel, item, weight, templates.Axolotl)
		local placed = motion.GetGeometry(item, weight, ground)
		assert(heldScale == 2 * expected and placed.scale == expected, "Apply authored scale once in held and placed fish")
		assert(math.abs(placed.radius - 4.056 * expected) < 1e-5, "Use the final size for plot travel bounds")
		assert(math.abs(placed.height - (ground.Size.Y * 0.5 + 1.25 + 1.017 * expected)) < 1e-5,
			"Keep the final-sized fish above the ground")
	end
end
for _, invalid in { 0, -1, math.huge, -math.huge, 0 / 0, "invalid" } do
	assert(stats.GetScaleRatio({ DefaultWeight = 840, ModelDefaultScale = invalid }, 840, templates.Axolotl) == 1,
		"Invalid base multipliers must fall back to one")
end
stats.ScaleModel(toolModel, axolotl, 64000, templates.Axolotl)
local oldFish = motion.GetGeometry(axolotl, 64000, ground)
assert(math.abs(oldFish.scale * 6.036 - 25.59) < 0.02, "Compress the old 64,000 kg fish using the cube root")
assert(heldScale == 2 * oldFish.scale, "Hold and place the old fish at the same size")
assert(motion.GetGeometry(axolotl, 64000, legacy).scale == oldFish.scale, "Plot size must not change model size")

templates.Slender = fishTemplate(vector.new(1, 1, 10), nil, "Slender")
local slender = motion.GetGeometry({ Model = "Slender", DefaultWeight = 1 }, 1, ground)
assert(slender.footprint, "Use the fish's directional footprint instead of a circular inset")
local footprint = slender.footprint
for edge = 1, 4 do
	local move = motion.Start(ground, vector.zero, 0, {
		NextNumber = function(_, low, high) return if low == nil then 0.1 else (low + high) / 2 end,
		NextInteger = function() return edge end,
	}, 0, footprint)
	local pose = motion.Sample(ground, slender.height, move, move.duration, footprint)
	local center = ground.CFrame:PointToObjectSpace(pose.Position)
	local closest = math.huge
	for _, x in { -0.5, 0.5 } do
		for _, z in { -5, 5 } do
			local forward = ground.CFrame:VectorToObjectSpace(pose.LookVector)
			local corner = center + vector.new(-forward.Z * x - forward.X * z, 0, forward.X * x - forward.Z * z)
			assert(math.abs(corner.X) <= 30.00001 and math.abs(corner.Z) <= 28.25001, "The whole fish stays inside")
			local gap = if edge <= 2 then 30 - math.abs(corner.X) else 28.25 - math.abs(corner.Z)
			closest = math.min(closest, gap)
		end
	end
	assert(closest < 0.0001, "The body must touch each selected edge without a circular gap")
end
local longFish = motion.GetGeometry({ Model = "Slender", DefaultWeight = 1 }, 1000, legacy)
assert(math.abs(longFish.radius - 21.5) < 1e-5 and longFish.scale * 10 < 50,
	"Long horizontal fish must still fit the shared footprint")

templates.Tall = fishTemplate(vector.new(1, 10, 1))
local tallFish = motion.GetGeometry({ Model = "Tall", DefaultWeight = 1, ModelDefaultScale = 1.5 }, 1000, legacy)
assert(tallFish.scale * 10 == 50, "Limit the longest model side to 50 studs after combining base and weight")
local cappedBase = motion.GetGeometry({ Model = "Tall", DefaultWeight = 1, ModelDefaultScale = 10 }, 1, legacy)
assert(cappedBase.scale == 5, "Limit base size even before weight growth")

templates.Wide = fishTemplate(vector.new(8, 2, 10), 9)
local wideFish = motion.GetGeometry({ Model = "Wide", DefaultWeight = 1, ModelDefaultScale = 1.5 }, 1000, legacy)
assert(math.abs(wideFish.radius - 21.5) < 1e-5, "Leave travel room for wide, animated fish")
assert(wideFish.scale * 10 < 50, "Apply the shared footprint limit before the longest-side cap")

local function fixedRandom(edge)
	return {
		NextNumber = function(_, min, max)
			if min == nil then
				return if edge then 0.1 else 0.9
			end
			return (min + max) * 0.5
		end,
		NextInteger = function()
			return edge
		end,
	}
end

for _, yaw in { 0, math.pi * 0.5, math.pi, 0.37 } do
	local boundary = boundaryPart(vector.new(60, 1, 56), frame(vector.new(1839, 772.8, 842), yaw))
	local start = boundary.CFrame:PointToWorldSpace(vector.new(0, 3, 25))
	local root = { Position = start, CFrame = frame(start, yaw + math.pi) }
	local entry = assert(motion.GetEntry(boundary, root))
	expectVector(entry, vector.new(0, 0, 28), "Clamp the projected placement to the Ground edge")
	local preview = motion.GetSurfacePoint(boundary, entry)
	expectVector(boundary.CFrame:PointToObjectSpace(preview), vector.new(0, 1.2, 28), "Surface point must use the placement X/Z")

	root.Position = boundary.CFrame:PointToWorldSpace(vector.new(31, 3, 25))
	assert(not motion.GetEntry(boundary, root), "Reject placements originating outside a rotated plot")

	for edge, target in { vector.new(-30, 0, 0), vector.new(30, 0, 0), vector.new(0, 0, -28), vector.new(0, 0, 28) } do
		local random = fixedRandom(edge)
		local from = if edge == 4 then vector.zero else entry
		local move = motion.Start(boundary, from, 50, random, math.pi)
		expectVector(move.target, target, "Each of the four edges must be selectable")
		assert(math.abs((move.target - move.from).Magnitude / move.duration - 6) < 1e-6, "Duration must follow distance and speed")

		local decoded = assert(motion.Decode(motion.Encode(move)), "Decode the complete move")
		local middle = move.startedAt + move.duration * 0.5
		local pose, swimmingWeight = motion.Sample(boundary, 4, move, middle)
		local clientPose = motion.Sample(boundary, 4, decoded, middle)
		expectVector(pose.Position, clientPose.Position, "Clients sample the same published move")
		expectVector(pose.LookVector, clientPose.LookVector, "Clients sample the same published heading")
		assert(swimmingWeight == 1, "Use full swim weight mid-segment")

		for index = 0, 100 do
			local sampled = motion.Sample(boundary, 4, move, move.startedAt + move.duration * index / 100)
			local localPosition = boundary.CFrame:PointToObjectSpace(sampled.Position)
			assert(math.abs(localPosition.X) <= 30 + 1e-5 and math.abs(localPosition.Z) <= 28 + 1e-5, "Stay inside the plot")
		end

		local arrivedAt = move.startedAt + move.duration
		assert(not motion.Advance(boundary, move, arrivedAt - 0.01, random), "Keep the current move until arrival")
		local rest = assert(motion.Advance(boundary, move, arrivedAt, random))
		assert(not rest.swimming and rest.duration >= 0.7 and rest.duration <= 1.5, "Rest for the configured time")
		local arrived = motion.Sample(boundary, 4, move, arrivedAt)
		local resting, restWeight = motion.Sample(boundary, 4, rest, rest.startedAt + rest.duration * 0.5)
		expectVector(boundary.CFrame:PointToObjectSpace(arrived.Position), target + vector.new(0, 4, 0), "Reach the selected edge")
		expectVector(resting.Position, arrived.Position, "Hold position while resting")
		expectVector(resting.LookVector, arrived.LookVector, "Hold heading while resting")
		assert(restWeight == 0.25, "Keep only a light tail motion while resting")

		local nextMove = assert(motion.Advance(boundary, rest, rest.startedAt + rest.duration, fixedRandom()))
		assert(nextMove.swimming, "Start swimming again after resting")
		local resumed = motion.Sample(boundary, 4, nextMove, nextMove.startedAt)
		expectVector(resumed.Position, resting.Position, "Resume at the previous target")
		expectVector(resumed.LookVector, resting.LookVector, "Resume without snapping to the next heading")
	end
end

-- Turn at the edge with an off-center body, then continue through rest/resume.
-- Check the actual body corners independently of the motion module's limits.
local offsetFootprint = { minimum = vector.new(-3, 0, -6), maximum = vector.new(5, 0, 10), radius = math.sqrt(125) }
for _, plotYaw in { 0, 0.37, math.pi / 2 } do
	local boundary = boundaryPart(vector.new(60, 1, 56), frame(vector.new(50, 10, -30), plotYaw))
	local seed = 7823
	local random = {}
	function random:NextNumber(low, high)
		seed = seed * 48271 % 2147483647
		local alpha = seed / 2147483647
		return if low == nil then alpha else low + (high - low) * alpha
	end
	function random:NextInteger(low, high)
		return math.min(high, math.floor(self:NextNumber(low, high + 1)))
	end
	local move = motion.Start(boundary, vector.new(29, 0, 27), 0, random, math.pi * 0.75, offsetFootprint)
	for _ = 1, 100 do
		for index = 0, 40 do
			local pose = motion.Sample(boundary, 4, move, move.startedAt + move.duration * index / 40, offsetFootprint)
			local center = boundary.CFrame:PointToObjectSpace(pose.Position)
			local forward = boundary.CFrame:VectorToObjectSpace(pose.LookVector)
			for _, x in { -3, 5 } do
				for _, z in { -6, 10 } do
					local corner = center + vector.new(-forward.Z * x - forward.X * z, 0, forward.X * x - forward.Z * z)
					assert(math.abs(corner.X) <= 30.0001 and math.abs(corner.Z) <= 28.0001,
						"The entire offset footprint must stay inside while turning, travelling and resting")
				end
			end
		end
		local arrived = motion.Sample(boundary, 4, move, move.startedAt + move.duration, offsetFootprint)
		move = assert(motion.Advance(boundary, move, move.startedAt + move.duration, random, offsetFootprint))
		local resumed = motion.Sample(boundary, 4, move, move.startedAt, offsetFootprint)
		expectVector(arrived.Position, resumed.Position, "Do not jump when changing direction at the edge")
		expectVector(arrived.LookVector, resumed.LookVector, "Do not snap the heading at the edge")
	end
end

local tiny = boundaryPart(vector.new(2, 1, 4), frame(vector.zero, 0))
local centeredRandom = fixedRandom()
local draws = 0
local nextNumber = centeredRandom.NextNumber
function centeredRandom:NextNumber(min, max)
	if min == -1 then
		draws += 1
	end
	return nextNumber(self, min, max)
end
local fallback = motion.Start(tiny, vector.zero, 0, centeredRandom)
assert(draws == 8, "Limit attempts when all candidate targets are too close")
expectVector(fallback.target, vector.new(-1, 0, -2), "Fall back to the farthest corner")

local wideRadius = 21.5
local edgeEntry = vector.new(20, 0, 20)
local wideMove = motion.Start(legacy, edgeEntry, 50, fixedRandom(1), math.pi, wideRadius)
expectVector(wideMove.from, vector.new(1, 0, 1), "Inset a restored or projected entry by the fish radius")
expectVector(wideMove.target, vector.new(-1, 0, 0), "Inset swimming targets by the same radius")
local preview = motion.GetSurfacePoint(legacy, edgeEntry, wideRadius)
expectVector(legacy.CFrame:PointToObjectSpace(preview), vector.new(1, 1.2, 1), "Preview the actual entry")
for index = 0, 10 do
	local pose = motion.Sample(legacy, 4, wideMove, 50 + wideMove.duration * index / 10, wideRadius)
	local position = legacy.CFrame:PointToObjectSpace(pose.Position)
	assert(math.abs(position.X) + wideRadius <= 22.5 + 1e-5, "Keep the fish inside during turns on X")
	assert(math.abs(position.Z) + wideRadius <= 22.5 + 1e-5, "Keep the fish inside during turns on Z")
end
local noRoom = motion.Start(legacy, edgeEntry, 50, fixedRandom(1), math.pi, 22.5)
assert(not noRoom.swimming and noRoom.duration > 0, "Keep a stationary fish idle without a zero-duration move")
expectVector(noRoom.from, vector.zero, "Center a fish with no room to swim")

print("PlotFishMotion.test.lua passed")
