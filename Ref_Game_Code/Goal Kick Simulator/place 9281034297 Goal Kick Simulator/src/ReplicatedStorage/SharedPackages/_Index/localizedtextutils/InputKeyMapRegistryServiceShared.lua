-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:15
-- Luau version 6, Types version 3
-- Time taken: 0.004282 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {
	ServiceName = "InputKeyMapRegistryServiceShared";
}
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ObservableList")
function module.Init(arg1, arg2) -- Line 20
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._maid = var1_result1_upvr_2.new()
	arg1._providerLookupByName = {}
	arg1._providersList = var1_result1_upvr.new()
	arg1._maid:GiveTask(arg1._providersList)
	arg1._maid:GiveTask(arg1._providersList:ObserveItemsBrio():Subscribe(function(arg1_2) -- Line 30
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_2:IsDead() then
		else
			local any_GetValue_result1_upvr = arg1_2:GetValue()
			local any_GetProviderName_result1_upvr = any_GetValue_result1_upvr:GetProviderName()
			if arg1._providerLookupByName[any_GetProviderName_result1_upvr] then
				error("Already have a provider with name %q":format(any_GetProviderName_result1_upvr))
			end
			arg1._providerLookupByName[any_GetProviderName_result1_upvr] = any_GetValue_result1_upvr
			arg1_2:ToMaid():GiveTask(function() -- Line 46
				--[[ Upvalues[3]:
					[1]: arg1 (copied, readonly)
					[2]: any_GetProviderName_result1_upvr (readonly)
					[3]: any_GetValue_result1_upvr (readonly)
				]]
				if arg1._providerLookupByName[any_GetProviderName_result1_upvr] == any_GetValue_result1_upvr then
					arg1._providerLookupByName[any_GetProviderName_result1_upvr] = nil
				end
			end)
		end
	end))
end
function module.RegisterProvider(arg1, arg2) -- Line 54
	assert(arg2, "Bad provider")
	assert(arg1._providersList, "Not initialized")
	return arg1._providersList:Add(arg2)
end
function module.ObserveProvidersBrio(arg1) -- Line 61
	return arg1._providersList:ObserveItemsBrio()
end
local var1_result1_upvr_3 = any_load_result1("RxBrioUtils")
function module.ObserveInputKeyMapListsBrio(arg1) -- Line 65
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return arg1:ObserveProvidersBrio():Pipe({var1_result1_upvr_3.flatMapBrio(function(arg1_3) -- Line 67
		return arg1_3:ObserveInputKeyMapListsBrio()
	end)})
end
function module.GetProvider(arg1, arg2) -- Line 73
	local var12
	if type(arg2) ~= "string" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad providerName")
	var12 = arg1._providerLookupByName
	return var12[arg2]
end
local RunService_upvr = game:GetService("RunService")
function module.FindInputKeyMapList(arg1, arg2, arg3) -- Line 85
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local var27
	if type(arg2) ~= "string" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "Bad providerName")
	if type(arg3) ~= "string" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "Bad inputKeyMapListName")
	if not RunService_upvr:IsRunning() then
		return nil
	end
	var27 = arg1._providersList
	assert(var27, "Not initialized")
	var27 = arg1._providerLookupByName
	for _, v in pairs(var27) do
		if v:GetProviderName() == arg2 then
			local any_FindInputKeyMapList_result1_2 = v:FindInputKeyMapList(arg3)
			if any_FindInputKeyMapList_result1_2 then
				return any_FindInputKeyMapList_result1_2
			end
		end
	end
	return nil
end
function module.Destroy(arg1) -- Line 107
	arg1._maid:DoCleaning()
end
return module