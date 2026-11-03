-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:02
-- Luau version 6, Types version 3
-- Time taken: 0.014107 seconds

local module_2_upvr = {}
local function _(arg1) -- Line 29, Named "distance_line_from_origin"
	return math.abs(arg1.intercept) / math.sqrt(arg1.slope * arg1.slope + 1)
end
local function _(arg1, arg2) -- Line 33, Named "length_of_ray_until_intersect"
	return arg2.intercept / (math.sin(arg1) - arg2.slope * math.cos(arg1))
end
function module_2_upvr.get_bounds(arg1) -- Line 37
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local module_3 = {}
	local var7 = (arg1 + 16) ^ 3 / 1560896
	local var8
	if module_2_upvr.epsilon < var7 then
		var8 = var7
	else
		var8 = arg1 / module_2_upvr.kappa
	end
	for i = 1, 3 do
		local _1_5 = module_2_upvr.m[i][1]
		local _2 = module_2_upvr.m[i][2]
		local _3_3 = module_2_upvr.m[i][3]
		for i_2 = 0, 1 do
			local var12 = (632260 * _3_3 - 126452 * _2) * var8 + 126452 * i_2
			table.insert(module_3, {
				slope = (284517 * _1_5 - 94839 * _3_3) * var8 / var12;
				intercept = ((838422 * _3_3 + 769860 * _2 + 731718 * _1_5) * arg1 * var8 - 769860 * i_2 * arg1) / var12;
			})
		end
	end
	return module_3
end
function module_2_upvr.max_safe_chroma_for_l(arg1) -- Line 65
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var16
	for i_3 = 1, 6 do
		local var17 = module_2_upvr.get_bounds(arg1)[i_3]
		local var18 = math.abs(var17.intercept) / math.sqrt(var17.slope * var17.slope + 1)
		if 0 <= var18 then
			var16 = math.min(var16, var18)
		end
	end
	return var16
end
function module_2_upvr.max_safe_chroma_for_lh(arg1, arg2) -- Line 78
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var21 = arg2 / 360 * math.pi * 2
	local var22
	for i_4 = 1, 6 do
		local var23 = module_2_upvr.get_bounds(arg1)[i_4]
		local var24 = var23.intercept / (math.sin(var21) - var23.slope * math.cos(var21))
		if 0 <= var24 then
			var22 = math.min(var22, var24)
		end
	end
	return var22
end
function module_2_upvr.dot_product(arg1, arg2) -- Line 93
	return 0 + arg1[1] * arg2[1] + arg1[2] * arg2[2] + arg1[3] * arg2[3]
end
function module_2_upvr.from_linear(arg1) -- Line 101
	if arg1 <= 0.0031308 then
		return 12.92 * arg1
	end
	return 1.055 * arg1 ^ 0.4166666666666667 - 0.055
end
function module_2_upvr.to_linear(arg1) -- Line 109
	if 0.04045 < arg1 then
		return ((arg1 + 0.055) / 1.055) ^ 2.4
	end
	return arg1 / 12.92
end
function module_2_upvr.xyz_to_rgb(arg1) -- Line 117
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return {module_2_upvr.from_linear(module_2_upvr.dot_product(module_2_upvr.m[1], arg1)), module_2_upvr.from_linear(module_2_upvr.dot_product(module_2_upvr.m[2], arg1)), module_2_upvr.from_linear(module_2_upvr.dot_product(module_2_upvr.m[3], arg1))}
end
function module_2_upvr.rgb_to_xyz(arg1) -- Line 125
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local tbl = {module_2_upvr.to_linear(arg1[1]), module_2_upvr.to_linear(arg1[2]), module_2_upvr.to_linear(arg1[3])}
	return {module_2_upvr.dot_product(module_2_upvr.minv[1], tbl), module_2_upvr.dot_product(module_2_upvr.minv[2], tbl), module_2_upvr.dot_product(module_2_upvr.minv[3], tbl)}
end
function module_2_upvr.y_to_l(arg1) -- Line 138
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	if arg1 <= module_2_upvr.epsilon then
		return arg1 / module_2_upvr.refY * module_2_upvr.kappa
	end
	return 116 * (arg1 / module_2_upvr.refY) ^ 0.3333333333333333 - 16
