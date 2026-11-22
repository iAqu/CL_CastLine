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
local changed = {}
local environment = setmetatable({
	Instance = {
		new = function(class)
			assert(class == "BindableEvent", "Use an event for observers of input contexts")
			return {
				Event = {},
				Fire = function(_, context)
					table.insert(changed, context)
				end,
			}
		end,
	},
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
assert(#changed == 1 and changed[1] == "Fishing", "Nested sources must not duplicate change events")
gate.SetActive("Fishing", anotherFishing, false)
assert(gate.IsWorldActionAllowed(), "Cleanup must restore gameplay")
assert(#changed == 2 and changed[2] == "Fishing", "The last source must publish the release")

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

local training = {}
gate.SetActive("Training", training, true)
assert(not gate.IsPlacementActionAllowed(), "Training must block fish placement while holding a barbell")
assert(gate.IsWorldActionAllowed(), "Training must not block movement or its own upgrade prompt")
gate.SetActive("Training", training, false)
assert(gate.IsPlacementActionAllowed())
