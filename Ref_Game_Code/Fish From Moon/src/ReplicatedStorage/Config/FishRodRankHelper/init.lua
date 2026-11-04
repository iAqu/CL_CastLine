local FishRodRankHelper = {}

local FishRodRankConfig = require(script.FishRodRankConfig)

function FishRodRankHelper.GetFishRodRankList()
	return FishRodRankConfig
end

function FishRodRankHelper.GetFishRodRank(level)
	return FishRodRankConfig[tonumber(level)]
end

return FishRodRankHelper