-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Modules.GuiControl)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local WorldSetup = workspace:WaitForChild("WorldSetup")
local v1 = false
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Oxygen = PlayerGui:WaitForChild("Oxygen")
local DepthScreen = PlayerGui:WaitForChild("DepthScreen")
local function HasGear() --[[ HasGear | Line: 32 | Upvalues: Replion (copy), ItemUtility (copy), PlayerStatsUtility (copy) ]]
	local v1 = Replion.Client:GetReplion("Data")
	if not v1 or v1.Destroyed then
		return
	end
	local v2 = ItemUtility:GetItemData("Advanced Diving Gear")
	local v3 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 37 | Upvalues: v2 (copy) ]]
		return p1.Id == v2.Data.Id
	end, "Items")
	return if v3 then v1:GetExpect("EquippedOxygenTankId") == v2.Data.Id else v3
end
local function InitScene(p1, p2) --[[ InitScene | Line: 44 | Upvalues: LocalPlayer (copy), CurrentCamera (copy) ]]
	LocalPlayer.Character.HumanoidRootPart.Anchored = true
	LocalPlayer.Character:PivotTo(CFrame.lookAt(p1.WorldPosition + Vector3.new(-1.5, 0, 0), p1.WorldPosition))
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.CFrame = CFrame.lookAt(p2.WorldPosition, LocalPlayer.Character:GetPivot().Position)
end
local function Ascend() --[[ Ascend | Line: 52 | Upvalues: WorldSetup (copy), HasGear (copy), LocalPlayer (copy), Oxygen (copy), CurrentCamera (copy), ReplicatedStorage (copy), DepthScreen (copy), RunService (copy), InitScene (copy), TweenService (copy), TweenUtil (copy), TextNotificationController (copy) ]]
	local v1 = WorldSetup:WaitForChild("DivingScene") or workspace:WaitForChild("DivingScene")
	local v2 = WorldSetup:WaitForChild("DivingScene2") or workspace:WaitForChild("DivingScene2")
	if not (HasGear() and LocalPlayer.Character) then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "You don\'t have the Advanced Diving Gear equipped!",
			CustomDuration = 5,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
		return
	end
	local v3 = false
	local v4 = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local v5 = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	local Magnitude = (v2.Points.Start.WorldPosition - v2.Points.End.WorldPosition).Magnitude
	local Magnitude_2 = (v2.Points2.Start.WorldPosition - v2.Points2.End.WorldPosition).Magnitude
	local function SceneUpdater() --[[ SceneUpdater | Line: 64 | Upvalues: Oxygen (ref), v3 (ref), LocalPlayer (ref), CurrentCamera (ref) ]]
		Oxygen.Enabled = false
		if not v3 then
			local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
			CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(CurrentCamera.CFrame.X, HumanoidRootPart.Position.Y, CurrentCamera.CFrame.Z), HumanoidRootPart.Position)
		end
	end
	local Animator = LocalPlayer.Character.Humanoid:FindFirstChild("Animator")
	if Animator then
		local v6 = Animator:LoadAnimation(ReplicatedStorage.Assets.RopeGrab)
		v6.Looped = true
		v6.Priority = Enum.AnimationPriority.Action4
		v6:Play()
		DepthScreen.Enabled = true
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		RunService:BindToRenderStep("CamFollow", Enum.RenderPriority.Camera.Value, SceneUpdater)
		InitScene(v2.Points2.End, v2.Camera2)
		TweenService:Create(DepthScreen.Blackscreen, TweenInfo.new(1, Enum.EasingStyle.Linear), {
			Transparency = 0
		}):Play()
		task.defer(TweenUtil.TweenNumber, DepthScreen.Depth, "%dm", 250, 200, TweenInfo.new(1, Enum.EasingStyle.Linear), true)
		TweenUtil.TweenModelCFrame(LocalPlayer.Character, LocalPlayer.Character:GetPivot() + Vector3.new(0, Magnitude_2, 0), false, TweenInfo.new(1, Enum.EasingStyle.Linear))
		v3 = true
		task.defer(function() --[[ Line: 94 | Upvalues: LocalPlayer (ref), v2 (copy) ]]
			LocalPlayer:RequestStreamAroundAsync(v2.Points.Start.WorldPosition)
		end)
		InitScene(v2.Points.End, v2.Camera)
		v3 = false
		task.defer(TweenUtil.TweenModelCFrame, LocalPlayer.Character, LocalPlayer.Character:GetPivot() + Vector3.new(0, Magnitude, 0), false, v5)
		local v7 = TweenService:Create(DepthScreen.Blackscreen, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0.1), {
			Transparency = 1
		})
		v7:Play()
		v7.Completed:Wait()
		local v8 = TweenService:Create(DepthScreen.Blackscreen, v5, {
			Transparency = 0
		})
		task.defer(function() --[[ Line: 108 | Upvalues: v8 (copy), DepthScreen (ref), TweenService (ref), TweenUtil (ref) ]]
			v8:Play()
			v8.Completed:Wait()
			DepthScreen.LocationText.Text = "Pirate Cove"
			DepthScreen.LocationText["Pirate Cove"].Enabled = true
			DepthScreen.Header.Visible = true
			DepthScreen.LocationText.Visible = true
			local v1 = TweenService:Create(DepthScreen.LocationText, TweenInfo.new(0.5), {
				TextTransparency = 0
			})
			local v2 = TweenService:Create(DepthScreen.LocationText.UIStroke, TweenInfo.new(0.5), {
				Transparency = 0.75
			})
			TweenService:Create(DepthScreen.Header, TweenInfo.new(0.5), {
				TextTransparency = 0
			}):Play()
			TweenService:Create(DepthScreen.Header.UIStroke, TweenInfo.new(0.5), {
				Transparency = 0.7
			}):Play()
			v1:Play()
			v2:Play()
			v1.Completed:Wait()
			task.wait(0.5)
			TweenUtil.TweenAll(DepthScreen, 1, TweenInfo.new(0.25), true)
		end)
		task.defer(TweenUtil.TweenNumber, DepthScreen.Depth, "%dm", 200, 100, v4, true)
		task.wait(v5.Time)
		v3 = true
		task.defer(function() --[[ Line: 137 | Upvalues: LocalPlayer (ref), v1 (copy) ]]
			LocalPlayer:RequestStreamAroundAsync(v1.Points.End.WorldPosition)
		end)
		InitScene(v1.Points.End, v1.Camera)
		workspace:WaitForChild("WorldSetup"):WaitForChild("DivingScene")
		task.wait(1.25)
		v3 = false
		task.defer(TweenUtil.TweenNumber, DepthScreen.Depth, "%dm", 100, 0, v4, true)
		TweenUtil.TweenModelCFrame(LocalPlayer.Character, LocalPlayer.Character:GetPivot() + Vector3.new(0, (v1.Points.Start.WorldPosition - v1.Points.End.WorldPosition).Magnitude, 0), false, v4)
		v6:Stop()
		RunService:UnbindFromRenderStep("CamFollow")
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		LocalPlayer.Character.HumanoidRootPart.Anchored = false
		CurrentCamera.CameraType = Enum.CameraType.Custom
		CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
		ResetUI()
	end
