local DailyRewardHelper = {}

local DailyRewardConfig = require(script.DailyRewardConfig)

function DailyRewardHelper.GetDailyReward()
	return DailyRewardConfig
end
function DailyRewardHelper.GetDailyRewardImg(daily)
	return DailyRewardConfig[tonumber(daily)].img
end
function DailyRewardHelper.GetDailyRewardTxt(daily)
	return DailyRewardConfig[tonumber(daily)].txt
end
function DailyRewardHelper.GetDailyRewardNum(daily)
	return DailyRewardConfig[tonumber(daily)].num
end


return DailyRewardHelper
