-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local CurveUtil = require(ReplicatedStorage.Modules.Util.CurveUtil)
local VFXController = require(ReplicatedStorage.Controllers.VFXController)
local SuperTween = require(script.Parent.Parent.Internal.SuperTween)
require(script.Parent.Parent.Internal.Types)
local v1 = Net:RemoteFunction("CompletedWarp")
local CurrentCamera = workspace.CurrentCamera
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 31 | Upvalues: Trove (copy), Signal (copy), Players (copy), t (copy) ]]
	local v1 = Trove.new()
	local t2 = {
		Model = nil,
		ForcefieldModel = nil,
		StartTime = 0,
		Signature = p5,
		Cleaner = v1:Extend(),
		TeleportCleaner = v1:Extend(),
		Cancelled = Signal.new(),
		Destroyed = Signal.new(),
		Completed = Signal.new(),
		TeleportPlayer = p1,
		TeleportCharacter = p2
	}
	t2.CustomCamera = if p1 == Players.LocalPlayer then true else false
	t2.Points = {}
	t2.Origin = p3
	t2.Goal = p4
	local v4 = setmetatable(t2, t)
	v4.Cleaner:Add(function() --[[ Line: 55 | Upvalues: v4 (copy) ]]
		v4.Cancelled:DisconnectAll()
		v4.Cancelled:Destroy()
	end)
	v4.Cleaner:Add(function() --[[ Line: 60 | Upvalues: v4 (copy) ]]
		v4.Destroyed:DisconnectAll()
		v4.Destroyed:Destroy()
	end)
	v4.Cleaner:Add(function() --[[ Line: 65 | Upvalues: v4 (copy) ]]
		v4.Completed:DisconnectAll()
		v4.Completed:Destroy()
	end)
	return v4
end
function t.OnCanceled(p1, p2) --[[ OnCanceled | Line: 73 ]]
	p1.Cancelled:Connect(p2)
end
function t.OnDestroyed(p1, p2) --[[ OnDestroyed | Line: 77 ]]
	p1.Destroyed:Connect(p2)
