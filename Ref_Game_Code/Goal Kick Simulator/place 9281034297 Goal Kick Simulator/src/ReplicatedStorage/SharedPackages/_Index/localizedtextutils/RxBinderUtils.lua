-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:48
-- Luau version 6, Types version 3
-- Time taken: 0.006160 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_6 = any_load_result1("Binder")
local var1_result1_upvr_3 = any_load_result1("Brio")
local var1_result1_upvr = any_load_result1("Maid")
local var1_result1_upvr_4 = any_load_result1("Observable")
local var1_result1_upvr_5 = any_load_result1("Rx")
local var1_result1_upvr_8 = any_load_result1("RxBrioUtils")
local var1_result1_upvr_7 = any_load_result1("RxInstanceUtils")
local module_upvr = {}
local var1_result1_upvr_2 = any_load_result1("RxLinkUtils")
function module_upvr.observeLinkedBoundClassBrio(arg1, arg2, arg3) -- Line 35
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_8 (readonly)
		[4]: module_upvr (readonly)
	]]
	local var11
	if type(arg1) ~= "string" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad linkName")
	if typeof(arg2) ~= "Instance" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad parent")
	var11 = var1_result1_upvr_6.isBinder(arg3)
	assert(var11, "Bad binder")
	var11 = var1_result1_upvr_2
	var11 = arg1
	return var11.observeValidLinksBrio(var11, arg2):Pipe({var1_result1_upvr_8.flatMapBrio(function(arg1_2, arg2_2) -- Line 42
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: arg3 (readonly)
		]]
		return module_upvr.observeBoundClassBrio(arg3, arg2_2)
	end)})
end
function module_upvr.observeBoundChildClassBrio(arg1, arg2) -- Line 55
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
		[3]: var1_result1_upvr_8 (readonly)
		[4]: module_upvr (readonly)
	]]
	local any_isBinder_result1_3 = var1_result1_upvr_6.isBinder(arg1)
	assert(any_isBinder_result1_3, "Bad binder")
	if typeof(arg2) ~= "Instance" then
		any_isBinder_result1_3 = false
	else
		any_isBinder_result1_3 = true
	end
	assert(any_isBinder_result1_3, "Bad instance")
	return var1_result1_upvr_7.observeChildrenBrio(arg2):Pipe({var1_result1_upvr_8.flatMapBrio(function(arg1_3) -- Line 61
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return module_upvr.observeBoundClassBrio(arg1, arg1_3)
	end)})
end
function module_upvr.observeBoundParentClassBrio(arg1, arg2) -- Line 74
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
		[3]: var1_result1_upvr_8 (readonly)
		[4]: module_upvr (readonly)
		[5]: var1_result1_upvr_5 (readonly)
	]]
	local any_isBinder_result1_4 = var1_result1_upvr_6.isBinder(arg1)
	assert(any_isBinder_result1_4, "Bad binder")
	if typeof(arg2) ~= "Instance" then
		any_isBinder_result1_4 = false
	else
		any_isBinder_result1_4 = true
	end
	assert(any_isBinder_result1_4, "Bad instance")
	return var1_result1_upvr_7.observePropertyBrio(arg2, "Parent"):Pipe({var1_result1_upvr_8.switchMapBrio(function(arg1_4) -- Line 80
		--[[ Upvalues[3]:
			[1]: module_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var1_result1_upvr_5 (copied, readonly)
		]]
		if arg1_4 then
			return module_upvr.observeBoundClassBrio(arg1, arg1_4)
		end
		return var1_result1_upvr_5.EMPTY
	end), var1_result1_upvr_8.onlyLastBrioSurvives()})
end
function module_upvr.observeBoundChildClassesBrio(arg1, arg2) -- Line 98
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr_8 (readonly)
		[3]: module_upvr (readonly)
	]]
	local var20
	if type(arg1) ~= "table" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Bad binders")
	if typeof(arg2) ~= "Instance" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Bad instance")
	var20 = var1_result1_upvr_7
	var20 = arg2
	return var20.observeChildrenBrio(var20):Pipe({var1_result1_upvr_8.flatMapBrio(function(arg1_5) -- Line 104
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return module_upvr.observeBoundClassesBrio(arg1, arg1_5)
	end)})
