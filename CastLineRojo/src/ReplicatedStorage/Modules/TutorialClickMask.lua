local Mask = {}
Mask.__index = Mask

function Mask.new(gui)
	local self = setmetatable({ gui = gui, panels = {} }, Mask)
	for index = 1, 4 do
		local panel = Instance.new("Frame")
		panel.Name = "TutorialShade"
		panel.BackgroundColor3 = Color3.new(0, 0, 0)
		panel.BackgroundTransparency = 0.4
		panel.BorderSizePixel = 0
		panel.Active, panel.Selectable, panel.Interactable = false, false, false
		panel.ZIndex, panel.Visible, panel.Parent = 1, false, gui
		self.panels[index] = panel
	end
	local border = Instance.new("Frame")
	border.Name = "TutorialTargetOutline"
	border.BackgroundTransparency = 1
	border.Active, border.Selectable, border.Interactable = false, false, false
	border.ZIndex, border.Visible, border.Parent = 2, false, gui
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color, stroke.Thickness, stroke.Parent = Color3.new(1, 1, 1), 2, border
	self.border = border
	return self
end

function Mask:Clear()
	self.border.Visible = false
	for _, panel in self.panels do
		panel.Visible = false
	end
end

local function getHole(target, origin, viewport)
	local padding = target.AbsoluteSize * 0.075
	local topLeft = target.AbsolutePosition - padding
	local bottomRight = topLeft + target.AbsoluteSize + padding * 2
	local ancestor = target
	while ancestor do
		if ancestor:IsA("GuiObject") then
			if not ancestor.Visible then
				return nil
			end
			if ancestor ~= target and ancestor.ClipsDescendants then
				local low = ancestor.AbsolutePosition
				local size = if ancestor:IsA("ScrollingFrame") then ancestor.AbsoluteWindowSize else ancestor.AbsoluteSize
				local high = low + size
				topLeft = Vector2.new(math.max(topLeft.X, low.X), math.max(topLeft.Y, low.Y))
				bottomRight = Vector2.new(math.min(bottomRight.X, high.X), math.min(bottomRight.Y, high.Y))
			end
		elseif ancestor:IsA("ScreenGui") then
			if not ancestor.Enabled then
				return nil
			end
			break
		end
		ancestor = ancestor.Parent
	end
	if not ancestor then
		return nil
	end
	-- Snap shared edges before deriving the offsets and sizes of individual panels.
	local x1 = math.clamp(math.round(topLeft.X - origin.X), 0, viewport.X)
	local y1 = math.clamp(math.round(topLeft.Y - origin.Y), 0, viewport.Y)
	local x2 = math.clamp(math.round(bottomRight.X - origin.X), 0, viewport.X)
	local y2 = math.clamp(math.round(bottomRight.Y - origin.Y), 0, viewport.Y)
	if x2 > x1 and y2 > y1 then
		return x1, y1, x2, y2
	end
	return nil
end

local function layout(frame, x, y, width, height)
	frame.Position = UDim2.fromOffset(x, y)
	frame.Size = UDim2.fromOffset(width, height)
	frame.Visible = true
end

function Mask:Update(target)
	local viewport = self.gui.AbsoluteSize
	local size = Vector2.new(math.round(viewport.X), math.round(viewport.Y))
	local x1, y1, x2, y2
	if target then
		x1, y1, x2, y2 = getHole(target, self.gui.AbsolutePosition, size)
	end
	if not x1 then
		self:Clear()
		return nil
	end
	layout(self.panels[1], 0, 0, size.X, y1)
	layout(self.panels[2], 0, y2, size.X, size.Y - y2)
	layout(self.panels[3], 0, y1, x1, y2 - y1)
	layout(self.panels[4], x2, y1, size.X - x2, y2 - y1)
	layout(self.border, x1, y1, x2 - x1, y2 - y1)
	return Vector2.new(x1, y1), Vector2.new(x2, y2)
end

return Mask
