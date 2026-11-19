-- Own only training's visibility lease. Other gameplay can keep the backpack hidden.
local State = {}
State.__index = State

function State.new(playerGui, otherGameplayHidden)
	return setmetatable({ playerGui = playerGui, otherGameplayHidden = otherGameplayHidden, active = false }, State)
end

function State:SetActive(active)
	self.active = active
	self:Step()
end

function State:Step()
	local gui = self.playerGui:FindFirstChild("BackpackGui")
	if self.heldGui and self.heldGui ~= gui then
		self.heldGui = nil
	end
	if self.active then
		if gui and not self.heldGui then
			self.heldGui, self.previousEnabled = gui, gui.Enabled
		end
		if gui and gui.Enabled then
			gui.Enabled = false -- Purse closes the inventory and releases modal input.
		end
	elseif self.heldGui and not self.otherGameplayHidden() then
		if self.heldGui.Parent and self.heldGui.Enabled == false then
			self.heldGui.Enabled = self.previousEnabled
		end
		self.heldGui = nil
	end
end

function State:Destroy()
	self:SetActive(false)
	if self.heldGui then
		-- Finish a deferred handoff once the other gameplay releases its own lock.
		local connection
		connection = game:GetService("RunService").Heartbeat:Connect(function()
			self:Step()
			if not self.heldGui then
				connection:Disconnect()
			end
		end)
	end
end

return State
