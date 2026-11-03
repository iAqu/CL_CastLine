-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Debris = game:GetService("Debris")
game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local CameraShaker = require(ReplicatedStorage.Modules.CameraShaker)
local CurrentCamera = workspace.CurrentCamera
local SkeletonNarwhal = ReplicatedStorage.Assets.Cutscenes.SkeletonNarwhal
local t = {}
t.__index = t
local function TimeScale(p1, p2, p3, p4) --[[ TimeScale | Line: 24 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p1, TweenInfo.new(p2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
		TimeScale = 0
	})
	v1.Completed:Once(function() --[[ Line: 26 | Upvalues: p3 (copy), TweenService (ref), p1 (copy), p4 (copy) ]]
		task.wait(p3)
		TweenService:Create(p1, TweenInfo.new(p4, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
			TimeScale = 1
		}):Play()
	end)
	v1:Play()
end
local function Emit(p1) --[[ Emit | Line: 33 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("ParticleEmitter") then
			local v3 = v2:GetAttribute("EmitCount") or 0
			local v4 = v2:GetAttribute("EmitDelay") or 0
			if v4 == 0 then
				v2:Emit(v3)
				continue
			end
			task.delay(v4, v2.Emit, v2, v3)
		end
	end
end
local function TrailPartUp(p1, p2, p3, p4) --[[ TrailPartUp | Line: 48 | Upvalues: SkeletonNarwhal (copy), CurrentCamera (copy), TweenService (copy), Debris (copy) ]]
	local v1 = tick()
	local v2 = Random.new()
	local v3 = SkeletonNarwhal.PillarTrailParts:GetChildren()
	while tick() - v1 <= p3 do
		local v4 = v3[v2:NextInteger(1, #v3)]:Clone()
		for v5, v6 in v4.ExtraRotation:GetChildren() do
			if v6:IsA("Attachment") then
				local Angles = CFrame.Angles
				local v8 = v2:NextInteger(-360, 360)
				v6.CFrame = v6.CFrame * Angles(0, math.rad(v8), 0) * CFrame.new(v2:NextNumber(30, 45), v2:NextNumber(-20, 20), v2:NextNumber(-8, 8))
			end
		end
		v4.CFrame = p1 * CFrame.Angles(0, math.rad((v2:NextInteger(-360, 360))), 0)
		v4.Parent = CurrentCamera
		local v10 = v2:NextNumber(500, 850) / 1000
		local v11 = TweenInfo.new(v10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		TweenService:Create(v4, v11, {
			CFrame = v4.CFrame * CFrame.new(0, v2:NextNumber(p4 * 0.7, p4), 0)
		}):Play()
		local t = {}
		t.CFrame = v4.ExtraRotation.CFrame * CFrame.Angles(0, math.rad((v2:NextInteger(120, 179))), 0)
		TweenService:Create(v4.ExtraRotation, v11, t):Play()
		Debris:AddItem(v4, v10 + 0.9)
		task.wait(0.2)
	end
end
local function PillarStart(p1, p2) --[[ PillarStart | Line: 74 | Upvalues: SkeletonNarwhal (copy), CurrentCamera (copy), TweenService (copy), Emit (copy), TrailPartUp (copy), Debris (copy) ]]
	local v1 = SkeletonNarwhal.Beampillar:Clone()
	v1.CFrame = p1
	v1.Parent = CurrentCamera
	local v2 = TweenService:Create(v1.Reciever, TweenInfo.new(0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
		CFrame = v1.Recievergoal1.CFrame
	})
	v2.Completed:Once(function() --[[ Line: 80 | Upvalues: TweenService (ref), v1 (copy) ]]
		TweenService:Create(v1.Reciever, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			CFrame = v1.Recievergoal2.CFrame
		}):Play()
	end)
	Emit(v1)
	v2:Play()
	TrailPartUp(p1, 20, p2, 300)
	task.delay(p2, function() --[[ Line: 87 | Upvalues: v1 (copy), TweenService (ref), Debris (ref) ]]
		for v12, v2 in v1:GetDescendants() do
			if v2:IsA("ParticleEmitter") then
				v2.Enabled = false
				continue
			end
			if v2:IsA("Beam") then
				TweenService:Create(v2, TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
					Width0 = 0,
					Width1 = 0
				}):Play()
			end
		end
		Debris:AddItem(v1, 4)
	end)
end
local function OrbStart(p1) --[[ OrbStart | Line: 99 | Upvalues: SkeletonNarwhal (copy), CurrentCamera (copy), TweenService (copy), Debris (copy), PillarStart (copy), Emit (copy) ]]
	local v1 = SkeletonNarwhal.Explosionorb:Clone()
	v1.CFrame = p1
	v1.Parent = CurrentCamera
	local v2 = SkeletonNarwhal.Bloom:Clone()
	v2.Parent = game:GetService("Lighting")
	local v3 = SkeletonNarwhal.DepthOfField:Clone()
	v3.Parent = game:GetService("Lighting")
	local v4 = TweenService:Create(v1, TweenInfo.new(0.6, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
		Size = Vector3.new(80, 80, 80),
		Color = Color3.fromRGB(120, 149, 255)
	})
	v4.Completed:Once(function() --[[ Line: 111 | Upvalues: TweenService (ref), v1 (copy), v3 (copy), v2 (copy), Debris (ref), PillarStart (ref), p1 (copy) ]]
		task.wait(0.5)
		TweenService:Create(v1, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
			Size = Vector3.new(0.01, 0.01, 0.01)
		}):Play()
		TweenService:Create(v3, TweenInfo.new(0.3, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
			FarIntensity = 0.05,
			InFocusRadius = 30
		}):Play()
		TweenService:Create(v2, TweenInfo.new(0.3, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
			Intensity = 1,
			Size = 24,
			Threshold = 2
		}):Play()
		task.delay(1, v1.Destroy, v1)
		Debris:AddItem(v2, 1)
		Debris:AddItem(v3, 1)
		PillarStart(p1, 3)
	end)
	v4:Play()
	task.wait(0.2)
	Emit(v1)
	TweenService:Create(v2, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Intensity = 3,
		Size = 50,
		Threshold = 0.9
	}):Play()
	TweenService:Create(v3, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		FarIntensity = 0.2,
		InFocusRadius = 0
	}):Play()
end
local function AbsorbTrail(p1, p2) --[[ AbsorbTrail | Line: 131 | Upvalues: SkeletonNarwhal (copy), TweenService (copy), Emit (copy) ]]
	local v1 = Random.new()
	local v2 = SkeletonNarwhal.Trailholder:GetChildren()
	for i = 1, p2 do
		local v3 = v2[v1:NextInteger(1, #v2)]:Clone()
		v3.CFrame = CFrame.new() * CFrame.Angles(0, v1:NextInteger(-360, 360), 0)
		v3.Parent = p1
		v3.TrailParent.CFrame = CFrame.new(v1:NextInteger(-100, 300), v1:NextInteger(-200, 200), 0)
		local v4 = TweenService:Create(v3.TrailParent, TweenInfo.new(v1:NextNumber(60, 250) / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			CFrame = CFrame.new()
		})
		local v6 = TweenInfo.new(v1:NextNumber(60, 250) / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local t = {}
		local v7 = CFrame.new()
		t.CFrame = v7 * CFrame.Angles(0, math.rad((v1:NextNumber(-30, 170))), 0)
		local v9 = TweenService:Create(v3, v6, t)
		v9.Completed:Once(function() --[[ Line: 143 | Upvalues: v3 (copy) ]]
			for v1, v2 in v3:GetDescendants() do
				if v2:IsA("Trail") then
					task.delay(0.12, function() --[[ Line: 146 | Upvalues: v2 (copy) ]]
						v2.Enabled = false
					end)
					continue
				end
				if v2:IsA("ParticleEmitter") then
					v2.Enabled = false
				end
			end
		end)
		v4:Play()
		v9:Play()
		Emit(v3)
	end
end
function t.new(p1, p2) --[[ new | Line: 160 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = Trove.new()
	v2.Destroyed = false
	return v2
end
function t.Play(p1, p2, p3, p4, p5) --[[ Play | Line: 169 | Upvalues: SkeletonNarwhal (copy), CurrentCamera (copy), TweenService (copy), Emit (copy), CameraShaker (copy), TimeScale (copy), OrbStart (copy), Soundbook (copy), AbsorbTrail (copy) ]]
	local v1 = p5 or false
	local v2 = nil
	local v3 = SkeletonNarwhal.MeteorBright:Clone()
	v3.CFrame = CFrame.new(p3) * CFrame.new(0, 800, 0) * CFrame.Angles(0, 0, math.pi)
	v3.Parent = CurrentCamera
	p1.Cleaner:Add(v3)
	if v1 then
		task.defer(function() --[[ Line: 180 | Upvalues: v2 (ref), CurrentCamera (ref), p3 (copy), TweenService (ref), v3 (copy) ]]
			v2 = CurrentCamera.CFrame
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local v1 = v2.Position - p3
			local v4 = CurrentCamera.CFrame.Position + v1.Unit * math.clamp(125 - v1.Magnitude, 0, 125)
			TweenService:Create(CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), {
				FieldOfView = 10,
				CFrame = CFrame.lookAt(v4, v3.Position)
			}):Play()
			task.wait(0.5)
			repeat
				CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, v3.Position)
				task.wait()
			until (v3.Position - p3).Magnitude <= 5
		end)
	end
	local v4 = TweenService:Create(v3, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		CFrame = CFrame.new(p3) * CFrame.Angles(0, 0, math.pi)
	})
	p1.Cleaner:Add(v4.Completed:Connect(function() --[[ Line: 204 | Upvalues: v3 (copy), Emit (ref), v1 (ref), TweenService (ref), CurrentCamera (ref), CameraShaker (ref), v2 (ref), TimeScale (ref), OrbStart (ref), p3 (copy) ]]
		v3.Transparency = 1
		v3.Outer.Transparency = 1
		task.delay(4, v3.Destroy, v3)
		Emit(v3.MeteorImpact)
		if v1 then
			task.defer(function() --[[ Line: 212 | Upvalues: TweenService (ref), CurrentCamera (ref), CameraShaker (ref), v2 (ref) ]]
				TweenService:Create(CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Cubic), {
					FieldOfView = 30
				}):Play()
				task.wait(1.2)
				TweenService:Create(CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
					FieldOfView = 65
				}):Play()
				local v1 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(p1) --[[ Line: 217 | Upvalues: CurrentCamera (ref) ]]
					CurrentCamera.CFrame = CurrentCamera.CFrame * p1
				end)
				v1:Start()
				v1:ShakeSustain(CameraShaker.Presets.Explosion)
				task.wait(0.8)
				v1:StopSustained(0.6)
				TweenService:Create(CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Sine), {
					CFrame = v2
				}):Play()
				task.delay(1.2, function() --[[ Line: 226 | Upvalues: CurrentCamera (ref) ]]
					CurrentCamera.CameraType = Enum.CameraType.Custom
				end)
			end)
		end
		for v12, v22 in v3.MeteorImpact.Timescaled:GetChildren() do
			if v22:IsA("ParticleEmitter") then
				TimeScale(v22, 0.6, 0.5, 0.25)
			end
		end
		OrbStart(CFrame.new(p3))
		for v32, v4 in v3:GetDescendants() do
			if v4:IsA("Beam") and not v4:IsA("ParticleEmitter") then
				v4.Enabled = false
			end
		end
	end))
	local v5 = Soundbook.Sounds["Skeleton Narwhal Cutscene"]:Play()
	if not v1 then
		v5.Volume = v5.Volume / 2
	end
	v4:Play()
	if not v1 then
		Emit(v3.StartVFX)
		AbsorbTrail(v3.TrailsStuff, 20)
		task.delay(5, p1.Cleaner.Destroy, p1.Cleaner)
		return
	end
	TweenService:Create(CurrentCamera, TweenInfo.new(3, Enum.EasingStyle.Quad), {
		FieldOfView = 65
	}):Play()
	Emit(v3.StartVFX)
	AbsorbTrail(v3.TrailsStuff, 20)
	task.delay(5, p1.Cleaner.Destroy, p1.Cleaner)
end
function t.Destroy(p1) --[[ Destroy | Line: 268 ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1.Cleaner:Destroy()
	end
end
return t