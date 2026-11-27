local Players = game:GetService("Players")

local ButtonAnimation = require(script.Parent.ButtonAnimation)
local FishInventoryData = require(script.Parent.FishInventoryData)
local GuiAnimation = require(script.Parent.GuiAnimation)
local MutationDataUtil = require(script.Parent.MutationDataUtil)
local NumberUtil = require(script.Parent.NumberUtil)
local PlotUpgradeData = require(script.Parent.PlotUpgradeData)
local WeightFormat = require(script.Parent.WeightFormat)

local PlotFullGui = {}
local NARROW_PANEL_WIDTH = 300
local NARROW_VIEWPORT_WIDTH = 720

local function escapeRichText(text: string): string
	return (text:gsub("[&<>]", { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;" }))
end

local function formatRate(rate: number): string
	if rate < 0.01 then
		return "+<$0.01/s"
	end
	local value = if rate < 1000
		then (string.format("%.2f", rate):gsub("0+$", ""):gsub("%.$", ""))
		else NumberUtil.FormatItemPriceCompact(rate)
	return "+$" .. value .. "/s"
end

function PlotFullGui.Open(full, onSwap, onUpgrade)
	local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local template = playerGui and playerGui:FindFirstChild("ConfirmGui")
	if not template then
		return nil
	end

	local gui = template:Clone()
	gui.Name = "PlotFullGui"
	local frame = gui.Frame
	local templateSize = frame.Size
	local aspect = frame.UIAspectRatioConstraint.AspectRatio
	local function fitPanel()
		local viewport = gui.AbsoluteSize
		local width = templateSize.X.Scale * viewport.X + templateSize.X.Offset
		local height = templateSize.Y.Scale * viewport.Y + templateSize.Y.Offset
		local minimumWidth = math.min(NARROW_PANEL_WIDTH, viewport.X * 0.9, viewport.Y * 0.8 * aspect)
		frame.Size = if viewport.X < NARROW_VIEWPORT_WIDTH and math.min(width, height * aspect) < minimumWidth
			then UDim2.fromOffset(math.max(width, minimumWidth), math.max(height, minimumWidth / aspect))
			else templateSize
	end

	local title = frame.Top.Title
	local titleWidth = 0.36
	local titleShift = (titleWidth - title.Size.X.Scale) * title.AnchorPoint.X
	title.Text = "Plot Full"
	title.Size += UDim2.fromScale(titleWidth - title.Size.X.Scale, 0)
	title.Position += UDim2.fromScale(titleShift, 0)

	local text = frame.ConfirmTextLabel
	local swap = full.swap
	local nextUpgrade = PlotUpgradeData.GetNext(full.level)
	text.Position = UDim2.fromScale(0.5, 0.43)
	text.Size = UDim2.fromScale(text.Size.X.Scale, 0.46)
	text.RichText = true
	text.TextWrapped = true
	local textLimit = Instance.new("UITextSizeConstraint")
	textLimit.Parent = text
	local function fitBodyText()
		textLimit.MaxTextSize = math.max(textLimit.MinTextSize, math.floor(frame.AbsoluteSize.Y * 0.12))
	end
	local lines = { `{full.capacity}/{full.capacity} fish` }
	if swap then
		local outgoing = FishInventoryData[swap.itemId]
		local mutation = MutationDataUtil.GetConfig(swap.mutationId)
		local outgoingName = outgoing and outgoing.DisplayName or swap.itemId
		if mutation then
			outgoingName = mutation.DisplayName .. " " .. outgoingName
		end
		local weight = WeightFormat.FormatKg(swap.weight):gsub(" ", utf8.char(0xA0))
		local fish = escapeRichText(outgoingName .. " (" .. weight .. ")")
		table.insert(lines, `Return {fish} to backpack`)
		table.insert(lines, '<font color="#75FF26">' .. escapeRichText(formatRate(swap.rate)) .. "</font>")
	end
	if nextUpgrade then
		local price = NumberUtil.FormatItemPriceCompact(nextUpgrade.Price)
		table.insert(lines, `Expand to {nextUpgrade.Capacity} · ${price}`)
	elseif not swap then
		table.insert(lines, "Unequip a fish in My Fish.")
	end
	text.Text = table.concat(lines, "<br />")

	local swapButton = frame.ConfirmButton
	swapButton.Visible = swap ~= nil
	swapButton.TextLabel.Text = "Swap"
	local closeButton = frame.CancelButton
	closeButton.TextLabel.Text = "Close"
	local upgradeButton
	if nextUpgrade then
		upgradeButton = swapButton:Clone()
		upgradeButton.Name = "UpgradeButton"
		upgradeButton.Visible = true
		upgradeButton.TextLabel.Text = "Expand"
		upgradeButton.UIGradient.Color = frame.Top.UIGradient.Color
		upgradeButton.Parent = frame
	end

	local closed = false
	local function close()
		if not closed then
			closed = true
			GuiAnimation.PopModal(gui)
			gui:Destroy()
		end
	end

	local actions = {}
	if swap then
		table.insert(actions, { button = swapButton, callback = onSwap })
	end
	if upgradeButton then
		table.insert(actions, { button = upgradeButton, callback = onUpgrade })
	end
	table.insert(actions, { button = closeButton })
	local buttonWidth = swapButton.Size.X.Scale
	local leftEdge = swapButton.Position.X.Scale - buttonWidth / 2
	local columnWidth = (closeButton.Position.X.Scale + buttonWidth / 2 - leftEdge) / 3
	for index, action in ipairs(actions) do
		local button = action.button
		if #actions == 1 then
			button.Position += UDim2.fromScale(0.5 - button.Position.X.Scale, 0)
		elseif #actions == 3 then
			local columnCenter = leftEdge + (index - 0.5) * columnWidth
			button.Position += UDim2.fromScale(columnCenter - button.Position.X.Scale, 0)
			button.Size += UDim2.fromScale(columnWidth - 0.035 - button.Size.X.Scale, 0)
		end
		button.NextSelectionLeft = index > 1 and actions[index - 1].button or button
		button.NextSelectionRight = index < #actions and actions[index + 1].button or button
		ButtonAnimation.SetUp(button)
		button.Activated:Connect(function()
			if closed then
				return
			end
			close()
			if action.callback then
				action.callback()
			end
		end)
	end

	gui.Enabled = true
	gui.Parent = playerGui
	fitPanel()
	fitBodyText()
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitPanel)
	frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBodyText)
	GuiAnimation.PushModal(gui, closeButton, close)
	return close
end

return PlotFullGui
