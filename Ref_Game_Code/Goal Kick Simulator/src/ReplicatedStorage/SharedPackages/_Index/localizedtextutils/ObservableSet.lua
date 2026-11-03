-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:51
-- Luau version 6, Types version 3
-- Time taken: 0.005025 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("Maid")
local module_upvr = {
	ClassName = "ObservableSet";
}
module_upvr.__index = module_upvr
local var1_result1_upvr = any_load_result1("Signal")
function module_upvr.new() -- Line 22
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var1_result1_upvr_3.new()
	setmetatable_result1._set = {}
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
function module_upvr.isObservableSet(arg1) -- Line 65
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var6 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_upvr then
			var6 = false
		else
			var6 = true
		end
	end
	return var6
end
local var1_result1_upvr_5 = any_load_result1("Observable")
local var1_result1_upvr_4 = any_load_result1("Brio")
function module_upvr.ObserveItemsBrio(arg1) -- Line 73
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_4 (readonly)
	]]
	return var1_result1_upvr_5.new(function(arg1_2) -- Line 74
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr_3.new()
		for i, _ in pairs(arg1._set) do
			local any_new_result1_2 = var1_result1_upvr_4.new(i)
			any_new_result1_upvr[i] = any_new_result1_2
			arg1_2:Fire(any_new_result1_2)
		end
		any_new_result1_upvr:GiveTask(arg1.ItemAdded:Connect(function(arg1_3) -- Line 77, Named "handleItem"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_4 (copied, readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: arg1_2 (readonly)
			]]
			local any_new_result1 = var1_result1_upvr_4.new(arg1_3)
			any_new_result1_upvr[arg1_3] = any_new_result1
			arg1_2:Fire(any_new_result1)
		end))
		any_new_result1_upvr:GiveTask(arg1.ItemRemoved:Connect(function(arg1_4) -- Line 88
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr[arg1_4] = nil
		end))
		arg1._maid[arg1_2] = any_new_result1_upvr
		any_new_result1_upvr:GiveTask(function() -- Line 93
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_2 (readonly)
			]]
			arg1._maid[arg1_2] = nil
			arg1_2:Complete()
		end)
		return any_new_result1_upvr
	end)
end
function module_upvr.Contains(arg1, arg2) -- Line 107
	if arg2 == nil then
	else
	end
	assert(true, "Bad item")
	if arg1._set[arg2] ~= true then
	else
	end
	return true
end
function module_upvr.GetCount(arg1) -- Line 117
	return arg1._countValue.Value
end
local var1_result1_upvr_2 = any_load_result1("RxValueBaseUtils")
function module_upvr.ObserveCount(arg1) -- Line 125
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.observeValue(arg1._countValue)
end
function module_upvr.Add(arg1, arg2) -- Line 134
	if arg2 == nil then
	else
	end
	assert(true, "Bad item")
	if not arg1._set[arg2] then
		arg1._countValue.Value = arg1._countValue.Value + 1
		arg1._set[arg2] = true
		arg1.ItemAdded:Fire(arg2)
	end
	return function() -- Line 143
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		if arg1.Destroy then
			arg1:Remove(arg2)
		end
	end
end
function module_upvr.Remove(arg1, arg2) -- Line 154
	if arg2 == nil then
	else
	end
	assert(true, "Bad item")
	if arg1._set[arg2] then
		arg1._countValue.Value = arg1._countValue.Value - 1
		arg1._set[arg2] = nil
		if arg1.Destroy then
			arg1.ItemRemoved:Fire(arg2)
		end
	end
end
function module_upvr.GetFirstItem(arg1) -- Line 171
	return next(arg1._set)
end
function module_upvr.GetList(arg1) -- Line 180
	local module_2 = {}
	for i_2, _ in pairs(arg1._set) do
		table.insert(module_2, i_2)
	end
	return module_2
end
function module_upvr.GetSetCopy(arg1) -- Line 192
	local module = {}
	for i_3, _ in pairs(arg1._set) do
		module[i_3] = true
	end
	return module
end
function module_upvr.Destroy(arg1) -- Line 203
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr