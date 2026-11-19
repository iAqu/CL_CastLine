local HttpService = game:GetService("HttpService")

local FishingAssets = require(script.Parent.FishingAssets)
local ItemStatUtil = require(script.Parent.ItemStatUtil)

local PlotFishMotion = {
	FOLDER_NAME = "PlacedFish",
	MOVE_ATTRIBUTE = "MoveState",
}

-- Match StealEgg: constrain the body center, allowing fins and tails past the fence.
local EDGE_INSET = 1.75
local FLOAT_HEIGHT = 5
local FLOAT_AMPLITUDE = 0.5
local FLOAT_PERIOD = 6

export type Move = {
	from: Vector3,
	target: Vector3,
	fromYaw: number,
	targetYaw: number,
	startedAt: number,
	duration: number,
	swimming: boolean,
}

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
	return {
		template = template,
		scale = scale,
		radius = metrics.radius * scale,
		height = boundary.Size.Y * 0.5 + FLOAT_HEIGHT - metrics.bottom * scale,
	}
end

local function getSwimLimits(boundary: BasePart): (number, number)
	return math.max(boundary.Size.X * 0.5 - EDGE_INSET, 0), math.max(boundary.Size.Z * 0.5 - EDGE_INSET, 0)
end

local function clampToPlot(position: Vector3, halfX: number, halfZ: number): Vector3
	return Vector3.new(math.clamp(position.X, -halfX, halfX), 0, math.clamp(position.Z, -halfZ, halfZ))
end

local function clampToSwimArea(boundary: BasePart, position: Vector3): Vector3
	local halfX, halfZ = getSwimLimits(boundary)
	return clampToPlot(position, halfX, halfZ)
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
	return clampToSwimArea(boundary, projected)
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
	yaw: number?
): Move
	local halfX, halfZ = getSwimLimits(boundary)
	local from = clampToPlot(entry, halfX, halfZ)
	local target = if halfX > 0 or halfZ > 0 then pickTarget(halfX, halfZ, from, random) else from
	local direction = target - from
	local distance = direction.Magnitude
	local swimming = distance > 0
	local targetYaw = if swimming then math.atan2(-direction.X, -direction.Z) else yaw or 0
	return {
		from = from,
		target = target,
		fromYaw = yaw or 0,
		targetYaw = targetYaw,
		startedAt = now,
		duration = if swimming then distance / random:NextNumber(5, 7) else random:NextNumber(0.7, 1.5),
		swimming = swimming,
	}
end

function PlotFishMotion.Advance(boundary: BasePart, move: Move, now: number, random: Random): Move?
	if now < move.startedAt + move.duration then
		return nil
	end
	if not move.swimming then
		return PlotFishMotion.Start(boundary, move.target, now, random, move.targetYaw)
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

function PlotFishMotion.GetFloatPhase(uid: string): number
	local hash = 0
	for index = 1, #uid do
		hash = (hash * 31 + string.byte(uid, index)) % 65521
	end
	-- Spread similar IDs across the cycle, including IDs differing only in their suffix.
	return ((hash * 48271) % 65521) / 65521 * 2 * math.pi
end

function PlotFishMotion.Sample(boundary: BasePart, height: number, move: Move, now: number, floatPhase: number?): (CFrame, number)
	local elapsed = math.max(0, now - move.startedAt)
	local alpha = math.clamp(elapsed / move.duration, 0, 1)
	local turnAlpha = math.clamp(elapsed / math.min(0.4, move.duration), 0, 1)
	local deltaYaw = (move.targetYaw - move.fromYaw + math.pi) % (2 * math.pi) - math.pi
	local yaw = move.fromYaw + deltaYaw * smooth(turnAlpha)
	local center = clampToSwimArea(boundary, move.from + (move.target - move.from) * smooth(alpha))
	-- Absolute server time keeps floating continuous through moves, rests and display recreation.
	local floatOffset = FLOAT_AMPLITUDE * math.sin((now % FLOAT_PERIOD) / FLOAT_PERIOD * 2 * math.pi + (floatPhase or 0))
	local position = center + Vector3.new(0, height + floatOffset, 0)
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

function PlotFishMotion.GetSurfacePoint(boundary: BasePart, point: Vector3): Vector3
	local center = clampToSwimArea(boundary, point)
	return boundary.CFrame:PointToWorldSpace(center + Vector3.new(0, boundary.Size.Y * 0.5 + 0.7, 0))
end

return PlotFishMotion
