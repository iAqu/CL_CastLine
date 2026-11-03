-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent:WaitForChild("types-teardown-fn"))
local teardown = require(script.Parent:WaitForChild("teardown"))
require(script.Parent:WaitForChild("types"))
return function(...) --[[ createFn | Line: 8 | Upvalues: teardown (copy) ]]
	local v1 = table.pack(...)
	return function() --[[ teardownFn | Line: 10 | Upvalues: teardown (ref), v1 (copy) ]]
		teardown(table.unpack(v1, 1, v1.n))
	end
end