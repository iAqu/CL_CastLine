-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("CollectionService")
local Trove = require(ReplicatedStorage.Packages.Trove)
local EmitAt = require(script.EmitAt)
local FOVTable = require(script.FOVTable)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Modules.Util.TweenUtil)
local ClientTimeController = require(ReplicatedStorage.Controllers.ClientTimeController)
local function BlackScreen(p1) --[[ BlackScreen | Line: 26 | Upvalues: Players (copy), TweenService (copy) ]]
	local v2 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
	local v3 = v2 and v2:FindFirstChild("Blackout")
	if not v3 then
		return
	end
	v3.Label.Visible = false
	v3.Blackout.BackgroundTransparency = 1
	v3.Blackout.BackgroundColor3 = (p1 or false) and Color3.new(255/255, 255/255, 255/255) or Color3.new(0/255, 0/255, 0/255)
	local v5 = TweenService:Create(v3.Blackout, TweenInfo.new(0.5), {
		BackgroundTransparency = 0
	})
	local v6 = TweenService:Create(v3.Blackout, TweenInfo.new(0.5), {
		BackgroundTransparency = 1
	})
	v6.Completed:Once(function() --[[ Line: 39 | Upvalues: v3 (copy) ]]
		v3.Enabled = false
		v3.Label.Visible = true
		v3.Blackout.BackgroundTransparency = 0
		v3.Blackout.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	end)
	v3.Enabled = true
	v5:Play()
	v5.Completed:Wait()
	task.wait(0.3)
	v6:Play()
end
local v1 = nil
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 60 | Upvalues: t (copy), Trove (copy), Players (copy), v1 (ref) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = Trove.new()
	v2.Destroyed = false
	v2.Finished = false
	v2.Camera = nil
	local CutsceneStuff = Instance.new("Model")
	CutsceneStuff.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	CutsceneStuff.Name = "CutsceneStuff"
	CutsceneStuff.Parent = workspace
	v2.Cleaner:Add(CutsceneStuff)
	local t2 = {}
	local t3 = {}
	for v3, v4 in script.Rigs:GetChildren() do
		local v5 = v4:Clone()
		local v6 = script.Animations:FindFirstChild(v5.Name)
		local v7 = v5:FindFirstChildWhichIsA("Animator", true)
		if v7 then
			v5.Parent = CutsceneStuff
			local v8 = v7:LoadAnimation(v6)
			v8.Priority = Enum.AnimationPriority.Action4
			v8.Looped = false
			table.insert(t2, v8)
		else
			warn("Failed to find Animator!")
		end
		if v5.Name == "Cam" then
			v2.Camera = v5
		elseif v5.Name == "Character" then
			local Character = Players.LocalPlayer.Character
			local v9 = if Character then Character.Humanoid:GetAppliedDescription() else Character
			if v9 then
				v5.Humanoid:ApplyDescription(v9)
			end
		end
		if v5:HasTag("ReplicationFocus") then
			v1 = v5.PrimaryPart
		end
		v2.Cleaner:Add(v5)
		table.insert(t3, v5)
	end
	if script:FindFirstChild("Scene") then
		local LocalPlayer = Players.LocalPlayer
		local v10 = script.Scene:Clone()
		v10.Parent = CutsceneStuff
		v2.Cleaner:Add(v10)
	end
	for v11, v122 in script.VFX:GetChildren() do
		local v13 = v122:Clone()
		v13.Parent = CutsceneStuff
		v2.Cleaner:Add(v13)
	end
	v2.Rigs = t3
	v2.Tracks = t2
	return v2
