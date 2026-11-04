local MouseHoverUI = {}

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to set up hover effect for the button and detailed info panel
function MouseHoverUI.CreateHoverEffect(button, infoPanel)
	-- Ensure infoPanel is hidden initially
	infoPanel.Visible = false

	-- Variable to store the connection
	local connection

	-- Function to update info panel position and visibility
	local function onMouseMoved(input)
		-- Only care about mouse movement (not keyboard inputs)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = input.Position

			-- Get the button position and size
			local buttonPos = button.AbsolutePosition
			local buttonSize = button.AbsoluteSize
			local mouseInsideButton = mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
				mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y

			-- Show or hide the info panel based on mouse position
			if mouseInsideButton then
				infoPanel.Visible = true
				infoPanel.Position = UDim2.new(0, mousePos.X + 10, 0, mousePos.Y) -- Positioning the info panel near the mouse
			else
				infoPanel.Visible = false
			end
		end
	end

	-- Connect the mouse movement event when mouse enters the button
	button.MouseEnter:Connect(function()
		-- Start tracking mouse movement when mouse enters the button
		connection = UserInputService.InputChanged:Connect(onMouseMoved)
	end)

	-- Hide the info panel and disconnect the connection when the mouse leaves the button
	button.MouseLeave:Connect(function()
		infoPanel.Visible = false
		if connection then
			connection:Disconnect()
		end
	end)
end

return MouseHoverUI
