-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
local function v1(p1, p2) --[[ flattenImpl | Line: 4 | Upvalues: v1 (copy) ]]
	local tbl = {}
	for v12, v2 in p1 do
		if type(v2) == "table" and (not p2 or p2 > 0) then
			local v5 = v1(v2, if p2 then p2 - 1 else p2)
			for k, v in pairs(tbl) do
				v5[k] = v
			end
			tbl = v5
			continue
		end
		tbl[v12] = v2
	end
	return tbl
end
return function(p1, p2) --[[ flatten | Line: 45 | Upvalues: maybeFreeze (copy), v1 (copy) ]]
	return maybeFreeze((v1(p1, p2)))
end