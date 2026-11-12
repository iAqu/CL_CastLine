local HttpService = game:GetService("HttpService")

local FishingAssets = require(script.Parent.FishingAssets)
local ItemStatUtil = require(script.Parent.ItemStatUtil)
local FishSwimBounds = require(script.Parent.FishSwimBounds)

local PlotPlacementUtil = require(script.Parent.PlotPlacementUtil)

local PlotFishMotion = {
	CAPACITY = PlotPlacementUtil.CAPACITY,
	FOLDER_NAME = "PlacedFish",
	MOVE_ATTRIBUTE = "MoveState",
}

export type Move = {
	from: Vector3,
	target: Vector3,
	fromYaw: number,
	targetYaw: number,
	startedAt: number,
	duration: number,
	swimming: boolean,
}

export type Footprint = {
	minimum: Vector3,
	maximum: Vector3,
	radius: number,
}

type Bounds = Footprint | number

function PlotFishMotion.GetBoundary(plot: Instance): BasePart?
	local ground = plot:FindFirstChild("Ground")
	if ground and ground:IsA("BasePart") then
		return ground
	end

	local part = plot:FindFirstChild("3")
	return if part and part:IsA("BasePart") then part else nil
end

function PlotFishMotion.GetGeometry(item, weight: number, boundary: BasePart)
	local template = FishingAssets.GetFish(item.Model)
	if not template then
		return nil
	end
	local metrics = ItemStatUtil.GetModelBounds(template)
	local scale = ItemStatUtil.GetScaleRatio(item, weight, template)
	local animations = template:FindFirstChild("Animations")
	local swim = animations and animations:FindFirstChild("SwimLoop")
	local envelope = swim and FishSwimBounds[template.PrimaryPart.MeshId .. "/" .. swim.AnimationId]
	local footprint
	if envelope then
		footprint = {
			minimum = Vector3.new(math.min(metrics.minimum.X, envelope[1]), 0, math.min(metrics.minimum.Z, envelope[3])) * scale,
			maximum = Vector3.new(math.max(metrics.maximum.X, envelope[2]), 0, math.max(metrics.maximum.Z, envelope[4])) * scale,
			radius = math.max(metrics.radius, envelope[5]) * scale,
		}
	else
		-- Unknown animated models keep the conservative circular boundary.
		footprint = metrics.radius * scale
	end
	return {
		template = template,
		scale = scale,
		radius = metrics.radius * scale,
		footprint = footprint,
		height = boundary.Size.Y * 0.5 + 1.25 - metrics.bottom * scale,
	}
end

local function getSwimLimits(boundary: BasePart, footprint: Bounds?, yaw: number?): (number, number, number, number)
	local halfX, halfZ = boundary.Size.X * 0.5, boundary.Size.Z * 0.5
	local minX, maxX, minZ, maxZ
	if typeof(footprint) == "table" then
		local cosine, sine = math.cos(yaw or 0), math.sin(yaw or 0)
		local low, high = footprint.minimum, footprint.maximum
		local centerX, centerZ = (low.X + high.X) * 0.5, (low.Z + high.Z) * 0.5
		local extentX, extentZ = (high.X - low.X) * 0.5, (high.Z - low.Z) * 0.5
		local x, z = cosine * centerX + sine * centerZ, -sine * centerX + cosine * centerZ
		local width = math.abs(cosine) * extentX + math.abs(sine) * extentZ
		local depth = math.abs(sine) * extentX + math.abs(cosine) * extentZ
		-- Both envelopes contain every pose: their tighter support is still safe.
		minX, maxX = math.max(x - width, -footprint.radius), math.min(x + width, footprint.radius)
		minZ, maxZ = math.max(z - depth, -footprint.radius), math.min(z + depth, footprint.radius)
	else
		local radius = footprint or 0
		minX, maxX, minZ, maxZ = -radius, radius, -radius, radius
	end
	return math.min(-halfX - minX, 0), math.max(halfX - maxX, 0),
		math.min(-halfZ - minZ, 0), math.max(halfZ - maxZ, 0)
end

local function clampToPlot(position: Vector3, halfX: number, halfZ: number): Vector3
	return Vector3.new(math.clamp(position.X, -halfX, halfX), 0, math.clamp(position.Z, -halfZ, halfZ))
end

local function clampToFootprint(boundary: BasePart, position: Vector3, footprint: Bounds?, yaw: number?): Vector3
	local minX, maxX, minZ, maxZ = getSwimLimits(boundary, footprint, yaw)
	return Vector3.new(math.clamp(position.X, minX, maxX), 0, math.clamp(position.Z, minZ, maxZ))
end

local function fitTarget(boundary: BasePart, from: Vector3, target: Vector3, footprint: Bounds?): Vector3?
	local direction = target - from
	local distance = direction.Magnitude
	if distance < 0.00001 then
		return nil
	end
	direction = direction * (1 / distance)
	local yaw = math.atan2(-direction.X, -direction.Z)
	local minX, maxX, minZ, maxZ = getSwimLimits(boundary, footprint, yaw)
	local enter, leave = 0, distance
	for _, axis in { { from.X, direction.X, minX, maxX }, { from.Z, direction.Z, minZ, maxZ } } do
		local at, speed, low, high = table.unpack(axis)
		if math.abs(speed) < 0.00001 then
			if at < low or at > high then
				return nil
			end
		else
			local a, b = (low - at) / speed, (high - at) / speed
			enter, leave = math.max(enter, math.min(a, b)), math.min(leave, math.max(a, b))
		end
	end
	return if leave >= enter and leave > 0 then from + direction * leave else nil
end

