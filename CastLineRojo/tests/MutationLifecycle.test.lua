local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local statUtil = read("src/ReplicatedStorage/Modules/ItemStatUtil.lua")
local titleUtil = read("src/ReplicatedStorage/Modules/MutationTitleUtil.lua")
local visualUtil = read("src/ReplicatedStorage/Modules/MutationVisualUtil.lua")
local toolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")
local grantUtil = read("src/ServerScriptService/Services/ItemGrantUtil.lua")
local digService = read("src/ServerScriptService/Services/DigItemService.lua")
local giftService = read("src/ServerScriptService/Services/GiftService.lua")
local drownService = read("src/ServerScriptService/Services/DrownDropService.lua")
local pedestalService = read("src/ServerScriptService/Services/PlotPedestalService.lua")
local sellService = read("src/ServerScriptService/Services/SellService.lua")
local cashService = read("src/ServerScriptService/Services/PlotCashPoolService.lua")
local digController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")
local heldController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/HeldItemVisualController.lua")
local drownController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DrownDropController.lua")
local pedestalController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotPedestalController.lua")

assert(statUtil:find("mutationPriceRate: number?", 1, true), "Price calculation must accept a Mutation rate")
assert(statUtil:find("* mutationMultiplier", 1, true), "Mutation PriceRate must multiply item value")
assert(grantUtil:find("MutationId: string?", 1, true), "Grant options must accept a forced MutationId")
assert(grantUtil:find("MutationId = mutationId", 1, true), "Granted items must persist MutationId")
assert(digService:find("MutationId = roll.mutationId", 1, true), "Only the locked dig roll may inject MutationId")

for name, source in pairs({
	tool = toolUtil,
	gift = giftService,
	drown = drownService,
	pedestal = pedestalService,
	sell = sellService,
	cash = cashService,
}) do
	assert(source:find("MutationId", 1, true), name .. " path must preserve or consume MutationId")
end

assert(titleUtil:find('FindFirstChild("MutationFrame")', 1, true), "Mutation labels must use the AF-style frame")
assert(titleUtil:find("config.Icon", 1, true), "Mutation labels must use the configured icon")
assert(titleUtil:find("MutationDataUtil.GetLabelColor", 1, true), "Mutation labels must use LabelColor")
assert(titleUtil:find('mutationId ~= "Rainbow"', 1, true), "Rainbow titles need their special gradient")
assert(titleUtil:find('CollectionService:AddTag(marker, "LocalScriptAttach")', 1, true), "Rainbow title gradients must attach their client animation")
assert(visualUtil:find('Golden = "EffectPart_Golden"', 1, true), "Golden particles must use the authored asset")
assert(visualUtil:find('Diamond = "EffectPart_Diamond"', 1, true), "Diamond particles must use the authored asset")
assert(visualUtil:find('Rainbow = "EffectPart_Rainbow"', 1, true), "Rainbow particles must use the authored asset")
assert(visualUtil:find("WeldConstraint", 1, true), "Mutation particles must follow moving items")
assert(visualUtil:find("LockedToPart = true", 1, true), "Mutation particles must remain locked to the effect part")
assert(visualUtil:find("for _, descendant in target:GetDescendants()", 1, true), "Reapplying a Mutation must remove duplicate effect parts")

assert(toolUtil:find("MutationTitleUtil.Show", 1, true) and toolUtil:find("MutationVisualUtil.Apply", 1, true), "Held tools must show both Mutation label and particles")
assert(digController:find("MutationTitleUtil.Show", 1, true) and digController:find("MutationVisualUtil.Apply", 1, true), "Dig reveals must show both Mutation label and particles")
assert(heldController:find("MutationTitleUtil.Show", 1, true), "Local held title replacements must retain the Mutation label")
assert(drownController:find("MutationTitleUtil.Show", 1, true), "Drowned item titles must retain the Mutation label")
assert(pedestalController:find("MutationTitleUtil.Show", 1, true) and pedestalController:find("MutationVisualUtil.Apply", 1, true), "Pedestal displays must show both Mutation label and particles")

print("MutationLifecycle.test.lua passed")
