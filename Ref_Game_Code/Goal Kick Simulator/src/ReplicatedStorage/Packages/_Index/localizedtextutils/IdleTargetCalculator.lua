-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:37
-- Luau version 6, Types version 3
-- Time taken: 0.001286 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "IdleTargetCalculator"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new() -- Line 19
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(), setmetatable_result1_2_upvr)
	setmetatable_result1._disableContextUI = Instance.new("BoolValue")
	setmetatable_result1._disableContextUI.Value = false
	setmetatable_result1._maid:GiveTask(setmetatable_result1._disableContextUI)
	setmetatable_result1.Changed = setmetatable_result1._disableContextUI.Changed
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetShouldDisableContextUI(arg1) -- Line 31
	return arg1._disableContextUI.Value
end
local any_load_result1_result1_upvr = any_load_result1("RxValueBaseUtils")
function setmetatable_result1_2_upvr.ObserveShouldDisableContextUI(arg1) -- Line 36
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.observeValue(arg1._disableContextUI)
end
function setmetatable_result1_2_upvr.SetTarget(arg1, arg2) -- Line 40
	if not arg2 then
		arg1._disableContextUI.Value = false
	else
		if arg1._lastTargetPosition then
			if 0.15 <= (arg1._lastTargetPosition - arg2).magnitude then
				arg1._lastMoveTime = os.clock()
				arg1._disableContextUI.Value = true
			elseif not arg1._lastMoveTime or 1 <= os.clock() - arg1._lastMoveTime then
				arg1._disableContextUI.Value = false
			else
				arg1._disableContextUI.Value = true
			end
		else
			arg1._disableContextUI.Value = false
		end
		arg1._lastTargetPosition = arg2
	end
end
return setmetatable_result1_2_upvr