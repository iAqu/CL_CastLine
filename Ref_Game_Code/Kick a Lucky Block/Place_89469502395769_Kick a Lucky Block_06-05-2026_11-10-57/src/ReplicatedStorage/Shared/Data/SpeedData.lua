-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("@game/ReplicatedStorage/Shared/Utility/InfiniteMath")
return {
	LOBBY_SPEED = 22,
	BASE_SPEED = 13,
	FREE_LEVELS = 4,
	SPEED_INCREMENT = 1,
	cachedSpeeds = {},
	cachedCosts = {},
	BASE_COST = v1.new(50),
	GetSpeedFromLevel = function(p1, p2) --[[ GetSpeedFromLevel | Line: 15 ]]
		if not p1.cachedSpeeds[p2] then
			p1.cachedSpeeds[p2] = p1.BASE_SPEED + p1.SPEED_INCREMENT * p2
		end
		return p1.cachedSpeeds[p2]
	end,
	GetCostForLevel = function(p1, p2) --[[ GetCostForLevel | Line: 24 | Upvalues: v1 (copy) ]]
		if not p1.cachedCosts[p2] then
			local v12 = p2 - p1.FREE_LEVELS
			if v12 <= 0 then
				p1.cachedCosts[p2] = v1.new(0)
			else
				p1.cachedCosts[p2] = p1.BASE_COST * 1.465 ^ (v12 - 1)
			end
		end
		return p1.cachedCosts[p2]
	end,
	GetCostForRange = function(p1, p2, p3) --[[ GetCostForRange | Line: 39 ]]
		local sum = 0
		for i = p2, p3 do
			sum = sum + p1:GetCostForLevel(i)
		end
		return sum
	end
}