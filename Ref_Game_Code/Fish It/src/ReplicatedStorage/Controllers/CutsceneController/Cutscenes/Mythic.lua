-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("TweenService")
game:GetService("RunService")
local Players = game:GetService("Players")
game:GetService("Debris")
local v1 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Cutscenes")[script.Name]
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Shared.ItemUtility)
local SebasUtil = require(ReplicatedStorage.Modules.SebasUtil)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Controllers.VFXController)
local CameraShaker = require(ReplicatedStorage.Modules.CameraShaker)
require(ReplicatedStorage.Modules.CameraShaker.CameraShakeInstance)
local Transition = require(ReplicatedStorage.Controllers.CutsceneController.Internal.Transition)
local CoreCall = require(ReplicatedStorage.Modules.CoreCall)
local CurrentCamera = workspace.CurrentCamera
local VFX = workspace:WaitForChild("VFX")
local t = {}
t.__index = t
Random.new(os.clock())
local function camShake(p1) --[[ camShake | Line: 38 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera
	v1.CFrame = v1.CFrame * p1
end
local v2 = CameraShaker.new(Enum.RenderPriority.Last.Value, camShake)
v2:Start()
function t.new(p1, p2) --[[ new | Line: 45 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = Trove.new()
	v2.Destroyed = false
	v2.Properties = {
		SpawnHeight = 500,
		SpawnRadius = 500,
		Duration = 3.5
	}
	return v2
end
function t.Play(p1, p2, p3, p4, p5) --[[ Play | Line: 60 | Upvalues: Transition (copy), Players (copy), CoreCall (copy), VFX (copy), SebasUtil (copy), v1 (copy), CurrentCamera (copy), Soundbook (copy), v2 (copy), CameraShaker (copy) ]]
	local v12
	if p5 then
		v12 = Transition.new(Players.LocalPlayer.PlayerGui)
		CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, false)
		CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, false)
		v12:Play("In", true)
	else
		v12 = nil
	end
	task.wait(0.8)
	local v22 = p1.Cleaner:Clone(p4)
	v22.Parent = VFX
	SebasUtil:AnchorAll(v22)
	SebasUtil:DisableAllCollisions(v22)
	v22:PivotTo(CFrame.lookAt(p3 + Vector3.new(0, p1.Properties.SpawnHeight, 0) + SebasUtil:randPointInHorizDisc(p1.Properties.SpawnRadius - 1, p1.Properties.SpawnRadius), p3))
	local Position = v22:GetPivot().Position
	local v3 = v22:GetExtentsSize()
	local v5 = p1.Cleaner:Clone(v1.MeteorVfx)
	local v6 = v5:GetExtentsSize()
	local v8 = math.clamp(v6.X * v6.Y * v6.Z / (v3.X * v3.Y * v3.Z), 0.01, 20)
	v22:ScaleTo(v22:GetScale() * v8)
	v5:PivotTo(v22:GetPivot())
	v5.Parent = v22
	if p5 then
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
	end
	local v9 = p3 + (p3 - Position).Unit * v22:GetExtentsSize().Z
	task.spawn(function() --[[ Line: 106 | Upvalues: v12 (ref), Soundbook (ref), p5 (copy) ]]
		if v12 then
			v12:Play("Out", false)
		end
		local v1 = Soundbook.Sounds["Cutscene - Mythic"]:Play()
		if p5 then
			return
		end
		v1.Volume = v1.Volume / 2
	end)
	local v10 = false
	local function moveFish(p1, p2, p32) --[[ moveFish | Line: 127 | Upvalues: v22 (copy), Position (copy), p3 (copy), p5 (copy), CurrentCamera (ref), SebasUtil (ref), v10 (ref), v5 (copy), v2 (ref), CameraShaker (ref) ]]
		v22:PivotTo(CFrame.lookAt(Position:Lerp(p3, p32 ^ 2), p3 + Vector3.new(-0, -0.1, -0)))
		if p5 then
			CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, v22:GetPivot().Position)
			CurrentCamera.FieldOfView = SebasUtil:lerp(2, 65, p32 ^ 2)
		end
		if not (p32 >= 0.65) or v10 then
			return
		end
		v10 = true
		SebasUtil:EnableAllParticles(v5.Fire)
		if not p5 then
			return
		end
		v2:Shake(CameraShaker.Presets.Bump)
	end
	SebasUtil:RenderStepLoopFor(p1.Properties.Duration, moveFish, Enum.RenderPriority.Last.Value, function() --[[ Line: 144 | Upvalues: p1 (copy), p5 (copy), CurrentCamera (ref), v2 (ref), SebasUtil (ref), v22 (copy), v1 (ref), VFX (ref), p3 (copy), v9 (copy), Position (copy) ]]
		p1._camDisabled = p5
		local v12, v23, v3, v4
		if not p5 then
			SebasUtil:DisableAllParticles(v22)
			v12 = p1.Cleaner:Clone(v1.Impact)
			v12.Parent = VFX
			v12.Position = p3
			SebasUtil:EnableAllParticles(v12)
			v23 = v22:GetPivot().Position
			v3 = function(p1_2, p2_2, p3_2) --[[ lerp2 | Line: 160 | Upvalues: v22 (ref), v23 (copy), v9 (ref) ]]
				v22:PivotTo(CFrame.lookAt(v23:Lerp(v9, p3_2 ^ 2), v9 + Vector3.new(-0, -0.1, -0)))
			end
			v4 = (p3 - Position).Magnitude / p1.Properties.Duration
			SebasUtil:HeartbeatLoopFor((p3 - v9).Magnitude / v4, v3, function() --[[ Line: 169 | Upvalues: SebasUtil (ref), v12 (copy) ]]
				SebasUtil:DisableAllParticles(v12)
			end)
			return
		end
		CurrentCamera.CameraType = Enum.CameraType.Custom
		v2:ShakeOnce(10, 10, 0, 1)
		SebasUtil:DisableAllParticles(v22)
		v12 = p1.Cleaner:Clone(v1.Impact)
		v12.Parent = VFX
		v12.Position = p3
		SebasUtil:EnableAllParticles(v12)
		v23 = v22:GetPivot().Position
		v3 = function(p1_2, p2_2, p3_2) --[[ lerp2 | Line: 160 | Upvalues: v22 (ref), v23 (copy), v9 (ref) ]]
			v22:PivotTo(CFrame.lookAt(v23:Lerp(v9, p3_2 ^ 2), v9 + Vector3.new(-0, -0.1, -0)))
		end
		v4 = (p3 - Position).Magnitude / p1.Properties.Duration
		SebasUtil:HeartbeatLoopFor((p3 - v9).Magnitude / v4, v3, function() --[[ Line: 169 | Upvalues: SebasUtil (ref), v12 (copy) ]]
			SebasUtil:DisableAllParticles(v12)
		end)
	end)
	task.wait(p1.Properties.Duration + 3)
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, true)
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, true)
	if v12 then
		v12:Destroy()
	end
	p1:Destroy()
end
function t.Destroy(p1) --[[ Destroy | Line: 186 | Upvalues: v2 (copy), CurrentCamera (copy) ]]
	if p1.Destroyed then
		return
	end
	v2:StopSustained()
	if not p1._camDisabled then
		CurrentCamera.CameraType = Enum.CameraType.Custom
	end
	p1.Destroyed = true
	p1.Cleaner:Destroy()
end
return t