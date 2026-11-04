-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:00
-- Luau version 6, Types version 3
-- Time taken: 0.003897 seconds

local module_upvr = {}
local TweenService_upvr = game:GetService("TweenService")
local CurrentCamera_upvr = workspace.CurrentCamera
local HumanModule_upvr = require(game.ReplicatedStorage.Tool.HumanModule)
local var5_upvw = false
local TweenInfo_new_result1_upvr = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
function module_upvr.CameraFocus(arg1, arg2, arg3, arg4) -- Line 22
	--[[ Upvalues[4]:
		[1]: var5_upvw (read and write)
		[2]: CurrentCamera_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: TweenInfo_new_result1_upvr (readonly)
	]]
	if not arg2 then
	else
		if var5_upvw then
			warn("camera animation is playing!")
			return
		end
		if not arg3 or not arg3 then
		end
		if not arg4 or not arg4 then
		end
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		CurrentCamera_upvr.CameraSubject = arg2
		local any_Create_result1_2 = TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo_new_result1_upvr, {
			CFrame = CFrame.new(CurrentCamera_upvr.CFrame:Lerp(arg2.CFrame, 0.8).Position, arg2.Position);
		})
		local const_number_upvw = 3
		local CameraType_upvr = CurrentCamera_upvr.CameraType
		any_Create_result1_2.Completed:Connect(function() -- Line 42
			--[[ Upvalues[4]:
				[1]: const_number_upvw (read and write)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: CameraType_upvr (readonly)
				[4]: var5_upvw (copied, read and write)
			]]
			wait(const_number_upvw)
			CurrentCamera_upvr.CameraType = CameraType_upvr
			CurrentCamera_upvr.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
			var5_upvw = false
		end)
		any_Create_result1_2:Play()
		var5_upvw = true
	end
end
local var12_upvw
function module_upvr.CameraWatch(arg1, arg2, arg3, arg4) -- Line 54
	--[[ Upvalues[4]:
		[1]: var5_upvw (read and write)
		[2]: var12_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
		[4]: TweenService_upvr (readonly)
	]]
	if not arg3 then
	else
		if var5_upvw then
			warn("camera animation is playing!")
			return
		end
		if not arg4 then
		end
		var12_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		CurrentCamera_upvr.CameraSubject = arg3
		TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
			CFrame = CFrame.new(arg2, arg3.Position);
		}):Play()
		var5_upvw = true
	end
end
function module_upvr.CameraCangkuWatch(arg1, arg2) -- Line 89
	--[[ Upvalues[4]:
		[1]: var5_upvw (read and write)
		[2]: var12_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
		[4]: TweenService_upvr (readonly)
	]]
	if var5_upvw then
		warn("camera animation is playing!")
	else
		var12_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
			CFrame = arg2.CFrame;
		}):Play()
		var5_upvw = true
	end
end
local var15_upvw = false
function module_upvr.CameraWatchEnd(arg1) -- Line 120
	--[[ Upvalues[3]:
		[1]: var5_upvw (read and write)
		[2]: var12_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
	]]
	if var5_upvw and var12_upvw then
		CurrentCamera_upvr.CameraType = var12_upvw
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid then
			CurrentCamera_upvr.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		end
		var5_upvw = false
		var12_upvw = nil
	end
end
function module_upvr.CustomCameraWatch(arg1) -- Line 135
	--[[ Upvalues[3]:
		[1]: var5_upvw (read and write)
		[2]: var12_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
	]]
	if var5_upvw then
		warn("camera animation is playing!")
		return false
	end
	var12_upvw = CurrentCamera_upvr.CameraType
	CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
	var5_upvw = true
	return true
end
function module_upvr.CustomCameraWatchEnd(arg1) -- Line 150
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:CameraWatchEnd()
end
function module_upvr.CameraWatchShop(arg1, arg2) -- Line 154
	--[[ Upvalues[3]:
		[1]: var5_upvw (read and write)
		[2]: var12_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
	]]
	if var5_upvw then
	else
		var12_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		CurrentCamera_upvr.CFrame = arg2
		var5_upvw = true
	end
end
function module_upvr.CameraWatchShopMove(arg1, arg2) -- Line 172
	--[[ Upvalues[4]:
		[1]: var5_upvw (read and write)
		[2]: var12_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
		[4]: TweenService_upvr (readonly)
	]]
	if var5_upvw then
	else
		var12_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		local tbl = {}
		tbl.CFrame = arg2
		TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), tbl):Play()
		var5_upvw = true
	end
