-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:27
-- Luau version 6, Types version 3
-- Time taken: 0.012100 seconds

local module_2_upvr = {}
local tbl_upvr = {'K', 'M', 'B', 'T', 'P', 'E', "aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh", "ii", "jj", "kk", "ll", "mm", "nn", "oo", "pp", "qq", "rr", "ss", "tt", "uu", "vv", "ww", "xx", "yy", "zz", "AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH", "II", "JJ", "KK", "LL", "MM", "NN", "OO", "PP", "QQ", "RR", "SS", "TT", "UU", "VV", "WW", "XX", "YY", "ZZ"}
local function _(arg1, arg2) -- Line 11, Named "tranEndNum"
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var3
	if 0.9999 <= var3 then
		var3 = 0
		local var4 = arg1 + 1
		return var4, var3
	end
	local math_modf_result1_11, math_modf_result2_15 = math.modf(var3 * 100)
	if 0.9999 <= math_modf_result2_15 then
		math_modf_result1_11 += 1
	end
	return var4, math_modf_result1_11
end
local function _(arg1, arg2) -- Line 30, Named "tranEndNum_1"
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var7
	if 0.9999 <= var7 then
		var7 = 0
		local var8 = arg1 + 1
		return var8, var7
	end
	local math_modf_result1_5, math_modf_result2_2 = math.modf(var7 * 10)
	if 0.9999 <= math_modf_result2_2 then
		math_modf_result1_5 += 1
	end
	return var8, math_modf_result1_5
end
local function _(arg1) -- Line 49, Named "toFixed"
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local math_modf_result1_13, math_modf_result2_16 = math.modf(arg1)
	local var14
	if 0.9999 <= math_modf_result2_16 then
		var14 = math_modf_result1_13 + 1
	else
		local math_modf_result1_16, math_modf_result2_10 = math.modf(0 * 100)
		if 0.9999 <= math_modf_result2_10 then
			math_modf_result1_16 += 1
		end
		var14 = math_modf_result1_13 + 1
	end
	local var17 = var14
	local var18
	local var19 = math_modf_result1_16
	var14 = 0
	if var14 < var19 then
		var14 = 10
		if var19 < var14 then
			var14 = var17..".0"..var19
			return var14
		end
		var14 = var19 % 10
		if var14 == 0 then
			var14 = math.floor(var19 / 10)
		end
		var14 = var17..'.'..var14
		return var14
	end
	var14 = tostring(var17)
	return var14
end
local function _(arg1) -- Line 69, Named "toFixed_1"
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local math_modf_result1_21, math_modf_result2_14 = math.modf(arg1)
	local var23
	if 0.9999 <= math_modf_result2_14 then
		var23 = math_modf_result1_21 + 1
	else
		local math_modf_result1_19, math_modf_result2_11 = math.modf(0 * 10)
		if 0.9999 <= math_modf_result2_11 then
			math_modf_result1_19 += 1
		end
		var23 = math_modf_result1_21 + 1
	end
	local var26 = var23
	local var27
	local var28 = math_modf_result1_19
	var23 = 0
	if var23 < var28 then
		var23 = var28 % 10
		if var23 == 0 then
			var23 = math.floor(var28 / 10)
		end
		var23 = var26..'.'..var23
		return var23
	end
	var23 = tostring(var26)
	return var23
end
local function _(arg1) -- Line 84, Named "toFixed_0"
	local math_modf_result1_4, math_modf_result2_13 = math.modf(arg1)
	return tostring(math_modf_result1_4)
end
function module_2_upvr.getNumStr_0(arg1) -- Line 91
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg1 then
		return '0'
	end
	local tonumber_result1_3 = tonumber(arg1)
	for i = #tbl_upvr, 1, -1 do
		local math_pow_result1_2 = math.pow(10, i * 3)
		if math_pow_result1_2 <= tonumber_result1_3 then
			local math_modf_result1_10, _ = math.modf(tonumber_result1_3 / math_pow_result1_2)
			return tostring(math_modf_result1_10)..tbl_upvr[i]
		end
	end
	local math_modf_result1_6, _ = math.modf(tonumber_result1_3)
	return tostring(math_modf_result1_6)
