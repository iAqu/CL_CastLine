-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
return {
	RollItem = function(p1, p2, p3) --[[ RollItem | Line: 10 | Upvalues: TableUtil (copy) ]]
		local v1 = p2:NextInteger(1, (TableUtil.Reduce(p3[p1], function(p1, p2) --[[ Line: 11 ]]
			return p1 + p2.Weight
		end, 0)))
		local sum = 0
		for i, v in ipairs(p3[p1]) do
			sum = sum + v.Weight
			if v1 <= sum then
				return v
			end
		end
		return p3[p1][1]
	end,
	RollWeights = function(p1) --[[ RollWeights | Line: 26 ]]
		local v1 = Random.new()
		local sum = 0
		for i, v in ipairs(p1) do
			sum = sum + v
		end
		local v2 = v1:NextInteger(1, sum)
		local sum_2 = 0
		for i, v in ipairs(p1) do
			sum_2 = sum_2 + v
			if v2 <= sum_2 then
				return i
			end
		end
		return 1
	end
}