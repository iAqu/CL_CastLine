-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:59
-- Luau version 6, Types version 3
-- Time taken: 0.012115 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Observable")
local var1_result1_upvr_3 = any_load_result1("Maid")
local function defaultCompare_upvr(arg1, arg2) -- Line 24, Named "defaultCompare"
	if arg1 >= arg2 then
	else
	end
	return true
end
local module_upvr = {
	ClassName = "ObservableSortedList";
}
module_upvr.__index = module_upvr
local var1_result1_upvr_4 = any_load_result1("Signal")
function module_upvr.new(arg1) -- Line 37
	--[[ Upvalues[4]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: defaultCompare_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var1_result1_upvr_3.new()
	setmetatable_result1._keyList = {}
	setmetatable_result1._sortValue = {}
	setmetatable_result1._contents = {}
	setmetatable_result1._indexes = {}
	setmetatable_result1._keyObservables = {}
	local var7 = arg1
	if not var7 then
		var7 = defaultCompare_upvr
	end
	setmetatable_result1._compare = var7
	setmetatable_result1._countValue = Instance.new("IntValue")
	setmetatable_result1._countValue.Value = 0
	setmetatable_result1._maid:GiveTask(setmetatable_result1._countValue)
	setmetatable_result1.ItemAdded = var1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ItemAdded)
	setmetatable_result1.ItemRemoved = var1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ItemRemoved)
	setmetatable_result1.CountChanged = setmetatable_result1._countValue.Changed
	return setmetatable_result1
end
function module_upvr.isObservableSortedList(arg1) -- Line 88
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var8 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_upvr then
			var8 = false
		else
			var8 = true
		end
	end
	return var8
end
local var1_result1_upvr = any_load_result1("Brio")
function module_upvr.ObserveItemsBrio(arg1) -- Line 96
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr_2.new(function(arg1_2) -- Line 97
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_5_upvr = var1_result1_upvr_3.new()
		for _, v in pairs(arg1._keyList) do
			local any_new_result1_2 = var1_result1_upvr.new(arg1._contents[v], v)
			any_new_result1_5_upvr[v] = any_new_result1_2
			arg1_2:Fire(any_new_result1_2)
		end
		any_new_result1_5_upvr:GiveTask(arg1.ItemAdded:Connect(function(arg1_3, arg2, arg3) -- Line 100, Named "handleItem"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr (copied, readonly)
				[2]: any_new_result1_5_upvr (readonly)
				[3]: arg1_2 (readonly)
			]]
			local any_new_result1 = var1_result1_upvr.new(arg1_3, arg3)
			any_new_result1_5_upvr[arg3] = any_new_result1
			arg1_2:Fire(any_new_result1)
		end))
		any_new_result1_5_upvr:GiveTask(arg1.ItemRemoved:Connect(function(arg1_4, arg2) -- Line 111
			--[[ Upvalues[1]:
				[1]: any_new_result1_5_upvr (readonly)
			]]
			any_new_result1_5_upvr[arg2] = nil
		end))
		arg1._maid[arg1_2] = any_new_result1_5_upvr
		any_new_result1_5_upvr:GiveTask(function() -- Line 116
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_2 (readonly)
			]]
			arg1._maid[arg1_2] = nil
			arg1_2:Complete()
		end)
		return any_new_result1_5_upvr
	end)
end
function module_upvr.ObserveIndex(arg1, arg2) -- Line 132
	local var23
	if type(arg2) ~= "number" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad indexToObserve")
	var23 = arg1._keyList
	local var24 = var23[arg2]
	if not var24 then
		var23 = error
		var23("No entry at index %q, cannot observe changes":format(arg2))
	end
	var23 = arg1:ObserveIndexByKey(var24)
	return var23
end
function module_upvr.ObserveIndexByKey(arg1, arg2) -- Line 150
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	local var26
	if type(arg2) ~= "userdata" then
		var26 = false
	else
		var26 = true
	end
	assert(var26, "Bad key")
	var26 = var1_result1_upvr_2
	function var26(arg1_5) -- Line 153
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local any_new_result1_4 = var1_result1_upvr_3.new()
		local var28 = arg1._keyObservables[arg2]
		if not var28 then
			var28 = {}
		end
		arg1._keyObservables[arg2] = var28
		table.insert(arg1._keyObservables[arg2], arg1_5)
		local var29 = arg1._indexes[arg2]
		if var29 then
			arg1_5:Fire(var29)
		end
		any_new_result1_4:GiveTask(function() -- Line 163
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: arg1_5 (readonly)
			]]
			local var33 = arg1._keyObservables[arg2]
			if not var33 then
			else
				local table_find_result1 = table.find(var33, arg1_5)
				if table_find_result1 then
					table.remove(var33, table_find_result1)
					if #var33 == 0 then
						arg1._keyObservables[arg2] = nil
					end
				end
			end
		end)
		return any_new_result1_4
	end
	return var26.new(var26)
