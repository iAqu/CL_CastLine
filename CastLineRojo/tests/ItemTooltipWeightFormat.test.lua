local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local itemToolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")
local purse = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")

assert(itemToolUtil:find("WeightFormat.FormatKg(instanceData.Weight)", 1, true))
assert(itemToolUtil:find('local TITLE_WEIGHT_COLOR = "#B1DAF8"', 1, true))
assert(itemToolUtil:find('local TOOLTIP_PRICE_COLOR = "#FFBD30"', 1, true))
assert(itemToolUtil:find('<font color=\\"%s\\">%s</font>', 1, true))
assert(itemToolUtil:find('<font color=\\"%s\\">$%s</font>', 1, true))
assert(itemToolUtil:find("NumberUtil.FormatItemPriceCompact(instanceData.Price)", 1, true))
assert(purse:find("ToolTip.RichText = true", 1, true))

print("ItemTooltipWeightFormat.test.lua passed")
