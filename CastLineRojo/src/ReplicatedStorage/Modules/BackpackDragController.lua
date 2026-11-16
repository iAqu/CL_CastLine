local UserInputService = game:GetService("UserInputService")

local BackpackDragController = {}
BackpackDragController.__index = BackpackDragController

local function position(input)
	return Vector2.new(input.Position.X, input.Position.Y)
end

function BackpackDragController.new(config)
	local self = setmetatable({ config = config, pending = nil, bindings = {} }, BackpackDragController)
	UserInputService.InputChanged:Connect(function(input)
		local pending = self.pending
		if not pending then
			return
		end
		if pending.touch then
			if input ~= pending.input then
				return
			end
		elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end
		pending.position = position(input)
		if pending.active then
			self:_move()
		elseif pending.touch then
			-- Before the long press, a swipe belongs to the ScrollingFrame.
			if (pending.position - pending.start).Magnitude > 8 then
				self:Cancel()
			end
		elseif (pending.position - pending.start).Magnitude > 8 and config.canDrag() then
			self:_start()
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		local pending = self.pending
		if not pending then
			return
		end
		if
			(pending.touch and input ~= pending.input)
			or (not pending.touch and input.UserInputType ~= Enum.UserInputType.MouseButton1)
		then
			return
		end
		local point = position(input)
		local active, slot, frame = pending.active, pending.slot, pending.frame
		self:Cancel()
		if active then
			config.drop(slot, point)
		elseif config.canInteract() and frame.Parent then
			local p, size = frame.AbsolutePosition, frame.AbsoluteSize
			if point.X >= p.X and point.Y >= p.Y and point.X <= p.X + size.X and point.Y <= p.Y + size.Y then
				config.click(slot)
			end
		end
	end)
	UserInputService.WindowFocusReleased:Connect(function()
		self:Cancel()
	end)
	return self
end

function BackpackDragController:_move()
	local pending = self.pending
	if pending and pending.ghost then
		local point = pending.position - self.config.layer.AbsolutePosition
		pending.ghost.Position = UDim2.fromOffset(point.X, point.Y)
	end
end

function BackpackDragController:_start()
	local pending = self.pending
	if not pending or not self.config.canDrag() or pending.slot.Tool ~= pending.tool then
		return
	end
	pending.active = true
	local ghost = pending.frame:Clone()
	ghost.Name = "DragPreview"
	ghost:SetAttribute("HotbarSlotIndex", nil)
	local reference = ghost:FindFirstChild("ToolReference")
	if reference then
		reference:Destroy()
	end
	local baseZ = pending.frame.ZIndex
	for _, child in ipairs(ghost:GetDescendants()) do
		if child:IsA("GuiObject") then
			child.ZIndex = 50 + math.max(0, child.ZIndex - baseZ)
			child.Active = false
			child.Selectable = false
			if child.Name == "ToolTip" then
				child.Visible = false
			end
		end
	end
	ghost.ZIndex = 50
	ghost.AnchorPoint = Vector2.new(0.5, 0.5)
	ghost.Size = UDim2.fromOffset(pending.frame.AbsoluteSize.X, pending.frame.AbsoluteSize.Y)
	ghost.Active = false
	ghost.Selectable = false
	ghost.AutoButtonColor = false
	ghost.BackgroundTransparency = 0.15
	local scale = ghost:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
	scale.Scale = 1.12
	scale.Parent = ghost
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Thickness = 2
	stroke.Parent = ghost
	ghost.Parent = self.config.layer
	pending.ghost = ghost
	pending.scrollingEnabled = self.config.scrolling.ScrollingEnabled
	self.config.scrolling.ScrollingEnabled = false
	self.config.started(pending.frame)
	self:_move()
end

function BackpackDragController:Cancel()
	local pending = self.pending
	if not pending then
		return
	end
	self.pending = nil
	if pending.ghost then
		pending.ghost:Destroy()
	end
	if pending.active then
		self.config.scrolling.ScrollingEnabled = pending.scrollingEnabled
		self.config.finished(pending.frame)
	end
end

function BackpackDragController:CancelSlot(slot)
	if self.pending and self.pending.slot == slot then
		self:Cancel()
	end
end

function BackpackDragController:Bind(frame, slot)
	local connections = {}
	self.bindings[frame] = connections
	table.insert(
		connections,
		frame.InputBegan:Connect(function(input)
			local touch = input.UserInputType == Enum.UserInputType.Touch
			if not touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			if self.pending or not slot.Tool or not self.config.canInteract() then
				return
			end
			local point = position(input)
			local pending = {
				frame = frame,
				slot = slot,
				tool = slot.Tool,
				input = input,
				start = point,
				position = point,
				touch = touch,
				active = false,
			}
			self.pending = pending
			if touch then
				task.delay(0.18, function()
					if self.pending == pending then
						self:_start()
					end
				end)
			end
		end)
	)
	table.insert(
		connections,
		frame.Activated:Connect(function(input)
			-- Mouse/touch clicks are resolved once, by InputEnded above.
			if
				input
				and (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				return
			end
			if self.config.canInteract() then
				self.config.click(slot)
			end
		end)
	)
	table.insert(
		connections,
		frame.Destroying:Connect(function()
			self:CancelSlot(slot)
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			self.bindings[frame] = nil
		end)
	)
end

return BackpackDragController
