local PlotCashPoolSweepUtil = {}

local AXES = { "X", "Y", "Z" }
local EPSILON = 1e-8

function PlotCashPoolSweepUtil.SegmentIntersectsLocalBox(startPoint, endPoint, halfExtents)
	local minimumAlpha = 0
	local maximumAlpha = 1

	for _, axis in ipairs(AXES) do
		local startValue = startPoint[axis]
		local delta = endPoint[axis] - startValue
		local extent = math.max(0, halfExtents[axis])
		if math.abs(delta) <= EPSILON then
			if startValue < -extent or startValue > extent then
				return false
			end
		else
			local entryAlpha = (-extent - startValue) / delta
			local exitAlpha = (extent - startValue) / delta
			if entryAlpha > exitAlpha then
				entryAlpha, exitAlpha = exitAlpha, entryAlpha
			end
			minimumAlpha = math.max(minimumAlpha, entryAlpha)
			maximumAlpha = math.min(maximumAlpha, exitAlpha)
			if minimumAlpha > maximumAlpha then
				return false
			end
		end
	end

	return true
end

function PlotCashPoolSweepUtil.SegmentIntersectsOrientedBox(
	startPosition,
	endPosition,
	boxCFrame,
	boxSize,
	padding
)
	local localStart = boxCFrame:PointToObjectSpace(startPosition)
	local localEnd = boxCFrame:PointToObjectSpace(endPosition)
	local halfExtents = boxSize * 0.5 + padding
	return PlotCashPoolSweepUtil.SegmentIntersectsLocalBox(localStart, localEnd, halfExtents)
end

return PlotCashPoolSweepUtil
