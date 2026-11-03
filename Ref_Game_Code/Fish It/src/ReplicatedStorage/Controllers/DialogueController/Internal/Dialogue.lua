-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
game:GetService("Lighting")
game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Quest = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Quest")
local CurrentCamera = workspace.CurrentCamera
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Thread = require(ReplicatedStorage.Packages.Thread)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local DialogueTree = require(script.Parent.DialogueTree)
local v1 = Net:RemoteEvent("DialogueEnded")
local v2 = Net:RemoteEvent("TriggerSubmarine")
local SelectionVisual = script.SelectionVisual
local DialoguePrompt = script.DialoguePrompt
local Option = DialoguePrompt.Content.Inside.List.Option
Option.Parent = nil
require(script.Parent.Types)
local v3 = Signal.new()
local t = {}
local t2 = {
	_activeInstance = nil
}
t2.__index = t2
t2.PathSignal = v3
local function setMovementLocked(p1) --[[ setMovementLocked | Line: 64 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return
	end
	local WalkSpeed = Humanoid.WalkSpeed
	local JumpPower = Humanoid.JumpPower
	if p1 then
		Humanoid.WalkSpeed = 0
		Humanoid.JumpPower = 0
	end
	return function() --[[ Line: 83 | Upvalues: Humanoid (copy), WalkSpeed (copy), JumpPower (copy) ]]
		if not Humanoid.Parent then
			return
		end
		Humanoid.WalkSpeed = WalkSpeed
		Humanoid.JumpPower = JumpPower
	end
end
local function enableOcclusion(p1, p2, p3) --[[ enableOcclusion | Line: 91 | Upvalues: t (copy) ]]
	for v1, v2 in workspace.CurrentCamera:GetPartsObscuringTarget(p1, p2) do
		if not t[v2] then
			t[v2] = true
			v2.LocalTransparencyModifier = p3
			for v3, v4 in v2:GetChildren() do
				if v4:IsA("Decal") or v4:IsA("Texture") then
					v4.LocalTransparencyModifier = p3
				end
			end
		end
	end
end
local function disableOcclusion() --[[ disableOcclusion | Line: 106 | Upvalues: t (copy) ]]
	for v1 in t do
		if v1 and v1.Parent then
			v1.LocalTransparencyModifier = 0
			for v2, v3 in v1:GetChildren() do
				if v3:IsA("Decal") or v3:IsA("Texture") then
					v3.LocalTransparencyModifier = 0
				end
			end
		end
	end
	table.clear(t)
end
local function togglRod(p1, p2) --[[ togglRod | Line: 122 ]]
	local v1 = p1:FindFirstChild("!!!FISHING_VIEW_MODEL!!!") or p1:FindFirstChild("!!!EQUIPPED_TOOL!!!")
	local t = { "ParticleEmitter", "Beam", "Trail", "PointLight", "SpotLight", "SurfaceLight" }
	if not v1 then
		return
	end
	for v2, v3 in v1:GetDescendants() do
		if v3:IsA("BasePart") then
			v3.LocalTransparencyModifier = if p2 then 0 else 1
			continue
		end
		if table.find(t, v3.ClassName) then
			v3.Enabled = p2
		end
	end
end
local function focusCameraOn(p1) --[[ focusCameraOn | Line: 136 | Upvalues: CurrentCamera (copy), LocalPlayer (copy), TweenService (copy), Quest (copy), RunService (copy), enableOcclusion (copy), togglRod (copy), disableOcclusion (copy) ]]
	local CameraType = CurrentCamera.CameraType
	local v1 = CurrentCamera.CFrame
	local FieldOfView = CurrentCamera.FieldOfView
	if CameraType == Enum.CameraType.Scriptable then
		CameraType = Enum.CameraType.Custom
	end
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	local Character = LocalPlayer.Character
	local v2 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
	local v3 = p1.Position + Vector3.new(0, 0.073, 0)
	if v2 then
		local v4 = v3 - v2.Position
		if v4.Magnitude > 0.001 then
			v2.CFrame = CFrame.new(v2.Position, v2.Position + Vector3.new(v4.X, 0, v4.Z))
		end
	end
	local Position = v1.Position
	if v2 then
		Position = v2.Position + (v2.CFrame.RightVector * 4.1 - v2.CFrame.LookVector * 4.34) + Vector3.new(0, 2.05, 0)
	end
	TweenService:Create(CurrentCamera, TweenInfo.new(1.24, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		FieldOfView = 55,
		CFrame = CFrame.new(Position, v3)
	}):Play()
	local v7 = if p1 then p1.Parent and p1:FindFirstChild((("Tag - %*"):format(p1.Parent.Name))) else p1
	if v7 then
		TweenService:Create(v7, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new()
		}):Play()
	end
	local v8 = if p1 then p1.Parent and p1:FindFirstChild((("Tracker - %*"):format(p1.Parent.Name))) else p1
	if v8 then
		for v9, v10 in v8:GetChildren() do
			if v10:IsA("GuiObject") then
				v10.Visible = false
			end
		end
	end
	Quest.Enabled = false
	local v11 = RunService.RenderStepped:Connect(function() --[[ Line: 190 | Upvalues: enableOcclusion (ref), v3 (copy), LocalPlayer (ref), p1 (copy) ]]
		enableOcclusion({ v3 }, { LocalPlayer.Character, p1.Parent }, 0.75)
	end)
	local v12 = Character.ChildAdded:Connect(function() --[[ Line: 198 | Upvalues: togglRod (ref), Character (copy) ]]
		togglRod(Character, false)
	end)
	togglRod(Character, false)
	return function() --[[ Line: 204 | Upvalues: CurrentCamera (ref), TweenService (ref), v1 (copy), FieldOfView (copy), CameraType (ref), v11 (copy), v12 (copy), disableOcclusion (ref), togglRod (ref), Character (copy) ]]
		if CurrentCamera then
			local v13 = TweenService:Create(CurrentCamera, TweenInfo.new(0.31, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				CFrame = v1,
				FieldOfView = FieldOfView
			})
			v13:Play()
			v13.Completed:Wait()
			CurrentCamera.CameraType = CameraType
		end
		if v11 then
			v11:Disconnect()
		end
		if v12 then
			v12:Disconnect()
		end
		disableOcclusion()
		togglRod(Character, true)
	end
end
local function typewriter(p1, p2, p3) --[[ typewriter | Line: 231 ]]
	p2.MaxVisibleGraphemes = -1
	p2.Text = p3
	task.wait()
	p2.MaxVisibleGraphemes = 0
	p1._typing = true
	p1._skipTyping = false
	for v1 in utf8.graphemes(p3) do
		if p1._skipTyping then
			p2.MaxVisibleGraphemes = -1
			break
		end
		p2.MaxVisibleGraphemes = p2.MaxVisibleGraphemes + 1
		task.wait(0.022222222222222223)
	end
	p1._typing = false
end
function t2.create(p1, p2, p3) --[[ create | Line: 258 | Upvalues: t2 (copy), Signal (copy), Trove (copy), DialoguePrompt (copy), LocalPlayer (copy), focusCameraOn (copy), UserInputService (copy), Thread (copy), typewriter (copy) ]]
	if t2._activeInstance then
		t2._activeInstance:restoreCutscene()
		t2._activeInstance._interrupted = true
		t2._activeInstance:stop()
	end
	local v1 = nil
	local v3 = setmetatable({}, t2)
	t2._activeInstance = v3
	local function void() --[[ void | Line: 270 | Upvalues: v1 (ref), v3 (copy) ]]
		if v1 then
			v3.cleaner:Remove(v1)
		end
		v3:stop()
	end
	v3.name = p1
	v3.path = 1
	v3.selecting = -1
	v3.pivot = p3:GetPivot()
	v3.animating = false
	v3.dead = false
	v3.selectionMade = false
	v3.waitSignal = Signal.new()
	v3._typing = false
	v3._skipTyping = false
	v3._speechGui = nil
	v3._speechText = nil
	v3._speechSeq = 0
	v3._cutsceneRestored = false
	v3._usedTypewriter = false
	v3._interrupted = false
	v3._pathSeq = 0
	v3.cleaner = Trove.new()
	v3.optionCleaner = v3.cleaner:Extend()
	v3.selectionCleaner = v3.cleaner:Extend()
	v3.basePart = p2
	v3.instance = v3.cleaner:Clone(DialoguePrompt)
	v3.instance.StudsOffset = Vector3.new(6, 0.5, 0)
	local v4 = p2:FindFirstChild((("Tag - %*"):format(v3.name)))
	if v4 then
		v3.overheadTag = v4
		v3.overheadTagSize = v4.Size
	end
	local Head = p3:FindFirstChild("Head")
	if Head then
		v3._speechGui = script.NPCSpeechBubble:Clone()
		if not v3._speechGui then
			return
		end
		v3._speechGui.Adornee = Head
		v3._speechGui.Parent = LocalPlayer.PlayerGui
		local Main = v3._speechGui:FindFirstChild("Main")
		if Main and Main:IsA("Frame") then
			local Title = Main:FindFirstChild("Title")
			if Title and Title:IsA("TextLabel") then
				v3._speechText = Title
			end
			local Background = Main:FindFirstChild("Background")
			if Background and (Background:IsA("GuiObject") and (Title and Title:IsA("TextLabel"))) then
				v3._speechTextBackground = Background
				local function updateSpeechBackgroundVisibility() --[[ updateSpeechBackgroundVisibility | Line: 336 | Upvalues: Background (copy), Title (copy) ]]
					Background.Visible = string.len(Title.Text) > 0
				end
				Background.Visible = string.len(Title.Text) > 0
				Title:GetPropertyChangedSignal("Text"):Connect(updateSpeechBackgroundVisibility)
				Background.Size = UDim2.fromOffset(Title.AbsoluteSize.X + 10, Title.AbsoluteSize.Y)
				Title:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 344 | Upvalues: Background (copy), Title (copy) ]]
					Background.Size = UDim2.fromOffset(Title.AbsoluteSize.X + 10, Title.AbsoluteSize.Y)
				end)
			end
		end
	end
	local Character = LocalPlayer.Character
	local v6
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			local WalkSpeed = Humanoid.WalkSpeed
			local JumpPower = Humanoid.JumpPower
			Humanoid.WalkSpeed = 0
			Humanoid.JumpPower = 0
			v6 = function() --[[ Line: 83 | Upvalues: Humanoid (copy), WalkSpeed (copy), JumpPower (copy) ]]
				if not Humanoid.Parent then
					return
				end
				Humanoid.WalkSpeed = WalkSpeed
				Humanoid.JumpPower = JumpPower
			end
		else
			v6 = nil
		end
	else
		v6 = nil
	end
	v3._unlockMovement = v6
	if Head then
		local v7 = focusCameraOn(Head) or (function() --[[ Line: 355 ]] end)
		function v3._restoreCamera() --[[ Line: 357 | Upvalues: v7 (copy) ]]
			v7()
		end
	end
	v3.cleaner:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 362 | Upvalues: v3 (copy) ]]
		if p2 then
			return
		end
		if p1.UserInputType ~= Enum.UserInputType.MouseButton1 and p1.KeyCode ~= Enum.KeyCode.Space or not v3._typing then
			return
		end
		v3._skipTyping = true
	end))
	v3.cleaner:Add(p3.AncestryChanged:Connect(function() --[[ Line: 375 | Upvalues: p3 (copy), v3 (copy) ]]
		if p3:IsDescendantOf(workspace) then
			return
		end
		v3:stop()
	end))
	v1 = v3.cleaner:Add(Thread:Execute(60, function() --[[ Line: 382 | Upvalues: LocalPlayer (ref), v3 (copy), typewriter (ref), v1 (ref) ]]
		local Character = LocalPlayer.Character
		if not (if Character then (Character:GetPivot().Position - v3.pivot.Position).Magnitude >= 20 else false) then
			return
		end
		if v3._speechText then
			local v2 = v3
			v2._speechSeq = v2._speechSeq + 1
			local _speechSeq = v3._speechSeq
			v3._speechText.TextTransparency = 0
			v3._speechText.Text = ""
			v3._usedTypewriter = true
			typewriter(v3, v3._speechText, "You walked away!")
			v3:endCutsceneAfterSpeech(_speechSeq)
		end
		if v1 then
			v3.cleaner:Remove(v1)
		end
		v3:stop()
	end))
	v3:populate()
	if v3.instance then
		v3.instance.Adornee = v3.basePart
		v3.instance.Parent = LocalPlayer.PlayerGui
	end
	return v3
