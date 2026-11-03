-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:10
-- Luau version 6, Types version 3
-- Time taken: 0.009339 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("Observable")
local module_upvr = {
	ClassName = "ObservableMapSet";
}
module_upvr.__index = module_upvr
local any_load_result1_result1_upvr_3 = any_load_result1("Signal")
function module_upvr.new() -- Line 26
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = any_load_result1_result1_upvr_2.new()
	setmetatable_result1._observableSetMap = {}
	setmetatable_result1.SetAdded = any_load_result1_result1_upvr_3.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.SetAdded)
	setmetatable_result1.SetRemoved = any_load_result1_result1_upvr_3.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.SetRemoved)
	setmetatable_result1._setCount = Instance.new("IntValue")
	setmetatable_result1._setCount.Value = 0
	setmetatable_result1._maid:GiveTask(setmetatable_result1._setCount)
	return setmetatable_result1
end
function module_upvr.Add(arg1, arg2, arg3) -- Line 64
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_4_upvr = any_load_result1_result1_upvr_2.new()
	local var8_upvw
	any_new_result1_4_upvr:GiveTask(arg3:Subscribe(function(arg1_2) -- Line 75
		--[[ Upvalues[3]:
			[1]: var8_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		if var8_upvw then
			arg1:_removeFromObservableSet(var8_upvw, arg2)
		end
		var8_upvw = nil
		if arg1_2 then
			arg1:_addToObservableSet(arg1_2, arg2)
		end
		var8_upvw = arg1_2
	end))
	any_new_result1_4_upvr:GiveTask(function() -- Line 68, Named "removeLastEntry"
		--[[ Upvalues[3]:
			[1]: var8_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		if var8_upvw then
			arg1:_removeFromObservableSet(var8_upvw, arg2)
		end
		var8_upvw = nil
	end)
	arg1._maid[any_new_result1_4_upvr] = any_new_result1_4_upvr
	any_new_result1_4_upvr:GiveTask(function() -- Line 90
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_4_upvr (readonly)
		]]
		arg1._maid[any_new_result1_4_upvr] = nil
	end)
	return any_new_result1_4_upvr
end
function module_upvr.GetSetCount(arg1) -- Line 101
	return arg1._setCount.Value
end
local var1_result1_upvr = any_load_result1("RxValueBaseUtils")
function module_upvr.ObserveSetCount(arg1) -- Line 109
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.observeValue(arg1._setCount)
end
function module_upvr.ObserveItemsForKeyBrio(arg1, arg2) -- Line 118
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return any_load_result1_result1_upvr.new(function(arg1_3) -- Line 121
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local any_new_result1_3_upvr = any_load_result1_result1_upvr_2.new()
		local function connect() -- Line 124
			--[[ Upvalues[5]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: arg2 (copied, readonly)
				[4]: arg1_3 (readonly)
				[5]: any_new_result1_3_upvr (readonly)
			]]
			local any_new_result1 = any_load_result1_result1_upvr_2.new()
			local var15 = arg1._observableSetMap[arg2]
			if var15 then
				any_new_result1:GiveTask(var15:ObserveItemsBrio():Subscribe(function(arg1_4) -- Line 129
					--[[ Upvalues[1]:
						[1]: arg1_3 (copied, readonly)
					]]
					arg1_3:Fire(arg1_4)
				end))
			end
			any_new_result1_3_upvr._current = any_new_result1
		end
		any_new_result1_3_upvr:GiveTask(arg1.SetAdded:Connect(function(arg1_5) -- Line 137
			--[[ Upvalues[2]:
				[1]: arg2 (copied, readonly)
				[2]: connect (readonly)
			]]
			if arg1_5 == arg2 then
				connect()
			end
		end))
		any_new_result1_3_upvr:GiveTask(arg1.SetRemoved:Connect(function(arg1_6) -- Line 143
			--[[ Upvalues[2]:
				[1]: arg2 (copied, readonly)
				[2]: connect (readonly)
			]]
			if arg1_6 == arg2 then
				connect()
			end
		end))
		connect()
		return any_new_result1_3_upvr
	end)
end
function module_upvr.GetListForKey(arg1, arg2) -- Line 160
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	local var19 = arg1._observableSetMap[arg2]
	if not var19 then
		return {}
	end
	return var19:GetList()
end
function module_upvr.GetObservableSetForKey(arg1, arg2) -- Line 176
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return arg1._observableSetMap[arg2]
end
local any_load_result1_result1_upvr_4 = any_load_result1("Brio")
function module_upvr.ObserveSetBrio(arg1, arg2) -- Line 182
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return any_load_result1_result1_upvr.new(function(arg1_7) -- Line 185
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: any_load_result1_result1_upvr_4 (copied, readonly)
		]]
		local any_new_result1_2_upvr = any_load_result1_result1_upvr_2.new()
		local function _() -- Line 188, Named "connect"
			--[[ Upvalues[5]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: any_load_result1_result1_upvr_4 (copied, readonly)
				[4]: arg1_7 (readonly)
				[5]: any_new_result1_2_upvr (readonly)
			]]
			local var23
			local var24 = arg1._observableSetMap[arg2]
			if var24 then
				var23 = any_load_result1_result1_upvr_4.new(var24)
				arg1_7:Fire(var23)
			end
			any_new_result1_2_upvr._current = var23
		end
		any_new_result1_2_upvr:GiveTask(arg1.SetAdded:Connect(function(arg1_8) -- Line 200
			--[[ Upvalues[5]:
				[1]: arg2 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_load_result1_result1_upvr_4 (copied, readonly)
				[4]: arg1_7 (readonly)
				[5]: any_new_result1_2_upvr (readonly)
			]]
			if arg1_8 == arg2 then
				local var26
				local var27 = arg1._observableSetMap[arg2]
				if var27 then
					var26 = any_load_result1_result1_upvr_4.new(var27)
					arg1_7:Fire(var26)
				end
				any_new_result1_2_upvr._current = var26
			end
		end))
		any_new_result1_2_upvr:GiveTask(arg1.SetRemoved:Connect(function(arg1_9) -- Line 206
			--[[ Upvalues[5]:
				[1]: arg2 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_load_result1_result1_upvr_4 (copied, readonly)
				[4]: arg1_7 (readonly)
				[5]: any_new_result1_2_upvr (readonly)
			]]
			if arg1_9 == arg2 then
				local var29
				local var30 = arg1._observableSetMap[arg2]
				if var30 then
					var29 = any_load_result1_result1_upvr_4.new(var30)
					arg1_7:Fire(var29)
				end
				any_new_result1_2_upvr._current = var29
			end
		end))
		local var31
		local var32 = arg1._observableSetMap[arg2]
		if var32 then
			var31 = any_load_result1_result1_upvr_4.new(var32)
			arg1_7:Fire(var31)
		end
		any_new_result1_2_upvr._current = var31
		return any_new_result1_2_upvr
	end)
