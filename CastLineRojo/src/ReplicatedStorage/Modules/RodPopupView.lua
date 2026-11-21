local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local RarityPresentation = require(ReplicatedStorage.Modules.RarityPresentation)

local View = {}
View.__index = View

function View.new(gui: ScreenGui, popup: Frame, kind: "Rod" | "Barbell" | "Event")
	local main = popup.MainFrame
	return setmetatable({
		gui = gui,
		popup = popup,
		kind = kind,
		main = main,
		preview = if kind == "Event" then nil else main.PreviewFrame,
		button = if kind == "Event" then main.JoinButton else main.ShopButton,
		restingPosition = popup.Position,
		baseSize = popup.Size,
		scale = popup:FindFirstChildOfClass("UIScale"),
		generation = 0,
		closing = false,
		hovered = false,
	}, View)
end

function View:Paused(): boolean
	local selected = GuiService.SelectedObject
	return self.hovered or (selected ~= nil and selected:IsDescendantOf(self.popup))
end

function View:Fit()
	local size = self.gui.AbsoluteSize
	local baseWidth = (if self.popup.SizeConstraint == Enum.SizeConstraint.RelativeYY then size.Y else size.X)
			* self.baseSize.X.Scale
		+ self.baseSize.X.Offset
	if self.scale and baseWidth > 0 and size.X > 0 then
		self.scale.Scale = math.min(1, size.X * 0.95 / baseWidth)
	end
end

function View:SetItem(item)
	local isBarbell = self.kind == "Barbell"
	local icon = item.Icon
	local hasIcon = typeof(icon) == "string" and icon ~= "" and icon ~= "nil"
	self.preview.RodImage.Image = if hasIcon then icon else ""
	self.preview.RodImage.Visible = hasIcon
	if isBarbell then
		self.preview.Visible = hasIcon
	end
	self.main.Top.Title.Text = if isBarbell then "NEW BARBELL UNLOCKED!" else "NEW ROD UNLOCKED!"
	self.main.NameLabel.Text = item.DisplayName
	self.main.NameLabel.TextColor3 = RarityPresentation.GetColor(item.Rarity)
	self.main.PriceLabel.Text = '<font color="#00F900">$' .. NumberUtil.FormatItemPriceCompact(item.Price) .. "</font>"
	self.popup:SetAttribute(if isBarbell then "TrainingID" else "RodID", if isBarbell then item.TrainingID else item.RodID)
end

function View:Show(item)
	if item then
		self:SetItem(item)
	end
	self.generation += 1
	if self.tween then
		self.tween:Cancel()
	end
	self.closing, self.hovered = false, false
	self.main.ProgressFrame.ProgressBar.Size = UDim2.fromScale(1, 1)
	self.popup.Position = UDim2.new(self.restingPosition.X.Scale, self.restingPosition.X.Offset, -0.4, -64)
	self.gui.Enabled, self.popup.Visible = true, true
	self:Fit()
	self.tween = TweenService:Create(
		self.popup,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = self.restingPosition }
	)
	self.tween:Play()
	if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
		self.previousSelection = GuiService.SelectedObject
		GuiService.SelectedObject = self.button
	end
end

function View:Hide(immediate: boolean?)
	self.generation += 1
	local generation = self.generation
	if self.tween then
		self.tween:Cancel()
	end
	self.closing = true
	local selected = GuiService.SelectedObject
	if selected and selected:IsDescendantOf(self.popup) then
		GuiService.SelectedObject = if self.previousSelection and self.previousSelection.Parent
			then self.previousSelection
			else nil
	end
	self.previousSelection = nil
	if immediate then
		self.popup.Visible, self.gui.Enabled = false, false
		self.closing = false
		return
	end
	self.tween = TweenService:Create(self.popup, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Position = UDim2.new(self.restingPosition.X.Scale, self.restingPosition.X.Offset, -0.4, -64),
	})
	self.tween.Completed:Once(function()
		if self.generation == generation then
			self.popup.Visible, self.gui.Enabled = false, false
			self.closing = false
		end
	end)
	self.tween:Play()
end

function View:Step(remaining: number, duration: number?)
	self.main.ProgressFrame.ProgressBar.Size = UDim2.fromScale(math.clamp(remaining / (duration or 7), 0, 1), 1)
	self:Fit()
end

return View
