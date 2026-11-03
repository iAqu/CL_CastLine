-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:31
-- Luau version 6, Types version 3
-- Time taken: 0.000753 seconds

local module = {}
local tbl_2_upvr = {}
tbl_2_upvr.__index = tbl_2_upvr
local module_upvr = require(script.Parent.Parent:WaitForChild("ChatConstants"))
function tbl_2_upvr.SendSystemMessageToSelf(arg1, arg2, arg3, arg4) -- Line 31
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local tbl = {
		ID = -1;
		FromSpeaker = nil;
		SpeakerUserId = 0;
		OriginalChannel = arg3.Name;
		IsFiltered = true;
		MessageLength = string.len(arg2);
		MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(arg2));
	}
	tbl.Message = arg2
	tbl.MessageType = module_upvr.MessageTypeSystem
	tbl.Time = os.time()
	tbl.ExtraData = arg4
	arg3:AddMessageToChannel(tbl)
end
function module.new() -- Line 50
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, tbl_2_upvr)
	setmetatable_result1.COMMAND_MODULES_VERSION = 1
	setmetatable_result1.KEY_COMMAND_PROCESSOR_TYPE = "ProcessorType"
	setmetatable_result1.KEY_PROCESSOR_FUNCTION = "ProcessorFunction"
	setmetatable_result1.IN_PROGRESS_MESSAGE_PROCESSOR = 0
	setmetatable_result1.COMPLETED_MESSAGE_PROCESSOR = 1
	return setmetatable_result1
end
return module.new()