end
function module_upvr.CameraWatchSelf(arg1) -- Line 199
	--[[ Upvalues[5]:
		[1]: HumanModule_upvr (readonly)
		[2]: var5_upvw (read and write)
		[3]: var12_upvw (read and write)
		[4]: CurrentCamera_upvr (readonly)
		[5]: TweenService_upvr (readonly)
	]]
	local any_GetHumanoidRootPart_result1 = HumanModule_upvr.GetHumanoidRootPart(game.Players.LocalPlayer)
	if not any_GetHumanoidRootPart_result1 then
	else
		if var5_upvw then return end
		var12_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		local any_ToWorldSpace_result1_2 = any_GetHumanoidRootPart_result1:GetPivot():ToWorldSpace(CFrame.new(Vector3.new(-5, 0, -10)))
		any_GetHumanoidRootPart_result1:PivotTo(CFrame.lookAt(any_GetHumanoidRootPart_result1.Position, any_ToWorldSpace_result1_2.Position))
		TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
			CFrame = CFrame.lookAt(any_ToWorldSpace_result1_2.Position, any_ToWorldSpace_result1_2.Position - any_GetHumanoidRootPart_result1.CFrame.LookVector);
		}):Play()
		var5_upvw = true
	end
end
function module_upvr.CameraWatchSelfLasting(arg1) -- Line 238
	--[[ Upvalues[7]:
		[1]: HumanModule_upvr (readonly)
		[2]: var5_upvw (read and write)
		[3]: var12_upvw (read and write)
		[4]: CurrentCamera_upvr (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: var15_upvw (read and write)
		[7]: module_upvr (readonly)
	]]
	local any_GetHumanoidRootPart_result1_2_upvr = HumanModule_upvr.GetHumanoidRootPart(game.Players.LocalPlayer)
	if not any_GetHumanoidRootPart_result1_2_upvr then
	else
		if var5_upvw then return end
		var12_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		local any_ToWorldSpace_result1 = any_GetHumanoidRootPart_result1_2_upvr:GetPivot():ToWorldSpace(CFrame.new(Vector3.new(-5, 0, -10)))
		any_GetHumanoidRootPart_result1_2_upvr:PivotTo(CFrame.lookAt(any_GetHumanoidRootPart_result1_2_upvr.Position, any_ToWorldSpace_result1.Position))
		local any_Create_result1 = TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
			CFrame = CFrame.lookAt(any_ToWorldSpace_result1.Position, any_ToWorldSpace_result1.Position - any_GetHumanoidRootPart_result1_2_upvr.CFrame.LookVector);
		})
		local var24_upvw = false
		any_Create_result1.Completed:Connect(function() -- Line 274
			--[[ Upvalues[1]:
				[1]: var24_upvw (read and write)
			]]
			var24_upvw = true
		end)
		any_Create_result1:Play()
		local var27_upvw
		local any_GetPivot_result1_upvw = any_GetHumanoidRootPart_result1_2_upvr:GetPivot()
		local any_GetPivot_result1_upvr = any_GetHumanoidRootPart_result1_2_upvr:GetPivot()
		var27_upvw = game["Run Service"].Heartbeat:Connect(function(arg1_2) -- Line 281
			--[[ Upvalues[8]:
				[1]: var24_upvw (read and write)
				[2]: var15_upvw (copied, read and write)
				[3]: any_GetHumanoidRootPart_result1_2_upvr (readonly)
				[4]: var27_upvw (read and write)
				[5]: module_upvr (copied, readonly)
				[6]: any_GetPivot_result1_upvw (read and write)
				[7]: any_GetPivot_result1_upvr (readonly)
				[8]: CurrentCamera_upvr (copied, readonly)
			]]
			if not var24_upvw then
			else
				if not var15_upvw or not any_GetHumanoidRootPart_result1_2_upvr then
					var27_upvw:Disconnect()
					var27_upvw = nil
					module_upvr:CameraWatchEnd()
					return
				end
				if any_GetHumanoidRootPart_result1_2_upvr then
					any_GetPivot_result1_upvw = any_GetHumanoidRootPart_result1_2_upvr:GetPivot()
				end
				CurrentCamera_upvr.CFrame = CFrame.lookAt(any_GetPivot_result1_upvr.Rotation + any_GetPivot_result1_upvw.Position:ToWorldSpace(CFrame.new(Vector3.new(-5, 0, -10))).Position, any_GetPivot_result1_upvr.Rotation + any_GetPivot_result1_upvw.Position:ToWorldSpace(CFrame.new(-5, 0, 0)).Position)
			end
		end)
		var15_upvw = true
		var5_upvw = true
	end
end
function module_upvr.CameraWatchLastingStop(arg1) -- Line 312
	--[[ Upvalues[1]:
		[1]: var15_upvw (read and write)
	]]
	var15_upvw = false
end
return module_upvr