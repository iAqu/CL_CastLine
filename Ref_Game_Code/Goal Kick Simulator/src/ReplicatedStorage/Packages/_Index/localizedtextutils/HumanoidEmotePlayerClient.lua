-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:54
-- Luau version 6, Types version 3
-- Time taken: 0.006572 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_5 = any_load_result1("BaseObject")
local var1_result1_upvr_3 = any_load_result1("HumanoidEmotePlayerConstants")
local var1_result1_upvr = any_load_result1("Promise")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_5)
setmetatable_result1_upvr.ClassName = "HumanoidEmotePlayerClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
any_load_result1("PromiseRemoteEventMixin"):Add(setmetatable_result1_upvr, var1_result1_upvr_3.REMOTE_EVENT_NAME)
local Players_upvr = game:GetService("Players")
local var1_result1_upvr_8 = any_load_result1("AnimationProvider")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 35
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: Players_upvr (readonly)
		[4]: var1_result1_upvr_8 (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_5.new(arg1), setmetatable_result1_upvr)
	if setmetatable_result1:_getPlayer() == Players_upvr.LocalPlayer then
		local _obj = setmetatable_result1._obj
		if _obj then
			_obj = setmetatable_result1._obj:IsA("Animator")
		end
		assert(_obj, "Bad animator")
		setmetatable_result1._animationProvider = arg2:GetService(var1_result1_upvr_8)
		setmetatable_result1:_setupLocal()
	end
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("CharacterUtils")
function setmetatable_result1_upvr._getPlayer(arg1) -- Line 48
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.getPlayerFromCharacter(arg1._obj)
end
function setmetatable_result1_upvr.PlayEmote(arg1, arg2, arg3, arg4) -- Line 60
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local var11
	if type(arg2) ~= "string" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad emoteName")
	if type(arg3) ~= "string" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad guid")
	var11 = true
	if type(arg4) ~= "number" then
		if arg4 ~= nil then
			var11 = false
		else
			var11 = true
		end
	end
	assert(var11, "Bad bleedAmount")
	local var12_upvw = arg4
	if not var12_upvw then
		var11 = var1_result1_upvr_3
		var12_upvw = var11.DEFAULT_BLEND_AMOUNT
	end
	return arg1:_promiseAnimationFromName(arg2):Then(function(arg1_2) -- Line 67
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
			[3]: var12_upvw (read and write)
		]]
		return arg1:_promisePlayEmote(arg1_2, arg3, var12_upvw)
	end, function(arg1_3) -- Line 69
		--[[ Upvalues[1]:
			[1]: arg2 (readonly)
		]]
		warn("[HumanoidEmotePlayerClient.PlayEmote] - Failed to find animation %q (failed with) %q":format(tostring(arg2), tostring(arg1_3)))
	end)
end
local var1_result1_upvr_4 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("HumanoidEmotePlayerLocal")
function setmetatable_result1_upvr._setupLocal(arg1) -- Line 75
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	arg1._pendingPromisesMaid = var1_result1_upvr_4.new()
	arg1._maid:GiveTask(arg1._pendingPromisesMaid)
	arg1._emotePlayer = any_load_result1_result1_upvr.new(arg1._obj)
	arg1._maid:GiveTask(arg1._emotePlayer)
	arg1:PromiseRemoteEvent():Then(function(arg1_4) -- Line 82
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		local var18 = arg1_4
		if not var18 then
			var18 = error("No remoteEvent")
		end
		arg1._remoteEvent = var18
		arg1._maid:GiveTask(arg1_4.OnClientEvent:Connect(function(...) -- Line 85
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1:_handleClientEvent(...)
		end))
	end)
end
local var1_result1_upvr_7 = any_load_result1("HumanoidEmotePlayerClientRequests")
function setmetatable_result1_upvr._handleClientEvent(arg1, arg2, ...) -- Line 91
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_7 (readonly)
	]]
	if arg2 == var1_result1_upvr_7.PLAY_EMOTE then
		arg1:_handlePlayEmoteRequest(...)
	else
		error("[HumanoidEmotePlayerClient._handleClientEvent] - Bad request %q":format(tostring(arg2)))
	end
