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
local workspaceChildren = {}
local workspace = {
	FindFirstChild = function(_, name)
		return workspaceChildren[name]
	end,
}

local motionPath = "src/ReplicatedStorage/Modules/PlotFishMotion.lua"
local motion = assert(load(
	read(motionPath),
	motionPath,
	"t",
	setmetatable({
		game = { GetService = function(_, name)
			return if name == "Workspace" then workspace else httpService
		end },
		require = function(module)
			return module
		end,
		script = { Parent = {
			PlotPlacementUtil = { CAPACITY = 10 },
			FishingAssets = { GetFish = function(name) return templates[name] end },
			ItemStatUtil = stats,
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
		Position = cframe.Position,
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

do
	-- The HomeLot is a narrow path that overlaps the entrance of the rotated Ground.
	local function partAt(x, y, z, size)
		return boundaryPart(size, frame(groundFrame:PointToWorldSpace(vector.new(x, y, z)), 0.37))
	end
	local function rootAt(x, y, z)
		local cframe = frame(groundFrame:PointToWorldSpace(vector.new(x, y, z)), 0.37)
		return { Position = cframe.Position, CFrame = cframe }
	end
	local function home(lot)
		return {
			FindFirstChild = function(_, name)
				assert(name == "HomeLot")
				return lot
			end,
		}
	end
	local ownLot = home(partAt(-0.34, -0.4, -44.6, vector.new(14.22, 1.78, 40.2)))
	local otherLot = home(partAt(96, -0.4, -44.6, vector.new(14.22, 1.78, 40.2)))
	local homes = { otherLot, ownLot }
	workspaceChildren.RoundPondPrototype = {
		FindFirstChild = function(_, name)
			assert(name == "Homes")
			return { GetChildren = function() return homes end }
		end,
	}
	children.AreaSpawnPoint = partAt(-0.34, 3.72, -49.41, vector.new(2, 1, 2))

	assert(motion.GetEntry(ground, rootAt(-0.34, 3.72, -27), plot), "The inside sample at the entrance must pass")
	local walkwayEntry = assert(motion.GetEntry(ground, rootAt(-0.34, 3.72, -29), plot),
		"The server sample across the entrance must also pass")
	expectVector(walkwayEntry, vector.new(-0.34, 0, -26.5), "The walkway entry must land in the swim area")
	assert(motion.GetEntry(ground, rootAt(-0.34, 3.72, -49.41), plot), "Accept placement at the home spawn")
	assert(not motion.GetEntry(ground, rootAt(8, 3.72, -34), plot), "Reject the public area alongside the path")
	assert(not motion.GetEntry(ground, rootAt(-0.34, 3.72, -74), plot), "Reject the fishing dock beyond the path")
	assert(not motion.GetEntry(ground, rootAt(96, 3.72, -44.6), plot), "Reject other homes")
	assert(not motion.GetEntry(ground, rootAt(-0.34, 30, -49.41), plot), "Keep the existing height limits")

	table.insert(homes, home(partAt(2, -0.4, -49, vector.new(10, 1, 10))))
	assert(not motion.GetEntry(ground, rootAt(-0.34, 3.72, -49.41), plot), "Ambiguous HomeLots must fall back to Ground")
	assert(motion.GetEntry(ground, rootAt(-0.34, 3.72, -27), plot), "Ground placement still works when lots overlap")
	homes = { otherLot }
	assert(not motion.GetEntry(ground, rootAt(-0.34, 3.72, -49.41), plot), "An unmatched spawn must fall back to Ground")
	children.AreaSpawnPoint = nil
	workspaceChildren.RoundPondPrototype = nil
end

local function expectHorizontal(actual, expected, message)
	expectVector(vector.new(actual.X, 0, actual.Z), vector.new(expected.X, 0, expected.Z), message)
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
		assert(math.abs(placed.radius - 4.056 * expected) < 1e-5, "Preserve the final model radius")
		assert(math.abs(placed.height - (ground.Size.Y * 0.5 + 5 + 1.017 * expected)) < 1e-5,
			"Keep the final-sized fish five studs above the ground")
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
templates.Wide = fishTemplate(vector.new(8, 2, 10), 9)
local wide = { Model = "Wide", DefaultWeight = 1, ModelDefaultScale = 2 }
for _, case in {
	{ raw = 60, expected = 60 },
	{ raw = 80, expected = 80 },
	{ raw = 160, expected = 96.6355323334 },
	{ raw = 320, expected = 113.2710646669 },
} do
	local weight = (case.raw / 20) ^ 3
	local scale, rawScale = stats.GetScaleRatio(wide, weight, templates.Wide)
	local placed = motion.GetGeometry(wide, weight, legacy)
	stats.ScaleModel(toolModel, wide, weight, templates.Wide)
	assert(math.abs(rawScale * 10 - case.raw) < 1e-5, "Return the raw weight and base scale")
	assert(math.abs(scale * 10 - case.expected) < 1e-5, "Apply the logarithmic curve only above 80 studs")
	assert(placed.scale == scale and heldScale == 2 * scale, "Held and placed fish must have the same size")
	assert(placed.radius == 9 * scale and placed.radius > 21.5, "Keep the true radius of oversized fish")
end
local largeBase = { ModelDefaultScale = 16, DefaultWeight = 1 }
assert(math.abs(stats.GetScaleRatio(largeBase, 1, templates.Wide) * 10 - 96.6355323334) < 1e-5,
	"Apply the curve when the base model alone exceeds 80 studs")

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
	expectVector(entry, vector.new(0, 0, 26.25), "Clamp the projected placement to the center boundary")
	local preview = motion.GetSurfacePoint(boundary, entry)
	expectVector(boundary.CFrame:PointToObjectSpace(preview), vector.new(0, 1.2, 26.25), "Surface point must use the placement X/Z")

	root.Position = boundary.CFrame:PointToWorldSpace(vector.new(31, 3, 25))
	assert(not motion.GetEntry(boundary, root), "Reject placements originating outside a rotated plot")

	for edge, target in { vector.new(-28.25, 0, 0), vector.new(28.25, 0, 0), vector.new(0, 0, -26.25), vector.new(0, 0, 26.25) } do
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
			assert(math.abs(localPosition.X) <= 28.25 + 1e-5 and math.abs(localPosition.Z) <= 26.25 + 1e-5, "Stay inside the plot")
		end

		local arrivedAt = move.startedAt + move.duration
		assert(not motion.Advance(boundary, move, arrivedAt - 0.01, random), "Keep the current move until arrival")
		local rest = assert(motion.Advance(boundary, move, arrivedAt, random))
		assert(not rest.swimming and rest.duration >= 0.7 and rest.duration <= 1.5, "Rest for the configured time")
		local arrived = motion.Sample(boundary, 4, move, arrivedAt)
		local resting, restWeight = motion.Sample(boundary, 4, rest, rest.startedAt + rest.duration * 0.5)
		expectHorizontal(boundary.CFrame:PointToObjectSpace(arrived.Position), target, "Reach the selected edge")
		expectHorizontal(resting.Position, arrived.Position, "Hold horizontal position while floating at rest")
		expectVector(resting.LookVector, arrived.LookVector, "Hold heading while resting")
		assert(restWeight == 0.25, "Keep only a light tail motion while resting")

		local nextMove = assert(motion.Advance(boundary, rest, rest.startedAt + rest.duration, fixedRandom()))
		assert(nextMove.swimming, "Start swimming again after resting")
		local resumed = motion.Sample(boundary, 4, nextMove, nextMove.startedAt)
		local restEnd = motion.Sample(boundary, 4, rest, nextMove.startedAt)
		expectVector(resumed.Position, restEnd.Position, "Resume at the same position and floating height")
		expectVector(resumed.LookVector, resting.LookVector, "Resume without snapping to the next heading")
	end
end

-- Near the physical ground edge, placing is still allowed and preview/spawn agree.
for _, plotYaw in { 0, 0.37, math.pi / 2 } do
	local boundary = boundaryPart(vector.new(60, 1, 56), frame(vector.new(50, 10, -30), plotYaw))
	for _, x in { -29.9, 29.9 } do
		for _, z in { -27.9, 27.9 } do
			local position = boundary.CFrame:PointToWorldSpace(vector.new(x, 3, z))
			local entry = assert(motion.GetEntry(boundary, { Position = position, CFrame = frame(position, plotYaw) }))
			local preview = boundary.CFrame:PointToObjectSpace(motion.GetSurfacePoint(boundary, entry))
			local move = motion.Start(boundary, entry, 0, fixedRandom(1), 0.7)
			expectVector(move.from, vector.new(preview.X, 0, preview.Z), "Preview and actual spawn must match at corners")
			assert(math.abs(entry.X) <= 28.25 and math.abs(entry.Z) <= 26.25, "Clamp corner placements to the center area")
		end
	end
	for _, outside in { vector.new(30.1, 3, 0), vector.new(0, 3, 28.1) } do
		local position = boundary.CFrame:PointToWorldSpace(outside)
		assert(not motion.GetEntry(boundary, { Position = position, CFrame = frame(position, plotYaw) }),
			"Players outside the physical ground cannot place fish")
	end

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
	local move = motion.Start(boundary, vector.new(29, 0, 27), 0, random, math.pi * 0.75)
	for _ = 1, 100 do
		for index = 0, 40 do
			local pose = motion.Sample(boundary, 4, move, move.startedAt + move.duration * index / 40)
			local center = boundary.CFrame:PointToObjectSpace(pose.Position)
			assert(math.abs(center.X) <= 28.2501 and math.abs(center.Z) <= 26.2501,
				"Center must stay inside while turning, travelling and resting")
		end
		local arrived = motion.Sample(boundary, 4, move, move.startedAt + move.duration)
		move = assert(motion.Advance(boundary, move, move.startedAt + move.duration, random))
		local resumed = motion.Sample(boundary, 4, move, move.startedAt)
		expectVector(arrived.Position, resumed.Position, "Do not jump when changing direction at the edge")
		expectVector(arrived.LookVector, resumed.LookVector, "Do not snap the heading at the edge")
	end
end

-- Weight, size and facing affect the fish appearance, never its center travel area.
local expectedTargets = { vector.new(-28.25, 0, 0), vector.new(28.25, 0, 0), vector.new(0, 0, -26.5), vector.new(0, 0, 26.5) }
local bodyCrossings = 0
for _, name in { "Axolotl", "Slender", "Wide" } do
	for _, multiple in { 1, 8, 1000 } do
		local geometry = assert(motion.GetGeometry({ Model = name, DefaultWeight = 1 }, multiple, ground))
		local metrics = stats.GetModelBounds(geometry.template)
		for _, yaw in { 0, 0.7, math.pi } do
			for edge, target in expectedTargets do
				local move = motion.Start(ground, vector.zero, 0, fixedRandom(edge), yaw)
				expectVector(move.target, target, "Every size and facing must reach the same four center edges")
				local pose = motion.Sample(ground, geometry.height, move, move.duration)
				local center = ground.CFrame:PointToObjectSpace(pose.Position)
				expectHorizontal(center, target, "Reach the center limit independently of floating height")
				local bottomGap = center.Y + metrics.bottom * geometry.scale - ground.Size.Y / 2
				assert(bottomGap >= 3.8 - 1e-5 and bottomGap <= 6.2 + 1e-5,
					"Every model size must float 3.8 to 6.2 studs above the ground")
				local forward = ground.CFrame:VectorToObjectSpace(pose.LookVector)
				for _, x in { metrics.minimum.X * geometry.scale, metrics.maximum.X * geometry.scale } do
					for _, z in { metrics.minimum.Z * geometry.scale, metrics.maximum.Z * geometry.scale } do
						local corner = center + vector.new(-forward.Z * x - forward.X * z, 0, forward.X * x - forward.Z * z)
						if math.abs(corner.X) > 30 or math.abs(corner.Z) > 28.25 then bodyCrossings += 1 end
					end
				end
			end
		end
	end
end
assert(bodyCrossings > 0, "Large fish bodies must be allowed to extend beyond the ground")

-- Preserve the 20% edge selection threshold.
for _, chance in { 0.199, 0.2 } do
	local edgeDraws = 0
	local random = fixedRandom()
	local nextNumber = random.NextNumber
	function random:NextNumber(low, high)
		return if low == nil then chance else nextNumber(self, low, high)
	end
	function random:NextInteger()
		edgeDraws += 1
		return 1
	end
	motion.Start(ground, vector.zero, 0, random)
	assert((edgeDraws > 0) == (chance < 0.2), "Only draws below 20% select an edge")
end

local tiny = boundaryPart(vector.new(2, 1, 4), frame(vector.zero, 0))
local centeredRandom = fixedRandom()
local draws = 0
local nextNumber = centeredRandom.NextNumber
function centeredRandom:NextNumber(min, max)
	if min == -0.25 then draws += 1 end
	return nextNumber(self, min, max)
end
local fallback = motion.Start(tiny, vector.new(3, 0, 0), 0, centeredRandom)
assert(draws == 8, "Limit attempts when all candidate targets are too close")
expectVector(fallback.from, vector.zero, "A collapsed X axis must stay at the center")
expectVector(fallback.target, vector.new(0, 0, -0.25), "Fall back to the farthest allowed point")
local narrow = boundaryPart(vector.new(4, 1, 2), frame(vector.zero, 0))
expectVector(motion.Start(narrow, vector.zero, 0, fixedRandom(2)).target, vector.new(0.25, 0, 0),
	"A collapsed Z axis must still allow movement on X")
for _, size in { vector.new(2, 1, 3), vector.new(3.5, 1, 3.5) } do
	local boundary = boundaryPart(size, frame(vector.zero, 0))
	local noRoom = motion.Start(boundary, vector.new(20, 0, 20), 50, fixedRandom(1), math.pi)
	assert(not noRoom.swimming and noRoom.duration > 0, "No travel room must produce a positive-duration idle")
	expectVector(noRoom.from, vector.zero, "Center a fish with no room to swim")
	local resumed = assert(motion.Advance(boundary, noRoom, 50 + noRoom.duration, fixedRandom(1)))
	assert(not resumed.swimming and resumed.duration > 0, "Continue idling safely in a collapsed area")
end
local edgeEntry = vector.new(100, 0, -100)
local restored = motion.Start(legacy, edgeEntry, 50, fixedRandom(1), math.pi)
expectVector(restored.from, vector.new(20.75, 0, -20.75), "Restored entries use the same fixed inset on the legacy boundary")
local preview = motion.GetSurfacePoint(legacy, edgeEntry)
expectVector(legacy.CFrame:PointToObjectSpace(preview), vector.new(20.75, 1.2, -20.75), "Legacy preview uses the fixed center inset")

-- Floating uses one shared clock, independent of move timing or display lifetime.
local floatBoundary = boundaryPart(vector.new(60, 1, 56), frame(vector.new(80, 10, -20), 0.37))
local floatMove = motion.Start(floatBoundary, vector.zero, 0, fixedRandom(1), 0.7)
local uid = "fish-7a03648b"
local floatPhase = motion.GetFloatPhase(uid)
assert(floatPhase >= 0 and floatPhase < 2 * math.pi, "Map fish IDs into one floating cycle")
assert(floatPhase == motion.GetFloatPhase(uid), "Display recreation must preserve the same phase")
assert(math.abs(motion.GetFloatPhase("fish-1") - motion.GetFloatPhase("fish-2")) > 0.1,
	"Similar fish IDs must not float in lockstep")
for time, offset in { [0] = 0, [1.5] = 1.2, [3] = 0, [4.5] = -1.2, [6] = 0 } do
	local pose = motion.Sample(floatBoundary, 7, floatMove, time, 0)
	local localPosition = floatBoundary.CFrame:PointToObjectSpace(pose.Position)
	assert(math.abs(localPosition.Y - 7 - offset) < 1e-5, "Float by 1.2 studs over a six-second cycle")
end
for _, time in { 0, 0.37, 3, 6, 1794812000.25 } do
	local pose = motion.Sample(floatBoundary, 7, floatMove, time, floatPhase)
	local repeated = motion.Sample(floatBoundary, 7, floatMove, time + 6, floatPhase)
	assert(math.abs(pose.Position.Y - repeated.Position.Y) < 1e-5, "Floating must repeat every six seconds at server epoch times")
	local decoded = assert(motion.Decode(motion.Encode(floatMove)))
	local recreated = motion.Sample(floatBoundary, 7, decoded, time, motion.GetFloatPhase(uid))
	expectVector(pose.Position, recreated.Position, "Clients must agree on floating after decoding or recreation")
	local defaultPhase = motion.Sample(floatBoundary, 7, floatMove, time)
	local zeroPhase = motion.Sample(floatBoundary, 7, floatMove, time, 0)
	expectVector(defaultPhase.Position, zeroPhase.Position, "Omitted floating phase must default to zero")
end
local stopAt = floatMove.startedAt + floatMove.duration
local floatRest = assert(motion.Advance(floatBoundary, floatMove, stopAt, fixedRandom(1)))
local beforeRest = motion.Sample(floatBoundary, 7, floatMove, stopAt, floatPhase)
local afterRest = motion.Sample(floatBoundary, 7, floatRest, stopAt, floatPhase)
expectVector(beforeRest.Position, afterRest.Position, "Floating must not reset when movement becomes idle")
local idleStart = motion.Sample(floatBoundary, 7, floatRest, 0, 0)
local idlePeak = motion.Sample(floatBoundary, 7, floatRest, 1.5, 0)
expectHorizontal(idleStart.Position, idlePeak.Position, "Idle fish stay in place horizontally")
assert(math.abs(idlePeak.Position.Y - idleStart.Position.Y - 1.2) < 1e-5, "Idle fish must continue floating")
local restartAt = floatRest.startedAt + floatRest.duration
local floatNext = assert(motion.Advance(floatBoundary, floatRest, restartAt, fixedRandom(2)))
local beforeRestart = motion.Sample(floatBoundary, 7, floatRest, restartAt, floatPhase)
local afterRestart = motion.Sample(floatBoundary, 7, floatNext, restartAt, floatPhase)
expectVector(beforeRestart.Position, afterRestart.Position, "Floating must not reset when idle becomes movement")
expectVector(beforeRestart.LookVector, afterRestart.LookVector, "Floating must not change the heading")

print("PlotFishMotion.test.lua passed")
