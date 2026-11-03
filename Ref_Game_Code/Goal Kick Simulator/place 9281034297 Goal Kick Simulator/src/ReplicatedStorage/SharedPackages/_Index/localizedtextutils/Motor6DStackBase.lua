-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:21
-- Luau version 6, Types version 3
-- Time taken: 0.001366 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "Motor6DStackBase"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Motor6DAnimator")
local any_load_result1_result1_upvr = any_load_result1("Motor6DStackInterface")
function setmetatable_result1_upvr.new(arg1) -- Line 16
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_3.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1._animator = var1_result1_upvr.new(arg1)
	setmetatable_result1._maid:GiveTask(setmetatable_result1._animator)
	setmetatable_result1._maid:GiveTask(any_load_result1_result1_upvr:Implement(setmetatable_result1._obj, setmetatable_result1))
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("Motor6DPhysicsTransformer")
function setmetatable_result1_upvr.TransformFromCFrame(arg1, arg2, arg3) -- Line 27
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var8
	if typeof(arg2) ~= "CFrame" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad physicsTransformCFrame")
	var8 = true
	if type(arg3) ~= "number" then
		if arg3 ~= nil then
			var8 = false
		else
			var8 = true
		end
	end
	assert(var8, "Bad speed")
	var8 = var1_result1_upvr_2
	var8 = arg2
	local any_new_result1 = var8.new(var8)
	if arg3 then
		var8 = any_new_result1:SetSpeed
		var8(arg3)
	end
	var8 = arg1._animator:Push
	var8(any_new_result1)
	return any_new_result1
end
function setmetatable_result1_upvr.Push(arg1, arg2) -- Line 42
	assert(arg2, "No transformer")
	return arg1._animator:Push(arg2)
end
return setmetatable_result1_upvr