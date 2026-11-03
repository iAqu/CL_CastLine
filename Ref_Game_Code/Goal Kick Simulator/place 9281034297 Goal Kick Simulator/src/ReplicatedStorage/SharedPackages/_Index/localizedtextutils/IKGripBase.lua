-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:26
-- Luau version 6, Types version 3
-- Time taken: 0.001667 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1_upvr("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_2_upvr.ClassName = "IKGripBase"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2) -- Line 18
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_3.new(arg1), setmetatable_result1_2_upvr)
	setmetatable_result1._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1._attachment = setmetatable_result1._obj.Parent
	assert(setmetatable_result1._obj:IsA("ObjectValue"), "Not an object value")
	assert(setmetatable_result1._attachment:IsA("Attachment"), "Not parented to an attachment")
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetPriority(arg1) -- Line 30
	return 1
end
function setmetatable_result1_2_upvr.GetAttachment(arg1) -- Line 34
	return arg1._obj.Parent
end
local RunService_upvr = game:GetService("RunService")
local var1_result1_upvr = any_load_result1_upvr("promisePropertyValue")
local var1_result1_upvr_2 = any_load_result1_upvr("Promise")
function setmetatable_result1_2_upvr.PromiseIKRig(arg1) -- Line 38
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: any_load_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_2 (readonly)
	]]
	if arg1._ikRigPromise then
		return arg1._ikRigPromise
	end
	local var8_upvw
	if RunService_upvr:IsServer() then
		var8_upvw = arg1._serviceBag:GetService(any_load_result1_upvr("IKService"))
	else
		var8_upvw = arg1._serviceBag:GetService(any_load_result1_upvr("IKServiceClient"))
	end
	local var1_result1_upvr_result1 = var1_result1_upvr(arg1._obj, "Value")
	arg1._maid:GiveTask(var1_result1_upvr_result1)
	arg1._ikRigPromise = var1_result1_upvr_result1:Then(function(arg1_2) -- Line 54
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var8_upvw (read and write)
		]]
		if not arg1_2:IsA("Humanoid") then
			warn("[IKGripBase.PromiseIKRig] - Humanoid in link is not a humanoid")
			return var1_result1_upvr_2.rejected()
		end
		return arg1._maid:GivePromise(var8_upvw:PromiseRig(arg1_2))
	end)
	return arg1._ikRigPromise
end
return setmetatable_result1_2_upvr