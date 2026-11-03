local file = assert(io.open("src/ReplicatedStorage/Modules/GameplayInputGate.lua", "r"))
local source = file:read("*a")
file:close()

local guiService = { MenuIsOpen = false }
local focusedTextBox = nil
local services = {
	GuiService = guiService,
	UserInputService = {
		GetFocusedTextBox = function()
			return focusedTextBox
		end,
	},
}
local environment = setmetatable({
	game = {
		GetService = function(_, name)
			return assert(services[name])
		end,
	},
}, { __index = getfenv() })
local gate = assert(load(source, "GameplayInputGate", "t", environment))()
local fishing, anotherFishing, popup, backpack = {}, {}, {}, {}

assert(gate.IsWorldActionAllowed() and gate.IsPlacementActionAllowed())
gate.SetActive("Fishing", fishing, true)
assert(not gate.IsWorldActionAllowed() and not gate.IsPlacementActionAllowed(), "Preparing must block gameplay")
assert(not gate.IsUiBlockingWorld(), "Fishing itself must not block the screen tap that ends preparation")
gate.SetActive("Fishing", anotherFishing, true)
gate.SetActive("Fishing", fishing, false)
assert(not gate.IsWorldActionAllowed(), "One cleanup must not release another active fishing context")
gate.SetActive("Fishing", anotherFishing, false)
assert(gate.IsWorldActionAllowed(), "Cleanup must restore gameplay")

gate.SetActive("Fishing", fishing, true)
gate.SetActive("Popup", popup, true)
assert(gate.IsUiBlockingWorld(), "Popup input must not return the player to spawn")
gate.SetActive("Fishing", fishing, false)
assert(not gate.IsWorldActionAllowed(), "Fishing cleanup must preserve the popup's input lock")
gate.SetActive("Popup", popup, false)
gate.SetActive("Backpack", backpack, true)
assert(gate.IsUiBlockingWorld() and not gate.IsWorldActionAllowed())
gate.SetActive("Backpack", backpack, false)

guiService.MenuIsOpen = true
assert(gate.IsUiBlockingWorld() and not gate.IsWorldActionAllowed())
guiService.MenuIsOpen = false
focusedTextBox = {}
assert(gate.IsUiBlockingWorld() and not gate.IsWorldActionAllowed())
focusedTextBox = nil
assert(gate.IsWorldActionAllowed() and gate.IsPlacementActionAllowed())
