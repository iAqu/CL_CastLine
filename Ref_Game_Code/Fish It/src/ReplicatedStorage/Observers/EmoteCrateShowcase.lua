-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)
local EmoteHumanoids = ReplicatedStorage.Assets:FindFirstChild("EmoteHumanoids")
local EmoteCrates = require(ReplicatedStorage.EmoteCrates)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local BillboardUtils = require(ReplicatedStorage.Controllers.CrateController.Modules.CrateAnimationHelpers.BillboardUtils)
local EmoteLootboxController = require(ReplicatedStorage.Controllers.EmoteLootboxController)
local CrateItemBillboard = ReplicatedStorage.Controllers.CrateController.Modules.CrateAnimation:WaitForChild("CrateItemBillboard")
local v1 = BillboardUtils.new({
	TweenService = TweenService,
	billboardTemplate = CrateItemBillboard
})
local getCrateItemChance = v1.getCrateItemChance
local formatChanceText = v1.formatChanceText
local createItemBillboard = v1.createItemBillboard
local LocalPlayer = Players.LocalPlayer
local t = {}
local v2 = Promise.promisify(function(p1) --[[ Line: 33 | Upvalues: Players (copy) ]]
	local Character = p1.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v1 then
		return v1:GetAppliedDescription()
	else
		return Players:GetHumanoidDescriptionFromUserId(p1.UserId)
	end
end)
local function getDefaultCrateName() --[[ getDefaultCrateName | Line: 75 | Upvalues: EmoteCrates (copy) ]]
	if EmoteCrates["Valentine Emotes"] then
		return "Valentine Emotes"
	end
	for v1 in EmoteCrates do
		return v1
	end
	return nil
end
local function resolveCrateName(p1) --[[ resolveCrateName | Line: 88 | Upvalues: EmoteCrates (copy) ]]
	if p1 and EmoteCrates[p1] then
		return p1
	end
	if EmoteCrates["Valentine Emotes"] then
		return "Valentine Emotes"
	end
	for v1 in EmoteCrates do
		return v1
	end
	return nil
end
local function resolveSpawnCFrame(p1) --[[ resolveSpawnCFrame | Line: 96 ]]
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
local function resolveEmoteHumanoidModel(p1) --[[ resolveEmoteHumanoidModel | Line: 126 | Upvalues: EmoteHumanoids (copy) ]]
	if not (EmoteHumanoids and EmoteHumanoids:IsA("Folder")) then
		return nil
	end
	local v2 = EmoteHumanoids:FindFirstChild(if typeof(p1) == "string" and p1 ~= "" then p1 else "Default")
	if v2 and v2:IsA("Model") then
		return v2
	end
	local Default = EmoteHumanoids:FindFirstChild("Default")
	if Default and Default:IsA("Model") then
		return Default
	else
		return nil
	end
end
local function createShowcaseRig(p1, p2) --[[ createShowcaseRig | Line: 145 | Upvalues: resolveEmoteHumanoidModel (copy) ]]
	local v1 = resolveEmoteHumanoidModel(p2)
	if not v1 then
		return nil, nil, nil
	end
	local EmoteCratePreviewRig = v1:Clone()
	EmoteCratePreviewRig.Name = "EmoteCratePreviewRig"
	local v2 = EmoteCratePreviewRig:FindFirstChildWhichIsA("Humanoid")
	if not v2 then
		EmoteCratePreviewRig:Destroy()
		return nil, nil, nil
	end
	v2.AutoRotate = false
	v2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	v2.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	for v3, v4 in EmoteCratePreviewRig:GetDescendants() do
		if v4:IsA("BasePart") then
			v4.CanCollide = false
			v4.CanQuery = false
			v4.CanTouch = false
			v4.CollisionGroup = "Players"
		end
	end
	if not EmoteCratePreviewRig.PrimaryPart then
		local HumanoidRootPart = EmoteCratePreviewRig:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
			EmoteCratePreviewRig.PrimaryPart = HumanoidRootPart
		end
	end
	local Animator = v2:FindFirstChildOfClass("Animator")
	if not Animator then
		local Animator_2 = Instance.new("Animator")
		Animator_2.Parent = v2
		Animator = Animator_2
	end
	if Animator then
		return EmoteCratePreviewRig, v2, Animator
	else
		EmoteCratePreviewRig:Destroy()
		return nil, nil, nil
	end
end
local function clearEmoteVFX(p1) --[[ clearEmoteVFX | Line: 195 ]]
	local ActiveVFX = p1.ActiveVFX
	p1.ActiveVFX = {}
	for i, v in ipairs(ActiveVFX) do
		if v.Parent then
			v:Destroy()
		end
	end