end
function t.Recalculate(p1, p2) --[[ Recalculate | Line: 81 | Upvalues: CurrentCamera (copy) ]]
	local v2 = math.min((tick() - p1.StartTime) / 2.2, 1)
	local v3 = v2 * (#p1.Points - 1) + 1
	local v4 = math.floor(v3)
	local v7 = p1.Points[v4]:Lerp(p1.Points[math.min(v4 + 1, #p1.Points)], v3 - v4)
	if p1.Model and p1.Model.Parent then
		local Position = v7.Position
		local Unit = ((if v2 < 0.99 then p1.Points[math.min(v4 + 2, #p1.Points)].Position else p1.Points[#p1.Points].Position) - Position).Unit
		local v11 = Vector3.new(0, 1, 0)
		if math.abs((Unit:Dot(v11))) > 0.99 then
			v11 = Vector3.new(1, 0, 0)
		end
		local Unit_2 = Unit:Cross(v11).Unit
		local Unit_3 = Unit_2:Cross(Unit).Unit
		local v13 = CFrame.fromMatrix(Position, Unit_2, Unit_3, -Unit)
		if p1.CustomCamera and v2 >= 0.3 then
			local v14 = v13 * CFrame.new(Vector3.new(0, 0, 30))
			CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v14, v2 * 0.1)
			CurrentCamera.Focus = v14
		end
		local v15 = v13 * CFrame.Angles(0, 0, 0)
		p1.Model:PivotTo(v15)
		p1.ForcefieldModel:PivotTo(v15)
	end
	if not (v2 >= 1) then
		return
	end
	p1:ModelCompleted()
end
function t.Teleport(p1) --[[ Teleport | Line: 151 | Upvalues: CurrentCamera (copy), CurveUtil (copy), Players (copy), SuperTween (copy), RunService (copy) ]]
	local v1 = p1.TeleportCharacter:FindFirstChildWhichIsA("Humanoid")
	local v2 = v1:GetAppliedDescription()
	v1:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	v1:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	local v3 = script.ForcefieldModel:Clone()
	v3.Parent = CurrentCamera
	p1.ForcefieldModel = v3
	local v4 = script.Rig:Clone()
	local v5 = v4:FindFirstChildWhichIsA("Humanoid")
	local v6 = v5:FindFirstChildWhichIsA("Animator"):LoadAnimation(script.FallAnim)
	v6.Looped = true
	v6:Play()
	p1.Cleaner:Add(function() --[[ Line: 170 | Upvalues: v6 (ref) ]]
		v6:Destroy()
		v6 = nil
	end)
	v5:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	v5:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	v4.HumanoidRootPart.Anchored = true
	v4:PivotTo(CFrame.new(5000, 5000, 5000))
	v4.Parent = CurrentCamera
	p1.Model = v4
	xpcall(function() --[[ Line: 185 | Upvalues: v5 (copy), v2 (copy) ]]
		v5:ApplyDescriptionAsync(v2)
	end, warn)
	local v7 = math.max(p1.Origin.Position.Y, p1.Goal.Position.Y) + 30
	p1.Points = CurveUtil.GetCurveBetween({
		numPoints = 40,
		visualize = true,
		withRotation = true,
		start = p1.Origin.Position,
		finish = p1.Goal.Position,
		curveHeight = v7,
		yRotation = CFrame.fromOrientation(0, 0, 0)
	})
	p1.Points[#p1.Points] = p1.Goal
	p1.StartTime = tick()
	if p1.CustomCamera then
		pcall(function() --[[ Line: 205 | Upvalues: Players (ref), p1 (copy) ]]
			Players.LocalPlayer:RequestStreamAroundAsync(p1.Points[1].Position)
		end)
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CameraSubject = v5
		CurrentCamera.Focus = v4:GetPivot()
		local v8 = SuperTween.new(CurrentCamera, TweenInfo.new(0.3), {
			CFrame = CurrentCamera.CFrame * CFrame.new(Vector3.new(0, 0, 30)),
			FieldOfView = 60
		})
		v8:Play()
		v8.Completed:Wait()
	end
	RunService:BindToRenderStep("CameraUpdater", Enum.RenderPriority.Camera.Value + 1, function(p12) --[[ Line: 222 | Upvalues: p1 (copy) ]]
		p1:Recalculate(p12)
	end)
	if p1.TeleportCharacter and p1.TeleportCharacter:FindFirstChild("Head") then
		p1:HideCharacter()
	end
	v4:PivotTo(p1.Points[1])
end
function t.Stop(p1, p2) --[[ Stop | Line: 233 | Upvalues: RunService (copy), Players (copy), v1 (copy), SuperTween (copy), CurrentCamera (copy), VFXController (copy) ]]
	RunService:UnbindFromRenderStep("CameraUpdater")
	if p1.CustomCamera and p2 then
		pcall(function() --[[ Line: 237 | Upvalues: Players (ref), p1 (copy) ]]
			Players.LocalPlayer:RequestStreamAroundAsync(p1.Goal.Position)
		end)
		v1:InvokeServer("Character", p1.Signature)
	end
	p1:UnhideCharacter()
	p1.ForcefieldModel.Parent = nil
	p1.Model.Parent = nil
	if p1.CustomCamera and p2 then
		local _ = p1.Points[#p1.Points]
		local Goal = p1.Goal
	end
	if not p1.CustomCamera then
		return
	end
	if p2 then
		local v2, _, v3 = p1.Goal:ToOrientation()
		local v4 = p1.TeleportCharacter.Head.CFrame * CFrame.new(Vector3.new(0, 0, 15)) * CFrame.Angles(math.rad(v2), 0, (math.rad(v3))) + Vector3.new(0, 2, 0)
		local v5 = SuperTween.new(CurrentCamera, TweenInfo.new(0.4), {
			CFrame = v4,
			FieldOfView = 70
		})
		v5:Play()
		v5.Completed:Wait()
	end
	CurrentCamera.CameraType = Enum.CameraType.Custom
	CurrentCamera.CameraSubject = p1.TeleportCharacter.Humanoid
	if not p1.TeleportCharacter then
		return
	end
	VFXController:RenderAtPoint("Bubble Explode", p1.TeleportCharacter:GetPivot())
end
function t.Ended(p1) --[[ Ended | Line: 309 ]]
	p1.TeleportCleaner:Clean()
	p1.Cleaner:Clean()
	p1.Model:Destroy()
	p1.ForcefieldModel:Destroy()
end
function t.ModelCompleted(p1) --[[ ModelCompleted | Line: 317 ]]
	p1:Stop(true)
	p1.Completed:Fire()
	p1:Ended()
end
function t.Cancel(p1) --[[ Cancel | Line: 324 ]]
	p1:Stop()
	p1.Cancelled:Fire()
	p1:Ended()
end
function t.Destroy(p1) --[[ Destroy | Line: 331 ]]
	p1:Stop()
	p1:Ended()
	p1.Destroyed:Fire()
end
function t.UnhideCharacter(p1) --[[ UnhideCharacter | Line: 337 ]]
	for i, v in ipairs(p1.Collection.Parts) do
		v.LocalTransparencyModifier = v.LocalTransparencyModifier - 1
	end
	for i, v in ipairs(p1.Collection.Effects) do
		v.Enabled = true
	end
	for i, v in ipairs(p1.Collection.Textures) do
		v.Transparency = v.Transparency - 1
	end
	table.clear(p1.Collection)
end
function t.HideCharacter(p1) --[[ HideCharacter | Line: 353 ]]
	p1.Collection = {
		Textures = {},
		Parts = {},
		Effects = {}
	}
	for i, v in ipairs(p1.TeleportCharacter:GetDescendants()) do
		p1:HideInstance(v)
	end
	p1.Cleaner:Add(p1.TeleportCharacter.DescendantAdded:Connect(function(p12) --[[ Line: 364 | Upvalues: p1 (copy) ]]
		p1:HideInstance(p12)
	end))
end
function t.IsEffect(p1, p2) --[[ IsEffect | Line: 369 ]]
	return p2:IsA("Trail") or (p2:IsA("ParticleEmitter") or (p2:IsA("Beam") or (p2:IsA("Light") or (p2:IsA("Sparkles") or (p2:IsA("Fire") or p2:IsA("Smoke"))))))
end
function t.HideInstance(p1, p2) --[[ HideInstance | Line: 379 ]]
	if p2:IsA("BasePart") then
		p2.LocalTransparencyModifier = p2.LocalTransparencyModifier + 1
		table.insert(p1.Collection.Parts, p2)
	end
	if p1:IsEffect(p2) and p2.Enabled then
		p2.Enabled = false
		table.insert(p1.Collection.Effects, p2)
	end
	if not p2:IsA("Decal") then
		return
	end
	p2.Transparency = p2.Transparency + 1
	table.insert(p1.Collection.Textures, p2)
end
return t