end
local var1_result1_upvr_2 = any_load_result1("RxBrioUtils")
function module_upvr.ObserveCountForKey(arg1, arg2) -- Line 218
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return arg1:ObserveSetBrio(arg2):Pipe({var1_result1_upvr_2.switchMapBrio(function(arg1_10) -- Line 222
		return arg1_10:ObserveCount()
	end), var1_result1_upvr_2.emitOnDeath(0)})
end
function module_upvr._addToObservableSet(arg1, arg2, arg3) -- Line 229
	arg1:_getOrCreateObservableSet(arg2):Add(arg3)
end
function module_upvr._removeFromObservableSet(arg1, arg2, arg3) -- Line 234
	local var37 = arg1._observableSetMap[arg2]
	if not var37 then
	else
		if not var37.Destroy then return end
		if var37:Contains(arg3) then
			var37:Remove(arg3)
			if var37:GetCount() == 0 then
				arg1:_removeObservableSet(arg2)
			end
		end
	end
end
function module_upvr._removeObservableSet(arg1, arg2) -- Line 253
	local var38 = arg1._observableSetMap[arg2]
	if var38 then
		arg1._observableSetMap[arg2] = nil
		arg1._maid[var38] = nil
		if arg1.SetRemoved.Destroy then
			arg1.SetRemoved:Fire(arg2)
		end
		arg1._setCount.Value = arg1._setCount.Value - 1
	end
end
local any_load_result1_result1_upvr_5 = any_load_result1("ObservableSet")
function module_upvr._getOrCreateObservableSet(arg1, arg2) -- Line 269
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
	]]
	if arg1._observableSetMap[arg2] then
		return arg1._observableSetMap[arg2]
	end
	local any_new_result1_6 = any_load_result1_result1_upvr_2.new()
	local any_new_result1_5 = any_load_result1_result1_upvr_5.new()
	any_new_result1_6:GiveTask(any_new_result1_5)
	arg1._observableSetMap[arg2] = any_new_result1_5
	arg1.SetAdded:Fire(arg2, any_new_result1_5)
	arg1._setCount.Value = arg1._setCount.Value + 1
	arg1._maid[any_new_result1_5] = any_new_result1_6
	return any_new_result1_5
end
function module_upvr.Destroy(arg1) -- Line 290
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr