-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:43
-- Luau version 6, Types version 3
-- Time taken: 0.001064 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("Motor6DTransformer")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "Motor6DPhysicsTransformer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Spring")
function setmetatable_result1_upvr.new(arg1) -- Line 15
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local var5 = setmetatable_result1_upvr
	local setmetatable_result1 = setmetatable(var1_result1_upvr_3.new(), var5)
	if typeof(arg1) ~= "CFrame" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad physicsTransform")
	setmetatable_result1._physicsTransform = arg1
	setmetatable_result1._relativeTransformSpring = var1_result1_upvr.new(0)
	setmetatable_result1._relativeTransformSpring.s = 25
	setmetatable_result1._relativeTransformSpring.t = 1
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetSpeed(arg1, arg2) -- Line 29
	arg1._relativeTransformSpring.s = arg2
end
local var1_result1_upvr_2 = any_load_result1("SpringUtils")
function setmetatable_result1_upvr.Transform(arg1, arg2) -- Line 33
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any_animating_result1, any_animating_result2 = var1_result1_upvr_2.animating(arg1._relativeTransformSpring)
	if any_animating_result1 then
		return arg1._physicsTransform:Lerp(arg2(), any_animating_result2)
	end
	arg1:FireFinished()
	return nil
end
return setmetatable_result1_upvr