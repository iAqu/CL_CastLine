-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKBHR5cGUIZnVuY3Rpb24EZnVuYwZ0cnV0aHkFcGFpcnMFY291bnQGc2NyaXB0BlBhcmVudAdyZXF1aXJlBFV0aWwAAgsCAQAABwQAAAUCBIUcjAIAALsoAQNSBAEApAMBAAAAAECfAwIC8AMCAAIAAIBlAAUA+wMAAE0DA2YDAAAATQED7wQAAACkAwYAAABQQFIEAACfAwIEFwMGAFIIAQBSCQYAUgoAAJ8IAwIOCAEAlQICB24D+f8CAAAAggICAAgDAQQAAABAAwIDAwMEAwUEAABQQAIAAAAAAADwPwAZBgEYAAIAAAAAAAAAAAAAAAACAAAAAAEAAAAAAf4ABh0AAAAAAwAAAQIAD6MAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAJ4FAAAAnwECAsACBgASAAEAggICAAcDBwQAAABAAwgDCQQAADBAAwoGAAEAAQABGAABAAAAAAACAAAAABUAEQEAAAAAAaiIRLjryeGHWh1w8KXw8ibYkFPMmkwuuQ==

-- https://lua.expert/
local Util = require(script.Parent.Parent.Util)

return function(p1, p2) --[[ count | Line: 25 | Upvalues: Util (copy) ]]
	local count = 0

	if type(p2) ~= "function" then
		p2 = Util.func.truthy
	end

	for k, v in pairs(p1) do
		if p2(k, p1) then
			count = count + 1
		end
	end

	return count
end