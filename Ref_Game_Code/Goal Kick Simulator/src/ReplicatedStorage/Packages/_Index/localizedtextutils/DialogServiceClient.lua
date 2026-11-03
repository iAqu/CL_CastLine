-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:28
-- Luau version 6, Types version 3
-- Time taken: 0.003808 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1_upvr("Maid")
local module = {
	ServiceName = "DialogServiceClient";
}
local var1_result1_upvr = any_load_result1_upvr("StateStack")
function module.Init(arg1, arg2) -- Line 24
	--[[ Upvalues[3]:
		[1]: any_load_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	assert(not arg1._maid, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._serviceBag:GetService(any_load_result1_upvr("BusyCharacterServiceClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("FaceBindersClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("GuiThemeService"))
	arg1._serviceBag:GetService(any_load_result1_upvr("HintInputServiceClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("HumanoidEmotePlayerBindersClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("IdleServiceClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("TextFilterServiceClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("SharedInputKeyMap"))
	arg1._serviceBag:GetService(any_load_result1_upvr("DialogTemplatesClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("DialogBindersClient"))
	arg1._serviceBag:GetService(any_load_result1_upvr("DialogTranslator"))
	arg1._serviceBag:GetService(any_load_result1_upvr("DialogInputKeyMap"))
	arg1._maid = var1_result1_upvr_3.new()
	arg1._dialogVisibleStack = var1_result1_upvr.new(false)
	arg1._maid:GiveTask(arg1._dialogVisibleStack)
	arg1.DialogVisibleChanged = assert(arg1._dialogVisibleStack.Changed, "Bad changed event")
end
local any_load_result1_upvr_result1_upvr_2 = any_load_result1_upvr("DialogBindersClient")
function module.Start(arg1) -- Line 56
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr_result1_upvr_2 (readonly)
	]]
	local DialogSession = arg1._serviceBag:GetService(any_load_result1_upvr_result1_upvr_2).DialogSession
	arg1._maid:GiveTask(DialogSession:GetClassAddedSignal():Connect(function(arg1_2, arg2) -- Line 60
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleNewRemoteSession(arg1_2)
	end))
	for _, v in pairs(DialogSession:GetAll()) do
		arg1:_handleNewRemoteSession(v)
	end
end
function module.IsDialogVisible(arg1) -- Line 73
	return arg1._dialogVisibleStack:GetState()
end
local any_load_result1_upvr_result1_upvr = any_load_result1_upvr("LocalDialogSessionClient")
local any_load_result1_upvr_result1_upvr_4 = any_load_result1_upvr("Promise")
function module.PromiseLocalSession(arg1) -- Line 81
	--[[ Upvalues[2]:
		[1]: any_load_result1_upvr_result1_upvr (readonly)
		[2]: any_load_result1_upvr_result1_upvr_4 (readonly)
	]]
	local any_new_result1_upvr = any_load_result1_upvr_result1_upvr.new(arg1._serviceBag)
	any_new_result1_upvr:GetPromiseIsShown():Then(function() -- Line 84
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		arg1:_setCurrentDialogSession(any_new_result1_upvr, true)
	end)
	return any_load_result1_upvr_result1_upvr_4.resolved(any_new_result1_upvr)
end
function module._handleNewRemoteSession(arg1, arg2) -- Line 91
	assert(arg2, "Bad session")
	if arg2:IsLocalPlayerParticipant() then
		arg1:_setCurrentDialogSession(arg2, false)
	end
end
local any_load_result1_upvr_result1_upvr_3 = any_load_result1_upvr("IdleServiceClient")
local var1_result1_upvr_2 = any_load_result1_upvr("BusyCharacterServiceClient")
function module._setCurrentDialogSession(arg1, arg2, arg3) -- Line 99
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: any_load_result1_upvr_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	assert(arg2, "Bad session")
	local any_new_result1_upvr_3 = var1_result1_upvr_3.new()
	any_new_result1_upvr_3:GiveTask(arg2)
	local any_new_result1_upvr_2 = var1_result1_upvr_3.new()
	any_new_result1_upvr_3:GiveTask(function() -- Line 106
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		task.delay(0.4, function() -- Line 108
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_2 (copied, readonly)
			]]
			any_new_result1_upvr_2:DoCleaning()
		end)
	end)
	any_new_result1_upvr_3:GiveTask(arg1._dialogVisibleStack:PushState(true))
	any_new_result1_upvr_3:GiveTask(arg1._serviceBag:GetService(any_load_result1_upvr_result1_upvr_3):PushDisable())
	if arg3 then
		any_new_result1_upvr_3:GiveTask(arg1._serviceBag:GetService(var1_result1_upvr_2):MarkAsBusy())
	end
	any_new_result1_upvr_3:GiveTask(arg2.SessionOver:Connect(function() -- Line 127
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr_3 (readonly)
		]]
		if arg1._maid._currentDialogSession == any_new_result1_upvr_3 then
			arg1._maid._currentDialogSession = nil
		end
	end))
	arg1._maid._currentDialogSession = any_new_result1_upvr_3
end
return module