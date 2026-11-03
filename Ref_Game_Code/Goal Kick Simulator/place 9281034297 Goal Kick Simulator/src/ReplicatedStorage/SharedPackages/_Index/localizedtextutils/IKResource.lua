-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:05
-- Luau version 6, Types version 3
-- Time taken: 0.005244 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "IKResource"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1) -- Line 14
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1._data = assert(arg1, "Bad data")
	assert(arg1.name, "Bad data.name")
	assert(arg1.robloxName, "Bad data.robloxName")
	setmetatable_result1._instance = nil
	setmetatable_result1._childResourceMap = {}
	setmetatable_result1._descendantLookupMap = {
		[arg1.name] = setmetatable_result1;
	}
	setmetatable_result1._ready = Instance.new("BoolValue")
	setmetatable_result1._ready.Value = false
	setmetatable_result1._maid:GiveTask(setmetatable_result1._ready)
	setmetatable_result1.ReadyChanged = setmetatable_result1._ready.Changed
	if setmetatable_result1._data.children then
		for _, v in pairs(setmetatable_result1._data.children) do
			setmetatable_result1:_addResource(setmetatable_result1_upvr.new(v))
		end
	end
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetData(arg1) -- Line 42
	return arg1._data
end
function setmetatable_result1_upvr.IsReady(arg1) -- Line 46
	return arg1._ready.Value
end
function setmetatable_result1_upvr.Get(arg1, arg2) -- Line 50
	local var13 = arg1._descendantLookupMap[arg2]
	if not var13 then
		error("[IKResource.Get] - Resource %q does not exist":format(tostring(arg2)))
	end
	local any_GetInstance_result1 = var13:GetInstance()
	if not any_GetInstance_result1 then
		error("[IKResource.Get] - Not ready!")
	end
	return any_GetInstance_result1
end
function setmetatable_result1_upvr.GetInstance(arg1) -- Line 64
	if arg1._data.isLink then
		if arg1._instance then
			return arg1._instance.Value
		end
		return nil
	end
	return arg1._instance
end
local var1_result1_upvr = any_load_result1("Maid")
function setmetatable_result1_upvr.SetInstance(arg1, arg2) -- Line 76
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg1._instance == arg2 then
	else
		arg1._maid._instanceMaid = nil
		arg1._instance = arg2
		if next(arg1._childResourceMap) then
			if arg2 then
				arg1:_startListening(var1_result1_upvr.new(), arg2)
			else
				arg1:_clearChildren()
			end
		end
		if arg2 and arg1._data.isLink then
			assert(arg2:IsA("ObjectValue"))
			arg1._maid:GiveTask(arg2.Changed:Connect(function() -- Line 97
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1:_updateReady()
			end))
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		arg1._maid._instanceMaid = var1_result1_upvr.new()
		arg1:_updateReady()
	end
end
function setmetatable_result1_upvr.GetLookupTable(arg1) -- Line 106
	return arg1._descendantLookupMap
end
function setmetatable_result1_upvr._startListening(arg1, arg2, arg3) -- Line 110
	for _, v_2 in pairs(arg3:GetChildren()) do
		arg1:_handleChildAdded(v_2)
	end
	arg2:GiveTask(arg3.ChildAdded:Connect(function(arg1_2) -- Line 115
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleChildAdded(arg1_2)
	end))
	arg2:GiveTask(arg3.ChildRemoved:Connect(function(arg1_3) -- Line 118
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleChildRemoved(arg1_3)
	end))
end
function setmetatable_result1_upvr._addResource(arg1, arg2) -- Line 123
	local any_GetData_result1 = arg2:GetData()
	assert(any_GetData_result1.name, "Bad data.name")
	local robloxName = any_GetData_result1.robloxName
	assert(robloxName, "Bad data.robloxName")
	if type(any_GetData_result1.robloxName) ~= "string" then
		robloxName = false
	else
		robloxName = true
	end
	assert(robloxName, "Bad data.robloxName")
	assert(not arg1._childResourceMap[any_GetData_result1.robloxName], "Data already exists")
	assert(not arg1._descendantLookupMap[any_GetData_result1.name], "Data already exists")
	arg1._childResourceMap[any_GetData_result1.robloxName] = arg2
	arg1._maid:GiveTask(arg2)
	arg1._maid:GiveTask(arg2.ReadyChanged:Connect(function() -- Line 136
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateReady()
	end))
	for i_3, v_3 in pairs(arg2:GetLookupTable()) do
		assert(not arg1._descendantLookupMap[i_3], "Resource already exists with name")
		arg1._descendantLookupMap[i_3] = v_3
	end
end
function setmetatable_result1_upvr._handleChildAdded(arg1, arg2) -- Line 148
	local var34 = arg1._childResourceMap[arg2.Name]
	if not var34 then
	else
		var34:SetInstance(arg2)
	end
end
function setmetatable_result1_upvr._handleChildRemoved(arg1, arg2) -- Line 157
	local var35 = arg1._childResourceMap[arg2.Name]
	if not var35 then
	elseif var35:GetInstance() == arg2 then
		var35:SetInstance(nil)
	end
end
function setmetatable_result1_upvr._clearChildren(arg1) -- Line 168
	for _, v_4 in pairs(arg1._childResourceMap) do
		v_4:SetInstance(nil)
	end
end
function setmetatable_result1_upvr._updateReady(arg1) -- Line 174
	arg1._ready.Value = arg1:_calculateIsReady()
end
function setmetatable_result1_upvr._calculateIsReady(arg1) -- Line 178
	if not arg1._instance then
		return false
	end
	if arg1._data.isLink and not arg1._instance.Value then
		return false
	end
	for _, v_5 in pairs(arg1._childResourceMap) do
		if not v_5:IsReady() then
			return false
		end
	end
	return true
end
return setmetatable_result1_upvr