end
function module_2_upvr.getNumStr_1(arg1) -- Line 111
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg1 then
		return '0'
	end
	local tonumber_result1_2 = tonumber(arg1)
	for i_2 = #tbl_upvr, 1, -1 do
		local var41 = 10
		local math_pow_result1_3 = math.pow(var41, i_2 * 3)
		local var43
		if math_pow_result1_3 <= tonumber_result1_2 then
			local math_modf_result1_18, math_modf_result2_8 = math.modf(tonumber_result1_2 / math_pow_result1_3)
			if 0.9999 <= math_modf_result2_8 then
				var43 = math_modf_result1_18 + 1
			else
				local math_modf_result1_9, math_modf_result2_5 = math.modf(0 * 10)
				if 0.9999 <= math_modf_result2_5 then
					math_modf_result1_9 += 1
				end
				var43 = math_modf_result1_18 + 1
			end
			local var49
			local var50 = math_modf_result1_9
			var43 = 0
			if var43 < var50 then
				var43 = var50 % 10
				if var43 == 0 then
					var43 = math.floor(var50 / 10)
				end
				var43 = var43
				var41 = var43..'.'..var43
			else
				var43 = tostring(var43)
				var41 = var43
			end
			return var41..tbl_upvr[i_2]
		end
	end
	local math_modf_result1_2, math_modf_result2_17 = math.modf(tonumber_result1_2)
	if 0.9999 <= math_modf_result2_17 then
		var41 = math_modf_result1_2 + 1
	else
		local math_modf_result1, math_modf_result2_12 = math.modf(0 * 10)
		if 0.9999 <= math_modf_result2_12 then
			math_modf_result1 += 1
		end
	end
	local var56 = math_modf_result1_2 + 1
	local var57
	local var58 = math_modf_result1
	if 0 < var58 then
		if var58 % 10 == 0 then
		end
		return var56..'.'..math.floor(var58 / 10)
	end
	local tostring_result1 = tostring(var56)
	do
		return tostring_result1
	end
	return tostring_result1
end
function module_2_upvr.getNumStr(arg1) -- Line 131
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg1 then
		return '0'
	end
	local tonumber_result1 = tonumber(arg1)
	for i_3 = #tbl_upvr, 1, -1 do
		local var63 = 10
		local math_pow_result1_4 = math.pow(var63, i_3 * 3)
		local var65
		if math_pow_result1_4 <= tonumber_result1 then
			local math_modf_result1_14, math_modf_result2_3 = math.modf(tonumber_result1 / math_pow_result1_4)
			if 0.9999 <= math_modf_result2_3 then
				var65 = math_modf_result1_14 + 1
			else
				local math_modf_result1_7, math_modf_result2_7 = math.modf(0 * 100)
				if 0.9999 <= math_modf_result2_7 then
					math_modf_result1_7 += 1
				end
				var65 = math_modf_result1_14 + 1
			end
			var65 = 0
			if var65 < math_modf_result1_7 then
				var65 = 10
				local var71
				if var71 < var65 then
					var65 = var65
					var63 = var65..".0"..var71
				else
					var65 = var71 % 10
					if var65 == 0 then
						var65 = math.floor(var71 / 10)
						var71 = var65
					end
					var65 = var65
					var63 = var65..'.'..var71
				end
			else
				var65 = tostring(var65)
				var63 = var65
			end
			return var63..tbl_upvr[i_3]
		end
	end
	local math_modf_result1_12, math_modf_result2_4 = math.modf(tonumber_result1)
	if 0.9999 <= math_modf_result2_4 then
		var63 = math_modf_result1_12 + 1
	else
		local math_modf_result1_20, math_modf_result2_6 = math.modf(0 * 100)
		if 0.9999 <= math_modf_result2_6 then
			math_modf_result1_20 += 1
		end
	end
	local var77 = math_modf_result1_12 + 1
	local var78
	local var79 = math_modf_result1_20
	if 0 < var79 then
		if var79 < 10 then
			return var77..".0"..var79
		end
		if var79 % 10 == 0 then
		end
		return var77..'.'..math.floor(var79 / 10)
	end
	local tostring_result1_2 = tostring(var77)
	do
		return tostring_result1_2
	end
	return tostring_result1_2
end
function module_2_upvr.BackNumStr(arg1) -- Line 151
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg1 then
		return 0
	end
	for i_4 = #tbl_upvr, 1, -1 do
		local string_find_result1 = string.find(arg1, tbl_upvr[i_4])
		if string_find_result1 then
			return tonumber(string.sub(arg1, 0, string_find_result1 - 1)) * math.pow(10, i_4 * 3)
		end
	end
	if tonumber(arg1) then
		return tonumber(arg1)
	end
	return 0
end
local function _(arg1) -- Line 173, Named "toFixed00000"
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local math_modf_result1_15, math_modf_result2_9 = math.modf(arg1)
	local var86
	if 0.9999 <= math_modf_result2_9 then
		var86 = math_modf_result1_15 + 1
	else
		local math_modf_result1_8, math_modf_result2_18 = math.modf(0 * 100)
		if 0.9999 <= math_modf_result2_18 then
			math_modf_result1_8 += 1
		end
		var86 = math_modf_result1_15 + 1
	end
	var86 = 0
	if var86 < math_modf_result1_8 then
		var86 = 10
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if math_modf_result1_8 < var86 then
			var86 = '0'
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		else
			var86 = ""
		end
	else
	end
	var86 = 10
	local var89
	if var89 < var86 then
		var86 = "00"
	else
		var86 = 100
		if var86..var89 < var86 then
			var86 = '0'
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		end
	end
	var86 = tostring(var86..var86..var89.."00")
	return var86
