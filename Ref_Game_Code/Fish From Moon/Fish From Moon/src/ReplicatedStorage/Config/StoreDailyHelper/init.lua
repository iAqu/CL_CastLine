local StoreDailyHelper = {}

local StoreDailyConfig = require(script.StoreDailyConfig)

function StoreDailyHelper.GetAllDaily()
	return StoreDailyConfig
end

function StoreDailyHelper.GetIndexDaily(index)
	return StoreDailyConfig[tonumber(index)]
end

return StoreDailyHelper