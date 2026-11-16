local Placement = { MAX_DISTANCE = 30, INTERACT_DISTANCE = 12, GAP = 0.5 }

function Placement.IsFinite(value)
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end

function Placement.Check(x, z, radius, halfX, halfZ, neighbors)
	if not Placement.IsFinite(x) or not Placement.IsFinite(z) then
		return false, "Invalid position"
	end
	if math.abs(x) + radius > halfX or math.abs(z) + radius > halfZ then
		return false, "Place the egg inside your home"
	end
	for _, other in ipairs(neighbors) do
		local dx, dz = x - other.X, z - other.Z
		if dx * dx + dz * dz < (radius + other.Radius + Placement.GAP) ^ 2 then
			return false, "This space is occupied by another egg"
		end
	end
	return true
end

return Placement
