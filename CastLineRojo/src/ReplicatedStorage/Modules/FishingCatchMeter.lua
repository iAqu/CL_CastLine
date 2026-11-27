local ContentProvider = game:GetService("ContentProvider")
local InstructionView = require(script.Parent.FishingInstructionView)

local FishingCatchMeter = {}
FishingCatchMeter.__index = FishingCatchMeter
local TAP_ICON = "rbxasset://textures/ui/Controls/TouchTapIcon.png"

function FishingCatchMeter.new(castMeter, gui)
	local holder = castMeter.holder:Clone()
	holder.Name = "CatchProgressMeter"
	holder.Visible = false
	holder.Active = false

	local bar = holder.Bar
	bar.Visible = true
	bar.Active = false
	local gradient = bar:FindFirstChildOfClass("UIGradient")
	gradient.Enabled = false
	bar.BackgroundColor3 = bar.BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.55)
	for _, child in bar:GetChildren() do
		if child:IsA("GuiObject") then
			child.Visible = false
		end
	end

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.AnchorPoint = Vector2.new(0, 1)
	fill.Position = UDim2.fromScale(0, 1)
	fill.Size = UDim2.fromScale(1, 0)
	fill.BorderSizePixel = 0
	fill.BackgroundColor3 = Color3.new(1, 1, 1)
	fill.ZIndex = bar.ZIndex + 1
	bar:FindFirstChildOfClass("UICorner"):Clone().Parent = fill
	local fillGradient = gradient:Clone()
	fillGradient.Enabled = true
	fillGradient.Parent = fill
	fill.Parent = bar

	holder.Prompt.Text = "TAP FAST!"
	holder.Prompt.Visible = true
	holder.Prompt.Active = false
	holder.Parent = gui
	local finger = InstructionView.CreateTapFinger(gui, holder.Prompt.ZIndex + 1, TAP_ICON)
	finger.Size, finger.Position = UDim2.fromOffset(48, 48), UDim2.fromScale(0.5, 0.4)
	task.spawn(function()
		ContentProvider:PreloadAsync({ finger })
	end)
	return setmetatable({ holder = holder, fill = fill, finger = finger }, FishingCatchMeter)
end

function FishingCatchMeter:Update(visible, progress)
	self.holder.Visible = visible
	self.fill.Size = UDim2.fromScale(1, progress)
end

function FishingCatchMeter:ShowBitePrompt(elapsed, camera, bait, mouth, prewarming)
	local finger = self.finger
	-- Mount the image during the approach so the first bite frame already has a texture.
	finger.Visible = elapsed ~= nil or prewarming == true
	finger.ImageTransparency = if elapsed == nil then 1 else 0
	if elapsed == nil then
		return
	end
	local inset, viewport = finger.Parent.AbsolutePosition, finger.Parent.AbsoluteSize
	local size = math.clamp(math.min(viewport.X, viewport.Y) * 0.14, 48, 110)
	local margin = size * 0.5 + 12
	if viewport.X < margin * 2 or viewport.Y < margin * 2 then
		finger.Visible = false
		return
	end
	local center = camera:WorldToScreenPoint(bait.Position)
	local mouthPoint = camera:WorldToScreenPoint(mouth or bait.Position)
	local radius = bait.Size.Magnitude * 0.5
	local top = camera:WorldToScreenPoint(bait.Position + camera.CFrame.UpVector * radius)
	local y = math.min(top.Y, mouthPoint.Y) - inset.Y - margin
	local x = center.X - inset.X
	if y < margin then
		local side = if x < viewport.X * 0.5 then 1 else -1
		local edge = camera:WorldToScreenPoint(bait.Position + camera.CFrame.RightVector * radius * side)
		x = (if side > 0 then math.max(edge.X, mouthPoint.X) else math.min(edge.X, mouthPoint.X)) - inset.X + side * margin
		y = center.Y - inset.Y
	end
	local position = UDim2.fromOffset(math.clamp(x, margin, viewport.X - margin), math.clamp(y, margin, viewport.Y - margin))
	InstructionView.AnimateTapFinger(finger, elapsed, position, size)
end

function FishingCatchMeter:Destroy()
	self.finger:Destroy()
	self.holder:Destroy()
end

return FishingCatchMeter
