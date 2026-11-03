local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotPedestalController.lua")
local service = read("src/ServerScriptService/Services/PlotPedestalService.lua")
local refreshPrompt = assert(
	controller:match("local function refreshPrompt%b()%s*(.-)\nend\n\nlocal function getPedestalBounds"),
	"Could not locate the pedestal prompt refresh function"
)
local activatePedestal = assert(
	controller:match("local function activatePedestal%b()%s*(.-)\nend\n\nlocal function bindPedestal"),
	"Could not locate the pedestal activation function"
)

assert(
	controller:find("local function isPickupHandState(heldTool: Tool?): boolean", 1, true)
		and controller:find("return heldTool == nil", 1, true),
	"Empty hands must share the pickup state"
)
assert(
	refreshPrompt:find("if ItemToolUtil.IsItemTool(heldTool) then", 1, true),
	"Displayable item tools must enable the place or swap prompt"
)
assert(refreshPrompt:find('prompt.ActionText = hasDisplayedItem(pedestal) and "Swap" or "Place"', 1, true))
assert(
	refreshPrompt:find("if isPickupHandState(heldTool) and hasDisplayedItem(pedestal) then", 1, true),
	"Empty hands must expose Pick Up only when the pedestal contains an item"
)
assert(
	refreshPrompt:match("prompt%.Enabled = false%s*$"),
	"Empty pedestals and non-displayable held tools must keep the prompt disabled"
)

assert(
	activatePedestal:find("local canPickup = isPickupHandState(heldTool) and hasDisplayedItem(pedestal)", 1, true),
	"Pedestal activation must allow pickup with empty hands"
)
assert(
	activatePedestal:find("if not heldItemTool and not canPickup then", 1, true),
	"Pedestal activation must still reject other non-displayable held tools"
)
assert(
	activatePedestal:find("request = service:placeItem(slot, itemUid)", 1, true),
	"Holding a displayable item must place or swap it"
)
assert(
	activatePedestal:find("request = service:pickupItem(slot)", 1, true),
	"Empty-handed activation must preserve displayed-item pickup"
)

assert(
	service:find("return heldTool == nil", 1, true),
	"The server must permit displayed-item pickup with empty hands"
)

print("PlotPedestalPromptVisibility.test.lua passed")
