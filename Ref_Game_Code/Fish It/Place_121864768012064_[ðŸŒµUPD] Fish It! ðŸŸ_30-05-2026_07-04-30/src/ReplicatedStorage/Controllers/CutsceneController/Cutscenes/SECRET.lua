-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local v1 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Cutscenes")[script.Name]
local Trove = require(ReplicatedStorage.Packages.Trove)
local SebasUtil = require(ReplicatedStorage.Modules.SebasUtil)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local CameraShaker = require(ReplicatedStorage.Modules.CameraShaker)
local CameraShakeInstance = require(ReplicatedStorage.Modules.CameraShaker.CameraShakeInstance)
require(ReplicatedStorage.Controllers.VFXController)
local CurrentCamera = workspace.CurrentCamera
local VFX = workspace:WaitForChild("VFX")
local t = {}
t.__index = t
local v2 = Random.new(os.clock())
local function camShake(p1) --[[ camShake | Line: 32 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera
	v1.CFrame = v1.CFrame * p1
end
local v3 = CameraShaker.new(Enum.RenderPriority.Last.Value, camShake)
v3:Start()
local function createSpiralTrail(p1, p2, p3, p4) --[[ createSpiralTrail | Line: 39 | Upvalues: v1 (copy), v2 (copy), VFX (copy), RunService (copy) ]]
	local function decayExp(p1, p2, p3) --[[ decayExp | Line: 44 ]]
		return p3 + (p2 - p3) * math.exp(p1 * -2)
	end
	local v12 = p4:Clone(v1.Trail)
	local v22 = v2:NextNumber(-3.141592653589793, math.pi)
	local v3 = v22
	local v4 = math.cos(v3) * p2
	local v5 = v22
	v12.Position = p1 + Vector3.new(v4, 0, math.sin(v5) * p2)
	v12.Parent = VFX
	local v7 = 0
	local v8 = 0
	local v9 = nil
	v9 = RunService.Heartbeat:Connect(function(p12) --[[ Line: 58 | Upvalues: v8 (ref), p2 (copy), v12 (copy), p1 (copy), v22 (ref), p3 (copy), v7 (ref), v9 (ref) ]]
		local v3 = (p2 - 10) * math.exp(v8 * -2) + 10
		local v4 = v12
		v4.Position = p1 + Vector3.new(math.cos(v22) * v3, v8 ^ 2 * 8, math.sin(v22) * v3)
		v22 = v22 + p3 * p12
		v8 = v8 + p12
		v7 = v7 + p12 / 5
		if v7 > 1 then
			v9:Disconnect()
			task.delay(1, function() --[[ Line: 70 | Upvalues: v12 (ref) ]]
				v12:Destroy()
			end)
		end
	end)
end
function t.new(p1, p2) --[[ new | Line: 79 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = Trove.new()
	v2.Destroyed = false
	return v2
end
function t.Play(p1, p2, p3, p4, p5) --[[ Play | Line: 88 | Upvalues: v1 (copy), Soundbook (copy), VFX (copy), SebasUtil (copy), v3 (copy), CameraShaker (copy), TweenService (copy), CameraShakeInstance (copy), CurrentCamera (copy), createSpiralTrail (copy), v2 (copy) ]]
	local v12 = p1.Cleaner:Clone(v1.ColorCorrection)
	p1.Cleaner:Add(task.delay(0.2, function() --[[ Line: 91 | Upvalues: Soundbook (ref), p5 (copy) ]]
		local v1 = Soundbook.Sounds["Cutscene - SECRET"]:Play()
		if p5 then
			return
		end
		v1.Volume = v1.Volume / 2
	end))
	p1.Cleaner:Add(task.spawn(function() --[[ Line: 98 | Upvalues: p1 (copy), v1 (ref), VFX (ref), p3 (copy), SebasUtil (ref), p5 (copy), v3 (ref), CameraShaker (ref), v12 (copy), TweenService (ref), CameraShakeInstance (ref), CurrentCamera (ref), createSpiralTrail (ref), v2 (ref) ]]
		local v13 = p1.Cleaner:Clone(v1.Circle)
		v13.Parent = VFX
		v13.Position = p3 + Vector3.new(0, 1, 0)
		SebasUtil:EmitAll(v13)
		if p5 then
			v3:Shake(CameraShaker.Presets.Bump)
		end
		task.wait(1)
		if p1.Destroyed then
			return
		end
		local v22 = p1.Cleaner:Clone(v1.BeamLine)
		v22.Parent = VFX
		v22:PivotTo(CFrame.new(v13.Position))
		SebasUtil:AppearAllBeams(v22, 0.35)
		if p5 then
			v3:ShakeOnce(6, 10, 0, 1)
			v3:ShakeSustain(CameraShaker.Presets.Bump)
		end
		task.wait(2)
		if p1.Destroyed then
			return
		end
		if p5 then
			v3:StopSustained()
			v12.Parent = game.Lighting
			TweenService:Create(v12, TweenInfo.new(0.4), {
				Brightness = v12.Brightness,
				TintColor = v12.TintColor,
				Contrast = v12.Contrast
			}):Play()
			v12.Brightness = 0
			v12.TintColor = Color3.fromRGB(255, 255, 255)
			v12.Contrast = 0
			local v32 = CameraShakeInstance.new(8, 14, 0, 2)
			v32.PositionInfluence = Vector3.new(0, 0.15, 0)
			v32.RotationInfluence = Vector3.new(1.25, 0, 4)
			v3:ShakeSustain(v32)
		end
		SebasUtil:DisableAllParticles(v22)
		SebasUtil:HeartbeatLoopFor(0.4, function(p1, p2, p3) --[[ lerpBeam | Line: 156 | Upvalues: v22 (copy), SebasUtil (ref) ]]
			v22:ScaleTo(SebasUtil:lerp(1, 3, p3))
		end, function() --[[ Line: 160 ]] end)
		local v4 = p1.Cleaner:Clone(v1.BeamParticles)
		v4.Parent = VFX
		v4.Position = v22.BeamLine.Position
		if p5 then
			TweenService:Create(CurrentCamera, TweenInfo.new(3), {
				FieldOfView = 120
			}):Play()
		end
		local sum = 3
		while sum >= 0 do
			createSpiralTrail(p3, v2:NextNumber(45, 50), v2:NextNumber(15, 30), p1.Cleaner)
			sum = sum - task.wait(0.35)
		end
		if p5 then
			v3:StopSustained()
		end
		SebasUtil:DisableAllParticles(v22)
		SebasUtil:DisableAllParticles(v4)
		SebasUtil:DisableAllParticles(v13)
		SebasUtil:DisableAllBeams(v22, 0.5)
		SebasUtil:DisableAllBeams(v13, 0.5)
		SebasUtil:fadeAllLights(v13, 1)
		if p1.Destroyed then
			return
		end
		if not p5 then
			task.wait(1.5)
			p1.Completed = true
			p1:Destroy()
			return
		end
		TweenService:Create(v12, TweenInfo.new(1), {
			Brightness = 0,
			Contrast = 0,
			TintColor = Color3.fromRGB(255, 255, 255)
		}):Play()
		local v5 = p1.Cleaner:Clone(v1.WhiteScreen)
		v5.Parent = game.Lighting
		TweenService:Create(v5, TweenInfo.new(1), {
			Brightness = v5.Brightness
		}):Play()
		v5.Brightness = 0
		task.wait(0.3)
		if p1.Destroyed then
			return
		end
		local v6 = TweenService:Create(v5, TweenInfo.new(0.3), {
			Brightness = 0
		})
		local v7 = TweenService:Create(CurrentCamera, TweenInfo.new(0.3), {
			FieldOfView = 65
		})
		v6:Play()
		v7:Play()
		task.wait(1.5)
		p1.Completed = true
		p1:Destroy()
	end))
end
function t.Destroy(p1) --[[ Destroy | Line: 267 | Upvalues: v3 (copy), CurrentCamera (copy) ]]
	if p1.Destroyed then
		return
	end
	v3:StopSustained()
	p1.Destroyed = true
	p1.Cleaner:Destroy()
	if p1.Completed then
		return
	end
	CurrentCamera.FieldOfView = 65
end
return t