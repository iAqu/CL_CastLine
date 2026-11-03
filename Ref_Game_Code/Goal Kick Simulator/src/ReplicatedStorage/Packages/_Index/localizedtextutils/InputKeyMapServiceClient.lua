-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:02
-- Luau version 6, Types version 3
-- Time taken: 0.001506 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local module = {
	ServiceName = "InputKeyMapServiceClient";
}
local var1_result1_upvr_2 = any_load_result1_upvr("Maid")
function module.Init(arg1, arg2) -- Line 13
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: any_load_result1_upvr (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._maid = var1_result1_upvr_2.new()
	arg1._serviceBag:GetService(any_load_result1_upvr("InputModeServiceClient"))
	arg1._translator = arg1._serviceBag:GetService(any_load_result1_upvr("InputKeyMapTranslator"))
	arg1._registryService = arg1._serviceBag:GetService(any_load_result1_upvr("InputKeyMapRegistryServiceShared"))
	arg1:_ensureLocalizationEntries()
end
function module.FindInputKeyMapList(arg1, arg2, arg3) -- Line 28
	return arg1._registryService:FindInputKeyMapList(arg2, arg3)
end
local var1_result1_upvr = any_load_result1_upvr("PseudoLocalize")
function module._ensureLocalizationEntries(arg1) -- Line 32
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	arg1._maid:GiveTask(arg1._registryService:ObserveInputKeyMapListsBrio():Subscribe(function(arg1_2) -- Line 33
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		if arg1_2:IsDead() then
		else
			local any_GetValue_result1 = arg1_2:GetValue()
			local any_GetBindingName_result1 = any_GetValue_result1:GetBindingName()
			local any_GetLocalizationTable_result1 = arg1._translator:GetLocalizationTable()
			local any_GetBindingTranslationKey_result1 = any_GetValue_result1:GetBindingTranslationKey()
			local formatted = "InputKeyMapServiceClient.%s":format(any_GetValue_result1:GetListName())
			any_GetLocalizationTable_result1:SetEntryValue(any_GetBindingTranslationKey_result1, any_GetBindingName_result1, formatted, "en", any_GetBindingName_result1)
			any_GetLocalizationTable_result1:SetEntryValue(any_GetBindingTranslationKey_result1, any_GetBindingName_result1, formatted, var1_result1_upvr.getDefaultPseudoLocaleId(), var1_result1_upvr.pseudoLocalize(any_GetBindingName_result1))
		end
	end))
end
function module.Destroy(arg1) -- Line 56
	arg1._maid:DoCleaning()
end
return module