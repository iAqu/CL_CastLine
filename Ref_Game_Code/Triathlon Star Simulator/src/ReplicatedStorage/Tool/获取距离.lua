-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:05
-- Luau version 6, Types version 3
-- Time taken: 0.000872 seconds

return {
	getIsInDistance = function(arg1, arg2, arg3) -- Line 3, Named "getIsInDistance"
		if arg3 * 4 < math.abs(arg1.y - arg2.y) then
			return false
		end
		if math.abs((Vector3.new(arg1.x, 0, arg1.z) - Vector3.new(arg2.x, 0, arg2.z)).Magnitude) < arg3 then
			return true
		end
		return false
	end;
	GetDistance = function(arg1, arg2) -- Line 15, Named "GetDistance"
		return math.abs((arg1 - arg2).Magnitude)
	end;
	GetDistanceXZ = function(arg1, arg2) -- Line 20, Named "GetDistanceXZ"
		if 100 < math.abs(arg1.y - arg2.y) then
			return 100
		end
		return math.abs((Vector3.new(arg1.x, 0, arg1.z) - Vector3.new(arg2.x, 0, arg2.z)).Magnitude)
	end;
}