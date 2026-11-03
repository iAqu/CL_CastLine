-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:44
-- Luau version 6, Types version 3
-- Time taken: 0.001837 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_2_upvr.ClassName = "StateStack"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
local var1_result1_upvr = any_load_result1("ValueObject")
function setmetatable_result1_2_upvr.new(arg1) -- Line 38
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_2_upvr)
	setmetatable_result1._defaultValue = arg1
	setmetatable_result1._state = var1_result1_upvr.new(arg1)
	setmetatable_result1._maid:GiveTask(setmetatable_result1._state)
	setmetatable_result1._stateStack = {}
	setmetatable_result1.Changed = setmetatable_result1._state.Changed
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetCount(arg1) -- Line 61
	return #arg1._stateStack
end
function setmetatable_result1_2_upvr.GetState(arg1) -- Line 69
	return arg1._state.Value
end
function setmetatable_result1_2_upvr.Observe(arg1) -- Line 77
	return arg1._state:Observe()
end
function setmetatable_result1_2_upvr.PushState(arg1, arg2) -- Line 86
	local tbl_upvr = {}
	tbl_upvr[1] = arg2
	table.insert(arg1._stateStack, tbl_upvr)
	arg1:_updateState()
	return function() -- Line 91
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: tbl_upvr (readonly)
		]]
		if arg1.Destroy then
			arg1:_popState(tbl_upvr)
		end
	end
end
function setmetatable_result1_2_upvr._popState(arg1, arg2) -- Line 98
	local table_find_result1 = table.find(arg1._stateStack, arg2)
	if table_find_result1 then
		table.remove(arg1._stateStack, table_find_result1)
		arg1:_updateState()
	else
		warn("[StateStack] - Failed to find index")
	end
end
function setmetatable_result1_2_upvr._updateState(arg1) -- Line 108
	local var9 = arg1._stateStack[#arg1._stateStack]
	if var9 == nil then
		arg1._state.Value = arg1._defaultValue
	else
		arg1._state.Value = var9[1]
	end
end
return setmetatable_result1_2_upvr