end
local function Descend() --[[ Descend | Line: 172 | Upvalues: WorldSetup (copy), HasGear (copy), LocalPlayer (copy), Oxygen (copy), CurrentCamera (copy), ReplicatedStorage (copy), DepthScreen (copy), InitScene (copy), RunService (copy), TweenService (copy), TweenUtil (copy), TextNotificationController (copy) ]]
	local v1 = WorldSetup:WaitForChild("DivingScene") or workspace:WaitForChild("DivingScene")
	local v2 = WorldSetup:WaitForChild("DivingScene2") or workspace:WaitForChild("DivingScene2")
	if not (HasGear() and LocalPlayer.Character) then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "You don\'t have the Advanced Diving Gear equipped!",
			CustomDuration = 5,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
		return
	end
	local v3 = false
	local v4 = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	local v5 = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local Magnitude = (v1.Points.Start.WorldPosition - v1.Points.End.WorldPosition).Magnitude
	local function SceneUpdater() --[[ SceneUpdater | Line: 183 | Upvalues: Oxygen (ref), v3 (ref), LocalPlayer (ref), CurrentCamera (ref) ]]
		Oxygen.Enabled = false
		if not v3 then
			local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
			CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(CurrentCamera.CFrame.X, HumanoidRootPart.Position.Y, CurrentCamera.CFrame.Z), HumanoidRootPart.Position)
		end
	end
	local Animator = LocalPlayer.Character.Humanoid:FindFirstChild("Animator")
	if Animator then
		local v6 = Animator:LoadAnimation(ReplicatedStorage.Assets.RopeGrab)
		v6.Looped = true
		v6.Priority = Enum.AnimationPriority.Action4
		v6:Play()
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		DepthScreen.Enabled = true
		InitScene(v1.Points.Start, v1.Camera)
		RunService:BindToRenderStep("CamFollow", Enum.RenderPriority.Camera.Value, SceneUpdater)
		TweenService:Create(DepthScreen.Blackscreen, v4, {
			Transparency = 0
		}):Play()
		task.defer(TweenUtil.TweenNumber, DepthScreen.Depth, "%dm", 0, 100, v4, true)
		TweenUtil.TweenModelCFrame(LocalPlayer.Character, LocalPlayer.Character:GetPivot() - Vector3.new(0, Magnitude, 0), false, v4)
		v3 = true
		task.defer(function() --[[ Line: 214 | Upvalues: LocalPlayer (ref), v2 (copy) ]]
			LocalPlayer:RequestStreamAroundAsync(v2.Points.Start.WorldPosition)
		end)
		InitScene(v2.Points.Start, v2.Camera)
		workspace:WaitForChild("WorldSetup"):WaitForChild("DivingScene2")
		task.wait(1)
		v3 = false
		task.defer(TweenUtil.TweenModelCFrame, LocalPlayer.Character, LocalPlayer.Character:GetPivot() - Vector3.new(0, (v2.Points.Start.WorldPosition - v2.Points.End.WorldPosition).Magnitude, 0), false, v5)
		local v7 = TweenService:Create(DepthScreen.Blackscreen, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0.1), {
			Transparency = 1
		})
		v7:Play()
		v7.Completed:Wait()
		local v8 = TweenService:Create(DepthScreen.Blackscreen, v5, {
			Transparency = 0
		})
		task.defer(function() --[[ Line: 233 | Upvalues: v8 (copy), DepthScreen (ref), TweenService (ref), TweenUtil (ref) ]]
			v8:Play()
			v8.Completed:Wait()
			DepthScreen.LocationText.Text = "Crystal Depths"
			DepthScreen.LocationText["Pirate Cove"].Enabled = false
			DepthScreen.LocationText.Visible = true
			DepthScreen.Header.Visible = true
			local v1 = TweenService:Create(DepthScreen.LocationText, TweenInfo.new(0.5), {
				TextTransparency = 0
			})
			local v2 = TweenService:Create(DepthScreen.LocationText.UIStroke, TweenInfo.new(0.5), {
				Transparency = 0.75
			})
			TweenService:Create(DepthScreen.Header, TweenInfo.new(0.5), {
				TextTransparency = 0
			}):Play()
			TweenService:Create(DepthScreen.Header.UIStroke, TweenInfo.new(0.5), {
				Transparency = 0.7
			}):Play()
			v1:Play()
			v2:Play()
			v1.Completed:Wait()
			task.wait(0.5)
			TweenUtil.TweenAll(DepthScreen, 1, TweenInfo.new(0.25), true)
		end)
		task.defer(TweenUtil.TweenNumber, DepthScreen.Depth, "%dm", 100, 200, v4, true)
		task.wait(v5.Time)
		v3 = true
		task.defer(function() --[[ Line: 262 | Upvalues: LocalPlayer (ref), v2 (copy) ]]
			LocalPlayer:RequestStreamAroundAsync(v2.Points2.Start.WorldPosition)
		end)
		InitScene(v2.Points2.Start, v2.Camera2)
		local v9 = TweenService:Create(DepthScreen.Blackscreen, TweenInfo.new(0.25), {
			Transparency = 1
		})
		v9:Play()
		v9.Completed:Wait()
		v3 = false
		task.defer(TweenUtil.TweenNumber, DepthScreen.Depth, "%dm", 200, 250, TweenInfo.new(1, Enum.EasingStyle.Linear), true)
		TweenUtil.TweenModelCFrame(LocalPlayer.Character, LocalPlayer.Character:GetPivot() - Vector3.new(0, (v2.Points2.Start.WorldPosition - v2.Points2.End.WorldPosition).Magnitude, 0), false, TweenInfo.new(1, Enum.EasingStyle.Linear))
		v6:Stop()
		RunService:UnbindFromRenderStep("CamFollow")
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		LocalPlayer.Character.HumanoidRootPart.Anchored = false
		CurrentCamera.CameraType = Enum.CameraType.Custom
		CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
		ResetUI()
	end