end
function t2.undoSelect(p1) --[[ undoSelect | Line: 417 ]]
	p1.selecting = -1
	p1.selectionCleaner:Clean()
end
function t2.select(p1, p2, p3) --[[ select | Line: 422 | Upvalues: SelectionVisual (copy), spr (copy) ]]
	if p1.selecting == p2 then
		return
	end
	local selectionMade = p1.selectionMade
	if p1.dead then
		return
	end
	p1.selectionMade = true
	p1.selecting = p2
	p1.selectionCleaner:Clean()
	local v1 = p1.instance.Content.Inside.List:FindFirstChild((tostring(p2)))
	if v1 then
		local v2 = p1.selectionCleaner:Clone(SelectionVisual)
		local Shadow = v1.Shadow
		local BG = v1.BG
		spr.stop(Shadow)
		spr.stop(BG)
		spr.target(BG, 1, 3, {
			BackgroundTransparency = 0.2
		})
		spr.target(Shadow, 1, 3, {
			ImageTransparency = 0.5
		})
		p1.selectionCleaner:Add(function() --[[ Line: 459 | Upvalues: spr (ref), Shadow (copy), BG (copy) ]]
			spr.stop(Shadow)
			spr.stop(BG)
			spr.target(BG, 1, 3, {
				BackgroundTransparency = 0.3
			})
			spr.target(Shadow, 1, 3, {
				ImageTransparency = 1
			})
		end)
		v2.Parent = v1.Items
	end
	p1.selectionMade = false
