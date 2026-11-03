-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:36
-- Luau version 6, Types version 3
-- Time taken: 0.003963 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr_3 = any_load_result1("StateStack")
local module = {
	ServiceName = "BusyCharacterServiceClient";
}
local var1_result1_upvr_7 = any_load_result1("AnimatedSpriteProvider")
local var1_result1_upvr_4 = any_load_result1("GuiThemeService")
local any_load_result1_result1_upvr_3 = any_load_result1("BusyCharacterTemplatesClient")
local var1_result1_upvr_9 = any_load_result1("BusyCharacterBindersClient")
function module.Init(arg1, arg2) -- Line 28
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr_9 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
		[6]: var1_result1_upvr_3 (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._serviceBag:GetService(var1_result1_upvr_7)
	arg1._serviceBag:GetService(var1_result1_upvr_4)
	arg1._serviceBag:GetService(any_load_result1_result1_upvr_3)
	arg1._bindersClient = arg1._serviceBag:GetService(var1_result1_upvr_9)
	arg1._maid = var1_result1_upvr_5.new()
	arg1._isBusyStack = var1_result1_upvr_3.new(false)
	arg1._maid:GiveTask(arg1._isBusyStack)
	arg1.IsBusyChanged = arg1._isBusyStack.Changed
	arg1._maid:GiveTask(arg1:_observeBusyCharacterBrio():Subscribe(function(arg1_2) -- Line 48
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_2:IsDead() then
		else
			arg1_2:ToMaid():GiveTask(arg1._isBusyStack:PushState(true))
		end
	end))
	arg1:_setupLocalStack()
end
function module.IsBusy(arg1) -- Line 64
	assert(arg1._serviceBag, "Not initialized")
	return arg1._isBusyStack:GetState()
end
local var1_result1_upvr_2 = any_load_result1("Observable")
local var1_result1_upvr = any_load_result1("Brio")
function module.ObserveNotBusyBrio(arg1) -- Line 74
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr_2.new(function(arg1_3) -- Line 75
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_5 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var1_result1_upvr (copied, readonly)
		]]
		local any_new_result1_3_upvr = var1_result1_upvr_5.new()
		any_new_result1_3_upvr:GiveTask(arg1._isBusyStack.Changed:Connect(function() -- Line 78, Named "emit"
			--[[ Upvalues[4]:
				[1]: arg1 (copied, readonly)
				[2]: any_new_result1_3_upvr (readonly)
				[3]: var1_result1_upvr (copied, readonly)
				[4]: arg1_3 (readonly)
			]]
			if arg1._isBusyStack:GetState() then
				any_new_result1_3_upvr._current = nil
			else
				local any_new_result1 = var1_result1_upvr.new(true)
				arg1_3:Fire(any_new_result1)
				any_new_result1_3_upvr._current = any_new_result1
			end
		end))
		if arg1._isBusyStack:GetState() then
			any_new_result1_3_upvr._current = nil
			return any_new_result1_3_upvr
		end
		local any_new_result1_2 = var1_result1_upvr.new(true)
		arg1_3:Fire(any_new_result1_2)
		any_new_result1_3_upvr._current = any_new_result1_2
		return any_new_result1_3_upvr
	end)
end
function module.PushStateWhileBusy(arg1, arg2) -- Line 101
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	assert(arg1._serviceBag, "Not initialized")
	assert(arg2, "No disabledStack")
	assert(arg2.PushState, "No PushState")
	local any_new_result1_upvr = var1_result1_upvr_5.new()
	local function update() -- Line 108
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: arg2 (readonly)
		]]
		if arg1:IsBusy() then
			any_new_result1_upvr._disabled = arg2:PushState(true)
		else
			any_new_result1_upvr._disabled = nil
		end
	end
	any_new_result1_upvr:GiveTask(arg1.IsBusyChanged:Connect(update))
	if arg1:IsBusy() then
		any_new_result1_upvr._disabled = arg2:PushState(true)
		return any_new_result1_upvr
	end
	any_new_result1_upvr._disabled = nil
	return any_new_result1_upvr
end
local RunService_upvr = game:GetService("RunService")
function module.MarkAsBusy(arg1) -- Line 126
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() and not arg1._localBusyStack then
		return function() -- Line 128
		end
	end
	assert(arg1._localBusyStack, "Not initialized")
	return arg1._localBusyStack:PushState(true)
end
local var1_result1_upvr_8 = any_load_result1("PromiseGetRemoteEvent")
local var1_result1_upvr_10 = any_load_result1("BusyCharacterConstants")
function module._setupLocalStack(arg1) -- Line 136
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_8 (readonly)
		[3]: var1_result1_upvr_10 (readonly)
	]]
	arg1._localBusyStack = var1_result1_upvr_3.new(false)
	arg1._maid:GiveTask(arg1._localBusyStack)
	arg1._maid:GivePromise(var1_result1_upvr_8(var1_result1_upvr_10.GLOBAL_REMOTE_EVENT_NAME)):Then(function(arg1_4) -- Line 143
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._maid:GiveTask(arg1._localBusyStack.Changed:Connect(function() -- Line 144
			--[[ Upvalues[2]:
				[1]: arg1_4 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			arg1_4:FireServer(arg1._localBusyStack:GetState())
		end))
	end)
	arg1._maid:GiveTask(arg1._localBusyStack.Changed:Connect(function() -- Line 149, Named "update"
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1._localBusyStack:GetState() then
			arg1._maid._localBinding = arg1._isBusyStack:PushState(true)
		else
			arg1._maid._localBinding = nil
		end
	end))
	if arg1._localBusyStack:GetState() then
		arg1._maid._localBinding = arg1._isBusyStack:PushState(true)
	else
		arg1._maid._localBinding = nil
	end
end
local var1_result1_upvr_6 = any_load_result1("RxInstanceUtils")
local Players_upvr = game:GetService("Players")
local any_load_result1_result1_upvr_2 = any_load_result1("Rx")
local any_load_result1_result1_upvr = any_load_result1("RxBinderUtils")
function module._observeBusyCharacterBrio(arg1) -- Line 160
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: Players_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	return var1_result1_upvr_6.observeProperty(Players_upvr.LocalPlayer, "Character"):Pipe({any_load_result1_result1_upvr_2.switchMap(function(arg1_5) -- Line 163
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		if arg1_5 then
			return any_load_result1_result1_upvr.observeBoundClassBrio(arg1._bindersClient.BusyCharacter, arg1_5)
		end
		return any_load_result1_result1_upvr_2.EMPTY
	end)})
end
return module