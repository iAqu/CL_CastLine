-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:55
-- Luau version 6, Types version 3
-- Time taken: 0.009971 seconds

local tbl_upvr = {}
function Get(arg1, arg2, arg3) -- Line 3
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg2 == "Circular" then
	elseif "Circ" == "Exponential" then
	end
	if not tbl_upvr["Expo"..arg3] then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if "Expo" == "Linear" then
		else
			return
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	if "Expo" == "Linear" then
		return arg1
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return tbl_upvr["Expo"..arg3](arg1)
end
function tbl_upvr.QuadIn(arg1) -- Line 31
	return 1 * math.pow(arg1 / 1, 2) + 0
end
function tbl_upvr.QuadOut(arg1) -- Line 36
	local var3 = arg1 / 1
	return -1 * var3 * (var3 - 2) + 0
end
function tbl_upvr.QuadInOut(arg1) -- Line 41
	local var4 = arg1 / 1 * 2
	if var4 < 1 then
		return 0.5 * math.pow(var4, 2) + 0
	end
	return -0.5 * ((var4 - 1) * (var4 - 3) - 1) + 0
end
function tbl_upvr.QuadOutIn(arg1) -- Line 49
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.QuadOut(arg1 * 2)
	end
	return tbl_upvr.QuadIn(arg1 * 2 - 1)
end
function tbl_upvr.CubicIn(arg1) -- Line 56
	return 1 * math.pow(arg1 / 1, 3) + 0
end
function tbl_upvr.CubicOut(arg1) -- Line 61
	return 1 * (math.pow(arg1 / 1 - 1, 3) + 1) + 0
end
function tbl_upvr.CubicInOut(arg1) -- Line 66
	local var5 = arg1 / 1 * 2
	if var5 < 1 then
		return 0.5 * var5 * var5 * var5 + 0
	end
	local var6 = var5 - 2
	return 0.5 * (var6 * var6 * var6 + 2) + 0
end
function tbl_upvr.CubicOutIn(arg1) -- Line 75
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.CubicOut(arg1 * 2)
	end
	return tbl_upvr.CubicIn(arg1 * 2 - 1)
end
function tbl_upvr.QuartIn(arg1) -- Line 82
	return 1 * math.pow(arg1 / 1, 4) + 0
end
function tbl_upvr.QuartOut(arg1) -- Line 87
	return -1 * (math.pow(arg1 / 1 - 1, 4) - 1) + 0
end
function tbl_upvr.QuartInOut(arg1) -- Line 92
	local var7 = arg1 / 1 * 2
	if var7 < 1 then
		return 0.5 * math.pow(var7, 4) + 0
	end
	return -0.5 * (math.pow(var7 - 2, 4) - 2) + 0
end
function tbl_upvr.QuartOutIn(arg1) -- Line 101
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.QuartOut(arg1 * 2)
	end
	return tbl_upvr.QuartIn(arg1 * 2 - 1)
end
function tbl_upvr.QuintIn(arg1) -- Line 108
	return 1 * math.pow(arg1 / 1, 5) + 0
end
function tbl_upvr.QuintOut(arg1) -- Line 113
	return 1 * (math.pow(arg1 / 1 - 1, 5) + 1) + 0
end
function tbl_upvr.QuintInOut(arg1) -- Line 118
	local var8 = arg1 / 1 * 2
	if var8 < 1 then
		return 0.5 * math.pow(var8, 5) + 0
	end
	return 0.5 * (math.pow(var8 - 2, 5) + 2) + 0
end
function tbl_upvr.QuintOutIn(arg1) -- Line 127
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.QuintOut(arg1 * 2)
	end
	return tbl_upvr.QuintIn(arg1 * 2 - 1)
end
function tbl_upvr.SineIn(arg1) -- Line 134
	return -1 * math.cos(arg1 / 1 * (math.pi/2)) + 1 + 0
end
function tbl_upvr.SineOut(arg1) -- Line 138
	return 1 * math.sin(arg1 / 1 * (math.pi/2)) + 0
end
function tbl_upvr.SineInOut(arg1) -- Line 142
	return -0.5 * (math.cos(math.pi * arg1 / 1) - 1) + 0
end
function tbl_upvr.SineOutIn(arg1) -- Line 146
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.SineOut(arg1 * 2)
	end
	return tbl_upvr.SineIn(arg1 * 2)
end
function tbl_upvr.ExpoIn(arg1) -- Line 153
	if arg1 == 0 then
		return 0
	end
	return 1 * math.pow(2, 10 * (arg1 / 1 - 1)) + 0 - 0.001
end
function tbl_upvr.ExpoOut(arg1) -- Line 160
	if arg1 == 1 then
		return 1
	end
	return 1.001 * (-math.pow(2, -10 * arg1 / 1) + 1) + 0
end
function tbl_upvr.ExpoInOut(arg1) -- Line 167
	if arg1 == 0 then
		return 0
	end
	if arg1 == 1 then
		return 1
	end
	local var9 = arg1 / 1 * 2
	if var9 < 1 then
		return 0.5 * math.pow(2, 10 * (var9 - 1)) + 0 - 0.0005
	end
	return 0.50025 * (-math.pow(2, -10 * (var9 - 1)) + 2) + 0
end
function tbl_upvr.ExpoOutIn(arg1) -- Line 182
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.ExpoOut(arg1 * 2)
	end
	return tbl_upvr.ExpoIn(arg1 * 2 - 1)
end
function tbl_upvr.CircIn(arg1) -- Line 189
	return -1 * (math.sqrt(1 - math.pow(arg1 / 1, 2)) - 1) + 0
