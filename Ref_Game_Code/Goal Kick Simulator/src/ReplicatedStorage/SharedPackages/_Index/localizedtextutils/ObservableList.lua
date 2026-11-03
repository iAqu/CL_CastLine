-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:21
-- Luau version 6, Types version 3
-- Time taken: 0.010629 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_5 = any_load_result1("Observable")
local var1_result1_upvr_2 = any_load_result1("Maid")
local module_upvr = {
	ClassName = "ObservableList";
}
module_upvr.__index = module_upvr
local var1_result1_upvr = any_load_result1("Signal")
function module_upvr.new() -- Line 23
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var1_result1_upvr_2.new()
	setmetatable_result1._keyList = {}
	setmetatable_result1._contents = {}
	setmetatable_result1._indexes = {}
	setmetatable_result1._keyObservables = {}
	setmetatable_result1._countValue = Instance.new("IntValue")
	setmetatable_result1._countValue.Value = 0
	setmetatable_result1._maid:GiveTask(setmetatable_result1._countValue)
	setmetatable_result1.ItemAdded = var1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ItemAdded)
	setmetatable_result1.ItemRemoved = var1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ItemRemoved)
	setmetatable_result1.CountChanged = setmetatable_result1._countValue.Changed
	return setmetatable_result1
end
function module_upvr.isObservableList(arg1) -- Line 71
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var7 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_upvr then
			var7 = false
		else
			var7 = true
		end
	end
	return var7
end
local var1_result1_upvr_6 = any_load_result1("Brio")
function module_upvr.ObserveItemsBrio(arg1) -- Line 79
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_6 (readonly)
	]]
	return var1_result1_upvr_5.new(function(arg1_2) -- Line 80
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr_6 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_3_upvr = var1_result1_upvr_2.new()
		for _, v in pairs(arg1._keyList) do
			local any_new_result1_2 = var1_result1_upvr_6.new(arg1._contents[v], v)
			any_new_result1_3_upvr[v] = any_new_result1_2
			arg1_2:Fire(any_new_result1_2)
		end
		any_new_result1_3_upvr:GiveTask(arg1.ItemAdded:Connect(function(arg1_3, arg2, arg3) -- Line 83, Named "handleItem"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_6 (copied, readonly)
				[2]: any_new_result1_3_upvr (readonly)
				[3]: arg1_2 (readonly)
			]]
			local any_new_result1_4 = var1_result1_upvr_6.new(arg1_3, arg3)
			any_new_result1_3_upvr[arg3] = any_new_result1_4
			arg1_2:Fire(any_new_result1_4)
		end))
		any_new_result1_3_upvr:GiveTask(arg1.ItemRemoved:Connect(function(arg1_4, arg2) -- Line 94
			--[[ Upvalues[1]:
				[1]: any_new_result1_3_upvr (readonly)
			]]
			any_new_result1_3_upvr[arg2] = nil
		end))
		arg1._maid[arg1_2] = any_new_result1_3_upvr
		any_new_result1_3_upvr:GiveTask(function() -- Line 99
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_2 (readonly)
			]]
			arg1._maid[arg1_2] = nil
			arg1_2:Complete()
		end)
		return any_new_result1_3_upvr
	end)
end
function module_upvr.ObserveIndex(arg1, arg2) -- Line 115
	local var22
	if type(arg2) ~= "number" then
		var22 = false
	else
		var22 = true
	end
	assert(var22, "Bad indexToObserve")
	var22 = arg1._keyList
	local var23 = var22[arg2]
	if not var23 then
		var22 = error
		var22("No entry at index %q, cannot observe changes":format(arg2))
	end
	var22 = arg1:ObserveIndexByKey(var23)
	return var22
end
function module_upvr.RemoveFirst(arg1, arg2) -- Line 132
	for i_2, v_2 in pairs(arg1._contents) do
		if v_2 == arg2 then
			arg1:RemoveByKey(i_2)
			return true
		end
	end
	return false
end
function module_upvr.GetCountValue(arg1) -- Line 148
	return arg1._countValue
end
function module_upvr.ObserveIndexByKey(arg1, arg2) -- Line 159
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var30
	if type(arg2) ~= "userdata" then
		var30 = false
	else
		var30 = true
	end
	assert(var30, "Bad key")
	var30 = var1_result1_upvr_5
	function var30(arg1_5) -- Line 162
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: var1_result1_upvr_2 (copied, readonly)
		]]
		local var31 = arg1._indexes[arg2]
		if not var31 then
			arg1_5:Complete()
			return
		end
		local any_new_result1 = var1_result1_upvr_2.new()
		local var33 = arg1._keyObservables[arg2]
		if not var33 then
			var33 = {}
		end
		arg1._keyObservables[arg2] = var33
		table.insert(arg1._keyObservables[arg2], arg1_5)
		arg1_5:Fire(var31)
		any_new_result1:GiveTask(function() -- Line 175
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: arg1_5 (readonly)
			]]
			local var37 = arg1._keyObservables[arg2]
			if not var37 then
			else
				local table_find_result1 = table.find(var37, arg1_5)
				if table_find_result1 then
					table.remove(var37, table_find_result1)
					if #var37 == 0 then
						arg1._keyObservables[arg2] = nil
					end
				end
			end
		end)
		return any_new_result1
	end
	return var30.new(var30)
end
function module_upvr.GetIndexByKey(arg1, arg2) -- Line 200
	local var39 = arg1._indexes[arg2]
	if var39 then
		return var39
	end
	return nil
