-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:33
-- Luau version 6, Types version 3
-- Time taken: 0.003533 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("AreaAwareHumanoidBase")
local var1_result1_upvr_3 = any_load_result1("AreaAwareHumanoidConstants")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "AreaAwareHumanoidClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
any_load_result1("PromiseRemoteEventMixin"):Add(setmetatable_result1_upvr, var1_result1_upvr_3.REMOTE_EVENT_NAME)
local var1_result1_upvr = any_load_result1("AreaBindersClient")
local Players_upvr = game:GetService("Players")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 19
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: Players_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1_upvr_2._areaBindersClient = arg2:GetService(var1_result1_upvr)
	if setmetatable_result1_upvr_2:GetPlayer() == Players_upvr.LocalPlayer then
		setmetatable_result1_upvr_2:SetupAsOwner()
	end
	setmetatable_result1_upvr_2:PromiseRemoteEvent():Then(function(arg1_2) -- Line 29
		--[[ Upvalues[2]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: Players_upvr (copied, readonly)
		]]
		setmetatable_result1_upvr_2._remoteEvent = assert(arg1_2, "No remoteEvent")
		if setmetatable_result1_upvr_2:GetPlayer() == Players_upvr.LocalPlayer then
			setmetatable_result1_upvr_2:_setupReplicationAsOwner()
		else
			setmetatable_result1_upvr_2:_setupReplicationAsNonOwner()
		end
	end)
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.GetAreaBinder(arg1) -- Line 42
	return arg1._areaBindersClient.Area
end
function setmetatable_result1_upvr._handleClientEvent(arg1, arg2, arg3, ...) -- Line 46
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local var9
	if type(arg2) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad request")
	if typeof(arg3) ~= "Instance" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad areaInstance")
	local any_FindArea_result1 = arg1:FindArea(arg3)
	if not any_FindArea_result1 then
		var9 = warn
		var9("[AwareAwareHumanoid._handleClientEvent] - Could not find area")
	else
		var9 = var1_result1_upvr_3.REQUEST_ADD_PRESENCE
		if arg2 == var9 then
			var9 = arg1:_handleRequestAddPresence
			var9(any_FindArea_result1, ...)
			return
		end
		var9 = var1_result1_upvr_3.REQUEST_REMOVE_PRESENCE
		if arg2 == var9 then
			var9 = arg1:RemovePresenceForArea
			var9(any_FindArea_result1)
			return
		end
		var9 = error
		var9("[AwareAwareHumanoid._handleServerEvent] - Bad request %q":format(tostring(arg2)))
	end
end
function setmetatable_result1_upvr._handleRequestAddPresence(arg1, arg2, arg3, arg4) -- Line 66
	local var11
	if typeof(arg4) ~= "Vector3" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad relPointInArea")
	if typeof(arg3) ~= "Instance" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad areaPart")
	arg1:GetOrCreatePresence(arg2, arg3, arg4)
end
function setmetatable_result1_upvr._setupReplicationAsNonOwner(arg1) -- Line 73
	arg1._maid:GiveTask(arg1._remoteEvent.OnClientEvent:Connect(function(...) -- Line 74
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleClientEvent(...)
	end))
end
function setmetatable_result1_upvr._setupReplicationAsOwner(arg1) -- Line 79
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	arg1._maid:GivePromise(arg1:PromiseRootPart()):Then(function(arg1_3) -- Line 80
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
		]]
		arg1._maid:GiveTask(arg1.PresenceAdded:Connect(function(arg1_4, arg2, arg3) -- Line 81
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: var1_result1_upvr_3 (copied, readonly)
			]]
			assert(arg3, "No relPointInArea")
			arg1._remoteEvent:FireServer(var1_result1_upvr_3.REQUEST_ADD_PRESENCE, arg1_4:GetAreaObject(), arg2, arg3)
		end))
		arg1._maid:GiveTask(arg1.PresenceRemoving:Connect(function(arg1_5) -- Line 87
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: var1_result1_upvr_3 (copied, readonly)
			]]
			arg1._remoteEvent:FireServer(var1_result1_upvr_3.REQUEST_REMOVE_PRESENCE, arg1_5:GetAreaObject())
		end))
		for _, v in pairs(arg1:GetPresenceList()) do
			local any_GetAreaPart_result1 = v:GetArea():GetAreaPart(arg1_3.Position)
			if any_GetAreaPart_result1 then
				arg1._remoteEvent:FireServer(var1_result1_upvr_3.REQUEST_ADD_PRESENCE, v:GetAreaObject(), any_GetAreaPart_result1, any_GetAreaPart_result1.CFrame:pointToObjectSpace(arg1_3.Position))
			else
				warn("[AreaAwareHumanoid._setupReplicationAsOwner] - Failed to find area part for area")
			end
		end
	end)
end
return setmetatable_result1_upvr