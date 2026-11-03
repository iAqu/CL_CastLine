-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:19
-- Luau version 6, Types version 3
-- Time taken: 0.005847 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_7 = any_load_result1("DialogHumanoidParticipantBase")
local var1_result1_upvr_2 = any_load_result1("Maid")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_7)
setmetatable_result1_upvr_2.ClassName = "DialogHumanoidParticipantClient"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
any_load_result1("PromiseRemoteEventMixin"):Add(setmetatable_result1_upvr_2, any_load_result1("DialogHumanoidParticipantConstants").REMOTE_EVENT_NAME)
local var1_result1_upvr_8 = any_load_result1("DialogBindersClient")
local var1_result1_upvr_3 = any_load_result1("HumanoidEmotePlayerBindersClient")
local var1_result1_upvr_10 = any_load_result1("FaceBindersClient")
local var1_result1_upvr_9 = any_load_result1("promiseBoundClass")
local var1_result1_upvr_6 = any_load_result1("promisePropertyValue")
local var1_result1_upvr = any_load_result1("CharacterUtils")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 28
	--[[ Upvalues[8]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_8 (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: var1_result1_upvr_10 (readonly)
		[6]: var1_result1_upvr_9 (readonly)
		[7]: var1_result1_upvr_6 (readonly)
		[8]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_7.new(arg1), setmetatable_result1_upvr_2)
	assert(setmetatable_result1_upvr._obj.Parent, "No parent")
	setmetatable_result1_upvr._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1_upvr._dialogSessionBinder = arg2:GetService(var1_result1_upvr_8).DialogSession
	setmetatable_result1_upvr._humanoidEmotePlayerBinder = arg2:GetService(var1_result1_upvr_3).HumanoidEmotePlayer
	setmetatable_result1_upvr._playerfaceAnimatorBinder = arg2:GetService(var1_result1_upvr_10).HumanoidFaceAnimator
	setmetatable_result1_upvr._promiseDialogSession = var1_result1_upvr_9(setmetatable_result1_upvr._dialogSessionBinder, setmetatable_result1_upvr._obj.Parent)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._promiseDialogSession)
	setmetatable_result1_upvr._promiseHumanoid = var1_result1_upvr_6(setmetatable_result1_upvr._obj, "Value")
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._promiseHumanoid)
	setmetatable_result1_upvr._promiseHumanoid:Then(function(arg1_2) -- Line 45
		--[[ Upvalues[3]:
			[1]: setmetatable_result1_upvr (readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: var1_result1_upvr_9 (copied, readonly)
		]]
		setmetatable_result1_upvr._humanoid = arg1_2
		setmetatable_result1_upvr._player = var1_result1_upvr.getPlayerFromCharacter(arg1_2)
		local var8_result1 = var1_result1_upvr_9(setmetatable_result1_upvr._playerfaceAnimatorBinder, arg1_2)
		setmetatable_result1_upvr._maid:GiveTask(var8_result1)
		return var8_result1
	end):Then(function(arg1_3) -- Line 55
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		return setmetatable_result1_upvr._maid:GivePromise(arg1_3:PromiseAnimatedMouth())
	end):Then(function(arg1_4) -- Line 58
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		local var16 = arg1_4
		if not var16 then
			var16 = error("No animatedMouth")
		end
		setmetatable_result1_upvr._animatedMouth = var16
		setmetatable_result1_upvr:_tryStartEnumerateLoop()
	end)
	setmetatable_result1_upvr._promiseDialogSession:Then(function(arg1_5) -- Line 63
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_handleDialogSession(arg1_5)
	end)
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.PromiseHumanoid(arg1) -- Line 70
	return arg1._promiseHumanoid
end
local var1_result1_upvr_4 = any_load_result1("DialogHumanoidParticipantEventTypes")
function setmetatable_result1_upvr_2._handleHumanoidParticipantEvent(arg1, arg2) -- Line 74
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	local var19
	if type(arg2) ~= "table" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad event")
	var19 = var1_result1_upvr_4.PLAY_EMOTE
	if arg2.type == var19 then
		arg1:_handlePlayEmote(arg2)
	elseif arg2.type then
		var19 = "[DialogHumanoidParticipantClient._handleHumanoidParticipantEvent] - Bad event %q":format(tostring(arg2.type))
		warn(var19)
	else
		var19 = "[DialogHumanoidParticipantClient._handleHumanoidParticipantEvent] - No event.type"
		warn(var19)
	end
	arg1:PromiseRemoteEvent():Then(function(arg1_6) -- Line 88
		--[[ Upvalues[1]:
			[1]: arg2 (readonly)
		]]
		arg1_6:FireServer(arg2)
	end)
end
local Players_upvr = game:GetService("Players")
local var1_result1_upvr_5 = any_load_result1("HumanoidEmotePlayerUtils")
function setmetatable_result1_upvr_2._handlePlayEmote(arg1, arg2) -- Line 121
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 37 start (CF ANALYSIS FAILED)
	local var23
	if type(arg2.entityKey) ~= "string" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad event.entityKey")
	if type(arg2.emoteName) ~= "string" then
		var23 = false
		-- KONSTANTWARNING: GOTO [26] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 37 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [25] 18. Error Block 39 start (CF ANALYSIS FAILED)
	var23 = true
	assert(var23, "Bad event.emoteName")
	if type(arg2.emoteGuid) ~= "string" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad event.emoteGuid")
	var23 = arg1:GetKey()
	if arg2.entityKey ~= var23 then
	else
		if not arg1._humanoid then return end
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var23 = Players_upvr.LocalPlayer
			return arg1._player ~= var23
		end
		if not arg1._player or INLINED() then return end
		var23 = var1_result1_upvr_5
		var23 = arg1._humanoidEmotePlayerBinder
		local any_getForHumanoid_result1 = var23.getForHumanoid(var23, arg1._humanoid)
		if not any_getForHumanoid_result1 then
			var23 = warn
			var23("[DialogHumanoidParticipantClient._handlePlayEmote] - No emotePlayer for local humanoid")
			return
		end
		var23 = any_getForHumanoid_result1:PlayEmote
		var23(arg2.emoteName, arg2.emoteGuid, arg2.blendAmount)
		-- KONSTANTERROR: [25] 18. Error Block 39 end (CF ANALYSIS FAILED)
	end
end
function setmetatable_result1_upvr_2._handleDialogSession(arg1, arg2) -- Line 150
	assert(not arg1._dialogSession, "Already initialized")
	local var25 = arg2
	if not var25 then
		var25 = error("No dialogSession")
	end
	arg1._dialogSession = var25
	arg1._maid:GiveTask(arg1._dialogSession.CurrentTextRenderer.Changed:Connect(function() -- Line 155
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_tryStartEnumerateLoop()
		arg1:_tryListenForParticipantEvent()
	end))
	arg1:_tryStartEnumerateLoop()
	arg1:_tryListenForParticipantEvent()
end
function setmetatable_result1_upvr_2._tryListenForParticipantEvent(arg1) -- Line 163
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if not arg1._dialogSession then
		arg1._maid._participantMaid = nil
	else
		local Value = arg1._dialogSession.CurrentTextRenderer.Value
		if not Value then
			arg1._maid._participantMaid = nil
			return
		end
		local any_new_result1_2 = var1_result1_upvr_2.new()
		any_new_result1_2:GiveTask(Value.HumanoidParticipantEvent:Connect(function(arg1_7) -- Line 177
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_handleHumanoidParticipantEvent(arg1_7)
		end))
		arg1._maid._participantMaid = any_new_result1_2
	end
end
function setmetatable_result1_upvr_2._tryStartEnumerateLoop(arg1) -- Line 184
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if not arg1._dialogSession then
		arg1._maid._enumerateLoopMaid = nil
	else
		local Value_2 = arg1._dialogSession.CurrentTextRenderer.Value
		if not Value_2 then
			arg1._maid._enumerateLoopMaid = nil
			return
		end
		if not arg1._animatedMouth then
			arg1._maid._enumerateLoopMaid = nil
			return
		end
		local any_new_result1 = var1_result1_upvr_2.new()
		any_new_result1:GiveTask(Value_2.WritingText:Connect(function(arg1_8, arg2, arg3, arg4, arg5) -- Line 203
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg5 == arg1:GetKey() then
				arg1._animatedMouth:EnumerateTextStep(arg1_8, arg2, arg3, arg4)
			end
		end))
		any_new_result1:GiveTask(function() -- Line 209
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1._animatedMouth.Destroy then
				arg1._animatedMouth:Close()
			end
		end)
		arg1._maid._enumerateLoopMaid = any_new_result1
	end
end
return setmetatable_result1_upvr_2