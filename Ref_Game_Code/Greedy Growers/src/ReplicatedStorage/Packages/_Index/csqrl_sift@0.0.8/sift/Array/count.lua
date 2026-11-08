-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKBHR5cGUIZnVuY3Rpb24EZnVuYwZ0cnV0aHkGaXBhaXJzBWNvdW50BnNjcmlwdAZQYXJlbnQHcmVxdWlyZQRVdGlsAAIMAgEAAAcEAAAFAgSFHYwCAAC7KAEDUgQBAKQDAQAAAABAnwMCAvADAgACAACAZQAFAPsDAABNAwNmAwAAAE0BA+8EAAAApAMGAAAAUEBSBAAAnwMCBFEDBwBSCAEAUgkHAFIKBgBSCwAAnwgEAg4IAQCVAgIHbgP4/wIAAICCAgIACAMBBAAAAEADAgMDAwQDBQQAAFBAAgAAAAAAAPA/ABkGARgAAgAAAAAAAAAAAAAAAAIAAAAAAQAAAAAAAf4ABh0AAAAAAwAAAQIAD6MAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAJ4FAAAAnwECAsACBgASAAEAggICAAcDBwQAAABAAwgDCQQAADBAAwoGAAEAAQABGAABAAAAAAACAAAAABUAEQEAAAAAAYZgLmbOZg1m2HtuKd3iDd32eDkStKREZw==

-- https://lua.expert/
local Util = require(script.Parent.Parent.Util)

return function(p1, p2) --[[ count | Line: 25 | Upvalues: Util (copy) ]]
	local count = 0

	if type(p2) ~= "function" then
		p2 = Util.func.truthy
	end

	for i, v in ipairs(p1) do
		if p2(v, i, p1) then
			count = count + 1
		end
	end

	return count
end