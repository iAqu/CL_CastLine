-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:35
-- Luau version 6, Types version 3
-- Time taken: 0.007872 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local var1_result1_upvr = any_load_result1("Rx")
local module_upvr = {
	ClassName = "JSONTranslator";
	ServiceName = "JSONTranslator";
}
module_upvr.__index = module_upvr
local var1_result1_upvr_3 = any_load_result1("JsonToLocalizationTable")
local any_load_result1_result1_upvr_5 = any_load_result1("LocalizationServiceUtils")
local Players_upvr = game:GetService("Players")
local any_load_result1_result1_upvr_4 = any_load_result1("Promise")
local any_load_result1_result1_upvr = any_load_result1("PseudoLocalize")
function module_upvr.new(arg1, ...) -- Line 48
	--[[ Upvalues[7]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: RunService_upvr (readonly)
		[4]: any_load_result1_result1_upvr_5 (readonly)
		[5]: Players_upvr (readonly)
		[6]: any_load_result1_result1_upvr_4 (readonly)
		[7]: any_load_result1_result1_upvr (readonly)
	]]
	local var10 = module_upvr
	local setmetatable_result1 = setmetatable({}, var10)
	if type(arg1) ~= "string" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "Bad translatorName")
	setmetatable_result1.ServiceName = arg1
	setmetatable_result1._localizationTable = var1_result1_upvr_3.toLocalizationTable(arg1, ...)
	setmetatable_result1._englishTranslator = setmetatable_result1._localizationTable:GetTranslator("en")
	setmetatable_result1._fallbacks = {}
	if RunService_upvr:IsRunning() then
		setmetatable_result1._promiseTranslator = any_load_result1_result1_upvr_5.promiseTranslator(Players_upvr.LocalPlayer)
	else
		setmetatable_result1._promiseTranslator = any_load_result1_result1_upvr_4.resolved(setmetatable_result1._englishTranslator)
	end
	if RunService_upvr:IsStudio() then
		any_load_result1_result1_upvr.addToLocalizationTable(setmetatable_result1._localizationTable, nil, "en")
	end
	return setmetatable_result1
end
local any_load_result1_result1_upvr_3 = any_load_result1("RxInstanceUtils")
function module_upvr.ObserveLocaleId(arg1) -- Line 77
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr.fromPromise(arg1._promiseTranslator):Pipe({var1_result1_upvr.switchMap(function(arg1_2) -- Line 79
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		return any_load_result1_result1_upvr_3.observeProperty(arg1_2, "LocaleId")
	end)})
end
function module_upvr.GetLocaleId(arg1) -- Line 90
	if arg1._promiseTranslator:IsFulfilled() then
		return arg1._promiseTranslator:Wait().LocaleId
	end
	warn("[JSONTranslator] - Translator is not loaded yet, returning english")
	return "en"
end
function module_upvr.GetLocalizationTable(arg1) -- Line 105
	return arg1._localizationTable
end
function module_upvr.PromiseLoaded(arg1) -- Line 113
	return arg1._promiseTranslator
end
function module_upvr.FallbackTo(arg1, arg2) -- Line 124
	assert(arg2, "Bad translator")
	assert(arg2.FormatByKey, "Bad translator")
	table.insert(arg1._fallbacks, arg2)
end
function module_upvr.PromiseFormatByKey(arg1, arg2, arg3) -- Line 137
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var15
	if arg1 == module_upvr then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Construct a new version of this class to use it")
	if type(arg2) ~= "string" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Key must be a string")
	return arg1._promiseTranslator:Then(function() -- Line 141
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
		]]
		return arg1:FormatByKey(arg2, arg3)
	end)
