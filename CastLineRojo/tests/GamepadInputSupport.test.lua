local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local plotFish = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotFishController.lua")
local baitSelect = read("src/ReplicatedStorage/Modules/FishingBaitSelect.lua")
local homeGui = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")
local guiAnimation = read("src/ReplicatedStorage/Modules/GuiAnimation.lua")
local confirmGui = read("src/ReplicatedStorage/Modules/ConfirmGuiClient.lua")
local commonResultGui = read("src/ReplicatedStorage/Modules/CommonResultClient.lua")
local purse = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")

assert(
	plotFish:find("Enum.KeyCode.ButtonR2", 1, true)
		and plotFish:find("Enum.UserInputType.MouseButton1", 1, true)
		and plotFish:find("TouchTapInWorld", 1, true),
	"Plot fish interaction must support R2, mouse and touch"
)
assert(
	baitSelect:find("GuiAnimation.PushModal(gui, initialFocus, close", 1, true)
		and baitSelect:find("GuiAnimation.RefreshNavigationFocus(gui)", 1, true)
		and baitSelect:find("GuiAnimation.PopModal(gui)", 1, true),
	"The bait picker must own gamepad focus, recover after failed requests and clean up when closed"
)

assert(
	homeGui:find('input.KeyCode == Enum.KeyCode.F or input.KeyCode == Enum.KeyCode.ButtonY', 1, true),
	"Pick up must preserve keyboard F and gamepad Y"
)
assert(
	guiAnimation:find("GuiService.SelectedObject = target", 1, true)
		and guiAnimation:find("Enum.KeyCode.ButtonB", 1, true),
	"Popup navigation must establish focus and support gamepad back"
)
assert(
	confirmGui:find("GuiAnimation.PushModal(clone, clone.Frame.CancelButton", 1, true),
	"Destructive confirmation must default gamepad focus to Cancel"
)
assert(
	commonResultGui:find("GuiAnimation.PushModal(clone, button", 1, true),
	"Result dialogs must be dismissible with gamepad input"
)
assert(
	purse:find('GameplayInputGate.SetActive("Backpack", MainFrame, open)', 1, true),
	"Open inventory must block world gamepad actions"
)

local function section(first, after)
	local start = assert(guiAnimation:find(first, 1, true), first)
	local finish = assert(guiAnimation:find(after, start + 1, true), after)
	return guiAnimation:sub(start, finish - 1)
end

local home = { Enabled = true }
local function guiObject(parent)
	return {
		Parent = parent,
		Visible = true,
		Active = true,
		Selectable = true,
		Interactable = true,
		IsA = function(_, class)
			return class == "GuiObject"
		end,
		IsDescendantOf = function(_, ancestor)
			return ancestor == home
		end,
	}
end
local panel = guiObject(home)
local button = guiObject(panel)
local guiService = {}
local entry = { gui = {} }
local closed = false
local inGamepadMode = true
local source = section("local function isInteractiveWithin", "local function navigationRoot")
	.. section("local homeSelection", "local homeHud")
	.. section("local function onGamepadBack", "ContextActionService:BindActionAtPriority")
	.. "\nreturn onGamepadBack, restoreHomeSelection, function(button) homeSelection = button end"
local chunk, loadError = loadstring(source, "Popup gamepad focus")
local onBack, restoreFocus, rememberFocus = setfenv(assert(chunk, loadError), setmetatable({
	HomeGui = home,
	GuiService = guiService,
	UserInputService = {
		GetFocusedTextBox = function()
			return nil
		end,
	},
	Enum = { UserInputState = { Begin = "Begin" }, ContextActionResult = { Pass = "Pass", Sink = "Sink" } },
	task = {
		defer = function(callback)
			callback()
		end,
	},
	GuiAnimation = {
		CloseGui = function(gui)
			assert(gui == entry.gui, "Back must close the active popup")
			closed = true
			entry = nil
		end,
	},
	backHandlers = {},
	isUsingGamepad = function()
		return inGamepadMode
	end,
	topNavigationEntry = function()
		return entry
	end,
}, { __index = getfenv() }))()

rememberFocus(button)
assert(onBack("AFPopupBack", "Begin", {}) == "Sink" and closed, "Gamepad Back must dismiss the popup")
restoreFocus()
assert(guiService.SelectedObject == button, "After the HUD slides back, gamepad focus must return to its button")
guiService.SelectedObject = nil
panel.Interactable = false
rememberFocus(button)
restoreFocus()
assert(guiService.SelectedObject == nil, "A button in a disabled HUD panel must not receive focus")
panel.Interactable = true
rememberFocus(button)
inGamepadMode = false
restoreFocus()
inGamepadMode = true
restoreFocus()
assert(guiService.SelectedObject == nil, "Switching to mouse input must clear the saved gamepad focus")

print("GamepadInputSupport.test.lua passed")
