local ItemBoundsUtil = {}

local function includePartPoint(minimum: Vector3?, maximum: Vector3?, point: Vector3): (Vector3?, Vector3?)
	if minimum and maximum then
		return Vector3.new(
			math.min(minimum.X, point.X),
			math.min(minimum.Y, point.Y),
			math.min(minimum.Z, point.Z)
		), Vector3.new(
			math.max(maximum.X, point.X),
			math.max(maximum.Y, point.Y),
			math.max(maximum.Z, point.Z)
		)
	end
	return point, point
end

function ItemBoundsUtil.GetWorldAxisBounds(root: Instance): (CFrame, Vector3)
	local minimum: Vector3? = nil
	local maximum: Vector3? = nil

	local function includePart(part: BasePart)
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local point = part.CFrame:PointToWorldSpace(Vector3.new(
						part.Size.X * x * 0.5,
						part.Size.Y * y * 0.5,
						part.Size.Z * z * 0.5
					))
					minimum, maximum = includePartPoint(minimum, maximum, point)
				end
			end
		end
	end

	if root:IsA("BasePart") then
		includePart(root)
	end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("BasePart") then
			includePart(descendant)
		end
	end

	if not minimum or not maximum then
		if root:IsA("Model") then
			return root:GetBoundingBox()
		end
		return CFrame.new(), Vector3.zero
	end

	local center = (minimum + maximum) * 0.5
	local size = maximum - minimum
	return CFrame.new(center), size
end

return ItemBoundsUtil
