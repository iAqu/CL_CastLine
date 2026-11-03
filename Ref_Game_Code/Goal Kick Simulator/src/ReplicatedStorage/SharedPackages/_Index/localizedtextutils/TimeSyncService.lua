-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:54
-- Luau version 6, Types version 3
-- Time taken: 0.003021 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local any_load_result1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("TimeSyncConstants")
local module = {
	ServiceName = "TimeSyncService";
}
local any_load_result1_result1_upvr_3 = any_load_result1("Maid")
function module.Init(arg1) -- Line 30
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: RunService_upvr (readonly)
	]]
	assert(not arg1._clockPromise, "TimeSyncService is already initialized!")
	arg1._maid = any_load_result1_result1_upvr_3.new()
	arg1._clockPromise = any_load_result1_result1_upvr_2.new()
	arg1._maid:GiveTask(arg1._clockPromise)
	if not RunService_upvr:IsRunning() then
		error("Cannot initialize in test mode")
	else
		if RunService_upvr:IsServer() then
			arg1._clockPromise:Resolve(arg1:_buildMasterClock())
			return
		end
		if RunService_upvr:IsClient() then
			arg1._clockPromise:Resolve(arg1:_promiseSlaveClock())
			return
		end
		error("Bad RunService state")
	end
end
local function IsSynced(arg1) -- Line 56
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return true
	end
	assert(arg1._clockPromise, "TimeSyncService is not initialized")
	return arg1._clockPromise:IsFulfilled()
end
module.IsSynced = IsSynced
function module.WaitForSyncedClock(arg1) -- Line 71
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return arg1:_buildMockClock()
	end
	assert(arg1._clockPromise, "TimeSyncService is not initialized")
	return arg1._clockPromise:Wait()
end
function module.GetSyncedClock(arg1) -- Line 85
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return arg1:_buildMockClock()
	end
	assert(arg1._clockPromise, "TimeSyncService is not initialized")
	if arg1._clockPromise:IsFulfilled() then
		return arg1._clockPromise:Wait()
	end
	return nil
end
function module.PromiseSyncedClock(arg1) -- Line 103
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return any_load_result1_result1_upvr_2.resolved(arg1:_buildMockClock())
	end
	assert(arg1._clockPromise, "TimeSyncService is not initialized")
	return any_load_result1_result1_upvr_2.resolved(arg1._clockPromise)
end
function module._buildMockClock(arg1) -- Line 112
	return {
		IsSynced = function(arg1_2) -- Line 115, Named "IsSynced"
			return true
		end;
		GetTime = function(arg1_3) -- Line 119, Named "GetTime"
			return tick()
		end;
		GetPing = function(arg1_4) -- Line 123, Named "GetPing"
			return 0
		end;
	}
end
local any_load_result1_result1_upvr_8 = any_load_result1("GetRemoteEvent")
local any_load_result1_result1_upvr_4 = any_load_result1("GetRemoteFunction")
local any_load_result1_result1_upvr_10 = any_load_result1("MasterClock")
function module._buildMasterClock(arg1) -- Line 130
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: any_load_result1_result1_upvr_10 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_10.new(any_load_result1_result1_upvr_8(var1_result1_upvr.REMOTE_EVENT_NAME), any_load_result1_result1_upvr_4(var1_result1_upvr.REMOTE_FUNCTION_NAME))
	arg1._maid:GiveTask(any_new_result1)
	return any_new_result1
end
local any_load_result1_result1_upvr_6 = any_load_result1("PromiseUtils")
local any_load_result1_result1_upvr_7 = any_load_result1("PromiseGetRemoteEvent")
local any_load_result1_result1_upvr_5 = any_load_result1("PromiseGetRemoteFunction")
local any_load_result1_result1_upvr_9 = any_load_result1("SlaveClock")
local any_load_result1_result1_upvr = any_load_result1("TimeSyncUtils")
function module._promiseSlaveClock(arg1) -- Line 140
	--[[ Upvalues[6]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: any_load_result1_result1_upvr_7 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_5 (readonly)
		[5]: any_load_result1_result1_upvr_9 (readonly)
		[6]: any_load_result1_result1_upvr (readonly)
	]]
	return arg1._maid:GivePromise(any_load_result1_result1_upvr_6.all({any_load_result1_result1_upvr_7(var1_result1_upvr.REMOTE_EVENT_NAME), any_load_result1_result1_upvr_5(var1_result1_upvr.REMOTE_FUNCTION_NAME)})):Then(function(arg1_5, arg2) -- Line 144
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_9 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
		]]
		local any_new_result1_2 = any_load_result1_result1_upvr_9.new(arg1_5, arg2)
		arg1._maid:GiveTask(any_new_result1_2)
		return any_load_result1_result1_upvr.promiseClockSynced(any_new_result1_2)
	end)
end
function module.Destroy(arg1) -- Line 154
	arg1._maid:DoCleaning()
end
return module