end
function t2.confirmSelection(p1, p2, p3, p4) --[[ confirmSelection | Line: 477 | Upvalues: v2 (copy), v1 (copy), t2 (copy), typewriter (copy) ]]
	local selectionMade = p1.selectionMade
	p1.selectionMade = true
	if p4 and p4.FinishedCallback then
		task.spawn(p4.FinishedCallback)
	end
	task.defer(function() --[[ Line: 490 | Upvalues: p1 (copy), v2 (ref), p4 (copy), v1 (ref), p2 (copy), p3 (copy), t2 (ref) ]]
		if p1.name == "Submarine Operator" then
			v2:FireServer(p4)
		end
		v1:FireServer(p1.name, p2, p3)
		t2.PathSignal:Fire(p1.name, p2, p3)
	end)
	local v12 = nil
	local Response = p4.Response
	if typeof(Response) == "function" then
		v12 = Response()
	elseif typeof(Response) == "string" then
		v12 = Response
	end
	if typeof(v12) == "string" and (string.len(v12) > 0 and p1._speechText) then
		p1._speechText.TextTransparency = 0
		p1._speechText.Text = ""
		local _speechTextBackground = p1._speechTextBackground
		local _speechText = p1._speechText
		if _speechTextBackground and _speechText then
			_speechTextBackground.BackgroundTransparency = script.NPCSpeechBubble.Main.Background.BackgroundTransparency
			local UIStroke = _speechText:FindFirstChildOfClass("UIStroke")
			if UIStroke then
				UIStroke.Transparency = script.NPCSpeechBubble.Main.Title.UIStroke.Transparency
			end
		end
		p1._speechSeq = p1._speechSeq + 1
		local _speechSeq = p1._speechSeq
		p1._usedTypewriter = true
		typewriter(p1, p1._speechText, v12)
		p1:endCutsceneAfterSpeech(_speechSeq)
	end
	if p4.Result then
		p1:stop(p4.Result)
		return
	end
	if p4.Void then
		p1:stop()
		return
	end
	if p4.Path then
		p1:next(p4.Path)
	else
		p1:stop()
	end
