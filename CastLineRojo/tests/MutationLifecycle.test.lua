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
local giftService = read("src/ServerScriptService/Services/GiftService.lua")
local drownService = read("src/ServerScriptService/Services/DrownDropService.lua")
local plotFishService = read("src/ServerScriptService/Services/PlotFishService.lua")
local sellService = read("src/ServerScriptService/Services/SellService.lua")
local cashService = read("src/ReplicatedStorage/Modules/PlotFishIncome.lua")
local drownController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DrownDropController.lua")
local plotFishController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotFishController.lua")

assert(statUtil:find("mutationPriceRate: number?", 1, true), "Price calculation must accept a Mutation rate")
assert(statUtil:find("* mutationMultiplier", 1, true), "Mutation PriceRate must multiply item value")
assert(grantUtil:find("MutationId: string?", 1, true), "Grant options must accept a forced MutationId")
assert(grantUtil:find("MutationId = mutationId", 1, true), "Granted items must persist MutationId")

for name, source in pairs({
	tool = toolUtil,
	gift = giftService,
	drown = drownService,
	plotFish = plotFishService,
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

assert(toolUtil:find("MutationVisualUtil.Apply", 1, true), "Held tools must keep their Mutation particles")
assert(drownController:find("MutationTitleUtil.Show", 1, true), "Drowned item titles must retain the Mutation label")
assert(plotFishController:find("FishTitleUtil.Create(titleGui, item, mutationId, owner, weight)", 1, true), "Roaming fish titles must include weight")
assert(plotFishController:find("MutationVisualUtil.Apply", 1, true), "Roaming fish must keep their Mutation particles")

local function loadSource(path, globals)
	return assert(load(read(path), path, "t", setmetatable(globals, { __index = getfenv() })))()
end

local modulesPath = "src/ReplicatedStorage/Modules/"
local mutations = dofile("src/ReplicatedFirst/Data/MutationsData.lua")
local mutationData = loadSource(modulesPath .. "MutationDataUtil.lua", {
	game = { GetService = function() return { Data = { MutationsData = mutations } } end },
	require = function(value) return value end,
})
local income = loadSource(modulesPath .. "PlotFishIncome.lua", {
	script = { Parent = { FishInventoryData = {}, ItemStatUtil = require("./helpers/ItemStats"), MutationDataUtil = mutationData, PlotPlacementUtil = {} } },
	require = function(value) return value end,
})
local modules = {
	MutationDataUtil = mutationData,
	NumberUtil = { FormatItemPriceCompact = tostring },
	PlotFishIncome = income,
}
local fishTitle = loadSource(modulesPath .. "FishTitleUtil.lua", {
	game = { GetService = function() return { Modules = modules } end },
	require = function(value) return value end,
})

local function instance(className, children)
	return {
		IsA = function(_, class) return class == className end,
		FindFirstChild = function(_, name) return children and children[name] end,
	}
end

local mutationNames = { "Golden", "Diamond", "Mint", "Rainbow" }
local template = instance("BillboardGui")
function template:Clone()
	local labels = { NameLabel = instance("TextLabel"), CpsLabel = instance("TextLabel") }
	for _, name in mutationNames do
		local label = instance("TextLabel")
		label.Text = name
		label.Visible = name == "Golden"
		labels["MutationLabel_" .. name] = label
	end
	return instance("BillboardGui", { Frame = instance("Frame", labels) })
end

local titleGui = instance("ScreenGui", { FishTitleTemplate = template })
local item = { DisplayName = "Duck", CpsPrice = 5 }
local function assertFishTitle(mutationId, expectedLabel, expectedCps)
	local title = assert(fishTitle.Create(titleGui, item, mutationId))
	local frame = assert(title:FindFirstChild("Frame"))
	assert(frame:FindFirstChild("NameLabel").Text == item.DisplayName, "Fish titles must show only the fish name")
	assert(frame:FindFirstChild("CpsLabel").Text == expectedCps)
	for _, name in mutationNames do
		local label = frame:FindFirstChild("MutationLabel_" .. name)
		assert(label.Visible == (name == expectedLabel), "Wrong visibility for " .. name .. " on " .. tostring(mutationId))
		assert(label.Text == name, "Keep the authored mutation label text")
	end
end

assertFishTitle(nil, nil, "$5/s")
assertFishTitle("Golden", "Golden", "$7/s")
assertFishTitle("Diamond", "Diamond", "$10/s")
assertFishTitle("Rainbow", "Rainbow", "$12/s")
assertFishTitle("Mint", nil, "$5/s")
assertFishTitle("Unknown", nil, "$5/s")
assert(fishTitle.Create(nil, item, nil) == nil, "Missing templates must allow the caller to fall back")

print("MutationLifecycle.test.lua passed")
