-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:39
-- Luau version 6, Types version 3
-- Time taken: 0.001359 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local var1_result1_upvr = any_load_result1("Maid")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "GripPointer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1) -- Line 17
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	local var6 = arg1
	if not var6 then
		var6 = error("No ikRig")
	end
	setmetatable_result1._ikRig = var6
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetLeftGrip(arg1, arg2) -- Line 25
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	arg1._leftGripAttachment = arg2
	if not arg1._leftGripAttachment then
		arg1._maid._leftGripMaid = nil
	else
		local any_new_result1_upvr = var1_result1_upvr.new()
		any_new_result1_upvr:GivePromise(arg1._ikRig:PromiseLeftArm()):Then(function(arg1_2) -- Line 34
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (readonly)
				[2]: arg1 (readonly)
			]]
			any_new_result1_upvr:GiveTask(arg1_2:Grip(arg1._leftGripAttachment, 1))
		end)
		arg1._maid._leftGripMaid = any_new_result1_upvr
	end
end
function setmetatable_result1_upvr.SetRightGrip(arg1, arg2) -- Line 40
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	arg1._rightGripAttachment = arg2
	if not arg1._rightGripAttachment then
		arg1._maid._rightArmMaid = nil
	else
		local any_new_result1_upvr_2 = var1_result1_upvr.new()
		any_new_result1_upvr_2:GivePromise(arg1._ikRig:PromiseRightArm()):Then(function(arg1_3) -- Line 49
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: arg1 (readonly)
			]]
			any_new_result1_upvr_2:GiveTask(arg1_3:Grip(arg1._rightGripAttachment, 1))
		end)
		arg1._maid._rightArmMaid = any_new_result1_upvr_2
	end
end
return setmetatable_result1_upvr