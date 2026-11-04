-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:05
-- Luau version 6, Types version 3
-- Time taken: 0.002749 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BezierCurve_upvr = require(ReplicatedStorage.Tool.BezierCurve)
local CurrentCamera_upvr = workspace.CurrentCamera
local var5_upvw = false
local var6_upvw
function module_upvr.SurroundingWatch(arg1) -- Line 16
	--[[ Upvalues[5]:
		[1]: var5_upvw (read and write)
		[2]: var6_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: BezierCurve_upvr (readonly)
	]]
	if not arg1 then
	else
		if var5_upvw then
			warn("camera animation is playing!")
			return
		end
		var6_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		CurrentCamera_upvr.CameraSubject = arg1
		local function var7_upvr() -- Line 29
			--[[ Upvalues[1]:
				[1]: module_upvr (copied, readonly)
			]]
			spawn(function() -- Line 30
				--[[ Upvalues[1]:
					[1]: module_upvr (copied, readonly)
				]]
				task.wait(2)
				module_upvr:CameraWatchEnd()
			end)
		end
		local var9 = arg1.CFrame * CFrame.Angles(0, 0.3490658503988659, 0)
		local var11_upvr = arg1.Position - Vector3.new(arg1.CFrame.LookVector.X * 20, -8, arg1.CFrame.LookVector.Z * 20)
		local var12_upvr = arg1.Position + Vector3.new(-arg1.CFrame.RightVector.X * 40, 12, -arg1.CFrame.RightVector.Z * 40)
		local var13_upvr = arg1.Position - Vector3.new(-arg1.CFrame.LookVector.X * 20, -16, -arg1.CFrame.LookVector.Z * 20)
		local function _() -- Line 68
			--[[ Upvalues[7]:
				[1]: BezierCurve_upvr (copied, readonly)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: var11_upvr (readonly)
				[4]: var12_upvr (readonly)
				[5]: var13_upvr (readonly)
				[6]: arg1 (readonly)
				[7]: var7_upvr (readonly)
			]]
			BezierCurve_upvr.QuadraticBezierCurvesCameraLookAt(120, 60, CurrentCamera_upvr, var11_upvr, var12_upvr, var13_upvr, CFrame.new(0, 0, 0), arg1, var7_upvr)
		end
		BezierCurve_upvr.QuadraticBezierCurvesCameraLookAt(120, 60, CurrentCamera_upvr, var9.Position - Vector3.new(var9.LookVector.X * 20, -4, var9.LookVector.Z * 20), var9.Position + Vector3.new(var9.RightVector.X * 40, 12, var9.RightVector.Z * 40), var9.Position - Vector3.new(-var9.LookVector.X * 20, -16, -var9.LookVector.Z * 20), CFrame.new(0, 0, 0), arg1, var7_upvr)
		var5_upvw = true
	end
