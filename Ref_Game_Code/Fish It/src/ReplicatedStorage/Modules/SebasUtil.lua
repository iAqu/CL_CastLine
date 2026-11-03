-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VFXUtil = ReplicatedStorage.Assets:WaitForChild("VFXUtil")
local VFX = workspace:WaitForChild("VFX")
local t = {}
local CurrentCamera = workspace.CurrentCamera
local v1 = Random.new()
function t.CubicBezier(p1, p2, p3, p4, p5, p6) --[[ CubicBezier | Line: 17 ]]
	return (1 - p6) ^ 3 * p2 + p6 * 3 * (1 - p6) ^ 2 * p3 + p6 ^ 2 * 3 * (1 - p6) * p4 + p6 ^ 3 * p5
end
function t.quadBezier(p1, p2, p3, p4, p5) --[[ quadBezier | Line: 21 ]]
	return (1 - p5) ^ 2 * p2 + 2 * (1 - p5) * p5 * p3 + p5 ^ 2 * p4
end
function t.QuadraticEaseOut(p1, p2) --[[ QuadraticEaseOut | Line: 25 ]]
	return math.lerp(p2 * p2, 1 - (1 - p2) * (1 - p2), p2)
end
function t.lerp(p1, p2, p3, p4) --[[ lerp | Line: 32 ]]
	return p2 + (p3 - p2) * p4
end
function t.invLerp(p1, p2, p3, p4) --[[ invLerp | Line: 36 ]]
	return (p4 - p2) / (p3 - p2)
end
function t.remap(p1, p2, p3, p4, p5, p6) --[[ remap | Line: 40 | Upvalues: t (copy) ]]
	return t:lerp(p4, p5, (math.clamp(t:invLerp(p3, p3, p6), 0, 1)))
end
function t.gaussianRandom(p1, p2, p3) --[[ gaussianRandom | Line: 45 ]]
	local v1, v2
	repeat
		v1 = 2 * math.random() - 1
		local v3 = 2 * math.random() - 1
		v2 = math.pow(v1, 2) + math.pow(v3, 2)
	until v2 ~= 0 and v2 < 1
	return p2 + p3 * v1 * math.sqrt(math.log(v2) * -2 / v2)
end
function t.randomPointInSphere(p1, p2) --[[ randomPointInSphere | Line: 57 | Upvalues: t (copy) ]]
	local v1 = 6.283185307179586 * math.random()
	local v3 = math.acos(2 * math.random() - 1)
	local v5 = math.min(t:gaussianRandom(0, p2 / 3), p2)
	return v5 * math.sin(v3) * math.cos(v1), v5 * math.sin(v3) * math.sin(v1), v5 * math.cos(v3)
end
function t.randomPointInAnnulus(p1, p2, p3) --[[ randomPointInAnnulus | Line: 70 ]]
	local v1 = 6.283185307179586 * math.random()
	local v3 = math.acos(2 * math.random() - 1)
	local v5 = p2 + (p3 - p2) * math.sqrt((math.random()))
	return v5 * math.sin(v3) * math.cos(v1), v5 * math.sin(v3) * math.sin(v1), v5 * math.cos(v3)
end
function t.flat(p1, p2) --[[ flat | Line: 83 ]]
	local t = {}
	local function v1(p1) --[[ flatten | Line: 86 | Upvalues: v1 (copy), t (copy) ]]
		for i, v in ipairs(p1) do
			if typeof(v) == "table" then
				v1(v)
				continue
			end
			table.insert(t, v)
		end
	end
	v1(p2)
	return t
