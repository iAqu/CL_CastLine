-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:44
-- Luau version 6, Types version 3
-- Time taken: 0.003952 seconds

local module = {
	solve = function(arg1, arg2) -- Line 31, Named "solve"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local len = #arg1
		for i = 1, len do
			local var27
			for i_2 = i, len do
				if 0 < math.abs(arg1[i_2][i]) then
					var27 = i_2
				end
			end
			arg1[i] = arg1[var27]
			arg1[var27] = arg1[i]
			arg2[i] = arg2[var27]
			arg2[var27] = arg2[i]
			local var29 = arg1[i]
			for i_3 = i + 1, len do
				local var30 = arg1[i_3]
				local var31 = var30[i] / var29[i]
				var30[i] = 0
				if var31 ~= 0 then
					arg2[i_3] -= var31 * arg2[i]
					for i_4 = i + 1, len do
						var30[i_4] -= var31 * var29[i_4]
						local _
					end
				end
			end
		end
		for i_5 = len, 1, -1 do
			local var34 = arg1[i_5]
			local var35 = 0
			for i_6 = i_5 + 1, len do
				var35 += var34[i_6] * ({})[i_6]
				local var36
			end
			local var37 = (arg2[i_5] - var35) / var34[i_5]
			if var37 ~= var37 or not var37 then
			end
			var36[i_5] = 0
		end
		return var36
	end;
}
local function _(arg1, arg2) -- Line 86, Named "getValidRatio"
	if arg2 == 0 then
		return 0 * arg1
	end
	return arg1 / arg2
end
function module.solveTridiagonal(arg1, arg2, arg3, arg4) -- Line 101
	local len_2 = #arg1
	local var43
	for i_7 = 1, len_2 - 1, var43 do
		local var44 = arg1[i_7]
		local var45
		if var44 == 0 then
			var45 = 0 * arg3[i_7]
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			var45 = arg3[i_7] / var44
		end
		arg1[i_7 + 1] -= var45 * arg2[i_7]
		arg4[i_7 + 1] -= var45 * arg4[i_7]
		arg3[i_7] = 0
	end
	local module_2 = {}
	local var47 = arg1[len_2]
	if var47 == 0 then
		var43 = 0 * arg4[len_2]
	else
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		var43 = arg4[len_2] / var47
	end
	module_2[len_2] = var43
	var43 = 1
	for i_8 = len_2 - 1, var43, -1 do
		local var48 = arg1[i_8]
		local var49
		if var48 == 0 then
			var49 = 0 * (arg4[i_8] - arg2[i_8] * module_2[i_8 + 1])
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			var49 = (arg4[i_8] - arg2[i_8] * module_2[i_8 + 1]) / var48
		end
		module_2[i_8] = var49
	end
	return module_2
end
return module