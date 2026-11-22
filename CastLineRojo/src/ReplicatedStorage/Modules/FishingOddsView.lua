local GuiService = game:GetService("GuiService")
local FishingOddsView = {}
FishingOddsView.GuiName = "FishingOddsGui"

local INK = Color3.fromRGB(250, 253, 255)
local PANEL = Color3.fromRGB(21, 35, 56)
local ACCENT = Color3.fromRGB(43, 103, 167)

local function text(parent, class, value, size)
	local object = Instance.new(class)
	object.BackgroundTransparency = 1
	object.TextColor3 = INK
	object.Font = Enum.Font.FredokaOne
	object.TextSize = size
	object.Text = value
	object.Parent = parent
	return object
end

local function button(parent, value, size)
	local control = text(parent, "TextButton", value, 16)
	control.Size = size
	control.BackgroundTransparency = 0
	control.BackgroundColor3 = ACCENT
	control.BorderSizePixel = 0
	return control
end

local function percent(chance)
	if chance == 0 then
		return "0%"
	end
	local value = chance * 100
	local decimals = math.max(4, 4 - math.floor(math.log10(value)))
	return (string.format("%." .. decimals .. "f", value):gsub("0+$", ""):gsub("%.$", "")) .. "%"
end

function FishingOddsView.Bind(playerGui)
	local gui = Instance.new("ScreenGui")
	gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = FishingOddsView.GuiName, false, 100

	local panel = Instance.new("Frame")
	panel.Name = "Odds"
	panel.AnchorPoint = Vector2.new(1, 0)
	panel.Position = UDim2.new(1, -18, 0, 60)
	panel.Size = UDim2.fromScale(0.86, 0.65)
	panel.BackgroundColor3, panel.BorderSizePixel, panel.Active = PANEL, 0, true
	panel.Parent = gui
	local limits = Instance.new("UISizeConstraint")
	limits.MaxSize = Vector2.new(325, 425)
	limits.Parent = panel

	local title = text(panel, "TextLabel", "Catch Odds", 21)
	title.Position, title.Size = UDim2.fromOffset(14, 0), UDim2.new(1, -85, 0, 48)
	title.TextXAlignment = Enum.TextXAlignment.Left
	local close = button(panel, "Close", UDim2.fromOffset(60, 32))
	close.AnchorPoint, close.Position = Vector2.new(1, 0), UDim2.new(1, -10, 0, 8)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "Outcomes"
	scroll.Position = UDim2.fromOffset(12, 48)
	scroll.Size = UDim2.new(1, -24, 1, -58)
	scroll.AutomaticCanvasSize, scroll.CanvasSize = Enum.AutomaticSize.Y, UDim2.new()
	scroll.ScrollingDirection, scroll.ScrollBarThickness = Enum.ScrollingDirection.Y, 5
	scroll.BackgroundTransparency, scroll.BorderSizePixel = 1, 0
	scroll.Parent = panel
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scroll
	gui.Parent = playerGui

	local function clear()
		for _, child in ipairs(scroll:GetChildren()) do
			if child ~= layout then
				child:Destroy()
			end
		end
	end

	local function line(value, size)
		local label = text(scroll, "TextLabel", value, size)
		label.LayoutOrder = #scroll:GetChildren()
		label.Size, label.AutomaticSize = UDim2.new(1, -10, 0, size + 8), Enum.AutomaticSize.Y
		label.TextXAlignment, label.TextWrapped = Enum.TextXAlignment.Left, true
		return label
	end

	local function rows(items)
		for _, row in ipairs(items) do
			line(row.name .. "   " .. percent(row.chance), 16)
		end
	end
	panel.Visible = false
	local toggle = button(gui, "Catch Odds", UDim2.fromOffset(105, 32))
	toggle.AnchorPoint, toggle.Position = Vector2.new(1, 0), UDim2.new(1, -18, 0, 20)
	toggle.Activated:Connect(function()
		panel.Visible = not panel.Visible
		if panel.Visible and GuiService.SelectedObject == toggle then
			GuiService.SelectedObject = close
		end
	end)
	close.Activated:Connect(function()
		panel.Visible = false
		if GuiService.SelectedObject == close then
			GuiService.SelectedObject = toggle
		end
	end)
	return {
		Update = function(odds)
			clear()
			line(odds.name .. (if odds.boosted then " • Ultra Luck active" else ""), 18)
			rows(odds.rows)
			if odds.variants then
				line("Fish variant odds", 18)
				rows(odds.variants)
			end
			line("Percentages are rounded.", 14)
		end,
		Destroy = function()
			gui:Destroy()
		end,
	}
end

return FishingOddsView
