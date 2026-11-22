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
local tradeRequestGui = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeRequestGuiController.lua")

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
	tradeRequestGui:find("GuiAnimation.PushModal(TradeRequestGui, CancelButton", 1, true),
	"Trade requests must default gamepad focus to Cancel"
)
assert(
	purse:find('GameplayInputGate.SetActive("Backpack", MainFrame, open)', 1, true),
	"Open inventory must block world gamepad actions"
)

print("GamepadInputSupport.test.lua passed")
