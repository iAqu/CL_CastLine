local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local util = read("src/ReplicatedStorage/Modules/CarryCapacityUtil.lua")
local service = read("src/ServerScriptService/Services/CarryCapacityService.lua")
local digService = read("src/ServerScriptService/Services/DigItemService.lua")
local drownDropService = read("src/ServerScriptService/Services/DrownDropService.lua")
local pedestalService = read("src/ServerScriptService/Services/PlotPedestalService.lua")
local homeController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")

assert(util:find("getPlacedItemIds", 1, true), "Displayed plot items must not count as carried")
assert(util:find("CarryCapacityUtil.GetCapacity", 1, true), "Capacity must come from the carry upgrade")
assert(service:find('Name = "CarryCapacityService"', 1, true), "Capacity needs an authoritative server service")
assert(service:find("CarriedWeightKg", 1, true) or util:find("CarriedWeightKg", 1, true), "Current weight must replicate to the client")
assert(digService:find('Reason = "Not enough carry weight"', 1, true), "Digging must reject items that do not fit")
assert(not drownDropService:find("carryCapacityService:CanCarry", 1, true), "Drowned item pickup must not enforce capacity")
assert(not pedestalService:find("CanSetCarriedWeight", 1, true), "Pedestal swaps must not enforce net carried weight")
assert(not pedestalService:find("CanCarry(player, itemData.Weight)", 1, true), "Pedestal pickup must not enforce capacity")
assert(homeController:find("BackpackWeightLabel.Text", 1, true), "The HUD must show current and maximum weight")
assert(homeController:find("BackpackFill.Size", 1, true), "The HUD bar must reflect capacity usage")

print("CarryCapacity.test.lua passed")
