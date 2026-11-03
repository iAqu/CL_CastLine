-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:53
-- Luau version 6, Types version 3
-- Time taken: 0.006893 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_4 = any_load_result1("Observable")
local var1_result1_upvr = any_load_result1("Maid")
local module_upvr = {
	ClassName = "ObservableCountingMap";
}
module_upvr.__index = module_upvr
local var1_result1_upvr_2 = any_load_result1("Signal")
function module_upvr.new() -- Line 22
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var1_result1_upvr.new()
	setmetatable_result1._map = {}
	setmetatable_result1._totalKeyCountValue = Instance.new("IntValue")
	setmetatable_result1._totalKeyCountValue.Value = 0
	setmetatable_result1._maid:GiveTask(setmetatable_result1._totalKeyCountValue)
	setmetatable_result1.KeyAdded = var1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.KeyAdded)
	setmetatable_result1.KeyRemoved = var1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.KeyRemoved)
	setmetatable_result1.KeyChanged = var1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.KeyChanged)
	setmetatable_result1.TotalKeyCountChanged = setmetatable_result1._totalKeyCountValue.Changed
	return setmetatable_result1
end
function module_upvr.isObservableMap(arg1) -- Line 74
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
function module_upvr.ObserveKeysList(arg1) -- Line 82
	return arg1:_observeDerivedDataStructureFromKeys(function() -- Line 83
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		local module_2 = {}
		for i, _ in pairs(arg1._map) do
			table.insert(module_2, i)
		end
		return module_2
	end)
end
function module_upvr.ObserveKeysSet(arg1) -- Line 98
	return arg1:_observeDerivedDataStructureFromKeys(function() -- Line 99
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		local module = {}
		for i_2, _ in pairs(arg1._map) do
			module[i_2] = true
		end
		return module
	end)
end
function module_upvr._observeDerivedDataStructureFromKeys(arg1, arg2) -- Line 110
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr_4.new(function(arg1_2) -- Line 111
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_2 = var1_result1_upvr.new()
		local function emit() -- Line 114
			--[[ Upvalues[2]:
				[1]: arg1_2 (readonly)
				[2]: arg2 (copied, readonly)
			]]
			arg1_2:Fire(arg2())
		end
		any_new_result1_2:GiveTask(arg1.KeyAdded:Connect(emit))
		any_new_result1_2:GiveTask(arg1.KeyRemoved:Connect(emit))
		arg1_2:Fire(arg2())
		arg1._maid[arg1_2] = any_new_result1_2
		any_new_result1_2:GiveTask(function() -- Line 124
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_2 (readonly)
			]]
			arg1._maid[arg1_2] = nil
			arg1_2:Complete()
		end)
		return any_new_result1_2
	end)
end
local var1_result1_upvr_3 = any_load_result1("Brio")
function module_upvr.ObserveKeysBrio(arg1) -- Line 137
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_4.new(function(arg1_3) -- Line 138
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr.new()
		for i_3, _ in pairs(arg1._map) do
			local any_new_result1 = var1_result1_upvr_3.new(i_3)
			any_new_result1_upvr[i_3] = any_new_result1
			arg1_3:Fire(any_new_result1)
		end
		any_new_result1_upvr:GiveTask(arg1.KeyAdded:Connect(function(arg1_4) -- Line 141, Named "handleItem"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: arg1_3 (readonly)
			]]
			local any_new_result1_3 = var1_result1_upvr_3.new(arg1_4)
			any_new_result1_upvr[arg1_4] = any_new_result1_3
			arg1_3:Fire(any_new_result1_3)
		end))
		any_new_result1_upvr:GiveTask(arg1.KeyRemoved:Connect(function(arg1_5) -- Line 152
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr[arg1_5] = nil
		end))
		arg1._maid[arg1_3] = any_new_result1_upvr
		any_new_result1_upvr:GiveTask(function() -- Line 157
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_3 (readonly)
			]]
			arg1._maid[arg1_3] = nil
			arg1_3:Complete()
		end)
		return any_new_result1_upvr
	end)
