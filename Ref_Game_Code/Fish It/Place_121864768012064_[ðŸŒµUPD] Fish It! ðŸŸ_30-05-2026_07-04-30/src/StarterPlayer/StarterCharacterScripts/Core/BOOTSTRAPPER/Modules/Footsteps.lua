-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local spr = require(ReplicatedStorage.Packages.spr)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Replion)
local FootstepSounds = require(ReplicatedStorage.Modules.FootstepSounds)
local CurrentCamera = workspace.CurrentCamera
local Character = Players.LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local v1 = 0
local v2 = 0
local v3 = nil
local t = {}
local t2 = {}
local v4 = Trove.new()
local BlockedHumanoidStates = require(ReplicatedStorage.Shared.BlockedHumanoidStates)
return {
	Start = function(p1) --[[ Start | Line: 39 | Upvalues: RunService (copy), v4 (copy), Humanoid (copy), v1 (ref), HumanoidRootPart (copy), Character (copy) ]]
		RunService:BindToRenderStep("UpdateVolume", Enum.RenderPriority.Camera.Value, function(p12) --[[ Line: 40 | Upvalues: p1 (copy) ]]
			p1:UpdateVolumeMultiplier(p12)
			p1:Update(p12)
		end)
		v4:Add(Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function() --[[ Line: 45 | Upvalues: p1 (copy) ]]
			p1:Refresh()
		end))
		v4:Add(Humanoid.Running:Connect(function(p12) --[[ Line: 48 | Upvalues: v1 (ref), p1 (copy) ]]
			v1 = p12
			p1:Refresh()
		end))
		v4:Add(HumanoidRootPart:GetPropertyChangedSignal("Position"):Connect(function() --[[ Line: 52 | Upvalues: p1 (copy) ]]
			p1:Refresh()
		end))
		v4:Add(Character.Destroying:Once(function() --[[ Line: 56 | Upvalues: p1 (copy) ]]
			p1:Destroy()
		end))
		v4:Add(Humanoid.Died:Connect(function() --[[ Line: 59 | Upvalues: p1 (copy) ]]
			p1:Destroy()
		end))
	end,
	Update = function(p1, p2) --[[ Update | Line: 64 | Upvalues: v2 (ref), t (copy), FootstepSounds (copy) ]]
		local v1 = v2
		for v22, v3 in t do
			if not v3:GetAttribute("Destroying") then
				local v4 = FootstepSounds[v22]
				if v4 then
					local v5 = v4.volume * v1
					if v3.Volume ~= v5 then
						v3.Volume = v5
					end
				end
			end
		end
	end,
	Refresh = function(p1, p2) --[[ Refresh | Line: 85 | Upvalues: Humanoid (copy), BlockedHumanoidStates (copy), FootstepSounds (copy), v1 (ref), t2 (copy), v3 (ref), t (copy), SoundService (copy) ]]
		local FloorMaterial = Humanoid.FloorMaterial
		local v12 = FloorMaterial.Name
		local v2 = Humanoid:GetState()
		if table.find(BlockedHumanoidStates.Footsteps, v2) then
			p1:DestroyAllSounds()
			return
		end
		local v32 = FootstepSounds[v12]
		if not v32 then
			p1:DestroyAllSounds()
			return
		end
		if Humanoid.MoveDirection.Magnitude == 0 or (v1 < 12 or v2 ~= Enum.HumanoidStateType.Running) then
			p1:DestroyAllSounds()
			return
		end
		local v4 = os.clock()
		local v5 = t2[v12] or 0
		if v4 < v5 then
			if p2 then
				return
			end
			task.defer(function() --[[ Line: 111 | Upvalues: v5 (copy), v4 (copy), p1 (copy) ]]
				task.wait(v5 - v4)
				p1:Refresh(true)
			end)
		else
			if v3 ~= FloorMaterial then
				p1:DestroyAllSounds()
			end
			if t[FloorMaterial.Name] == nil then
				local Sound = Instance.new("Sound")
				Sound.Name = FloorMaterial.Name
				Sound.SoundId = v32.id
				Sound.Volume = v32.volume
				Sound.PlaybackSpeed = v32.speed
				Sound.Looped = true
				Sound.Parent = SoundService
				t[FloorMaterial.Name] = Sound
				Sound:Play()
				t2[FloorMaterial.Name] = os.clock() + (0.5 + math.random())
			end
			v3 = FloorMaterial
		end
	end,
	UpdateVolumeMultiplier = function(p1, p2) --[[ UpdateVolumeMultiplier | Line: 143 | Upvalues: CurrentCamera (copy), HumanoidRootPart (copy), v2 (ref) ]]
		v2 = 1 - math.min((CurrentCamera.CFrame.Position - HumanoidRootPart.Position).Magnitude, 40) / 40
	end,
	DestroySound = function(p1, p2, p3) --[[ DestroySound | Line: 152 | Upvalues: t (copy), spr (copy), SoundService (copy) ]]
		if not p3:GetAttribute("Destroying") then
			p3:SetAttribute("Destroying", true)
			t[p2] = nil
			spr.stop(p3)
			spr.target(p3, 90, 325, {
				Volume = 0
			})
			task.delay(0.4, function() --[[ Line: 165 | Upvalues: p3 (copy), SoundService (ref) ]]
				if not p3:IsDescendantOf(SoundService) then
					return
				end
				p3:Destroy()
			end)
		end
	end,
	DestroyAllSounds = function(p1) --[[ DestroyAllSounds | Line: 172 | Upvalues: t (copy), v3 (ref) ]]
		for v1, v2 in t do
			p1:DestroySound(v1, v2)
		end
		v3 = nil
	end,
	Destroy = function(p1) --[[ Destroy | Line: 179 | Upvalues: RunService (copy), t (copy), v4 (copy) ]]
		RunService:UnbindFromRenderStep("UpdateVolume")
		for v1, v2 in t do
			v2:SetAttribute("Destroying", true)
			v2:Destroy()
		end
		table.clear(t)
		v4:Destroy()
	end
}