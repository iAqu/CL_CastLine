local file = assert(io.open("src/ReplicatedFirst/LoadingScreen.client.lua", "r"))
local source = file:read("*a")
file:close()

local first = assert(source:find("local function hideSceneGui(", 1, true))
local last = assert(source:find("local function anchorCharacter(", first, true))
local functions = source:sub(first, last - 1) .. "\nreturn hideSceneGuis, restoreSceneGuis"

local function signal()
	local callbacks = {}
	return {
		Connect = function(_, callback)
			callbacks[callback] = true
			return {
				Disconnect = function()
					callbacks[callback] = nil
				end,
			}
		end,
		Fire = function(_, ...)
			for callback in pairs(callbacks) do
				callback(...)
			end
		end,
	}
end

local function root(descendants)
	return {
		DescendantAdded = signal(),
		GetDescendants = function()
			return descendants
		end,
	}
end

local loadingPart = {}
local function sceneGui(class, distance, enabled, inLoadingPart)
	local changed = signal()
	local attributes = {}
	local gui = { Enabled = enabled, Parent = {}, CurrentDistance = distance }
	function gui:IsA(name)
		return class == name
	end
	function gui:IsDescendantOf(part)
		return inLoadingPart and part == loadingPart
	end
	function gui:GetAttribute(name)
		return attributes[name]
	end
	function gui:SetAttribute(name, value)
		attributes[name] = value
	end
	function gui:GetPropertyChangedSignal(property)
		assert(property == "MaxDistance", "The gate should watch distance")
		return changed
	end
	return setmetatable(gui, {
		__index = function(self, key)
			assert(key == "MaxDistance", "Unexpected GUI property read: " .. key)
			return self.CurrentDistance
		end,
		__newindex = function(self, key, value)
			assert(key == "MaxDistance", "Unexpected GUI property write: " .. key)
			if self.CurrentDistance ~= value then
				self.CurrentDistance = value
				changed:Fire()
			end
		end,
	})
end

local hiddenDistance = 0.01
local originalDistanceAttribute = "LoadingSceneGuiOriginalDistance"
local sign = sceneGui("BillboardGui", math.huge, true)
local panel = sceneGui("SurfaceGui", 100, false)
local loading = sceneGui("SurfaceGui", 0, true, true)
local unrelated = sceneGui("ScreenGui", 100, true)
local workspace = root({ sign, loading })
local playerGui = root({ panel, unrelated })
local loadSceneUi = assert(loadstring(functions, "Loading scene UI"))
setfenv(loadSceneUi, setmetatable({
	Workspace = workspace,
	playerGui = playerGui,
	loadingPart = loadingPart,
	sceneGuiStates = {},
	sceneGuiConnections = {},
	HIDDEN_SCENE_GUI_DISTANCE = hiddenDistance,
	SCENE_GUI_ORIGINAL_DISTANCE = originalDistanceAttribute,
}, { __index = getfenv() }))
local start, restore = loadSceneUi()

start()
assert(sign.MaxDistance == hiddenDistance and panel.MaxDistance == hiddenDistance, "Hide both scene GUI types")
assert(loading.MaxDistance == 0 and unrelated.MaxDistance == 100, "Keep Loading and screen GUIs out of the scene gate")
assert(sign.Enabled and not panel.Enabled, "The gate must leave controller-owned Enabled alone")

local late = sceneGui("SurfaceGui", 0, true)
playerGui.DescendantAdded:Fire(late)
assert(late.MaxDistance == hiddenDistance, "Hide panels added during the transition")
workspace.DescendantAdded:Fire(sign)
sign.Enabled = false
panel.MaxDistance = 73
assert(panel.MaxDistance == hiddenDistance, "Distance changes must stay hidden until release")

local clone = sceneGui("SurfaceGui", panel.MaxDistance, true)
clone:SetAttribute(originalDistanceAttribute, panel:GetAttribute(originalDistanceAttribute))
workspace.DescendantAdded:Fire(clone)
local configuredClone = sceneGui("SurfaceGui", 50, true)
configuredClone:SetAttribute(originalDistanceAttribute, panel:GetAttribute(originalDistanceAttribute))
workspace.DescendantAdded:Fire(configuredClone)
assert(clone.MaxDistance == hiddenDistance and configuredClone.MaxDistance == hiddenDistance, "Hide both kinds of clone")

restore()
assert(sign.MaxDistance == math.huge and not sign.Enabled, "Restore an unlimited sign that its controller disabled")
assert(panel.MaxDistance == 73 and not panel.Enabled, "Restore the latest panel distance and keep its disabled state")
assert(late.MaxDistance == 0 and late.Enabled, "Restore the new panel's original distance")
assert(clone.MaxDistance == 73, "Restore the template's intended distance on a clone made during Loading")
assert(configuredClone.MaxDistance == 50, "An explicit clone distance takes precedence over the template snapshot")
assert(clone:GetAttribute(originalDistanceAttribute) == nil and panel:GetAttribute(originalDistanceAttribute) == nil,
	"Clear temporary distance attributes on templates and clones")
restore()
local after = sceneGui("BillboardGui", 80, true)
workspace.DescendantAdded:Fire(after)
assert(after.MaxDistance == 80, "Restore must disconnect the descendant watchers")
panel.MaxDistance = 42
assert(panel.MaxDistance == 42, "Restore must disconnect per-GUI watchers")
