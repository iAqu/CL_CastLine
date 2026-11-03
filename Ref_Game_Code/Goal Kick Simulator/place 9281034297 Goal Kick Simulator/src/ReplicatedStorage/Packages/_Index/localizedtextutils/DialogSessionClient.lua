-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:27
-- Luau version 6, Types version 3
-- Time taken: 0.005680 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("DialogServerSessionEvents")
local any_load_result1_result1_upvr = any_load_result1("LocalDialogSessionClient")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr)
setmetatable_result1_upvr_2.ClassName = "DialogSessionClient"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_4 = any_load_result1("DialogParticipantsClient")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 22
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
	]]
	assert(arg2, "No serviceBag")
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr.new(arg2), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg2, "No serviceBag")
	local var7 = arg1
	if not var7 then
		var7 = error("No remoteEvent")
	end
	setmetatable_result1_upvr._remoteEvent = var7
	var7 = setmetatable_result1_upvr._remoteEvent.Parent
	local var8 = var7
	if not var8 then
		var8 = error("No player")
	end
	setmetatable_result1_upvr._player = var8
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._remoteEvent.OnClientEvent:Connect(function(...) -- Line 31
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_handleClientEvent(...)
	end))
	setmetatable_result1_upvr._maid:GiveTask(function() -- Line 35
		--[[ Upvalues[2]:
			[1]: setmetatable_result1_upvr (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		setmetatable_result1_upvr._remoteEvent:FireServer(any_load_result1_result1_upvr_2.SESSION_ENDED)
	end)
	if setmetatable_result1_upvr:IsLocalPlayerParticipant() then
		setmetatable_result1_upvr._participants = any_load_result1_result1_upvr_4.new(setmetatable_result1_upvr._remoteEvent, setmetatable_result1_upvr._serviceBag)
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._participants)
	end
	return setmetatable_result1_upvr
end
local Players_upvr = game:GetService("Players")
function setmetatable_result1_upvr_2.IsLocalPlayerParticipant(arg1) -- Line 62
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local var12
	if arg1:_getPlayer() ~= Players_upvr.LocalPlayer then
		var12 = false
	else
		var12 = true
	end
	return var12
end
function setmetatable_result1_upvr_2._getPlayer(arg1) -- Line 66
	return arg1._player
end
function setmetatable_result1_upvr_2.ShowChoices(arg1, arg2, ...) -- Line 70
	--[[ Upvalues[2]:
		[1]: setmetatable_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_ShowChoices_result1 = getmetatable(setmetatable_result1_upvr_2).ShowChoices(arg1, arg2, ...)
	any_ShowChoices_result1:Then(function(arg1_2) -- Line 73
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		local var15
		if type(arg1_2) ~= "table" then
			var15 = false
		else
			var15 = true
		end
		assert(var15, "Bad choice")
		if type(arg1_2.key) ~= "string" then
			var15 = false
		else
			var15 = true
		end
		assert(var15, "Bad choice.key")
		var15 = arg1
		var15._remoteEvent:FireServer(any_load_result1_result1_upvr_2.CHOICE_SELECTED, arg2, arg1_2)
	end):Catch(function() -- Line 78
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.CHOICE_SELECTION_FAILED, arg2)
	end)
	return any_ShowChoices_result1
end
function setmetatable_result1_upvr_2.ShowSlider(arg1, arg2) -- Line 85
	--[[ Upvalues[2]:
		[1]: setmetatable_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_ShowSlider_result1 = getmetatable(setmetatable_result1_upvr_2).ShowSlider(arg1, arg2)
	any_ShowSlider_result1:Then(function(arg1_3) -- Line 88
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.SLIDER_SELECTED, arg2, arg1_3)
	end):Catch(function() -- Line 90
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.SLIDER_SELECTION_FAILED, arg2)
	end)
	return any_ShowSlider_result1
end
function setmetatable_result1_upvr_2.ShowTextBox(arg1, arg2) -- Line 97
	--[[ Upvalues[2]:
		[1]: setmetatable_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_ShowTextBox_result1 = getmetatable(setmetatable_result1_upvr_2).ShowTextBox(arg1, arg2)
	any_ShowTextBox_result1:Then(function(arg1_4) -- Line 100
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.TEXT_BOX_INPUT, arg2, arg1_4)
	end):Catch(function() -- Line 102
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.TEXT_BOX_INPUT_FAILED, arg2)
	end)
	return any_ShowTextBox_result1
end
function setmetatable_result1_upvr_2.ShowText(arg1, arg2, ...) -- Line 109
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr_2 (readonly)
	]]
	return arg1:_handleShowTextPromise(arg2, getmetatable(setmetatable_result1_upvr_2).ShowText(arg1, arg2, ...))
end
function setmetatable_result1_upvr_2.ShowRawText(arg1, arg2, ...) -- Line 115
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr_2 (readonly)
	]]
	return arg1:_handleShowTextPromise(arg2, getmetatable(setmetatable_result1_upvr_2)._showRawText(arg1, arg2, ...))
end
local any_load_result1_result1_upvr_3 = any_load_result1("Promise")
function setmetatable_result1_upvr_2.EndSession(arg1) -- Line 125
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.SESSION_END_REQUEST)
	return any_load_result1_result1_upvr_3.rejected()
end
function setmetatable_result1_upvr_2._handleShowTextPromise(arg1, arg2, arg3) -- Line 131
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	arg3:Then(function() -- Line 132
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_2 (copied, readonly)
			[3]: arg2 (readonly)
		]]
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.DONE_SHOWING_TEXT, arg2)
	end):Catch(function(arg1_5) -- Line 134
		--[[ Upvalues[3]:
			[1]: arg2 (readonly)
			[2]: arg1 (readonly)
			[3]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		warn("[DialogSessionClient] - Failed to show text %q due to %q":format(arg2, tostring(arg1_5)))
		arg1._remoteEvent:FireServer(any_load_result1_result1_upvr_2.SHOWING_TEXT_FAILED, arg2)
	end)
	return arg3
end
local any_load_result1_result1_upvr_5 = any_load_result1("DialogClientSessionEvents")
function setmetatable_result1_upvr_2._handleClientEvent(arg1, arg2, ...) -- Line 142
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local var27
	if type(arg2) ~= "string" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "Bad request")
	var27 = any_load_result1_result1_upvr_5
	if arg2 == var27.SHOW_TEXT then
		arg1:ShowText(...)
	else
		var27 = any_load_result1_result1_upvr_5
		if arg2 == var27.SHOW_CHOICES then
			arg1:ShowChoices(...)
			return
		end
		var27 = any_load_result1_result1_upvr_5
		if arg2 == var27.SHOW_SLIDER then
			arg1:ShowSlider(...)
			return
		end
		var27 = any_load_result1_result1_upvr_5
		if arg2 == var27.SHOW_RAW_TEXT then
			arg1:ShowRawText(...)
			return
		end
		var27 = any_load_result1_result1_upvr_5
		if arg2 == var27.SHOW_TEXT_BOX then
			arg1:ShowTextBox(...)
			return
		end
		var27 = "[DialogSessionClient._handleClientEvent] - Unknown request %q":format(tostring(arg2))
		warn(var27)
	end
end
return setmetatable_result1_upvr_2