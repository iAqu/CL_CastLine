local FishRodLevelHelper = {}

local FishRodLevelConfig = require(script.FishRodLevelConfig)

function FishRodLevelHelper.GetExpSum(level)
	return FishRodLevelConfig[tonumber(level)].expSum
end

function FishRodLevelHelper.GetlevelUp(level)
	return FishRodLevelConfig[tonumber(level)].levelUp
end

return FishRodLevelHelper