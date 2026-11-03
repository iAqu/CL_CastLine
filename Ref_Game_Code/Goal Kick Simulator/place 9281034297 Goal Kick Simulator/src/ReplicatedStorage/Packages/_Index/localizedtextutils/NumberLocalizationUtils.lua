-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:05
-- Luau version 6, Types version 3
-- Time taken: 0.007394 seconds

local var1_upvr = require(script.Parent.loader).load(script)("RoundingBehaviourTypes")
local module = {}
local tbl_upvr = {
	["en-us"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, 'K'}, {1000000, 'M'}, {1000000000, 'B'}
	};
	["es-es"] = {
		decimalSeparator = ',';
		groupDelimiter = '.';
		
		{1, ""}, {1000, " mil"}, {1000000, " M"}
	};
	["fr-fr"] = {
		decimalSeparator = ',';
		groupDelimiter = ' ';
		
		{1, ""}, {1000, " k"}, {1000000, " M"}, {1000000000, " Md"}
	};
	["de-de"] = {
		decimalSeparator = ',';
		groupDelimiter = ' ';
		
		{1, ""}, {1000, " Tsd."}, {1000000, " Mio."}, {1000000000, " Mrd."}
	};
	["pt-br"] = {
		decimalSeparator = ',';
		groupDelimiter = '.';
		
		{1, ""}, {1000, " mil"}, {1000000, " mi"}, {1000000000, " bi"}
	};
	["zh-cn"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, "千"}, {10000, "万"}, {100000000, "亿"}
	};
	["zh-cjv"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, "千"}, {10000, "万"}, {100000000, "亿"}
	};
	["zh-tw"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, "千"}, {10000, "萬"}, {100000000, "億"}
	};
	["ko-kr"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, "천"}, {10000, "만"}, {100000000, "억"}
	};
	["ja-jp"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, "千"}, {10000, "万"}, {100000000, "億"}
	};
	["it-it"] = {
		decimalSeparator = ',';
		groupDelimiter = ' ';
		
		{1, ""}, {1000, " mila"}, {1000000, " Mln"}, {1000000000, " Mld"}
	};
	["ru-ru"] = {
		decimalSeparator = ',';
		groupDelimiter = '.';
		
		{1, ""}, {1000, " тыс"}, {1000000, " млн"}, {1000000000, " млрд"}
	};
	["id-id"] = {
		decimalSeparator = ',';
		groupDelimiter = '.';
		
		{1, ""}, {1000, " rb"}, {1000000, " jt"}, {1000000000, " M"}
	};
	["vi-vn"] = {
		decimalSeparator = '.';
		groupDelimiter = ' ';
		
		{1, ""}, {1000, " N"}, {1000000, " Tr"}, {1000000000, " T"}
	};
	["th-th"] = {
		decimalSeparator = '.';
		groupDelimiter = ',';
		
		{1, ""}, {1000, " พ"}, {10000, " ม"}, {100000, " ส"}, {1000000, " ล"}
	};
	["tr-tr"] = {
		decimalSeparator = ',';
		groupDelimiter = '.';
		
		{1, ""}, {1000, " B"}, {1000000, " Mn"}, {1000000000, " Mr"}
	};
	["en-gb"] = tbl_upvr["en-us"];
	["es-mx"] = tbl_upvr["es-es"];
}
local function _(arg1) -- Line 186, Named "findDecimalPointIndex"
	local string_find_result1_2 = string.find(arg1, "%.")
	if not string_find_result1_2 then
		string_find_result1_2 = #arg1 + 1
	end
	return string_find_result1_2
end
local function _(arg1) -- Line 191, Named "findDecimalOffset"
	if arg1 == 0 then
		return 0
	end
	return -(math.floor(math.log10(math.abs(arg1))) + 1)
end
local function _(arg1, arg2, arg3) -- Line 200, Named "roundToSignificantDigits"
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	if arg1 == 0 then
	else
	end
	local var85 = 10 ^ (arg2 + -(math.floor(math.log10(math.abs(arg1))) + 1))
	local var86
	if arg3 == var1_upvr.Truncate then
		var86 = math.modf(arg1 * var85)
	else
		var86 = math.floor(arg1 * var85 + 0.5)
	end
	return var86 / var85
