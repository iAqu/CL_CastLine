local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local source = read("src/ReplicatedStorage/Modules/NumberUtil.lua")
local replacementCount
source, replacementCount = source:gsub(
	"local ReplicatedStorage = game:GetService%(\"ReplicatedStorage\"%)\n\n"
		.. "local FormatNumberMain = require%(ReplicatedStorage%.Libs%.FormatNumber%.Main%)\n"
		.. "local FormatNumberSimple = require%(ReplicatedStorage%.Libs%.FormatNumber%.Simple%)",
	[[local FormatNumberMain = {
	NumberFormatter = {
		with = function()
			return {
				Format = function(_, value)
					return tostring(value)
				end,
			}
		end,
	},
}
local FormatNumberSimple = {}]],
	1
)
assert(replacementCount == 1, "NumberUtil test harness must replace its Roblox dependencies")

local NumberUtil = assert(loadstring(source))()
local formatPrice = NumberUtil.FormatItemPriceCompact

assert(formatPrice(999) == "999", "Prices below 1K must stay unshortened")
assert(formatPrice(1_000) == "1K", "1K must use the K suffix")
assert(formatPrice(1_200) == "1.2K", "Trailing decimal zeroes must be removed")
assert(formatPrice(1_239) == "1.23K", "Price abbreviations must truncate instead of round")
assert(formatPrice(12_345) == "12.34K", "K prices must retain at most two decimal places")
assert(formatPrice(999_999) == "999.99K", "Prices must not round into the next suffix")
assert(formatPrice(1_000_000) == "1M", "One million must use the M suffix")
assert(formatPrice(10_000_000) == "10M", "Ten million must stay compact without decimals")
assert(formatPrice(1_000_000_000) == "1B", "Higher compact suffixes must remain supported")

for _, path in ipairs({
	"src/StarterPlayer/StarterPlayerScripts/Controllers/DrownDropController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/PlotFishController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SellShopController.lua",
}) do
	assert(read(path):find("FormatItemPriceCompact", 1, true), path .. " must use compact item-price formatting")
end

print("ItemPriceDisplay.test.lua passed")
