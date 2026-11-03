-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
local TimedUpgradesServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.TimedUpgradesServiceClient)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local RarityData = require(ReplicatedStorage.Shared.Data.RarityData)
local KickData = require(ReplicatedStorage.Shared.Data.KickData)
local GetPoint = require(ReplicatedStorage.Shared.Functional.GetPoint)
local CurrentCamera = workspace.CurrentCamera
local v1 = RaycastParams.new()
v1.FilterType = Enum.RaycastFilterType.Include
local MIN_SPEED = KickData.MIN_SPEED
local MAX_SPEED = KickData.MAX_SPEED
local MAX_DISTANCE = KickData.MAX_DISTANCE
local t = {
	InMinigame = false,
	InMinigameChanged = Signal.new(),
	Scale = 0,
	TravelRatio = 0
}
function GetMultiplier() --[[ GetMultiplier | Line: 38 | Upvalues: KickServiceClient (copy), TimedUpgradesServiceClient (copy) ]]
	return 1 * (KickServiceClient.Multipliers.Speed or 1) * TimedUpgradesServiceClient:GetMultiplierForType("kick_speed")
end
function t.Kick(p1, p2, p3, p4, p5) --[[ Kick | Line: 50 | Upvalues: v1 (copy), CollectionService (copy), MAX_DISTANCE (copy), MIN_SPEED (copy), MAX_SPEED (copy), Signal (copy), CurrentCamera (copy), TweenService (copy), RunService (copy), RarityData (copy), GetPoint (copy) ]]
	v1.FilterDescendantsInstances = CollectionService:GetTagged("Floor")
	local v12 = p3 + p5 * p4
	local v2 = workspace:Raycast(v12, Vector3.new(0, -20, 0), v1)
	if v2 then
		v12 = v2.Position
	end
	local v3 = math.min(p4 / 4, 650)
	local v4 = v12
	local t = {
		p3,
		p3 + p5 * p4 * 0.33 + Vector3.new(0, v3, 0),
		p3 + p5 * p4 * 0.66 + Vector3.new(0, v3, 0),
		v4
	}
	local v8 = math.clamp(p4 / MAX_DISTANCE, 0, 1)
	local v9 = (MIN_SPEED + (MAX_SPEED - MIN_SPEED) * math.sqrt(v8) * 0.5) * GetMultiplier()
	local v10 = 0
	local v11 = CFrame.Angles(0, 0, 0)
	local v122 = nil
	local v13 = Signal.new()
	local v14 = Signal.new()
	CurrentCamera.FieldOfView = 70
	TweenService:Create(CurrentCamera, TweenInfo.new(1), {
		FieldOfView = 110
	}):Play()
	local v15 = nil
	v122 = RunService.PreSimulation:Connect(function(p1) --[[ Line: 83 | Upvalues: v10 (ref), v9 (ref), p4 (copy), RarityData (ref), v15 (ref), v13 (copy), v11 (ref), p2 (copy), GetPoint (ref), t (copy), v122 (ref), TweenService (ref), CurrentCamera (ref), p5 (copy), v12 (ref), v14 (copy) ]]
		v10 = v10 + v9 * p1
		v10 = math.min(v10, p4)
		local v4 = math.clamp(v10 / p4, 0, 1)
		local v5 = RarityData:GetRarityByDistance(v10)
		if v5 ~= v15 then
			v15 = v5
			v13:Fire(v5)
		end
		v11 = v11 * CFrame.Angles(math.rad(p1 * 90), 0, (math.rad(p1 * 90)))
		p2.CFrame = CFrame.new(GetPoint(v4, t)) * v11
		if v4 == 1 then
			v122:Disconnect()
			TweenService:Create(CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 70
			}):Play()
			local v6 = (Vector3.new(0, 1, 0)):Cross(-p5)
			p2.CFrame = CFrame.fromMatrix(v12 + Vector3.new(0, p2.Size.Y / 2, 0), v6, Vector3.new(0, 1, 0), -p5)
			v14:Fire(v12)
			v14:Destroy()
		end
	end)
	return v13, v14
end
function t.PerformKick(p1, p2, p3) --[[ PerformKick | Line: 110 | Upvalues: CurrentCamera (copy), TweenService (copy), RunService (copy), t (copy), Signal (copy) ]]
	if p2 and p2.PrimaryPart then
		if p3 then
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local v1 = p2.PrimaryPart.CFrame * CFrame.new(6, 1, 6) * CFrame.Angles(0, 0.2617993877991494, 0)
			TweenService:Create(CurrentCamera, TweenInfo.new(1), {
				CFrame = v1
			}):Play()
		end
		local v2 = 0
		local v3 = 1
		local v4 = RunService.PreRender:Connect(function(p1) --[[ Line: 127 | Upvalues: v2 (ref), v3 (ref), t (ref) ]]
			v2 = math.clamp(v2 + v3 * p1 * 2, 0, 1)
			if v2 >= 1 then
				v3 = -1
			elseif v2 <= 0 then
				v3 = 1
			end
			t.Scale = v2
		end)
		local v5 = Signal.new()
		v5:Connect(function() --[[ Line: 141 | Upvalues: v4 (ref), v5 (copy), t (ref), p3 (copy), CurrentCamera (ref) ]]
			v4:Disconnect()
			v5:Destroy()
			t.InMinigame = false
			t.InMinigameChanged:Fire(false)
			if p3 then
				CurrentCamera.CameraType = Enum.CameraType.Custom
			end
		end)
		t.InMinigame = true
		t.InMinigameChanged:Fire(true)
		return v5
	end
end
return t