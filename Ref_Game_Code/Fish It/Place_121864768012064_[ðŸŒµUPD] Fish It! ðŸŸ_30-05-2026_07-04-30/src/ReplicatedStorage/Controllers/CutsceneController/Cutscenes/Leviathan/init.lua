-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("CollectionService")
local Trove = require(ReplicatedStorage.Packages.Trove)
local FOVTable = require(script.FOVTable)
local EmitAt = require(script.EmitAt)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local function BlackScreen(p1) --[[ BlackScreen | Line: 22 | Upvalues: Players (copy), TweenService (copy) ]]
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
	v6.Completed:Once(function() --[[ Line: 35 | Upvalues: v3 (copy) ]]
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
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 54 | Upvalues: t (copy), Trove (copy), Players (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = Trove.new()
	v2.Destroyed = false
	v2.Finished = false
	v2.Camera = nil
	local CutsceneStuff = Instance.new("Folder")
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
			local LocalPlayer = Players.LocalPlayer
			local Character = LocalPlayer.Character
			local v9 = if Character then Character.Humanoid:GetAppliedDescription() else Character
			if v9 then
				v5.Humanoid:ApplyDescription(v9)
			end
			LocalPlayer:RequestStreamAroundAsync(v5:GetPivot().Position)
		end
		v2.Cleaner:Add(v5)
		table.insert(t3, v5)
	end
	for v10, v11 in script.VFX:GetChildren() do
		local v12 = v11:Clone()
		v12.Parent = CutsceneStuff
		v2.Cleaner:Add(v12)
	end
	v2.Rigs = t3
	v2.Tracks = t2
	return v2
end
function t.Play(p1, p2, p3) --[[ Play | Line: 117 | Upvalues: Players (copy), Soundbook (copy), BlackScreen (copy), GuiControl (copy), RunService (copy), FOVTable (copy), EmitAt (copy) ]]
	Players.LocalPlayer:SetAttribute("InCutscene", true)
	local CurrentCamera = workspace.CurrentCamera
	local FieldOfView = CurrentCamera.FieldOfView
	Soundbook.Sounds["Leviathan Cutscene"]:Play()
	task.wait(0.1)
	task.defer(BlackScreen)
	task.wait(0.3)
	local v1 = GuiControl:HideAllHUD({ "Blackout" })
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.CFrame = p1.Camera.CamPart.CFrame
	p1.Cleaner:Add(function() --[[ Line: 138 | Upvalues: CurrentCamera (copy), FieldOfView (copy), GuiControl (ref), v1 (copy), Players (ref) ]]
		CurrentCamera.FieldOfView = FieldOfView
		CurrentCamera.CameraType = Enum.CameraType.Custom
		GuiControl:RestoreHUD(v1)
		Players.LocalPlayer:SetAttribute("InCutscene", false)
	end)
	p1.Cleaner:Add(CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() --[[ Line: 147 | Upvalues: CurrentCamera (copy), p1 (copy) ]]
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CFrame = p1.Camera.CamPart.CFrame
	end))
	p1.PreviousFrame = 0
	p1.Started = time()
	local v2 = nil
	local v3 = false
	for v4, v5 in p1.Tracks do
		v5:Play()
	end
	local function Clean() --[[ Clean | Line: 163 | Upvalues: p1 (copy), v2 (ref) ]]
		p1.Finished = true
		v2:Disconnect()
		p1.Cleaner:Clean()
	end
	local _ = RunService.RenderStepped:Connect(function(p12) --[[ Line: 169 | Upvalues: p1 (copy), v2 (ref), CurrentCamera (copy), FOVTable (ref), EmitAt (ref), v3 (ref), BlackScreen (ref), Clean (copy) ]]
		local v22 = math.ceil((time() - p1.Started) * 60) + 1
		if v22 == p1.PreviousFrame then
			return
		end
		if not (workspace:IsAncestorOf(p1.Camera) and workspace:IsAncestorOf(p1.Camera.CamPart)) then
			p1.Finished = true
			v2:Disconnect()
			p1.Cleaner:Clean()
			return
		end
		CurrentCamera.CFrame = p1.Camera.CamPart.CFrame
		if FOVTable[tostring(v22)] then
			CurrentCamera.FieldOfView = FOVTable[tostring(v22)]
		end
		if EmitAt[v22] then
			task.defer(EmitAt[v22])
		end
		if p1.PreviousFrame + 1 ~= v22 and EmitAt[p1.PreviousFrame + 1] then
			task.defer(EmitAt[p1.PreviousFrame + 1])
		end
		if not v3 and v22 >= 1230 then
			v3 = true
			task.defer(BlackScreen, true)
			task.delay(0.5, Clean)
		end
		p1.PreviousFrame = v22
	end)
end
function t.IsFinished(p1) --[[ IsFinished | Line: 201 ]]
	return p1.Finished
end
function t.Destroy(p1) --[[ Destroy | Line: 205 ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1.Cleaner:Destroy()
	end
end
return t