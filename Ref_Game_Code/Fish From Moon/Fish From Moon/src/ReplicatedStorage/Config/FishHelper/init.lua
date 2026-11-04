local FishHelper = {}

local FishConfig = require(script.FishConfig)

function FishHelper.GetFishList()
	return FishConfig
end

function FishHelper.GetFish(fishId)
	return FishConfig[tostring(fishId)]
end

return FishHelper