end
function module_upvr.GetCount(arg1) -- Line 213
	return arg1._countValue.Value
end
local var1_result1_upvr_3 = any_load_result1("RxValueBaseUtils")
function module_upvr.ObserveCount(arg1) -- Line 221
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.observeValue(arg1._countValue)
end
function module_upvr.Add(arg1, arg2) -- Line 230
	return arg1:InsertAt(arg2, #arg1._keyList + 1)
end
function module_upvr.Get(arg1, arg2) -- Line 239
	local var41
	if type(arg2) ~= "number" then
		var41 = false
	else
		var41 = true
	end
	assert(var41, "Bad index")
	var41 = arg1._keyList
	local var42 = var41[arg2]
	if not var42 then
		var41 = nil
		return var41
	end
	var41 = arg1._contents[var42]
	return var41
end
local var1_result1_upvr_4 = any_load_result1("Symbol")
function module_upvr.InsertAt(arg1, arg2, arg3) -- Line 256
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	if arg2 == nil then
	else
	end
	assert(true, "Bad item")
	if type(arg3) ~= "number" then
	else
	end
	assert(true, "Bad index")
	local clamped = math.clamp(arg3, 1, #arg1._keyList + 1)
	local any_named_result1_upvr = var1_result1_upvr_4.named("entryKey")
	arg1._contents[any_named_result1_upvr] = arg2
	arg1._indexes[any_named_result1_upvr] = clamped
	local tbl = {}
	for i_3 = #arg1._keyList, clamped, -1 do
		local var53 = arg1._keyList[i_3]
		arg1._indexes[var53] = i_3 + 1
		arg1._keyList[i_3 + 1] = var53
		local var54 = arg1._keyObservables[var53]
		if var54 then
			table.insert(tbl, {
				key = var53;
				newIndex = i_3 + 1;
				subs = var54;
			})
		end
	end
	arg1._keyList[clamped] = any_named_result1_upvr
	arg1._countValue.Value = arg1._countValue.Value + 1
	arg1.ItemAdded:Fire(arg2, clamped, any_named_result1_upvr)
	local var56 = arg1._keyObservables[any_named_result1_upvr]
	if var56 then
		table.insert(tbl, {
			key = any_named_result1_upvr;
			newIndex = clamped;
			subs = var56;
		})
	end
	for _, v_3 in pairs(tbl) do
		if arg1._indexes[v_3.key] == v_3.newIndex then
			arg1:_fireSubs(v_3.subs, v_3.newIndex)
		end
	end
	return function() -- Line 313
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_named_result1_upvr (readonly)
		]]
		if arg1.Destroy then
			arg1:RemoveByKey(any_named_result1_upvr)
		end
	end
end
function module_upvr.RemoveAt(arg1, arg2) -- Line 325
	local var62
	if type(arg2) ~= "number" then
		var62 = false
	else
		var62 = true
	end
	assert(var62, "Bad index")
	var62 = arg1._keyList
	local var63 = var62[arg2]
	if not var63 then
		var62 = nil
		return var62
	end
	var62 = arg1:RemoveByKey(var63)
	return var62
end
function module_upvr.RemoveByKey(arg1, arg2) -- Line 341
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	local var70 = arg1._indexes[arg2]
	if not var70 then
		return nil
	end
	local var71 = arg1._contents[arg2]
	if var71 == nil then
		return nil
	end
	local var72 = arg1._keyObservables[arg2]
	arg1._keyObservables[arg2] = nil
	arg1._indexes[arg2] = nil
	arg1._contents[arg2] = nil
	local len = #arg1._keyList
	for i_5 = var70, len - 1 do
		local var74 = arg1._keyList[i_5 + 1]
		arg1._indexes[var74] = i_5
		arg1._keyList[i_5] = var74
		local var75 = arg1._keyObservables[var74]
		if var75 then
			table.insert({}, {
				key = var74;
				newIndex = i_5;
				subs = var75;
			})
		end
	end
	arg1._keyList[len] = nil
	arg1._countValue.Value = arg1._countValue.Value - 1
	if arg1.Destroy then
		arg1.ItemRemoved:Fire(var71, arg2)
	end
	if var72 then
		arg1:_completeSubs(var72)
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for _, v_4 in pairs({}) do
		if arg1._indexes[v_4.key] == v_4.newIndex then
			arg1:_fireSubs(v_4.subs, v_4.newIndex)
		end
	end
	return var71
end
function module_upvr._fireSubs(arg1, arg2, arg3) -- Line 401
	for _, v_5_upvr in pairs(arg2) do
		if v_5_upvr:IsPending() then
			task.spawn(function() -- Line 404
				--[[ Upvalues[2]:
					[1]: v_5_upvr (readonly)
					[2]: arg3 (readonly)
				]]
				v_5_upvr:Fire(arg3)
			end)
		end
	end
end
function module_upvr._completeSubs(arg1, arg2) -- Line 411
	for _, v_6 in pairs(arg2) do
		if v_6:IsPending() then
			v_6:Fire(nil)
			v_6:Complete()
		end
	end
end
function module_upvr.GetList(arg1) -- Line 424
	local module = {}
	for _, v_7 in pairs(arg1._keyList) do
		table.insert(module, arg1._contents[v_7])
	end
	return module
end
function module_upvr.Destroy(arg1) -- Line 435
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr