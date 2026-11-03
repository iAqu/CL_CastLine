-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:16
-- Luau version 6, Types version 3
-- Time taken: 0.002222 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogTranslator")
local any_load_result1_result1_upvr_2 = any_load_result1("DialogEntityUtils")
local var1_result1_upvr = any_load_result1("LocalizedTextUtils")
local module_upvr = {}
local any_load_result1_result1_upvr_3 = any_load_result1("DialogEntityTypes")
function module_upvr.replaceWithLocalizedText(arg1, arg2) -- Line 16
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2, "No context")
	for i, v in pairs(arg2) do
		if v.type == any_load_result1_result1_upvr_3.LOCALIZED_ENTITY then
			({})[i] = module_upvr.createEntityFromLocalizedEntity(arg1, v)
		elseif v.type == any_load_result1_result1_upvr_3.LOCALIZED_INPUT_HINT then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i] = module_upvr.createInputHintFromLocalizedInputHint(arg1, v)
		elseif v.type == any_load_result1_result1_upvr_3.LOCALIZED_TALKER_ENTITY then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i] = module_upvr.createTalkerEntityFromLocalizedEntity(arg1, v)
		elseif v.type == any_load_result1_result1_upvr_3.LOCALIZED_CURRENCY_AMOUNT then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i] = module_upvr.createCurrencyFromLocalizedEntity(arg1, v)
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i] = v
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
local any_load_result1_result1_upvr_4 = any_load_result1("NumberLocalizationUtils")
function module_upvr.createCurrencyFromLocalizedEntity(arg1, arg2) -- Line 39
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2.amount, "Bad amount")
	assert(arg2.formatKey, "Bad formatKey")
	assert(arg2.textColor3, "Bad textColor3")
	local service = arg1:GetService(var1_result1_upvr_2)
	return any_load_result1_result1_upvr_2.createEntity(service:FormatByKey(arg2.formatKey, {
		amount = any_load_result1_result1_upvr_4.localize(arg2.amount, service:GetLocaleId());
	}), arg2.textColor3)
end
function module_upvr.createTalkerEntityFromLocalizedEntity(arg1, arg2) -- Line 55
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2.textColor3, "Bad textColor3")
	assert(arg2.translationKey, "Bad translationKey")
	assert(arg2.voicePitchAdjustment, "Bad voicePitchAdjustment")
	assert(arg2.translationArgs, "Bad translationArgs")
	return any_load_result1_result1_upvr_2.createTalkerEntity(var1_result1_upvr.formatByKeyRecursive(arg1:GetService(var1_result1_upvr_2), arg2.translationKey, arg2.translationArgs), arg2.textColor3, arg2.voicePitchAdjustment)
end
function module_upvr.createEntityFromLocalizedEntity(arg1, arg2) -- Line 71
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2.textColor3, "Bad textColor3")
	assert(arg2.translationKey, "Bad translationKey")
	assert(arg2.translationArgs, "Bad translationArgs")
	return any_load_result1_result1_upvr_2.createEntity(var1_result1_upvr.formatByKeyRecursive(arg1:GetService(var1_result1_upvr_2), arg2.translationKey, arg2.translationArgs), arg2.textColor3)
end
local any_load_result1_result1_upvr = any_load_result1("InputKeyMapRegistryServiceShared")
function module_upvr.createInputHintFromLocalizedInputHint(arg1, arg2) -- Line 85
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2.inputKeyMapListProviderName, "Bad localizedInputHint.inputKeyMapListProviderName")
	assert(arg2.inputKeyMapListName, "Bad inputKeyMapListName")
	local any_FindInputKeyMapList_result1 = arg1:GetService(any_load_result1_result1_upvr):FindInputKeyMapList(arg2.inputKeyMapListProviderName, arg2.inputKeyMapListName)
	if any_FindInputKeyMapList_result1 then
		return any_load_result1_result1_upvr_2.createInputHint(any_FindInputKeyMapList_result1)
	end
	return nil
end
return module_upvr