end
local any_load_result1_result1_upvr_2 = any_load_result1("Blend")
local var1_result1_upvr_2 = any_load_result1("Observable")
local var1_result1_upvr_4 = any_load_result1("Maid")
function module_upvr.ObserveFormatByKey(arg1, arg2, arg3) -- Line 152
	--[[ Upvalues[5]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_2 (readonly)
		[5]: var1_result1_upvr_4 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 29 start (CF ANALYSIS FAILED)
	local var28
	if arg1 == module_upvr then
		var28 = false
	else
		var28 = true
	end
	assert(var28, "Construct a new version of this class to use it")
	if type(arg2) ~= "string" then
		var28 = false
		-- KONSTANTWARNING: GOTO [20] #16
	end
	-- KONSTANTERROR: [0] 1. Error Block 29 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [19] 15. Error Block 31 start (CF ANALYSIS FAILED)
	var28 = true
	assert(var28, "Key must be a string")
	if arg3 then
		var28 = {}
		for i, v in pairs(arg3) do
			local any_toPropertyObservable_result1 = any_load_result1_result1_upvr_2.toPropertyObservable(v)
			if not any_toPropertyObservable_result1 then
				any_toPropertyObservable_result1 = var1_result1_upvr.of(v)
			end
			var28[i] = any_toPropertyObservable_result1
		end
	else
	end
	var28 = var1_result1_upvr_2.new
	local var34_upvw
	var28 = var28(function(arg1_3) -- Line 168
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var34_upvw (read and write)
			[4]: arg2 (readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr_4.new()
		any_new_result1_upvr:GivePromise(arg1._promiseTranslator:Then(function() -- Line 171
			--[[ Upvalues[5]:
				[1]: var34_upvw (copied, read and write)
				[2]: any_new_result1_upvr (readonly)
				[3]: arg1_3 (readonly)
				[4]: arg1 (copied, readonly)
				[5]: arg2 (copied, readonly)
			]]
			if var34_upvw then
				any_new_result1_upvr:GiveTask(var34_upvw:Subscribe(function(arg1_4) -- Line 173
					--[[ Upvalues[3]:
						[1]: arg1_3 (copied, readonly)
						[2]: arg1 (copied, readonly)
						[3]: arg2 (copied, readonly)
					]]
					arg1_3:Fire(arg1:FormatByKey(arg2, arg1_4))
				end))
			else
				arg1_3:Fire(arg1:FormatByKey(arg2, nil))
			end
		end))
		return any_new_result1_upvr
	end)
	do
		return var28
	end
	-- KONSTANTERROR: [19] 15. Error Block 31 end (CF ANALYSIS FAILED)
end
function module_upvr.FormatByKey(arg1, arg2, arg3) -- Line 191
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local var46_upvw
	if arg1 == module_upvr then
		var46_upvw = false
	else
		var46_upvw = true
	end
	assert(var46_upvw, "Construct a new version of this class to use it")
	if type(arg2) ~= "string" then
		var46_upvw = false
	else
		var46_upvw = true
	end
	assert(var46_upvw, "Key must be a string")
	if not RunService_upvr:IsRunning() then
		return arg1:_formatByKeyTestMode(arg2, arg3)
	end
	local any__getClientTranslatorOrError_result1_upvr = arg1:_getClientTranslatorOrError()
	var46_upvw = nil
	local pcall_result1, pcall_result2_3 = pcall(function() -- Line 202
		--[[ Upvalues[4]:
			[1]: var46_upvw (read and write)
			[2]: any__getClientTranslatorOrError_result1_upvr (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
		]]
		var46_upvw = any__getClientTranslatorOrError_result1_upvr:FormatByKey(arg2, arg3)
	end)
	if pcall_result1 and not pcall_result2_3 then
		return var46_upvw
	end
	if pcall_result2_3 then
		warn(pcall_result2_3)
	else
		warn("Failed to localize '"..arg2.."'")
	end
	if any__getClientTranslatorOrError_result1_upvr.LocaleId ~= arg1._englishTranslator.LocaleId then
		local pcall_result1_3, pcall_result2_2 = pcall(function() -- Line 219
			--[[ Upvalues[4]:
				[1]: var46_upvw (read and write)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
				[4]: arg3 (readonly)
			]]
			var46_upvw = arg1._englishTranslator:FormatByKey(arg2, arg3)
		end)
		if pcall_result1_3 and not pcall_result2_2 then
			return var46_upvw
		end
	end
	return arg2
end
function module_upvr._getClientTranslatorOrError(arg1) -- Line 231
	assert(arg1._promiseTranslator, "ClientTranslator is not initialized")
	if arg1._promiseTranslator:IsFulfilled() then
		return assert(arg1._promiseTranslator:Wait(), "Failed to get translator")
	end
	error("Translator is not yet acquired yet")
	return nil
end
function module_upvr._formatByKeyTestMode(arg1, arg2, arg3) -- Line 242
	local var56_upvw
	local any_GetTranslator_result1_upvr = arg1._localizationTable:GetTranslator("en")
	local pcall_result1_2, pcall_result2 = pcall(function() -- Line 246
		--[[ Upvalues[4]:
			[1]: var56_upvw (read and write)
			[2]: any_GetTranslator_result1_upvr (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
		]]
		var56_upvw = any_GetTranslator_result1_upvr:FormatByKey(arg2, arg3)
	end)
	if pcall_result1_2 and not pcall_result2 then
		return var56_upvw
	end
	for _, v_2 in pairs(arg1._fallbacks) do
		local any_FormatByKey_result1 = v_2:FormatByKey(arg2, arg3)
		if any_FormatByKey_result1 then
			return any_FormatByKey_result1
		end
	end
	if pcall_result2 then
		warn(pcall_result2)
	else
		warn("Failed to localize '"..arg2.."'")
	end
	return arg2
end
function module_upvr.Destroy(arg1) -- Line 273
	arg1._localizationTable:Destroy()
	arg1._localizationTable = nil
	arg1._englishTranslator = nil
	arg1._promiseTranslator = nil
	setmetatable(arg1, nil)
end
return module_upvr