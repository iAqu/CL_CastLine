local function read(path)
	local f = assert(io.open(path, "r"))
	local source = f:read("*a")
	f:close()
	return source
end
local function loadSource(path, env)
	return assert(load(read(path), path, "t", setmetatable(env, { __index = getfenv() })))()
end
local function instance(class, name, parent)
	local o = { ClassName = class, Name = name or class, children = {}, attributes = {}, Archivable = true, Visible = true }
	function o:IsA(kind) return self.ClassName == kind end
	function o:GetAttribute(key) return self.attributes[key] end
	function o:SetAttribute(key, value) self.attributes[key] = value end
	function o:FindFirstChild(childName)
		for _, child in ipairs(self.children) do if child.Name == childName then return child end end
	end
	function o:GetChildren() return table.clone(self.children) end
	function o:GetDescendants()
		local descendants = {}
		for _, child in ipairs(self.children) do
			table.insert(descendants, child)
			for _, descendant in ipairs(child:GetDescendants()) do table.insert(descendants, descendant) end
		end
		return descendants
	end
	function o:IsDescendantOf(root)
		local current = self.Parent
		while current do if current == root then return true end; current = current.Parent end
		return false
	end
	function o:Destroy()
		for _, child in ipairs(self:GetChildren()) do child:Destroy() end
		self.Parent = nil
	end
	function o:Clone()
		local c = instance(self.ClassName, self.Name)
		for key, value in pairs(self) do
			if typeof(value) ~= "function" and key ~= "_parent" and key ~= "children" and key ~= "attributes" then c[key] = value end
		end
		c.attributes = table.clone(self.attributes)
		for _, child in ipairs(self.children) do if child.Archivable then child:Clone().Parent = c end end
		return c
	end
	setmetatable(o, {
		__index = function(self, key) return if key == "Parent" then rawget(self, "_parent") else self:FindFirstChild(key) end,
		__newindex = function(self, key, value)
			if key ~= "Parent" then rawset(self, key, value); return end
			local old = rawget(self, "_parent")
			if old then table.remove(old.children, assert(table.find(old.children, self))) end
			rawset(self, "_parent", value)
			if value then table.insert(value.children, self) end
		end,
	})
	if parent then o.Parent = parent end
	return o
end
local colors = { new = function() return "255,255,255" end, fromRGB = function(r, g, b) return string.format("%d,%d,%d", r, g, b) end }
local mutations = dofile("src/ReplicatedFirst/Data/MutationsData.lua")
local mutationData = loadSource("src/ReplicatedStorage/Modules/MutationDataUtil.lua", {
	game = { GetService = function() return { Data = { MutationsData = mutations } } end },
	require = function(value) return value end, Color3 = colors,
})
local modules = {
	FishInventoryData = {
		Fish = { DisplayName = "Test fish", CpsPrice = 100, DefaultWeight = 2, Rarity = "Common" },
		Event = { DisplayName = "Event fish", CpsPrice = 1.5, DefaultWeight = 2, Rarity = "Event" },
	},
	ItemToolUtil = {
		ITEM_ID_ATTRIBUTE = "ItemId", MUTATION_ID_ATTRIBUTE = "MutationId", WEIGHT_ATTRIBUTE = "Weight",
		IsItemTool = function(tool) return tool ~= nil and tool:GetAttribute("InventoryKind") == "Item" end,
	},
	MutationDataUtil = mutationData,
}
modules.PlotFishIncome = loadSource("src/ReplicatedStorage/Modules/PlotFishIncome.lua", {
	script = { Parent = { FishInventoryData = modules.FishInventoryData, ItemStatUtil = require("./helpers/ItemStats"), MutationDataUtil = mutationData, PlotPlacementUtil = {} } },
	require = function(value) return value end,
})
local formatMain = { NumberFormatter = { with = function() return { Format = function(_, value) return tostring(value) end } end } }
modules.NumberUtil = loadSource("src/ReplicatedStorage/Modules/NumberUtil.lua", {
	game = { GetService = function() return { Libs = { FormatNumber = { Main = formatMain, Simple = {} } } } end }, require = function(value) return value end,
})
local gameRoot = instance("DataModel", "game")
local storage = instance("Folder", "ReplicatedStorage", gameRoot)
storage.Modules = modules
local gradients = instance("Folder", "UIGradient", instance("Folder", "Gui", storage))
instance("UIGradient", "UIGradient_Mutation_Rainbow", gradients).Color = "rainbow"
local deferred, tagged = {}, {}
function gameRoot:GetService(name)
	if name == "ReplicatedStorage" then return storage end
	assert(name == "CollectionService")
	return { AddTag = function(_, marker, tag)
		assert(tag == "LocalScriptAttach")
		table.insert(tagged, marker)
	end }
