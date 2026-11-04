local UpgradesHelper = {}

local UpgradesConfig = require(script.UpgradesConfig)

function UpgradesHelper.GetUpgradesNum(id,level)
	return UpgradesConfig[tostring(id)][tonumber(level)].num
end

function UpgradesHelper.GetUpgradesNeedNum(id,level)
	return UpgradesConfig[tostring(id)][tonumber(level)].needNum
end

return UpgradesHelper
