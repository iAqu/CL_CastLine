-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:05
-- Luau version 6, Types version 3
-- Time taken: 0.002323 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("Maid")
local module_upvr = {
	ClassName = "InputKeyMapListProvider";
	ServiceName = "InputKeyMapListProvider";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2) -- Line 65
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._providerName = assert(arg1, "No providerName")
	setmetatable_result1.ServiceName = arg1
	setmetatable_result1._createDefaults = assert(arg2, "No createDefaults")
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("InputKeyMapRegistryServiceShared")
function module_upvr.Init(arg1, arg2) -- Line 75
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._maid = var1_result1_upvr.new()
	arg1:_ensureDefaultsInit()
	arg1._maid:GiveTask(arg1._serviceBag:GetService(any_load_result1_result1_upvr):RegisterProvider(arg1))
end
function module_upvr.Start(arg1) -- Line 87
end
function module_upvr.GetProviderName(arg1) -- Line 95
	return arg1._providerName
end
function module_upvr.GetInputKeyMapList(arg1, arg2) -- Line 106
	local any_FindInputKeyMapList_result1 = arg1:FindInputKeyMapList(arg2)
	if not any_FindInputKeyMapList_result1 then
		error("Bad keyMapListName %q":format(tostring(arg2)))
	end
	return any_FindInputKeyMapList_result1
end
local RunService_upvr = game:GetService("RunService")
function module_upvr.FindInputKeyMapList(arg1, arg2) -- Line 120
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local var8
	if type(arg2) ~= "string" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad keyMapListName")
	if RunService_upvr:IsRunning() and not arg1._inputKeyMapLists then
		var8 = "Not initialized, make sure to retrieve via serviceBag and init"
		error(var8)
	end
	if not arg1._inputKeyMapLists then
		var8 = var1_result1_upvr
		arg1._maid = var8.new()
	end
	arg1:_ensureDefaultsInit()
	var8 = arg1._inputKeyMapLists
	return var8[arg2]
end
function module_upvr.Add(arg1, arg2) -- Line 137
	assert(arg2, "Bad inputKeyMapList")
	assert(arg1._maid, "Not initialized")
	if arg1._inputKeyMapLists[arg2:GetListName()] then
		error("Already added %q":format(arg2:GetListName()))
	end
	arg1._inputKeyMapLists[arg2:GetListName()] = arg2
	arg1._maid:GiveTask(arg2)
	arg1._maid:GiveTask(arg1._inputMapLists:Add(arg2))
end
function module_upvr.ObserveInputKeyMapListsBrio(arg1) -- Line 151
	return arg1._inputMapLists:ObserveItemsBrio()
end
local any_load_result1_result1_upvr_2 = any_load_result1("ObservableList")
function module_upvr._ensureDefaultsInit(arg1) -- Line 155
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	if not arg1._inputKeyMapLists then
		arg1._inputMapLists = any_load_result1_result1_upvr_2.new()
		arg1._maid:GiveTask(arg1._inputMapLists)
		arg1._inputKeyMapLists = {}
		arg1._createDefaults(arg1, arg1._serviceBag)
	end
end
function module_upvr.Destroy(arg1) -- Line 166
	if arg1._maid then
		arg1._maid:DoCleaning()
		arg1._maid = nil
	end
	arg1._inputKeyMapLists = nil
end
return module_upvr