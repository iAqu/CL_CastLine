-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Currency = require(script:WaitForChild("Currency"))
return {
	GetCurrency = function(p1, p2) --[[ GetCurrency | Line: 10 | Upvalues: Currency (copy) ]]
		return Currency[p2]
	end
}