-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:04
-- Luau version 6, Types version 3
-- Time taken: 0.001114 seconds

return {
	compileBBox = function(arg1, arg2) -- Line 18, Named "compileBBox"
		return CFrame.fromMatrix(arg1.Position, arg1.XVector / arg2.x, arg1.YVector / arg2.y, arg1.ZVector / arg2.z):inverse()
	end;
	testPointBBox = function(arg1, arg2) -- Line 33, Named "testPointBBox"
		local var4 = arg2 * arg1
		local var5 = false
		if math.abs(var4.x) < 0.5 then
			var5 = false
			if math.abs(var4.y) < 0.5 then
				if math.abs(var4.z) >= 0.5 then
					var5 = false
				else
					var5 = true
				end
			end
		end
		return var5
	end;
}