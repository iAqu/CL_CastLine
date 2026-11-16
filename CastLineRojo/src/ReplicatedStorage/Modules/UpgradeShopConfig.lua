local UpgradeShopConfig = {}

UpgradeShopConfig.BUNDLE_AMOUNTS = table.freeze({ 1, 5, 10 })

local CONFIGS = table.freeze({})

function UpgradeShopConfig.IsValidUpgradeId(upgradeId: unknown): boolean
	return typeof(upgradeId) == "string" and CONFIGS[upgradeId] ~= nil
end

function UpgradeShopConfig.IsValidBundleAmount(amount: unknown): boolean
	return typeof(amount) == "number"
		and amount % 1 == 0
		and table.find(UpgradeShopConfig.BUNDLE_AMOUNTS, amount) ~= nil
end

function UpgradeShopConfig.GetLevel(playerData, upgradeId: string): number
	local upgrades = playerData and playerData.Upgrades
	local level = typeof(upgrades) == "table" and tonumber(upgrades[upgradeId]) or nil
	return math.max(0, math.floor(level or 0))
end

function UpgradeShopConfig.GetUnitPrice(upgradeId: string, currentLevel: number): number
	local config = CONFIGS[upgradeId]
	assert(config, `Unknown upgrade: {upgradeId}`)
	local level = math.max(0, math.floor(tonumber(currentLevel) or 0))
	return math.round(config.Coefficient * (level + 1) ^ config.Exponent)
end

function UpgradeShopConfig.GetBundlePrice(upgradeId: string, currentLevel: number, amount: number): number
	assert(UpgradeShopConfig.IsValidBundleAmount(amount), `Invalid bundle amount: {tostring(amount)}`)
	return UpgradeShopConfig.GetUnitPrice(upgradeId, currentLevel) * amount
end

return UpgradeShopConfig
