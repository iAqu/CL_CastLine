-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:55
-- Luau version 6, Types version 3
-- Time taken: 0.002843 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr)
setmetatable_result1_upvr.ClassName = "RagdollHumanoidOnDeathClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("RagdollBindersClient")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 29
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._ragdollBinder = arg2:GetService(var1_result1_upvr).Ragdoll
	if setmetatable_result1_upvr_2._obj:GetState() == Enum.HumanoidStateType.Dead then
		setmetatable_result1_upvr_2:_handleDeath()
		return setmetatable_result1_upvr_2
	end
	setmetatable_result1_upvr_2._maid._diedEvent = setmetatable_result1_upvr_2._obj.Died:Connect(function() -- Line 37
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_handleDeath(setmetatable_result1_upvr_2._obj)
	end)
	return setmetatable_result1_upvr_2
end
local any_load_result1_result1_upvr_2 = any_load_result1("CharacterUtils")
function setmetatable_result1_upvr._getPlayer(arg1) -- Line 45
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.getPlayerFromCharacter(arg1._obj)
end
local Players_upvr = game:GetService("Players")
local Workspace_upvr = game:GetService("Workspace")
function setmetatable_result1_upvr._handleDeath(arg1) -- Line 49
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: Workspace_upvr (readonly)
		[3]: setmetatable_result1_upvr (readonly)
	]]
	arg1._maid._diedEvent = nil
	if arg1:_getPlayer() == Players_upvr.LocalPlayer then
		arg1._ragdollBinder:BindClient(arg1._obj)
	end
	local Parent_upvr = arg1._obj.Parent
	arg1._maid:GiveTask(task.delay(Players_upvr.RespawnTime - 0.5, function() -- Line 58
		--[[ Upvalues[3]:
			[1]: Parent_upvr (readonly)
			[2]: Workspace_upvr (copied, readonly)
			[3]: setmetatable_result1_upvr (copied, readonly)
		]]
		if not Parent_upvr:IsDescendantOf(Workspace_upvr) then
		else
			setmetatable_result1_upvr.disableParticleEmittersAndFadeOutYielding(Parent_upvr, 0.4)
		end
	end))
end
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr.disableParticleEmittersAndFadeOutYielding(arg1, arg2) -- Line 75
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	for i, v in pairs(arg1:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			({})[v] = v.Transparency
		elseif v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
	local const_number = 0
	while const_number < arg2 do
		i = (const_number + RunService_upvr.Heartbeat:Wait()) / arg2
		v = 1
		local minimum = math.min(i, v)
		i = pairs
		v = {}
		i = i(v)
		for i_2, v_2 in i(v) do
			i_2.Transparency = (1 - minimum) * v_2 + minimum
			local _
		end
	end
end
return setmetatable_result1_upvr