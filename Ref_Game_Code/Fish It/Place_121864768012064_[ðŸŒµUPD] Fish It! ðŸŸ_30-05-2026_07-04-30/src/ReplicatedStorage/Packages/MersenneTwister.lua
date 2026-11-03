-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 25 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		index = 625,
		mt = {}
	}, t)
	v2.mt[1] = p1
	for i = 2, 624 do
		v2.mt[i] = bit32.bxor(4294967295, (bit32.bxor(v2.mt[i - 1], (bit32.rshift(v2.mt[i - 1], 30))))) * 1812433253 + i
		v2.mt[i] = v2.mt[i] % 4294967295
	end
	return v2
end
function t.extractNumber(p1) --[[ extractNumber | Line: 40 ]]
	if p1.index >= 624 then
		p1:_generateNumbers()
	end
	local v1 = p1.mt[p1.index]
	p1.index = p1.index + 1
	local v3 = bit32.bxor(v1, (bit32.rshift(v1, 11)))
	local v6 = bit32.bxor(v3, (bit32.band(bit32.lshift(v3, 7), 2636928640)))
	local v9 = bit32.bxor(v6, (bit32.band(bit32.lshift(v6, 15), 4022730752)))
	return bit32.bxor(v9, (bit32.rshift(v9, 18))) % 4294967295
end
function t._generateNumbers(p1) --[[ _generateNumbers | Line: 57 ]]
	for i = 1, 624 do
		local v5 = bit32.bxor(bit32.rshift(p1.mt[i], 31), (bit32.lshift(p1.mt[i % 624 + 1], 1)))
		if v5 % 2 == 0 then
			v5 = bit32.bxor(v5, 2567483615)
		end
		p1.mt[i] = bit32.band(v5, 4294967295)
	end
	p1.index = 1
end
function t.random(p1) --[[ random | Line: 68 ]]
	return p1:extractNumber() / 4294967295
end
return t