-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Replion)
local Transition = require(ReplicatedStorage.Controllers.CutsceneController.Internal.Transition)
local v1 = Net:RemoteEvent("SubmarineTP")
local v2 = Net:RemoteFunction("SubmarineTP2")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local SubmarineObject = ReplicatedStorage.Assets:WaitForChild("SubmarineObject")
local t = {
	Settings = {
		DropStuds = 22,
		DropTime = 6,
		HoldTime = 0.3,
		CameraDistance = 24,
		CameraHeight = 3,
		CameraSideOffset = 2,
		SubmarineObject = nil,
		PlayerOffset = CFrame.new(0, 1.8, 0),
		EasingStyle = Enum.EasingStyle.Sine,
		EasingDirection = Enum.EasingDirection.InOut
	}
}
local v3 = false
local v4 = nil
local Custom = Enum.CameraType.Custom
local v5 = nil
local function SetHumanoid(p1, p2) --[[ SetHumanoid | Line: 59 ]]
	if p2 then
		p1.Sit = true
		p1:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		p1:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		p1:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		local Animator = p1:FindFirstChildOfClass("Animator")
		if not Animator then
			return
		end
		for v1, v2 in Animator:GetPlayingAnimationTracks() do
			v2:Stop()
		end
		return
	end
	p1:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	p1:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	p1:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end
local function WeldCharacter(p1, p2, p3) --[[ WeldCharacter | Line: 79 ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		local Seat = p2:FindFirstChild("Seat")
		HumanoidRootPart.Anchored = false
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		HumanoidRootPart.CFrame = p2.CFrame * p3
		local Weld = Instance.new("Weld")
		Weld.Part0 = Seat
		Weld.Part1 = HumanoidRootPart
		Weld.C0 = p2.CFrame:ToObjectSpace(HumanoidRootPart.CFrame)
		Weld.C1 = CFrame.identity
		Weld.Parent = p2
		return Weld
	else
		return nil
	end
end
local function StartCamera(p1) --[[ StartCamera | Line: 102 | Upvalues: Custom (ref), CurrentCamera (copy), v5 (ref), CollectionService (copy), ReplicatedStorage (copy), SubmarineObject (copy), t (copy), v4 (ref), RunService (copy), v3 (ref) ]]
	Custom = CurrentCamera.CameraType
	v5 = CurrentCamera.CameraSubject
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	for v1, v2 in CollectionService:GetTagged("Submarine") do
		v2.Parent = ReplicatedStorage
	end
	local v32 = SubmarineObject:Clone()
	v32.Parent = workspace
	local v42 = v32.CFrame
	local v6 = v32.Position + v42.LookVector * p1.CameraDistance + v42.RightVector * p1.CameraSideOffset + Vector3.new(0, p1.CameraHeight, 0)
	t.Settings.SubmarineObject = v32
	local v7 = 0
	v4 = RunService.RenderStepped:Connect(function(p1) --[[ Line: 121 | Upvalues: v3 (ref), v7 (ref), v6 (copy), v32 (copy), CurrentCamera (ref) ]]
		if v3 then
			v7 = v7 + 0.10471975511965978 * p1
			CurrentCamera.CFrame = CFrame.lookAt(v32.Position + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v7):VectorToWorldSpace(v6 - v32.Position), v32.Position, Vector3.new(0, 1, 0))
		end
	end)
end
local function StopCamera() --[[ StopCamera | Line: 137 | Upvalues: v4 (ref), CurrentCamera (copy), LocalPlayer (copy) ]]
	if v4 then
		v4:Disconnect()
		v4 = nil
	end
	CurrentCamera.CameraType = Enum.CameraType.Custom
	local Character = LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if not v1 then
		return
	end
	CurrentCamera.CameraSubject = v1
end
function t.Play(p1, p2) --[[ Play | Line: 152 | Upvalues: v3 (ref), LocalPlayer (copy), SetHumanoid (copy), StartCamera (copy), WeldCharacter (copy), TweenService (copy) ]]
	if v3 then
		return
	end
	v3 = true
	local v1 = LocalPlayer and LocalPlayer.Character
	if not v1 then
		v3 = false
		return
	end
	local Humanoid = v1:FindFirstChild("Humanoid")
	if not Humanoid then
		v3 = false
		return
	end
	SetHumanoid(Humanoid, true)
	StartCamera(p1.Settings)
	local SubmarineObject = p1.Settings.SubmarineObject
	if not SubmarineObject then
		return
	end
	local v2 = WeldCharacter(v1, SubmarineObject, p1.Settings.PlayerOffset)
	local v32 = SubmarineObject.CFrame * CFrame.new(0, -p1.Settings.DropStuds, 0)
	local Sound = SubmarineObject:FindFirstChild("Sound")
	local v4 = TweenService:Create(SubmarineObject, TweenInfo.new(p1.Settings.DropTime, p1.Settings.EasingStyle, p1.Settings.EasingDirection), {
		CFrame = v32
	})
	Humanoid.Sit = true
	task.wait(1)
	v4:Play()
	Sound:Play()
	task.wait(p1.Settings.DropTime - 0.85)
	local _ = p1.Settings.HoldTime > 0
	v3 = false
	if not p2 then
		return
	end
	Humanoid.Sit = false
	p2()
	if v2 then
		v2:Destroy()
	end
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end
function t.Start(p1) --[[ Start | Line: 213 | Upvalues: v1 (copy), Transition (copy), LocalPlayer (copy), v4 (ref), CurrentCamera (copy), v2 (copy), CollectionService (copy) ]]
	v1.OnClientEvent:Connect(function() --[[ Line: 214 | Upvalues: p1 (copy), Transition (ref), LocalPlayer (ref), v4 (ref), CurrentCamera (ref), v2 (ref), CollectionService (ref) ]]
		p1:Play(function() --[[ Line: 215 | Upvalues: Transition (ref), LocalPlayer (ref), p1 (ref), v4 (ref), CurrentCamera (ref), v2 (ref), CollectionService (ref) ]]
			local v1 = Transition.new(LocalPlayer.PlayerGui)
			v1:Play("In", true)
			local SubmarineObject = p1.Settings.SubmarineObject
			if SubmarineObject then
				SubmarineObject:Destroy()
			end
			if v4 then
				v4:Disconnect()
				v4 = nil
			end
			CurrentCamera.CameraType = Enum.CameraType.Custom
			local Character = LocalPlayer.Character
			local v22 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
			if v22 then
				CurrentCamera.CameraSubject = v22
			end
			v2:InvokeServer()
			task.wait(0.35)
			for v3, v42 in CollectionService:GetTagged("Submarine") do
				v42.Parent = workspace
			end
			v1:Play("Out", true)
			if v1 then
				v1:Destroy()
			end
			if v4 then
				v4:Disconnect()
				v4 = nil
			end
			CurrentCamera.CameraType = Enum.CameraType.Custom
			local Character_2 = LocalPlayer.Character
			local v5 = if Character_2 then Character_2:FindFirstChildWhichIsA("Humanoid") else Character_2
			if not v5 then
				return
			end
			CurrentCamera.CameraSubject = v5
		end)
	end)
end
return t