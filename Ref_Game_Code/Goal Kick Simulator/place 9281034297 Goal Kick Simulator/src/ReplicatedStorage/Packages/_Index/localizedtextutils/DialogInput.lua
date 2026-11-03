-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:00
-- Luau version 6, Types version 3
-- Time taken: 0.003130 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "DialogInput"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("DialogInputKeyMap")
local HttpService_upvr = game:GetService("HttpService")
local any_load_result1_result1_upvr_3 = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1) -- Line 21
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: HttpService_upvr (readonly)
		[5]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1_upvr_2._dialogInputKeyMap = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr)
	setmetatable_result1_upvr_2._actionKey = HttpService_upvr:GenerateGUID(false).."_DialogInput"
	setmetatable_result1_upvr_2.RequestedNextInput = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.RequestedNextInput)
	setmetatable_result1_upvr_2._enabled = Instance.new("BoolValue")
	setmetatable_result1_upvr_2._enabled.Value = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._enabled)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._enabled.Changed:Connect(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if setmetatable_result1_upvr_2._enabled.Value then
			setmetatable_result1_upvr_2:_bindInput()
		else
			setmetatable_result1_upvr_2:_unbindInput()
		end
	end))
	setmetatable_result1_upvr_2._inputKeyMapList = setmetatable_result1_upvr_2._dialogInputKeyMap:GetInputKeyMapList("ADVANCE_DIALOG")
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetEnabled(arg1, arg2) -- Line 48
	local var9
	if type(arg2) ~= "boolean" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad value")
	arg1._enabled.Value = arg2
end
function setmetatable_result1_upvr._unbindInput(arg1) -- Line 54
	arg1._maid._inputMaid = nil
end
local any_load_result1_result1_upvr = any_load_result1("Maid")
local UserInputService_upvr = game:GetService("UserInputService")
local any_load_result1_result1_upvr_4 = any_load_result1("Rx")
local ContextActionService_upvr = game:GetService("ContextActionService")
function setmetatable_result1_upvr._bindInput(arg1) -- Line 58
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: ContextActionService_upvr (readonly)
	]]
	if arg1._maid._inputMaid then
		error("[DialogInput._bindInput] - Input already bound")
	end
	local any_new_result1_upvr = any_load_result1_result1_upvr.new()
	any_new_result1_upvr:GiveTask(UserInputService_upvr.TouchTap:Connect(function(arg1_2, arg2) -- Line 65
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.RequestedNextInput:Fire()
	end))
	any_new_result1_upvr:GiveTask(any_load_result1_result1_upvr_4.combineLatest({
		isRobloxTouchButton = arg1._inputKeyMapList:ObserveIsRobloxTouchButton();
		inputEnumsList = arg1._inputKeyMapList:ObserveInputEnumsList();
	}):Subscribe(function(arg1_3) -- Line 72
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: ContextActionService_upvr (copied, readonly)
			[4]: arg1 (readonly)
		]]
		any_new_result1_upvr._contextMaid = nil
		local any_new_result1 = any_load_result1_result1_upvr.new()
		ContextActionService_upvr:BindActionAtPriority(arg1._actionKey, function(arg1_4, arg2, arg3) -- Line 78
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			if arg2 == Enum.UserInputState.Begin then
				arg1.RequestedNextInput:Fire()
			end
		end, arg1_3.isRobloxTouchButton, Enum.ContextActionPriority.Medium.Value + 1, unpack(arg1_3.inputEnumsList))
		any_new_result1:GiveTask(function() -- Line 87
			--[[ Upvalues[2]:
				[1]: ContextActionService_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			ContextActionService_upvr:UnbindAction(arg1._actionKey)
		end)
		any_new_result1_upvr._contextMaid = any_new_result1
	end))
	any_new_result1_upvr:GiveTask(arg1._inputKeyMapList:ObserveIsTapInWorld():Subscribe(function(arg1_5) -- Line 94
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr (readonly)
			[2]: UserInputService_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		if arg1_5 then
			any_new_result1_upvr._tapInWorldEvent = UserInputService_upvr.TouchTapInWorld:Connect(function(arg1_6, arg2) -- Line 96
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				if not arg2 then
					arg1.RequestedNextInput:Fire()
				end
			end)
		else
			any_new_result1_upvr._tapInWorldEvent = nil
		end
	end))
	arg1._maid._inputMaid = any_new_result1_upvr
end
function setmetatable_result1_upvr.GetInputKeyMapList(arg1) -- Line 109
	return arg1._inputKeyMapList
end
return setmetatable_result1_upvr