end
function module_2_upvr.l_to_y(arg1) -- Line 146
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	if arg1 <= 8 then
		return module_2_upvr.refY * arg1 / module_2_upvr.kappa
	end
	return module_2_upvr.refY * ((arg1 + 16) / 116) ^ 3
end
function module_2_upvr.xyz_to_luv(arg1) -- Line 154
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local _1_3 = arg1[1]
	local _2_4 = arg1[2]
	local var30 = _1_3 + 15 * _2_4 + 3 * arg1[3]
	local var31 = 4 * _1_3
	local var32 = 9 * _2_4
	if var30 ~= 0 then
		var31 /= var30
		var32 /= var30
	else
		var31 = 0
		var32 = 0
	end
	local any_y_to_l_result1 = module_2_upvr.y_to_l(_2_4)
	if any_y_to_l_result1 == 0 then
		return {0, 0, 0}
	end
	return {any_y_to_l_result1, 13 * any_y_to_l_result1 * (var31 - module_2_upvr.refU), 13 * any_y_to_l_result1 * (var32 - module_2_upvr.refV)}
end
function module_2_upvr.luv_to_xyz(arg1) -- Line 174
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local _1_7 = arg1[1]
	if _1_7 == 0 then
		return {0, 0, 0}
	end
	local var38 = (arg1[2]) / (13 * _1_7) + module_2_upvr.refU
	local var39 = (arg1[3]) / (13 * _1_7) + module_2_upvr.refV
	local any_l_to_y_result1 = module_2_upvr.l_to_y(_1_7)
	local var41 = 0 - 9 * any_l_to_y_result1 * var38 / ((var38 - 4) * var39 - var38 * var39)
	return {var41, any_l_to_y_result1, (9 * any_l_to_y_result1 - 15 * var39 * any_l_to_y_result1 - var39 * var41) / (3 * var39)}
end
function module_2_upvr.luv_to_lch(arg1) -- Line 188
	local _2_3 = arg1[2]
	local _3_4 = arg1[3]
	local squareroot = math.sqrt(_2_3 * _2_3 + _3_4 * _3_4)
	local var46
	if squareroot < 1e-08 then
		var46 = 0
	else
		var46 = math.atan2(_3_4, _2_3) * 180 / math.pi
		if var46 < 0 then
			var46 = 360 + var46
		end
	end
	return {arg1[1], squareroot, var46}
end
function module_2_upvr.lch_to_luv(arg1) -- Line 205
	local _2_2 = arg1[2]
	local var49 = arg1[3] / 360 * 2 * math.pi
	return {arg1[1], math.cos(var49) * _2_2, math.sin(var49) * _2_2}
end
function module_2_upvr.hsluv_to_lch(arg1) -- Line 212
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local _1 = arg1[1]
	local _3_6 = arg1[3]
	if 99.9999999 < _3_6 then
		return {100, 0, _1}
	end
	if _3_6 < 1e-08 then
		return {0, 0, _1}
	end
	return {_3_6, module_2_upvr.max_safe_chroma_for_lh(_3_6, _1) / 100 * arg1[2], _1}
end
function module_2_upvr.lch_to_hsluv(arg1) -- Line 225
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local _1_2 = arg1[1]
	local _3_5 = arg1[3]
	if 99.9999999 < _1_2 then
		return {_3_5, 0, 100}
	end
	if _1_2 < 1e-08 then
		return {_3_5, 0, 0}
	end
	return {_3_5, arg1[2] / module_2_upvr.max_safe_chroma_for_lh(_1_2, _3_5) * 100, _1_2}
end
function module_2_upvr.hpluv_to_lch(arg1) -- Line 240
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local _1_6 = arg1[1]
	local _3 = arg1[3]
	if 99.9999999 < _3 then
		return {100, 0, _1_6}
	end
	if _3 < 1e-08 then
		return {0, 0, _1_6}
	end
	return {_3, module_2_upvr.max_safe_chroma_for_l(_3) / 100 * arg1[2], _1_6}
