-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
require(ReplicatedStorage.Shared.Packages.Trove)
local ShakerController = require(ReplicatedStorage.Modules.ControllerLoader.ShakerController)
local AnimateBrainrots = require(ReplicatedStorage.Modules.ServicesLoader.VFXService.AnimateBrainrots)
local GetPoint = require(ReplicatedStorage.Functional.GetPoint)
local LocalPlayer = game:GetService("Players").LocalPlayer
local LBThrow = SoundService.Effects.LBThrow
local LBLand = SoundService.Effects.LBLand
function bezier_block(p1, p2) --[[ bezier_block | Line: 22 | Upvalues: RunService (copy), GetPoint (copy) ]]
	local t = { p1.Position }
	local v1 = p1.CFrame:ToWorldSpace(CFrame.new(0, 0, -10))
	local v2 = workspace:Raycast(v1.Position, Vector3.new(0, -50, 0))
	if v2 then
		v1 = CFrame.new(v2.Position) * v1.Rotation * CFrame.new(0, p1.Size.Y / 2, 0)
	end
	local v3 = v1.Position - p1.Position
	t[2] = p1.Position + v3.Unit * v3.Magnitude / 2 + Vector3.new(0, 20, 0)
	t[3] = v1.Position
	local v4 = 0
	local v5 = 0
	local v6 = nil
	v6 = RunService.PreRender:Connect(function(p12) --[[ Line: 42 | Upvalues: p1 (copy), v4 (ref), v5 (ref), GetPoint (ref), t (copy), v1 (ref), v6 (ref), p2 (copy) ]]
		if p1 then
			v4 = v4 + p12
			v5 = v5 + p12 * 20
			local v2 = math.clamp(v4 / 0.5, 0, 1)
			local v3 = GetPoint(v2, t)
			p1.CFrame = CFrame.new(v3) * v1.Rotation * CFrame.Angles(v5, 0, 0)
			if v2 == 1 then
				v6:Disconnect()
				p1.CFrame = v1
				p2()
			end
		end
	end)
end
function shake_block(p1, p2) --[[ shake_block | Line: 64 | Upvalues: ShakerController (copy), TweenService (copy) ]]
	if p1 and p1.Parent then
		local v1 = p1.Parent
		local v2 = p1.CFrame
		local v3 = ShakerController.add(5, 1, 0.6, function(p12) --[[ Line: 72 | Upvalues: p1 (copy), v2 (copy) ]]
			p1.CFrame = v2 * p12
		end)
		local Highlight = Instance.new("Highlight")
		Highlight.FillTransparency = 1
		Highlight.OutlineTransparency = 1
		Highlight.FillColor = Color3.new(255/255, 255/255, 255/255)
		Highlight.Parent = v1
		Highlight.Adornee = v1
		local v4 = TweenService:Create(Highlight, TweenInfo.new(1), {
			FillTransparency = 0
		})
		v4:Play()
		task.delay(1, function() --[[ Line: 86 | Upvalues: v3 (copy), v4 (copy), Highlight (copy), p1 (copy), v2 (copy), p2 (copy) ]]
			v3()
			v4:Destroy()
			Highlight:Destroy()
			p1.CFrame = v2
			p2()
		end)
	end
end
function explode_block(p1) --[[ explode_block | Line: 95 | Upvalues: ReplicatedStorage (copy), SoundService (copy) ]]
	local v1 = ReplicatedStorage.Objects.VFX.KickVFX:Clone()
	local v2 = SoundService.Effects.Explosion_1:Clone()
	v2.Parent = p1
	v1.Parent = p1
	for i, v in ipairs(p1.Parent:GetDescendants()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = 1
		end
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
		if v:IsA("Light") then
			v.Enabled = false
		end
	end
	for i, v in ipairs(v1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount") or 1)
		end
	end
	v2:Play()
	game:GetService("Debris"):AddItem(v1, 3)
	game:GetService("Debris"):AddItem(v2, 3)
end
return function(p1, p2, p3, p4, p5) --[[ Line: 122 | Upvalues: LocalPlayer (copy), ReplicatedStorage (copy), LBThrow (copy), LBLand (copy), AnimateBrainrots (copy) ]]
	if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
		local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
		if Humanoid then
			local v1 = ReplicatedStorage.Objects.LuckyBlockModels:FindFirstChild(p1)
			if v1 then
				local v2 = v1:Clone()
				local Root = v2:WaitForChild("Root")
				Root.Anchored = true
				Root.CFrame = LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, -(Humanoid.HipHeight + LocalPlayer.Character.PrimaryPart.Size.Y / 2), 0) * CFrame.new(0, Root.Size.Y / 2, 0)
				v2.Parent = workspace.Debris
				LBThrow:Play()
				bezier_block(Root, function() --[[ Line: 145 | Upvalues: LBLand (ref), Root (copy), AnimateBrainrots (ref), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), v2 (copy) ]]
					LBLand:Play()
					shake_block(Root, function() --[[ Line: 147 | Upvalues: Root (ref), AnimateBrainrots (ref), p1 (ref), p2 (ref), p3 (ref), p4 (ref), p5 (ref), v2 (ref) ]]
						explode_block(Root)
						AnimateBrainrots(p1, Root.CFrame * CFrame.new(0, -Root.Size.Y / 2, 0), p2, p3, p4, p5)
						game:GetService("Debris"):AddItem(v2, 2)
					end)
				end)
			end
		end
	end
end