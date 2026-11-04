local FreeGiftHelper = {}

local FreeGiftConfig = require(script.FreeGiftConfig)

function FreeGiftHelper.GetFreeGift()
	return FreeGiftConfig
end
function FreeGiftHelper.GetFreeGiftImg(freeGift)
	return FreeGiftConfig[tonumber(freeGift)].img
end
function FreeGiftHelper.GetFreeGiftTxt(freeGift)
	return FreeGiftConfig[tonumber(freeGift)].txt
end
function FreeGiftHelper.GetFreeGiftNum(freeGift)
	return FreeGiftConfig[tonumber(freeGift)].num
end


return FreeGiftHelper
