-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:17
-- Luau version 6, Types version 3
-- Time taken: 0.001334 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Motor6DTransformer")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "Motor6DSmoothTransformer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Spring")
function setmetatable_result1_upvr.new(arg1) -- Line 15
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1._getTransform = assert(arg1, "No getTransform")
	setmetatable_result1._relativeTransformSpring = var1_result1_upvr.new(0)
	setmetatable_result1._relativeTransformSpring.s = 25
	setmetatable_result1._relativeTransformSpring.t = 0
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetSpeed(arg1, arg2) -- Line 27
	arg1._relativeTransformSpring.s = arg2
end
function setmetatable_result1_upvr.SetTarget(arg1, arg2) -- Line 31
	arg1._relativeTransformSpring.t = arg2
end
local any_load_result1_result1_upvr = any_load_result1("SpringUtils")
function setmetatable_result1_upvr.Transform(arg1, arg2) -- Line 35
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local any_animating_result1, any_animating_result2 = any_load_result1_result1_upvr.animating(arg1._relativeTransformSpring)
	local arg2_result1 = arg2()
	local any__getTransform_result1 = arg1._getTransform(arg2_result1)
	if any__getTransform_result1 then
		arg1._lastTransform = any__getTransform_result1
	else
		any__getTransform_result1 = arg1._lastTransform
	end
	if not any__getTransform_result1 then
		return nil
	end
	if any_animating_result1 or 0 < any_animating_result2 then
		return arg2_result1:Lerp(any__getTransform_result1, any_animating_result2)
	end
	return nil
end
return setmetatable_result1_upvr