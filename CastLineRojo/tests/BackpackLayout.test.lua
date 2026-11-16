local Layout = dofile("src/ReplicatedStorage/Modules/BackpackLayout.lua")
local devices = {
	{ 1920, 1022, false },
	{ 1280, 662, false },
	{ 640, 422, false },
	{ 320, 510, false },
	{ 1871, 776, false },
	{ 874, 344, true },
	{ 402, 816, true },
	{ 667, 317, true },
	{ 320, 510, true },
	{ 1194, 776, true },
	{ 834, 1136, true },
}
for _, device in ipairs(devices) do
	local w, h, touch = device[1], device[2], device[3]
	local m = Layout.Compute(w, h, touch)
	assert(m.VisibleSlots == (touch and 7 or 10))
	assert(m.GridColumns == m.VisibleSlots)
	assert(m.GridWidth == m.GridColumns * m.IconSize + (m.GridColumns - 1) * m.Gap)
	assert(m.PanelWidth == m.GridWidth + 36 and m.GridOffsetX == 18)
	assert(m.GridOffsetX + m.GridWidth <= m.PanelWidth - 6, "The scrollbar cannot consume a column")
	for column = 1, m.GridColumns do
		local inventoryX = (w - m.PanelWidth) / 2 + m.GridOffsetX + (column - 1) * (m.IconSize + m.Gap)
		local hotbarX = (w - m.HotbarWidth) / 2
			+ m.HotbarWidth / 2
			- m.IconSize / 2
			+ (m.IconSize + m.Gap) * (column - (m.VisibleSlots / 2 + 0.5))
		assert(math.abs(inventoryX - hotbarX) <= 1, "Every column aligns with the expanded hotbar")
	end
	for _, count in ipairs({ 0, 1, m.GridColumns, m.GridColumns + 1, m.GridColumns * 5 + 3 }) do
		local height = Layout.CanvasHeight(count, m)
		if count == 0 then
			assert(height == 0)
		else
			local lastRow = math.floor((count - 1) / m.GridColumns)
			local lastBottom = lastRow * (m.IconSize + m.Gap) + m.IconSize
			assert(height == lastBottom + 8, "The canvas includes the complete final row and bottom padding")
		end
	end
	assert(m.IconSize > 0 and m.PanelHeight > m.HeaderHeight)
	assert(m.HotbarWidth <= w - m.Margin * 2)
	assert(m.VisibleSlots * m.IconSize + (m.VisibleSlots + 1) * m.Gap <= m.HotbarWidth)
	assert(m.PanelWidth <= w - m.Margin * 2)
	assert(m.PanelY >= m.Margin)
	assert(m.PanelY + m.PanelHeight <= m.HotbarY - m.Gap)
	assert(m.HotbarY + m.HotbarHeight <= h - m.Margin)
	assert(m.PanelWidth - 56 > 44, "Header must leave room for the close button")
end
assert(Layout.Compute(874, 344, true).Phone, "Landscape phones use their short side")
assert(not Layout.Compute(1194, 776, true).Phone, "Tablets must not use phone classification")
assert(Layout.Compute(402, 816, true).IconSize >= 44)
assert(Layout.Compute(874, 344, true).IconSize >= 44)
assert(Layout.DropAction(1, 2, false, 10) == "Swap")
assert(Layout.DropAction(11, 2, false, 10) == "Swap")
assert(Layout.DropAction(8, 2, false, 7) == "MoveReserved")
assert(Layout.DropAction(10, 7, false, 7) == "MoveReserved")
assert(Layout.DropAction(8, 2, false, 10) == "Swap")
assert(Layout.DropAction(1, nil, true, 7) == "MoveToInventory")
assert(Layout.DropAction(1, nil, false, 7) == "Cancel")
assert(Layout.DropAction(8, nil, true, 7) == "Cancel")
assert(Layout.DropAction(1, 1, false, 7) == "Cancel")
assert(Layout.DropAction(1, 8, false, 7) == "Cancel", "Hidden hotbar positions cannot receive a drop")
