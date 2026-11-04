local FishRoadPoolHelper = {}

local FishRoadPoolConfig = require(script.FishRoadPoolConfig)

function FishRoadPoolHelper.GetAllFishRoadPool()
	return FishRoadPoolConfig
end

function FishRoadPoolHelper.GetFishRoadPoolInfo(fishRoadPoolId)
	return FishRoadPoolConfig[tonumber(fishRoadPoolId)]
end

function FishRoadPoolHelper.GetFishRoadPool(fishRoadPoolId)
	return FishRoadPoolConfig[tonumber(fishRoadPoolId)].pool
end

return FishRoadPoolHelper
