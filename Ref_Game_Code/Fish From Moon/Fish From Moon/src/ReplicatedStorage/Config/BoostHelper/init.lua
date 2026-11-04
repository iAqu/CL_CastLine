local BoostHelper = {}

local BoostConfig = require(script.BoostConfig)

function BoostHelper.GetBoost(index)
	return BoostConfig[index]
end

return BoostHelper