end
function ResetUI() --[[ ResetUI | Line: 298 | Upvalues: DepthScreen (copy) ]]
	DepthScreen.Enabled = false
	DepthScreen.Depth.Text = "Depth: 0m"
	DepthScreen.Depth.TextTransparency = 0
	DepthScreen.Blackscreen.Transparency = 1
	DepthScreen.Header.Visible = false
	DepthScreen.LocationText.Visible = false
	DepthScreen.Header.TextTransparency = 0
	DepthScreen.LocationText.TextTransparency = 0
	DepthScreen.Header.UIStroke.Transparency = 0.75
	DepthScreen.LocationText.UIStroke.Transparency = 0.75
	DepthScreen.LocationText["Pirate Cove"].Enabled = false
end
return {
	Start = function(p1) --[[ Start | Line: 318 | Upvalues: WorldSetup (copy), v1 (ref), LocalPlayer (copy), Ascend (copy), Descend (copy) ]]
		local DepthRopePrompts = WorldSetup:WaitForChild("DepthRopePrompts")
		DepthRopePrompts:WaitForChild("Crystal Depths").Ascend.Triggered:Connect(function(p1) --[[ Line: 321 | Upvalues: v1 (ref), LocalPlayer (ref), Ascend (ref) ]]
			if v1 then
				return
			end
			if p1 == LocalPlayer then
				v1 = true
				ResetUI()
				Ascend()
				task.delay(1, function() --[[ Line: 328 | Upvalues: v1 (ref) ]]
					v1 = false
				end)
			end
		end)
		DepthRopePrompts:WaitForChild("Pirate Cove").Descend.Triggered:Connect(function(p1) --[[ Line: 333 | Upvalues: v1 (ref), LocalPlayer (ref), Descend (ref) ]]
			if v1 then
				return
			end
			if p1 == LocalPlayer then
				v1 = true
				ResetUI()
				Descend()
				task.delay(1, function() --[[ Line: 340 | Upvalues: v1 (ref) ]]
					v1 = false
				end)
			end
		end)
	end
}