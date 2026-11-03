-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(ReplicatedStorage.Shared.Data.RarityData)
local WaveData = require(ReplicatedStorage.Shared.Data.WaveData)
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local v1 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local WaveBlur = v1.WaveBlur
local Run = v1.Run
local Alarm = SoundService.Effects.Alarm
local Siren = SoundService.Effects.Siren
local COMEHERE = SoundService.Effects.COMEHERE
local t = {}
function CameraTargetWave(p1, p2) --[[ CameraTargetWave | Line: 39 | Upvalues: CurrentCamera (copy), TweenService (copy) ]]
	local v1 = p1.Position + p1.LookVector * p2 + Vector3.new(0, 3, 0)
	local v4 = CFrame.new(Vector3.new(v1.X, math.max(v1.Y, 10), v1.Z), p1.Position)
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	local v5 = TweenService:Create(CurrentCamera, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		CFrame = v4
	})
	v5:Play()
	return v5
end
function RaiseWave(p1, p2, p3, p4) --[[ RaiseWave | Line: 50 | Upvalues: TweenService (copy), Alarm (copy) ]]
	if p1.PrimaryPart or p1:FindFirstChild("RootPart") then
		local v2 = p2 * Vector3.new(1, 0, 1) + Vector3.new(0, p4, 0)
		local v3 = p3 * Vector3.new(1, 0, 1) + Vector3.new(0, p4, 0)
		local v4 = TweenService:Create(p1.PrimaryPart, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			CFrame = CFrame.lookAt(v2, v3)
		})
		Alarm:Play()
		v4:Play()
		v4.Completed:Wait()
	end
end
function RestoreCameraToPlayer(p1) --[[ RestoreCameraToPlayer | Line: 64 | Upvalues: CurrentCamera (copy), TweenService (copy) ]]
	if p1 then
		local PrimaryPart = p1.PrimaryPart
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		local v2 = CFrame.new(PrimaryPart.Position - PrimaryPart.CFrame.LookVector * 80 + Vector3.new(0, 3, 0), PrimaryPart.Position)
		local v3 = TweenService:Create(CurrentCamera, TweenInfo.new(0.6666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			CFrame = v2
		})
		v3:Play()
		v3.Completed:Connect(function() --[[ Line: 76 | Upvalues: CurrentCamera (ref), v2 (copy), p1 (copy) ]]
			CurrentCamera.CameraType = Enum.CameraType.Custom
			CurrentCamera.CFrame = v2
			CurrentCamera.CameraSubject = p1.Humanoid
		end)
	end
end
function OnStartedRunning() --[[ OnStartedRunning | Line: 84 | Upvalues: WaveBlur (copy), Run (copy), COMEHERE (copy), Siren (copy) ]]
	WaveBlur.Visible = true
	Run.Visible = true
	COMEHERE:Play()
	Siren:Play()
end
function OnRunEnded() --[[ OnRunEnded | Line: 91 | Upvalues: WaveBlur (copy), Run (copy) ]]
	WaveBlur.Visible = false
	Run.Visible = false
end
function t.SpawnWave(p1, p2) --[[ SpawnWave | Line: 98 | Upvalues: LocalPlayer (copy), WaveData (copy), CurrentCamera (copy), RunService (copy) ]]
	local Character = LocalPlayer.Character
	if Character and Character.PrimaryPart then
		local v1 = WaveData.Waves[p2]
		if v1 then
			local v2 = OverlapParams.new()
			v2.FilterType = Enum.RaycastFilterType.Include
			v2.FilterDescendantsInstances = { Character.PrimaryPart }
			local v3 = v1.Model:Clone()
			local v4 = v3.PrimaryPart or v3:WaitForChild("RootPart")
			local v5 = Vector3.new(v1.Start_X, -20, 231)
			local v6 = CFrame.lookAt(v5, Vector3.new(671, -20, 231))
			v3:PivotTo(v6)
			v3.Parent = workspace.Waves
			local v8 = v1.CameraDistance or 50
			local v10 = true
			local v11 = nil
			CameraTargetWave(v6, v8).Completed:Once(function() --[[ Line: 135 | Upvalues: v10 (ref), v11 (ref), v4 (copy), v3 (copy), v8 (copy), CurrentCamera (ref) ]]
				if v10 then
					v11 = v4:GetPropertyChangedSignal("Position"):Connect(function() --[[ Line: 140 | Upvalues: v3 (ref), v8 (ref), CurrentCamera (ref) ]]
						local v1 = v3:GetPivot()
						local v2 = v1.Position + v1.LookVector * v8 + Vector3.new(0, 3, 0)
						CurrentCamera.CFrame = CFrame.new(Vector3.new(v2.X, math.max(v2.Y, 10), v2.Z), v1.Position)
					end)
				end
			end)
			RaiseWave(v3, v5, Vector3.new(671, -20, 231), -10.5 + v4.Size.Y / 2)
			if v11 and v11.Connected then
				v11:Disconnect()
			end
			v10 = false
			RestoreCameraToPlayer(Character)
			OnStartedRunning()
			local v12 = 0
			task.delay(1, function() --[[ Line: 164 | Upvalues: v12 (ref), v1 (copy) ]]
				v12 = v1.Speed
			end)
			local Unit = (Vector3.new(671, -20, 231) - v5).Unit
			v4.Anchored = true
			local v13 = CFrame.lookAt(Vector3.new(0, 0, 0), Unit)
			local v14 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 173 | Upvalues: v4 (copy), Character (copy), v12 (ref), v13 (copy), Unit (copy), v2 (copy) ]]
				if v4 and (Character and Character.Parent == workspace.Players and not (v12 <= 0)) then
					v4.CFrame = v13 + (v4.Position + Unit * v12 * p1)
					local v1 = workspace:GetPartsInPart(v4, v2)
					if #v1 > 0 and table.find(v1, Character.PrimaryPart) then
						Character.Humanoid:TakeDamage(1000)
					end
					if (Character.PrimaryPart.Position - v4.Position):Dot(Unit) < 0 then
						Character.Humanoid:TakeDamage(1000)
					end
				end
			end)
			return function() --[[ Line: 204 | Upvalues: v14 (ref), v3 (copy), LocalPlayer (ref), Character (copy), CurrentCamera (ref) ]]
				OnRunEnded()
				v14:Disconnect()
				v3:Destroy()
				if LocalPlayer.Character ~= Character then
					CurrentCamera.CameraType = Enum.CameraType.Custom
					if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
						return
					end
					CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
				end
			end
		end
	end
end
return t