end
local FXUtil_upvr = require(ReplicatedStorage["特效表现工具"].FXUtil)
function module_upvr.ShipWatch(arg1) -- Line 80
	--[[ Upvalues[5]:
		[1]: var5_upvw (read and write)
		[2]: var6_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
		[4]: FXUtil_upvr (readonly)
		[5]: BezierCurve_upvr (readonly)
	]]
	if not arg1 then
	else
		if var5_upvw then
			warn("camera animation is playing!")
			return
		end
		var6_upvw = CurrentCamera_upvr.CameraType
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		CurrentCamera_upvr.CameraSubject = arg1
		local ______ = workspace["过场"]["点位"]
		local _______upvr = workspace["过场"]["船"]["装饰"]["特效"]
		task.delay(2.5, function() -- Line 98
			--[[ Upvalues[2]:
				[1]: FXUtil_upvr (copied, readonly)
				[2]: _______upvr (readonly)
			]]
			FXUtil_upvr.Start_All_Emit(_______upvr)
		end)
		local function var18_upvr() -- Line 104
			--[[ Upvalues[1]:
				[1]: _______upvr (readonly)
			]]
			spawn(function() -- Line 106
				--[[ Upvalues[1]:
					[1]: _______upvr (copied, readonly)
				]]
				task.wait(2)
				if not _______upvr then
				end
			end)
		end
		local ______1 = ______["点位1"]
		local ______2 = ______["点位2"]
		local ______3 = ______["点位3"]
		local ______4 = ______["点位4"]
		CurrentCamera_upvr.CFrame = ______1:GetPivot()
		local Position_upvr_5 = ______4:GetPivot().Position
		local Position_upvr_4 = ______["中间4"]:GetPivot().Position
		local Position_upvr_2 = ______["点位5"]:GetPivot().Position
		local function Curve4_upvr() -- Line 178, Named "Curve4"
			--[[ Upvalues[7]:
				[1]: BezierCurve_upvr (copied, readonly)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: Position_upvr_5 (readonly)
				[4]: Position_upvr_4 (readonly)
				[5]: Position_upvr_2 (readonly)
				[6]: arg1 (readonly)
				[7]: var18_upvr (readonly)
			]]
			BezierCurve_upvr.QuadraticBezierCurvesCameraLookAt(540, 60, CurrentCamera_upvr, Position_upvr_5, Position_upvr_4, Position_upvr_2, CFrame.new(0, 0, 0), arg1, var18_upvr)
		end
		local Position_upvr_3 = ______3:GetPivot().Position
		local Position_upvr_9 = ______["中间3"]:GetPivot().Position
		local Position_upvr = ______4:GetPivot().Position
		local function Curve3_upvr() -- Line 182, Named "Curve3"
			--[[ Upvalues[7]:
				[1]: BezierCurve_upvr (copied, readonly)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: Position_upvr_3 (readonly)
				[4]: Position_upvr_9 (readonly)
				[5]: Position_upvr (readonly)
				[6]: arg1 (readonly)
				[7]: Curve4_upvr (readonly)
			]]
			BezierCurve_upvr.QuadraticBezierCurvesCameraLookAt(225, 60, CurrentCamera_upvr, Position_upvr_3, Position_upvr_9, Position_upvr, CFrame.new(0, 0, 0), arg1, Curve4_upvr)
		end
		local Position_upvr_7 = ______2:GetPivot().Position
		local Position_upvr_8 = ______["中间2"]:GetPivot().Position
		local Position_upvr_6 = ______3:GetPivot().Position
		BezierCurve_upvr.QuadraticBezierCurvesCameraLookAt(180, 60, CurrentCamera_upvr, ______1:GetPivot().Position, ______["中间1"]:GetPivot().Position, ______2:GetPivot().Position, CFrame.new(0, 0, 0), arg1, function() -- Line 186, Named "Curve2"
			--[[ Upvalues[7]:
				[1]: BezierCurve_upvr (copied, readonly)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: Position_upvr_7 (readonly)
				[4]: Position_upvr_8 (readonly)
				[5]: Position_upvr_6 (readonly)
				[6]: arg1 (readonly)
				[7]: Curve3_upvr (readonly)
			]]
			BezierCurve_upvr.QuadraticBezierCurvesCameraLookAt(270, 60, CurrentCamera_upvr, Position_upvr_7, Position_upvr_8, Position_upvr_6, CFrame.new(0, 0, 0), arg1, Curve3_upvr)
		end)
		var5_upvw = true
	end
end
function module_upvr.CameraWatchEnd(arg1) -- Line 195
	--[[ Upvalues[3]:
		[1]: var5_upvw (read and write)
		[2]: var6_upvw (read and write)
		[3]: CurrentCamera_upvr (readonly)
	]]
	if var5_upvw and var6_upvw then
		CurrentCamera_upvr.CameraType = var6_upvw
		CurrentCamera_upvr.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		var5_upvw = false
		var6_upvw = nil
	end
end
return module_upvr