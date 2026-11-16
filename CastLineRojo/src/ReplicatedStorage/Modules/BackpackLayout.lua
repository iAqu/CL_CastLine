-- Pure layout and drop policy. Logical hotbar slots always remain 1..10.
local BackpackLayout = {}
local GRID_SIDE_PADDING = 18

function BackpackLayout.Compute(width, height, touchOnly)
	width, height = math.max(1, width), math.max(1, height)
	local phone = touchOnly and math.min(width, height) < 500
	local count = touchOnly and 7 or 10
	local scale = math.max(0.45, math.min(height / 692, 2.5))
	local margin = math.max(8, math.floor(8 * scale))
	local availableWidth = math.max(1, width - margin * 2)
	local desired = touchOnly and height * (phone and 0.15 or 0.11) or 56 * scale
	desired = math.max(touchOnly and 44 or 36, math.min(desired, touchOnly and 72 or 84))
	-- Fit the complete row and panel padding before sizing either container.
	local icon = math.max(1, math.floor(desired))
	local gap, gridWidth
	repeat
		gap = math.max(3, math.floor(icon * 0.09))
		gridWidth = count * icon + (count - 1) * gap
		if gridWidth + GRID_SIDE_PADDING * 2 <= availableWidth or icon == 1 then
			break
		end
		icon = icon - 1
	until false
	local hotbarWidth = gridWidth + gap * 2
	local hotbarHeight = icon + gap * 2
	local hotbarY = math.max(0, height - margin - hotbarHeight)
	local panelWidth = gridWidth + GRID_SIDE_PADDING * 2
	local panelHeight = math.max(1, math.floor(math.min(height * (phone and 0.62 or 0.42), hotbarY - margin - gap)))
	return {
		TouchOnly = touchOnly,
		Phone = phone,
		VisibleSlots = count,
		GridColumns = count,
		GridWidth = gridWidth,
		GridOffsetX = GRID_SIDE_PADDING,
		IconSize = icon,
		Gap = gap,
		Margin = margin,
		HeaderHeight = 56,
		HotbarWidth = hotbarWidth,
		HotbarHeight = hotbarHeight,
		HotbarY = hotbarY,
		PanelWidth = panelWidth,
		PanelHeight = panelHeight,
		PanelY = math.max(margin, hotbarY - gap - panelHeight),
	}
end

function BackpackLayout.CanvasHeight(itemCount, layout)
	local rows = math.ceil(itemCount / layout.GridColumns)
	if rows == 0 then
		return 0
	end
	return rows * layout.IconSize + (rows - 1) * layout.Gap + 8
end

function BackpackLayout.IsInventorySlot(index, visibleSlots)
	return index > visibleSlots
end

function BackpackLayout.DropAction(sourceIndex, targetIndex, inInventory, visibleSlots)
	if targetIndex and targetIndex >= 1 and targetIndex <= visibleSlots then
		if sourceIndex == targetIndex then
			return "Cancel"
		end
		if sourceIndex > visibleSlots and sourceIndex <= 10 then
			return "MoveReserved"
		end
		return "Swap"
	end
	if inInventory and sourceIndex <= visibleSlots then
		return "MoveToInventory"
	end
	return "Cancel"
end

return BackpackLayout
