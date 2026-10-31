local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local util = read("src/ReplicatedStorage/Modules/PotionToolUtil.lua")
local potionService = read("src/ServerScriptService/Services/PotionService.lua")
local potionController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PotionToolController.lua")
local purse = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")
local heldItemClient = read("src/StarterPlayer/StarterPlayerScripts/Controllers/HeldItemVisualController.lua")
local heldItemService = read("src/ServerScriptService/Services/HeldItemVisualService.lua")

assert(util:find('models:FindFirstChild("Potion")', 1, true), "Potion tools must use Models.Potion templates")
assert(util:find('template:IsA("Model")', 1, true), "Potion templates must be Models")
assert(util:find('tool.CanBeDropped = false', 1, true), "Potion tools must not be droppable")
assert(util:find('tool:SetAttribute(PotionToolUtil.POTION_TOOL_ATTRIBUTE, true)', 1, true), "Potion tools must be identifiable")
assert(util:find('tool:SetAttribute(PotionToolUtil.POTION_COUNT_ATTRIBUTE, normalizedCount)', 1, true), "Potion tool counts must remain attribute-backed")

assert(potionService:find('PotionToolUtil.CreateTool(potionId, count)', 1, true), "PotionService must convert potion models to Tools")
assert(potionService:find('player.CharacterAdded:Connect', 1, true), "PotionService must rebuild potion Tools after respawn")
assert(potionService:find('self.Client.EquipPotion:Connect', 1, true), "Store use must equip through PotionService")

assert(potionController:find('Knit.CreateController', 1, true), "PotionToolController must remain a Knit controller stub")

assert(heldItemClient:find('PotionToolUtil.IsPotionTool(tool)', 1, true), "Held item client must recognize potion Tools")
assert(heldItemClient:find('kind = "potion"', 1, true), "Held item client must report potion descriptors")
assert(heldItemService:find('if kind == "potion" then', 1, true), "Held item server must validate potion descriptors")
assert(heldItemService:find('createPotionVisual(resolved.potionId)', 1, true), "Held item server must create potion visuals")

print("PotionToolConversion.test.lua passed")