function PlotFishMotion.GetEntry(boundary: BasePart, root: BasePart): Vector3?
	local position = boundary.CFrame:PointToObjectSpace(root.Position)
	local half = boundary.Size * 0.5
	if
		math.abs(position.X) > half.X
		or math.abs(position.Z) > half.Z
		or position.Y < -2
		or position.Y > half.Y + 10
	then
		return nil
	end
	local forward = boundary.CFrame:VectorToObjectSpace(root.CFrame.LookVector)
	local horizontal = Vector3.new(forward.X, 0, forward.Z)
	local projected = position + (if horizontal.Magnitude > 0.01 then horizontal.Unit * 5 else Vector3.zero)
	return clampToPlot(projected, half.X, half.Z)
end

local function pickTarget(halfX: number, halfZ: number, from: Vector3, random: Random): Vector3
	local minDistance = math.min(8, Vector2.new(halfX, halfZ).Magnitude * 0.5)
	local aimForEdge = random:NextNumber() < 0.2
	for _ = 1, 8 do
		local x = random:NextNumber(-halfX, halfX)
		local z = random:NextNumber(-halfZ, halfZ)
		if aimForEdge then
			local edge = random:NextInteger(1, 4)
			if edge <= 2 then
				x = if edge == 1 then -halfX else halfX
			else
				z = if edge == 3 then -halfZ else halfZ
			end
		end
		local target = Vector3.new(x, 0, z)
		if (target - from).Magnitude >= minDistance then
			return target
		end
	end
	return Vector3.new(if from.X >= 0 then -halfX else halfX, 0, if from.Z >= 0 then -halfZ else halfZ)
end

function PlotFishMotion.Start(
	boundary: BasePart,
	entry: Vector3,
	now: number,
	random: Random,
	yaw: number?,
	footprint: Bounds?
): Move
	local from = clampToFootprint(boundary, entry, footprint, yaw)
	local target
	if typeof(footprint) == "table" then
		for _ = 1, 8 do
			local candidate = pickTarget(boundary.Size.X * 0.5, boundary.Size.Z * 0.5, from, random)
			target = fitTarget(boundary, from, candidate, footprint)
			if target then
				break
			end
		end
		target = target or fitTarget(boundary, from, Vector3.zero, footprint) or from
	else
		local _, halfX, _, halfZ = getSwimLimits(boundary, footprint)
		target = if halfX > 0 or halfZ > 0 then pickTarget(halfX, halfZ, from, random) else from
	end
	local direction = target - from
	local distance = direction.Magnitude
	local swimming = distance > 0
	local targetYaw = if swimming then math.atan2(-direction.X, -direction.Z) else yaw or 0
	return {
		from = from,
		target = target,
		fromYaw = yaw or (if typeof(footprint) == "table" then 0 else targetYaw),
		targetYaw = targetYaw,
		startedAt = now,
		duration = if swimming then distance / random:NextNumber(5, 7) else random:NextNumber(0.7, 1.5),
		swimming = swimming,
	}
end

function PlotFishMotion.Advance(boundary: BasePart, move: Move, now: number, random: Random, footprint: Bounds?): Move?
	if now < move.startedAt + move.duration then
		return nil
	end
	if not move.swimming then
		return PlotFishMotion.Start(boundary, move.target, now, random, move.targetYaw, footprint)
	end
	return {
		from = move.target,
		target = move.target,
		fromYaw = move.targetYaw,
		targetYaw = move.targetYaw,
		startedAt = now,
		duration = random:NextNumber(0.7, 1.5),
		swimming = false,
	}
end

local function smooth(alpha: number): number
	return alpha * alpha * (3 - 2 * alpha)
end

function PlotFishMotion.Sample(boundary: BasePart, height: number, move: Move, now: number, footprint: Bounds?): (CFrame, number)
	local elapsed = math.max(0, now - move.startedAt)
	local alpha = math.clamp(elapsed / move.duration, 0, 1)
	local turnAlpha = math.clamp(elapsed / math.min(0.4, move.duration), 0, 1)
	local deltaYaw = (move.targetYaw - move.fromYaw + math.pi) % (2 * math.pi) - math.pi
	local yaw = move.fromYaw + deltaYaw * smooth(turnAlpha)
	local center = clampToFootprint(boundary, move.from + (move.target - move.from) * smooth(alpha), footprint, yaw)
	local position = center + Vector3.new(0, height, 0)
	local forward = Vector3.new(-math.sin(yaw), 0, -math.cos(yaw))
	local swimWeight = if move.swimming then math.min(1, 6 * alpha * (1 - alpha)) else 0
	return boundary.CFrame * CFrame.lookAt(position, position + forward), 0.25 + 0.75 * swimWeight
end

-- One attribute keeps the time, heading and endpoints of each move together when replicated.
function PlotFishMotion.Encode(move: Move): string
	return HttpService:JSONEncode({
		move.from.X,
		move.from.Z,
		move.target.X,
		move.target.Z,
		move.fromYaw,
		move.targetYaw,
		move.startedAt,
		move.duration,
		move.swimming,
	})
end

function PlotFishMotion.Decode(encoded: unknown): Move?
	if typeof(encoded) ~= "string" then
		return nil
	end
	local fields = HttpService:JSONDecode(encoded)
	return {
		from = Vector3.new(fields[1], 0, fields[2]),
		target = Vector3.new(fields[3], 0, fields[4]),
		fromYaw = fields[5],
		targetYaw = fields[6],
		startedAt = fields[7],
		duration = fields[8],
		swimming = fields[9],
	}
end

function PlotFishMotion.GetSurfacePoint(boundary: BasePart, point: Vector3, footprint: Bounds?): Vector3
	local center = clampToFootprint(boundary, point, footprint, 0)
	return boundary.CFrame:PointToWorldSpace(center + Vector3.new(0, boundary.Size.Y * 0.5 + 0.7, 0))
end

return PlotFishMotion
