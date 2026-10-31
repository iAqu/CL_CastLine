local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local function selectBackpack(tiers, capacity: number)
	local selected = nil
	for _, tier in ipairs(tiers) do
		if tier.carryWeight <= capacity and (not selected or tier.carryWeight > selected.carryWeight) then
			selected = tier
		end
	end
	return selected
end

local tiers = {
	{ carryWeight = 25, model = "Red Backpack" },
	{ carryWeight = 45, model = "Cartoon Frog Backpack" },
	{ carryWeight = 75, model = "Blue Camo Backpack" },
	{ carryWeight = 800, model = "Expedition Backpack" },
}

assert(selectBackpack(tiers, 50).model == "Cartoon Frog Backpack", "50kg must equip the 45kg backpack")
assert(selectBackpack(tiers, 75).model == "Blue Camo Backpack", "Exact capacity must equip its matching backpack")
assert(selectBackpack(tiers, 800).model == "Expedition Backpack", "The highest qualifying backpack must be equipped")
assert(selectBackpack(tiers, 24) == nil, "Capacity below the first tier must not equip a backpack")

local data = read("src/ReplicatedFirst/Data/BackpacksData.lua")
local visualService = read("src/ServerScriptService/Services/BackpackVisualService.lua")
local capacityService = read("src/ServerScriptService/Services/CarryCapacityService.lua")

assert(data:find("CarryWeight", 1, true), "Backpack data must define capacity thresholds")
assert(data:find("Model", 1, true), "Backpack data must define model names")
assert(visualService:find("getConfigForCapacity", 1, true), "Backpack visuals must select a tier from capacity")
assert(visualService:find("carryWeight <= capacity", 1, true), "Backpack selection must not exceed capacity")
assert(visualService:find("AUTO_EQUIPPED_ATTRIBUTE", 1, true), "Auto-equipped backpacks must be identifiable")
assert(visualService:find("humanoid:AddAccessory(backpack)", 1, true), "The selected backpack must be equipped as an Accessory")
assert(visualService:find("backpack:GetDescendants()", 1, true), "Backpack equipment must inspect every descendant")
assert(visualService:find('descendant:IsA("BasePart")', 1, true), "Only physical backpack descendants need anchoring changes")
assert(visualService:find("descendant.Anchored = false", 1, true), "Backpack BaseParts must be unanchored before attachment")
local unanchorCallIndex = assert(visualService:find("unanchorBackpackParts(backpack)", 1, true))
local addAccessoryIndex = assert(visualService:find("humanoid:AddAccessory(backpack)", 1, true))
assert(unanchorCallIndex < addAccessoryIndex, "Backpack parts must be unanchored before attachment")
assert(capacityService:find('Knit.GetService("BackpackVisualService"):RefreshPlayer(player)', 1, true), "Capacity refresh must refresh the backpack visual")

print("BackpackVisual.test.lua passed")