end
function module_upvr.observeBoundClass(arg1, arg2) -- Line 117
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local any_isBinder_result1 = var1_result1_upvr_6.isBinder(arg1)
	assert(any_isBinder_result1, "Bad binder")
	if typeof(arg2) ~= "Instance" then
		any_isBinder_result1 = false
	else
		any_isBinder_result1 = true
	end
	assert(any_isBinder_result1, "Bad instance")
	return var1_result1_upvr_4.new(function(arg1_6) -- Line 121
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local any_new_result1_4 = var1_result1_upvr.new()
		any_new_result1_4:GiveTask(arg1:ObserveInstance(arg2, function(...) -- Line 124
			--[[ Upvalues[1]:
				[1]: arg1_6 (readonly)
			]]
			arg1_6:Fire(...)
		end))
		arg1_6:Fire(arg1:Get(arg2))
		return any_new_result1_4
	end)
end
function module_upvr.observeBoundClassBrio(arg1, arg2) -- Line 140
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
	]]
	local any_isBinder_result1_2 = var1_result1_upvr_6.isBinder(arg1)
	assert(any_isBinder_result1_2, "Bad binder")
	if typeof(arg2) ~= "Instance" then
		any_isBinder_result1_2 = false
	else
		any_isBinder_result1_2 = true
	end
	assert(any_isBinder_result1_2, "Bad instance")
	return var1_result1_upvr_4.new(function(arg1_7) -- Line 144
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg2 (readonly)
		]]
		local any_new_result1_3_upvr = var1_result1_upvr.new()
		any_new_result1_3_upvr:GiveTask(arg1:ObserveInstance(arg2, function(arg1_8) -- Line 147, Named "handleClassChanged"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: any_new_result1_3_upvr (readonly)
				[3]: arg1_7 (readonly)
			]]
			if arg1_8 then
				local any_new_result1_6 = var1_result1_upvr_3.new(arg1_8)
				any_new_result1_3_upvr._lastBrio = any_new_result1_6
				arg1_7:Fire(any_new_result1_6)
			else
				any_new_result1_3_upvr._lastBrio = nil
			end
		end))
		local any_Get_result1 = arg1:Get(arg2)
		if any_Get_result1 then
			local any_new_result1_7 = var1_result1_upvr_3.new(any_Get_result1)
			any_new_result1_3_upvr._lastBrio = any_new_result1_7
			arg1_7:Fire(any_new_result1_7)
			return any_new_result1_3_upvr
		end
		any_new_result1_3_upvr._lastBrio = nil
		return any_new_result1_3_upvr
	end)
end
function module_upvr.observeBoundClassesBrio(arg1, arg2) -- Line 172
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var41
	if type(arg1) ~= "table" then
		var41 = false
	else
		var41 = true
	end
	assert(var41, "Bad binders")
	if typeof(arg2) ~= "Instance" then
		var41 = false
	else
		var41 = true
	end
	assert(var41, "Bad instance")
	var41 = pairs(arg1)
	local pairs_result1_2, pairs_result2_2, pairs_result3 = pairs(arg1)
	for _, v in pairs_result1_2, pairs_result2_2, pairs_result3 do
		table.insert({}, module_upvr.observeBoundClassBrio(v, arg2))
		local var46
	end
	pairs_result1_2 = var1_result1_upvr_5.of(unpack(var46))
	pairs_result1_2 = pairs_result1_2:Pipe({var1_result1_upvr_5.mergeAll()})
	return pairs_result1_2
end
function module_upvr.observeAllBrio(arg1) -- Line 193
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
	]]
	assert(var1_result1_upvr_6.isBinder(arg1), "Bad binder")
	return var1_result1_upvr_4.new(function(arg1_9) -- Line 196
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_2_upvr = var1_result1_upvr.new()
		any_new_result1_2_upvr:GiveTask(arg1:GetClassAddedSignal():Connect(function(arg1_10) -- Line 199, Named "handleNewClass"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: any_new_result1_2_upvr (readonly)
				[3]: arg1_9 (readonly)
			]]
			local any_new_result1_5 = var1_result1_upvr_3.new(arg1_10)
			any_new_result1_2_upvr[arg1_10] = any_new_result1_5
			arg1_9:Fire(any_new_result1_5)
		end))
		any_new_result1_2_upvr:GiveTask(arg1:GetClassRemovingSignal():Connect(function(arg1_11) -- Line 207
			--[[ Upvalues[1]:
				[1]: any_new_result1_2_upvr (readonly)
			]]
			any_new_result1_2_upvr[arg1_11] = nil
		end))
		for i_2, _ in pairs(arg1:GetAllSet()) do
			local any_new_result1 = var1_result1_upvr_3.new(i_2)
			any_new_result1_2_upvr[i_2] = any_new_result1
			arg1_9:Fire(any_new_result1)
		end
		return any_new_result1_2_upvr
	end)
end
return module_upvr