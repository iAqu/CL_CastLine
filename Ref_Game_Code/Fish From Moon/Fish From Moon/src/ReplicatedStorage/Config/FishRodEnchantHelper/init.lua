local FishRodEnchantHelper = {}

local FishRodEnchantConfig = require(script.FishRodEnchantConfig)

function FishRodEnchantHelper.GetEnchant()
	return FishRodEnchantConfig
end

function FishRodEnchantHelper.GetEnchantIndex(index)
	return FishRodEnchantConfig[tonumber(index)]
end

return FishRodEnchantHelper