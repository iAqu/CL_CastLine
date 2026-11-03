-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
local CurveUtil = require(ReplicatedStorage.Modules.Util.CurveUtil)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local CosmeticFolder = Workspace:WaitForChild("CosmeticFolder")
local PetName = Assets:WaitForChild("PetName")
local PetFishingStatus = Assets:WaitForChild("PetFishingStatus")
local LocalPlayer = Players.LocalPlayer
local t = {}
local t2 = {}
local t3 = {}
local v1 = setmetatable({}, {
	__mode = "k"
})
local v2 = setmetatable({}, {
	__mode = "k"
})
local t4 = {
	Axolotl = {
		Idle = {
			Id = "rbxassetid://87552481581513",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://97283839257175",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		},
		FishingIdle = {
			Id = "rbxassetid://133012710469903",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		FishCaught = {
			Id = "rbxassetid://98624881808998",
			Looped = false,
			Priority = Enum.AnimationPriority.Action
		},
		FishingStart = {
			Id = "rbxassetid://94626238859788",
			Looped = false,
			Priority = Enum.AnimationPriority.Action4
		}
	},
	Capybara = {
		Idle = {
			Id = "rbxassetid://116139139069297",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://79536041035639",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		},
		FishingIdle = {
			Id = "rbxassetid://75327174500148",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		FishCaught = {
			Id = "rbxassetid://103176932492548",
			Looped = false,
			Priority = Enum.AnimationPriority.Action
		},
		FishingStart = {
			Id = "rbxassetid://119705116050860",
			Looped = false,
			Priority = Enum.AnimationPriority.Action4
		}
	},
	Penguin = {
		Idle = {
			Id = "rbxassetid://113744517667094",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://126250543374968",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		},
		FishingIdle = {
			Id = "rbxassetid://121181316884487",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		FishCaught = {
			Id = "rbxassetid://97273287137380",
			Looped = false,
			Priority = Enum.AnimationPriority.Action
		},
		FishingStart = {
			Id = "rbxassetid://83999568119969",
			Looped = false,
			Priority = Enum.AnimationPriority.Action4
		}
	},
	Otter = {
		Idle = {
			Id = "rbxassetid://71753290334727",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://134675032627343",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		}
	},
	Frog = {
		Idle = {
			Id = "rbxassetid://96244814906283",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://95139908328539",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		}
	},
	Cow = {
		Idle = {
			Id = "rbxassetid://119038130281918",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://126618669493760",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		}
	},
	["Tabby Cat"] = {
		Idle = {
			Id = "rbxassetid://101725467157423",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Walk = {
			Id = "rbxassetid://117554543099998",
			Looped = true,
			Priority = Enum.AnimationPriority.Movement
		}
	}
}
local function hasRenderablePart(p1) --[[ hasRenderablePart | Line: 231 ]]
	return p1:FindFirstChildWhichIsA("BasePart", true) ~= nil
end
local function waitForTemplateReady(p1) --[[ waitForTemplateReady | Line: 235 | Upvalues: v1 (copy), RunService (copy), ContentProvider (copy) ]]
	if v1[p1] then
		return true
	end
	local v12 = os.clock()
	local v2 = os.clock()
	local v3 = -1
	while os.clock() - v12 < 3 do
		if not p1.Parent then
			return false
		end
		local v4 = #p1:GetDescendants()
		if v4 ~= v3 then
			v2, v3 = os.clock(), v4
		end
		local v6 = if p1:FindFirstChildWhichIsA("BasePart", true) == nil then false else true
		if v6 and os.clock() - v2 >= 0.2 then
			break
		end
		RunService.Heartbeat:Wait()
	end
	if p1:FindFirstChildWhichIsA("BasePart", true) ~= nil then
		local v8 = p1:GetDescendants()
		table.insert(v8, p1)
		pcall(function() --[[ Line: 268 | Upvalues: ContentProvider (ref), v8 (copy) ]]
			ContentProvider:PreloadAsync(v8)
		end)
		v1[p1] = true
		return true
	else
		return false
	end
end
local function getPetTemplate(p1) --[[ getPetTemplate | Line: 276 | Upvalues: ModelDownloader (copy), waitForTemplateReady (copy) ]]
	if typeof(p1) ~= "string" or p1 == "" then
		return nil
	end
	local v1 = ModelDownloader:GetModel("Pets", p1, true)
	if not (v1 and v1:IsA("Model")) then
		return nil
	end
	if waitForTemplateReady(v1) then
		return v1
	else
		return nil
	end
end
local function getRootAndHumanoid(p1) --[[ getRootAndHumanoid | Line: 289 ]]
	return p1:FindFirstChild("HumanoidRootPart"), p1:FindFirstChildOfClass("Humanoid")
end
local function getModelHalfHeight(p1) --[[ getModelHalfHeight | Line: 295 ]]
	local _, v1 = p1:GetBoundingBox()
	return math.max(v1.Y * 0.5, 0.5)
end
local function getPivotBottomOffset(p1) --[[ getPivotBottomOffset | Line: 300 ]]
	local v1, v2 = p1:GetBoundingBox()
	local RootPart = p1:FindFirstChild("RootPart")
	local v4 = if RootPart then RootPart.Size.Y else 0
	return math.max(p1:GetPivot().Position.Y - (v1.Position.Y - v2.Y * 0.5) - v4, 0)
end
local function prepareModel(p1) --[[ prepareModel | Line: 308 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			v2.Anchored = true
			v2.CanCollide = false
			v2.CanTouch = false
			v2.CanQuery = false
		end
	end
end
local function getAnimator(p1) --[[ getAnimator | Line: 319 ]]
	local AnimationController = p1:FindFirstChildOfClass("AnimationController")
	if not AnimationController then
		local AnimationController_2 = Instance.new("AnimationController")
		AnimationController_2.Parent = p1
		AnimationController = AnimationController_2
	end
	local Animator = AnimationController:FindFirstChildOfClass("Animator")
	if not Animator then
		local Animator_2 = Instance.new("Animator")
		Animator_2.Parent = AnimationController
		Animator = Animator_2
	end
	return Animator
end
local function loadAnimationTrack(p1, p2) --[[ loadAnimationTrack | Line: 335 ]]
	if not (p1.Animator and p1.Animations) then
		return nil
	end
	local v1 = p1.Animations[p2]
	if not v1 then
		return nil
	end
	local Animation = Instance.new("Animation")
	Animation.AnimationId = v1.Id
	local v2, v3 = pcall(function() --[[ Line: 348 | Upvalues: p1 (copy), Animation (copy) ]]
		return p1.Animator:LoadAnimation(Animation)
	end)
	Animation:Destroy()
	if v2 and v3 then
		v3.Looped = v1.Looped
		v3.Priority = v1.Priority
		p1.Tracks[p2] = v3
		return v3
	else
		return nil
	end
end
local function preloadPetAnimations(p1) --[[ preloadPetAnimations | Line: 363 | Upvalues: ContentProvider (copy), t3 (copy), loadAnimationTrack (copy) ]]
	if not p1.Animations then
		return
	end
	local list = {}
	for v1, v2 in p1.Animations do
		if not p1.Tracks[v1] then
			local Animation = Instance.new("Animation")
			Animation.Name = v1
			Animation.AnimationId = v2.Id
			table.insert(list, Animation)
		end
	end
	if #list > 0 then
		pcall(function() --[[ Line: 381 | Upvalues: ContentProvider (ref), list (copy) ]]
			ContentProvider:PreloadAsync(list)
		end)
	end
	for i, v in ipairs(list) do
		if t3[p1.Player.UserId] == p1 then
			loadAnimationTrack(p1, v.Name)
		end
		v:Destroy()
	end
end
local function getAnimationTrack(p1, p2) --[[ getAnimationTrack | Line: 394 | Upvalues: loadAnimationTrack (copy) ]]
	if not (p1.Animator and p1.Animations) then
		return nil
	end
	local v1 = p1.Tracks[p2]
	if v1 then
		return v1
	else
		return loadAnimationTrack(p1, p2)
	end
end
local function stopOtherAnimations(p1, p2, p3) --[[ stopOtherAnimations | Line: 407 ]]
	for v1, v2 in p1.Tracks do
		if v1 ~= p2 and v2.IsPlaying then
			v2:Stop(p3)
		end
	end
end
local function playPetAnimation(p1, p2, p3) --[[ playPetAnimation | Line: 415 | Upvalues: loadAnimationTrack (copy), stopOtherAnimations (copy) ]]
	if p1.CurrentAnimation == p2 and not p3 then
		return p1.Tracks[p2]
	end
	local v1 = if p1.Animator and p1.Animations then p1.Tracks[p2] or loadAnimationTrack(p1, p2) else nil
	if not v1 then
		return nil
	end
	stopOtherAnimations(p1, p2, 0.15)
	if not v1.IsPlaying or p3 then
		v1:Play(0.15)
	end
	p1.CurrentAnimation = p2
	return v1
end
local function playOneShotAnimation(p1, p2, p3) --[[ playOneShotAnimation | Line: 434 | Upvalues: playPetAnimation (copy) ]]
	local v1 = playPetAnimation(p1, p2, true)
	if not v1 then
		return false
	end
	local v2 = if v1.Length > 0 then v1.Length else p3
	p1.OneShotEndsAt = os.clock() + v2
	return true
end
local function updatePetAnimation(p1, p2, p3) --[[ updatePetAnimation | Line: 445 | Upvalues: playPetAnimation (copy) ]]
	if not p1.Animations then
		return
	end
	if os.clock() < p1.OneShotEndsAt then
		return
	end
	if p3 == "Fishing" and p1.LastState ~= "Fishing" then
		local v1 = playPetAnimation(p1, "FishingStart", true)
		local v2
		if v1 then
			local v3 = if v1.Length > 0 then v1.Length else 1
			p1.OneShotEndsAt = os.clock() + v3
			v2 = true
		else
			v2 = false
		end
		if v2 then
			p1.LastState = p3
			return
		end
	end
	p1.LastState = p3
	if p3 == "Fishing" then
		playPetAnimation(p1, "FishingIdle")
		return
	end
	if p2 then
		playPetAnimation(p1, "Walk")
	else
		playPetAnimation(p1, "Idle")
	end
end
local function makeNameGui(p1, p2, p3) --[[ makeNameGui | Line: 473 | Upvalues: PetName (copy) ]]
	local v1 = p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)
	if not v1 then
		return
	end
	local PetName_2 = p1:FindFirstChild("PetName")
	if PetName_2 then
		PetName_2:Destroy()
	end
	local v2 = PetName:Clone()
	v2.Adornee = v1
	local _, v3 = p1:GetBoundingBox()
	v2.StudsOffsetWorldSpace = Vector3.new(0, math.max(v3.Y * 0.5, 0.5) + 1.2, 0)
	v2.StudsOffset = if p3 == "Fishing" then Vector3.new(0, 2, 0) else Vector3.new(0, 1, 0)
	v2.TextLabel.Text = p2
	v2.Parent = p1
end
local function makeFishingGui(p1) --[[ makeFishingGui | Line: 494 | Upvalues: PetFishingStatus (copy) ]]
	local v1 = p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)
	if not v1 then
		return
	end
	if not p1:FindFirstChild("PetFishingStatus") then
		local v2 = PetFishingStatus:Clone()
		v2.Adornee = v1
		v2.Enabled = false
		local _, v3 = p1:GetBoundingBox()
		v2.StudsOffsetWorldSpace = Vector3.new(0, math.max(v3.Y * 0.5, 0.5) + 2, 0)
		v2.Parent = p1
	end
end
local function updateFishingGui(p1) --[[ updateFishingGui | Line: 512 | Upvalues: Workspace (copy) ]]
	local PetFishingStatus = p1.Model:FindFirstChild("PetFishingStatus")
	if not PetFishingStatus then
		return
	end
	local v1 = p1.Player:GetAttribute("PetFishingPhase")
	if v1 ~= "Waiting" and v1 ~= "Reeling" then
		PetFishingStatus.Enabled = false
		return
	end
	local Label = PetFishingStatus.Frame.Label
	local Fill = PetFishingStatus.Frame.BarBack.Fill
	local v2 = p1.Player:GetAttribute("PetFishingPhaseStartAt")
	local v3 = p1.Player:GetAttribute("PetFishingPhaseEndAt")
	if typeof(v2) ~= "number" or (typeof(v3) ~= "number" or v3 <= v2) then
		PetFishingStatus.Enabled = false
		return
	end
	local v4 = Workspace:GetServerTimeNow()
	local v6 = math.clamp((v4 - v2) / math.max(v3 - v2, 0.001), 0, 1)
	PetFishingStatus.Enabled = true
	if v1 == "Waiting" then
		Label.Text = ("%*s"):format((math.max(math.ceil(v3 - v4), 0)))
		Fill.Size = UDim2.fromScale(1 - v6, 1)
	else
		Label.Text = "Fishing"
		Fill.Size = UDim2.fromScale(v6, 1)
	end
end
local function getDefaultBaitTemplate() --[[ getDefaultBaitTemplate | Line: 549 | Upvalues: ItemUtility (copy), ModelDownloader (copy) ]]
	local v1 = ItemUtility:GetBaitData(1)
	if not v1 then
		return nil
	end
	local v2 = ModelDownloader:GetModel(v1.Data.Type, v1.Data.Id, false)
	if not v2 then
		return nil
	end
	if v2:IsA("BasePart") then
		return v2
	else
		return nil
	end
end
local function getRodCastParts(p1) --[[ getRodCastParts | Line: 563 ]]
	local RootPart = p1.Model:FindFirstChild("RootPart")
	if RootPart then
		RootPart:FindFirstChild("LowerBody")
	end
	local v1 = if RootPart then RootPart:FindFirstChild("FishingRodBone", true) else RootPart
	local v2 = if v1 then v1:FindFirstChild("0") else v1
	local Rod = p1.Model:FindFirstChild("Rod")
	return v2, if Rod then Rod:FindFirstChild("Beams") else Rod
end
local function getBaitAttachment(p1) --[[ getBaitAttachment | Line: 575 ]]
	local v1 = p1:FindFirstChildWhichIsA("Attachment")
	if v1 then
		return v1
	else
		local BaitAttachment = Instance.new("Attachment")
		BaitAttachment.Name = "BaitAttachment"
		BaitAttachment.Position = Vector3.new(0, p1.Size.Y * 0.5, 0)
		BaitAttachment.Parent = p1
		return BaitAttachment
	end
end
local function disconnectPetBait(p1) --[[ disconnectPetBait | Line: 588 | Upvalues: spr (copy) ]]
	if p1.BaitConnection then
		p1.BaitConnection:Disconnect()
		p1.BaitConnection = nil
	end
	for i, v in ipairs(p1.BaitBeams) do
		if v.Parent then
			v.Attachment1 = nil
			v.Enabled = false
		end
	end
	table.clear(p1.BaitBeams)
	if p1.BaitModel then
		spr.stop(p1.BaitModel)
		p1.BaitModel:Destroy()
		p1.BaitModel = nil
	end
	p1.LastBaitCastKey = nil
end
local function connectRodBeams(p1, p2, p3, p4) --[[ connectRodBeams | Line: 611 ]]
	if not p3 then
		return
	end
	for v1, v2 in p3:GetDescendants() do
		if v2:IsA("Beam") then
			v2.Attachment0 = p2
			v2.Attachment1 = p4
			v2.Enabled = true
			table.insert(p1.BaitBeams, v2)
		end
	end
end
local function movePetBait(p1, p2, p3, p4) --[[ movePetBait | Line: 628 | Upvalues: CurveUtil (copy), CosmeticFolder (copy), RunService (copy), t3 (copy), spr (copy), Soundbook (copy) ]]
	local v1 = math.max(p3.Y, p4.Y) + 16
	local v2 = CurveUtil.GetCurveBetween({
		numPoints = 30,
		visualize = false,
		withRotation = true,
		start = p3,
		finish = p4,
		curveHeight = v1,
		yRotation = CFrame.fromOrientation(0, 0, 0)
	})
	p2:PivotTo(CFrame.new(p3))
	p2.Parent = CosmeticFolder
	local v4 = math.max((p3 - p4).Magnitude / 40 * 1, 0.1)
	local v5 = os.clock()
	p1.BaitConnection = RunService.Heartbeat:Connect(function() --[[ Line: 647 | Upvalues: t3 (ref), p1 (copy), p2 (copy), v5 (copy), v4 (copy), v2 (copy), p4 (copy), spr (ref), Soundbook (ref) ]]
		if t3[p1.Player.UserId] == p1 and (p1.BaitModel == p2 and p2.Parent) then
			local v22 = math.min((os.clock() - v5) / v4, 1)
			local v3 = v22 * (#v2 - 1) + 1
			local v42 = math.floor(v3)
			p2:PivotTo(v2[v42]:Lerp(v2[math.min(v42 + 1, #v2)], v3 - v42))
			if not (v22 >= 1) then
				return
			end
			if p1.BaitConnection then
				p1.BaitConnection:Disconnect()
				p1.BaitConnection = nil
			end
			p2:PivotTo(CFrame.new(p4))
			spr.stop(p2)
			spr.target(p2, 70, 150, {
				Pivot = CFrame.new(p4 - Vector3.new(0, 2, 0))
			})
			task.delay(1, function() --[[ Line: 674 | Upvalues: t3 (ref), p1 (ref), p2 (ref), spr (ref), p4 (ref) ]]
				if t3[p1.Player.UserId] ~= p1 or (p1.BaitModel ~= p2 or not p2.Parent) then
					return
				end
				spr.stop(p2)
				spr.target(p2, 30, 60, {
					Pivot = CFrame.new(p4)
				})
			end)
			Soundbook:RenderAt("Water Splash", p4)
		else
			if not p1.BaitConnection then
				return
			end
			p1.BaitConnection:Disconnect()
			p1.BaitConnection = nil
		end
	end)
end
local function createPetBaitVisual(p1, p2) --[[ createPetBaitVisual | Line: 687 | Upvalues: ItemUtility (copy), ModelDownloader (copy), getRodCastParts (copy), disconnectPetBait (copy), connectRodBeams (copy), movePetBait (copy) ]]
	local v1 = ItemUtility:GetBaitData(1)
	local v2
	if v1 then
		local v3 = ModelDownloader:GetModel(v1.Data.Type, v1.Data.Id, false)
		v2 = if v3 then if v3:IsA("BasePart") then v3 else nil else nil
	else
		v2 = nil
	end
	if not v2 then
		return false
	end
	local v4, v5 = getRodCastParts(p1)
	if not v4 then
		return false
	end
	disconnectPetBait(p1)
	local v6 = v2:Clone()
	v6:SetAttribute("UseCosmeticBulletObject", true)
	v6.Anchored = true
	v6.Name = ("PetBait_%*"):format(p1.Player.UserId)
	local v7 = v6:FindFirstChildWhichIsA("Attachment")
	local v8
	if v7 then
		v8 = v7
	else
		local BaitAttachment = Instance.new("Attachment")
		BaitAttachment.Name = "BaitAttachment"
		BaitAttachment.Position = Vector3.new(0, v6.Size.Y * 0.5, 0)
		BaitAttachment.Parent = v6
		v8 = BaitAttachment
	end
	connectRodBeams(p1, v4, v5, v8)
	p1.BaitModel = v6
	movePetBait(p1, v6, v4.WorldPosition, p2)
	return true
end
local function updatePetBaitVisual(p1) --[[ updatePetBaitVisual | Line: 713 | Upvalues: disconnectPetBait (copy), createPetBaitVisual (copy) ]]
	if p1.Player:GetAttribute("PetFishingPhase") ~= "Reeling" then
		disconnectPetBait(p1)
		return
	end
	local v1 = p1.Player:GetAttribute("PetFishingCastPosition")
	if typeof(v1) ~= "Vector3" or v1 == Vector3.new(0, 0, 0) then
		disconnectPetBait(p1)
		return
	end
	local v2 = p1.Player:GetAttribute("PetFishingPhaseStartAt")
	local v3 = p1.Player:GetAttribute("PetFishingPhaseEndAt")
	if typeof(v2) ~= "number" or (typeof(v3) ~= "number" or v3 <= v2) then
		disconnectPetBait(p1)
		return
	end
	local v4 = ("%*:%*:%*:%*:%*"):format(v2, v3, v1.X, v1.Y, v1.Z)
	if p1.LastBaitCastKey == v4 and (p1.BaitModel and p1.BaitModel.Parent) then
		return
	end
	if not createPetBaitVisual(p1, v1) then
		return
	end
	p1.LastBaitCastKey = v4
end
local function setHidden(p1, p2) --[[ setHidden | Line: 743 ]]
	if p1.Hidden == p2 then
		return
	end
	p1.Hidden = p2
	for v1, v2 in p1.Model:GetDescendants() do
		if v2:IsA("BasePart") then
			v2.LocalTransparencyModifier = if p2 then 1 else 0
			continue
		end
		if v2:IsA("BillboardGui") then
			v2.Enabled = not p2
		end
	end
end
local function getGroundedPosition(p1, p2, p3) --[[ getGroundedPosition | Line: 758 | Upvalues: Workspace (copy) ]]
	local v1 = Workspace:Raycast(p2 + Vector3.new(0, 8, 0), Vector3.new(0, -24, 0), p3)
	if v1 then
		return Vector3.new(p2.X, v1.Position.Y + p1.PivotBottomOffset + 0.08, p2.Z)
	else
		return p2
	end
end
local function getMoveStep(p1, p2) --[[ getMoveStep | Line: 768 ]]
	local v1 = math.clamp(p1 / 28, 0, 1)
	return (v1 * 4.5 + 9.5) * (v1 * 1.75 + 1) * p2
end
local function getTargetPosition(p1) --[[ getTargetPosition | Line: 775 ]]
	local RootPart = p1.RootPart
	local v1 = p1.Player:GetAttribute("EquippedPetState")
	return RootPart.Position - RootPart.CFrame.LookVector * (if v1 == "Fishing" then 2.2 else 4) + RootPart.CFrame.RightVector * (if v1 == "Fishing" then 3.4 else 2.4)
end
local function getSeatBoat(p1) --[[ getSeatBoat | Line: 783 | Upvalues: Workspace (copy) ]]
	if not p1 then
		return nil
	end
	local Vehicles = Workspace:FindFirstChild("Vehicles")
	if not Vehicles then
		return nil
	end
	local v1 = p1.Parent
	while v1 and v1 ~= Workspace do
		if v1:IsA("Model") and (v1:IsDescendantOf(Vehicles) and v1:GetAttribute("OwnerId") ~= nil) then
			return v1
		end
		v1 = v1.Parent
	end
	return nil
end
local function getBoatSeats(p1) --[[ getBoatSeats | Line: 805 | Upvalues: v2 (copy) ]]
	local v1 = v2[p1]
	if v1 then
		return v1
	end
	local t = {}
	for v22, v3 in p1:GetDescendants() do
		if v3:IsA("Seat") or v3:IsA("VehicleSeat") then
			table.insert(t, v3)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 818 ]]
		return p1:GetFullName() < p2:GetFullName()
	end)
	v2[p1] = t
	return t
end
local function getSeatedBoatPlayerIndex(p1, p2) --[[ getSeatedBoatPlayerIndex | Line: 826 | Upvalues: Players (copy), getSeatBoat (copy) ]]
	local list = {}
	for v1, v2 in Players:GetPlayers() do
		local Character = v2.Character
		local v3 = if Character then Character:FindFirstChildOfClass("Humanoid") else Character
		local v4 = if v3 then v3.SeatPart else v3
		if v4 and getSeatBoat(v4) == p2 then
			table.insert(list, v2)
		end
	end
	table.sort(list, function(p1, p2) --[[ Line: 837 ]]
		return p1.UserId < p2.UserId
	end)
	for i, v in ipairs(list) do
		if v == p1 then
			return i
		end
	end
	return nil
end
local function getAssignedBoatPetSeat(p1, p2) --[[ getAssignedBoatPetSeat | Line: 850 | Upvalues: getSeatedBoatPlayerIndex (copy), getBoatSeats (copy) ]]
	local v1 = getSeatedBoatPlayerIndex(p1, p2)
	if not v1 then
		return nil
	end
	local t = {}
	for i, v in ipairs((getBoatSeats(p2))) do
		if v.Occupant == nil then
			table.insert(t, v)
		end
	end
	return t[v1]
end
local function getBoatPetTarget(p1) --[[ getBoatPetTarget | Line: 866 | Upvalues: getSeatBoat (copy), getAssignedBoatPetSeat (copy) ]]
	local v1 = getSeatBoat(p1.Humanoid.SeatPart)
	if not v1 then
		return nil, nil
	end
	local v2 = getAssignedBoatPetSeat(p1.Player, v1)
	if v2 then
		return v2.Position + v2.CFrame.UpVector * (v2.Size.Y * 0.5 + p1.PivotBottomOffset + 0.08), v2.CFrame.LookVector
	end
	local Head = p1.Character:FindFirstChild("Head")
	if Head then
		return Head.Position + Vector3.new(0, p1.PivotBottomOffset + 3.5, 0), Head.CFrame.LookVector
	else
		return p1.RootPart.Position + Vector3.new(0, p1.HalfHeight + 3.5, 0), p1.RootPart.CFrame.LookVector
	end
end
local function shouldRender(p1) --[[ shouldRender | Line: 886 ]]
	local v1 = p1:GetAttribute("EquippedPetState")
	local v2 = p1:GetAttribute("EquippedPetModelName")
	return if typeof(v2) == "string" and v2 ~= "" then v1 ~= "None" else false
end
function t2.GetPetAnimations(p1) --[[ GetPetAnimations | Line: 892 | Upvalues: t4 (copy) ]]
	return t4
end
function t2.Unrender(p1, p2) --[[ Unrender | Line: 896 | Upvalues: t3 (copy), disconnectPetBait (copy) ]]
	local v1 = t3[p2.UserId]
	if not v1 then
		return
	end
	for v2, v3 in v1.Tracks do
		v3:Stop(0)
		v3:Destroy()
	end
	disconnectPetBait(v1)
	v1.Model:Destroy()
	t3[p2.UserId] = nil
end
function t2.Render(p1, p2) --[[ Render | Line: 912 | Upvalues: getPetTemplate (copy), t3 (copy), makeNameGui (copy), makeFishingGui (copy), prepareModel (copy), getAnimator (copy), t4 (copy), getPivotBottomOffset (copy), Workspace (copy), preloadPetAnimations (copy) ]]
	local v1 = p2:GetAttribute("EquippedPetState")
	local v2 = p2:GetAttribute("EquippedPetModelName")
	if not (if typeof(v2) == "string" and v2 ~= "" then v1 ~= "None" else false) then
		p1:Unrender(p2)
		return
	end
	local Character = p2.Character
	if not Character then
		p1:Unrender(p2)
		return
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if HumanoidRootPart and Humanoid then
		local v4 = p2:GetAttribute("EquippedPetModelName")
		local v5 = getPetTemplate(v4)
		if not v5 then
			p1:Unrender(p2)
			return
		end
		local v6 = t3[p2.UserId]
		if v6 and v6.Model.Name == v4 then
			v6.Character = Character
			v6.RootPart = HumanoidRootPart
			v6.Humanoid = Humanoid
			makeNameGui(v6.Model, p2:GetAttribute("EquippedPetName") or v4, (p2:GetAttribute("EquippedPetState")))
			makeFishingGui(v6.Model)
			return
		end
		p1:Unrender(p2)
		local v7 = v5:Clone()
		v7.Name = v4
		prepareModel(v7)
		local v8 = getAnimator(v7)
		local v9 = t4[v4]
		local _, v10 = v7:GetBoundingBox()
		local v12 = math.max(v10.Y * 0.5, 0.5)
		local v13 = getPivotBottomOffset(v7)
		local t = {
			CurrentAnimation = nil,
			LastState = nil,
			OneShotEndsAt = 0,
			Hidden = false,
			BaitModel = nil,
			BaitConnection = nil,
			LastBaitCastKey = nil,
			Player = p2,
			Character = Character,
			Humanoid = Humanoid,
			RootPart = HumanoidRootPart,
			Model = v7,
			Animator = v8,
			Animations = v9,
			Tracks = {},
			HalfHeight = v12,
			PivotBottomOffset = v13,
			Position = HumanoidRootPart.Position,
			Forward = HumanoidRootPart.CFrame.LookVector,
			BaitBeams = {}
		}
		local RootPart = t.RootPart
		local v14 = t.Player:GetAttribute("EquippedPetState")
		local v20 = RootPart.Position - RootPart.CFrame.LookVector * (if v14 == "Fishing" then 2.2 else 4) + RootPart.CFrame.RightVector * (if v14 == "Fishing" then 3.4 else 2.4)
		v7:PivotTo(CFrame.lookAt(v20, v20 + HumanoidRootPart.CFrame.LookVector))
		v7.Parent = Workspace
		makeNameGui(v7, p2:GetAttribute("EquippedPetName") or v4, (p2:GetAttribute("EquippedPetState")))
		makeFishingGui(v7)
		local t2 = {
			CurrentAnimation = nil,
			LastState = nil,
			OneShotEndsAt = 0,
			Hidden = false,
			BaitModel = nil,
			BaitConnection = nil,
			LastBaitCastKey = nil,
			Player = p2,
			Character = Character,
			Humanoid = Humanoid,
			RootPart = HumanoidRootPart,
			Model = v7,
			Animator = v8,
			Animations = v9,
			Tracks = {},
			HalfHeight = v12,
			PivotBottomOffset = v13,
			Position = v20,
			Forward = HumanoidRootPart.CFrame.LookVector,
			BaitBeams = {}
		}
		t3[p2.UserId] = t2
		task.spawn(preloadPetAnimations, t2)
	else
		p1:Unrender(p2)
	end
end
function t2.Refresh(p1, p2) --[[ Refresh | Line: 1012 | Upvalues: t (copy) ]]
	if not t[p2] then
		t[p2] = true
		xpcall(function() --[[ Line: 1019 | Upvalues: p1 (copy), p2 (copy) ]]
			p1:Render(p2)
		end, warn)
		t[p2] = nil
	end
end
function t2.PlayCatchAnimation(p1, p2) --[[ PlayCatchAnimation | Line: 1026 | Upvalues: t3 (copy), playPetAnimation (copy) ]]
	local v1 = t3[p2.UserId]
	if not v1 then
		return
	end
	local v2 = playPetAnimation(v1, "FishCaught", true)
	if v2 then
		local v3 = if v2.Length > 0 then v2.Length else 1.2
		v1.OneShotEndsAt = os.clock() + v3
	end
	v1.LastState = nil
end
function t2.GetCatchTargetPosition(p1, p2) --[[ GetCatchTargetPosition | Line: 1036 | Upvalues: t3 (copy) ]]
	local v1 = t3[p2.UserId]
	if v1 then
		local Position = v1.Model:GetPivot().Position
		return Position + Vector3.new(0, v1.HalfHeight * 0.35, 0)
	end
	local Character = p2.Character
	if not Character then
		return nil
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return nil
	end
	local v3 = p2:GetAttribute("EquippedPetModelName")
	if typeof(v3) ~= "string" or v3 == "" then
		return nil
	end
	local v4 = p2:GetAttribute("EquippedPetState")
	return HumanoidRootPart.Position - HumanoidRootPart.CFrame.LookVector * (if v4 == "Fishing" then 2.2 else 4) + HumanoidRootPart.CFrame.RightVector * (if v4 == "Fishing" then 3.4 else 2.4) + Vector3.new(0, 1.5, 0)
end
function t2.Start(p1) --[[ Start | Line: 1065 | Upvalues: Observers (copy), t2 (copy), RunService (copy), t3 (copy), Workspace (copy), getBoatPetTarget (copy), LocalPlayer (copy), setHidden (copy), updateFishingGui (copy), updatePetBaitVisual (copy), disconnectPetBait (copy), updatePetAnimation (copy) ]]
	Observers.observePlayer(function(p1) --[[ Line: 1066 | Upvalues: t2 (ref) ]]
		local t = {
			p1:GetAttributeChangedSignal("EquippedPetModelName"):Connect(function() --[[ Line: 1068 | Upvalues: t2 (ref), p1 (copy) ]]
				t2:Refresh(p1)
			end),
			p1:GetAttributeChangedSignal("EquippedPetName"):Connect(function() --[[ Line: 1071 | Upvalues: t2 (ref), p1 (copy) ]]
				t2:Refresh(p1)
			end),
			p1:GetAttributeChangedSignal("EquippedPetState"):Connect(function() --[[ Line: 1074 | Upvalues: t2 (ref), p1 (copy) ]]
				t2:Refresh(p1)
			end),
			p1:GetAttributeChangedSignal("PetResetToken"):Connect(function() --[[ Line: 1077 | Upvalues: t2 (ref), p1 (copy) ]]
				t2:Unrender(p1)
				t2:Refresh(p1)
			end)
		}
		t2:Refresh(p1)
		return function() --[[ Line: 1085 | Upvalues: t (copy), t2 (ref), p1 (copy) ]]
			for i, v in ipairs(t) do
				v:Disconnect()
			end
			t2:Unrender(p1)
		end
	end)
	Observers.observeCharacter(function(p1, p2) --[[ Line: 1093 | Upvalues: t2 (ref) ]]
		local v1 = p2.ChildAdded:Connect(function(p12) --[[ Line: 1094 | Upvalues: t2 (ref), p1 (copy) ]]
			if p12.Name ~= "HumanoidRootPart" and not p12:IsA("Humanoid") then
				return
			end
			t2:Refresh(p1)
		end)
		t2:Refresh(p1)
		return function() --[[ Line: 1102 | Upvalues: v1 (copy), t2 (ref), p1 (copy) ]]
			v1:Disconnect()
			t2:Unrender(p1)
		end
	end)
	RunService:BindToRenderStep("PetVisualFollow", Enum.RenderPriority.Camera.Value + 2, function(p1) --[[ Line: 1108 | Upvalues: t3 (ref), Workspace (ref), t2 (ref), getBoatPetTarget (ref), LocalPlayer (ref), setHidden (ref), updateFishingGui (ref), updatePetBaitVisual (ref), disconnectPetBait (ref), updatePetAnimation (ref) ]]
		for v2, v3 in t3 do
			local v1
			local Player = v3.Player
			local v4 = Player:GetAttribute("EquippedPetState")
			local v5 = Player:GetAttribute("EquippedPetModelName")
			local v6 = if typeof(v5) == "string" and v5 ~= "" then v4 ~= "None" else false
			if v6 and v3.RootPart:IsDescendantOf(Workspace) then
				local v7 = v3.Player:GetAttribute("EquippedPetState")
				local v8, v9 = getBoatPetTarget(v3)
				if v8 then
					v1 = v8
				else
					local RootPart = v3.RootPart
					local v10 = v3.Player:GetAttribute("EquippedPetState")
					v1 = RootPart.Position - RootPart.CFrame.LookVector * (if v10 == "Fishing" then 2.2 else 4) + RootPart.CFrame.RightVector * (if v10 == "Fishing" then 3.4 else 2.4)
				end
				local v13 = v3.Player:GetAttribute("PetTeleportDistance")
				local v14 = if typeof(v13) == "number" then v13 else 200
				if not v8 then
					local v15 = RaycastParams.new()
					v15.FilterType = Enum.RaycastFilterType.Exclude
					v15.FilterDescendantsInstances = { v3.Character, v3.Model }
					v15.IgnoreWater = false
					local v16 = Workspace:Raycast(v1 + Vector3.new(0, 8, 0), Vector3.new(0, -24, 0), v15)
					if v16 then
						v1 = Vector3.new(v1.X, v16.Position.Y + v3.PivotBottomOffset + 0.08, v1.Z)
					end
				end
				local Magnitude = (v3.Position - v1).Magnitude
				local v19 = v1 - v3.Position
				if v8 or v14 < Magnitude then
					v3.Position = v1
					v19 = Vector3.new(0, 0, 0)
				elseif Magnitude > 0.08 then
					local v20 = math.clamp(Magnitude / 28, 0, 1)
					v3.Position = v3.Position + v19.Unit * math.min(Magnitude, (v20 * 4.5 + 9.5) * (v20 * 1.75 + 1) * p1)
				else
					v3.Position = v1
					v19 = Vector3.new(0, 0, 0)
				end
				local v22 = Vector3.new(v19.X, 0, v19.Z)
				local v23 = if v22.Magnitude > 0.08 then true else false
				local v24 = if v23 then v22 elseif v9 then v9 else v3.RootPart.CFrame.LookVector
				if v24.Magnitude > 0.01 then
					v3.Forward = v3.Forward:Lerp(v24.Unit, 1 - math.exp(p1 * -14))
				end
				local v26 = if v3.Humanoid.Health <= 0 then true elseif v3.Player == LocalPlayer then if LocalPlayer:GetAttribute("Cutscene") == true then true else false else false
				setHidden(v3, v26)
				if v26 then
					disconnectPetBait(v3)
				else
					updateFishingGui(v3)
					updatePetBaitVisual(v3)
				end
				updatePetAnimation(v3, v23, v7)
				v3.Model:PivotTo(CFrame.lookAt(v3.Position, v3.Position + v3.Forward))
				continue
			end
			t2:Refresh(v3.Player)
		end
	end)
end
return t2