-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ExpoInOut = function(p1) --[[ ExpoInOut | Line: 3 ]]
		if p1 == 0 then
			return 0
		end
		if p1 == 1 then
			return 1
		end
		local v1 = p1 * 2
		if v1 < 1 then
			return math.pow(2, (v1 - 1) * 10) * 0.5 - 0.0005
		else
			return (-math.pow(2, (v1 - 1) * -10) + 2) * 0.50025
		end
	end,
	ExpoIn = function(p1) --[[ ExpoIn | Line: 18 ]]
		if p1 == 0 then
			return 0
		else
			return math.pow(2, (p1 - 1) * 10) - 0.001
		end
	end,
	BounceOut = function(p1) --[[ BounceOut | Line: 25 ]]
		if p1 < 0.36363636363636365 then
			return p1 * 7.5625 * p1
		end
		if p1 < 0.7272727272727273 then
			local v1 = p1 - 0.5454545454545454
			return v1 * 7.5625 * v1 + 0.75
		end
		if p1 < 0.9090909090909091 then
			local v2 = p1 - 0.8181818181818182
			return v2 * 7.5625 * v2 + 0.9375
		else
			local v3 = p1 - 0.9545454545454546
			return v3 * 7.5625 * v3 + 0.984375
		end
	end,
	QuadOut = function(p1) --[[ QuadOut | Line: 41 ]]
		return p1 * -1 * (p1 - 2)
	end
}