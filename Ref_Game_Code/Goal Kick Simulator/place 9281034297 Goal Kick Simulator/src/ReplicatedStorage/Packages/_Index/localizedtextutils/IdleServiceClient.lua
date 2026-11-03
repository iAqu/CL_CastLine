-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:34
-- Luau version 6, Types version 3
-- Time taken: 0.006393 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local var1_result1_upvr_2 = any_load_result1_upvr("Maid")
local var1_result1_upvr = any_load_result1_upvr("RxValueBaseUtils")
local module = {
	ServiceName = "IdleServiceClient";
}
local var1_result1_upvr_3 = any_load_result1_upvr("RagdollBindersClient")
local var1_result1_upvr_6 = any_load_result1_upvr("StateStack")
local var1_result1_upvr_5 = any_load_result1_upvr("ValueObject")
function module.Init(arg1, arg2) -- Line 30
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: any_load_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr_6 (readonly)
		[5]: var1_result1_upvr_5 (readonly)
	]]
	assert(not arg1._maid, "Already initialized")
	arg1._maid = var1_result1_upvr_2.new()
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._serviceBag:GetService(any_load_result1_upvr("RagdollServiceClient"))
	arg1._humanoidTracker = arg1._serviceBag:GetService(any_load_result1_upvr("HumanoidTrackerService")):GetHumanoidTracker()
	arg1._ragdollBindersClient = arg1._serviceBag:GetService(var1_result1_upvr_3)
	arg1._disableStack = var1_result1_upvr_6.new(false)
	arg1._maid:GiveTask(arg1._disableStack)
	arg1._enabled = Instance.new("BoolValue")
	arg1._enabled.Value = true
	arg1._maid:GiveTask(arg1._enabled)
	arg1._showIdleUI = Instance.new("BoolValue")
	arg1._showIdleUI.Value = false
	arg1._maid:GiveTask(arg1._showIdleUI)
	arg1._humanoidIdle = Instance.new("BoolValue")
	arg1._humanoidIdle.Value = false
	arg1._maid:GiveTask(arg1._humanoidIdle)
	arg1._lastPosition = var1_result1_upvr_5.new(nil)
	arg1._maid:GiveTask(arg1._lastPosition)
end
function module.Start(arg1) -- Line 64
	arg1._maid:GiveTask(arg1._humanoidIdle.Changed:Connect(function() -- Line 65
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateShowIdleUI()
	end))
	arg1._maid:GiveTask(arg1._enabled.Changed:Connect(function() -- Line 68
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateShowIdleUI()
	end))
	arg1._maid:GiveTask(arg1._humanoidTracker.AliveHumanoid.Changed:Connect(function(...) -- Line 72
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleAliveHumanoidChanged(...)
	end))
	arg1._maid:GiveTask(arg1._disableStack.Changed:Connect(function() -- Line 75
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._enabled.Value = not arg1._disableStack:GetState()
	end))
	if arg1._humanoidTracker.AliveHumanoid.Value then
		arg1:_handleAliveHumanoidChanged()
	end
	arg1:_updateShowIdleUI()
end
local var1_result1_upvr_4 = any_load_result1_upvr("Rx")
function module.ObserveHumanoidMoveFromCurrentPosition(arg1, arg2) -- Line 91
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	local var14
	if type(arg2) ~= "number" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad minimumTimeVisible")
	var14 = var1_result1_upvr_4
	var14 = true
	return var14.of(var14):Pipe({var1_result1_upvr_4.delay(arg2), var1_result1_upvr_4.flatMap(function() -- Line 96
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1._lastPosition:Observe()
	end), var1_result1_upvr_4.where(function(arg1_2) -- Line 99
		if arg1_2 == nil then
		else
		end
		return true
	end), var1_result1_upvr_4.first(), var1_result1_upvr_4.flatMap(function(arg1_3) -- Line 103
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
		]]
		return arg1._lastPosition:Observe():Pipe({var1_result1_upvr_4.where(function(arg1_4) -- Line 105
			--[[ Upvalues[1]:
				[1]: arg1_3 (readonly)
			]]
			local var21 = true
			if arg1_4 ~= nil then
				if 2.5 > (arg1_3 - arg1_4).magnitude then
					var21 = false
				else
					var21 = true
				end
			end
			return var21
		end)})
	end), var1_result1_upvr_4.first()})
