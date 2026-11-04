local FishRodHelper = {}

local FishRodConfig = require(script.FishRodConfig)

function FishRodHelper.GetFishRodList()
	return FishRodConfig
end

function FishRodHelper.GetFishRod(fishRodId)
	return FishRodConfig[tostring(fishRodId)]
end

return FishRodHelper