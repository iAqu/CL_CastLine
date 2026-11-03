-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Emotes = require(ReplicatedStorage.Emotes)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local FormatUtil = require(ReplicatedStorage.Modules.Util.FormatUtil)
local EmoteHumanoids = ReplicatedStorage.Assets:FindFirstChild("EmoteHumanoids")
local LocalPlayer = Players.LocalPlayer
local v1 = Promise.promisify(function(p1) --[[ Line: 55 | Upvalues: Players (copy) ]]
	local Character = p1.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v1 then
		return v1:GetAppliedDescription()
	else
		return Players:GetHumanoidDescriptionFromUserId(p1.UserId)
	end
end)
local function resolveSpawnCFrame(p1) --[[ resolveSpawnCFrame | Line: 65 ]]
	local v1
	if p1:IsA("Model") then
		v1 = p1
	else
		local v2 = p1:FindFirstAncestorOfClass("Model")
		v1 = if v2 then v2 else p1
	end
	if v1:IsA("Model") then
		local CharacterSpawnPart = v1:FindFirstChild("CharacterSpawnPart", true)
		if CharacterSpawnPart and CharacterSpawnPart:IsA("BasePart") then
			return CharacterSpawnPart.CFrame
		end
		local PromptPart = v1:FindFirstChild("PromptPart", true)
		if PromptPart and PromptPart:IsA("BasePart") then
			return PromptPart.CFrame + Vector3.new(0, 2.5, 0)
		else
			return v1:GetPivot() + Vector3.new(0, 2.5, 0)
		end
	elseif p1:IsA("BasePart") then
		return p1.CFrame + Vector3.new(0, 2.5, 0)
	else
		return CFrame.new()
	end
end
local function resolveEmoteHumanoidModel(p1) --[[ resolveEmoteHumanoidModel | Line: 95 | Upvalues: EmoteHumanoids (copy) ]]
	if not (EmoteHumanoids and EmoteHumanoids:IsA("Folder")) then
		return nil
	end
	local v1 = EmoteHumanoids:FindFirstChild(p1)
	if v1 and v1:IsA("Model") then
		return v1
	end
	local Default = EmoteHumanoids:FindFirstChild("Default")
	if Default and Default:IsA("Model") then
		return Default
	else
		return nil
	end
end
local function createShowcaseRig(p1) --[[ createShowcaseRig | Line: 113 | Upvalues: resolveEmoteHumanoidModel (copy) ]]
	local v1 = resolveEmoteHumanoidModel(p1)
	if not v1 then
		return nil, nil, nil
	end
	local RoseEmotePreviewRig = v1:Clone()
	RoseEmotePreviewRig.Name = "RoseEmotePreviewRig"
	local v2 = RoseEmotePreviewRig:FindFirstChildWhichIsA("Humanoid")
	if not v2 then
		RoseEmotePreviewRig:Destroy()
		return nil, nil, nil
	end
	v2.AutoRotate = false
	v2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	v2.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	for v3, v4 in RoseEmotePreviewRig:GetDescendants() do
		if v4:IsA("BasePart") then
			v4.CanCollide = false
			v4.CanQuery = false
			v4.CanTouch = false
			v4.CollisionGroup = "Players"
		end
	end
	if not RoseEmotePreviewRig.PrimaryPart then
		local HumanoidRootPart = RoseEmotePreviewRig:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
			RoseEmotePreviewRig.PrimaryPart = HumanoidRootPart
		end
	end
	local Animator = v2:FindFirstChildOfClass("Animator")
	if not Animator then
		local Animator_2 = Instance.new("Animator")
		Animator_2.Parent = v2
		Animator = Animator_2
	end
	if Animator then
		return RoseEmotePreviewRig, v2, Animator
	else
		RoseEmotePreviewRig:Destroy()
		return nil, nil, nil
	end
end
local function clearEmoteVFX(p1) --[[ clearEmoteVFX | Line: 163 ]]
	local ActiveVFX = p1.ActiveVFX
	p1.ActiveVFX = {}
	for i, v in ipairs(ActiveVFX) do
		if v.Parent then
			v:Destroy()
		end
	end
end
local function attachAndEmitEmoteVFX(p1, p2) --[[ attachAndEmitEmoteVFX | Line: 175 | Upvalues: ParticleEmitter (copy) ]]
	local list = {}
	local EmoteVFX = p1:FindFirstChild("EmoteVFX")
	if not (EmoteVFX and EmoteVFX:IsA("Folder")) then
		return list
	end
	local v1 = EmoteVFX:GetAttribute("AttachPart")
	if typeof(v1) ~= "string" or v1 == "" then
		return list
	end
	local v2 = p1:FindFirstChild(v1, true)
	if not (v2 and v2:IsA("BasePart")) then
		return list
	end
	local v3 = EmoteVFX:Clone()
	for i, v in ipairs(v3:GetChildren()) do
		v.Parent = v2
		table.insert(list, v)
	end
	v3:Destroy()
	if p2 > 0 then
		task.delay(p2, function() --[[ Line: 201 | Upvalues: list (copy), ParticleEmitter (ref) ]]
			for i, v in ipairs(list) do
				if v.Parent then
					ParticleEmitter.emitContainer(v)
				end
			end
		end)
		return list
	end
	for i, v in ipairs(list) do
		ParticleEmitter.emitContainer(v)
	end
	return list
