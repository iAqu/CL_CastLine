local SurfaceGeometryUtil = {}

function SurfaceGeometryUtil.GetTopSurfaceLowestY(part: BasePart): number
	local halfSize = part.Size * 0.5
	local lowestY = math.huge

	for _, xSign in ipairs({ -1, 1 }) do
		for _, zSign in ipairs({ -1, 1 }) do
			local corner = part.CFrame:PointToWorldSpace(Vector3.new(
				halfSize.X * xSign,
				halfSize.Y,
				halfSize.Z * zSign
			))
			lowestY = math.min(lowestY, corner.Y)
		end
	end

	return lowestY
end

return table.freeze(SurfaceGeometryUtil)