end
function module_upvr.GetIndexByKey(arg1, arg2) -- Line 188
	local var35 = arg1._indexes[arg2]
	if var35 then
		return var35
	end
	return nil
end
function module_upvr.GetCount(arg1) -- Line 201
	return arg1._countValue.Value
end
function module_upvr.GetList(arg1) -- Line 209
	local module = {}
	for _, v_2 in pairs(arg1._keyList) do
		table.insert(module, arg1._contents[v_2])
	end
	return module
end
local var1_result1_upvr_5 = any_load_result1("RxValueBaseUtils")
function module_upvr.ObserveCount(arg1) -- Line 221
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	return var1_result1_upvr_5.observeValue(arg1._countValue)
end
local any_load_result1_result1_upvr = any_load_result1("Symbol")
function module_upvr.Add(arg1, arg2, arg3) -- Line 231
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
	]]
	if arg2 == nil then
	else
	end
	assert(true, "Bad item")
	assert(var1_result1_upvr_2.isObservable(arg3), "Bad observeValue")
	local any_named_result1_upvr = any_load_result1_result1_upvr.named("entryKey")
	local any_new_result1_3 = var1_result1_upvr_3.new()
	arg1._contents[any_named_result1_upvr] = arg2
	any_new_result1_3:GiveTask(arg3:Subscribe(function(arg1_6) -- Line 240
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_named_result1_upvr (readonly)
			[3]: arg2 (readonly)
		]]
		arg1._sortValue[any_named_result1_upvr] = arg1_6
		if arg1_6 ~= nil then
			arg1:_updateIndex(any_named_result1_upvr, arg2, arg1:_findCorrectIndex(arg1_6, arg1._indexes[any_named_result1_upvr]))
		else
			local var49 = arg1._keyObservables[any_named_result1_upvr]
			arg1:_removeItemByKey(any_named_result1_upvr, arg2)
			if var49 then
				arg1:_fireSubs(var49, nil)
			end
		end
	end))
	any_new_result1_3:GiveTask(function() -- Line 260
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_named_result1_upvr (readonly)
			[3]: arg2 (readonly)
		]]
		local var51 = arg1._keyObservables[any_named_result1_upvr]
		arg1._keyObservables[any_named_result1_upvr] = nil
		arg1:_removeItemByKey(any_named_result1_upvr, arg2)
		if var51 then
			arg1:_completeSubs(var51)
		end
		arg1._contents[any_named_result1_upvr] = nil
		arg1._sortValue[any_named_result1_upvr] = nil
	end)
	arg1._maid[any_named_result1_upvr] = any_new_result1_3
	return function() -- Line 277
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_named_result1_upvr (readonly)
		]]
		arg1._maid[any_named_result1_upvr] = nil
	end
end
function module_upvr.Get(arg1, arg2) -- Line 287
	local var53
	if type(arg2) ~= "number" then
		var53 = false
	else
		var53 = true
	end
	assert(var53, "Bad index")
	var53 = arg1._keyList
	local var54 = var53[arg2]
	if not var54 then
		var53 = nil
		return var53
	end
	var53 = arg1._contents[var54]
	return var53
end
function module_upvr.RemoveByKey(arg1, arg2) -- Line 303
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	arg1._maid[arg2] = nil
end
function module_upvr._updateIndex(arg1, arg2, arg3, arg4) -- Line 309
	if arg3 == nil then
	else
	end
	assert(true, "Bad item")
	if type(arg4) ~= "number" then
	else
	end
	assert(true, "Bad index")
	local var61 = arg1._indexes[arg2]
	if var61 == arg4 then
	else
		arg1._indexes[arg2] = arg4
		if not var61 then
			for i_10 = #arg1._keyList, arg4, -1 do
				local var63 = arg1._keyList[i_10]
				arg1._indexes[var63] = i_10 + 1
				arg1._keyList[i_10 + 1] = var63
				table.insert({}, {
					key = var63;
					newIndex = i_10 + 1;
				})
				local var65
			end
		elseif var61 < arg4 then
			for i_12 = var61 + 1, arg4 do
				i_10 = arg1._keyList[i_12]
				local var66 = i_10
				arg1._indexes[var66] = i_12 - 1
				arg1._keyList[i_12 - 1] = var66
				table.insert(var65, {
					key = var66;
					newIndex = i_12 - 1;
				})
				local var68
			end
		else
			i_12 = var61 - 1
			for i_13 = i_12, arg4, -1 do
				var66 = arg1._keyList[i_13]
				local var69 = var66
				arg1._indexes[var69] = i_13 + 1
				arg1._keyList[i_13 + 1] = var69
				table.insert(var68, {
					key = var69;
					newIndex = i_13 + 1;
				})
				local var71
			end
		end
		local tbl_2 = {}
		tbl_2.key = arg2
		tbl_2.newIndex = arg4
		tbl_2.item = arg3
		i_13 = var71
		table.insert(i_13, tbl_2)
		arg1._keyList[arg4] = arg2
		if var61 == nil then
			arg1:_deferChange(1, tbl_2, nil, var71)
			return
		end
		arg1:_deferChange(0, nil, nil, var71)
	end
