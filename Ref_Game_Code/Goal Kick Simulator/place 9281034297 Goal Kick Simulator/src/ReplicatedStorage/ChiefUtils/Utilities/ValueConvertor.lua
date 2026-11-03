-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:50
-- Luau version 6, Types version 3
-- Time taken: 0.009453 seconds

local module_3_upvr = {
	FormatDigit = function(arg1, arg2, arg3) -- Line 5, Named "FormatDigit"
		local tostring_result1_4 = tostring(arg2)
		local var3 = arg3 - tostring_result1_4:len()
		if 0 < var3 then
			tostring_result1_4 = string.rep('0', var3)..tostring_result1_4
		end
		return tostring_result1_4
	end;
	FormatOrdinal = function(arg1, arg2) -- Line 14, Named "FormatOrdinal"
		local var4
		local tostring_result1 = tostring(arg2)
		local var6
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var6 = tostring_result1:sub(-2):sub(1, 1)
			return var6
		end
		if 1 >= tostring_result1:len() or not INLINED() then
			var6 = ""
		end
		local any_sub_result1_2 = tostring_result1:sub(-1)
		if var6 == '1' then
			var4 = "th"
		elseif any_sub_result1_2 == '1' then
			var4 = "st"
		elseif any_sub_result1_2 == '2' then
			var4 = "nd"
		elseif any_sub_result1_2 == '3' then
			var4 = "rd"
		else
			var4 = "th"
		end
		return tostring(arg2)..var4
	end;
	AddCommas = function(arg1, arg2) -- Line 34, Named "AddCommas"
		if arg2 == math.huge then
			return "∞"
		end
		local var10 = arg2 % 1
		local var11 = math.ceil(var10 * 100 - 0.5) / 100
		local tostring_result1_3 = tostring(arg2 - var10)
		for i = 1, (#tostring_result1_3 - 1) / 3 do
			local var13 = -((3 * i) + (i - 1))
			tostring_result1_3 = tostring_result1_3:sub(1, var13 - 1)..','..tostring_result1_3:sub(var13)
			local var14
		end
		if var11 ~= 0 then
			i = tostring(var11):sub(3, tostring(var11):len())
		end
		return var14..'.'..i
	end;
}
function module_3_upvr.FormatTime(arg1, arg2) -- Line 57
	--[[ Upvalues[1]:
		[1]: module_3_upvr (readonly)
	]]
	local ceiled_3 = math.ceil(arg2 - 0.5)
	local floored_7 = math.floor(ceiled_3 / 3600)
	local floored_2 = math.floor(ceiled_3 % 3600 / 60)
	local var19 = ceiled_3 % 60
	if 0 < floored_7 then
		return floored_7.."h "..module_3_upvr:FormatDigit(floored_2, 2).."m "..module_3_upvr:FormatDigit(var19, 2)..'s'
	end
	if 0 < floored_2 then
		return floored_2.."m "..module_3_upvr:FormatDigit(var19, 2)..'s'
	end
	return var19..'s'
end
function module_3_upvr.FormatTimeWithDays(arg1, arg2) -- Line 71
	--[[ Upvalues[1]:
		[1]: module_3_upvr (readonly)
	]]
	local ceiled_4 = math.ceil(arg2 - 0.5)
	local floored_5 = math.floor(ceiled_4 / 86400)
	local floored_3 = math.floor(ceiled_4 % 86400 / 3600)
	local floored_4 = math.floor(ceiled_4 % 3600 / 60)
	local var24 = ceiled_4 % 60
	if 0 < floored_5 then
		return floored_5.."d "..module_3_upvr:FormatDigit(floored_3, 2).."h "..module_3_upvr:FormatDigit(floored_4, 2).."m "..module_3_upvr:FormatDigit(var24, 2)..'s'
	end
	if 0 < floored_3 then
		return floored_3.."h "..module_3_upvr:FormatDigit(floored_4, 2).."m "..module_3_upvr:FormatDigit(var24, 2)..'s'
	end
	if 0 < floored_4 then
		return floored_4.."m "..module_3_upvr:FormatDigit(var24, 2)..'s'
	end
	return var24..'s'
end
function module_3_upvr.FormatShortTime(arg1, arg2) -- Line 88
	local ceiled_2 = math.ceil(arg2 - 0.5)
	local floored_8 = math.floor(ceiled_2 / 3600)
	local floored_6 = math.floor(ceiled_2 % 3600 / 60)
	if 0 < floored_8 then
		return floored_8..'h'
	end
	if 0 < floored_6 then
		return floored_6.."m "
	end
	return (ceiled_2 % 60)..'s'
end
function module_3_upvr.AddNumberPadding(arg1, arg2, arg3) -- Line 102
	local tostring_result1_2 = tostring(arg2)
	local var29 = arg3 - tostring_result1_2:len()
	if 0 < var29 then
		tostring_result1_2 = string.rep('0', var29)..tostring_result1_2
	end
	return tostring_result1_2
end
local module_4_upvr = {'K', 'M', 'B', 'T', "Qd", "Qnt", "Sxt", "Spt", "Oct", "Non", "Dec", "Und", "Dod", "Trd", "Qad", "Qud", "Sxd", "Spd", "Ocd", "Nvd", "Vig", "Uvg", "Dvg", "Tvg", "Qvv", "Qvg", "Sxv", "Spv", "Ocv", "Nvv", "Trg", "Utg", "Dtg"}
function module_3_upvr.ShrinkNumber(arg1, arg2) -- Line 113
	--[[ Upvalues[1]:
		[1]: module_4_upvr (readonly)
	]]
	if arg2 == math.huge then
		return "∞"
	end
	if 999 < arg2 then
		local ceiled = math.ceil(arg2)
		local tostring_result1_5 = tostring(ceiled)
		local any_len_result1 = tostring_result1_5:len()
		local floored = math.floor((any_len_result1 - 1) / 3)
		tostring_result1_5 = tostring_result1_5:sub(1, any_len_result1 - floored * 3 + 1)
		local var35 = tostring_result1_5
		local any_sub_result1 = var35:sub(var35:len(), var35:len())
		if any_sub_result1 == '0' then
			var35 = var35:sub(1, var35:len() - 1)
		else
			var35 = var35:sub(1, var35:len() - 1)..'.'..any_sub_result1
		end
		return var35..module_4_upvr[floored]
	end
	return tostring(math.ceil(ceiled * 1000) / 1000)
end
function module_3_upvr.GetColorFromPercentage(arg1, arg2, arg3, arg4, arg5) -- Line 142
	local var37 = arg2
	if var37 then
		var37 = string.gsub(arg2, "%D", "")
	end
	local var38 = var37
	if var38 then
		var38 = tonumber(var37)
	end
	local var39 = var38
	if var39 then
		var38 = arg5
		local var40 = var38
		if not var40 then
			var40 = Color3.new(0, 1, 0)
		end
		local var41 = var40
		var40 = arg4
		local var42 = var40
		if not var42 then
			var42 = Color3.new(1, 0, 0)
		end
		local var43 = var42
		local clamped_2 = math.clamp(var39 / (arg3 or 1), 0, 1)
		local var45 = Vector3.new(var41.R, var41.G, var41.B) - Vector3.new(var43.R, var43.G, var43.B)
		return Color3.new(var43.R + var45.X * clamped_2, var43.G + var45.Y * clamped_2, var43.B + var45.Z * clamped_2)
	end
end
function module_3_upvr.AdjustColor(arg1, arg2, arg3) -- Line 156
	return Color3.new(arg2.R * arg3, arg2.G * arg3, arg2.B * arg3)
end
function module_3_upvr.GetPercentageTable(arg1, arg2) -- Line 160
	local _Total = arg2._Total
	local module = {}
	local var52 = 0
	for i_2, v in pairs(arg2.Content) do
		module[i_2] = v / _Total
		var52 += v
	end
	module[arg2._Default] = (_Total - var52) / _Total
	return module
end
function module_3_upvr.PickRarity(arg1, arg2, arg3) -- Line 173
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 50 start (CF ANALYSIS FAILED)
	local var80 = 0
	local tbl = {}
	local pairs_result1_2, pairs_result2, pairs_result3 = pairs(arg3.Content)
	for i_3, v_2 in pairs_result1_2, pairs_result2, pairs_result3 do
		tbl[#tbl + 1] = {
			Rarity = i_3;
			Value = v_2;
		}
	end
	pairs_result2 = arg3.Guaranteed
	local var86 = pairs_result2
	if not var86 then
		var86 = {}
	end
	for _, v_3 in pairs(var86) do
		var80 += v_3
	end
	table.sort(tbl, function(arg1_2, arg2_2) -- Line 184
		local var91
		if arg1_2.Value >= arg2_2.Value then
			var91 = false
		else
			var91 = true
		end
		return var91
	end)
	for _, v_4 in pairs(tbl) do
		v_4.Value += 0
		local var95
	end
	-- KONSTANTERROR: [0] 1. Error Block 50 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [59] 42. Error Block 10 start (CF ANALYSIS FAILED)
	local _, _, _ = pairs(tbl)
	-- KONSTANTERROR: [59] 42. Error Block 10 end (CF ANALYSIS FAILED)
end
function module_3_upvr.GetPercentageFromNumbers(arg1, arg2, arg3, arg4) -- Line 215
	return math.clamp((arg2 - arg3) / (arg4 - arg3), 0, 1)
end
function module_3_upvr.FormatMarkupColor(arg1, arg2, arg3) -- Line 219
	return string.format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.clamp(arg3.R, 0, 1) * 255, math.clamp(arg3.G, 0, 1) * 255, math.clamp(arg3.B, 0, 1) * 255), arg2)
