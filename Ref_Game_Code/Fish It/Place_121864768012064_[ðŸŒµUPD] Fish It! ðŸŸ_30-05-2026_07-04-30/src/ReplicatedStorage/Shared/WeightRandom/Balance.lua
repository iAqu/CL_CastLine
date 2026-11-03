-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	new = function(p1) --[[ new | Line: 9 ]]
		local t = {}
		local sum = 0
		for v1, v2 in p1 do
			if v2 >= 3 then
				t[v1] = v2
				sum = sum + v2
			end
		end
		if sum == 0 then
			return p1
		end
		local v3 = 100 / sum
		local t2 = {}
		local sum_2 = 0
		for v4, v5 in p1 do
			if v5 >= 3 then
				t2[v4] = v5 * v3
				sum_2 = sum_2 + t2[v4]
				continue
			end
			t2[v4] = v5
		end
		local v6 = 100 - sum_2
		for v7, v8 in t2 do
			if p1[v7] >= 3 then
				t2[v7] = t2[v7] + v6
				return t2
			end
		end
		return t2
	end
}