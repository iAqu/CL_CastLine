-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
game:GetService("Lighting")
game:GetService("SoundService")
local RunService = game:GetService("RunService")
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local TimerService = require(ReplicatedStorage.Modules.ServicesLoader.TimerService)
local ShakerController = require(ReplicatedStorage.Modules.ControllerLoader.ShakerController)
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
local v2 = CFrame.new(749.268, 0, 302.95)
local t = {
	Active = false
}
function AnimateMeteor(p1, p2) --[[ AnimateMeteor | Line: 34 | Upvalues: RunService (copy), TweenService (copy), v2 (copy), v1 (copy), ShakerController (copy), ReplicatedStorage (copy), VFXService (copy) ]]
	local v12 = nil
	local function ScaleToPhase(p12, p2) --[[ ScaleToPhase | Line: 37 | Upvalues: v12 (ref), p1 (copy), RunService (ref), TweenService (ref), v2 (ref) ]]
		if v12 and v12.Connected then
			v12:Disconnect()
		end
		local v22 = p1:GetScale()
		local v4 = math.max(p2 or math.lerp(1, 3, p12 / 30), 0.1)
		local v5 = 0
		v12 = RunService.PreRender:Connect(function(p12) --[[ Line: 49 | Upvalues: p1 (ref), v12 (ref), v5 (ref), TweenService (ref), v22 (copy), v4 (copy), v2 (ref) ]]
			if p1.Root then
				v5 = v5 + p12
				local v23 = math.clamp(v5 / 1, 0, 1)
				p1:ScaleTo((math.lerp(v22, v4, (TweenService:GetValue(v23, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)))))
				p1.Root.CFrame = v2 * CFrame.new(0, p1.Root.Size.Y / 2, 0)
				if v23 == 1 then
					v12:Disconnect()
				end
			else
				v12:Disconnect()
			end
		end)
	end
	local v22 = script.Assets.Rumble:Clone()
	v22.Parent = p1.Root
	v22:Play()
	v22.Looped = true
	local function startShake() --[[ startShake | Line: 73 | Upvalues: v22 (copy), p2 (copy), v1 (ref), p1 (copy), TweenService (ref), ShakerController (ref), v2 (ref), ReplicatedStorage (ref), v12 (ref), RunService (ref), VFXService (ref) ]]
		v22:Stop()
		local v13 = p2 - workspace:GetServerTimeNow()
		local v23 = v1:Add(Instance.new("Highlight"))
		v23.DepthMode = Enum.HighlightDepthMode.Occluded
		v23.FillTransparency = 1
		v23.OutlineTransparency = 1
		v23.FillColor = Color3.fromRGB(255, 255, 255)
		v23.Parent = p1
		task.delay(p2 - 3 - workspace:GetServerTimeNow(), function() --[[ Line: 86 | Upvalues: TweenService (ref), v23 (copy) ]]
			TweenService:Create(v23, TweenInfo.new(3), {
				FillTransparency = 0
			}):Play()
		end)
		TweenService:Create(p1.Cube.SurfaceAppearance, TweenInfo.new(v13), {
			EmissiveStrength = 500,
			EmissiveTint = Color3.fromRGB(255, 255, 255)
		}):Play()
		local v4 = script.Assets.Earthquake:Clone()
		v4.Volume = 0
		v4.Parent = p1.Root
		v4:Play()
		TweenService:Create(v4, TweenInfo.new(2), {
			Volume = 1.25
		}):Play()
		local v5 = ShakerController.add(2, 4, v13 - 2, function(p12) --[[ Line: 99 | Upvalues: p1 (ref), v2 (ref) ]]
			p1.Root.CFrame = v2 * CFrame.new(0, p1.Root.Size.Y / 2, 0) * p12
		end)
		if v5 then
			v1:Add(v5)
		end
		local v6 = ReplicatedStorage.Objects.VFX.TrainerAppear:Clone()
		v6.CFrame = p1.Root.CFrame
		v6.Parent = workspace.Debris
		task.delay(v13 - 1.5, function() --[[ Line: 111 | Upvalues: TweenService (ref), v4 (copy), v6 (copy), v12 (ref), p1 (ref), RunService (ref), v2 (ref), VFXService (ref) ]]
			local v1 = TweenService:Create(v4, TweenInfo.new(0.5), {
				Volume = 0
			})
			for i, v in ipairs(v6:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					v:Emit(v:GetAttribute("EmitCount") or 1)
				end
			end
			game.Debris:AddItem(v6, 3)
			if v12 and v12.Connected then
				v12:Disconnect()
			end
			local v22 = p1:GetScale()
			local v3 = 0
			local v42 = 15
			v12 = RunService.PreRender:Connect(function(p12) --[[ Line: 49 | Upvalues: p1 (ref), v12 (ref), v3 (ref), TweenService (ref), v22 (copy), v42 (copy), v2 (ref) ]]
				if p1.Root then
					v3 = v3 + p12
					local v23 = math.clamp(v3 / 1, 0, 1)
					p1:ScaleTo((math.lerp(v22, v42, (TweenService:GetValue(v23, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)))))
					p1.Root.CFrame = v2 * CFrame.new(0, p1.Root.Size.Y / 2, 0)
					if v23 == 1 then
						v12:Disconnect()
					end
				else
					v12:Disconnect()
				end
			end)
			for i, v in ipairs(p1:GetChildren()) do
				if v:IsA("BasePart") then
					TweenService:Create(v, TweenInfo.new(1), {
						LocalTransparencyModifier = 1
					}):Play()
				end
			end
			v1:Play()
			VFXService.PlayVFX("Whitescreen", 3)
			script.Assets.Cracks:Play()
		end)
	end
	local v3 = p2 - 1800
	local v4 = nil
	local v5 = nil
	local v6 = nil
	local v7 = tick()
	v4 = RunService.PreRender:Connect(function() --[[ Line: 138 | Upvalues: v7 (ref), v3 (copy), v5 (ref), v12 (ref), p1 (copy), RunService (ref), TweenService (ref), v2 (ref), v6 (ref), p2 (copy), v4 (ref), startShake (copy) ]]
		local v1 = tick()
		if v1 - v7 > 0.1 then
			v7 = v1
			local v32 = math.floor((workspace:GetServerTimeNow() - v3) / 60)
			if v32 ~= v5 then
				v5 = v32
				if v12 and v12.Connected then
					v12:Disconnect()
				end
				local v52 = p1:GetScale()
				local v72 = math.max(math.lerp(1, 3, v32 / 30), 0.1)
				local v8 = 0
				v12 = RunService.PreRender:Connect(function(p12) --[[ Line: 49 | Upvalues: p1 (ref), v12 (ref), v8 (ref), TweenService (ref), v52 (copy), v72 (copy), v2 (ref) ]]
					if p1.Root then
						v8 = v8 + p12
						local v22 = math.clamp(v8 / 1, 0, 1)
						p1:ScaleTo((math.lerp(v52, v72, (TweenService:GetValue(v22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)))))
						p1.Root.CFrame = v2 * CFrame.new(0, p1.Root.Size.Y / 2, 0)
						if v22 == 1 then
							v12:Disconnect()
						end
					else
						v12:Disconnect()
					end
				end)
			end
		end
		if v5 and (v5 >= 29 and (not v6 and p2 - workspace:GetServerTimeNow() < 20)) then
			v4:Disconnect()
			v6 = true
			startShake()
		end
	end)
	return function() --[[ Line: 160 | Upvalues: v4 (ref) ]]
		v4:Disconnect()
	end
end
function StartTimer(p1, p2, p3) --[[ StartTimer | Line: 165 | Upvalues: TimerService (copy) ]]
	local TimerLabel = p3:WaitForChild("TimerLabel")
	local v1 = TimerService.AddTimer(TimerLabel, p2)
	return function() --[[ Line: 169 | Upvalues: v1 (copy) ]]
		v1:Destroy(true)
	end
end
function Load(p1) --[[ Load | Line: 174 | Upvalues: v1 (copy), ReplicatedStorage (copy), v2 (copy) ]]
	local v12 = v1:Clone(ReplicatedStorage.Objects.VFX.Meteor)
	v12:WaitForChild("Root").CFrame = v2 * CFrame.new(0, v12.Root.Size.Y / 2, 0)
	v12.Root.Anchored = true
	v12.Parent = workspace.Debris
	local v22 = v1:Clone(script.Assets.TimerGui)
	v22.Parent = v12.Root
	v1:Add(AnimateMeteor(v12, p1))
	v1:Add(StartTimer(v12, p1, v22))
end
function ReturnToDefault() --[[ ReturnToDefault | Line: 187 ]] end
function Start(p1) --[[ Start | Line: 191 | Upvalues: VFXService (copy), v2 (copy), v1 (copy) ]]
	VFXService.PlayVFX("LuckyBlockMeteor", workspace:GetServerTimeNow() + 4, v2)
	v1:Add(task.delay(4, function() --[[ Line: 194 | Upvalues: p1 (copy) ]]
		Load(p1)
	end))
end
function t.Initialize(p1, p2, p3) --[[ Initialize | Line: 201 ]]
	if not p1.Active then
		p1.Active = true
		if p3 then
			Start(p2)
		else
			Load(p2)
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 214 | Upvalues: v1 (copy) ]]
	if p1.Active then
		v1:Clean()
		p1.Active = false
	end
end
return t