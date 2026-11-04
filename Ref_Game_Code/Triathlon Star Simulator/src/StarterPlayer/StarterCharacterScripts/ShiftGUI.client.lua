-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:13
-- Luau version 6, Types version 3
-- Time taken: 0.002016 seconds

local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character
if not Character then
	Character = LocalPlayer.CharacterAdded:Wait()
end
local HumanoidRootPart_upvr = Character:WaitForChild("HumanoidRootPart")
local Humanoid_upvr = Character:WaitForChild("Humanoid")
local CurrentCamera_upvr = workspace.CurrentCamera
local any_GetIns_result1_upvr = require(game.ReplicatedStorage.Tool.InsMgr).GetIns("IsShiftLockOn", "BoolValue", LocalPlayer)
any_GetIns_result1_upvr.Value = false
uis = game:GetService("UserInputService") -- Setting global
ismobile = uis.TouchEnabled -- Setting global
if not ismobile then
else
	local cframe_upvr = CFrame.new(3, 2, 0)
	local cframe_upvr_2 = CFrame.new(-1.7, 0, 0)
	local function _(arg1) -- Line 30, Named "UpdateAutoRotate"
		--[[ Upvalues[1]:
			[1]: Humanoid_upvr (readonly)
		]]
		Humanoid_upvr.AutoRotate = arg1
	end
	local function _(arg1, arg2) -- Line 34, Named "GetUpdatedCameraCFrame"
		--[[ Upvalues[1]:
			[1]: HumanoidRootPart_upvr (readonly)
		]]
		return CFrame.new(HumanoidRootPart_upvr.Position, Vector3.new(arg2.CFrame.LookVector.X * 900000, HumanoidRootPart_upvr.Position.Y, arg2.CFrame.LookVector.Z * 900000))
	end
	local function _() -- Line 38, Named "EnableShiftlock"
		--[[ Upvalues[5]:
			[1]: any_GetIns_result1_upvr (readonly)
			[2]: Humanoid_upvr (readonly)
			[3]: HumanoidRootPart_upvr (readonly)
			[4]: CurrentCamera_upvr (readonly)
			[5]: cframe_upvr (readonly)
		]]
		any_GetIns_result1_upvr.Value = true
		Humanoid_upvr.AutoRotate = false
		local var10 = CurrentCamera_upvr
		HumanoidRootPart_upvr.CFrame = CFrame.new(HumanoidRootPart_upvr.Position, Vector3.new(var10.CFrame.LookVector.X * 900000, HumanoidRootPart_upvr.Position.Y, var10.CFrame.LookVector.Z * 900000))
		CurrentCamera_upvr.CFrame *= cframe_upvr
	end
	local var11_upvw = false
	local function _() -- Line 45, Named "DisableShiftlock"
		--[[ Upvalues[5]:
			[1]: any_GetIns_result1_upvr (readonly)
			[2]: Humanoid_upvr (readonly)
			[3]: CurrentCamera_upvr (readonly)
			[4]: cframe_upvr_2 (readonly)
			[5]: var11_upvw (read and write)
		]]
		any_GetIns_result1_upvr.Value = false
		Humanoid_upvr.AutoRotate = true
		CurrentCamera_upvr.CFrame *= cframe_upvr_2
		pcall(function() -- Line 50
			--[[ Upvalues[1]:
				[1]: var11_upvw (copied, read and write)
			]]
			var11_upvw:Disconnect()
			var11_upvw = nil
		end)
	end
	var11_upvw = false
	local RunService_upvr = game:GetService("RunService")
	function ShiftLock() -- Line 57
		--[[ Upvalues[8]:
			[1]: var11_upvw (read and write)
			[2]: RunService_upvr (readonly)
			[3]: any_GetIns_result1_upvr (readonly)
			[4]: Humanoid_upvr (readonly)
			[5]: HumanoidRootPart_upvr (readonly)
			[6]: CurrentCamera_upvr (readonly)
			[7]: cframe_upvr (readonly)
			[8]: cframe_upvr_2 (readonly)
		]]
		if not var11_upvw then
			var11_upvw = RunService_upvr.RenderStepped:Connect(function() -- Line 59
				--[[ Upvalues[5]:
					[1]: any_GetIns_result1_upvr (copied, readonly)
					[2]: Humanoid_upvr (copied, readonly)
					[3]: HumanoidRootPart_upvr (copied, readonly)
					[4]: CurrentCamera_upvr (copied, readonly)
					[5]: cframe_upvr (copied, readonly)
				]]
				any_GetIns_result1_upvr.Value = true
				Humanoid_upvr.AutoRotate = false
				local var15 = CurrentCamera_upvr
				HumanoidRootPart_upvr.CFrame = CFrame.new(HumanoidRootPart_upvr.Position, Vector3.new(var15.CFrame.LookVector.X * 900000, HumanoidRootPart_upvr.Position.Y, var15.CFrame.LookVector.Z * 900000))
				CurrentCamera_upvr.CFrame *= cframe_upvr
			end)
		else
			any_GetIns_result1_upvr.Value = false
			Humanoid_upvr.AutoRotate = true
			CurrentCamera_upvr.CFrame *= cframe_upvr_2
			pcall(function() -- Line 50
				--[[ Upvalues[1]:
					[1]: var11_upvw (copied, read and write)
				]]
				var11_upvw:Disconnect()
				var11_upvw = nil
			end)
		end
	end
	game:GetService("ContextActionService"):SetPosition("ShiftLOCK", UDim2.new(0.8, 0, 0.8, 0))
	game.ReplicatedStorage.LocalMsg.ShiftLock.Event:Connect(function() -- Line 77
		ShiftLock()
	end)
end