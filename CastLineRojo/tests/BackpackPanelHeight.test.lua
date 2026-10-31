local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")

assert(controller:find('WaitForChild("Hotbar", 30)', 1, true), "BackpackPanel must bind the Hotbar")
assert(controller:find("backpackHotbar.AbsoluteSize.Y", 1, true), "BackpackPanel height must use Hotbar's actual height")
assert(controller:find('GetPropertyChangedSignal("AbsoluteSize")', 1, true), "BackpackPanel must update when Hotbar size changes")
assert(controller:find("clearBackpackHotbarBinding", 1, true), "BackpackPanel Hotbar binding must be cleaned up")
assert(controller:find("PlayerGUI.ChildRemoved", 1, true), "BackpackPanel must clean up when BackpackGui is rebuilt")

print("BackpackPanelHeight.test.lua passed")
