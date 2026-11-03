-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:55
-- Luau version 6, Types version 3
-- Time taken: 0.001545 seconds

local var1_upvr = require(script.Parent.loader).load(script)("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
setmetatable_result1_upvr.ClassName = "MasterClock"
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 21
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
	setmetatable_result1_upvr_2._remoteFunction.OnServerInvoke = function(arg1_2, arg2_2) -- Line 27
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		return setmetatable_result1_upvr_2:_handleDelayRequest(arg2_2)
	end
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._remoteEvent.OnServerEvent:Connect(function(arg1_3) -- Line 30
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._remoteEvent:FireClient(arg1_3, setmetatable_result1_upvr_2:GetTime())
	end))
	local var8_upvw = true
	setmetatable_result1_upvr_2._maid:GiveTask(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: var8_upvw (read and write)
		]]
		var8_upvw = false
	end)
	task.delay(5, function() -- Line 39
		--[[ Upvalues[2]:
			[1]: var8_upvw (read and write)
			[2]: setmetatable_result1_upvr_2 (readonly)
		]]
		while var8_upvw do
			setmetatable_result1_upvr_2:_forceSync()
			task.wait(5)
		end
	end)
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.IsSynced(arg1) -- Line 53
	return true
end
function setmetatable_result1_upvr.GetPing(arg1) -- Line 61
	return arg1._offset
end
function setmetatable_result1_upvr.GetTime(arg1) -- Line 69
	return tick()
end
function setmetatable_result1_upvr._forceSync(arg1) -- Line 73
	arg1._remoteEvent:FireAllClients(arg1:GetTime())
end
function setmetatable_result1_upvr._handleDelayRequest(arg1, arg2) -- Line 79
	return arg1:GetTime() - arg2
end
return setmetatable_result1_upvr