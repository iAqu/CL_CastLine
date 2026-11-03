-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:04
-- Luau version 6, Types version 3
-- Time taken: 0.000924 seconds

local var1_upvr = require(script.Parent.loader).load(script)("IKGripBase")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_upvr)
setmetatable_result1_upvr_2.ClassName = "IKRightGrip"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 14
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_upvr.new(arg1, arg2), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr:PromiseIKRig():Then(function(arg1_2) -- Line 18
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		return setmetatable_result1_upvr._maid:GivePromise(arg1_2:PromiseRightArm())
	end):Then(function(arg1_3) -- Line 21
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._maid:GiveTask(arg1_3:Grip(setmetatable_result1_upvr:GetAttachment(), setmetatable_result1_upvr:GetPriority()))
	end)
	return setmetatable_result1_upvr
end
return setmetatable_result1_upvr_2