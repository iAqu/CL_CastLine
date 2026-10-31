local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local animalPlacement = read("src/StarterPlayer/StarterPlayerScripts/Controllers/AnimalPlaceController.lua")
local propPlacement = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PropPlaceController.lua")
local homeGui = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")
local guiAnimation = read("src/ReplicatedStorage/Modules/GuiAnimation.lua")
local confirmGui = read("src/ReplicatedStorage/Modules/ConfirmGuiClient.lua")
local commonResultGui = read("src/ReplicatedStorage/Modules/CommonResultClient.lua")
local purse = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")
local tradeRequestGui = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeRequestGuiController.lua")
local storeGachaResultGui = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/StoreGachaResultGuiController.lua")

for name, placement in pairs({
	Animal = animalPlacement,
	Prop = propPlacement,
}) do
	assert(
		placement:find("Enum.KeyCode.ButtonR2", 1, true)
			and placement:find("Enum.KeyCode.ButtonB", 1, true),
		name .. " placement must support gamepad place and cancel"
	)
	assert(
		placement:find("Enum.UserInputType.MouseButton1", 1, true)
			and placement:find("Enum.UserInputType.Touch", 1, true),
		name .. " placement must preserve mouse and touch input"
	)
end

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
	commonResultGui:find("GuiAnimation.PushModal(clone, clone.Frame.ConfirmButton", 1, true),
	"Result dialogs must be dismissible with gamepad input"
)
assert(
	tradeRequestGui:find("GuiAnimation.PushModal(TradeRequestGui, CancelButton", 1, true),
	"Trade requests must default gamepad focus to Cancel"
)
assert(
	storeGachaResultGui:find("GuiAnimation.PushModal(resultGui, closeButton, finishResult)", 1, true),
	"Store gacha results must be dismissible with gamepad input"
)
assert(
	purse:find('GameplayInputGate.SetActive("Backpack", MainFrame, InventoryFrame.Visible)', 1, true),
	"Open inventory must block world gamepad actions"
)

print("GamepadInputSupport.test.lua passed")
