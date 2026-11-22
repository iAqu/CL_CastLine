local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)

local suspendedGamepads: { [Enum.UserInputType]: boolean } = {}
local selectHeld = false

local function syncNavigation()
	local navigatingUi = selectHeld
		or VRService.VREnabled
		or GuiService.SelectedObject ~= nil
		or GameplayInputGate.IsUiBlockingWorld()

	for _, gamepad in ipairs(UserInputService:GetConnectedGamepads()) do
		if navigatingUi then
			if suspendedGamepads[gamepad] then
				suspendedGamepads[gamepad] = nil
				UserInputService:SetNavigationGamepad(gamepad, true)
			end
		elseif UserInputService:IsNavigationGamepad(gamepad) then
			-- An idle gamepad still drives PlayerModule, but cannot navigate the Roblox top bar.
			suspendedGamepads[gamepad] = true
			UserInputService:SetNavigationGamepad(gamepad, false)
		end
	end
end

local function deferSyncNavigation()
	task.defer(syncNavigation)
end

local function releaseSelect()
	selectHeld = false
	deferSyncNavigation()
end

-- Keep Roblox's explicit GUI toggle available even when the stick is driving the character.
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonSelect then
		selectHeld = true
		syncNavigation()
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonSelect then
		releaseSelect()
	end
end)
UserInputService.WindowFocusReleased:Connect(releaseSelect)
UserInputService.GamepadConnected:Connect(deferSyncNavigation)
UserInputService.GamepadDisconnected:Connect(function(gamepad)
	suspendedGamepads[gamepad] = nil
	releaseSelect()
end)
UserInputService.TextBoxFocused:Connect(deferSyncNavigation)
UserInputService.TextBoxFocusReleased:Connect(deferSyncNavigation)
VRService:GetPropertyChangedSignal("VREnabled"):Connect(syncNavigation)
GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(syncNavigation)
GuiService.MenuOpened:Connect(syncNavigation)
GuiService.MenuClosed:Connect(deferSyncNavigation)
GameplayInputGate.ContextChanged:Connect(function(context)
	if context == "Popup" or context == "Backpack" then
		syncNavigation()
	end
end)

syncNavigation()
