local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local weightFormat = read("src/ReplicatedStorage/Modules/WeightFormat.lua")
local itemToolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")
local purse = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")

assert(weightFormat:find("function WeightFormat.FormatKgCompact", 1, true))
assert(weightFormat:find("math.abs(value) < 1_000", 1, true))
assert(weightFormat:find("NumberUtil.FormatNumberStartKWithDecimal(value, 1) .. \"kg\"", 1, true))
assert(itemToolUtil:find("WeightFormat.FormatKgCompact(instanceData.Weight)", 1, true))
assert(not itemToolUtil:find("WeightFormat.FormatKg(instanceData.Weight),", 1, true))
assert(itemToolUtil:find('local TITLE_WEIGHT_COLOR = "#B1DAF8"', 1, true))
assert(itemToolUtil:find('local TOOLTIP_PRICE_COLOR = "#FFBD30"', 1, true))
assert(itemToolUtil:find('<font color=\\"%s\\">%s</font>', 1, true))
assert(itemToolUtil:find('<font color=\\"%s\\">$%s</font>', 1, true))
assert(itemToolUtil:find("NumberUtil.FormatItemPriceCompact(instanceData.Price)", 1, true))
assert(purse:find("ToolTip.RichText = true", 1, true))

print("ItemTooltipWeightFormat.test.lua passed")
