-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("StarterPlayer")
game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
LocalPlayer:WaitForChild("PlayerScripts")
local Loader = require(ReplicatedStorage.Packages.Loader)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local VFXUtility = require(ReplicatedStorage.Shared.VFXUtility)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
local v1 = Loader.LoadChildren(script:WaitForChild("UpdateStyles"))
local t = {}
function t.New(p1) --[[ New | Line: 29 | Upvalues: t (copy), Trove (copy), Signal (copy) ]]
	t.Cleaning = false
	t.Cleaner = Trove.new()
	t.Alpha = 0
	t.Instance = nil
	t.Updates = {}
	t.Values = {}
	t.Queue = {}
	t.QueueIndex = -1
	t.QueueChanged = Signal.new()
	t.Ended = Signal.new()
	task.spawn(function() --[[ Line: 49 | Upvalues: t (ref) ]]
		while true do
			while true do
				task.wait()
				if not (#t.Queue > 1) then
					break
				end
				print("Activate visuals now!")
				task.defer(function() --[[ Line: 55 | Upvalues: t (ref) ]]
					t:Changed()
				end)
				t.Ended:Wait()
			end
			t.QueueChanged:Wait()
			print("== == == Queue changed here == == ==")
		end
	end)
end
function t.Changed(p1) --[[ Changed | Line: 68 | Upvalues: t (copy) ]]
	local v1 = t.Queue[1]
	if v1 then
		t:Give(v1.ItemType, v1.ItemIdentifier, v1.BoardStyle, v1.Style, v1.VFXName, v1.HideCraftOption)
		warn("STARTED RENDERING HERE")
	else
		warn("NOTHING WAS IN QUEUE!")
	end
end
function t.GetVolume(p1, p2) --[[ GetVolume | Line: 87 | Upvalues: t (copy) ]]
	local _, v1 = t:GetBoundingBox(p2)
	if v1 then
		return v1.X * v1.Y * v1.Z
	else
		return 1
	end
end
function t.GetBoundingBox(p1, p2) --[[ GetBoundingBox | Line: 98 ]]
	if p2:IsA("Model") then
		return p2:GetBoundingBox()
	end
	if p2:IsA("BasePart") then
		return p2.CFrame, p2.Size
	else
		return CFrame.identity, Vector3.new(0, 0, 0)
	end
end
function t.FitToFrame(p1, p2, p3) --[[ FitToFrame | Line: 112 | Upvalues: t (copy), CurrentCamera (copy) ]]
	local v1, v2 = t:GetBoundingBox(p2)
	if not (v1 and v2) then
		return 1
	end
	if p3 then
		v1 = p3
	end
	local v3 = (v1 - v1.Position):Inverse() * v2
	local v7 = Vector3.new(math.abs(v3.X), math.abs(v3.Y), (math.abs(v3.Z)))
	local v8 = math.max(v7.X, v7.Y, v7.Z)
	local v11 = math.tan((math.rad(CurrentCamera.FieldOfView / 2)))
	return v8 / 2 / v11 + (if v8 == v7.X then math.sqrt(v7.Y * v7.Y + v7.Z * v7.Z) / 2 elseif v8 == v7.Y then math.sqrt(v7.X * v7.X + v7.Z * v7.Z) / 2 else math.sqrt(v7.X * v7.X + v7.Y * v7.Y) / 2)
end
function t.ScreenToWorld(p1, p2, p3) --[[ ScreenToWorld | Line: 146 | Upvalues: CurrentCamera (copy) ]]
	local ViewportSize = CurrentCamera.ViewportSize
	local v3 = math.tan(math.rad(CurrentCamera.FieldOfView) * 0.5)
	return CurrentCamera.CFrame * CFrame.new((p2.X / ViewportSize.X * 2 - 1) * -(ViewportSize.X / ViewportSize.Y * v3) * p3, (p2.Y / ViewportSize.Y * 2 - 1) * v3 * p3, p3):Inverse()
end
function t._reconcile(p1, p2) --[[ _reconcile | Line: 168 | Upvalues: CurrentCamera (copy), GuiService (copy), t (copy) ]]
	local ViewportSize = CurrentCamera.ViewportSize
	GuiService:GetGuiInset()
	local v1 = t
	v1._alpha = v1._alpha + p2
	t._boardPosition = ViewportSize * 0.5
	local v2 = Vector2.new(ViewportSize.X * 0.38, ViewportSize.Y * 0.515)
	t._instancePosition = v2
	t._vfxPosition = v2
end
function t._update(p1, p2) --[[ _update | Line: 184 | Upvalues: t (copy), CurrentCamera (copy) ]]
	local Board = t.Board
	if Board then
		local v2 = t:ScreenToWorld(t._boardPosition, workspace:GetAttribute("StudioBoardDistance") or 5)
		t:FitToFrame(Board, v2)
		Board.CFrame = v2
	end
	local v3 = t.Instance
	if v3 then
		local v4 = t:ScreenToWorld(t._instancePosition, 3.25)
		t:FitToFrame(v3, v4)
		local v6 = v4 * CFrame.fromOrientation(0, math.rad((math.sin(t._alpha) + 0.5) * 15), 0)
		local v7, _, v8 = CurrentCamera.CFrame:ToOrientation()
		local v9 = v6 * CFrame.Angles(math.rad(v7), 1.5707963267948966, (math.rad(v8)))
		if v3:IsA("Model") then
			v3:PivotTo(v9)
		else
			v3.CFrame = v9
		end
	end
	if not (t.VFX and t.VFX.Container) then
		return
	end
	local v10 = t:ScreenToWorld(t._vfxPosition, 5.5)
	t:FitToFrame(t.VFX.Container, v10)
	t.VFX.Container.CFrame = v10
end
function t._createBoard(p1, p2, p3) --[[ _createBoard | Line: 222 | Upvalues: t (copy), CurrentCamera (copy), PlayerGui (copy) ]]
	local v1 = script.Boards[p2]:Clone()
	local v2 = script.Styles[p3]:Clone()
	t.Board = v1
	t.Board.Parent = CurrentCamera
	t.Style = v2
	t.Style.Adornee = t.Board
	t.Style.Parent = PlayerGui
end
function t.AddStyle(p1, p2, p3, p4) --[[ AddStyle | Line: 237 | Upvalues: v1 (copy), t (copy) ]]
	local v12 = v1[p2]
	if not v12 then
		return
	end
	v12(t.Style, p3, p4, function() --[[ Line: 244 | Upvalues: t (ref) ]]
		t:Cancel()
	end, t)
end
function t.Give(p1, p2, p3, p4, p5, p6, p7) --[[ Give | Line: 250 | Upvalues: ModelDownloader (copy), ItemUtility (copy), TierUtility (copy), t (copy), Lighting (copy), RunService (copy) ]]
	local v1 = ModelDownloader:Wait(p2, p3)
	if not v1 then
		error((("Unable to fetch model for %* %*"):format(p2, p3)))
	end
	local v2 = ItemUtility.GetItemDataFromItemType(p2, p3)
	local v3 = ItemUtility.GetItemDataFromItemType(p2, p3) and TierUtility:GetTier(v2.Data.Tier) or TierUtility:GetTierFromRarity(1)
	t._alpha = 0
	t.Instance = CreateInstance(v1)
	t.VFX = RenderVFX(p6, 0.3, v3.TierColor)
	t.Blur = script.DepthOfField:Clone()
	t.Blur.Parent = Lighting
	t:_createBoard(p4, p5)
	t:AddStyle(p5, p2, p3)
	RunService:BindToRenderStep("Projection", Enum.RenderPriority.Camera.Value + 1, function(p1) --[[ Line: 277 | Upvalues: t (ref) ]]
		t:_reconcile(p1)
		t:_update(p1)
	end)
end
function t.Cancel(p1) --[[ Cancel | Line: 283 | Upvalues: t (copy), RunService (copy) ]]
	if not t.Cleaning then
		t.Cleaning = true
		RunService:UnbindFromRenderStep("Projection")
		t.Cleaner:Clean()
		pcall(function() --[[ Line: 293 | Upvalues: t (ref) ]]
			if not t.VFX then
				return
			end
			for i, v in ipairs(t.VFX.ParticleEmitters) do
				v.Enabled = false
			end
			t.VFX.Container:Destroy()
			t.VFX.Container = nil
		end)
		pcall(function() --[[ Line: 304 | Upvalues: t (ref) ]]
			t.Style:Destroy()
			t.Board:Destroy()
			t.Instance:Destroy()
			t.Blur:Destroy()
		end)
		t.Cleaning = false
		t:Unlock()
		t.Ended:Fire()
	end
end
function t.Add(p1, p2, p3, p4, p5, p6, p7) --[[ Add | Line: 317 | Upvalues: t (copy) ]]
	if not t.Locked then
		t:Give(p2, p3, p4, p5, p6, p7)
		return
	end
	error("Cannot add during lock!")
end
function t.Lock(p1) --[[ Lock | Line: 351 | Upvalues: t (copy) ]]
	t.Locked = true
end
function t.Unlock(p1) --[[ Unlock | Line: 355 | Upvalues: t (copy) ]]
	t.Unlocked = false
end
function CreateInstance(p1) --[[ CreateInstance | Line: 359 | Upvalues: CurrentCamera (copy) ]]
	local v1 = p1:Clone()
	if v1:IsA("BasePart") then
		v1.Anchored = true
		v1.Parent = CurrentCamera
		return v1
	end
end
function RenderVFX(p1, p2, p3) --[[ RenderVFX | Line: 392 | Upvalues: VFXUtility (copy), CurrentCamera (copy) ]]
	local v1 = if p1 then VFXUtility:CreateContainer(p1) else p1
	if not v1 then
		return
	end
	local Container = v1.Container
	for i, v in ipairs(v1.ParticleEmitters) do
		if p3 then
			v.Color = p3
		end
		v.Enabled = true
	end
	if p2 then
		local Model = Instance.new("Model")
		Container.Parent = Model
		Model:ScaleTo(p2)
		Container.Parent = CurrentCamera
		Model:Destroy()
	else
		v1.Container.Parent = CurrentCamera
	end
	v1.Container.CFrame = CFrame.new(0, 0, 5000)
	return v1
end
return t