end
local presentationEnv = {
	game = gameRoot, require = function(value) return value end,
	Instance = { new = instance }, Enum = { ScaleType = { Fit = "Fit" } },
	task = { defer = function(fn) table.insert(deferred, fn) end },
	warn = function(err) error(err) end,
}
modules.FishIconPresentation = loadSource("src/ReplicatedStorage/Modules/FishIconPresentation.lua", presentationEnv)
local presentation = loadSource("src/ReplicatedStorage/Modules/BackpackSlotPresentation.lua", presentationEnv)
local function flush()
	local jobs = table.clone(deferred)
	table.clear(deferred)
	for _, fn in ipairs(jobs) do fn() end
end
local owner = instance("Player", "Owner", gameRoot)
owner:SetAttribute("BestOwnedFishBaseCps", 1000)
local slot = instance("TextButton", "1", owner)
instance("ImageLabel", "Icon", slot)
for _, name in ipairs({ "CpsLabel", "Number", "ToolName", "ItemNameLabel", "ItemWeightLabel", "ItemLevelLabel", "StackCountLabel", "ToolTip" }) do
	instance("TextLabel", name, slot).Text = name
end
local tool = instance("Tool", "FishTool")
tool.TextureId = "fish-icon"
tool:SetAttribute("InventoryKind", "Item")
tool:SetAttribute("ItemId", "Fish")
tool:SetAttribute("Weight", 2)
local function checkLabels()
	for _, label in ipairs(slot:GetDescendants()) do
		if label:IsA("TextLabel") and label.Name ~= "Number" and label.Name ~= "CpsLabel" then
			assert(not label.Visible, label.Name .. " must stay hidden")
		end
	end
end
local function apply(mutationId, expectedColor, expectedCps)
	tool:SetAttribute("MutationId", mutationId)
	presentation.Apply(slot, tool, owner)
	flush()
	assert(slot.Icon.Image == "fish-icon", "Mutation must tint the fish image rather than replace it")
	assert(slot.Icon.ImageColor3 == expectedColor)
	assert(slot.CpsLabel.Visible and slot.CpsLabel.Text == expectedCps)
	assert(slot.Number.Text == "Number", "Presentation must preserve keyboard numbering text")
	checkLabels()
