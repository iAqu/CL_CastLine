local SpinHelper = {}

local SpinConfig = require(script.SpinConfig)

function SpinHelper.GetSpin()
	return SpinConfig
end
function SpinHelper.GetSpinImg(spin)
	return SpinConfig[tonumber(spin)].img
end
function SpinHelper.GetSpinTxt(spin)
	return SpinConfig[tonumber(spin)].txt
end
function SpinHelper.GetSpinWeight(spin)
	return SpinConfig[tonumber(spin)].weight
end


return SpinHelper
