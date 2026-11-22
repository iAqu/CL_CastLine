-- Exercise the real topbar adapter, including queued user toggle events.
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
local changed = signal()
local contextChanged = signal()
local contexts = {}
local gate = {
	ContextChanged = contextChanged,
	IsActive = function(name)
		return contexts[name] == true
	end,
}
local function setContext(name, active)
	contexts[name] = active
	contextChanged:Fire(name)
end
local trainingChanged = signal()
local training = false
local player = {
	GetAttribute = function()
		return training
	end,
	GetAttributeChangedSignal = function()
		return trainingChanged
	end,
}
local backpack = { IsOpen = false, StateChanged = { Event = changed } }
local toggleCount = 0
local function setOpen(open)
	if backpack.IsOpen ~= open then
		backpack.IsOpen = open
		setContext("Backpack", open)
		changed:Fire(open)
	end
end
backpack.Open = function()
	setOpen(true)
end
backpack.Close = function()
	setOpen(false)
end
backpack.OpenClose = function()
	toggleCount = toggleCount + 1
	setOpen(not backpack.IsOpen)
end
local icon = { toggled = signal(), selected = false }
local labelContainer = { attributes = {} }
function labelContainer:SetAttribute(name, value)
	self.attributes[name] = value
end
function icon:getInstance(name)
	assert(name == "IconLabelContainer", "The width attribute belongs on the label container")
	return labelContainer
end
function icon:modifyTheme(modification)
	assert(
		modification[1] == "IconLabel" and modification[2] == "AutoLocalize" and modification[3] == false,
		"The theme should only disable translation for the font icon"
	)
end
for _, name in ipairs({
	"setLabel",
	"setTextSize",
	"setTextFont",
	"setOrder",
	"bindToggleKey",
	"autoDeselect",
	"setCaption",
}) do
	icon[name] = function() end
end
function icon:select(source)
	if self.selected then
		return
	end
	self.selected = true
	self.toggled:Fire(true, source)
end
function icon:deselect(source)
	if not self.selected then
		return
	end
	self.selected = false
	self.toggled:Fire(false, source)
end
function icon:setEnabled(value)
	self.enabled = value
end
local iconModule = {
	highlightKey = "DPadUp",
	new = function()
		return icon
	end,
}
local parent = {}
local storage = {
	Packages = { TopbarPlus = iconModule },
	Modules = { GameplayInputGate = gate },
}
local env = setmetatable({
	game = {
		GetService = function(_, name)
			return if name == "Players" then { LocalPlayer = player } else storage
		end,
	},
	script = { Parent = parent },
	task = { defer = function(callback) callback() end },
	require = function(module)
		return if module == parent then backpack else module
	end,
	Enum = { FontWeight = { Bold = 1, Regular = 2 }, FontStyle = { Normal = 1 }, KeyCode = { Backquote = 1 } },
}, { __index = getfenv() })
local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Purse/TopbarIcon.client.luau", "r"))
local source = file:read("*a")
file:close()
local adapter = assert(loadstring(source, "Purse topbar adapter"), "The topbar adapter must compile")
setfenv(adapter, env)
adapter()
assert(labelContainer.attributes.TargetWidth == 0, "The label container must set its width through an attribute")
assert(iconModule.highlightKey == "DPadUp", "Preserve the existing topbar shortcut")
setContext("Popup", true)
assert(iconModule.highlightKey == false, "An open popup must receive DPadUp for navigation")
setContext("Popup", false)
assert(iconModule.highlightKey == "DPadUp", "Closing a popup restores the topbar shortcut")
icon:select("User")
assert(backpack.IsOpen, "Selecting the icon must open the backpack")
assert(iconModule.highlightKey == false, "An open backpack must receive DPadUp for navigation")
setContext("Popup", true)
backpack.Close()
assert(iconModule.highlightKey == false, "Closing a backpack under a popup must keep DPadUp in the popup")
setContext("Popup", false)
assert(iconModule.highlightKey == "DPadUp", "Closing both interfaces restores the original shortcut")
assert(not icon.selected, "Closing the backpack must deselect the icon")
-- A delayed deselect event after a close must never re-open the inventory.
icon.toggled:Fire(false, "User")
assert(not backpack.IsOpen, "A stale user deselect must keep the backpack closed")
for _ = 1, 4 do
	icon:select("User")
	assert(backpack.IsOpen and icon.selected, "Opening the backpack must keep the icon selected")
	backpack.Close()
	assert(not backpack.IsOpen and not icon.selected, "Closing the backpack must clear the selected state")
end
assert(toggleCount == 0, "Topbar requests absolute open/close state instead of blindly toggling")
training = true
trainingChanged:Fire()
assert(icon.enabled == false and not backpack.IsOpen, "Training hides the backpack entrance")
icon.toggled:Fire(true, "User")
assert(not backpack.IsOpen, "Queued toggles must not open the backpack while training")
training = false
trainingChanged:Fire()
assert(icon.enabled == true and not backpack.IsOpen, "Stop restores the entrance without reopening inventory")
