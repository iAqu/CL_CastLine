-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:46
-- Luau version 6, Types version 3
-- Time taken: 0.002154 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("InputKeyMapList")
local var1_result1_upvr_4 = any_load_result1("Rx")
local var1_result1_upvr_2 = any_load_result1("ServiceBag")
local module_upvr = {}
local var1_result1_upvr_5 = any_load_result1("InputModeTypeSelector")
function module_upvr.getNewInputModeTypeSelector(arg1, arg2) -- Line 25
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_5 (readonly)
	]]
	assert(var1_result1_upvr_3.isInputKeyMapList(arg1), "Bad inputKeyMapList")
	assert(var1_result1_upvr_2.isServiceBag(arg2), "Bad serviceBag")
	return var1_result1_upvr_5.fromObservableBrio(arg2, arg1:ObserveInputModesTypesBrio())
end
function module_upvr.observeActiveInputKeyMap(arg1, arg2) -- Line 39
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: module_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	assert(var1_result1_upvr_3.isInputKeyMapList(arg1), "Bad inputKeyMapList")
	assert(var1_result1_upvr_2.isServiceBag(arg2), "Bad serviceBag")
	return module_upvr.observeActiveInputModeType(arg1, arg2):Pipe({var1_result1_upvr_4.switchMap(function(arg1_2) -- Line 44
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
		]]
		if arg1_2 then
			return arg1:ObserveInputKeyMapForInputMode(arg1_2)
		end
		return var1_result1_upvr_4.of(nil)
	end)})
end
function module_upvr.observeActiveInputTypesList(arg1, arg2) -- Line 66
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: module_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	assert(var1_result1_upvr_3.isInputKeyMapList(arg1), "Bad inputKeyMapList")
	assert(var1_result1_upvr_2.isServiceBag(arg2), "Bad serviceBag")
	return module_upvr.observeActiveInputKeyMap(arg1, arg2):Pipe({var1_result1_upvr_4.switchMap(function(arg1_3) -- Line 71
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr_4 (copied, readonly)
		]]
		if arg1_3 then
			return arg1_3:ObserveInputTypesList()
		end
		return var1_result1_upvr_4.of(nil)
	end), var1_result1_upvr_4.distinct()})
end
local var1_result1_upvr = any_load_result1("Observable")
local var1_result1_upvr_6 = any_load_result1("Maid")
function module_upvr.observeActiveInputModeType(arg1, arg2) -- Line 89
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_6 (readonly)
		[5]: module_upvr (readonly)
	]]
	assert(var1_result1_upvr_3.isInputKeyMapList(arg1), "Bad inputKeyMapList")
	assert(var1_result1_upvr_2.isServiceBag(arg2), "Bad serviceBag")
	return var1_result1_upvr.new(function(arg1_4) -- Line 93
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_6 (copied, readonly)
			[2]: module_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg2 (readonly)
		]]
		local any_new_result1 = var1_result1_upvr_6.new()
		local any_getNewInputModeTypeSelector_result1_upvr = module_upvr.getNewInputModeTypeSelector(arg1, arg2)
		any_new_result1:GiveTask(any_getNewInputModeTypeSelector_result1_upvr)
		any_new_result1:GiveTask(any_getNewInputModeTypeSelector_result1_upvr.Changed:Connect(function() -- Line 99
			--[[ Upvalues[2]:
				[1]: arg1_4 (readonly)
				[2]: any_getNewInputModeTypeSelector_result1_upvr (readonly)
			]]
			arg1_4:Fire(any_getNewInputModeTypeSelector_result1_upvr.Value)
		end))
		arg1_4:Fire(any_getNewInputModeTypeSelector_result1_upvr.Value)
		return any_new_result1
	end)
end
return module_upvr