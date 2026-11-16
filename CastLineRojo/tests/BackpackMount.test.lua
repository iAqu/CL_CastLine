-- Execute the production mount block with both possible CoreGui startup states.
local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau", "r"))
local source = file:read("*a")
file:close()
local first = assert(source:find("-- Make the main frame, which (mostly) covers the screen", 1, true))
local last = assert(source:find("-- Make the HotbarFrame", first, true))
local mount = source:sub(first, last - 1)
for _, coreEnabled in ipairs({ true, false }) do
	local backpackGui = {}
	local env = {
		BackpackGui = backpackGui,
		FFlagMountCoreGuiBackpack = true,
		StarterGui = {
			GetCoreGuiEnabled = function()
				return coreEnabled
			end,
		},
		Enum = { CoreGuiType = { Backpack = "Backpack" } },
		NewGui = function()
			return { Visible = true }
		end,
	}
	assert(load(mount, "Purse mount", "t", env))()
	assert(
		env.MainFrame.Parent == backpackGui,
		"Custom backpack must mount even when the default backpack was disabled before initialization"
	)
	assert(env.MainFrame.Visible, "A mounted custom backpack must keep its hotbar visible")
end

-- The hidden close button must release modal input, even with queued events.
local headerStart = assert(source:find("local closeButton = createCloseButton()", 1, true))
local headerEnd = assert(source:find("closeButton.Parent = InventoryFrame", headerStart, true))
local listeners = {}
local backpack = {
	IsOpen = false,
	StateChanged = { Event = {
		Connect = function(_, callback)
			table.insert(listeners, callback)
		end,
	} },
}
local env = {
	BackpackScript = backpack,
	createCloseButton = function()
		return {}
	end,
}
local closeButton = assert(
	load(source:sub(headerStart, headerEnd - 1) .. "\nreturn closeButton", "Purse close-button modal state", "t", env)
)()
assert(closeButton.Modal == false, "A closed backpack must not leave modal input active")
backpack.IsOpen = true
for _, callback in ipairs(listeners) do
	callback(true)
end
assert(closeButton.Modal == true)
backpack.IsOpen = false
for _, callback in ipairs(listeners) do
	callback(true)
end
assert(closeButton.Modal == false, "Queued events must read the actual current window state")
