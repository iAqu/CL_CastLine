local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local constants = read("src/ReplicatedStorage/Modules/Constants.lua")
local effects = read("src/ReplicatedStorage/Modules/GamePassEffectUtil.lua")
local carry = read("src/ReplicatedStorage/Modules/CarryCapacityUtil.lua")
local sell = read("src/ServerScriptService/Services/SellService.lua")
local dig = read("src/ServerScriptService/Services/DigItemService.lua")
local grants = read("src/ServerScriptService/Services/ItemGrantUtil.lua")
local gamePassService = read("src/ServerScriptService/Services/GamePassService.lua")
local purchaseData = read("src/ReplicatedFirst/Data/PurchaseData.lua")
local purchaseHelper = read("src/ReplicatedFirst/DataHelpers/PurchaseDataHelper.lua")
local store = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/StoreGuiController.lua")

for _, gamePassId in ipairs({ "DoubleDigSpeed", "DoubleDigPower", "DoubleCarry", "SuperLuck", "MegaLuck" }) do
	assert(constants:find(gamePassId, 1, true), gamePassId .. " must have a Constants.GAMEPASS entry")
	assert(purchaseData:find(gamePassId .. " = {", 1, true), gamePassId .. " must be configured in PurchaseData")
end

assert(effects:find("function GamePassEffectUtil.GetSaleMultiplier", 1, true), "Sale bonuses need a shared effect")
assert(effects:find("bonus += 0.2", 1, true), "VIP must add 20% sale cash")
assert(effects:find("bonus += 1", 1, true), "DoubleWins must add 100% sale cash")
assert(effects:find("function GamePassEffectUtil.GetItemLuckMultiplier", 1, true), "Item-roll Luck bonuses need a shared effect")
assert(effects:find("bonus += 0.5", 1, true), "SuperLuck must add 50% luck")
assert(effects:find("bonus += 2", 1, true), "MegaLuck must add 200% luck")
assert(effects:find("function GamePassEffectUtil.GetDigSpeedMultiplier", 1, true), "Dig speed must use a shared multiplier")
assert(effects:find("return if ownsGamePass(playerData, Constants.GAMEPASS.DOUBLE_DIG_SPEED) then 2 else 1", 1, true), "DoubleDigSpeed must provide a 2x multiplier")
assert(effects:find("baseInterval / GamePassEffectUtil.GetDigSpeedMultiplier", 1, true), "Dig interval must derive from the shared speed multiplier")
assert(effects:find("then 2 else 1", 1, true), "Power and carry effects must double their base values")

assert(carry:find("GamePassEffectUtil.GetCarryCapacityMultiplier", 1, true), "Carry capacity must use the shared GamePass effect")
assert(sell:find("GamePassEffectUtil.GetSaleMultiplier(profile.Data)", 1, true), "Sale rewards and quotes must use the shared sale multiplier")
assert(grants:find("GamePassEffectUtil.GetItemLuckMultiplier(profile.Data)", 1, true), "Condition rolls must apply shared GamePass Luck")
assert(dig:find("GamePassEffectUtil.GetItemLuckMultiplier(profile.Data)", 1, true), "Same-rarity item rolls must use GamePass Luck")
assert(dig:find("GamePassEffectUtil.GetDigPowerMultiplier", 1, true), "Dig damage must use the shared power multiplier")
assert(dig:find("GamePassEffectUtil.GetDigInterval", 1, true), "Dig cadence must use the shared interval effect")
assert(gamePassService:find("Constants.GAMEPASS.DOUBLE_CARRY", 1, true), "DoubleCarry acquisition must refresh capacity immediately")

assert(purchaseHelper:find("purchaseData.GiftProductId == productId", 1, true), "Gift product IDs must resolve to their purchase type")
assert(store:find("PurchaseDataHelper.GetGamePassesData", 1, true), "GamePass cards must be sourced from PurchaseData")
assert(store:find("PurchaseDataHelper.GetWinsData", 1, true), "Wins cards must be sourced from PurchaseData")
assert(store:find("GeneratedStoreWinsCard", 1, true), "Wins cards must be regenerated without duplicates")
assert(store:find('"StarterPackFrame", "PotionFrame"', 1, true), "Non-store sections must remain hidden")
assert(not store:find("LimitedTabButton", 1, true), "Hidden Limited UI must not be bound")
assert(store:find("code redemption failed", 1, true), "Code redemption failures must be handled")

print("GamePassEffects.test.lua passed")
