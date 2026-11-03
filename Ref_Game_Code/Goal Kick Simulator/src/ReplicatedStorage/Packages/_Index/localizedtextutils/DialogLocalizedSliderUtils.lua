-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:42
-- Luau version 6, Types version 3
-- Time taken: 0.000891 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("DialogSliderOptionTypes")
local var1_result1_upvr = any_load_result1("DialogSliderOptionUtils")
local any_load_result1_result1_upvr = any_load_result1("DialogTranslator")
function module.createOptionsFromLocalizedOptions(arg1, arg2) -- Line 13
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local var6
	if arg2.type ~= var1_result1_upvr_2.LOCALIZED_SLIDER_OPTIONS then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad type")
	var6 = var1_result1_upvr
	var6 = {}
	var6.formatType = arg2.formatType
	var6.key = arg2.key
	var6.initialValue = arg2.initialValue
	var6.min = arg2.min
	var6.minLabel = arg1:GetService(any_load_result1_result1_upvr):FormatByKey(arg2.minLabelKey, arg2.minLabelContext)
	var6.max = arg2.max
	var6.maxLabel = arg1:GetService(any_load_result1_result1_upvr):FormatByKey(arg2.maxLabelKey, arg2.maxLabelContext)
	var6.round = arg2.round
	return var6.createSliderOptions(var6)
end
return module