-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:07
-- Luau version 6, Types version 3
-- Time taken: 0.003110 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("IKRigBase")
local setmetatable_result1_upvr_2 = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "IKRigClient"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
any_load_result1("PromiseRemoteEventMixin"):Add(setmetatable_result1_upvr_2, any_load_result1("IKConstants").REMOTE_EVENT_NAME)
local Players_upvr = game:GetService("Players")
function setmetatable_result1_upvr_2.new(arg1, arg2) -- Line 20
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: Players_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._serviceBag = assert(arg2, "No serviceBag")
	if setmetatable_result1_upvr:GetPlayer() == Players_upvr.LocalPlayer then
		setmetatable_result1_upvr:_setupLocalPlayer(setmetatable_result1_upvr._remoteEvent)
	end
	setmetatable_result1_upvr:PromiseRemoteEvent():Then(function(arg1_2) -- Line 29
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._remoteEvent = assert(arg1_2, "No remoteEvent")
		setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._remoteEvent.OnClientEvent:Connect(function(...) -- Line 32
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (copied, readonly)
			]]
			setmetatable_result1_upvr:_handleRemoteEventClient(...)
		end))
		if setmetatable_result1_upvr._localPlayerAimer then
			setmetatable_result1_upvr._localPlayerAimer:SetRemoteEvent(setmetatable_result1_upvr._remoteEvent)
		end
	end)
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.GetPositionOrNil(arg1) -- Line 49
	local RootPart = arg1._obj.RootPart
	if not RootPart then
		return nil
	end
	return RootPart.Position
end
function setmetatable_result1_upvr_2.GetLocalPlayerAimer(arg1) -- Line 63
	return arg1._localPlayerAimer
end
function setmetatable_result1_upvr_2.GetTarget(arg1) -- Line 72
	if arg1._localPlayerAimer then
		return arg1._localPlayerAimer:GetAimPosition()
	end
	return arg1._target
end
function setmetatable_result1_upvr_2._handleRemoteEventClient(arg1, arg2) -- Line 81
	local var9 = true
	if typeof(arg2) ~= "Vector3" then
		if arg2 ~= nil then
			var9 = false
		else
			var9 = true
		end
	end
	assert(var9, "Bad newTarget")
	local any_GetTorso_result1 = arg1:GetTorso()
	if any_GetTorso_result1 then
		any_GetTorso_result1:Point(arg2)
	end
	arg1._target = arg2
end
local var1_result1_upvr = any_load_result1("IKRigAimerLocalPlayer")
function setmetatable_result1_upvr_2._setupLocalPlayer(arg1, arg2) -- Line 93
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	arg1._localPlayerAimer = var1_result1_upvr.new(arg1._serviceBag, arg1, arg2)
	arg1._maid:GiveTask(arg1._localPlayerAimer)
end
return setmetatable_result1_upvr_2