end
function t.Play(p1, p2, p3) --[[ Play | Line: 135 | Upvalues: Players (copy), GuiControl (copy), Lighting (copy), v1 (ref), ClientTimeController (copy), Soundbook (copy), BlackScreen (copy), RunService (copy), FOVTable (copy), EmitAt (copy) ]]
	Players.LocalPlayer:SetAttribute("InCutscene", true)
	local CurrentCamera = workspace.CurrentCamera
	local FieldOfView = CurrentCamera.FieldOfView
	local v12 = GuiControl:HideAllHUD({ "Blackout" })
	local v2 = p1.Camera.CamPart.CFrame
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.CFrame = v2
	CurrentCamera.Focus = v2
	Lighting.Blur.Enabled = false
	local LocalPlayer = Players.LocalPlayer
	LocalPlayer.ReplicationFocus = v1 or p1.Camera.CamPart
	ClientTimeController:_forceUpdateAndOverride("Day")
	for v4, v5 in workspace:GetDescendants() do
		if v5:IsA("ProximityPrompt") then
			v5.Enabled = false
		end
	end
	p1.Cleaner:Add(function() --[[ Line: 160 | Upvalues: CurrentCamera (copy), FieldOfView (copy), GuiControl (ref), v12 (copy), Lighting (ref), Players (ref), ClientTimeController (ref) ]]
		CurrentCamera.FieldOfView = FieldOfView
		CurrentCamera.CameraType = Enum.CameraType.Custom
		GuiControl:RestoreHUD(v12)
		Lighting.Blur.Enabled = true
		Players.LocalPlayer:SetAttribute("InCutscene", false)
		ClientTimeController:_removeOverride()
		for v1, v2 in workspace:GetDescendants() do
			if v2:IsA("ProximityPrompt") then
				v2.Enabled = true
			end
		end
	end, CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() --[[ Line: 174 | Upvalues: p1 (copy), CurrentCamera (copy), Players (ref), v1 (ref) ]]
		if not (p1 and (p1.Camera and p1.Camera:FindFirstChild("CamPart"))) then
			return
		end
		local v12 = p1.Camera.CamPart.CFrame
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CFrame = v12
		CurrentCamera.Focus = v12
		Players.LocalPlayer.ReplicationFocus = v1 or p1.Camera.CamPart
	end))
	Soundbook.Sounds["Underground Maja Cutscene"]:Play()
	task.wait(0.27)
	task.defer(BlackScreen)
	task.wait(0.3)
	p1.PreviousFrame = 0
	p1.Started = time()
	local v6 = false
	for v7, v8 in p1.Tracks do
		v8:Play()
	end
	local function Clean() --[[ Clean | Line: 201 | Upvalues: p1 (copy), RunService (ref) ]]
		if not p1.completed then
			p1.Finished = true
			RunService:UnbindFromRenderStep("SmoothCamera")
			p1.Cleaner:Clean()
			return
		end
		p1.completed()
		p1.Finished = true
		RunService:UnbindFromRenderStep("SmoothCamera")
		p1.Cleaner:Clean()
	end
	local v9 = false
	local v10 = 0
	RunService:BindToRenderStep("SmoothCamera", Enum.RenderPriority.Camera.Value + 1, function(p12) --[[ Line: 213 | Upvalues: p1 (copy), RunService (ref), CurrentCamera (copy), Players (ref), v1 (ref), v10 (ref), v9 (ref), FOVTable (ref), EmitAt (ref), v6 (ref), BlackScreen (ref), Clean (copy) ]]
		local v2 = math.ceil((time() - p1.Started) * 60) + 1
		if v2 == p1.PreviousFrame then
			return
		end
		if workspace:IsAncestorOf(p1.Camera) and workspace:IsAncestorOf(p1.Camera.CamPart) then
			local v3 = p1.Camera.CamPart.CFrame
			CurrentCamera.CFrame = v3
			CurrentCamera.Focus = v3
			local LocalPlayer = Players.LocalPlayer
			LocalPlayer.ReplicationFocus = v1 or p1.Camera.CamPart
			if v3.Position.Y < -3 and (v10 < tick() and not v9) then
				v9 = true
				task.spawn(function() --[[ Line: 234 | Upvalues: v1 (ref), Players (ref), v3 (copy), v10 (ref), v9 (ref) ]]
					if v1 then
						Players.LocalPlayer:RequestStreamAroundAsync(v1.Position)
					else
						Players.LocalPlayer:RequestStreamAroundAsync(v3.Position)
					end
					v10 = tick() + 5
					v9 = false
				end)
			end
			if FOVTable[tostring(v2)] then
				CurrentCamera.FieldOfView = FOVTable[tostring(v2)]
			end
			if EmitAt[v2] then
				task.defer(EmitAt[v2])
			end
			if p1.PreviousFrame + 1 ~= v2 and EmitAt[p1.PreviousFrame + 1] then
				task.defer(EmitAt[p1.PreviousFrame + 1])
			end
			if not v6 and v2 >= 1000 then
				v6 = true
				task.defer(BlackScreen, true)
				task.delay(0.5, Clean)
			end
			p1.PreviousFrame = v2
		else
			if p1.completed then
				p1.completed()
			end
			p1.Finished = true
			RunService:UnbindFromRenderStep("SmoothCamera")
			p1.Cleaner:Clean()
		end
	end)
end
function t.IsFinished(p1) --[[ IsFinished | Line: 270 ]]
	return p1.Finished
end
function t.Destroy(p1) --[[ Destroy | Line: 274 | Upvalues: v1 (ref), Players (copy) ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1.Cleaner:Destroy()
		v1 = nil
		Players.LocalPlayer.ReplicationFocus = nil
	end
end
return t