end
apply(nil, "255,255,255", "$100/s")
assert(slot.Number.Visible, "Desktop shortcut numbers must remain visible")
apply("Golden", "255,170,0", "$150/s")
apply("Diamond", "37,204,255", "$200/s")
apply("Rainbow", "255,255,255", "$250/s")
local rainbow = assert(slot.Icon:FindFirstChild("BackpackMutationRainbowGradient"))
assert(rainbow.Color == "rainbow" and rainbow.Enabled)
assert(#tagged == 1 and tagged[1].Name == "GUI_MovingRainbowGradient")
for _ = 1, 5 do presentation.Apply(slot, tool, owner) end
flush()
assert(slot.Icon:FindFirstChild("BackpackMutationRainbowGradient") == rainbow and #tagged == 1, "Refreshes must reuse one running rainbow gradient")
local ghost = slot:Clone()
local ghostGradient = ghost.Icon:FindFirstChild("BackpackMutationRainbowGradient")
assert(ghostGradient and not ghostGradient:FindFirstChild("GUI_MovingRainbowGradient"), "Drag ghosts must not copy a live animation script marker")
ghost:Destroy()
assert(rainbow.Parent == slot.Icon, "Destroying drag preview must retain the original animation")
slot.Parent = instance("Frame", "Inventory", owner)
presentation.Apply(slot, tool, owner)
flush()
assert(slot.Icon:FindFirstChild("BackpackMutationRainbowGradient") == rainbow and #tagged == 1, "Moving slots between hotbar and inventory must reuse the effect")
apply("Golden", "255,170,0", "$150/s")
assert(not slot.Icon:FindFirstChild("BackpackMutationRainbowGradient") and not rainbow.Parent)
apply("Unknown", "255,255,255", "$100/s")
-- Weight and the activity income baseline use the same production formula as fish titles.
tool:SetAttribute("Weight", 4)
presentation.Apply(slot, tool, owner)
local expected = modules.PlotFishIncome.GetCpsPrice(modules.FishInventoryData.Fish, 1, 1000, 4)
assert(expected > 100 and slot.CpsLabel.Text == "$" .. modules.NumberUtil.FormatItemPriceCompact(expected) .. "/s")
tool:SetAttribute("ItemId", "Event")
tool:SetAttribute("Weight", 2)
presentation.Apply(slot, tool, owner)
assert(slot.CpsLabel.Text == "$1.5K/s")
owner:SetAttribute("BestOwnedFishBaseCps", 2000)
presentation.Apply(slot, tool, owner)
assert(slot.CpsLabel.Text == "$3K/s")
slot.Number.Visible = false
presentation.Apply(slot, tool, owner)
assert(not slot.Number.Visible, "Mobile and inventory numbering must remain hidden")
tool:SetAttribute("ItemId", "Missing")
presentation.Apply(slot, tool, owner)
assert(not slot.CpsLabel.Visible and slot.CpsLabel.Text == "")
tool:SetAttribute("ItemId", "Fish")
apply("Rainbow", "255,255,255", "$250/s")
local rod = instance("Tool", "Rod")
rod.TextureId = "rod-icon"
presentation.Apply(slot, rod, owner)
assert(slot.Icon.Image == "rod-icon" and slot.Icon.ImageColor3 == "255,255,255")
assert(not slot.CpsLabel.Visible and not slot.Icon:FindFirstChild("BackpackMutationRainbowGradient"))
presentation.Apply(slot, nil, owner)
assert(slot.Icon.Image == "" and not slot.Icon.Visible and not slot.CpsLabel.Visible)
checkLabels()
-- Removing the slot before its deferred attachment must not start a stale animation.
tool:SetAttribute("MutationId", "Rainbow")
presentation.Apply(slot, tool, owner)
local before = #tagged
slot:Destroy()
flush()
assert(#tagged == before)

-- Run the real compact-slot guard in the stack count controller.
local stackSource = read("src/StarterPlayer/StarterPlayerScripts/Controllers/StackCountController.lua")
local start = assert(stackSource:find("local function refreshSlot", 1, true))
local finish = assert(stackSource:find("local function requestRefresh", start, true))
local refresh = assert(load(stackSource:sub(start, finish - 1) .. "\nreturn refreshSlot", "StackCount refresh", "t", setmetatable({ LABEL_NAME = "StackCountLabel" }, { __index = getfenv() })))()
local compact = instance("TextButton", "2")
compact:SetAttribute("MinimalSlotLabels", true)
instance("TextLabel", "StackCountLabel", compact).Text = "x99"
refresh(compact)
assert(not compact.StackCountLabel.Visible and compact.StackCountLabel.Text == "")
-- The real Purse reset supports templates with the internal ToolName node removed.
local purseSource = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")
local resetStart = assert(purseSource:find("local function resetSlotFrameForRuntime", 1, true))
local resetEnd = assert(purseSource:find("\nlocal function", resetStart + 1, true))
local reset = assert(load(purseSource:sub(resetStart, resetEnd - 1) .. "\nreturn resetSlotFrameForRuntime", "Purse reset", "t", setmetatable({
	NewGui = instance,
	ensureStackCountLabel = function(frame) return frame.StackCountLabel end,
}, { __index = getfenv() })))()
local missingName = instance("TextButton", "BackpackSlot")
instance("ImageLabel", "Icon", missingName)
for _, name in ipairs({ "CpsLabel", "Number", "ItemNameLabel", "ItemWeightLabel", "StackCountLabel", "ToolTip" }) do
	instance("TextLabel", name, missingName).Text = "placeholder"
end
reset(missingName, 1)
assert(missingName.ToolName and not missingName.ToolName.Visible and missingName.ToolName.Text == "")
assert(missingName:GetAttribute("MinimalSlotLabels"))
assert(not missingName.CpsLabel.Visible and missingName.CpsLabel.Text == "")
for _, label in ipairs(missingName:GetDescendants()) do
	if label:IsA("TextLabel") then assert(not label.Visible) end
end
print("BackpackSlotPresentation.test.lua passed")