end
local function clearEmoteSound(p1) --[[ clearEmoteSound | Line: 206 ]]
	local ActiveSound = p1.ActiveSound
	p1.ActiveSound = nil
	if not (ActiveSound and ActiveSound.Parent) then
		return
	end
	ActiveSound:Destroy()
end
local function getRigSoundPart(p1) --[[ getRigSoundPart | Line: 215 ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		return HumanoidRootPart
	end
	local PrimaryPart = p1.PrimaryPart
	if PrimaryPart and PrimaryPart:IsA("BasePart") then
		return PrimaryPart
	end
	local v1 = p1:FindFirstChildWhichIsA("BasePart")
	if v1 and v1:IsA("BasePart") then
		return v1
	else
		return nil
	end
end
local function playEmoteSoundOnRig(p1, p2) --[[ playEmoteSoundOnRig | Line: 234 | Upvalues: Soundbook (copy), getRigSoundPart (copy) ]]
	if not Soundbook:HasSound(p2) then
		return nil
	end
	local v1 = Soundbook.Sounds[p2]
	if not v1 then
		return nil
	end
	local v2 = getRigSoundPart(p1)
	if not v2 then
		return nil
	end
	local v3 = v1:Play(v2)
	if v3 and v3:IsA("Sound") then
		return v3
	else
		return nil
	end
end
local function attachAndEmitEmoteVFX(p1, p2) --[[ attachAndEmitEmoteVFX | Line: 257 | Upvalues: ParticleEmitter (copy) ]]
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
		task.delay(p2, function() --[[ Line: 283 | Upvalues: list (copy), ParticleEmitter (ref) ]]
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
local function getDefaultPurchaseOption(p1) --[[ getDefaultPurchaseOption | Line: 299 ]]
	for i, v in ipairs(p1.PurchaseOptions) do
		if v.Quantity == 1 then
			return i, v
		end
	end
	return 1, p1.PurchaseOptions[1]
end
local function createPromptAttachment(p1, p2) --[[ createPromptAttachment | Line: 313 ]]
	local PurchaseAttachment = p1:FindFirstChild("PurchaseAttachment", true)
	if PurchaseAttachment and PurchaseAttachment:IsA("Attachment") then
		return PurchaseAttachment, nil
	end
	local PromptPart = p1:FindFirstChild("PromptPart", true)
	if PromptPart and PromptPart:IsA("BasePart") then
		local EmoteCratePurchaseAttachment = Instance.new("Attachment")
		EmoteCratePurchaseAttachment.Name = "EmoteCratePurchaseAttachment"
		EmoteCratePurchaseAttachment.Parent = PromptPart
		return EmoteCratePurchaseAttachment, EmoteCratePurchaseAttachment
	end
	local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		local EmoteCratePurchaseAttachment = Instance.new("Attachment")
		EmoteCratePurchaseAttachment.Name = "EmoteCratePurchaseAttachment"
		EmoteCratePurchaseAttachment.Parent = HumanoidRootPart
		return EmoteCratePurchaseAttachment, EmoteCratePurchaseAttachment
	else
		return nil, nil
	end
end
local function getOddsAdornee(p1, p2) --[[ getOddsAdornee | Line: 338 ]]
	local Head = p1:FindFirstChild("Head")
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	local v1 = if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else p1.PrimaryPart
	local v2 = if Head and Head:IsA("BasePart") then Head else v1
	if p2 then
		return v1
	else
		return v2
	end
end
local function buildPreviewEntries(p1) --[[ buildPreviewEntries | Line: 350 | Upvalues: ItemUtility (copy) ]]
	local t = {}
	for i, v in ipairs(p1.Items) do
		local v1
		if v.Currency == "ItemReward" then
			local v2, v3 = table.unpack(v.CurrencyRewardInfo)
			if v2 == "Emotes" then
				local v4 = ItemUtility:GetEmoteData(v3)
				if v4 and (typeof(v4.AnimationId) == "string" and v4.AnimationId ~= "") then
					local v6 = v4.AutoStopDuration or (if v4.Looped then 2.9 else 2.4)
					v1 = if typeof(v4.VFXStartDelay) == "number" then math.max(v4.VFXStartDelay, 0) else 0
					local t2 = {
						ItemIdentifier = v3,
						EmoteName = v4.Data.Name,
						Chance = v.Chance,
						Tier = v4.Data.Tier,
						AnimationId = v4.AnimationId
					}
					t2.AnimationPriority = v4.AnimationPriority or Enum.AnimationPriority.Action2
					t2.PlaybackSpeed = v4.PlaybackSpeed or 1
					t2.HoldDuration = v6
					t2.Looped = if v4.Looped == true then true else false
					t2.VFXStartDelay = v1
					table.insert(t, t2)
				end
			end
		end
	end
	return t
end
local function loadTrack(p1, p2, p3) --[[ loadTrack | Line: 388 | Upvalues: t (copy) ]]
	if t[p1] == nil then
		t[p1] = {}
	end
	local v1 = t[p1]
	local v2 = v1[p3.EmoteName]
	if v2 then
		return v2
	end
	local Animation = Instance.new("Animation")
	Animation.AnimationId = p3.AnimationId
	local v3, v4 = pcall(function() --[[ Line: 402 | Upvalues: p2 (copy), Animation (copy) ]]
		return p2:LoadAnimation(Animation)
	end)
	Animation:Destroy()
	if v3 and v4 then
		v4.Priority = p3.AnimationPriority
		v4.Looped = false
		v1[p3.EmoteName] = v4
		return v4
	else
		return nil
	end
end
local function cleanupRigTracks(p1) --[[ cleanupRigTracks | Line: 417 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	for v2, v3 in v1 do
		v3:Stop(0)
		v3:Destroy()
	end
	t[p1] = nil
end
local function buildCrateChanceData(p1) --[[ buildCrateChanceData | Line: 431 ]]
	local t = {}
	for i, v in ipairs(p1) do
		table.insert(t, {
			itemType = "Emotes",
			itemName = v.ItemIdentifier,
			chance = v.Chance
		})
	end
	return {
		crateItems = t
	}
end
local function createEntryOddsBillboard(p1, p2, p3, p4, p5) --[[ createEntryOddsBillboard | Line: 446 | Upvalues: getCrateItemChance (copy), TierUtility (copy), formatChanceText (copy), createItemBillboard (copy) ]]
	local v1 = getCrateItemChance(p5, "Emotes", p2.ItemIdentifier) or p2.Chance
	local v2 = TierUtility:GetTier(p2.Tier or 1).TierColor.Keypoints[1].Value
	return createItemBillboard(p1, p2.EmoteName, ("%*"):format((formatChanceText(v1))), v2, if p4 then 2.1 else 3, p3)
end
local function createPurchasePrompt(p1, p2, p3, p4) --[[ createPurchasePrompt | Line: 461 | Upvalues: getDefaultPurchaseOption (copy), createPromptAttachment (copy), LocalPlayer (copy), EmoteLootboxController (copy) ]]
	if p1:GetAttribute("DisablePurchasePrompt") == true then
		return nil, nil, nil
	end
	local _, v1 = getDefaultPurchaseOption(p4)
	if not v1 then
		return nil, nil, nil
	end
	local v2, v3 = createPromptAttachment(p1, p2)
	if not v2 then
		return nil, nil, v3
	end
	local EmoteCratePurchasePrompt = Instance.new("ProximityPrompt")
	EmoteCratePurchasePrompt.Name = "EmoteCratePurchasePrompt"
	EmoteCratePurchasePrompt.ObjectText = p3
	if v1.Coins then
		EmoteCratePurchasePrompt.ActionText = ("View (%* Coins)"):format(v1.Coins)
	else
		EmoteCratePurchasePrompt.ActionText = "View Crate"
	end
	EmoteCratePurchasePrompt.ClickablePrompt = true
	EmoteCratePurchasePrompt.RequiresLineOfSight = false
	EmoteCratePurchasePrompt.MaxActivationDistance = 14
	EmoteCratePurchasePrompt.Style = Enum.ProximityPromptStyle.Custom
	EmoteCratePurchasePrompt.KeyboardKeyCode = Enum.KeyCode.E
	EmoteCratePurchasePrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
	EmoteCratePurchasePrompt.HoldDuration = 0
	EmoteCratePurchasePrompt.Parent = v2
	return EmoteCratePurchasePrompt, EmoteCratePurchasePrompt.Triggered:Connect(function(p1) --[[ Line: 493 | Upvalues: LocalPlayer (ref), EmoteLootboxController (ref), p3 (copy) ]]
		if p1 == LocalPlayer then
			EmoteLootboxController:Open(p3)
		end
	end), v3
end
Observers.observeTag("EmoteCrateShowcase", function(p1) --[[ Line: 504 | Upvalues: Trove (copy), EmoteCrates (copy), buildPreviewEntries (copy), buildCrateChanceData (copy), resolveSpawnCFrame (copy), Promise (copy), v2 (copy), LocalPlayer (copy), createShowcaseRig (copy), loadTrack (copy), clearEmoteVFX (copy), attachAndEmitEmoteVFX (copy), getOddsAdornee (copy), createEntryOddsBillboard (copy), createPurchasePrompt (copy), t (copy), playEmoteSoundOnRig (copy), cleanupRigTracks (copy) ]]
	local v1 = Trove.new()
	local v22 = p1:GetAttribute("CrateName")
	local v3 = if typeof(v22) == "string" then v22 else nil
	local v4
	if v3 and EmoteCrates[v3] then
		v4 = v3
	elseif EmoteCrates["Valentine Emotes"] then
		v4 = "Valentine Emotes"
	else
		v4 = nil
		for v5 in EmoteCrates do
			v4 = v5
			break
		end
	end
	if not v4 then
		v1:Destroy()
		return
	end
	local v6 = EmoteCrates[v4]
	if not v6 then
		v1:Destroy()
		return
	end
	local v7 = buildPreviewEntries(v6)
	if #v7 == 0 then
		v1:Destroy()
		return
	end
	local v8 = buildCrateChanceData(v7)
	local RigObject = Instance.new("ObjectValue")
	RigObject.Name = "RigObject"
	RigObject.Parent = p1
	v1:Add(RigObject)
	local v9 = p1:GetAttribute("OddsAtFeet") == true
	local v10 = resolveSpawnCFrame(p1)
	local v11 = nil
	Promise.try(v2, LocalPlayer):andThen(function(p1) --[[ Line: 538 | Upvalues: v11 (ref) ]]
		v11 = p1
	end):catch(warn):await()
	local t2 = {}
	for i, v in ipairs(v7) do
		local v12, v13, v14 = createShowcaseRig(p1, v.EmoteName)
		if v12 and (v13 and v14) then
			v12:PivotTo(v10 + Vector3.new(0, -3000, 0))
			v12.Parent = workspace
			if v11 then
				pcall(function() --[[ Line: 555 | Upvalues: v13 (copy), v11 (ref) ]]
					v13:ApplyDescriptionAsync(v11)
				end)
			end
			local v15 = loadTrack(v12, v14, v)
			if v15 then
				v15.Priority = v.AnimationPriority
				v15.Looped = false
			end
			table.insert(t2, {
				ActiveSound = nil,
				Entry = v,
				Rig = v12,
				Animator = v14,
				Track = v15,
				ActiveVFX = {}
			})
			v12.Parent = nil
		end
	end
	if #t2 == 0 then
		v1:Destroy()
	else
		local v16 = nil
		local v17 = nil
		local v18 = nil
		local v19 = nil
		local v20 = nil
		local function clearPromptArtifacts() --[[ clearPromptArtifacts | Line: 589 | Upvalues: v19 (ref), v18 (ref), v20 (ref) ]]
			if v19 then
				v19:Disconnect()
				v19 = nil
			end
			if v18 and v18.Parent then
				v18:Destroy()
			end
			v18 = nil
			if v20 and v20.Parent then
				v20:Destroy()
			end
			v20 = nil
		end
		local function clearCurrentRig() --[[ clearCurrentRig | Line: 606 | Upvalues: v17 (ref), v16 (ref), clearEmoteVFX (ref), RigObject (copy) ]]
			if v17 and v17.Parent then
				v17:Destroy()
			end
			v17 = nil
			if not v16 then
				v16 = nil
				RigObject.Value = nil
				return
			end
			local Track = v16.Track
			if Track then
				pcall(function() --[[ Line: 615 | Upvalues: Track (copy) ]]
					Track:AdjustSpeed(0)
				end)
			end
			clearEmoteVFX(v16)
			local v1 = v16
			local ActiveSound = v1.ActiveSound
			v1.ActiveSound = nil
			if ActiveSound and ActiveSound.Parent then
				ActiveSound:Destroy()
			end
			local Rig = v16.Rig
			if not Rig.Parent then
				v16 = nil
				RigObject.Value = nil
				return
			end
			Rig.Parent = nil
			v16 = nil
			RigObject.Value = nil
		end
		local function updateRigForEntry(p12) --[[ updateRigForEntry | Line: 633 | Upvalues: clearCurrentRig (copy), v16 (ref), RigObject (copy), v10 (copy), attachAndEmitEmoteVFX (ref), getOddsAdornee (ref), v9 (copy), v17 (ref), createEntryOddsBillboard (ref), v8 (copy), v19 (ref), v18 (ref), v20 (ref), createPurchasePrompt (ref), p1 (copy), v4 (copy), v6 (copy) ]]
			clearCurrentRig()
			local Rig = p12.Rig
			if not (Rig and p12.Animator) then
				return false
			end
			v16 = p12
			RigObject.Value = Rig
			Rig:PivotTo(v10)
			Rig.Parent = workspace
			p12.ActiveVFX = attachAndEmitEmoteVFX(Rig, p12.Entry.VFXStartDelay)
			local v1 = getOddsAdornee(Rig, v9)
			if v1 then
				v17 = createEntryOddsBillboard(Rig, p12.Entry, v1, v9, v8)
			end
			if v19 then
				v19:Disconnect()
				v19 = nil
			end
			if v18 and v18.Parent then
				v18:Destroy()
			end
			v18 = nil
			local v2, v3, v42
			if not (v20 and v20.Parent) then
				v20 = nil
				v2, v3, v42 = createPurchasePrompt(p1, Rig, v4, v6)
				v18 = v2
				v19 = v3
				v20 = v42
				return true
			end
			v20:Destroy()
			v20 = nil
			v2, v3, v42 = createPurchasePrompt(p1, Rig, v4, v6)
			v18 = v2
			v19 = v3
			v20 = v42
			return true
		end
		local v21 = true
		v1:Add(function() --[[ Line: 659 | Upvalues: v21 (ref) ]]
			v21 = false
		end)
		v1:Add(task.spawn(function() --[[ Line: 663 | Upvalues: v21 (ref), t2 (copy), updateRigForEntry (copy), loadTrack (ref), t (ref), playEmoteSoundOnRig (ref) ]]
			while v21 do
				for i, v in ipairs(t2) do
					if not v21 then
						break
					end
					if updateRigForEntry(v) then
						local Rig = v.Rig
						local Animator = v.Animator
						local Entry = v.Entry
						if Rig and Animator then
							local Track = v.Track
							if not Track then
								Track = loadTrack(Rig, Animator, Entry)
								v.Track = Track
							end
							local v1 = t[Rig]
							if Track then
								if v1 then
									for v2, v3 in v1 do
										v3:Stop(0.2)
									end
								end
								Track.Priority = Entry.AnimationPriority
								Track.Looped = false
								Track:Play(0.2, 1, Entry.PlaybackSpeed)
								local ActiveSound = v.ActiveSound
								v.ActiveSound = nil
								if ActiveSound and ActiveSound.Parent then
									ActiveSound:Destroy()
								end
								v.ActiveSound = playEmoteSoundOnRig(Rig, Entry.EmoteName)
								if Track.Length <= 0 then
									local sum = 0
									while v21 and (Track.Length <= 0 and sum < 1) do
										sum = sum + task.wait(0.05)
									end
								end
								local HoldDuration = Entry.HoldDuration
								if Track.Length > 0 then
									HoldDuration = math.max(HoldDuration, Track.Length / math.max(Entry.PlaybackSpeed, 0.05))
								end
								local sum = 0
								while v21 and (Track.IsPlaying and sum < HoldDuration + 0.2) do
									sum = sum + task.wait(0.05)
								end
								pcall(function() --[[ Line: 723 | Upvalues: Track (ref) ]]
									Track:AdjustSpeed(0)
								end)
								continue
							end
							task.wait(0.1)
							continue
						end
						task.wait(0.1)
						continue
					end
					task.wait(0.1)
				end
			end
		end))
		return function() --[[ Line: 730 | Upvalues: v21 (ref), v19 (ref), v18 (ref), v20 (ref), clearCurrentRig (copy), t2 (copy), clearEmoteVFX (ref), cleanupRigTracks (ref), v1 (copy) ]]
			v21 = false
			if v19 then
				v19:Disconnect()
				v19 = nil
			end
			if v18 and v18.Parent then
				v18:Destroy()
			end
			v18 = nil
			if v20 and v20.Parent then
				v20:Destroy()
			end
			v20 = nil
			clearCurrentRig()
			for i, v in ipairs(t2) do
				clearEmoteVFX(v)
				local ActiveSound = v.ActiveSound
				v.ActiveSound = nil
				if ActiveSound and ActiveSound.Parent then
					ActiveSound:Destroy()
				end
				cleanupRigTracks(v.Rig)
				if v.Rig.Parent then
					v.Rig:Destroy()
					continue
				end
				v.Rig:Destroy()
			end
			v1:Destroy()
		end
	end
end, { workspace })
return {}