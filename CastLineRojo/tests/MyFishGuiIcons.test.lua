local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/MyFishGuiController.lua", "r"))
local source = file:read("*a")
file:close()
local start = assert(source:find("local function updateRow", 1, true))
local finish = assert(source:find("local function addRow", start, true))
local warnings, applied = {}, {}
local updateRow = assert(load(source:sub(start, finish - 1) .. "\nreturn updateRow", "MyFish row refresh", "t", setmetatable({
	missingIcons = {},
	Enum = { ScaleType = { Fit = "Fit" } },
	RarityConfig = { Normalize = function(value) return value end },
	GuiUtil = { SetRarityGradient = function() end },
	WeightFormat = { FormatKgCompact = function(value) return value .. "kg" end },
	NumberUtil = { FormatItemPriceCompact = tostring },
	MutationDataUtil = { GetConfig = function(id)
		return if id == "Golden" or id == "Diamond" or id == "Rainbow" then { DisplayName = id } else nil
	end },
	FishIconPresentation = { ApplyMutation = function(icon, mutationId)
		table.insert(applied, { icon = icon, mutationId = mutationId })
	end },
	warn = function(_, itemId) table.insert(warnings, itemId) end,
}, { __index = getfenv() })))()
local row = {
	Info = { AnimalName = {}, Rarity = {}, Income = {}, Mutation = {} },
	Preview = { Weight = {}, AnimalPreview = {} },
}
local item = { Icon = "rbxassetid://123", DisplayName = "Test fish", Rarity = "Rare" }
local entry = { itemId = "Fish_101", weight = 2, income = 100 }
local icon = row.Preview.AnimalPreview
updateRow(row, entry, item)
assert(icon.Image == item.Icon and icon.Visible and icon.ScaleType == "Fit")
assert(row.Preview.Weight.Text == "2KG" and row.Info.Income.Text == "$100/s")
assert(not row.Info.Mutation.Visible and applied[#applied].mutationId == nil)
for _, id in ipairs({ "Golden", "Diamond", "Rainbow" }) do
	entry.mutationId = id
	entry.income += 10
	updateRow(row, entry, item)
	assert(applied[#applied].icon == icon and applied[#applied].mutationId == id)
	assert(row.Info.Mutation.Visible and row.Info.Mutation.Text == id)
end
-- An existing row must update its image, labels and effect without being recreated.
entry.mutationId, entry.weight, entry.income = nil, 4, 250
item.Icon = "rbxassetid://456"
updateRow(row, entry, item)
assert(row.Preview.AnimalPreview == icon and icon.Image == item.Icon)
assert(row.Preview.Weight.Text == "4KG" and row.Info.Income.Text == "$250/s")
assert(not row.Info.Mutation.Visible and applied[#applied].mutationId == nil)
entry.mutationId = "Rainbow"
for _, invalid in ipairs({ "", "nil", "rbxassetid://", "rbxassetid://0", false }) do
	item.Icon = invalid
	updateRow(row, entry, item)
	assert(icon.Image == "" and not icon.Visible and applied[#applied].mutationId == nil)
end
item.Icon = nil
updateRow(row, entry, item)
assert(#warnings == 1 and warnings[1] == "Fish_101", "Missing icons must warn once per fish ID")
entry.itemId = "Fish_102"
updateRow(row, entry, item)
assert(#warnings == 2 and warnings[2] == "Fish_102")
item.Icon = "rbxassetid://789"
updateRow(row, entry, item)
assert(icon.Visible and icon.Image == item.Icon and applied[#applied].mutationId == "Rainbow")
print("MyFishGuiIcons.test.lua passed")
