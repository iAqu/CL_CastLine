-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:24
-- Luau version 6, Types version 3
-- Time taken: 0.000633 seconds

local var1_upvr = require(script.Parent.loader).load(script)("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_upvr.ClassName = "DialogHumanoidParticipantBase"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1) -- Line 13
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	return setmetatable(var1_upvr.new(arg1), setmetatable_result1_upvr)
end
function setmetatable_result1_upvr.GetHumanoid(arg1) -- Line 19
	return arg1._obj.Value
end
function setmetatable_result1_upvr.GetKey(arg1) -- Line 23
	return arg1._obj.Name
end
return setmetatable_result1_upvr