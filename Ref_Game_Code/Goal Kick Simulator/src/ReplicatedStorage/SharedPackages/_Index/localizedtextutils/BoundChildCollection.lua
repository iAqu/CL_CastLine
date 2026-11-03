-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:17
-- Luau version 6, Types version 3
-- Time taken: 0.002948 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr)
setmetatable_result1_upvr.ClassName = "BoundChildCollection"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 21
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr.new(), setmetatable_result1_upvr)
	local var6 = arg1
	if not var6 then
		var6 = error("No binder")
	end
	setmetatable_result1_upvr_2._binder = var6
	var6 = arg2
	local var7 = var6
	if not var7 then
		var7 = error("No parent")
	end
	setmetatable_result1_upvr_2._parent = var7
	setmetatable_result1_upvr_2.ClassAdded = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.ClassAdded)
	setmetatable_result1_upvr_2.ClassRemoved = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.ClassRemoved)
	setmetatable_result1_upvr_2._classes = {}
	setmetatable_result1_upvr_2._size = 0
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._binder:GetClassAddedSignal():Connect(function(...) -- Line 46
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_handleNewClassBound(...)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._binder:GetClassRemovingSignal():Connect(function(arg1_2) -- Line 49
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_removeClass(arg1_2)
	end))
	setmetatable_result1_upvr_2:_startTracking()
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.HasClass(arg1, arg2) -- Line 63
	return arg1._classes[arg2]
end
function setmetatable_result1_upvr.GetSize(arg1) -- Line 71
	return arg1._size
end
function setmetatable_result1_upvr.GetSet(arg1) -- Line 84
	return arg1._classes
end
function setmetatable_result1_upvr.GetClasses(arg1) -- Line 92
	local module = {}
	for i, _ in pairs(arg1._classes) do
		table.insert(module, i)
	end
	return module
end
function setmetatable_result1_upvr._startTracking(arg1) -- Line 100
	arg1._maid:GiveTask(arg1._parent.ChildAdded:Connect(function(arg1_3) -- Line 101
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_addChild(arg1_3)
	end))
	arg1._maid:GiveTask(arg1._parent.ChildRemoved:Connect(function(arg1_4) -- Line 105
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_removeChild(arg1_4)
	end))
	for _, v_2 in pairs(arg1._parent:GetChildren()) do
		arg1:_addChild(v_2, true)
	end
end
function setmetatable_result1_upvr._addChild(arg1, arg2, arg3) -- Line 115
	local any_Get_result1_2 = arg1._binder:Get(arg2)
	if not any_Get_result1_2 then
	else
		arg1:_addClass(any_Get_result1_2, arg3)
	end
end
function setmetatable_result1_upvr._handleNewClassBound(arg1, arg2, arg3) -- Line 124
	if arg3.Parent ~= arg1._parent then
	else
		arg1:_addClass(arg2)
	end
end
function setmetatable_result1_upvr._removeChild(arg1, arg2) -- Line 132
	local any_Get_result1 = arg1._binder:Get(arg2)
	if not any_Get_result1 then
	else
		arg1:_removeClass(any_Get_result1)
	end
end
function setmetatable_result1_upvr._addClass(arg1, arg2, arg3) -- Line 141
	if arg1._classes[arg2] then
	else
		arg1._classes[arg2] = true
		arg1._size += 1
		if not arg3 then
			arg1.ClassAdded:Fire(arg2)
		end
	end
end
function setmetatable_result1_upvr._removeClass(arg1, arg2) -- Line 153
	if not arg1._classes[arg2] then
	else
		arg1._classes[arg2] = nil
		arg1._size -= 1
		arg1.ClassRemoved:Fire(arg2)
	end
end
return setmetatable_result1_upvr