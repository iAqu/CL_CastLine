-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
local function v1(p1, p2) --[[ flatten | Line: 27 | Upvalues: v1 (copy), maybeFreeze (copy) ]]
	local t = {}
	local count = 1
	for v12, v2 in p1 do
		if type(v2) == "table" and (not p2 or p2 > 0) then
			local v5 = v1(v2, if p2 then p2 - 1 else p2)
			for i = 1, #v5 do
				t[count] = v5[i]
				count = count + 1
			end
			continue
		end
		t[count] = v2
		count = count + 1
	end
	return maybeFreeze(t)
end
return v1