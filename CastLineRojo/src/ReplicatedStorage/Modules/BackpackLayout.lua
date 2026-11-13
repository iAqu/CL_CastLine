-- Pure layout and drop policy. Logical hotbar slots always remain 1..10.
local BackpackLayout = {}

function BackpackLayout.Compute(width, height, touchOnly)
	width, height = math.max(1, width), math.max(1, height)
	local phone = touchOnly and math.min(width, height) < 500
	local count = touchOnly and 7 or 10
	local scale = math.max(0.45, math.min(height / 692, 2.5))
	local margin = math.max(8, math.floor(8 * scale))
	local availableWidth = math.max(1, width - margin * 2)
	local desired = touchOnly and height * (phone and 0.15 or 0.11) or 56 * scale
	desired = math.max(touchOnly and 44 or 36, math.min(desired, touchOnly and 72 or 84))
	local gap = math.max(3, math.floor(desired * 0.09))
	local icon = math.max(1, math.floor(math.min(desired, (availableWidth - gap * (count + 1)) / count)))
	gap = math.max(3, math.floor(icon * 0.09))
	local hotbarWidth = math.min(availableWidth, count * icon + gap * (count + 1))
	local hotbarHeight = icon + gap * 2
	local hotbarY = math.max(0, height - margin - hotbarHeight)
	local panelWidth = math.floor(math.min(availableWidth, math.max(hotbarWidth, width * (touchOnly and 0.9 or 0.55))))
	local panelHeight = math.max(1, math.floor(math.min(height * (phone and 0.62 or 0.42), hotbarY - margin - gap)))
	return {
		TouchOnly = touchOnly,
		Phone = phone,
		VisibleSlots = count,
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
