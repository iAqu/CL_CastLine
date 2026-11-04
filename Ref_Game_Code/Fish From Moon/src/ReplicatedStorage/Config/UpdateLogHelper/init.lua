local UpdateLogHelper = {}

local UpdateLogConfig = require(script.UpdateLogConfig)

function UpdateLogHelper.GetAll()
	return UpdateLogConfig
end

function UpdateLogHelper.GetIndex(index)
	return UpdateLogConfig[tonumber(index)]
end

return UpdateLogHelper
