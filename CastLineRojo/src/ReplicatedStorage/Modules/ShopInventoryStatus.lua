local ShopInventoryStatus = {}

function ShopInventoryStatus.Bind(list: ScrollingFrame, templateLabel: TextLabel)
	local label = templateLabel:Clone()
	label.Name = "InventoryStatus"
	label.AnchorPoint = list.AnchorPoint
	label.Position = list.Position
	label.Size = UDim2.new(list.Size.X.Scale * 0.88, list.Size.X.Offset, 0, 56)
	label.BackgroundTransparency = 1
	label.RichText = false
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Visible = false
	label.Active = false
	label.Parent = list.Parent
	local sizeConstraint = Instance.new("UITextSizeConstraint")
	sizeConstraint.MaxTextSize = 24
	sizeConstraint.Parent = label

	return function(message: string?)
		label.Text = message or ""
		label.Visible = message ~= nil
		list.Visible = message == nil
	end
end

return ShopInventoryStatus