end
local function addGroupDelimiters_upvr(arg1, arg2) -- Line 212, Named "addGroupDelimiters"
	local var87
	repeat
		local string_gsub_result1, string_gsub_result2 = string.gsub(var87, "^(-?%d+)(%d%d%d)", string.format("%%1%s%%2", arg2))
		var87 = string_gsub_result1
	until string_gsub_result2 == 0
	return var87
end
local function findDenominationEntry_upvr(arg1, arg2, arg3) -- Line 225, Named "findDenominationEntry"
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	local var92
	for i = #arg1, 2, -1 do
		local var93 = arg1[i]
		local var94
		if arg3 == var1_upvr.Truncate then
			var94 = var93[1]
		else
			var94 = var93[1] - arg1[i - 1][1] / 2
		end
		if var94 <= math.abs(arg2) then
			var92 = var93
			return var92
		end
	end
	return var92
end
function module.localize(arg1, arg2) -- Line 244
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: addGroupDelimiters_upvr (readonly)
	]]
	if arg1 == 0 then
		return '0'
	end
	local var95 = tbl_upvr[arg2]
	if not var95 then
		var95 = tbl_upvr["en-us"]
		warn(string.format("[NumberLocalizationUtils] - Locale not found: '%s', reverting to '%s' instead.", tostring(arg2), "en-us"))
	end
	if var95.groupDelimiter then
		return addGroupDelimiters_upvr(arg1, var95.groupDelimiter)
	end
	return arg1
end
function module.abbreviate(arg1, arg2, arg3, arg4) -- Line 263
	--[[ Upvalues[4]:
		[1]: var1_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: findDenominationEntry_upvr (readonly)
		[4]: addGroupDelimiters_upvr (readonly)
	]]
	if arg1 == 0 then
		return '0'
	end
	if arg3 == nil then
		local RoundToClosest = var1_upvr.RoundToClosest
	end
	if arg4 == nil then
	end
	local var97 = tbl_upvr[arg2]
	if not var97 then
		var97 = tbl_upvr["en-us"]
		warn(string.format("[NumberLocalizationUtils] - Locale not found: '%s', reverting to '%s' instead.", tostring(arg2), "en-us"))
	end
	local findDenominationEntry_result1 = findDenominationEntry_upvr(var97, arg1, RoundToClosest)
	local _2 = findDenominationEntry_result1[2]
	local var100 = arg1 / findDenominationEntry_result1[1]
	if var100 == 0 then
	else
	end
	local var101 = 10 ^ (3 + -(math.floor(math.log10(math.abs(var100))) + 1))
	local var102
	if RoundToClosest == var1_upvr.Truncate then
		var102 = math.modf(var100 * var101)
	else
		var102 = math.floor(var100 * var101 + 0.5)
	end
	var100 = nil
	local var103 = var100
	if RoundToClosest == var1_upvr.Truncate then
		var103 = math.modf(var102 / var101 * 10) / 10
	else
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		var103 = math.floor(var102 / var101 * 10 + 0.5) / 10
	end
	local tostring_result1 = tostring(var103)
	local string_find_result1 = string.find(tostring_result1, "%.")
	if not string_find_result1 then
		string_find_result1 = #tostring_result1 + 1
	end
	local string_sub_result1_2 = string.sub(tostring_result1, 1, string_find_result1 - 1)
	local string_sub_result1 = string.sub(tostring_result1, string_find_result1 + 1, #tostring_result1)
	if var97.groupDelimiter then
		string_sub_result1_2 = addGroupDelimiters_upvr(string_sub_result1_2, var97.groupDelimiter)
	end
	if 0 < #string_sub_result1 then
		return string_sub_result1_2..var97.decimalSeparator..string_sub_result1.._2
	end
	return string_sub_result1_2.._2
end
return module