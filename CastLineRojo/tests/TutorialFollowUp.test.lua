-- Run from SeaDigRojo: lua tests/TutorialFollowUp.test.lua
-- Execute the controller's real functions with UI/engine dependencies replaced.
local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/TutorialController.lua", "r"))
local source = file:read("*a")
file:close()

local env = setmetatable({}, { __index = _G })
local function bind(name, arguments)
	local first = assert(source:find("local function " .. name .. "(", 1, true))
	local last = source:find("\nlocal function ", first + 1, true)
	local body = source:sub(first, last - 1)
	-- Only remove the selected function's Luau signature; keep its body intact.
	body = body:gsub("^[^\n]+", "local function " .. name .. "(" .. arguments .. ")", 1)
	env[name] = assert(load(body .. "\nreturn " .. name, name, "t", env))()
end

local inside, closeButton, upgradeButton, tool, root, frame
local function part(position)
	return { Position = position, IsA = function(_, class) return class == "BasePart" end }
end
root = part("player position")
local character = { FindFirstChild = function() return root end }
local vectorMeta = { __add = function(a, b) return { X = a.X + b.X, Y = a.Y + b.Y, Z = a.Z + b.Z } end }
local function vector(x, y, z) return setmetatable({ X = x, Y = y, Z = z }, vectorMeta) end
local zonePart = part(vector(10, 20, 30))
zonePart.Size = vector(100, 38, 100)
zonePart.CFrame = { PointToWorldSpace = function(_, offset) return zonePart.Position + offset end }
local zone = { FindFirstChild = function() return zonePart end }
local areas = { FindFirstChild = function() return zone end }
env.Vector3 = { new = vector }
env.Workspace = { FindFirstChild = function() return areas end }
env.TutorialConfig = { GUIDED_ZONE_ID = "Zone_1" }
env.Constants = { TUTORIAL_ENABLED = true }
env.LOCAL_PLAYER = { Character = character, GetAttribute = function() return inside end }
env.TUTORIAL_FOLDER = {}
env.BEAM_HOLDER = {}
env.BEAM_PART = {}
env.RunService = { RenderStepped = { Connect = function(_, callback)
	frame = callback
	return { Disconnect = function() frame = nil end }
end } }
env.setUiHighlight = function(target) env.highlight = target end
env.stopCountdown = function() end
env.showHint = function(text) env.hint = text end
env.stopGuide = function() env.hint = nil; env.hideBeam(); env.setUiHighlight(nil) end
env.getInstancePosition = function(instance) return instance and instance.Position end
env.findShovelCloseButton = function() return closeButton end
env.findBackpackUpgradeButton = function() return upgradeButton end
env.findTool = function() return tool end
env.findBackpackSlotForTool = function() return "item slot" end
env.getFirstEmptyPedestal = function() return part("empty pedestal") end
env.getShop = function() return part("upgrade shop") end
local cashTarget = part("cash pool")
env.getCashPoolTarget = function(slot) return slot > 0 and cashTarget or nil end

bind("hideBeam", "")
bind("showBeam", "resolver")
bind("getDigZoneTarget", "")
-- The old controller has no retry helper; still run its original refreshGuide
-- so the pre-fix failure reports the wrong Cash hint, not a missing symbol.
if source:find("local function showFindAnotherItem(", 1, true) then
	bind("showFindAnotherItem", "")
end
bind("refreshGuide", "")

local function state(overrides)
	local result = {
		completed = true, returnedToDigZone = true, secondItemInstanceId = "",
		secondItemPlaced = false, cashPoolSlot = 0, cashCollected = false,
		backpackEligible = false, backpackUpgraded = false,
	}
	for key, value in pairs(overrides or {}) do result[key] = value end
	return result
end
local function refresh(value, hint)
	env.tutorialState = value
	env.refreshGuide()
	if frame then frame() end
	assert(env.hint == hint, "Expected " .. tostring(hint) .. ", got " .. tostring(env.hint))
