local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local GameplayInputGate = require(script.Parent.GameplayInputGate)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Details = {}
Details.PurchaseId = "MegaLuck"
Details.Description = "Doubles the draw weight of high-grade fish in your rod's rarity."
Details.FishingGuiName = "FishingOddsGui"

local INK = Color3.fromRGB(250, 253, 255)
local PANEL = Color3.fromRGB(21, 35, 56)
local ACCENT = Color3.fromRGB(43, 103, 167)
local purchaseView

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

local function newView(playerGui, name, heading, modal)
	local gui = Instance.new("ScreenGui")
	gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = name, false, 100
	local backdrop = Instance.new("Frame")
	backdrop.Name = "Backdrop"
	backdrop.Size = UDim2.fromScale(1, 1)
	backdrop.BackgroundColor3, backdrop.BackgroundTransparency = Color3.new(), 0.45
	backdrop.Active, backdrop.Visible, backdrop.Parent = true, modal, gui

	local panel = Instance.new("Frame")
	panel.Name = "Details"
	panel.AnchorPoint = if modal then Vector2.new(0.5, 0.5) else Vector2.new(1, 0)
	panel.Position = if modal then UDim2.fromScale(0.5, 0.5) else UDim2.new(1, -18, 0, 60)
	panel.Size = if modal then UDim2.fromScale(0.92, 0.82) else UDim2.fromScale(0.86, 0.65)
	panel.BackgroundColor3, panel.BorderSizePixel, panel.Active = PANEL, 0, true
	panel.Parent = gui
	local limits = Instance.new("UISizeConstraint")
	limits.MaxSize = Vector2.new(if modal then 500 else 325, if modal then 580 else 425)
	limits.Parent = panel

	local title = text(panel, "TextLabel", heading, 21)
	title.Position, title.Size = UDim2.fromOffset(14, 0), UDim2.new(1, -85, 0, 48)
	title.TextXAlignment = Enum.TextXAlignment.Left
	local close = button(panel, "Close", UDim2.fromOffset(60, 32))
	close.AnchorPoint, close.Position = Vector2.new(1, 0), UDim2.new(1, -10, 0, 8)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "Outcomes"
	scroll.Position = UDim2.fromOffset(12, 48)
	scroll.Size = UDim2.new(1, -24, 1, if modal then -104 else -58)
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
			local odds = percent(row.chance)
			if row.boostedChance then
				odds ..= "  →  " .. percent(row.boostedChance)
			end
			line(row.name .. "   " .. odds, 16)
		end
	end
	return gui, panel, close, clear, line, rows
end

function Details.OpenPurchase(forSelf: boolean)
	if purchaseView then
		return
	end
	local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not playerGui then
		return
	end
	local previousSelection = GuiService.SelectedObject
	local purchase = Knit.GetService("PurchaseService")
	local gui, panel, close, clear, line, rows = newView(playerGui, "UltraLuckDetailsGui", "Ultra Luck Details", true)
	purchaseView = gui
	GameplayInputGate.SetActive("Popup", gui, true)
	local respawnConnection
	local function dismiss()
		if purchaseView ~= gui then
			return
		end
		respawnConnection:Disconnect()
		GameplayInputGate.SetActive("Popup", gui, false)
		purchaseView = nil
		if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(gui) then
			GuiService.SelectedObject = if previousSelection and previousSelection.Parent then previousSelection else nil
		end
		gui:Destroy()
	end
	respawnConnection = Players.LocalPlayer.CharacterRemoving:Connect(dismiss)
	close.Activated:Connect(dismiss)
	if UserInputService.GamepadEnabled then
		GuiService.SelectedObject = close
	end
	line("Loading odds…", 16)
	purchase:GetUltraLuckOdds(forSelf):andThen(function(result)
		if purchaseView ~= gui then
			return
		end
		clear()
		if not result.ok then
			line(result.message, 16)
			return
		end
		line(Details.Description, 17)
		line((result.recipient and result.recipient .. " • " or "") .. result.rod, 17)
		line("Ordinary fishing • Base → Ultra Luck\nUses current catch guarantees. Event and tutorial catches follow their own rules.", 15)
		if result.message then
			line(result.message, 16)
		end
		for _, grade in ipairs(result.grades) do
			line(grade.name, 19)
			rows(grade.rows)
		end
		line("Percentages are rounded.", 14)
		if result.canBuy then
			local buy = button(panel, if forSelf then "Buy Ultra Luck" else "Gift Ultra Luck", UDim2.new(1, -24, 0, 36))
			buy.Name = "Buy"
			buy.Position = UDim2.new(0, 12, 1, -46)
			buy.Activated:Connect(function()
				dismiss()
				purchase.PromptPurchase:Fire(Details.PurchaseId, forSelf, result.recipientId)
			end)
		end
	end):catch(function()
		if purchaseView == gui then
			clear()
			line("Couldn't load the odds. Close and try again.", 16)
		end
	end)
end

function Details.BindFishing(playerGui)
	local gui, panel, close, clear, line, rows = newView(playerGui, Details.FishingGuiName, "Catch Odds", false)
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

return Details
