-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:13
-- Luau version 6, Types version 3
-- Time taken: 0.001466 seconds

return {
	animating = function(arg1, arg2) -- Line 9, Named "animating"
		-- KONSTANTERROR: [0] 1. Error Block 34 start (CF ANALYSIS FAILED)
		local var2 = arg2 or 0.000001
		local Target = arg1.Target
		local var4
		if type(Target) == "number" then
			local var5 = true
			if var2 >= math.abs(arg1.Position - arg1.Target) then
				if var2 >= math.abs(arg1.Velocity) then
					var5 = false
				else
					var5 = true
				end
			end
			var4 = var5
			-- KONSTANTWARNING: GOTO [68] #48
		end
		-- KONSTANTERROR: [0] 1. Error Block 34 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [37] 27. Error Block 35 start (CF ANALYSIS FAILED)
		if typeof(Target) == "Vector3" then
			local var6 = true
			if var2 >= (arg1.Position - arg1.Target).magnitude then
				if var2 >= arg1.Velocity.magnitude then
					var6 = false
				else
					var6 = true
				end
			end
			var4 = var6
		else
			error("Unknown type")
		end
		if var4 then
			return true, arg1.Position
		end
		do
			return false, Target
		end
		-- KONSTANTERROR: [37] 27. Error Block 35 end (CF ANALYSIS FAILED)
	end;
	getVelocityAdjustment = function(arg1, arg2, arg3, arg4) -- Line 35, Named "getVelocityAdjustment"
		return (arg2) * (2 * arg3 / arg4)
	end;
}