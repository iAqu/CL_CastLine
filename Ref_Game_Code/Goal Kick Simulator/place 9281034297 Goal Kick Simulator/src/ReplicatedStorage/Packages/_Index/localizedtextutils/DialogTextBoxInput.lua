-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:20
-- Luau version 6, Types version 3
-- Time taken: 0.002074 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_upvr.ClassName = "DialogTextBoxInput"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local HttpService_upvr = game:GetService("HttpService")
local var1_result1_upvr_2 = any_load_result1("DialogInputKeyMap")
local var1_result1_upvr_3 = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1) -- Line 18
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: HttpService_upvr (readonly)
		[4]: var1_result1_upvr_2 (readonly)
		[5]: var1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(), setmetatable_result1_upvr)
	setmetatable_result1._key = "DialogTextBoxInput_"..HttpService_upvr:GenerateGUID(false)
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1._dialogInputKeyMap = setmetatable_result1._serviceBag:GetService(var1_result1_upvr_2)
	setmetatable_result1.ToggleFocusTextbox = var1_result1_upvr_3.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ToggleFocusTextbox)
	setmetatable_result1.ConfirmRequest = var1_result1_upvr_3.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ConfirmRequest)
	setmetatable_result1:_bind()
	return setmetatable_result1
end
local ContextActionService_upvr = game:GetService("ContextActionService")
function setmetatable_result1_upvr._bind(arg1) -- Line 37
	--[[ Upvalues[1]:
		[1]: ContextActionService_upvr (readonly)
	]]
	arg1._maid:GiveTask(arg1._dialogInputKeyMap:GetInputKeyMapList("DIALOG_SELECT_TEXTBOX"):ObserveInputEnumsList():Subscribe(function(arg1_2) -- Line 41
		--[[ Upvalues[2]:
			[1]: ContextActionService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		ContextActionService_upvr:BindActionAtPriority(arg1._key.."ToggleFocus", function(arg1_3, arg2, arg3) -- Line 43
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			if arg2 == Enum.UserInputState.End then
				arg1.ToggleFocusTextbox:Fire()
			end
		end, false, Enum.ContextActionPriority.High.Value, unpack(arg1_2))
	end))
	arg1._maid:GiveTask(arg1._dialogInputKeyMap:GetInputKeyMapList("DIALOG_CONFIRM_SHORTCUT"):ObserveInputEnumsList():Subscribe(function(arg1_4) -- Line 53
		--[[ Upvalues[2]:
			[1]: ContextActionService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		ContextActionService_upvr:BindActionAtPriority(arg1._key.."Confirm", function(arg1_5, arg2, arg3) -- Line 55
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			if arg2 == Enum.UserInputState.End then
				arg1.ConfirmRequest:Fire()
			end
		end, false, Enum.ContextActionPriority.High.Value, unpack(arg1_4))
	end))
	arg1._maid:GiveTask(function() -- Line 65
		--[[ Upvalues[2]:
			[1]: ContextActionService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		ContextActionService_upvr:UnbindAction(arg1._key.."ToggleFocus")
		ContextActionService_upvr:UnbindAction(arg1._key.."Confirm")
	end)
end
return setmetatable_result1_upvr