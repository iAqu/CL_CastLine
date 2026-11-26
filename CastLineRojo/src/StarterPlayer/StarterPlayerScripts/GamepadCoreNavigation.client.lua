local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)

local suspendedGamepads: { [Enum.UserInputType]: boolean } = {}

local function syncNavigation()
	local navigatingUi = VRService.VREnabled or GameplayInputGate.IsUiBlockingWorld()

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

UserInputService.WindowFocused:Connect(deferSyncNavigation)
UserInputService.GamepadConnected:Connect(deferSyncNavigation)
UserInputService.GamepadDisconnected:Connect(function(gamepad)
	suspendedGamepads[gamepad] = nil
	deferSyncNavigation()
end)
UserInputService.TextBoxFocused:Connect(deferSyncNavigation)
UserInputService.TextBoxFocusReleased:Connect(deferSyncNavigation)
VRService:GetPropertyChangedSignal("VREnabled"):Connect(syncNavigation)
GuiService.MenuOpened:Connect(syncNavigation)
GuiService.MenuClosed:Connect(deferSyncNavigation)
GameplayInputGate.ContextChanged:Connect(function(context)
	if context == "Popup" or context == "Backpack" then
		syncNavigation()
	end
end)

-- Panels set an initial focus themselves. Leave free movement out of Roblox's automatic GUI selection.
GuiService.AutoSelectGuiEnabled = false
syncNavigation()
