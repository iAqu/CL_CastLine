-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:18
-- Luau version 6, Types version 3
-- Time taken: 0.001242 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_4 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_4)
setmetatable_result1_upvr.ClassName = "HumanoidFaceAnimatorClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("FaceBindersClient")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 16
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_4.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1._serviceBag = arg2
	setmetatable_result1._animatedMouthBinder = arg2:GetService(var1_result1_upvr).AnimatedMouth
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("promiseChild")
local var1_result1_upvr_3 = any_load_result1("promiseBoundClass")
function setmetatable_result1_upvr.PromiseAnimatedMouth(arg1) -- Line 25
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	return arg1._maid:GivePromise(var1_result1_upvr_2(arg1._obj.Parent, "Head")):Then(function(arg1_2) -- Line 28
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_2 (copied, readonly)
		]]
		return arg1._maid:GivePromise(var1_result1_upvr_2(arg1_2, "AnimatedMouth"))
	end):Then(function(arg1_3) -- Line 31
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
		]]
		return arg1._maid:GivePromise(var1_result1_upvr_3(arg1._animatedMouthBinder, arg1_3))
	end)
end
return setmetatable_result1_upvr