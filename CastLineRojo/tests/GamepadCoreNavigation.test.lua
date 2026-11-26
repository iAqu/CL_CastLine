local function signal()
	local listeners = {}
	return {
		Connect = function(_, callback)
			table.insert(listeners, callback)
		end,
		Fire = function(_, ...)
			for _, callback in ipairs(listeners) do
				callback(...)
			end
		end,
	}
end

local function service(properties)
	local signals = {}
	local result = {}
	function result:GetPropertyChangedSignal(name)
		signals[name] = signals[name] or signal()
		return signals[name]
	end
	return setmetatable(result, {
		__index = properties,
		__newindex = function(_, name, value)
			if properties[name] ~= value then
				properties[name] = value
				if signals[name] then
					signals[name]:Fire()
				end
			end
		end,
	})
end

local gui = service({
	MenuIsOpen = false,
	AutoSelectGuiEnabled = true,
	MenuOpened = signal(),
	MenuClosed = signal(),
})
local input = {
	InputBegan = signal(),
	InputEnded = signal(),
	WindowFocused = signal(),
	GamepadConnected = signal(),
	GamepadDisconnected = signal(),
	TextBoxFocused = signal(),
	TextBoxFocusReleased = signal(),
}
local connected = { "Gamepad1", "Gamepad2" }
local navigationEnabled = { Gamepad1 = true, Gamepad2 = false }
function input:GetConnectedGamepads()
	return connected
end
function input:IsNavigationGamepad(gamepad)
	return navigationEnabled[gamepad]
end
function input:SetNavigationGamepad(gamepad, enabled)
	navigationEnabled[gamepad] = enabled
end

local vr = service({ VREnabled = false })
local focusedTextBox, ownedMenu = false, false
local gate = { ContextChanged = signal() }
gate.IsUiBlockingWorld = function()
	return gui.MenuIsOpen or focusedTextBox or ownedMenu
end

local deferred = {}
local function flush()
	while #deferred > 0 do
		table.remove(deferred, 1)()
	end
end

local services = {
	GuiService = gui,
	ReplicatedStorage = { Modules = { GameplayInputGate = gate } },
	UserInputService = input,
	VRService = vr,
}
local environment = setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(module) return module end,
	Enum = { KeyCode = { ButtonSelect = "ButtonSelect" } },
	task = { defer = function(callback) table.insert(deferred, callback) end },
}, { __index = getfenv() })

local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/GamepadCoreNavigation.client.lua", "r"))
local run = assert(loadstring(file:read("*a"), "GamepadCoreNavigation"))
file:close()
setfenv(run, environment)()
assert(not navigationEnabled.Gamepad1, "Entering gameplay must reserve the left stick for native movement")

assert(not gui.AutoSelectGuiEnabled, "Roblox must not automatically enter top-bar selection")
gui.SelectedObject = {}
assert(not navigationEnabled.Gamepad1, "A passive HUD selection cannot take over native movement")
gui.SelectedObject = nil

gui.MenuIsOpen = true
gui.MenuOpened:Fire()
assert(navigationEnabled.Gamepad1, "The explicitly opened Roblox menu can use native navigation")
assert(not navigationEnabled.Gamepad2, "The game must not enable navigation on controllers it never suspended")
gui.MenuIsOpen = false
gui.MenuClosed:Fire()
flush()
assert(not navigationEnabled.Gamepad1, "Closing the Roblox menu hands the stick back to the game")

ownedMenu = true
gate.ContextChanged:Fire("Popup")
assert(navigationEnabled.Gamepad1, "Experience popups support directional navigation")
ownedMenu = false
gate.ContextChanged:Fire("Popup")
assert(not navigationEnabled.Gamepad1, "Closing the last popup resumes world movement")

focusedTextBox = true
input.TextBoxFocused:Fire()
flush()
assert(navigationEnabled.Gamepad1, "A focused box can use the Roblox on-screen keyboard")
focusedTextBox = false
input.TextBoxFocusReleased:Fire()
flush()
assert(not navigationEnabled.Gamepad1, "Leaving the on-screen keyboard resumes world movement")

local selectInput = { KeyCode = "ButtonSelect" }
input.InputBegan:Fire(selectInput)
assert(not navigationEnabled.Gamepad1, "Select must not enable navigation during free movement")
input.InputEnded:Fire(selectInput)
flush()
assert(not navigationEnabled.Gamepad1, "Releasing Select must not capture movement")

navigationEnabled.Gamepad1 = true
input.WindowFocused:Fire()
flush()
assert(not navigationEnabled.Gamepad1, "Refocusing the viewport keeps the stick with native movement")