end
function setmetatable_result1_upvr._promiseAnimationFromName(arg1, arg2) -- Line 100
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var21
	if type(arg2) ~= "string" then
		var21 = false
	else
		var21 = true
	end
	assert(var21, "Bad name")
	local any_Get_result1 = arg1._animationProvider:Get(arg2)
	if not any_Get_result1 then
		var21 = var1_result1_upvr.rejected("No animation with %q found":format(arg2))
		return var21
	end
	var21 = var1_result1_upvr.resolved(any_Get_result1)
	return var21
end
function setmetatable_result1_upvr._handlePlayEmoteRequest(arg1, arg2) -- Line 111
	-- KONSTANTERROR: [0] 1. Error Block 26 start (CF ANALYSIS FAILED)
	local var23
	if type(arg2) ~= "table" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad emoteData")
	if typeof(arg2.animation) ~= "Instance" then
		var23 = false
		-- KONSTANTWARNING: GOTO [25] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 26 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [24] 18. Error Block 29 start (CF ANALYSIS FAILED)
	var23 = true
	assert(var23, "Bad emoteData.animation")
	if type(arg2.guid) ~= "string" then
		var23 = false
		-- KONSTANTWARNING: GOTO [41] #30
	end
	-- KONSTANTERROR: [24] 18. Error Block 29 end (CF ANALYSIS FAILED)
end
local var1_result1_upvr_6 = any_load_result1("HumanoidEmotePlayerServerRequests")
function setmetatable_result1_upvr._promisePlayEmote(arg1, arg2, arg3, arg4) -- Line 120
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_6 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 24 start (CF ANALYSIS FAILED)
	local var25_upvr
	if typeof(arg2) ~= "Instance" then
		var25_upvr = false
	else
		var25_upvr = true
	end
	assert(var25_upvr, "Bad animation")
	if type(arg3) ~= "string" then
		var25_upvr = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 24 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 26 start (CF ANALYSIS FAILED)
	var25_upvr = true
	assert(var25_upvr, "Bad guid")
	if type(arg4) ~= "number" then
		var25_upvr = false
	else
		var25_upvr = true
	end
	assert(var25_upvr, "Bad blendAmount")
	var25_upvr = arg1._pendingPromisesMaid
	local var26 = var25_upvr[arg3]
	if var26 then
		return var26
	end
	var25_upvr = var1_result1_upvr.new()
	var25_upvr:Resolve(arg1._maid:GivePromise(arg1._emotePlayer:PromisePlayAnimation(arg2, arg4)))
	arg1:PromiseRemoteEvent():Then(function(arg1_5) -- Line 135
		--[[ Upvalues[3]:
			[1]: var25_upvr (readonly)
			[2]: var1_result1_upvr_6 (copied, readonly)
			[3]: arg3 (readonly)
		]]
		if var25_upvr:IsPending() then
			arg1_5:FireServer(var1_result1_upvr_6.START_PLAYING_EMOTE, arg3)
		end
	end)
	var25_upvr:Then(function() -- Line 141
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_6 (copied, readonly)
			[3]: arg3 (readonly)
		]]
		return arg1:PromiseRemoteEvent():Then(function(arg1_6) -- Line 142
			--[[ Upvalues[2]:
				[1]: var1_result1_upvr_6 (copied, readonly)
				[2]: arg3 (copied, readonly)
			]]
			arg1_6:FireServer(var1_result1_upvr_6.SUCCEED_PLAYING_EMOTE, arg3)
		end)
	end, function(arg1_7) -- Line 145
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_6 (copied, readonly)
			[3]: arg3 (readonly)
		]]
		return arg1:PromiseRemoteEvent():Then(function(arg1_8) -- Line 146
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_6 (copied, readonly)
				[2]: arg3 (copied, readonly)
				[3]: arg1_7 (readonly)
			]]
			arg1_8:FireServer(var1_result1_upvr_6.FAIL_PLAYING_EMOTE, arg3, arg1_7)
		end)
	end)
	arg1._pendingPromisesMaid[arg3] = var25_upvr
	var25_upvr:Finally(function() -- Line 152
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
		]]
		arg1._pendingPromisesMaid[arg3] = nil
	end)
	do
		return var25_upvr
	end
	-- KONSTANTERROR: [23] 18. Error Block 26 end (CF ANALYSIS FAILED)
end
return setmetatable_result1_upvr