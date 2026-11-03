-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local CurrentCamera = workspace.CurrentCamera
local _ = {
	["Freshwater Piranha"] = Color3.fromRGB(97, 129, 188),
	["Goliath Tiger"] = Color3.fromRGB(160, 109, 190),
	["Sacred Guardian Squid"] = Color3.fromRGB(177, 153, 96),
	Crocodile = Color3.fromRGB(172, 88, 89)
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
		spr.target(LDoor, 2, 0.5, {
			Pivot = v2
		})
	end
	local v3 = RDoor:GetAttribute(v1)
	if v3 then
		spr.target(RDoor, 2, 0.5, {
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
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 74 | Upvalues: SetCollisions (copy), OpenDoorTarget (copy), Observers (copy), Trove (copy) ]]
	local function OpenDoor(p12, p2) --[[ OpenDoor | Line: 77 | Upvalues: p1 (copy), SetCollisions (ref), OpenDoorTarget (ref) ]]
		if p1:GetExpect("UnlockedRuins") then
			SetCollisions(p12, false)
			OpenDoorTarget(p12, true)
		end
	end
	Observers.observeTag("RuinDoor", function(p12) --[[ Line: 134 | Upvalues: Trove (ref), p1 (copy), SetCollisions (ref), OpenDoorTarget (ref) ]]
		local v1 = Trove.new()
		v1:Add(p1:OnChange("UnlockedRuins", function(p13) --[[ Line: 139 | Upvalues: p12 (copy), p1 (ref), SetCollisions (ref), OpenDoorTarget (ref) ]]
			task.wait(1)
			local v1 = p12
			if p1:GetExpect("UnlockedRuins") then
				SetCollisions(v1, false)
				OpenDoorTarget(v1, true)
			end
		end))
		if not p1:GetExpect("UnlockedRuins") then
			return function() --[[ Line: 150 | Upvalues: v1 (ref) ]]
				if not v1 then
					return
				end
				v1:Destroy()
				v1 = nil
			end
		end
		SetCollisions(p12, false)
		OpenDoorTarget(p12, true)
		return function() --[[ Line: 150 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end
			v1:Destroy()
			v1 = nil
		end
	end)
end)
return {}