end
function module_upvr._removeItemByKey(arg1, arg2, arg3) -- Line 382
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	local var75 = arg1._indexes[arg2]
	if not var75 then
	else
		arg1._indexes[arg2] = nil
		arg1._sortValue[arg2] = nil
		local len = #arg1._keyList
		for i_11 = var75, len - 1 do
			local var78 = arg1._keyList[i_11 + 1]
			arg1._indexes[var78] = i_11
			arg1._keyList[i_11] = var78
			table.insert({}, {
				key = var78;
				newIndex = i_11;
			})
			local var80
		end
		arg1._keyList[len] = nil
		local tbl = {}
		tbl.key = arg2
		tbl.item = arg3
		arg1:_deferChange(-1, nil, tbl, var80)
	end
end
function module_upvr._deferChange(arg1, arg2, arg3, arg4, arg5) -- Line 420
	arg1:_queueDeferredChange()
	if arg3 then
		arg1._deferredChange.itemsRemoved[arg3.key] = nil
		arg1._deferredChange.itemsAdded[arg3.key] = arg3
	end
	if arg4 then
		arg1._deferredChange.itemsAdded[arg4.key] = nil
		arg1._deferredChange.itemsRemoved[arg4.key] = arg4
	end
	local _deferredChange = arg1._deferredChange
	_deferredChange.countChange += arg2
	for _, v_3 in pairs(arg5) do
		arg1._deferredChange.indexChanges[v_3.key] = v_3
	end
end
function module_upvr._queueDeferredChange(arg1) -- Line 440
	if not arg1._deferredChange then
		arg1._deferredChange = {
			countChange = 0;
			indexChanges = {};
			itemsAdded = {};
			itemsRemoved = {};
		}
		task.defer(function() -- Line 449
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			local _deferredChange_2 = arg1._deferredChange
			arg1._deferredChange = nil
			arg1._countValue.Value = arg1._countValue.Value + _deferredChange_2.countChange
			if arg1.Destroy then
				for _, v_4 in pairs(_deferredChange_2.itemsAdded) do
					arg1.ItemAdded:Fire(v_4.item, v_4.newIndex, v_4.key)
				end
				for _, v_5 in pairs(_deferredChange_2.itemsRemoved) do
					arg1.ItemRemoved:Fire(v_5.item, v_5.key)
				end
			end
			for _, v_6 in pairs(_deferredChange_2.indexChanges) do
				if arg1._indexes[v_6.key] == v_6.newIndex then
					local var123 = arg1._keyObservables[v_6.key]
					if var123 then
						arg1:_fireSubs(var123, v_6.newIndex)
					end
				end
			end
		end)
	end
end
function module_upvr._findCorrectIndex(arg1, arg2, arg3) -- Line 479
	for i_7 = #arg1._keyList, 1, -1 do
		if arg1._compare(arg1._sortValue[arg1._keyList[i_7]], arg2) then
			if arg3 and arg3 <= i_7 then
				return i_7
			end
			return i_7 + 1
		end
	end
	return 1
end
function module_upvr._fireSubs(arg1, arg2, arg3) -- Line 499
	for _, v_7_upvr in pairs(arg2) do
		if v_7_upvr:IsPending() then
			task.spawn(function() -- Line 502
				--[[ Upvalues[2]:
					[1]: v_7_upvr (readonly)
					[2]: arg3 (readonly)
				]]
				v_7_upvr:Fire(arg3)
			end)
		end
	end
end
function module_upvr._completeSubs(arg1, arg2) -- Line 509
	for _, v_8 in pairs(arg2) do
		if v_8:IsPending() then
			v_8:Fire(nil)
			v_8:Complete()
		end
	end
end
function module_upvr.Destroy(arg1) -- Line 521
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr