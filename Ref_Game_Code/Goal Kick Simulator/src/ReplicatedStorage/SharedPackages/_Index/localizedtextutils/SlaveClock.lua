-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:22
-- Luau version 6, Types version 3
-- Time taken: 0.001751 seconds

local var1_upvr = require(script.Parent.loader).load(script)("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
setmetatable_result1_upvr.ClassName = "SlaveClock"
setmetatable_result1_upvr._offset = -1
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 22
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_upvr.new(), setmetatable_result1_upvr)
	local var4 = arg1
	if not var4 then
		var4 = error("No remoteEvent")
	end
	setmetatable_result1_upvr_2._remoteEvent = var4
	var4 = arg2
	local var5 = var4
	if not var5 then
		var5 = error("No remoteFunction")
	end
	setmetatable_result1_upvr_2._remoteFunction = var5
	setmetatable_result1_upvr_2._ping = 0
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._remoteEvent.OnClientEvent:Connect(function(arg1_2) -- Line 29
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_handleSyncEventAsync(arg1_2)
	end))
	setmetatable_result1_upvr_2._remoteEvent:FireServer()
	setmetatable_result1_upvr_2._syncedBindable = Instance.new("BindableEvent")
	setmetatable_result1_upvr_2.SyncedEvent = setmetatable_result1_upvr_2._syncedBindable.Event
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.TickToSyncedTime(arg1, arg2) -- Line 46
	return arg2 - arg1._offset
end
function setmetatable_result1_upvr.GetTime(arg1) -- Line 54
	if not arg1:IsSynced() then
		error("[SlaveClock.GetTime] - Slave clock is not yet synced")
	end
	return arg1:_getLocalTime() - arg1._offset
end
function setmetatable_result1_upvr.IsSynced(arg1) -- Line 66
	local var7
	if arg1._offset == -1 then
		var7 = false
	else
		var7 = true
	end
	return var7
end
function setmetatable_result1_upvr._getLocalTime(arg1) -- Line 70
	return tick()
end
function setmetatable_result1_upvr.GetPing(arg1) -- Line 79
	return arg1._ping
end
function setmetatable_result1_upvr._handleSyncEventAsync(arg1, arg2) -- Line 83
	local var8 = arg1:_getLocalTime() - arg2
	local any__sendDelayRequestAsync_result1 = arg1:_sendDelayRequestAsync(arg1:_getLocalTime())
	arg1._offset = (var8 - any__sendDelayRequestAsync_result1) / 2
	arg1._pneWayDelay = (var8 + any__sendDelayRequestAsync_result1) / 2
	arg1._ping = os.clock() - os.clock()
	arg1._syncedBindable:Fire()
end
function setmetatable_result1_upvr._sendDelayRequestAsync(arg1, arg2) -- Line 121
	return arg1._remoteFunction:InvokeServer(arg2)
end
return setmetatable_result1_upvr