end
function tbl_upvr.CircOut(arg1) -- Line 194
	return 1 * math.sqrt(1 - math.pow(arg1 / 1 - 1, 2)) + 0
end
function tbl_upvr.CircInOut(arg1) -- Line 199
	local var10 = arg1 / 1 * 2
	if var10 < 1 then
		return -0.5 * (math.sqrt(1 - var10 * var10) - 1) + 0
	end
	local var11 = var10 - 2
	return 0.5 * (math.sqrt(1 - var11 * var11) + 1) + 0
end
function tbl_upvr.CircOutIn(arg1) -- Line 208
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.CircOut(arg1 * 2)
	end
	return tbl_upvr.CircIn(arg1 * 2 - 1)
end
function tbl_upvr.ElasticIn(arg1) -- Line 215
	if arg1 == 0 then
		return 0
	end
	local var12 = arg1 / 1
	if var12 == 1 then
		return 1
	end
	local var13
	local var14
	if not var13 then
		var13 = 0.3
	end
	local var15 = var13 / 4
	if not var14 or var14 < 1 then
		var15 = var13 / 4
	else
		var15 = var13 / (-math.pi*2) * math.asin(1 / 1)
	end
	local var16 = var12 - 1
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return -(1 * math.pow(2, 10 * var16) * math.sin((var16 * 1 - var15) * (-math.pi*2) / var13)) + 0
end
function tbl_upvr.ElasticOut(arg1) -- Line 239
	if arg1 == 0 then
		return 0
	end
	local var17 = arg1 / 1
	if var17 == 1 then
		return 1
	end
	local var18
	local var19
	if not var18 then
		var18 = 0.3
	end
	local var20 = var18 / 4
	if not var19 or var19 < 1 then
	else
		var20 = var18 / (-math.pi*2) * math.asin(1 / 1)
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return 1 * math.pow(2, -10 * var17) * math.sin((var17 * 1 - var20) * (-math.pi*2) / var18) + 1 + 0
end
function tbl_upvr.ElasticInOut(arg1) -- Line 261
	if arg1 == 0 then
		return 0
	end
	local var21 = arg1 / 1 * 2
	if var21 == 2 then
		return 1
	end
	local var22
	if not var22 then
		var22 = 0.44999999999999996
	end
	if not nil then
		local const_number = 0
	end
	local var24 = var22 / 4
	if not const_number or const_number < 1 then
	else
		var24 = var22 / (-math.pi*2) * math.asin(1 / 1)
	end
	if var21 < 1 then
		local var25 = var21 - 1
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return (-0.5) * (1 * math.pow(2, 10 * var25) * math.sin((var25 * 1 - var24) * (-math.pi*2) / var22)) + 0
	end
	local var26 = var25 - 1
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return 1 * math.pow(2, -10 * var26) * math.sin((var26 * 1 - var24) * (-math.pi*2) / var22) * 0.5 + 1 + 0
end
function tbl_upvr.ElasticOutIn(arg1) -- Line 291
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.ElasticOut(arg1 * 2)
	end
	return tbl_upvr.ElasticIn(arg1 * 2 - 1)
end
function tbl_upvr.BackIn(arg1) -- Line 298
	local var27 = arg1 / 1
	return 1 * var27 * var27 * (2.70158 * var27 - 1.70158) + 0
end
function tbl_upvr.BackOut(arg1) -- Line 303
	local var28 = arg1 / 1 - 1
	return 1 * (var28 * var28 * (2.70158 * var28 + 1.70158) + 1) + 0
end
function tbl_upvr.BackInOut(arg1) -- Line 308
	local const_number_2 = 2.5949095
	local var30 = arg1 / 1 * 2
	if var30 < 1 then
		return (0.5) * (var30 * var30 * ((const_number_2 + 1) * var30 - const_number_2)) + 0
	end
	local var31 = var30 - 2
	return 0.5 * (var31 * var31 * ((const_number_2 + 1) * var31 + const_number_2) + 2) + 0
end
function tbl_upvr.BackOutIn(arg1) -- Line 319
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.BackOut(arg1 * 2)
	end
	return tbl_upvr.BackIn(arg1 * 2 - 1)
end
function tbl_upvr.BounceOut(arg1) -- Line 326
	local var32 = arg1 / 1
	if var32 < 0.36363636363636365 then
		return (1) * (7.5625 * var32 * var32) + 0
	end
	if var32 < 0.7272727272727273 then
		local var33 = var32 - 0.5454545454545454
		return 1 * (7.5625 * var33 * var33 + 0.75) + 0
	end
	if var33 < 0.9090909090909091 then
		local var34 = var33 - 0.8181818181818182
		return 1 * (7.5625 * var34 * var34 + 0.9375) + 0
	end
	local var35 = var34 - 0.9545454545454546
	return 1 * (7.5625 * var35 * var35 + 0.984375) + 0
end
function tbl_upvr.BounceIn(arg1) -- Line 343
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	return 1 - tbl_upvr.BounceOut(1 - arg1) + 0
end
function tbl_upvr.BounceInOut(arg1) -- Line 347
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.BounceIn(arg1 * 2) * 0.5 + 0
	end
	return tbl_upvr.BounceOut(arg1 * 2 - 1) * 0.5 + 0.5 + 0
end
function tbl_upvr.BounceOutIn(arg1) -- Line 354
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1 < 0.5 then
		return tbl_upvr.BounceOut(arg1 * 2)
	end
	return tbl_upvr.BounceIn(arg1 * 2 - 1)
end
return Get