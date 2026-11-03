-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:54
-- Luau version 6, Types version 3
-- Time taken: 0.002395 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "RagdollClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("RagdollServiceClient")
local var1_result1_upvr_3 = any_load_result1("CameraStackService")
local any_load_result1_result1_upvr_3 = any_load_result1("CharacterUtils")
local Players_upvr = game:GetService("Players")
local any_load_result1_result1_upvr = any_load_result1("RagdollMotorUtils")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 33
	--[[ Upvalues[7]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr_3 (readonly)
		[6]: Players_upvr (readonly)
		[7]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1_upvr_2._ragdollServiceClient = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr)
	setmetatable_result1_upvr_2._cameraStackService = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr_3)
	if any_load_result1_result1_upvr_3.getPlayerFromCharacter(setmetatable_result1_upvr_2._obj) == Players_upvr.LocalPlayer then
		setmetatable_result1_upvr_2._maid:GiveTask(task.spawn(function() -- Line 42
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: setmetatable_result1_upvr_2 (readonly)
			]]
			any_load_result1_result1_upvr.yieldUntilStepped()
			setmetatable_result1_upvr_2:_setupHapticFeedback()
			setmetatable_result1_upvr_2:_setupCameraShake(setmetatable_result1_upvr_2._cameraStackService:GetImpulseCamera())
		end))
	end
	return setmetatable_result1_upvr_2
end
local RunService_upvr = game:GetService("RunService")
local Workspace_upvr = game:GetService("Workspace")
function setmetatable_result1_upvr._setupCameraShake(arg1, arg2) -- Line 55
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: Workspace_upvr (readonly)
	]]
	local Head_upvr = arg1._obj.Parent:FindFirstChild("Head")
	if not Head_upvr then
	else
		local Velocity_upvw = Head_upvr.Velocity
		arg1._maid:GiveTask(RunService_upvr.Heartbeat:Connect(function() -- Line 62
			--[[ Upvalues[5]:
				[1]: Workspace_upvr (copied, readonly)
				[2]: Head_upvr (readonly)
				[3]: Velocity_upvw (read and write)
				[4]: arg1 (readonly)
				[5]: arg2 (readonly)
			]]
			debug.profilebegin("ragdollcamerashake")
			local CFrame = Workspace_upvr.CurrentCamera.CFrame
			local Velocity = Head_upvr.Velocity
			local var18 = Velocity - Velocity_upvw
			if 0 <= var18.magnitude and arg1._ragdollServiceClient:GetScreenShakeEnabled() then
				arg2:Impulse(CFrame:vectorToObjectSpace(-0.1 * CFrame.lookVector:Cross(var18)))
			end
			Velocity_upvw = Velocity
			debug.profileend()
		end))
	end
end
local UserInputService_upvr = game:GetService("UserInputService")
local any_load_result1_result1_upvr_2 = any_load_result1("HapticFeedbackUtils")
function setmetatable_result1_upvr._setupHapticFeedback(arg1) -- Line 79
	--[[ Upvalues[2]:
		[1]: UserInputService_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_GetLastInputType_result1_upvr = UserInputService_upvr:GetLastInputType()
	if not any_load_result1_result1_upvr_2.setSmallVibration(any_GetLastInputType_result1_upvr, 1) then
	else
		local var22_upvw = true
		arg1._maid:GiveTask(function() -- Line 86
			--[[ Upvalues[1]:
				[1]: var22_upvw (read and write)
			]]
			var22_upvw = false
		end)
		task.spawn(function() -- Line 90
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: any_GetLastInputType_result1_upvr (readonly)
				[3]: var22_upvw (read and write)
				[4]: arg1 (readonly)
			]]
			for i = 1, 0, -0.1 do
				any_load_result1_result1_upvr_2.setSmallVibration(any_GetLastInputType_result1_upvr, i)
				task.wait(0.05)
			end
			any_load_result1_result1_upvr_2.setSmallVibration(any_GetLastInputType_result1_upvr, 0)
			if var22_upvw then
				arg1._maid:GiveTask(function() -- Line 98
					--[[ Upvalues[2]:
						[1]: any_load_result1_result1_upvr_2 (copied, readonly)
						[2]: any_GetLastInputType_result1_upvr (copied, readonly)
					]]
					any_load_result1_result1_upvr_2.smallVibrate(any_GetLastInputType_result1_upvr)
				end)
			end
		end)
	end
end
return setmetatable_result1_upvr