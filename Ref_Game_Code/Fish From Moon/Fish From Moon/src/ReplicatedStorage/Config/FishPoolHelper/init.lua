local FishPoolHelper = {}

local FishPoolConfig = require(script.FishPoolConfig)

function FishPoolHelper.GetFishPool()
	return FishPoolConfig
end

return FishPoolHelper