end
function module.IsHumanoidIdle(arg1) -- Line 118
	return arg1._humanoidIdle.Value
end
function module.IsMoving(arg1) -- Line 126
	return not arg1._humanoidIdle.Value
end
function module.ObserveHumanoidIdle(arg1) -- Line 134
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.observeValue(arg1._humanoidIdle)
end
function module.DoShowIdleUI(arg1) -- Line 142
	return arg1._showIdleUI.Value
end
function module.ObserveShowIdleUI(arg1) -- Line 150
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.observeValue(arg1._showIdleUI)
end
function module.GetShowIdleUIBoolValue(arg1) -- Line 158
	assert(arg1._showIdleUI, "Not initialized")
	return arg1._showIdleUI
end
function module.PushDisable(arg1) -- Line 168
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return function() -- Line 170
		end
	end
	assert(arg1._disableStack, "Not initialized")
	return arg1._disableStack:PushState(true)
end
function module._setEnabled(arg1, arg2) -- Line 177
	local var23
	if type(arg2) ~= "boolean" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad enabled")
	arg1._enabled.Value = arg2
end
local VRService_upvr = game:GetService("VRService")
function module._updateShowIdleUI(arg1) -- Line 182
	--[[ Upvalues[1]:
		[1]: VRService_upvr (readonly)
	]]
	local Value = arg1._humanoidIdle.Value
	if Value then
		Value = arg1._enabled.Value
		if Value then
			Value = not VRService_upvr.VREnabled
		end
	end
	arg1._showIdleUI.Value = Value
end
function module._handleAliveHumanoidChanged(arg1) -- Line 186
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local Value_upvr = arg1._humanoidTracker.AliveHumanoid.Value
	if not Value_upvr then
		arg1._maid._humanoidMaid = nil
	else
		local any_new_result1 = var1_result1_upvr_2.new()
		local os_clock_result1_upvw = os.clock()
		any_new_result1:GiveTask(function() -- Line 197
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1._lastPosition.Value = nil
			arg1._humanoidIdle.Value = false
		end)
		local function _() -- Line 202, Named "update"
			--[[ Upvalues[2]:
				[1]: os_clock_result1_upvw (read and write)
				[2]: arg1 (readonly)
			]]
			if 0.5 <= os.clock() - os_clock_result1_upvw then
				arg1._humanoidIdle.Value = true
			else
				arg1._humanoidIdle.Value = false
			end
		end
		any_new_result1:GiveTask(arg1._enabled.Changed:Connect(function() -- Line 210
			--[[ Upvalues[1]:
				[1]: os_clock_result1_upvw (read and write)
			]]
			os_clock_result1_upvw = os.clock()
		end))
		any_new_result1:GiveTask(RunService_upvr.Stepped:Connect(function() -- Line 214
			--[[ Upvalues[3]:
				[1]: Value_upvr (readonly)
				[2]: arg1 (readonly)
				[3]: os_clock_result1_upvw (read and write)
			]]
			local RootPart = Value_upvr.RootPart
			if RootPart then
				arg1._lastPosition.Value = RootPart.Position
			end
			if arg1._ragdollBindersClient.Ragdoll:Get(Value_upvr) then
				os_clock_result1_upvw = os.clock()
			elseif RootPart and 2.5 < RootPart.Velocity.magnitude then
				os_clock_result1_upvw = os.clock()
			end
			if 0.5 <= os.clock() - os_clock_result1_upvw then
				arg1._humanoidIdle.Value = true
			else
				arg1._humanoidIdle.Value = false
			end
		end))
		arg1._maid._humanoidMaid = any_new_result1
	end
end
function module.Destroy(arg1) -- Line 235
	arg1._maid:DoCleaning()
end
return module