end
local function hidden()
	assert(env.BEAM_HOLDER.Parent == nil and env.BEAM_PART.Parent == nil, "Arrow must be hidden")
end
local function visible(position)
	assert(env.BEAM_HOLDER.Parent == env.TUTORIAL_FOLDER and env.BEAM_PART.Parent == env.TUTORIAL_FOLDER)
	assert(env.BEAM_PART.Position == position)
end

-- Entered the zone, but no successful second dig: never skip to Cash.
inside = true
refresh(state(), "Find another item")
hidden()
-- Death mid-dig and respawn outside: resume searching, targeting the surface.
env.LOCAL_PLAYER.Character = nil
refresh(state(), "Find another item")
hidden()
env.LOCAL_PLAYER.Character = character
inside = false
refresh(state(), "Find another item")
assert(env.BEAM_PART.Position.Y == 39, "Search arrow must target the top face, not the center")

-- Held item, then loss/death or sale: the same authoritative empty ID retries.
for _, reason in ipairs({ "death", "sale" }) do
	tool = { Parent = character }
	refresh(state({ secondItemInstanceId = "second-" .. reason }), "Place for Cash and Luck")
	visible("empty pedestal")
	tool = nil
	refresh(state(), "Find another item")
end
tool = { Parent = {} }
refresh(state({ secondItemInstanceId = "second" }), "Place for Cash and Luck")
hidden()
assert(env.highlight == "item slot")

refresh(state({ secondItemPlaced = true, cashPoolSlot = 1 }), "Collect your Cash")
visible("cash pool")
refresh(state({ secondItemPlaced = true, cashPoolSlot = 0 }), "Collect your Cash")
hidden()
refresh(state({ secondItemPlaced = true, cashPoolSlot = 1, cashCollected = true }), nil)
refresh(state({ secondItemPlaced = true, cashCollected = true, backpackEligible = true }), "Upgrade your backpack")
visible("upgrade shop")
upgradeButton = "buy backpack"
refresh(state({ secondItemPlaced = true, cashCollected = true, backpackEligible = true }), "Upgrade your backpack")
hidden()
assert(env.highlight == upgradeButton)
refresh(state({ secondItemPlaced = true, cashCollected = true, backpackEligible = true, backpackUpgraded = true }), nil)

closeButton = "close shop"
refresh(state({ returnedToDigZone = false }), "Close the shop")
hidden()
assert(env.highlight == closeButton)
closeButton = nil
refresh(state({ returnedToDigZone = false }), "Find another item")

-- A temporarily missing CashPool must hide, recover, and hide again without
-- another state push. Missing roots during respawn follow the same lifecycle.
cashTarget = nil
refresh(state({ secondItemPlaced = true, cashPoolSlot = 1 }), "Collect your Cash")
hidden()
assert(frame, "Missing targets must keep retrying")
cashTarget = part("loaded cash pool")
frame()
visible("loaded cash pool")
root = nil
frame()
hidden()
root = part("respawn position")
frame()
visible("loaded cash pool")
cashTarget = nil
frame()
hidden()
env.hideBeam()
assert(frame == nil, "Stopping guidance must disconnect the retry loop")

-- Positions must be set before parenting either part into the visible scene.
local positions = {}
local function checkedBeam(name)
	return setmetatable({}, {
		__index = function(_, key) if key == "Position" then return positions[name] end end,
		__newindex = function(_, key, value)
			if key == "Position" then positions[name] = value end
			if key == "Parent" and value then
				assert(positions.holder == root.Position and positions.target == "fresh target", "Stale arrow flashed before position update")
			end
		end,
	})
end
env.BEAM_HOLDER = checkedBeam("holder")
env.BEAM_PART = checkedBeam("target")
env.showBeam(function() return "fresh target" end)
frame()
env.hideBeam()
io.write("TutorialFollowUp.test.lua passed\n")
