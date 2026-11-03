-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:30
-- Luau version 6, Types version 3
-- Time taken: 0.005956 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_5 = any_load_result1("Observable")
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("Brio")
local module_2_upvr = {
	ClassName = "ObservableMap";
}
module_2_upvr.__index = module_2_upvr
local var1_result1_upvr_4 = any_load_result1("Signal")
function module_2_upvr.new() -- Line 22
	--[[ Upvalues[3]:
		[1]: module_2_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_2_upvr)
	setmetatable_result1._maid = var1_result1_upvr_2.new()
	setmetatable_result1._map = {}
	setmetatable_result1._keyToSubList = {}
	setmetatable_result1._countValue = Instance.new("IntValue")
	setmetatable_result1._countValue.Value = 0
	setmetatable_result1._maid:GiveTask(setmetatable_result1._countValue)
	setmetatable_result1.KeyAdded = var1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.KeyAdded)
	setmetatable_result1.KeyRemoved = var1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.KeyRemoved)
	setmetatable_result1.KeyValueChanged = var1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.KeyValueChanged)
	setmetatable_result1.CountChanged = setmetatable_result1._countValue.Changed
	return setmetatable_result1
end
function module_2_upvr.isObservableMap(arg1) -- Line 76
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var8 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_2_upvr then
			var8 = false
		else
			var8 = true
		end
	end
	return var8
end
function module_2_upvr.ObserveKeysBrio(arg1) -- Line 84
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return arg1:_observeKeyValueChanged(function(arg1_2, arg2) -- Line 85
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (copied, readonly)
		]]
		return var1_result1_upvr.new(arg1_2)
	end)
end
function module_2_upvr.ObserveValuesBrio(arg1) -- Line 94
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return arg1:_observeKeyValueChanged(function(arg1_3, arg2) -- Line 95
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (copied, readonly)
		]]
		return var1_result1_upvr.new(arg2)
	end)
end
function module_2_upvr.ObservePairsBrio(arg1) -- Line 104
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return arg1:_observeKeyValueChanged(function(arg1_4, arg2) -- Line 105
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (copied, readonly)
		]]
		return var1_result1_upvr.new(arg1_4, arg2)
	end)
end
function module_2_upvr._observeKeyValueChanged(arg1, arg2) -- Line 110
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_5.new(function(arg1_5) -- Line 111
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr_2.new()
		for i, v in pairs(arg1._map) do
			if v ~= nil then
				local arg2_result1_2 = arg2(i, v)
				any_new_result1_upvr[i] = arg2_result1_2
				arg1_5:Fire(arg2_result1_2)
			else
				any_new_result1_upvr[i] = nil
			end
		end
		any_new_result1_upvr:GiveTask(arg1.KeyValueChanged:Connect(function(arg1_6, arg2_2) -- Line 114, Named "handleValue"
			--[[ Upvalues[3]:
				[1]: arg2 (copied, readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: arg1_5 (readonly)
			]]
			if arg2_2 ~= nil then
				local arg2_result1 = arg2(arg1_6, arg2_2)
				any_new_result1_upvr[arg1_6] = arg2_result1
				arg1_5:Fire(arg2_result1)
			else
				any_new_result1_upvr[arg1_6] = nil
			end
		end))
		arg1._maid[arg1_5] = any_new_result1_upvr
		any_new_result1_upvr:GiveTask(function() -- Line 131
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_5 (readonly)
			]]
			arg1._maid[arg1_5] = nil
			arg1_5:Complete()
		end)
		return any_new_result1_upvr
	end)
end
function module_2_upvr.Get(arg1, arg2) -- Line 145
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return arg1._map[arg2]
end
function module_2_upvr.ContainsKey(arg1, arg2) -- Line 156
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	if arg1._map[arg2] == nil then
	else
	end
	return true
end
function module_2_upvr.GetCount(arg1) -- Line 166
	return arg1._countValue.Value
end
local var1_result1_upvr_3 = any_load_result1("RxValueBaseUtils")
function module_2_upvr.ObserveCount(arg1) -- Line 174
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.observeValue(arg1._countValue)
end
function module_2_upvr.ObserveValueForKey(arg1, arg2) -- Line 183
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return var1_result1_upvr_5.new(function(arg1_7) -- Line 186
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local any_new_result1 = var1_result1_upvr_2.new()
		if not arg1._keyToSubList[arg2] then
			arg1._keyToSubList[arg2] = {}
		end
		table.insert(arg1._keyToSubList[arg2], arg1_7)
		any_new_result1:GiveTask(function() -- Line 194
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: arg1_7 (readonly)
			]]
			local var26 = arg1._keyToSubList[arg2]
			if var26 then
				local table_find_result1 = table.find(var26, arg1_7)
				if table_find_result1 then
					table.remove(var26, table_find_result1)
				end
				if #var26 == 0 then
					arg1._keyToSubList[arg2] = nil
				end
			end
		end)
		arg1_7:Fire(arg1._map[arg2])
		return any_new_result1
	end)
end
function module_2_upvr.Set(arg1, arg2, arg3) -- Line 221
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	local var32 = arg1._map[arg2]
	if var32 == arg3 then return end
	arg1._map[arg2] = arg3
	if var32 == nil then
		arg1._countValue.Value = arg1._countValue.Value + 1
		arg1.KeyAdded:Fire(arg2, arg3)
	elseif arg3 == nil then
		arg1._countValue.Value = arg1._countValue.Value - 1
		arg1.KeyRemoved:Fire(arg2)
	end
	arg1.KeyValueChanged:Fire(arg2, arg3, var32)
	local var33 = arg1._keyToSubList[arg2]
	if var33 then
		for _, v_2_upvr in pairs(table.clone(var33)) do
			if v_2_upvr and v_2_upvr:IsPending() then
				task.spawn(function() -- Line 245
					--[[ Upvalues[2]:
						[1]: v_2_upvr (readonly)
						[2]: arg3 (readonly)
					]]
					v_2_upvr:Fire(arg3)
				end)
			end
		end
	end
	return function() -- Line 252
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		if arg1.Destroy then
			arg1:Remove(arg2)
		end
	end
end
function module_2_upvr.Remove(arg1, arg2) -- Line 263
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	arg1:Set(arg2, nil)
end
function module_2_upvr.GetValueList(arg1) -- Line 273
	local module_3 = {}
	for _, v_3 in pairs(arg1._map) do
		table.insert(module_3, v_3)
	end
	return module_3
end
function module_2_upvr.GetKeyList(arg1) -- Line 285
	local module = {}
	for i_4, _ in pairs(arg1._map) do
		table.insert(module, i_4)
	end
	return module
end
function module_2_upvr.Destroy(arg1) -- Line 297
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_2_upvr