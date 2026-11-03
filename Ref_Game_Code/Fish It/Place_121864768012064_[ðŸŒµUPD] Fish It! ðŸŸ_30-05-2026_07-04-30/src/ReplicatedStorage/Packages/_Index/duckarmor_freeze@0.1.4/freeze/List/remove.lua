-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local maybeFreeze = require(script.Parent.Parent.utils.maybeFreeze)
local function removeSingle(p1, p2) --[[ removeSingle | Line: 4 ]]
	local v1 = #p1
	local v2 = table.create(v1 - 1)
	if p2 < 1 then
		p2 = p2 + (v1 + 1)
	end
	if p2 <= 0 or v1 < p2 then
		return p1
	end
	local count = 1
	for v3, v4 in p1 do
		if v3 ~= p2 then
			v2[count] = v4
			count = count + 1
		end
	end
	return v2
end
return function(p1, ...) --[[ remove | Line: 44 | Upvalues: removeSingle (copy), maybeFreeze (copy) ]]
	local t = { ... }
	if #t == 1 then
		return removeSingle(p1, t[1])
	end
	local v1 = #p1
	local t2 = {}
	local count = 0
	for v2, v3 in t do
		if v3 < 1 then
			v3 = v3 + (v1 + 1)
		end
		if not (v3 <= 0 or v1 < v3) then
			t2[v3] = true
			count = count + 1
		end
	end
	if count == 0 then
		return p1
	end
	local v4 = table.create((math.max(1, v1 - count)))
	local count_2 = 1
	for v5, v6 in p1 do
		if not t2[v5] then
			v4[count_2] = v6
			count_2 = count_2 + 1
		end
	end
	return maybeFreeze(v4)
end