end
local function createPromptAttachment(p1, p2) --[[ createPromptAttachment | Line: 217 ]]
	local PurchaseAttachment = p1:FindFirstChild("PurchaseAttachment", true)
	if PurchaseAttachment and PurchaseAttachment:IsA("Attachment") then
		return PurchaseAttachment, nil
	end
	local PromptPart = p1:FindFirstChild("PromptPart", true)
	if PromptPart and PromptPart:IsA("BasePart") then
		local EmoteShowcasePurchaseAttachment = Instance.new("Attachment")
		EmoteShowcasePurchaseAttachment.Name = "EmoteShowcasePurchaseAttachment"
		EmoteShowcasePurchaseAttachment.Parent = PromptPart
		return EmoteShowcasePurchaseAttachment, EmoteShowcasePurchaseAttachment
	end
	local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		local EmoteShowcasePurchaseAttachment = Instance.new("Attachment")
		EmoteShowcasePurchaseAttachment.Name = "EmoteShowcasePurchaseAttachment"
		EmoteShowcasePurchaseAttachment.Parent = HumanoidRootPart
		return EmoteShowcasePurchaseAttachment, EmoteShowcasePurchaseAttachment
	else
		return nil, nil
	end
end
local function createPurchasePrompt(p1, p2, p3, p4) --[[ createPurchasePrompt | Line: 242 | Upvalues: createPromptAttachment (copy), FormatUtil (copy), LocalPlayer (copy), TextNotificationController (copy) ]]
	if p1:GetAttribute("DisablePurchasePrompt") == true then
		return nil, nil, nil
	end
	local v1, v2 = createPromptAttachment(p1, p2)
	if v1 then
		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.Name = ("%*PurchasePrompt"):format(p3.Tag)
		ProximityPrompt.ObjectText = p3.EmoteName
		ProximityPrompt.ActionText = ("Buy (%* %*)"):format(FormatUtil.abbr(p3.Cost), p3.CurrencyName)
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		ProximityPrompt.MaxActivationDistance = 14
		ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
		ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
		ProximityPrompt.HoldDuration = 0
		ProximityPrompt.Parent = v1
		local v3 = false
		return ProximityPrompt, ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 266 | Upvalues: LocalPlayer (ref), v3 (ref), p4 (copy), p3 (copy), ProximityPrompt (copy), TextNotificationController (ref) ]]
			if p1 ~= LocalPlayer then
				return
			end
			if v3 then
				return
			end
			v3 = true
			local v1, v2, v32 = pcall(function() --[[ Line: 276 | Upvalues: p4 (ref) ]]
				return p4:InvokeServer()
			end)
			local t = {
				R = 255,
				G = 0,
				B = 0
			}
			local v4 = "Unable to complete purchase."
			if v1 and v2 == true then
				v4 = if typeof(v32) == "string" then v32 else ("Purchased %*!"):format(p3.EmoteName)
				ProximityPrompt.Enabled = false
				ProximityPrompt.ActionText = "Owned"
				t = {
					R = 0,
					G = 200,
					B = 0
				}
			elseif v1 and typeof(v32) == "string" then
				v4 = v32
			end
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = v4,
				TextColor = t
			})
			v3 = false
		end), v2
	else
		return nil, nil, v2
	end
