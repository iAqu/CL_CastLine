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
for _, name in ipairs({
	"modifyTheme",
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
	new = function()
		return icon
	end,
}
local parent = {}
local storage = { Packages = { TopbarPlus = iconModule } }
local env = setmetatable({
	game = {
		GetService = function(_, name)
			return if name == "Players" then { LocalPlayer = player } else storage
		end,
	},
	script = { Parent = parent },
	require = function(module)
		return module == parent and backpack or iconModule
	end,
	Enum = { FontWeight = { Bold = 1, Regular = 2 }, FontStyle = { Normal = 1 }, KeyCode = { Backquote = 1 } },
}, { __index = _G })
local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Purse/TopbarIcon.client.luau", "r"))
local source = file:read("*a")
file:close()
assert(load(source, "Purse topbar adapter", "t", env))()
icon:select("User")
assert(backpack.IsOpen)
backpack.Close()
assert(not icon.selected)
-- A delayed deselect event after a close must never re-open the inventory.
icon.toggled:Fire(false, "User")
assert(not backpack.IsOpen, "A stale user deselect must keep the backpack closed")
for _ = 1, 4 do
	icon:select("User")
	assert(backpack.IsOpen and icon.selected)
	backpack.Close()
	assert(not backpack.IsOpen and not icon.selected)
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
