-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("@game/ReplicatedStorage/Shared/Utility/InfiniteMath")
return {
	BASE_DISTANCE = 75,
	DISTANCE_INCREMENT = 1,
	MIN_DISTANCE = 30,
	MAX_DISTANCE = 3900,
	MIN_SPEED = 12,
	MAX_SPEED = 500,
	cachedDistances = {},
	cachedCosts = {},
	BASE_COST = v1.new(50),
	GetDistanceFromLevel = function(p1, p2) --[[ GetDistanceFromLevel | Line: 23 ]]
		if not p1.cachedDistances[p2] then
			p1.cachedDistances[p2] = 60 * p2 ^ if p2 <= 80000000 then 0.215 else 0.215 * (80000000 / p2) ^ 0.03
		end
		return p1.cachedDistances[p2]
	end,
	GetCostForLevel = function(p1, p2) --[[ GetCostForLevel | Line: 37 | Upvalues: v1 (copy) ]]
		if not p1.cachedCosts[p2] then
			if p2 == 0 then
				p1.cachedCosts[p2] = v1.new(0)
			else
				p1.cachedCosts[p2] = p1.BASE_COST * 1.2 ^ (p2 - 1)
			end
		end
		return p1.cachedCosts[p2]
	end,
	GetCostForRange = function(p1, p2, p3) --[[ GetCostForRange | Line: 49 ]]
		local sum = 0
		for i = p2, p3 do
			sum = sum + p1:GetCostForLevel(i)
		end
		return sum
	end
}