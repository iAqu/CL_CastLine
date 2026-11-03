-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local CurrentCamera = workspace.CurrentCamera
local t = {
	["Crescent Artifact"] = Color3.fromRGB(112, 255, 69),
	["Arrow Artifact"] = Color3.fromRGB(255, 47, 47),
	["Hourglass Diamond Artifact"] = Color3.fromRGB(255, 248, 49),
	["Diamond Artifact"] = Color3.fromRGB(219, 38, 255)
}
local function SetCollisions(p1, p2) --[[ SetCollisions | Line: 28 ]]
	for k, v in pairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = p2
			v.CanQuery = p2
			v.CanTouch = p2
		end
	end
end
local function OpenDoorTarget(p1, p2) --[[ OpenDoorTarget | Line: 40 | Upvalues: spr (copy), Soundbook (copy), SetCollisions (copy) ]]
	local LDoor = p1:WaitForChild("LDoor")
	local RDoor = p1:WaitForChild("RDoor")
	spr.stop(LDoor)
	spr.stop(RDoor)
	local v1 = if p2 then "TargetCF" else "OriginOffset"
	local v2 = LDoor:GetAttribute(v1)
	if v2 then
		spr.target(LDoor, 1, 3, {
			Pivot = v2
		})
	end
	local v3 = RDoor:GetAttribute(v1)
	if v3 then
		spr.target(RDoor, 1, 3, {
			Pivot = v3
		})
	end
	if not (p2 and (v2 and (workspace.CurrentCamera.CFrame.Position - v2.Position).Magnitude <= 500)) then
		SetCollisions(p1, not p2)
		return
	end
	Soundbook.Sounds.JungleDoorOpen:Play()
	SetCollisions(p1, not p2)
end
Observers.observeTag("AutoDoor", function(p1) --[[ Line: 74 | Upvalues: OpenDoorTarget (copy) ]]
	local LDoor = p1:WaitForChild("LDoor")
	local RDoor = p1:WaitForChild("RDoor")
	if not LDoor:GetAttribute("OriginOffset") then
		LDoor:SetAttribute("OriginOffset", LDoor:GetPivot())
	end
	if RDoor:GetAttribute("OriginOffset") then
		OpenDoorTarget(p1, true)
		return function() --[[ Line: 90 | Upvalues: OpenDoorTarget (ref), p1 (copy) ]]
			OpenDoorTarget(p1, false)
		end
	end
	RDoor:SetAttribute("OriginOffset", RDoor:GetPivot())
	OpenDoorTarget(p1, true)
	return function() --[[ Line: 90 | Upvalues: OpenDoorTarget (ref), p1 (copy) ]]
		OpenDoorTarget(p1, false)
	end
end)
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 95 | Upvalues: t (copy), spr (copy), CurrentCamera (copy), SetCollisions (copy), OpenDoorTarget (copy), Observers (copy), Trove (copy), ReplicatedStorage (copy), CollectionService (copy) ]]
	local function LightUpJewel(p12) --[[ LightUpJewel | Line: 98 | Upvalues: p1 (copy), t (ref) ]]
		if p1:GetExpect("UnlockedTemple") then
			return
		end
		local v1 = p1:GetExpect("TempleLevers")
		if not v1 then
			return
		end
		for k, v in pairs(v1) do
			local v2 = p12.Markings:FindFirstChild(k)
			if v2 then
				v2.PrimaryPart.Color = t[k]
			end
		end
	end
	local function OpenDoor(p12, p2) --[[ OpenDoor | Line: 122 | Upvalues: p1 (copy), spr (ref), t (ref), CurrentCamera (ref), SetCollisions (ref), OpenDoorTarget (ref) ]]
		if not p1:GetExpect("UnlockedTemple") then
			return
		end
		local DELETE_ME_AFTER_UNLOCK = p12:FindFirstChild("DELETE_ME_AFTER_UNLOCK")
		if DELETE_ME_AFTER_UNLOCK then
			DELETE_ME_AFTER_UNLOCK:Destroy()
		end
		task.delay(2, function() --[[ Line: 133 | Upvalues: p12 (copy), spr (ref), t (ref) ]]
			for k, v in pairs(p12.Markings:GetChildren()) do
				if v:IsA("Model") then
					v.PrimaryPart.Color = Color3.fromRGB(34, 30, 29)
					spr.stop(v.PrimaryPart)
					spr.target(v.PrimaryPart, 1, 3, {
						Color = t[v.Name]
					})
					task.wait(0.45)
				end
			end
		end)
		if p2 then
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			spr.target(CurrentCamera, 1, 1, {
				CFrame = p12.CameraPart.CFrame
			})
			task.wait(4)
		end
		SetCollisions(p12, false)
		OpenDoorTarget(p12, true)
		task.delay(2, function() --[[ Line: 174 | Upvalues: spr (ref), CurrentCamera (ref) ]]
			spr.stop(CurrentCamera)
			CurrentCamera.CameraType = Enum.CameraType.Custom
			CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
		end)
	end
	Observers.observeTag("TempleDoor", function(p12) --[[ Line: 185 | Upvalues: Trove (ref), p1 (copy), LightUpJewel (copy), OpenDoor (copy) ]]
		local v1 = Trove.new()
		v1:Add(p1:OnChange("TempleLevers", function() --[[ Line: 190 | Upvalues: LightUpJewel (ref), p12 (copy) ]]
			LightUpJewel(p12)
		end))
		v1:Add(p1:OnChange("UnlockedTemple", function(p1) --[[ Line: 196 | Upvalues: OpenDoor (ref), p12 (copy) ]]
			task.wait(3)
			OpenDoor(p12, true)
		end))
		LightUpJewel(p12)
		OpenDoor(p12, false)
		return function() --[[ Line: 210 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end
			v1:Destroy()
			v1 = nil
		end
	end)
	local ClientTimeController = require(ReplicatedStorage.Controllers.ClientTimeController)
	local function TimeChanged() --[[ TimeChanged | Line: 222 | Upvalues: CollectionService (ref), ClientTimeController (copy) ]]
		local v1 = CollectionService:GetTagged("MysteriousDoor")
		if ClientTimeController:IsNightTime() then
			for i, v in ipairs(v1) do
				v:AddTag("AutoDoor")
			end
		else
			for i, v in ipairs(v1) do
				v:RemoveTag("AutoDoor")
			end
		end
	end
	ClientTimeController.NightTimeChanged:Connect(TimeChanged)
	TimeChanged()
end)
return {}