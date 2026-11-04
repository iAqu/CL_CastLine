-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:21
-- Luau version 6, Types version 3
-- Time taken: 0.001689 seconds

return {
	CheckWorldIsUnlock = function(arg1, arg2) -- Line 6, Named "CheckWorldIsUnlock"
		local var2
		if arg2 > arg1:FindFirstChild("MaxWorld").Value then
			var2 = false
		else
			var2 = true
		end
		return var2
	end;
	isPointInPart = function(arg1, arg2) -- Line 12, Named "isPointInPart"
		local any_PointToObjectSpace_result1_2 = arg1.CFrame:PointToObjectSpace(arg2)
		local var7 = arg1.Size / 2
		local var8 = false
		if math.abs(any_PointToObjectSpace_result1_2.X) <= var7.X then
			var8 = false
			if math.abs(any_PointToObjectSpace_result1_2.Y) <= var7.Y then
				if math.abs(any_PointToObjectSpace_result1_2.Z) > var7.Z then
					var8 = false
				else
					var8 = true
				end
			end
		end
		return var8
	end;
	CheckCurTimeIsLimits = function(arg1, arg2) -- Line 29, Named "CheckCurTimeIsLimits"
		local UnixTimestamp = DateTime.fromUnixTimestamp(workspace:GetServerTimeNow()).UnixTimestamp
		if arg1 < UnixTimestamp and UnixTimestamp < arg2 then
			return true
		end
		return false
	end;
}