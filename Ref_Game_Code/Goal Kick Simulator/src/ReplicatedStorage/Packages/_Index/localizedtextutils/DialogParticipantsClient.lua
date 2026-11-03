-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:00
-- Luau version 6, Types version 3
-- Time taken: 0.001036 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "DialogParticipantsClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("DialogBindersClient")
local any_load_result1_result1_upvr = any_load_result1("BoundChildCollection")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 15
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	assert(setmetatable_result1._obj, "Bad parent")
	setmetatable_result1._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1._dialogBindersClient = setmetatable_result1._serviceBag:GetService(var1_result1_upvr)
	setmetatable_result1._participants = any_load_result1_result1_upvr.new(setmetatable_result1._dialogBindersClient.DialogHumanoidParticipant, setmetatable_result1._obj)
	setmetatable_result1._maid:GiveTask(setmetatable_result1._participants)
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetParticipantsBoundCollection(arg1) -- Line 28
	return arg1._participants
end
return setmetatable_result1_upvr