end
function module_3_upvr.GetNumberSequenceFromPercentage(arg1, arg2, arg3) -- Line 224
	local clamped = math.clamp(arg2 or 0, 0, 1)
	local var100 = arg3 or 0.05
	local module_2 = {}
	local NumberSequenceKeypoint_new_result1 = NumberSequenceKeypoint.new(0, 1 - math.clamp(clamped / var100, 0, 1))
	module_2[1] = NumberSequenceKeypoint_new_result1
	local var103
	if var103 > clamped then
		NumberSequenceKeypoint_new_result1 = false
	else
		NumberSequenceKeypoint_new_result1 = true
	end
	if clamped >= var100 then
		var103 = false
	else
		var103 = true
	end
	if not var103 and not NumberSequenceKeypoint_new_result1 then
		module_2[#module_2 + 1] = NumberSequenceKeypoint.new(clamped - var100, 0)
	end
	if NumberSequenceKeypoint_new_result1 then
		module_2[#module_2 + 1] = NumberSequenceKeypoint.new(clamped - var100, 0)
		if clamped ~= 1 then
			module_2[#module_2 + 1] = NumberSequenceKeypoint.new(1, 1 - math.clamp((clamped + var100) % 1 / var100, 0, 1))
		else
			module_2[#module_2 + 1] = NumberSequenceKeypoint.new(1, 0)
		end
	else
		if not var103 then
			module_2[#module_2 + 1] = NumberSequenceKeypoint.new(clamped + var100, 1)
		else
			module_2[#module_2 + 1] = NumberSequenceKeypoint.new(clamped + var100, 1)
		end
		module_2[#module_2 + 1] = NumberSequenceKeypoint.new(1, 1)
	end
	return NumberSequence.new(module_2)
end
function module_3_upvr.NormalizeRarity(arg1, arg2) -- Line 255
	if arg2 == "Secret" then
		return 5
	end
	if arg2 == "Legendary" then
		return 4
	end
	if arg2 == "Epic" then
		return 3
	end
	if arg2 == "Rare" then
		return 2
	end
	if arg2 == "Common" then
		return 1
	end
	return 0
end
return module_3_upvr