end
function module_2_upvr.getRankNum(arg1) -- Line 196
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local floored = math.floor(arg1)
	if not floored then
		return 0
	end
	for i_5 = #tbl_upvr, 1, -1 do
		local math_pow_result1 = math.pow(10, i_5 * 3)
		local var96
		if math_pow_result1 <= floored then
			local math_modf_result1_17, math_modf_result2 = math.modf(floored / math_pow_result1)
			if 0.9999 <= math_modf_result2 then
				var96 = math_modf_result1_17 + 1
			else
				local math_modf_result1_3, math_modf_result2_19 = math.modf(0 * 100)
				if 0.9999 <= math_modf_result2_19 then
					math_modf_result1_3 += 1
				end
				var96 = math_modf_result1_17 + 1
			end
			var96 = 0
			if var96 < math_modf_result1_3 then
				var96 = 10
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if math_modf_result1_3 < var96 then
					var96 = '0'
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				else
					var96 = ""
				end
			else
			end
			var96 = 10
			local var102
			if var102 < var96 then
				var96 = "00"
			else
				var96 = 100
				if var96..var102 < var96 then
					var96 = '0'
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				end
			end
			var96 = tostring(var96..var96..var102.."00")
			return tonumber(i_5..var96)
		end
	end
	return floored
end
function module_2_upvr.backRankNum(arg1) -- Line 214
	local floored_2 = math.floor(arg1)
	if not floored_2 then
		return 0
	end
	if floored_2 < 100000 then
		return floored_2
	end
	return math.floor(floored_2 % 100000) * math.pow(10, math.floor(floored_2 / 100000) * 3) * 0.01
end
function module_2_upvr.getRandNumZF(arg1) -- Line 230
	return -arg1 + (math.random()) * (arg1 * 2)
end
function module_2_upvr.getRandNum(arg1) -- Line 235
	return math.random() * arg1
end
function module_2_upvr.GetPercentStr(arg1) -- Line 241
	if 1 <= arg1 then
		return string.format("%0.2f", tostring(arg1)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	if 0.1 <= arg1 then
		return string.format("%0.2f", tostring(arg1)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	if 0.01 <= arg1 then
		return string.format("%0.3f", tostring(arg1)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	if 0.001 <= arg1 then
		return string.format("%0.4f", tostring(arg1)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	return "0.001%"
end
function module_2_upvr.GetChanceStr(arg1, arg2) -- Line 268
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var104 = arg1 / arg2 * 100
	if 1 <= var104 then
		return string.format("%0.2f", tostring(var104)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	if 0.1 <= var104 then
		return string.format("%0.2f", tostring(var104)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	if 0.01 <= var104 then
		return string.format("%0.3f", tostring(var104)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	if 0.001 <= var104 then
		return string.format("%0.4f", tostring(var104)):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")..'%'
	end
	return "1/"..module_2_upvr.getNumStr(arg2 / arg1 / 100)
end
function module_2_upvr.MathAdd(arg1, arg2) -- Line 298
end
function module_2_upvr.MathDel(arg1, arg2) -- Line 302
end
function module_2_upvr.MathMultiply(arg1, arg2) -- Line 306
end
function module_2_upvr.MathDivide(arg1, arg2) -- Line 310
end
function module_2_upvr.CheckIsInRate(arg1, arg2) -- Line 314
	if math.random() * arg2 < arg1 then
		return true
	end
	return false
end
function module_2_upvr.MapRangeClamped(arg1, arg2, arg3, arg4, arg5) -- Line 322
	if arg3 <= arg2 then return end
	if arg5 <= arg4 then return end
	if arg1 <= arg2 then
		return arg4
	end
	if arg3 <= arg1 then
		return arg5
	end
	return (arg5 - arg4) * ((arg1 - arg2) / (arg3 - arg2)) + arg4
end
function module_2_upvr.GetSkillCDMathNum(arg1) -- Line 343
	local var105
	if 10 <= arg1 then
		var105 = math.round(arg1)
	end
	if arg1 < 10 then
		var105 *= 10
		var105 = math.round(var105)
		var105 /= 10
	end
	return var105
end
function module_2_upvr.Table_Rand(arg1) -- Line 362
	if arg1 == nil then return end
	local module = {}
	local len = #arg1
	while 0 < len do
		local randint = math.random(1, len)
		table.insert(module, arg1[randint])
		arg1[randint] = arg1[len]
	end
	return module
end
function module_2_upvr.GetCFramePecent(arg1, arg2, arg3) -- Line 387
	return arg1:Lerp(arg2, arg3)
end
function module_2_upvr.GetVector3Pecent(arg1, arg2, arg3) -- Line 391
	return arg1 + (arg2 - arg1) * arg3
end
return module_2_upvr