end
local function observeConfiguredShowcase(p1, p2, p3) --[[ observeConfiguredShowcase | Line: 303 | Upvalues: Emotes (copy), Trove (copy), createShowcaseRig (copy), resolveSpawnCFrame (copy), Promise (copy), v1 (copy), LocalPlayer (copy), createPurchasePrompt (copy), clearEmoteVFX (copy), attachAndEmitEmoteVFX (copy) ]]
	local v12 = Emotes[p2.EmoteName]
	if not v12 then
		return
	end
	if typeof(v12.AnimationId) ~= "string" or v12.AnimationId == "" then
		return
	end
	local v2 = Trove.new()
	local v3, v4, v5 = createShowcaseRig(p2.EmoteName)
	if not (v3 and (v4 and v5)) then
		v2:Destroy()
		return
	end
	v3:PivotTo((resolveSpawnCFrame(p1)))
	v3.Parent = workspace
	v2:Add(v3)
	local RigObject = Instance.new("ObjectValue")
	RigObject.Name = "RigObject"
	RigObject.Value = v3
	RigObject.Parent = p1
	v2:Add(RigObject)
	Promise.try(v1, LocalPlayer):andThen(function(p1) --[[ Line: 329 | Upvalues: v4 (copy) ]]
		pcall(function() --[[ Line: 330 | Upvalues: v4 (ref), p1 (copy) ]]
			v4:ApplyDescriptionAsync(p1)
		end)
	end):catch(warn):await()
	local Animation = Instance.new("Animation")
	Animation.AnimationId = v12.AnimationId
	local v6, v7 = pcall(function() --[[ Line: 340 | Upvalues: v5 (copy), Animation (copy) ]]
		return v5:LoadAnimation(Animation)
	end)
	Animation:Destroy()
	if not (v6 and v7) then
		v2:Destroy()
		return
	end
	v7.Priority = v12.AnimationPriority or Enum.AnimationPriority.Action2
	v7.Looped = false
	v2:Add(function() --[[ Line: 352 | Upvalues: v7 (copy) ]]
		v7:Stop(0)
		v7:Destroy()
	end)
	local v9, v10, v11 = createPurchasePrompt(p1, v3, p2, p3)
	if v10 then
		v2:Add(v10)
	end
	if v9 then
		v2:Add(v9)
	end
	if v11 then
		v2:Add(v11)
	end
	local t = {
		ActiveVFX = {}
	}
	v2:Add(function() --[[ Line: 371 | Upvalues: clearEmoteVFX (ref), t (copy) ]]
		clearEmoteVFX(t)
	end)
	local v122 = v12.PlaybackSpeed or 1
	local v13 = v12.AutoStopDuration or (if v12.Looped then 2.9 else 2.4)
	local v14 = if typeof(v12.VFXStartDelay) == "number" then math.max(v12.VFXStartDelay, 0) else 0
	local v15 = if v12.Looped == true then true else false
	local v16 = true
	v2:Add(function() --[[ Line: 381 | Upvalues: v16 (ref) ]]
		v16 = false
	end)
	v2:Add(task.spawn(function() --[[ Line: 385 | Upvalues: v15 (copy), clearEmoteVFX (ref), t (copy), attachAndEmitEmoteVFX (ref), v3 (copy), v14 (copy), v7 (copy), v12 (copy), v122 (copy), v2 (copy), v16 (ref), v13 (copy) ]]
		if v15 then
			clearEmoteVFX(t)
			t.ActiveVFX = attachAndEmitEmoteVFX(v3, v14)
			v7.Priority = v12.AnimationPriority or Enum.AnimationPriority.Action2
			v7.Looped = true
			v7:Stop(0)
			v7:Play(0.1, 1, v122)
			v2:Add(v7.DidLoop:Connect(function() --[[ Line: 395 | Upvalues: v16 (ref), clearEmoteVFX (ref), t (ref), attachAndEmitEmoteVFX (ref), v3 (ref), v14 (ref) ]]
				if v16 then
					clearEmoteVFX(t)
					t.ActiveVFX = attachAndEmitEmoteVFX(v3, v14)
				end
			end))
			while v16 and v7.IsPlaying do
				task.wait(0.1)
			end
		else
			while v16 do
				clearEmoteVFX(t)
				t.ActiveVFX = attachAndEmitEmoteVFX(v3, v14)
				local v32 = v7
				v32.Priority = v12.AnimationPriority or Enum.AnimationPriority.Action2
				v7.Looped = false
				v7:Stop()
				v7:Play(0, 1, v122)
				if v7.Length <= 0 then
					local sum = 0
					while v16 and (v7.Length <= 0 and sum < 1) do
						sum = sum + task.wait(0.05)
					end
				end
				local v5 = v13
				if v7.Length > 0 then
					v5 = math.max(v5, v7.Length / math.max(v122, 0.05))
				end
				local sum = 0
				while v16 and (v7.IsPlaying and sum < v5 + 0.2) do
					sum = sum + task.wait(0.05)
				end
				if not v16 then
					break
				end
				pcall(function() --[[ Line: 442 | Upvalues: v7 (ref) ]]
					v7:AdjustSpeed(0)
				end)
				task.wait(0.35)
			end
		end
	end))
	return function() --[[ Line: 450 | Upvalues: v2 (copy) ]]
		v2:Destroy()
	end
end
for i, v in ipairs({
	{
		Tag = "RoseEmote",
		EmoteName = "Rose Offering",
		Cost = 10000,
		CurrencyName = "Valentines Coins",
		PurchaseRemoteName = "PurchaseRoseEmote"
	},
	{
		Tag = "SittingPoseEmote",
		EmoteName = "Sitting Pose",
		Cost = 10000,
		CurrencyName = "Coins",
		PurchaseRemoteName = "PurchaseSittingPoseEmote"
	},
	{
		Tag = "RetroBurgerEmote",
		EmoteName = "Retro Burger",
		Cost = 10000,
		CurrencyName = "Tix",
		PurchaseRemoteName = "PurchaseRetroBurgerEmote"
	}
}) do
	local v2 = Net:RemoteFunction(v.PurchaseRemoteName)
	Observers.observeTag(v.Tag, function(p1) --[[ Line: 457 | Upvalues: observeConfiguredShowcase (copy), v (copy), v2 (copy) ]]
		return observeConfiguredShowcase(p1, v, v2)
	end, { workspace })
end
return {}