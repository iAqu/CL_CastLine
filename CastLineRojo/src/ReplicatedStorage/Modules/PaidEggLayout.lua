local Layout = {}

-- Signed distance from the model's center to the tighter side of each view plane.
function Layout.GetFishScale(depth, focal, x, y, halfWidth, halfHeight, bounds, outlinePixels, outlineScale)
	local edgeX = (math.abs(x) + halfWidth) / focal
	local edgeY = (math.abs(y) + halfHeight) / focal
	local distanceX = depth * halfWidth / focal
	local distanceY = depth * halfHeight / focal
	local frustumX = math.sqrt(1 + edgeX * edgeX)
	local frustumY = math.sqrt(1 + edgeY * edgeY)
	local originalScale = math.min(distanceX / frustumX, distanceY / frustumY) * 0.96 / bounds.Radius

	-- A cylinder bounds the fish at every yaw angle. Fit the enlarged
	-- silhouette too, including the narrowest view plane.
	local margin = depth * (outlinePixels + 1) / focal
	local fitX = (distanceX - margin) / (bounds.HorizontalRadius * frustumX)
	local fitY = (distanceY - margin) / (bounds.HalfHeight + edgeY * bounds.HorizontalRadius)
	local maximum = math.max(0, math.min(fitX, fitY) / (outlineScale or 1))
	return math.min(originalScale * 1.3, maximum), maximum
end

-- Each cell owns its entire rotating visual and a separate caption below it.
function Layout.Get(count, width, height)
	local narrow = width / height < 1.2
	local columns = if count == 10 then (if narrow then 3 else 5) else count
	local rows = math.ceil(count / columns)
	local cellWidth = 0.92 / columns
	local cellHeight = if count == 10 then 0.76 / rows else 0.64
	local top = if count == 10 then 0.08 else 0.13
	local cells = {}
	for index = 1, count do
		local row = math.floor((index - 1) / columns)
		local column = (index - 1) % columns
		local inRow = math.min(columns, count - row * columns)
		local x = 0.5 + (column - (inRow - 1) / 2) * cellWidth
		local visualHeight = cellHeight * (if count == 10 then 0.64 else 0.72)
		cells[index] = {
			X = x,
			Y = top + row * cellHeight,
			Width = cellWidth * (if count == 10 then 0.93 else 0.88),
			VisualHeight = visualHeight,
			CaptionHeight = cellHeight - visualHeight,
		}
	end
	return cells
end

return Layout