end
function t2.populate(p1) --[[ populate | Line: 564 | Upvalues: DialogueTree (copy), Option (copy), GuiControl (copy) ]]
	p1.optionCleaner:Clean()
	p1:undoSelect()
	local v1 = DialogueTree[p1.name]
	if not v1 then
		return
	end
	local path = p1.path
	local v2 = v1[path]
	if not v2 then
		return
	end
	local v3 = nil
	if typeof(v2) == "function" then
		v3 = v2()
	elseif typeof(v2) == "table" then
		v3 = v2
	end
	if not v3 then
		return
	end
	local instance = p1.instance
	local List = instance.Content.Inside.List
	instance.StudsOffset = Vector3.new(6, -1.5, 0)
	local v6 = math.max(#v3.Dialogue / 2, 1)
	instance.Size = UDim2.new(v6 * 5 + 2.4, 0, v6 * 2.2 + 1.2, 0)
	List.UIGridLayout.CellSize = UDim2.fromScale(1, (math.min(1 / #v3.Dialogue, 0.5)))
	local function renderDialogue(p12, p2) --[[ renderDialogue | Line: 607 | Upvalues: p1 (copy), Option (ref), GuiControl (ref), path (copy), List (copy) ]]
		local v1 = tostring(p12)
		local v2 = p1.optionCleaner:Clone(Option)
		v2.Name = v1
		v2.Items.QuestLabel.Text = p2.Reply
		GuiControl:Hook("Hold Button", v2, v2.Items, 1, p1.optionCleaner).Clicked:Connect(function() --[[ Line: 614 | Upvalues: v2 (copy), p1 (ref), p12 (copy), p2 (copy), path (ref) ]]
			v2.Active = false
			if p1.selecting == p12 then
				p1:confirmSelection(path, p12, p2)
				v2.Active = true
				return
			end
			p1:select(p12, p2)
			p1:confirmSelection(path, p12, p2)
			v2.Active = true
		end)
		p1.optionCleaner:Add(v2.MouseEnter:Connect(function() --[[ Line: 626 | Upvalues: p1 (ref), p12 (copy), p2 (copy) ]]
			p1:select(p12, p2)
		end))
		v2.Parent = List
	end
	for v9, v10 in v3.Dialogue do
		renderDialogue(v9, v10)
	end
	table.clear({})
end
function t2.next(p1, p2) --[[ next | Line: 641 | Upvalues: DialogueTree (copy) ]]
	p1._pathSeq = p1._pathSeq + 1
	local v1 = DialogueTree[p1.name]
	if not v1 then
		return
	end
	local v2 = v1[p1.path]
	if not v2 then
		return
	end
	local v3 = nil
	if typeof(v2) == "function" then
		v3 = v2()
	elseif typeof(v2) == "table" then
		v3 = v2
	end
	if not v3 then
		return
	end
	if p1.animating then
		return
	end
	p1.animating = true
	local List = p1.instance.Content.Inside.List
	for v5, v6 in v3.Dialogue do
		local v7 = List:FindFirstChild((tostring(v5)))
		if v7 then
			v7:Destroy()
		end
	end
	p1.path = p2
	p1:populate()
	p1.animating = false
	p1.selectionMade = false
end
function t2.stop(p1, p2) --[[ stop | Line: 691 ]]
	if p1.animating then
		return
	end
	p1.animating = true
	if p1.restoreCutscene then
		p1:restoreCutscene()
	end
	if p2 == nil then
		p1.waitSignal:Fire(false)
	else
		p1.waitSignal:Fire(p2)
	end
	p1:destroy()
end
function t2.restoreCutscene(p1) --[[ restoreCutscene | Line: 725 | Upvalues: Quest (copy), TweenService (copy) ]]
	if p1._cutsceneRestored then
		return
	end
	p1._cutsceneRestored = true
	if p1._restoreCamera then
		p1._restoreCamera()
		p1._restoreCamera = nil
	end
	if p1._unlockMovement then
		p1._unlockMovement()
		p1._unlockMovement = nil
	end
	Quest.Enabled = true
	if p1.overheadTag then
		TweenService:Create(p1.overheadTag, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = p1.overheadTagSize
		}):Play()
	end
	local v1 = p1.basePart and p1.basePart:FindFirstChild((("Tracker - %*"):format(p1.name)))
	if not v1 then
		return
	end
	for v2, v3 in v1:GetChildren() do
		if v3:IsA("GuiObject") then
			v3.Visible = true
		end
	end
end
function t2.endCutsceneAfterSpeech(p1, p2) --[[ endCutsceneAfterSpeech | Line: 762 | Upvalues: TweenService (copy) ]]
	task.spawn(function() --[[ Line: 763 | Upvalues: p1 (copy), p2 (copy), TweenService (ref) ]]
		while p1._typing and p1._speechSeq == p2 do
			task.wait()
		end
		if p1._speechSeq ~= p2 then
			return
		end
		task.wait(2)
		if p1._speechSeq ~= p2 then
			return
		end
		local _speechGui = p1._speechGui
		local _speechText = p1._speechText
		if not (_speechGui and _speechText) then
			return
		end
		local Main = _speechGui:FindFirstChild("Main")
		local v1 = if Main then Main:FindFirstChild("Background") else Main
		if v1 then
			TweenService:Create(v1, TweenInfo.new(0.15), {
				BackgroundTransparency = 1
			}):Play()
		end
		TweenService:Create(_speechText, TweenInfo.new(0.15), {
			TextTransparency = 1
		}):Play()
		local UIStroke = _speechText:FindFirstChildOfClass("UIStroke")
		if UIStroke then
			TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Transparency = 1
			}):Play()
		end
		task.wait(0.2)
	end)
end
function t2.wait(p1) --[[ wait | Line: 808 ]]
	return p1.waitSignal:Wait()
end
function t2.onDestroyed(p1, p2) --[[ onDestroyed | Line: 812 ]]
	p1.cleaner:Add(p2)
end
function t2.destroy(p1) --[[ destroy | Line: 816 ]]
	if p1.dead then
		return
	end
	p1.dead = true
	p1.cleaner:Destroy()
	p1.waitSignal:DisconnectAll()
	p1.waitSignal:Destroy()
	p1.basePart = nil
	p1.instance = nil
	if p1._speechSeq ~= 0 or not p1._speechGui then
		return
	end
	p1._speechGui:Destroy()
	p1._speechGui = nil
	p1._speechText = nil
	p1._speechTextSize = nil
end
return t2