end
function module_2_upvr.lch_to_hpluv(arg1) -- Line 253
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local _1_4 = arg1[1]
	local _3_2 = arg1[3]
	if 99.9999999 < _1_4 then
		return {_3_2, 0, 100}
	end
	if _1_4 < 1e-08 then
		return {_3_2, 0, 0}
	end
	return {_3_2, arg1[2] / module_2_upvr.max_safe_chroma_for_l(_1_4) * 100, _1_4}
end
function module_2_upvr.rgb_to_hex(arg1) -- Line 266
	local var73 = '#'
	for i_5 = 1, 3 do
		local rounded = math.floor(arg1[i_5] * 255 + 0.5)
		local math_fmod_result1 = math.fmod(rounded, 16)
		local _ = math.floor((rounded - math_fmod_result1) / 16)
		var73 = var73..string.sub("0123456789abcdef", _ + 1, _ + 1)
		var73 = var73..string.sub("0123456789abcdef", math_fmod_result1 + 1, math_fmod_result1 + 1)
	end
	return var73
end
function module_2_upvr.hex_to_rgb(arg1) -- Line 279
	arg1 = string.lower(arg1)
	local var79 = arg1
	local module = {}
	for i_6 = 0, 2 do
		module[i_6 + 1] = (((string.find("0123456789abcdef", string.sub(var79, i_6 * 2 + 2, i_6 * 2 + 2)) - 1) * 16) + (string.find("0123456789abcdef", string.sub(var79, i_6 * 2 + 3, i_6 * 2 + 3)) - 1)) / 255
	end
	return module
end
function module_2_upvr.lch_to_rgb(arg1) -- Line 292
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.xyz_to_rgb(module_2_upvr.luv_to_xyz(module_2_upvr.lch_to_luv(arg1)))
end
function module_2_upvr.rgb_to_lch(arg1) -- Line 296
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.luv_to_lch(module_2_upvr.xyz_to_luv(module_2_upvr.rgb_to_xyz(arg1)))
end
function module_2_upvr.hsluv_to_rgb(arg1) -- Line 300
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.lch_to_rgb(module_2_upvr.hsluv_to_lch(arg1))
end
function module_2_upvr.rgb_to_hsluv(arg1) -- Line 304
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.lch_to_hsluv(module_2_upvr.rgb_to_lch(arg1))
end
function module_2_upvr.hpluv_to_rgb(arg1) -- Line 308
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.lch_to_rgb(module_2_upvr.hpluv_to_lch(arg1))
end
function module_2_upvr.rgb_to_hpluv(arg1) -- Line 312
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.lch_to_hpluv(module_2_upvr.rgb_to_lch(arg1))
end
function module_2_upvr.hsluv_to_hex(arg1) -- Line 316
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.rgb_to_hex(module_2_upvr.hsluv_to_rgb(arg1))
end
function module_2_upvr.hpluv_to_hex(arg1) -- Line 320
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.rgb_to_hex(module_2_upvr.hpluv_to_rgb(arg1))
end
function module_2_upvr.hex_to_hsluv(arg1) -- Line 324
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.rgb_to_hsluv(module_2_upvr.hex_to_rgb(arg1))
end
function module_2_upvr.hex_to_hpluv(arg1) -- Line 328
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.rgb_to_hpluv(module_2_upvr.hex_to_rgb(arg1))
end
module_2_upvr.m = {{3.240969941904521, -1.537383177570093, -0.498610760293}, {-0.96924363628087, 1.87596750150772, 0.041555057407175}, {0.055630079696993, -0.20397695888897, 1.056971514242878}}
module_2_upvr.minv = {{0.41239079926595, 0.35758433938387, 0.18048078840183}, {0.21263900587151, 0.71516867876775, 0.072192315360733}, {0.019330818715591, 0.11919477979462, 0.95053215224966}}
module_2_upvr.refY = 1
module_2_upvr.refU = 0.19783000664283
module_2_upvr.refV = 0.46831999493879
module_2_upvr.kappa = 903.2962962
module_2_upvr.epsilon = 0.0088564516
return module_2_upvr