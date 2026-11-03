-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:51
-- Luau version 6, Types version 3
-- Time taken: 0.002372 seconds

local var1_upvr = require(script.Parent.loader).load(script)("LuvColor3Utils")
return {
	addGrade = function(arg1, arg2) -- Line 11, Named "addGrade"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var3 = arg1 + arg2
		if 100 < var3 or var3 < 0 then
			local var4 = arg1 - arg2
			if math.abs(math.clamp(var3, 0, 100) - arg1) < math.abs(math.clamp(var4, 0, 100) - arg1) then
			end
		end
		return var4
	end;
	getGrade = function(arg1) -- Line 35, Named "getGrade"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var5
		if typeof(arg1) ~= "Color3" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad color")
		var5 = var1_upvr.fromColor3(arg1)
		local _, _, unpack_result3 = unpack(var5)
		return 100 - unpack_result3
	end;
	getGradedColor = function(arg1, arg2, arg3) -- Line 42, Named "getGradedColor"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var9
		if typeof(arg1) ~= "Color3" then
			var9 = false
		else
			var9 = true
		end
		assert(var9, "Bad baseColor")
		var9 = true
		if type(arg3) ~= "number" then
			if arg3 ~= nil then
				var9 = false
			else
				var9 = true
			end
		end
		assert(var9, "Bad vividness")
		if type(arg2) ~= "number" then
			var9 = false
		else
			var9 = true
		end
		assert(var9, "Bad colorGrade")
		var9 = var1_upvr.fromColor3(arg1)
		local unpack_result1, unpack_result2, unpack_result3_2 = unpack(var9)
		if arg3 then
			unpack_result2 = math.clamp(arg3 * unpack_result2, 0, 100)
		end
		return var1_upvr.toColor3({unpack_result1, unpack_result2, 100 - math.clamp(arg2, 0, 100)})
	end;
}