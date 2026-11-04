local MoneyHelper = {}

local MoneyConfig = require(script.MoneyConfig)

--获取金钱的值
function MoneyHelper.GetMoney(moneyLevel)
	return MoneyConfig[moneyLevel]
end


return MoneyHelper