end
function module_upvr.Contains(arg1, arg2) -- Line 171
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	if arg1._map[arg2] == nil then
	else
	end
	return true
end
function module_upvr.Get(arg1, arg2) -- Line 182
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	return arg1._map[arg2] or 0
end
function module_upvr.GetTotalKeyCount(arg1) -- Line 192
	return arg1._totalKeyCountValue.Value
end
local any_load_result1_result1_upvr = any_load_result1("RxValueBaseUtils")
function module_upvr.ObserveTotalKeyCount(arg1) -- Line 200
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.observeValue(arg1._totalKeyCountValue)
end
function module_upvr.Set(arg1, arg2, arg3) -- Line 210
	local any_Get_result1 = arg1:Get(arg2)
	if any_Get_result1 == arg3 then
	else
		if any_Get_result1 < arg3 then
			arg1:Remove(arg3 - any_Get_result1)
			return
		end
		if any_Get_result1 == arg3 then return end
		arg1:Add(any_Get_result1 - arg3)
	end
end
function module_upvr.Add(arg1, arg2, arg3) -- Line 233
	-- KONSTANTERROR: [0] 1. Error Block 33 start (CF ANALYSIS FAILED)
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	if type(arg3) ~= "number" then
		if arg3 ~= nil then
		else
		end
	end
	assert(true, "Bad amount")
	local var45_upvw = arg3 or 1
	if var45_upvw == 0 then return end
	if var45_upvw < 0 then
		arg1:Remove(arg2, -var45_upvw)
		return
	end
	if not arg1._map[arg2] then
		arg1._map[arg2] = var45_upvw
		arg1._totalKeyCountValue.Value = arg1._totalKeyCountValue.Value + 1
		if arg1.Destroy then
			arg1.KeyAdded:Fire(arg2)
			-- KONSTANTWARNING: GOTO [83] #60
		end
	else
		local var46 = arg1._map[arg2] + var45_upvw
		arg1._map[arg2] = var46
		arg1.KeyChanged:Fire(arg2, var46)
	end
	-- KONSTANTERROR: [0] 1. Error Block 33 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [83] 60. Error Block 19 start (CF ANALYSIS FAILED)
	local var48_upvw = false
	do
		return function() -- Line 259
			--[[ Upvalues[4]:
				[1]: arg1 (readonly)
				[2]: var48_upvw (read and write)
				[3]: arg2 (readonly)
				[4]: var45_upvw (read and write)
			]]
			if arg1.Destroy and not var48_upvw then
				var48_upvw = true
				arg1:RemoveCount(arg2, var45_upvw)
			end
		end
	end
	-- KONSTANTERROR: [83] 60. Error Block 19 end (CF ANALYSIS FAILED)
end
function module_upvr.RemoveCount(arg1, arg2, arg3) -- Line 273
	if arg2 == nil then
	else
	end
	assert(true, "Bad key")
	if type(arg3) ~= "number" then
		if arg3 ~= nil then
		else
		end
	end
	assert(true, "Bad amount")
	local var49 = arg3 or 1
	if var49 == 0 then
	else
		if var49 < 0 then
			arg1:Add(arg2, -var49)
			return
		end
		local var50 = arg1._map[arg2]
		if not var50 then return end
		local var51 = var50 - var49
		if 0 < var51 then
			arg1._map[arg2] = var51
			arg1.KeyChanged:Fire(arg2, var51)
			return
		end
		arg1._map[arg2] = nil
		arg1._totalKeyCountValue.Value = arg1._totalKeyCountValue.Value - 1
		if arg1.Destroy then
			arg1.KeyRemoved:Fire(arg2)
		end
		if arg1.Destroy then
			arg1.KeyChanged:Fire(arg2, 0)
		end
	end
end
function module_upvr.GetFirstKey(arg1) -- Line 313
	return next(arg1._map)
end
function module_upvr.GetKeysList(arg1) -- Line 322
	local module_3 = {}
	for i_4, _ in pairs(arg1._map) do
		table.insert(module_3, i_4)
	end
	return module_3
end
function module_upvr.Destroy(arg1) -- Line 333
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr