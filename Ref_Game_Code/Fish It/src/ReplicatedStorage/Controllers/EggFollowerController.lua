-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local LocalPlayer = Players.LocalPlayer
local t = {}
local t2 = {}
local t3 = {}
local v1 = Random.new()
local function getEggAssetAttributeName(p1) --[[ getEggAssetAttributeName | Line: 76 ]]
	return ("IncubatingEggAsset%*"):format(p1)
end
local function getEggHatchAtAttributeName(p1) --[[ getEggHatchAtAttributeName | Line: 80 ]]
	return ("IncubatingEggHatchAt%*"):format(p1)
end
local function getEggFolder() --[[ getEggFolder | Line: 84 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	if not Assets then
		return nil
	end
	local Eggs = Assets:FindFirstChild("Eggs")
	if Eggs and Eggs:IsA("Folder") then
		return Eggs
	else
		return nil
	end
end
local function getEggTemplate(p1) --[[ getEggTemplate | Line: 98 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1
	if Assets then
		local Eggs = Assets:FindFirstChild("Eggs")
		v1 = if Eggs and Eggs:IsA("Folder") then Eggs else nil
	else
		v1 = nil
	end
	if not v1 then
		return nil
	end
	if typeof(p1) == "string" and p1 ~= "" then
		local v2 = v1:FindFirstChild(p1)
		if v2 and v2:IsA("Model") then
			return v2
		end
	end
	local Egg = v1:FindFirstChild("Egg")
	if Egg and Egg:IsA("Model") then
		return Egg
	else
		return v1:FindFirstChildWhichIsA("Model")
	end
end
local function getEggTimerTemplate() --[[ getEggTimerTemplate | Line: 119 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	if not Assets then
		return nil
	end
	local EggTimer = Assets:FindFirstChild("EggTimer")
	if EggTimer and EggTimer:IsA("BillboardGui") then
		return EggTimer
	else
		return nil
	end
end
local function getOriginalTransparency(p1) --[[ getOriginalTransparency | Line: 133 ]]
	local v1 = p1:GetAttribute("EggHuntOriginalTransparency")
	if typeof(v1) == "number" then
		return v1
	else
		p1:SetAttribute("EggHuntOriginalTransparency", p1.Transparency)
		return p1.Transparency
	end
end
local function prepareEggModel(p1) --[[ prepareEggModel | Line: 143 | Upvalues: Workspace (copy) ]]
	local v1 = p1:GetDescendants()
	if p1:IsA("BasePart") then
		table.insert(v1, p1)
	end
	for i, v in ipairs(v1) do
		local v2
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			v.Massless = true
			local v3 = v:GetAttribute("EggHuntOriginalTransparency")
			if typeof(v3) == "number" then
				v2 = v3
			else
				v:SetAttribute("EggHuntOriginalTransparency", v.Transparency)
				v2 = v.Transparency
			end
			v.Transparency = v2
			continue
		end
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
			continue
		end
		if v:IsA("ProximityPrompt") then
			v:Destroy()
			continue
		end
		if v:IsA("Sound") then
			v.Playing = false
		end
	end
	local _, v4 = p1:GetBoundingBox()
	p1.Parent = Workspace
	return v4.Y * 0.5
end
local function getGroundPosition(p1, p2, p3) --[[ getGroundPosition | Line: 173 | Upvalues: Workspace (copy) ]]
	local v1 = Workspace:Raycast(p1 + Vector3.new(0, 10, 0), Vector3.new(0, -1000, 0), p3)
	return Vector3.new(p1.X, (if v1 then v1.Position.Y else p1.Y) + p2, p1.Z)
end
local function quadraticBezier(p1, p2, p3, p4) --[[ quadraticBezier | Line: 181 ]]
	local v1 = 1 - p4
	return v1 * v1 * p1 + v1 * 2 * p4 * p2 + p4 * p4 * p3
end
local function quadraticBezierTangent(p1, p2, p3, p4) --[[ quadraticBezierTangent | Line: 186 ]]
	return (1 - p4) * 2 * (p2 - p1) + p4 * 2 * (p3 - p2)
end
local function formatDuration(p1) --[[ formatDuration | Line: 191 ]]
	local v2 = math.max(0, (math.floor(p1)))
	local v3 = math.floor(v2 / 3600)
	local v4 = math.floor(v2 % 3600 / 60)
	local v5 = v2 % 60
	if v3 > 0 then
		if v4 > 0 then
			return ("%*h %*m"):format(v3, v4)
		else
			return ("%*h"):format(v3)
		end
	else
		if not (v4 > 0) then
			return ("%*s"):format(v5)
		end
		if v5 > 0 then
			return ("%*m %*s"):format(v4, v5)
		else
			return ("%*m"):format(v4)
		end
	end
end
local function getModelPrimaryPart(p1) --[[ getModelPrimaryPart | Line: 216 ]]
	if p1.PrimaryPart then
		return p1.PrimaryPart
	end
	local v1 = p1:FindFirstChildWhichIsA("BasePart", true)
	if v1 then
		p1.PrimaryPart = v1
	end
	return v1
end
local function createEggTimerGui(p1, p2) --[[ createEggTimerGui | Line: 229 | Upvalues: ReplicatedStorage (copy) ]]
	if not p1:IsA("Model") then
		return nil
	end
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	local v1
	if Assets then
		local EggTimer = Assets:FindFirstChild("EggTimer")
		v1 = if EggTimer and EggTimer:IsA("BillboardGui") then EggTimer else nil
	else
		v1 = nil
	end
	if not v1 then
		return nil
	end
	local v2
	if p1.PrimaryPart then
		v2 = p1.PrimaryPart
	else
		local v3 = p1:FindFirstChildWhichIsA("BasePart", true)
		if v3 then
			p1.PrimaryPart = v3
		end
		v2 = v3
	end
	if not v2 then
		return nil
	end
	local v4 = v1:Clone()
	v4.Parent = p1
	v4.Adornee = v2
	local Frame = v4:FindFirstChild("Frame")
	if not (Frame and Frame:IsA("Frame")) then
		return v4
	end
	local ItemName = Frame:FindFirstChild("ItemName")
	if not (ItemName and ItemName:IsA("TextLabel")) then
		return v4
	end
	ItemName.Text = p2
	return v4
end
local function updateEggTimerGui(p1, p2, p3) --[[ updateEggTimerGui | Line: 259 | Upvalues: formatDuration (copy) ]]
	if not p1 then
		return
	end
	local Frame = p1:FindFirstChild("Frame")
	if not Frame then
		return
	end
	local ItemName = Frame:FindFirstChild("ItemName")
	if ItemName then
		ItemName.Text = p2
	end
	local Timer = Frame:FindFirstChild("Timer")
	if not Timer then
		return
	end
	Timer.Text = formatDuration((math.max(p3 - os.time(), 0)))
end
local function setEggHiddenState(p1, p2) --[[ setEggHiddenState | Line: 280 ]]
	if p1.Hidden == p2 then
		return
	end
	p1.Hidden = p2
	if p1.TimerGui then
		p1.TimerGui.Enabled = not p2
	end
	local v1 = p1.PVInstance:GetDescendants()
	if p1.PVInstance:IsA("BasePart") then
		table.insert(v1, p1.PVInstance)
	end
	for i, v in ipairs(v1) do
		local v2
		if v:IsA("BasePart") then
			if p2 then
				v2 = 1
			else
				local v3 = v:GetAttribute("EggHuntOriginalTransparency")
				if typeof(v3) == "number" then
					v2 = v3
				else
					v:SetAttribute("EggHuntOriginalTransparency", v.Transparency)
					v2 = v.Transparency
				end
			end
			v.Transparency = v2
		end
	end
end
local function shouldHideEggs(p1) --[[ shouldHideEggs | Line: 303 ]]
	local SeatPart = p1.SeatPart
	if not SeatPart then
		return false
	end
	return SeatPart:IsA("VehicleSeat") or SeatPart.Name == "DriverSeat"
end
local function playHatchEffect(p1) --[[ playHatchEffect | Line: 312 | Upvalues: t3 (copy), v1 (copy) ]]
	if not p1.PVInstance:IsA("Model") then
		p1.PVInstance:Destroy()
		return
	end
	local t = {
		Elapsed = 0,
		Model = p1.PVInstance,
		Pivot = p1.PVInstance:GetPivot()
	}
	t.SpinDirection = if v1:NextNumber() >= 0.5 then 1 else -1
	t3[#t3 + 1] = t
end
local function updateHatchEffects(p1) --[[ updateHatchEffects | Line: 326 | Upvalues: t3 (copy), Workspace (copy), ParticleEmitter (copy), Soundbook (copy) ]]
	for i = #t3, 1, -1 do
		local v1 = t3[i]
		local Model = v1.Model
		if Model:IsDescendantOf(Workspace) then
			v1.Elapsed = v1.Elapsed + p1
			local v3 = math.min(v1.Elapsed / 0.35, 1)
			Model:ScaleTo(if v3 <= 0.3 then v3 / 0.3 * -0.55 + 1 else (v3 - 0.3) / 0.7 * 1.95 + 0.45)
			local v5 = math.clamp((v3 - 0.3) / 0.7, 0, 1)
			for i2, v in ipairs(Model:GetDescendants()) do
				local v6
				if v:IsA("BasePart") then
					local v7 = v:GetAttribute("EggHuntOriginalTransparency")
					if typeof(v7) == "number" then
						v6 = v7
					else
						v:SetAttribute("EggHuntOriginalTransparency", v.Transparency)
						v6 = v.Transparency
					end
					v.Transparency = math.clamp(v6 + v5, 0, 1)
				end
			end
			Model:PivotTo(v1.Pivot * CFrame.Angles(0, v1.SpinDirection * v3 * math.pi * 2.5, 0))
			if v3 >= 1 then
				ParticleEmitter.emitParticlesAt("EggExploding", v1.Pivot.Position, Workspace)
				Soundbook:RenderAt("EggIncubated", v1.Pivot.Position)
				Model:Destroy()
				table.remove(t3, i)
			end
			continue
		end
		table.remove(t3, i)
	end
end
local function beginJump(p1, p2, p3) --[[ beginJump | Line: 366 | Upvalues: Workspace (copy) ]]
	local v3 = Vector3.new(p2.X - p1.Position.X, 0, p2.Z - p1.Position.Z)
	local Magnitude = v3.Magnitude
	if Magnitude <= 0.08 then
		return
	end
	local v4 = math.clamp(Magnitude / 28, 0, 1)
	local v5 = p1.MoveSpeed * (v4 * 1.75 + 1)
	local v6 = (v4 * 1.1 + 1) * 1.55
	local Unit = v3.Unit
	local v7 = math.min(Magnitude, v6)
	local v10 = p1.Position + Vector3.new(Unit.X * v7, 0, Unit.Z * v7)
	local v11 = Workspace:Raycast(v10 + Vector3.new(0, 10, 0), Vector3.new(0, -1000, 0), p3)
	local v13 = Vector3.new(v10.X, (if v11 then v11.Position.Y else v10.Y) + p1.HalfHeight, v10.Z)
	local v14 = (p1.Position + v13) * 0.5
	local v15 = math.clamp(v7 / v6, 0.6, 1) * 1
	p1.JumpAlpha = 0
	p1.JumpDuration = math.max(v7 / v5, 0.08)
	p1.JumpStart = p1.Position
	p1.JumpControl = v14 + Vector3.new(0, v15, 0)
	p1.JumpGoal = v13
end
local function teleportEggToPosition(p1, p2, p3) --[[ teleportEggToPosition | Line: 390 ]]
	p1.Position = p2
	p1.JumpAlpha = 1
	p1.JumpDuration = 0
	p1.JumpStart = p2
	p1.JumpControl = p2
	p1.JumpGoal = p2
	if not (p3.Magnitude > 0.001) then
		return
	end
	p1.Forward = p3.Unit
end
local function getCharacterRootPart(p1) --[[ getCharacterRootPart | Line: 403 ]]
	local Character = p1.Character
	if not Character then
		return nil
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		return HumanoidRootPart
	else
		return nil
	end
end
local function getCharacterHumanoid(p1) --[[ getCharacterHumanoid | Line: 417 ]]
	local Character = p1.Character
	if not Character then
		return nil
	end
	local Humanoid = Character:FindFirstChild("Humanoid")
	if Humanoid and Humanoid:IsA("Humanoid") then
		return Humanoid
	else
		return nil
	end
end
local function getEggCount(p1) --[[ getEggCount | Line: 431 ]]
	local v1 = p1:GetAttribute("IncubatingEggCount")
	if typeof(v1) == "number" then
		return math.max(0, (math.floor(v1)))
	else
		return 0
	end
end
local function getActiveEggAssetNames(p1) --[[ getActiveEggAssetNames | Line: 440 ]]
	local v1 = p1:GetAttribute("IncubatingEggCount")
	local v2 = if typeof(v1) == "number" then math.max(0, (math.floor(v1))) else 0
	if v2 <= 0 then
		return {}
	end
	local v5 = table.create(v2)
	for i = 1, 8 do
		local v6 = p1:GetAttribute((("IncubatingEggAsset%*"):format(i)))
		if typeof(v6) == "string" and v6 ~= "" then
			v5[#v5 + 1] = v6
		end
	end
	while #v5 < v2 do
		v5[#v5 + 1] = "Egg"
	end
	while v2 < #v5 do
		v5[#v5] = nil
	end
	return v5
end
function t.Unrender(p1, p2) --[[ Unrender | Line: 465 | Upvalues: t2 (copy) ]]
	local v1 = t2[p2.UserId]
	if not v1 then
		return
	end
	for i, v in ipairs(v1.Eggs) do
		v.PVInstance:Destroy()
	end
	t2[p2.UserId] = nil
end
local function getFormationVectors(p1) --[[ getFormationVectors | Line: 478 ]]
	local v1 = p1.CFrame
	local v2 = Vector3.new(v1.LookVector.X, 0, v1.LookVector.Z)
	local v3 = if v2.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v2.Unit
	local v4 = Vector3.new(v1.RightVector.X, 0, v1.RightVector.Z)
	if v4.Magnitude <= 0.001 then
		return v3, Vector3.new(1, 0, 0)
	else
		return v3, v4.Unit
	end
end
local function getTargetSlotPosition(p1, p2, p3) --[[ getTargetSlotPosition | Line: 497 ]]
	local v1 = p1.CFrame
	local v2 = Vector3.new(v1.LookVector.X, 0, v1.LookVector.Z)
	local v3 = if v2.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v2.Unit
	local v4 = Vector3.new(v1.RightVector.X, 0, v1.RightVector.Z)
	local v5 = if v4.Magnitude <= 0.001 then Vector3.new(1, 0, 0) else v4.Unit
	local v6 = if p3 <= 4 then p3 else math.ceil(p3 * 0.5)
	local v7 = math.max(p3 - v6, 0)
	local v8, v9, v10
	if v6 < p2 then
		v8 = v7
		v9 = p2 - v6
		v10 = 1
	else
		v8 = v6
		v9 = p2
		v10 = 0
	end
	return p1.Position - v3 * (v10 * 2 + 2.75) + v5 * ((v9 - (v8 + 1) * 0.5) * 2)
end
local function createRenderEgg(p1, p2, p3, p4, p5, p6) --[[ createRenderEgg | Line: 519 | Upvalues: prepareEggModel (copy), getTargetSlotPosition (copy), Workspace (copy), LocalPlayer (copy), createEggTimerGui (copy), updateEggTimerGui (copy), v1 (copy) ]]
	local v12 = p2:Clone()
	local v2 = prepareEggModel(v12)
	local v3 = RaycastParams.new()
	v3.FilterType = Enum.RaycastFilterType.Exclude
	v3.FilterDescendantsInstances = { p3.Parent, v12 }
	v3.IgnoreWater = true
	local v4 = getTargetSlotPosition(p3, p4, p5)
	local v5 = Workspace:Raycast(v4 + Vector3.new(0, 10, 0), Vector3.new(0, -1000, 0), v3)
	local v7 = Vector3.new(v4.X, (if v5 then v5.Position.Y else v4.Y) + v2, v4.Z)
	local v8 = p3.CFrame
	local v9 = Vector3.new(v8.LookVector.X, 0, v8.LookVector.Z)
	local v10 = if v9.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v9.Unit
	local v11 = Vector3.new(v8.RightVector.X, 0, v8.RightVector.Z)
	local v122, _
	if v11.Magnitude <= 0.001 then
		v122 = v7
		_ = Vector3.new(1, 0, 0)
	else
		_ = v11.Unit
		v122 = v7
	end
	local v13 = if p1 == LocalPlayer then createEggTimerGui(v12, p2.Name) else nil
	updateEggTimerGui(v13, p2.Name, p6)
	return {
		Hidden = false,
		JumpAlpha = 1,
		JumpDuration = 0,
		AssetName = p2.Name,
		HalfHeight = v2,
		MoveSpeed = v1:NextNumber(9.5, 14),
		PVInstance = v12,
		TimerGui = v13,
		Position = v122,
		Forward = v10,
		HatchAt = p6,
		JumpStart = v122,
		JumpControl = v122,
		JumpGoal = v122
	}
end
local function getActiveEggHatchAts(p1) --[[ getActiveEggHatchAts | Line: 551 ]]
	local v1 = p1:GetAttribute("IncubatingEggCount")
	local v2 = if typeof(v1) == "number" then math.max(0, (math.floor(v1))) else 0
	if v2 <= 0 then
		return {}
	end
	local v5 = table.create(v2)
	for i = 1, 8 do
		local v6 = p1:GetAttribute((("IncubatingEggHatchAt%*"):format(i)))
		if typeof(v6) == "number" and v6 > 0 then
			v5[#v5 + 1] = v6
		end
	end
	while #v5 < v2 do
		v5[#v5 + 1] = 0
	end
	while v2 < #v5 do
		v5[#v5] = nil
	end
	return v5
end
local function refreshWhenCharacterReady(p1, p2) --[[ refreshWhenCharacterReady | Line: 576 | Upvalues: t (copy) ]]
	task.defer(function() --[[ Line: 577 | Upvalues: p2 (copy), p1 (copy), t (ref) ]]
		local v1_2 = p2:FindFirstChild("HumanoidRootPart") or p2:WaitForChild("HumanoidRootPart", 5)
		local v2_2 = p2:FindFirstChild("Humanoid") or p2:WaitForChild("Humanoid", 5)
		if p1.Character ~= p2 then
			return
		end
		if not (v1_2 and v2_2) then
			return
		end
		t:Render(p1)
	end)
end
function t._syncEggs(p1, p2, p3, p4) --[[ _syncEggs | Line: 590 | Upvalues: getEggTemplate (copy), updateEggTimerGui (copy), createRenderEgg (copy), playHatchEffect (copy) ]]
	local v1 = #p3
	for i, v in ipairs(p3) do
		local v2 = getEggTemplate(v)
		local v3 = p2.Eggs[i]
		local v4 = p4[i] or 0
		if v2 then
			if v3 and v3.AssetName == v2.Name then
				v3.HatchAt = v4
				updateEggTimerGui(v3.TimerGui, v2.Name, v4)
				continue
			end
			if v3 then
				v3.PVInstance:Destroy()
			end
			p2.Eggs[i] = createRenderEgg(p2.Player, v2, p2.RootPart, i, v1, v4)
			continue
		end
		if v3 then
			v3.PVInstance:Destroy()
			p2.Eggs[i] = nil
		end
	end
	for i = #p2.Eggs, #p3 + 1, -1 do
		local v5 = p2.Eggs[i]
		if v5 then
			playHatchEffect(v5)
			p2.Eggs[i] = nil
		end
	end
end
function t.Render(p1, p2) --[[ Render | Line: 627 | Upvalues: getActiveEggAssetNames (copy), getActiveEggHatchAts (copy), t2 (copy), getEggTemplate (copy), createRenderEgg (copy) ]]
	local Character = p2.Character
	local v1
	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		v1 = if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
	else
		v1 = nil
	end
	if not v1 then
		p1:Unrender(p2)
		return
	end
	local Character_2 = p2.Character
	local v2
	if Character_2 then
		local Humanoid = Character_2:FindFirstChild("Humanoid")
		v2 = if Humanoid and Humanoid:IsA("Humanoid") then Humanoid else nil
	else
		v2 = nil
	end
	if not v2 then
		p1:Unrender(p2)
		return
	end
	local v3 = getActiveEggAssetNames(p2)
	local v4 = getActiveEggHatchAts(p2)
	if #v3 <= 0 then
		p1:Unrender(p2)
		return
	end
	local v5 = t2[p2.UserId]
	if v5 then
		v5.Player = p2
		v5.Humanoid = v2
		v5.RootPart = v1
		p1:_syncEggs(v5, v3, v4)
		return
	end
	local v6 = table.create(#v3)
	for i, v in ipairs(v3) do
		local v7 = getEggTemplate(v)
		if v7 then
			v6[i] = createRenderEgg(p2, v7, v1, i, #v3, v4[i] or 0)
		end
	end
	t2[p2.UserId] = {
		Player = p2,
		Humanoid = v2,
		RootPart = v1,
		Eggs = v6
	}
end
function t.Refresh(p1, p2) --[[ Refresh | Line: 672 | Upvalues: t2 (copy) ]]
	local v1 = p2:GetAttribute("IncubatingEggCount")
	if (if typeof(v1) == "number" then math.max(0, (math.floor(v1))) else 0) > 0 then
		p1:Render(p2)
		return
	end
	if t2[p2.UserId] then
		p1:_syncEggs(t2[p2.UserId], {}, {})
	else
		p1:Unrender(p2)
	end
end
function t.Start(p1) --[[ Start | Line: 682 | Upvalues: Observers (copy), t (copy), RunService (copy), updateHatchEffects (copy), t2 (copy), getActiveEggAssetNames (copy), getActiveEggHatchAts (copy), Workspace (copy), setEggHiddenState (copy), LocalPlayer (copy), updateEggTimerGui (copy), getTargetSlotPosition (copy), beginJump (copy) ]]
	Observers.observePlayer(function(p1) --[[ Line: 683 | Upvalues: t (ref) ]]
		local v1 = table.create(17)
		v1[1] = p1:GetAttributeChangedSignal("IncubatingEggCount"):Connect(function() --[[ Line: 685 | Upvalues: t (ref), p1 (copy) ]]
			t:Refresh(p1)
		end)
		for i = 1, 8 do
			v1[i + 1] = p1:GetAttributeChangedSignal((("IncubatingEggAsset%*"):format(i))):Connect(function() --[[ Line: 689 | Upvalues: t (ref), p1 (copy) ]]
				t:Refresh(p1)
			end)
			v1[i + 8 + 1] = p1:GetAttributeChangedSignal((("IncubatingEggHatchAt%*"):format(i))):Connect(function() --[[ Line: 692 | Upvalues: t (ref), p1 (copy) ]]
				t:Refresh(p1)
			end)
		end
		t:Refresh(p1)
		return function() --[[ Line: 699 | Upvalues: v1 (copy), t (ref), p1 (copy) ]]
			for i, v in ipairs(v1) do
				v:Disconnect()
			end
			t:Unrender(p1)
		end
	end)
	Observers.observeCharacter(function(p1, p2) --[[ Line: 707 | Upvalues: t (ref) ]]
		local v1 = table.create(2)
		v1[1] = p2.ChildAdded:Connect(function(p12) --[[ Line: 709 | Upvalues: p1 (copy), p2 (copy), t (ref) ]]
			if p12.Name ~= "HumanoidRootPart" and p12.Name ~= "Humanoid" then
				return
			end
			local v1 = p1
			local v2 = p2
			task.defer(function() --[[ Line: 577 | Upvalues: v2 (copy), v1 (copy), t (ref) ]]
				local v1_2 = v2:FindFirstChild("HumanoidRootPart") or v2:WaitForChild("HumanoidRootPart", 5)
				local v2_2 = v2:FindFirstChild("Humanoid") or v2:WaitForChild("Humanoid", 5)
				if v1.Character ~= v2 then
					return
				end
				if not (v1_2 and v2_2) then
					return
				end
				t:Render(v1)
			end)
		end)
		v1[2] = p2.AncestryChanged:Connect(function(p12, p2) --[[ Line: 714 | Upvalues: t (ref), p1 (copy) ]]
			if p2 ~= nil then
				return
			end
			t:Unrender(p1)
		end)
		task.defer(function() --[[ Line: 577 | Upvalues: p2 (copy), p1 (copy), t (ref) ]]
			local v1_2 = p2:FindFirstChild("HumanoidRootPart") or p2:WaitForChild("HumanoidRootPart", 5)
			local v2_2 = p2:FindFirstChild("Humanoid") or p2:WaitForChild("Humanoid", 5)
			if p1.Character ~= p2 then
				return
			end
			if not (v1_2 and v2_2) then
				return
			end
			t:Render(p1)
		end)
		return function() --[[ Line: 722 | Upvalues: v1 (copy), t (ref), p1 (copy) ]]
			for i, v in ipairs(v1) do
				v:Disconnect()
			end
			t:Unrender(p1)
		end
	end)
	RunService:BindToRenderStep("EggHuntFollower", Enum.RenderPriority.Camera.Value + 1, function(p1) --[[ Line: 730 | Upvalues: updateHatchEffects (ref), t2 (ref), getActiveEggAssetNames (ref), getActiveEggHatchAts (ref), t (ref), Workspace (ref), setEggHiddenState (ref), LocalPlayer (ref), updateEggTimerGui (ref), getTargetSlotPosition (ref), beginJump (ref) ]]
		updateHatchEffects(p1)
		for k, v in pairs(t2) do
			local v1 = getActiveEggAssetNames(v.Player)
			local v2 = getActiveEggHatchAts(v.Player)
			if #v1 <= 0 then
				t:Unrender(v.Player)
				continue
			end
			if v.RootPart:IsDescendantOf(Workspace) then
				local Humanoid = v.Humanoid
				if Humanoid:IsDescendantOf(Workspace) then
					t:_syncEggs(v, v1, v2)
					local SeatPart = Humanoid.SeatPart
					local v3
					if SeatPart then
						local v4 = SeatPart:IsA("VehicleSeat")
						v3 = if v4 then v4 elseif SeatPart.Name == "DriverSeat" then true else false
					else
						v3 = false
					end
					local v5 = v.RootPart.CFrame
					local v6 = Vector3.new(v5.LookVector.X, 0, v5.LookVector.Z)
					local v7 = if v6.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v6.Unit
					local v8 = Vector3.new(v5.RightVector.X, 0, v5.RightVector.Z)
					local _ = if v8.Magnitude <= 0.001 then Vector3.new(1, 0, 0) else v8.Unit
					local v9 = 1 - math.exp(p1 * -12)
					local v10 = RaycastParams.new()
					v10.FilterType = Enum.RaycastFilterType.Exclude
					local v11 = table.create(#v.Eggs + 1)
					local count = 0
					local Character = v.Player.Character
					if Character then
						count = count + 1
						v11[count] = Character
					end
					local v12 = v7
					for i, v4 in ipairs(v.Eggs) do
						count = count + 1
						v11[count] = v4.PVInstance
					end
					v10.FilterDescendantsInstances = v11
					v10.IgnoreWater = true
					for i, v4 in ipairs(v.Eggs) do
						local v13, v14
						setEggHiddenState(v4, v3)
						if v.Player == LocalPlayer then
							updateEggTimerGui(v4.TimerGui, v4.AssetName, v4.HatchAt)
						end
						local v15 = getTargetSlotPosition(v.RootPart, i, #v.Eggs)
						local v16 = Workspace:Raycast(v15 + Vector3.new(0, 10, 0), Vector3.new(0, -1000, 0), v10)
						local v18 = Vector3.new(v15.X, (if v16 then v16.Position.Y else v15.Y) + v4.HalfHeight, v15.Z)
						local v19 = 0
						local v20 = 0
						local v23 = Vector3.new(v18.X - v4.Position.X, 0, v18.Z - v4.Position.Z)
						if v23.Magnitude >= 100 then
							v4.Position = v18
							v4.JumpAlpha = 1
							v4.JumpDuration = 0
							v4.JumpStart = v18
							v4.JumpControl = v18
							v4.JumpGoal = v18
							if v12.Magnitude > 0.001 then
								v4.Forward = v12.Unit
							end
							v23 = Vector3.new(0, 0, 0)
							v13 = v18
							v14 = v12
						else
							v13 = v18
							v14 = v12
						end
						if v4.JumpAlpha >= 1 and v23.Magnitude > 0.08 then
							beginJump(v4, v13, v10)
						elseif v4.JumpAlpha >= 1 then
							v4.Position = v4.Position:Lerp(v13, 1 - math.exp(p1 * -18))
						end
						if v4.JumpAlpha < 1 then
							v4.JumpAlpha = math.min(1, v4.JumpAlpha + p1 / v4.JumpDuration)
							local JumpAlpha = v4.JumpAlpha
							local v26 = 1 - JumpAlpha
							v4.Position = v26 * v26 * v4.JumpStart + v26 * 2 * JumpAlpha * v4.JumpControl + JumpAlpha * JumpAlpha * v4.JumpGoal
							local JumpControl_2 = v4.JumpControl
							local JumpAlpha_2 = v4.JumpAlpha
							local v27 = (1 - JumpAlpha_2) * 2 * (JumpControl_2 - v4.JumpStart) + JumpAlpha_2 * 2 * (v4.JumpGoal - JumpControl_2)
							local v28 = Vector3.new(v27.X, 0, v27.Z)
							if v28.Magnitude > 0.08 then
								v14 = v28.Unit
							end
							local v30 = math.sin(v4.JumpAlpha * math.pi)
							v19 = v30 * 0.3
							v20 = v30 * 0.04
							if v4.JumpAlpha >= 1 then
								v4.Position = v4.JumpGoal
							end
						else
							local v33 = Vector3.new(v13.X - v4.Position.X, 0, v13.Z - v4.Position.Z)
							if v33.Magnitude > 0.08 then
								v14 = v33.Unit
							end
						end
						local v34 = v4.Forward:Lerp(v14, v9)
						if v34.Magnitude > 0.001 then
							v4.Forward = v34.Unit
						end
						local v35 = CFrame.lookAt(v4.Position, v4.Position + v4.Forward)
						v4.PVInstance:PivotTo(v35 * CFrame.Angles(v19, 0, v20))
					end
					continue
				end
				t:Render(v.Player)
				continue
			end
			t:Refresh(v.Player)
		end
	end)
end
return t