end
function t.EmitAll(p1, p2) --[[ EmitAll | Line: 100 ]]
	for k, v in pairs(p2:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local v1 = v:GetAttribute("EmitCount")
			local v2 = v:GetAttribute("EmitDelay") or 0
			local v3 = v:GetAttribute("EmitDuration")
			local function eparticle() --[[ eparticle | Line: 107 | Upvalues: v3 (copy), v (copy) ]]
				if not v3 or v3 == 0 then
					return
				end
				v.Enabled = true
				task.delay(v3, function() --[[ Line: 110 | Upvalues: v (ref) ]]
					v.Enabled = false
				end)
			end
			if v1 then
				if v2 == 0 then
					v:Emit(v1)
					if v3 and v3 ~= 0 then
						v.Enabled = true
						task.delay(v3, function() --[[ Line: 110 | Upvalues: v (copy) ]]
							v.Enabled = false
						end)
					end
					continue
				end
				task.delay(v2, function() --[[ Line: 121 | Upvalues: v (copy), v1 (copy), v3 (copy) ]]
					v:Emit(v1)
					if not v3 or v3 == 0 then
						return
					end
					v.Enabled = true
					task.delay(v3, function() --[[ Line: 110 | Upvalues: v (ref) ]]
						v.Enabled = false
					end)
				end)
			end
		end
	end
end
function t.EmitOnce(p1, p2, p3, p4) --[[ EmitOnce | Line: 131 | Upvalues: Debris (copy), VFX (copy), t (copy) ]]
	local v1 = p2:Clone()
	Debris:AddItem(v1, p4 or 1)
	v1.Position = p3
	v1.Parent = VFX
	t:EmitAll(v1)
end
function t.ToggleAllBeams(p1, p2, p3) --[[ ToggleAllBeams | Line: 139 ]]
	for k, v in pairs(p2:GetDescendants()) do
		if v:IsA("Beam") then
			v.Enabled = p3
		end
	end
end
function t.ToggleAllTrails(p1, p2, p3) --[[ ToggleAllTrails | Line: 147 ]]
	for k, v in pairs(p2:GetDescendants()) do
		if v:IsA("Trail") then
			v.Enabled = p3
		end
	end
end
function t.ToggleAllParticles(p1, p2, p3) --[[ ToggleAllParticles | Line: 155 ]]
	for k, v in pairs(p2:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = p3
		end
	end
end
function t.EnableAllParticles(p1, p2) --[[ EnableAllParticles | Line: 163 | Upvalues: t (copy) ]]
	t:ToggleAllParticles(p2, true)
end
function t.DisableAllParticles(p1, p2) --[[ DisableAllParticles | Line: 167 | Upvalues: t (copy) ]]
	t:ToggleAllParticles(p2, false)
end
function t.EnableAllTrails(p1, p2) --[[ EnableAllTrails | Line: 171 | Upvalues: t (copy) ]]
	t:ToggleAllTrails(p2, true)
end
function t.DisableAllTrails(p1, p2) --[[ DisableAllTrails | Line: 175 | Upvalues: t (copy) ]]
	t:ToggleAllTrails(p2, false)
end
function t.PlaySound(p1, p2, p3, p4, p5) --[[ PlaySound | Line: 179 | Upvalues: TweenService (copy), Debris (copy) ]]
	local Sound = Instance.new("Sound")
	Sound.SoundId = p2
	Sound.Volume = p3
	Sound.Parent = p4
	Sound:Play()
	task.delay(p5 or 1, function() --[[ Line: 190 | Upvalues: Sound (copy), TweenService (ref), Debris (ref) ]]
		if Sound == nil then
			return
		end
		local v1 = TweenService:Create(Sound, TweenInfo.new(0.2), {
			Volume = 0
		})
		v1:Play()
		v1.Completed:Connect(function() --[[ Line: 194 | Upvalues: Debris (ref), Sound (ref) ]]
			Debris:AddItem(Sound, 0)
		end)
	end)
	return Sound
end
function t.SetupBeam(p1, p2, p3, p4) --[[ SetupBeam | Line: 203 ]]
	p2.Attachment0 = p3
	p2.Attachment1 = p4
end
function t.AppearBeam(p1, p2, p3) --[[ AppearBeam | Line: 208 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p2, TweenInfo.new(p3 or 0.5), {
		Width0 = p2.Width0,
		Width1 = p2.Width1
	})
	v1:Play()
	p2.Width0 = 0
	p2.Width1 = 0
	p2.Enabled = true
	return v1
end
function t.AppearAllBeams(p1, p2, p3) --[[ AppearAllBeams | Line: 222 | Upvalues: t (copy) ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("Beam") then
			t:AppearBeam(v, p3)
		end
	end
end
function t.DisableBeam(p1, p2, p3) --[[ DisableBeam | Line: 230 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p2, TweenInfo.new(p3 or 0.4), {
		Width0 = 0,
		Width1 = 0
	})
	v1:Play()
	return v1
end
function t.DisableAllBeams(p1, p2, p3) --[[ DisableAllBeams | Line: 243 | Upvalues: t (copy) ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("Beam") then
			t:DisableBeam(v, p3)
		end
	end
end
function t.AnchorAll(p1, p2) --[[ AnchorAll | Line: 251 ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
		end
	end
end
function t.UnAnchorAll(p1, p2) --[[ UnAnchorAll | Line: 259 ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
		end
	end
end
function t.DisableAllCollisions(p1, p2) --[[ DisableAllCollisions | Line: 267 ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
end
function t.FloorShockwave(p1, p2, p3, p4, p5, p6) --[[ FloorShockwave | Line: 275 | Upvalues: VFX (copy), VFXUtil (copy), v1 (copy), TweenService (copy), Debris (copy) ]]
	local v12 = RaycastParams.new()
	v12.FilterDescendantsInstances = { p2.Parent, VFX }
	v12.FilterType = Enum.RaycastFilterType.Exclude
	local v2 = workspace:Raycast(p2.Position, Vector3.new(0, p6 or -100, 0), p5 or v12)
	local v3
	if v2 then
		v3 = VFXUtil.Shockwave:Clone()
		v3.Parent = VFX or workspace
		v3.CanCollide = false
		local v5 = CFrame.new(v2.Position, v2.Position + v2.Normal)
		v3.CFrame = v5 * CFrame.Angles(-1.5707963267948966, math.rad((v1:NextNumber(-360, 360))), 0)
		local v7 = TweenService:Create(v3, TweenInfo.new(p4 or 0.5), {
			Transparency = 1,
			Size = p3,
			CFrame = v3.CFrame * CFrame.new(0, p3.Y / 2, 0)
		})
		v7:Play()
		v7.Completed:Connect(function() --[[ Line: 307 | Upvalues: Debris (ref), v3 (ref) ]]
			Debris:AddItem(v3, 0)
		end)
	else
		v3 = nil
	end
	return v3
end
function t.FloorImageCrack(p1, p2, p3, p4, p5, p6) --[[ FloorImageCrack | Line: 315 | Upvalues: VFX (copy), TweenService (copy), Debris (copy) ]]
	local Part = Instance.new("Part")
	Part.Parent = VFX or workspace
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CastShadow = false
	Part.CanQuery = false
	local v2 = CFrame.new(p2.Position, p2.Position + p2.Normal)
	Part.CFrame = v2 * CFrame.Angles(-1.5707963267948966, math.rad((math.random(-180, 180))), 0)
	Part.Size = Vector3.new(p3 or 10, 0.1, p3 or 10)
	Part.Anchored = true
	Part.Transparency = 1
	local Decal = Instance.new("Decal")
	Decal.Parent = Part
	Decal.Texture = p6 or "rbxassetid://8260787883"
	Decal.Face = "Top"
	Decal.Color3 = if p5 then p5 else p2.Instance.Color
	task.delay(p4 or 1, function() --[[ Line: 340 | Upvalues: TweenService (ref), Decal (copy), Debris (ref), Part (copy) ]]
		local v1 = TweenService:Create(Decal, TweenInfo.new(0.5), {
			Transparency = 1
		})
		v1:Play()
		v1.Completed:Connect(function() --[[ Line: 346 | Upvalues: Debris (ref), Part (ref) ]]
			Debris:AddItem(Part, 0.1)
		end)
	end)
	return Part
end
function t.TimeScaleParticle(p1, p2, p3) --[[ TimeScaleParticle | Line: 354 ]]
	p2.Drag = p2.Drag * p3
	p2.Speed = NumberRange.new(p2.Speed.Min * p3, p2.Speed.Max * p3)
	p2.Lifetime = NumberRange.new(p2.Lifetime.Min / p3, p2.Lifetime.Max / p3)
	p2.Rate = p2.Rate * p3
	p2.RotSpeed = NumberRange.new(p2.RotSpeed.Min * p3, p2.RotSpeed.Max * p3)
	p2.Acceleration = p2.Acceleration * p3 ^ 2
	if not p2:GetAttribute("EmitDelay") then
		return
	end
	p2:SetAttribute("EmitDelay", p2:GetAttribute("EmitDelay") / p3)
end
function t.ScaleParticle(p1, p2, p3) --[[ ScaleParticle | Line: 369 ]]
	local t = {}
	for k, v in pairs(p2.Size.Keypoints) do
		t[k] = NumberSequenceKeypoint.new(v.Time, v.Value * p3, v.Envelope * p3)
	end
	p2.Size = NumberSequence.new(t)
	p2.Drag = p2.Drag * p3
	p2.Speed = NumberRange.new(p2.Speed.Min * p3, p2.Speed.Max * p3)
	p2.Lifetime = NumberRange.new(p2.Lifetime.Min * p3, p2.Lifetime.Max * p3)
	p2.Rate = p2.Rate * p3
	p2.RotSpeed = NumberRange.new(p2.RotSpeed.Min * p3, p2.RotSpeed.Max * p3)
	p2.Acceleration = p2.Acceleration * p3
end
function t.ScaleBeams(p1, p2, p3, p4, p5) --[[ ScaleBeams | Line: 391 ]]
	for i, v in ipairs(p4) do
		v.TextureLength = v.TextureLength * p5
		v.ZOffset = v.ZOffset * p5
		v.CurveSize0 = v.CurveSize0 * p5
		v.CurveSize1 = v.CurveSize1 * p5
		v.Width0 = v.Width0 * p5
		v.Width1 = v.Width1 * p5
	end
	p2.Position = p2.Position * p5
	p3.Position = p3.Position * p5
end
function t.HeartbeatLoopFor(p1, p2, p3, p4) --[[ HeartbeatLoopFor | Line: 407 | Upvalues: RunService (copy) ]]
	local v1 = RunService:IsRunning() and time or os.clock
	local v2 = nil
	local v3 = v1()
	local v4 = false
	v2 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 419 | Upvalues: v1 (copy), v3 (copy), p2 (copy), p3 (copy), v4 (ref), p4 (copy), v2 (ref) ]]
		local v12 = v1() - v3
		if v12 < p2 then
			p3(v12, p1, v12 / p2)
			return
		end
		if v4 == true or p4 == nil then
			if v2 ~= nil then
				v2:Disconnect()
				v2 = nil
			end
		else
			v4 = true
			p4()
			if v2 == nil then
				return
			end
			v2:Disconnect()
			v2 = nil
		end
	end)
	return v2
end
function t.RenderStepLoopFor(p1, p2, p3, p4, p5) --[[ RenderStepLoopFor | Line: 445 | Upvalues: RunService (copy) ]]
	local v1 = RunService:IsRunning() and time or os.clock
	local v2 = v1()
	local v3 = false
	local v4 = "RenderStepLoop_" .. tostring(math.random(1000000000))
	RunService:BindToRenderStep(v4, p4, function(p1) --[[ Line: 457 | Upvalues: v1 (copy), v2 (copy), p2 (copy), p3 (copy), v3 (ref), p5 (copy), RunService (ref), v4 (copy) ]]
		local v12 = v1() - v2
		if v12 < p2 then
			p3(v12, p1, v12 / p2)
			return
		end
		if not v3 and p5 then
			v3 = true
			p5()
		end
		RunService:UnbindFromRenderStep(v4)
	end)
	return function() --[[ Line: 471 | Upvalues: RunService (ref), v4 (copy) ]]
		RunService:UnbindFromRenderStep(v4)
	end
end
function t.randPointInHorizDisc(p1, p2, p3) --[[ randPointInHorizDisc | Line: 476 | Upvalues: v1 (copy) ]]
	local v12 = v1:NextNumber(0, 6.283185307179586)
	local v2 = v1:NextNumber(p2, p3)
	local v3 = math.cos(v12) * v2
	return Vector3.new(v3, 0, math.sin(v12) * v2)
end
function t.InvertedSpringQuadraticParticles(p1, p2, p3, p4) --[[ InvertedSpringQuadraticParticles | Line: 484 | Upvalues: VFX (copy), v1 (copy), RunService (copy), Debris (copy) ]]
	local function quadraticCurve(p1, p2, p3, p4) --[[ quadraticCurve | Line: 506 ]]
		return p2 + p3 * p1 + p4 * p1 ^ 2 / 2
	end
	local function spring(p1, p2, p3) --[[ spring | Line: 510 ]]
		return math.exp(-p2 * p1) * math.sin(p3 * p1)
	end
	local t = {
		speed = 60,
		speedMinMultiplier = 0.5,
		speedMaxMultiplier = 1.5,
		gravity = -125,
		gravityMinMultiplier = 0.5,
		gravityMaXMultiplier = 1.5,
		lifetime = 0.8,
		lifetimeMinMultiplier = 1,
		lifetimeMaxMultiplier = 2,
		randomXZrotation = 40,
		randomYrotation = 180,
		amount = p4 or 40,
		parts = {}
	}
	for i = 1, p4 do
		local v12 = p2:Clone()
		v12.Parent = VFX or workspace
		v12.Position = p3
		local Angles = CFrame.Angles
		v12.CFrame = v12.CFrame * Angles(v1:NextNumber(-math.rad(t.randomXZrotation), math.rad(t.randomXZrotation) / 3), v1:NextNumber(-math.rad(t.randomYrotation), (math.rad(t.randomYrotation))), v1:NextNumber(-math.rad(t.randomXZrotation), math.rad(t.randomXZrotation) / 3))
		table.insert(t.parts, {
			instance = v12,
			cframe = v12.CFrame,
			speed = t.speed * v1:NextNumber(t.speedMinMultiplier, t.speedMaxMultiplier),
			gravity = t.gravity * v1:NextNumber(t.gravityMinMultiplier, t.gravityMaXMultiplier),
			lifetime = t.lifetime * v1:NextNumber(t.lifetimeMinMultiplier, t.lifetimeMaxMultiplier),
			springMultiplier = math.random(1, t.speedMaxMultiplier)
		})
	end
	local v12 = 0
	local v13 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 551 | Upvalues: v12 (ref), t (copy), Debris (ref) ]]
		v12 = v12 + p1
		for k, v in pairs(t.parts) do
			if v12 <= v.lifetime then
				local v4 = v12
				v.instance.Position = v.cframe.Position + v.cframe.RightVector * v.speed * v4 + Vector3.new(0, -v.gravity, 0) * v4 ^ 2 / 2
				local v5 = v12
				v.speed = v.speed + math.exp(-0.1 * v5) * math.sin(20 * v5) * v.springMultiplier
				continue
			end
			Debris:AddItem(v.instance, 0.5)
		end
	end)
	task.wait(t.lifetime * t.lifetimeMaxMultiplier + 0.1)
	v13:Disconnect()
	return t
end
function t.ResizeParticles(p1, p2, p3) --[[ ResizeParticles | Line: 581 ]]
	local Model = Instance.new("Model")
	local v1 = p2.Parent
	p2.Parent = Model
	Model:ScaleTo(p3)
	p2.Parent = v1
	Model:Destroy()
end
function t.fadeLight(p1, p2, p3) --[[ fadeLight | Line: 591 | Upvalues: TweenService (copy) ]]
	TweenService:Create(p2, TweenInfo.new(p3), {
		Brightness = 0
	}):Play()
end
function t.fadeAllLights(p1, p2, p3) --[[ fadeAllLights | Line: 598 | Upvalues: t (copy) ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("Light") then
			t:fadeLight(v, p3)
		end
	end
end
function t.FadeAllBeamsTransparency(p1, p2, p3) --[[ FadeAllBeamsTransparency | Line: 606 | Upvalues: TweenService (copy), RunService (copy) ]]
	for v1, v2 in p2:GetDescendants() do
		if v2:IsA("Beam") then
			v2.Transparency = NumberSequence.new(0.6)
			v2.Enabled = true
			local v3 = p3 or 1
			TweenService:Create(v2, TweenInfo.new(v3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				TextureSpeed = 0.1
			}):Play()
			local v4 = 0
			local v5 = nil
			v5 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 629 | Upvalues: v4 (ref), v3 (copy), v2 (copy), v5 (ref) ]]
				v4 = v4 + p1
				v2.Transparency = NumberSequence.new(math.min(v4 / v3, 1) * 1)
				if not (v3 <= v4) then
					return
				end
				v2.Transparency = NumberSequence.new(1)
				v5:Disconnect()
			end)
		end
	end
end
function t.OpenBeams(p1, p2, p3, p4) --[[ OpenBeams | Line: 643 | Upvalues: TweenService (copy) ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("Beam") then
			task.spawn(function() --[[ Line: 646 | Upvalues: TweenService (ref), v (copy), p3 (copy), p4 (copy) ]]
				TweenService:Create(v, TweenInfo.new(p3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					Width0 = v.Width0 * p4,
					Width1 = v.Width1 * p4
				}):Play()
				v.Width0 = 0
				v.Width1 = 0
				v.Enabled = true
			end)
		end
	end
end
function t.CloseBeams(p1, p2, p3) --[[ CloseBeams | Line: 665 | Upvalues: TweenService (copy) ]]
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("Beam") then
			task.spawn(function() --[[ Line: 668 | Upvalues: TweenService (ref), v (copy), p3 (copy) ]]
				TweenService:Create(v, TweenInfo.new(p3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					Width0 = 0,
					Width1 = 0
				}):Play()
			end)
		end
	end
end
function t.playSlash(p1, p2, p3, p4, p5) --[[ playSlash | Line: 683 | Upvalues: t (copy) ]]
	task.spawn(function() --[[ Line: 684 | Upvalues: p2 (copy), p4 (copy), t (ref), p3 (copy), p5 (copy) ]]
		local v1 = p2.CFrame
		local v3 = math.rad(p4 or 125)
		t:RenderStepLoopFor(p3, function(p1, p22, p3) --[[ Line: 688 | Upvalues: p2 (ref), v1 (copy), v3 (copy) ]]
			p2.CFrame = v1 * CFrame.Angles(0, v3 * p3, 0)
		end, Enum.RenderPriority.Last.Value, function() --[[ Line: 690 ]] end)
		t:OpenBeams(p2, 0.1, 1)
		task.wait(p5 or 0.1)
		t:CloseBeams(p2, 0.2)
	end)
end
function t.GetRandomNormalCone(p1, p2, p3) --[[ GetRandomNormalCone | Line: 700 | Upvalues: v1 (copy) ]]
	local Unit = p2:Cross(if p2:Cross(Vector3.new(0, 1, 0)).Magnitude > 0.01 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)).Unit
	local v4 = CFrame.fromAxisAngle(Unit, (math.rad((v1:NextNumber(0, p3))))):VectorToWorldSpace(p2)
	return CFrame.fromAxisAngle(p2, (math.rad((v1:NextNumber(0, 360))))):VectorToWorldSpace(v4)
end
function t.GetReflectedDirection(p1, p2, p3, p4) --[[ GetReflectedDirection | Line: 715 | Upvalues: t (copy) ]]
	return t:GetRandomNormalCone((p2 - 2 * p2:Dot(p3) * p3).Unit, p4)
end
function t.CastToMouseCFrame(p1, p2, p3, p4, p5) --[[ CastToMouseCFrame | Line: 726 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera:ScreenPointToRay(p5.X, p5.Y)
	local v2 = workspace:Raycast(v1.Origin, v1.Direction * (p2 or 1000), p3)
	if not v2 then
		print("Raycast failed")
		return p5.Hit
	end
	local v3 = CFrame.new(v2.Position, v2.Position + v2.Normal)
	if p4 then
		return v3 * CFrame.Angles(-1.5707963267948966, 0, 0)
	else
		return v3
	end
end
function t.lockAndLookAtMouse(p1, p2, p3, p4) --[[ lockAndLookAtMouse | Line: 748 | Upvalues: RunService (copy), Debris (copy) ]]
	local Attachment = Instance.new("Attachment", p2)
	local VectorForce = Instance.new("VectorForce")
	VectorForce.Force = Vector3.new(0, workspace.Gravity * p2.AssemblyMass, 0)
	VectorForce.ApplyAtCenterOfMass = true
	VectorForce.Attachment0 = Attachment
	VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	VectorForce.Parent = p2
	local AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	AlignOrientation.RigidityEnabled = true
	AlignOrientation.MaxTorque = (1 / 0)
	AlignOrientation.Responsiveness = 200
	AlignOrientation.Attachment0 = Attachment
	AlignOrientation.Parent = p2
	local AlignPosition = Instance.new("AlignPosition")
	AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	AlignPosition.MaxForce = (1 / 0)
	AlignPosition.Responsiveness = 200
	AlignPosition.RigidityEnabled = true
	AlignPosition.Attachment0 = Attachment
	AlignPosition.Position = p2.Position
	AlignPosition.Parent = p2
	local v2 = tick()
	local v3 = nil
	v3 = RunService.RenderStepped:Connect(function() --[[ Line: 777 | Upvalues: p2 (copy), v3 (ref), p3 (copy), AlignOrientation (copy), v2 (copy), p4 (copy) ]]
		if p2 and p2.Parent then
			AlignOrientation.CFrame = CFrame.lookAt(p2.Position, p2.Position + (p3.Hit.Position - p2.Position).Unit)
			if not (p4 <= tick() - v2) then
				return
			end
		end
		v3:Disconnect()
	end)
	task.delay(p4, function() --[[ Line: 792 | Upvalues: Debris (ref), Attachment (copy), VectorForce (copy), AlignOrientation (copy), AlignPosition (copy) ]]
		Debris:AddItem(Attachment, 0)
		Debris:AddItem(VectorForce, 0)
		Debris:AddItem(AlignOrientation, 0)
		Debris:AddItem(AlignPosition, 0)
	end)
end
function t.ColorFrame(p1, p2, p3, p4, p5, p6, p7) --[[ ColorFrame | Line: 800 | Upvalues: CurrentCamera (copy), Lighting (copy), TweenService (copy) ]]
	if not p5 then
		p5 = CurrentCamera.CFrame.Position
	end
	if (p6 or 99999) < (CurrentCamera.CFrame.Position - p5).Magnitude then
		return
	end
	local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
	ColorCorrectionEffect.TintColor = Color3.new(255/255, 255/255, 255/255)
	ColorCorrectionEffect.Parent = Lighting
	TweenService:Create(ColorCorrectionEffect, TweenInfo.new(p2), {
		TintColor = p4
	}):Play()
	if not p7 then
		task.delay(p2, function() --[[ Line: 826 | Upvalues: ColorCorrectionEffect (copy), TweenService (ref), p3 (copy) ]]
			if not ColorCorrectionEffect then
				return
			end
			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(p3), {
				TintColor = Color3.new(255/255, 255/255, 255/255)
			}):Play()
			task.wait(p3 + 0.05)
			if not ColorCorrectionEffect then
				return
			end
			ColorCorrectionEffect:Destroy()
		end)
	end
	return ColorCorrectionEffect
end
function t.ImpactFrame(p1, p2, p3, p4, p5, p6, p7, p8) --[[ ImpactFrame | Line: 844 | Upvalues: CurrentCamera (copy), Lighting (copy) ]]
	if not (p8 < (CurrentCamera.CFrame.Position - p7).Magnitude) then
		task.defer(function() --[[ Line: 858 | Upvalues: p4 (copy), p5 (copy), Lighting (ref), p6 (copy), p3 (copy), p2 (copy) ]]
			local list = {}
			for v1, v2 in p4 do
				local ImpactHighlight = Instance.new("Highlight")
				ImpactHighlight.Name = "ImpactHighlight"
				ImpactHighlight.FillColor = p5
				ImpactHighlight.OutlineTransparency = 1
				ImpactHighlight.Parent = v2
				table.insert(list, ImpactHighlight)
			end
			local Impact = Lighting:FindFirstChild("Impact")
			if not Impact then
				local Impact_2 = Instance.new("ColorCorrectionEffect")
				Impact_2.Brightness = 0
				Impact_2.Contrast = 0
				Impact_2.Saturation = 0
				Impact_2.Enabled = true
				Impact_2.TintColor = Color3.fromRGB(255, 255, 255)
				Impact_2.Name = "Impact"
				Impact_2.Parent = script
				Impact = Impact_2
			end
			local v3 = Impact:Clone()
			v3.Parent = game:GetService("Lighting")
			v3.TintColor = p6 or Color3.fromRGB(255, 255, 255)
			v3.Brightness = -1
			v3.Contrast = -100
			v3.Saturation = -1
			for i = 1, p3 do
				v3.Contrast = -100
				task.wait(p2)
				v3.Contrast = 100
				task.wait(p2)
			end
			v3.Brightness = 0
			v3.Contrast = 0
			v3.Saturation = 0
			v3:Destroy()
			for i, v in ipairs(list) do
				if v.Parent ~= nil then
					v:Destroy()
				end
			end
			table.clear(list)
		end)
	end
end
return t