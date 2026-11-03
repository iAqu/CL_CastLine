-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
game:GetService("Players")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local v1 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Cutscenes"):WaitForChild(script.Name)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local SebasUtil = require(Modules.SebasUtil)
local CameraShaker = require(Modules.CameraShaker)
require(Modules.CameraShaker.CameraShakeInstance)
local SphereShapedTrails = require(Modules.SphereShapedTrails)
local LightningBolt = require(Modules.LightningBolt)
local TrailParticles = require(Modules.TrailParticles)
require(Modules.TrailParticles.Presets)
local CurrentCamera = workspace.CurrentCamera
local VFX = workspace:WaitForChild("VFX")
local t = {}
t.__index = t
Random.new()
local function shakeCam(p1) --[[ shakeCam | Line: 32 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera
	v1.CFrame = v1.CFrame * p1
end
local v2 = CameraShaker.new(Enum.RenderPriority.Last.Value, shakeCam)
local v3 = TrailParticles.new(10, v1:WaitForChild("ExplosionTrailWhite"), Vector3.new(0, 0, 0), Vector3.new(1, 1, 1))
function t.new(p1, p2) --[[ new | Line: 42 | Upvalues: t (copy), Trove (copy), v2 (copy), v3 (copy) ]]
	local v22 = setmetatable({}, t)
	v22.CutscenePlayer = p1
	v22.CutsceneCharacter = p2
	v22.Cleaner = Trove.new()
	v22.Properties = {
		SpawnHeight = 150,
		LightningDuration = 1.5
	}
	v22.Collection = {
		Textures = {},
		Parts = {},
		Effects = {}
	}
	v22.Destroyed = false
	v2:Start()
	v3:Start()
	return v22
end
function t.Play(p1, p2, p3, p4, p5) --[[ Play | Line: 68 | Upvalues: Soundbook (copy), v1 (copy), VFX (copy), SebasUtil (copy), v2 (copy), CameraShaker (copy), TweenService (copy), CurrentCamera (copy), SphereShapedTrails (copy), LightningBolt (copy), v3 (copy) ]]
	p1.performCameraCinematics = p5
	local Cleaner = p1.Cleaner
	Cleaner:Add(task.delay(0.2, function() --[[ Line: 73 | Upvalues: Soundbook (ref), p5 (copy) ]]
		local v1 = Soundbook.Sounds["Cutscene - FORGOTTEN"]:Play()
		if p5 then
			return
		end
		v1.Volume = v1.Volume / 2
	end))
	Cleaner:Add(task.spawn(function() --[[ Line: 80 | Upvalues: v1 (ref), p1 (copy), VFX (ref), p3 (copy), SebasUtil (ref), p5 (copy), v2 (ref), CameraShaker (ref), TweenService (ref), CurrentCamera (ref), SphereShapedTrails (ref), LightningBolt (ref), v3 (ref) ]]
		local v12 = v1.Flare:Clone()
		p1.Cleaner:Add(v12)
		v12.Parent = VFX
		v12.Position = p3
		SebasUtil:EmitAll(v12)
		local v22 = v1.Wave1:Clone()
		p1.Cleaner:Add(v22)
		v22.Parent = VFX
		v22.Position = p3 + Vector3.new(0, 1, 0)
		SebasUtil:EmitAll(v22)
		local v32 = v1.Water:Clone()
		p1.Cleaner:Add(v32)
		v32.Parent = VFX
		v32.Position = p3 + Vector3.new(0, 0.15, 0)
		if p5 then
			v2:Shake(CameraShaker.Presets.Bump)
		end
		local v5 = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		local t = {}
		local v6 = p3
		local SpawnHeight = p1.Properties.SpawnHeight
		t.Position = v6 + Vector3.new(0, SpawnHeight, 0)
		TweenService:Create(v12, v5, t):Play()
		if p5 then
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local lookAt = CFrame.lookAt
			local Position = CurrentCamera.CFrame.Position
			local SpawnHeight_2 = p1.Properties.SpawnHeight
			local v8 = lookAt(Position, p3 + Vector3.new(0, SpawnHeight_2, 0)) * CFrame.new(Vector3.new(0, 0, 4))
			local v9 = TweenService:Create(CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				FieldOfView = 80,
				CFrame = v8
			})
			v9:Play()
			CurrentCamera.Focus = v8
			p1.Cleaner:Add(v9.Completed:Once(function() --[[ Line: 143 | Upvalues: p1 (ref), CurrentCamera (ref) ]]
				task.wait(1.72)
				if not p1.Destroyed then
					CurrentCamera.CameraType = Enum.CameraType.Custom
					CurrentCamera.FieldOfView = 65
				end
			end))
		end
		task.wait(0.5)
		if p1.Destroyed then
			return
		end
		if p5 then
			v2:Shake(CameraShaker.Presets.Bump)
		end
		task.wait(0.5)
		if p1.Destroyed then
			return
		end
		SebasUtil:EnableAllParticles(v12.Star2)
		print("Enabled particles")
		if p5 then
			v2:ShakeOnce(10, 10, 0, 1)
		end
		local v10 = v1.Wave:Clone()
		p1.Cleaner:Add(v10)
		v10.Parent = VFX
		local v11 = p3
		local SpawnHeight_2 = p1.Properties.SpawnHeight
		v10.Position = v11 + Vector3.new(0, SpawnHeight_2, 0)
		SebasUtil:EmitAll(v10)
		local v122 = v1.CloudParticles:Clone()
		p1.Cleaner:Add(v122)
		v122.Parent = VFX
		local v13 = p3
		local SpawnHeight_3 = p1.Properties.SpawnHeight
		v122.Position = v13 + Vector3.new(0, SpawnHeight_3, 0)
		SebasUtil:AppearAllBeams(v122, 0.35)
		local v14 = SphereShapedTrails.new(CFrame.new(p3) * CFrame.Angles(0.2617993877991494, 0, 0), p1.Properties.SpawnHeight * 1.5, 15, v1.TrailPartWhite, {
			rotationSpeed = 1,
			shapePartial = 0.5,
			noise = true,
			noiseFrequency = 0.5,
			noiseAmplitude = 50,
			rotationSpeedVariation = NumberRange.new(0.5, 1.5),
			radiusVariation = NumberRange.new(0.3, 1.2)
		})
		p1.Cleaner:Add(v14)
		v14:Start()
		local v15 = SphereShapedTrails.new(CFrame.new(p3) * CFrame.Angles(0.17453292519943295, 0, 0), p1.Properties.SpawnHeight * 1.5, 8, v1.TrailPartBlack, {
			rotationSpeed = 2,
			shapePartial = 0.5,
			noise = true,
			noiseFrequency = 2,
			noiseAmplitude = 50,
			rotationSpeedVariation = NumberRange.new(0.5, 1.5),
			radiusVariation = NumberRange.new(0.3, 1.2)
		})
		p1.Cleaner:Add(v15)
		v15:Start()
		task.wait(1.5)
		if p1.Destroyed then
			return
		end
		local Attachment = Instance.new("Attachment")
		p1.Cleaner:Add(Attachment)
		Attachment.Parent = workspace.Terrain
		local Attachment_2 = Instance.new("Attachment")
		p1.Cleaner:Add(Attachment_2)
		Attachment_2.Parent = workspace.Terrain
		local v16 = p3
		local SpawnHeight_4 = p1.Properties.SpawnHeight
		Attachment.WorldPosition = v16 + Vector3.new(0, SpawnHeight_4, 0)
		Attachment_2.WorldPosition = p3 + Vector3.new(0, 0.15, 0)
		for i = 1, 2 do
			local v17 = LightningBolt.new(Attachment, Attachment_2, 8)
			v17.PulseSpeed = 10
			v17.FadeLength = 0.4
			v17.Thickness = 5
			v17.MinRadius = 5
			v17.MaxRadius = 30
			v17.AnimationSpeed = 15
			v17.Frequency = 0.5
			v17.PulseLength = 2.5 * v17.PulseSpeed
			v17.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.85, Color3.fromRGB(22, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) })
		end
		if p5 then
			v2:ShakeOnce(10, 10, 0, 1.5)
		end
		local function lerpRotSpeeds(p1) --[[ lerpRotSpeeds | Line: 265 | Upvalues: v14 (copy), SebasUtil (ref), v15 (copy) ]]
			for i, v in ipairs(v14:GetSegments()) do
				local RotationSpeed = v.RotationSpeed
				SebasUtil:HeartbeatLoopFor(p1, function(p1, p2, p3) --[[ lerpRotSpeed | Line: 269 | Upvalues: v (copy), SebasUtil (ref), RotationSpeed (copy) ]]
					v.RotationSpeed = SebasUtil:lerp(RotationSpeed, RotationSpeed * 5, p3 ^ 2)
				end, function() --[[ Line: 273 ]] end)
			end
			for i, v in ipairs(v15:GetSegments()) do
				local RotationSpeed = v.RotationSpeed
				SebasUtil:HeartbeatLoopFor(p1, function(p1, p2, p3) --[[ lerpRotSpeed | Line: 280 | Upvalues: v (copy), SebasUtil (ref), RotationSpeed (copy) ]]
					v.RotationSpeed = SebasUtil:lerp(RotationSpeed, RotationSpeed * 5, p3 ^ 2)
				end, function() --[[ Line: 284 ]] end)
			end
		end
		local v18 = p1.Properties.LightningDuration * 2 / 3
		lerpRotSpeeds(v18)
		local noiseFrequency = v14.noiseFrequency
		local noiseFrequency_2 = v15.noiseFrequency
		SebasUtil:HeartbeatLoopFor(v18, function(p1, p2, p3) --[[ lerpNoiseFrequency | Line: 295 | Upvalues: v14 (copy), SebasUtil (ref), noiseFrequency (copy), v15 (copy), noiseFrequency_2 (copy) ]]
			v14.noiseFrequency = SebasUtil:lerp(noiseFrequency, noiseFrequency * 2, p3 ^ 2)
			v15.noiseFrequency = SebasUtil:lerp(noiseFrequency_2, noiseFrequency_2 * 2, p3 ^ 2)
		end, function() --[[ Line: 300 | Upvalues: v14 (copy), noiseFrequency (copy), v15 (copy), noiseFrequency_2 (copy) ]]
			v14.noiseFrequency = noiseFrequency * 2
			v15.noiseFrequency = noiseFrequency_2 * 2
		end)
		local v19 = v1.Beam:Clone()
		p1.Cleaner:Add(v19)
		v19.Parent = VFX
		v19.Position = p3 + Vector3.new(0, 0.15, 0)
		local SpawnHeight_5 = p1.Properties.SpawnHeight
		v19.Att0.Position = Vector3.new(0, SpawnHeight_5, 0)
		local SpawnHeight_6 = p1.Properties.SpawnHeight
		v19.Att1.Position = Vector3.new(0, SpawnHeight_6, 0)
		local v20 = TweenService:Create(v19.Att1, TweenInfo.new(0.1), {
			Position = Vector3.new(0, 0, 0)
		})
		v20:Play()
		v20.Completed:Connect(function() --[[ Line: 324 | Upvalues: SebasUtil (ref), v19 (copy) ]]
			SebasUtil:EmitAll(v19.Attachment)
			SebasUtil:EnableAllParticles(v19.Attachment)
		end)
		task.wait(p1.Properties.LightningDuration)
		if p1.Destroyed then
			return
		end
		for i, v in ipairs(v14:GetSegments()) do
			local BaseRadius = v.BaseRadius
			local v21 = v.CFrame
			SebasUtil:HeartbeatLoopFor(0.5, function(p1, p2, p32) --[[ lerpRadius | Line: 343 | Upvalues: v (copy), SebasUtil (ref), BaseRadius (copy), v21 (copy), p3 (ref) ]]
				v.BaseRadius = SebasUtil:lerp(BaseRadius, 0, p32 ^ 3)
				v.CFrame = v21:lerp(CFrame.new(p3), p32 ^ 2)
			end, function() --[[ Line: 348 ]] end)
		end
		for i, v in ipairs(v15:GetSegments()) do
			local BaseRadius = v.BaseRadius
			SebasUtil:HeartbeatLoopFor(0.5, function(p1, p2, p3) --[[ lerpRadius | Line: 355 | Upvalues: v (copy), SebasUtil (ref), BaseRadius (copy) ]]
				v.BaseRadius = SebasUtil:lerp(BaseRadius, 0, p3 ^ 2)
			end, function() --[[ Line: 359 ]] end)
		end
		lerpRotSpeeds(0.5)
		task.wait(0.5)
		if p1.Destroyed then
			return
		end
		if p5 then
			v2:ShakeOnce(10, 10, 0, 0.5)
		end
		p1.Cleaner:Add(task.spawn(function() --[[ Line: 374 | Upvalues: v15 (copy), v14 (copy) ]]
			v15:End(false)
			v14:End(false)
		end))
		task.wait(0.5)
		if p1.Destroyed then
			return
		end
		local v222, v23
		if not p5 then
			SebasUtil:fadeAllLights(v19, 0.5)
			SebasUtil:DisableAllParticles(v19)
			SebasUtil:DisableAllBeams(v19, 0.5)
			SebasUtil:DisableAllBeams(v122, 0.5)
			SebasUtil:DisableAllParticles(v12)
			SebasUtil:DisableAllParticles(v32)
			v222 = v1.FinalExplosion:Clone()
			p1.Cleaner:Add(v222)
			v222.Parent = VFX
			v222.Position = p3
			SebasUtil:EmitAll(v222)
			v3.DirectionRelativeToOrigin = true
			v3.Radius = 1
			v3.Origin = p3
			v23 = {
				Velocity = Vector3.new(1, 1, 1600),
				MinSpeedMult = 0.3,
				MaxSpeedMult = 1.3,
				FadeIn = 0.8,
				FadeOut = 1,
				Resolution = 0.25,
				Contrast = 200,
				TrailLife = 1,
				NoiseStrength = function(p1_2) --[[ NoiseStrength | Line: 418 ]]
					return p1_2
				end,
				VelocityDrag = function(p1_2) --[[ VelocityDrag | Line: 421 ]]
					return p1_2 - Vector3.new(0, 0, 60)
				end
			}
			v3.Part = v1.ExplosionTrailWhite
			v3:Simulate(v23)
			v3.Part = v1.ExplosionTrailBlack
			v3:Simulate(v23)
			task.wait(1)
			p1.Completed = true
			p1:Destroy()
			return
		end
		v2:ShakeOnce(10, 10, 0, 1)
		SebasUtil:fadeAllLights(v19, 0.5)
		SebasUtil:DisableAllParticles(v19)
		SebasUtil:DisableAllBeams(v19, 0.5)
		SebasUtil:DisableAllBeams(v122, 0.5)
		SebasUtil:DisableAllParticles(v12)
		SebasUtil:DisableAllParticles(v32)
		v222 = v1.FinalExplosion:Clone()
		p1.Cleaner:Add(v222)
		v222.Parent = VFX
		v222.Position = p3
		SebasUtil:EmitAll(v222)
		v3.DirectionRelativeToOrigin = true
		v3.Radius = 1
		v3.Origin = p3
		v23 = {
			Velocity = Vector3.new(1, 1, 1600),
			MinSpeedMult = 0.3,
			MaxSpeedMult = 1.3,
			FadeIn = 0.8,
			FadeOut = 1,
			Resolution = 0.25,
			Contrast = 200,
			TrailLife = 1,
			NoiseStrength = function(p1_2) --[[ NoiseStrength | Line: 418 ]]
				return p1_2
			end,
			VelocityDrag = function(p1_2) --[[ VelocityDrag | Line: 421 ]]
				return p1_2 - Vector3.new(0, 0, 60)
			end
		}
		v3.Part = v1.ExplosionTrailWhite
		v3:Simulate(v23)
		v3.Part = v1.ExplosionTrailBlack
		v3:Simulate(v23)
		task.wait(1)
		p1.Completed = true
		p1:Destroy()
	end))
end
function t.Destroy(p1) --[[ Destroy | Line: 454 | Upvalues: v2 (copy), v3 (copy), CurrentCamera (copy) ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1.Cleaner:Clean()
		p1.Cleaner:Destroy()
		v2:StopSustained()
		v3:Stop()
		CurrentCamera.CameraType = Enum.CameraType.Custom
	end
end
return t